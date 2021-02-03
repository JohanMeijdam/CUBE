<!--
var g_objNodeDiv;
var g_objMenuList;
var g_currentSpanIndex;
var g_currentParentId;
var g_currentObjIndex;
var g_currentChildIndex;
var g_currentRootId;
var g_currentObjId;
var g_currentObjType;
var g_currentNodeType;

function AddTreeviewChildren(p_json_rows, p_type, p_icon, p_name) {
	for (i in p_json_rows) {
		AddTreeviewNode(g_objNodeDiv, p_type, p_json_rows[i].Key, p_icon, p_name, p_json_rows[i].Display.toLowerCase(), 'N', ' ', null);
	}
}

function AddTreeviewNode(p_obj, p_type, p_json_id, p_icon, p_name, p_text, p_root, p_position, p_objPosition) {
	var l_objDiv = document.createElement('DIV');
	l_objDiv.style.paddingLeft = "12px";
	var l_objImg = document.createElement('IMG');
	var l_objSpan1 = document.createElement('SPAN');

	if (p_root == 'Y') {
		var l_index = 0;
	} else if (p_obj._parentId == 'NONE') {
		var l_index = 2; // Pos 1 is the icon
	} else {
		var l_index = DefineTypePosition (p_obj._type, p_type, 'L'); // Specifc function supplied by caller
	}
	switch (p_position) {
		case 'A':
			p_obj.childNodes[l_index].insertBefore(l_objDiv, p_objPosition.nextSibling);
			break;
		case 'B':
			p_obj.childNodes[l_index].insertBefore(l_objDiv, p_objPosition);
			break;
		case 'F':
			p_obj.childNodes[l_index].insertBefore(l_objDiv, p_obj.childNodes[l_index].childNodes[0]);
			break;
		default:
			p_obj.childNodes[l_index].appendChild(l_objDiv);
	}
	l_objDiv.appendChild(l_objImg);
	l_objDiv.appendChild(l_objSpan1);

	// Add a tray for each child type.
	if (p_root == 'Y') {
		var l_count = 1;
	} else {
		var l_count = DefineTypePosition (p_type, ' ', 'C'); // Specifc function supplied by caller
	}
	for (i = 2; i < l_count+2; i++) {
		var l_objSpan2 = document.createElement('SPAN')
		l_objSpan2._index = i;
		l_objDiv.appendChild(l_objSpan2);
	}
	l_objDiv._type = p_type;
	l_objDiv._name = p_name;
	l_objDiv.id = AssembleObjId (p_type, p_json_id);

	if (p_root == 'Y') {
		l_objDiv.style.paddingLeft = '0px';
		l_objDiv._parentId = 'NONE';
	} else {
		if (p_obj._type == p_type) {
			l_objDiv._rootId = p_obj._rootId;
		} else {
			l_objDiv._rootId = p_obj.id;
		}
		l_objDiv._index = l_index;
		l_objDiv._parentId = p_obj.id;
	}

	l_objImg.onmouseover = function(){OpenCloseMouseOver(this)};
	l_objImg.onmouseout = function(){OpenCloseMouseOut(this)};
	l_objImg.onclick = function(){OpenCloseOnClick(this)};
	l_objImg.src = 'icons/close.bmp';
	l_objImg._state = 'C';
	
	l_objSpan1.onmouseover=function(){Highlight(this)}; 
	l_objSpan1.onmouseout=function(){DeHighlight(this)};
	l_objSpan1.onclick=function(){OpenDetail(this)};
	l_objSpan1.oncontextmenu=function(){OpenMenu(this)};
	l_objSpan1.innerHTML = '<img style="border:1 solid transparent;" src="'+p_icon+'"/> '+p_text;
}

function CheckMenuItem (p_type, p_count) {
	var l_obj = g_objMenuList.childNodes
	for (i=0; i<l_obj.length; i++)
	{
		if (l_obj[i]._type == p_type && l_obj[i]._cardinality <= p_count) {
			g_objMenuList.removeChild(l_obj[i]);
		}
	}

}
function MoveNode (p_obj,  p_objPosition, p_moveAction) {
	switch (p_moveAction) {
	case 'A':
		p_objPosition.parentNode.insertBefore(p_obj, p_objPosition.nextSibling);
		break;
	case 'B':
		p_objPosition.parentNode.insertBefore(p_obj, p_objPosition);
		break;
	case 'F':
		alert ('FIRST not implemented');
		break;
	case 'L':
		if (p_objPosition.firstChild._state == 'O') {
			p_objPosition.appendChild(p_obj);
		} else {
			p_obj.parentNode.removeChild(p_obj);
		}
		break;
	}
	p_obj._parentId = p_objPosition._parentId;
}

function ChangeParent (p_obj, p_objParent, p_type, p_json_rows) {
	if (p_objParent.firstChild._state == 'O') {
		if (p_json_rows.length == 0) {
			p_objParent.childNodes[g_currentSpanIndex].appendChild(p_obj);
		} else {
			var l_objPosition = document.getElementById (AssembleObjId (p_type, p_json_rows[0].Key));
			p_objParent.childNodes[g_currentSpanIndex].insertBefore(p_obj, l_objPosition);
		}
	} else {
		p_obj.parentNode.removeChild(p_obj);
	}
}

function AssembleObjId (p_type, p_json_id) {
	return '{"'+p_type+'":'+JSON.stringify(p_json_id)+'}'
}

function IsInHierarchy (p_objRoot, p_obj) {
	var l_obj = p_obj;
	while (p_obj._rootId != l_obj.id) {
		if (l_obj.id == p_objRoot.id) {
			return true;
		}
		l_obj = l_obj.parentNode.parentNode;
	}
	return false;
}

function Highlight(p_obj) {
	p_obj.style.backgroundColor="#E0E0E0";
	if (g_xmlhttp.readyState == 1) {
		document.body.style.cursor = "wait";
		return;
	}
	switch (document.body._state) {
	case 'N':
		document.body.style.cursor = "pointer";
		break;
	case 'M':
		if ((g_currentParentId != p_obj.parentNode._parentId || g_currentObjIndex < p_obj.parentNode.parentNode._index) && g_currentParentId != p_obj.parentNode.id) {
			document.body.style.cursor = "url(icons/pointer-pos-nok.cur), default";	
		}
		break;
	case 'P':
		if ((g_currentRootId != p_obj.parentNode._rootId || g_currentObjType != p_obj.parentNode._type) && g_currentRootId != p_obj.parentNode.id || IsInHierarchy(g_objNodeDiv, p_obj.parentNode)) {
			document.body.style.cursor = "url(icons/pointer-par-nok.cur), default";
		}
		break;
	case 'A':
		if ((g_currentObjId != p_obj.parentNode._parentId || g_currentChildIndex < p_obj.parentNode.parentNode._index ) && g_currentObjId != p_obj.parentNode.id) {
			document.body.style.cursor = "url(icons/pointer-pos-nok.cur), default";	
		}
		break;
	}
}

function DeHighlight(p_obj) {
	p_obj.style.backgroundColor="#FFFFFF";
	if (g_xmlhttp.readyState == 1) {
		document.body.style.cursor = "wait";
		return;
	}
	switch (document.body._state) {
	case 'N':
		document.body.style.cursor = "default";
		break;
	case 'M':
		document.body.style.cursor = "url(icons/pointer-pos.cur), default";	
		break;
	case 'P':
		document.body.style.cursor = "url(icons/pointer-par.cur), default";	
		break;
	case 'A':
		document.body.style.cursor = "url(icons/pointer-pos.cur), default";	
		break;
	}
}

function CloseTreeviewNode(p_obj) {
	var l_length = p_obj.children.length;
	for (i = 2; i < l_length; i++) {
	    p_obj.childNodes[i].innerHTML = '';
	}
}

function OpenCloseMouseOver(p_obj) {
	if (document.body._state !== "N") return;
	if (p_obj._state == 'O') {
		p_obj.src='icons/open_h.bmp';
	} else {
		p_obj.src='icons/close_h.bmp';
	}
}

function OpenCloseMouseOut(p_obj) {
	if (document.body._state !== "N") return;
	if (p_obj._state == 'O') {
		p_obj.src='icons/open.bmp';
	} else {
		p_obj.src='icons/close.bmp';
	}
}

function OpenDescBox(p_icon,p_name,p_type,p_attribute_type,p_sequence) {

	CloseDescBox();

	var l_objDiv = document.createElement('DIV');
	var l_objTable = document.createElement('TABLE');
	var l_objImg = document.createElement('IMG');
	var l_objSpan = document.createElement('SPAN');
	var l_objImgExit = document.createElement('IMG');
	var l_objTextarea = document.createElement('TEXTAREA');

	document.body.appendChild(l_objDiv);

	l_objDiv.appendChild(l_objTable);
	l_objRow_0 = l_objTable.insertRow();
	l_objCell_0_0 = l_objRow_0.insertCell();
	l_objCell_0_1 = l_objRow_0.insertCell();
	l_objRow_1 = l_objTable.insertRow();
	l_objCell_1_0 = l_objRow_1.insertCell();
	l_objCell_0_0.appendChild(l_objImg);
	l_objCell_0_0.appendChild(l_objSpan);
	l_objCell_0_1.appendChild(l_objImgExit);
	l_objCell_1_0.appendChild(l_objTextarea);

	l_objDiv.id = 'DescBox';
	l_objDiv.style.position = 'absolute';
	l_objDiv.style.left = 100;
	l_objDiv.style.top = 100;
	l_objDiv.style.border = 'thin solid #7F7F7F';
	l_objDiv.style.boxShadow = '10px 10px 5px #888888';
	l_objDiv.draggable = 'true';
	l_objDiv.ondragstart = function(){StartMove(event)};
	l_objDiv.ondragend = function(){EndMove(event)};
	l_objImg.src = 'icons/' + p_icon + '.bmp';
	l_objSpan.innerHTML = '&nbsp;&nbsp;' + p_name;
	l_objCell_0_1.style.textAlign = 'right';
	l_objImgExit.style.cursor = 'pointer';
	l_objImgExit.src = 'icons/exit.bmp';
	l_objImgExit.onclick = function(){CloseDescBox()};
	l_objCell_1_0.colSpan = '2';
	l_objTextarea.readOnly = true;
	l_objTextarea.id = 'CubeDesc';
	l_objTextarea.rows = '5';
	l_objTextarea.cols = '80';
	l_objTextarea.style.whiteSpace = 'normal';
	l_objTextarea.maxLength = '3999';

	GetDescription(p_type,p_attribute_type,p_sequence);
}

function CloseDescBox() {
	l_obj = document.getElementById("DescBox");
	if (l_obj) { l_obj.parentNode.removeChild(l_obj);}
}

function GetDescription(p_type,p_attribute_type,p_sequence) {
	var l_requestText = JSON.stringify( {
		Service: "GetCubeDsc",
		Parameters: {
			Type: {
				TypeName: p_type,
				AttributeTypeName: p_attribute_type,
				Sequence: p_sequence
			}
		}
	} );
	g_xmlhttp.open('POST','CubeSysServer.php',true);
	g_xmlhttp.send(l_requestText);
}

function AddMenuItem(p_obj, p_text, p_icon, p_code, p_nodeType, p_type, p_name, p_cardinality, p_flagPosition, p_childIndex) {

	var l_objDiv = document.createElement('DIV');
	var l_objSpan = document.createElement('SPAN');
	var l_objImg = document.createElement('IMG');
	
	p_obj.appendChild(l_objDiv);
	l_objDiv.appendChild(l_objSpan);
	l_objDiv.appendChild(l_objImg);

	l_objDiv.style.paddingLeft = '0px';
	l_objDiv.style.cursor = 'pointer';
	l_objDiv._code = p_code;
	l_objDiv._nodeType = p_nodeType;
	l_objDiv._type = p_type;
	l_objDiv._name = p_name;
	l_objDiv._cardinality = p_cardinality;
	l_objDiv._flagPosition = p_flagPosition;
	l_objDiv._childIndex = p_childIndex;
	l_objDiv.onclick = function(){OpenMenuItem(this)};

	l_objSpan.innerHTML = '&nbsp;'+p_text+'&nbsp;&nbsp;';
	l_objSpan.onmouseover = function(){Highlight(this)};
	l_objSpan.onmouseout = function(){DeHighlight(this)};

	l_objImg.src = p_icon;
	l_objImg.style.border = '1';
}

function OpenMenuItem(p_obj) {
	CloseMenu();
	switch (p_obj._code) {
	case 'CubeMove':
		document.body.style.cursor = "url(icons/pointer-pos.cur), default";
		document.body._state = "M";
		break;
	case 'CubeChangePar':
		document.body.style.cursor = "url(icons/pointer-par.cur), default";
		document.body._state = "P";
		document.body._menuItemType = p_obj._type;
		document.body._flagPosition = p_obj._flagPosition;
		break;
	case 'CubeAdd':
		if (g_objNodeDiv.firstChild._state == 'C') {
			OpenDetailPage(p_obj._name, p_obj._nodeType, g_currentObjId, '{"Code":"L"}');
		} else if (g_objNodeDiv.children[p_obj._childIndex].children.length == 0) {
			OpenDetailPage(p_obj._name, p_obj._nodeType, g_currentObjId, '{"Code":"F"}');
		} else {
			document.body.style.cursor = "url(icons/pointer-pos.cur), default";
			document.body._state = "A";
			g_currentChildIndex = p_obj._childIndex;
			g_currentNodeType = p_obj._nodeType;
			g_currentObjType = p_obj._type;
			g_currentObjName = p_obj._name;
		}
		break;
	default:
		OpenDetailPage(p_obj._name, p_obj._nodeType, g_currentObjId, null);
	}
}

function CloseMenu() {
	l_obj = document.getElementById("Menu");
	if (l_obj) {l_obj.parentNode.removeChild(l_obj)};
}

function ResetState() {
	document.body._state="N";
	if (g_xmlhttp.readyState == 1) {
		document.body.style.cursor = "wait";
		return;
	}
	document.body.style.cursor="default";
}

function StartMove(p_event) {
	var l_obj = p_event.target;
	l_obj._x = p_event.screenX - parseInt(l_obj.style.left);
	l_obj._y = p_event.screenY - parseInt(l_obj.style.top);
	document.body._FlagDragging = 1;
	document.body._DraggingId = l_obj.id;
}

function EndMove(p_event) {
 	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
}

function allowDrop(p_event) {
	if (document.body._FlagDragging) {
		p_event.preventDefault();
	}
}

function drop(p_event) {
	if (document.body._FlagDragging) {
		var l_obj = document.getElementById(document.body._DraggingId);
		var l_x = p_event.screenX - l_obj._x;
		var l_y = p_event.screenY - l_obj._y;	
		l_obj.style.left = l_x + 'px';
		l_obj.style.top = l_y + 'px';
	}
}

-->
