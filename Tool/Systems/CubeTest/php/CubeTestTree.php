<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<style type="text/css">
<!--
div {padding-left:12px}
-->
</style>
<script language='javascript' type='text/javascript'>
<!--
var g_objMenuList;
var g_objNodeDiv;
var g_currentSpanIndex;
var g_currentObjIndex;
var g_currentChildIndex;
var g_currentParentId;
var g_currentRootId;
var g_currentObjId;
var g_currentObjType;
var g_currentNodeType;

var g_xmlhttp = new XMLHttpRequest();
g_xmlhttp.onreadystatechange = function() {
	if(g_xmlhttp.readyState == 4) {
		if(g_xmlhttp.status == 200) {
			document.body.style.cursor = "default";
			var g_responseText = g_xmlhttp.responseText;
			try {
				var l_json_array = JSON.parse(g_responseText);
			}
			catch (err) {
				alert ('JSON parse error:\n'+g_responseText);
			}
			for (i in l_json_array) {
				switch (l_json_array[i].ResultName) {
					case '': break;
					case 'LIST_AAA': AddTreeviewChildren(l_json_array[i].Rows,'TYP_AAA','icons/produkt.bmp'); break;
					case 'CHANGE_PARENT_AAA': ChangeParent (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId),'TYP_AAA',l_json_array[i].Rows); break;
					case 'LIST_AAD': AddTreeviewChildren(l_json_array[i].Rows,'TYP_AAD','icons/attrib.bmp'); break;
					case 'MOVE_AAD': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_BBB': AddTreeviewChildren(l_json_array[i].Rows,'TYP_BBB','icons/part.bmp'); break;
					case 'LIST_CCC': AddTreeviewChildren(l_json_array[i].Rows,'TYP_CCC','icons/produkt.bmp'); break;
					case 'COUNT_CCC': CheckMenuItem('TYP_CCC',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'MOVE_CCC': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_PRD': AddTreeviewChildren(l_json_array[i].Rows,'TYP_PRD','icons/produkt.bmp'); break;
					case 'LIST_PR2': AddTreeviewChildren(l_json_array[i].Rows,'TYP_PR2','icons/produkt.bmp'); break;
					case 'LIST_PA2': AddTreeviewChildren(l_json_array[i].Rows,'TYP_PA2','icons/part.bmp'); break;
					case 'CHANGE_PARENT_PA2': ChangeParent (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId),'TYP_PA2',l_json_array[i].Rows); break;
					case 'LIST_PRT': AddTreeviewChildren(l_json_array[i].Rows,'TYP_PRT','icons/part.bmp'); break;
					case 'CHANGE_PARENT_PRT': ChangeParent (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId),'TYP_PRT',l_json_array[i].Rows); break;
					case "ERROR": alert ('Server error:\n'+l_json_array[i].ErrorText); break;
					default: alert ('Unknown reply:\n'+g_responseText);
				}
			}
		} else {
			alert ('Request error:\n'+g_xmlhttp.statusText);
		}
		
	}
}
	
function AddTreeviewChildren(p_json_rows, p_type, p_icon) {
	for (i in p_json_rows) {
		AddTreeviewNode(g_objNodeDiv, p_type, p_json_rows[i].Key, p_icon, p_json_rows[i].Display.toLowerCase(), 'N', ' ', null);
	}
}

function InitBody() {
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	ResetState();
	l_objBody = document.body;
	l_objBody._type = 'ROOT';
	l_objBody.childNodes[0]._index = 0;
	AddTreeviewNode(l_objBody, 'DIR_AAA', null, 'icons/folder.bmp', 'Test_AAA', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_BBB', null, 'icons/folder.bmp', 'Test_BBB', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_CCC', null, 'icons/folder.bmp', 'Test_CCC', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_PRD', null, 'icons/folder.bmp', 'Producten', 'Y', ' ', null);
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

function PerformTrans(p_objParm) {
	var l_requestText = JSON.stringify(p_objParm);
	g_xmlhttp.open('POST','CubeTestServer.php',true);
//	g_xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	g_xmlhttp.send(l_requestText);
}

function DefineTypePosition (p_parentType, p_type, p_switch) {
	var l_index = 0;
	switch (p_parentType) {
	case 'TYP_AAA':
		switch (p_type) { case 'TYP_AAD': l_index = 2; break;case 'TYP_AAA': l_index = 3; break;}
		var l_count = 2; break;
	case 'TYP_CCC':
		switch (p_type) {case 'TYP_CCC': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_PRD':
		switch (p_type) { case 'TYP_PR2': l_index = 2; break; case 'TYP_PRT': l_index = 3; break;}
		var l_count = 2; break;
	case 'TYP_PR2':
		switch (p_type) { case 'TYP_PA2': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_PA2':
		switch (p_type) {case 'TYP_PA2': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_PRT':
		switch (p_type) {case 'TYP_PRT': l_index = 2; break;}
		var l_count = 1; break;
	default: var l_count = 0;
	}
	if (p_switch == 'C') {
		return l_count;
	} else {
		return l_index;
	}
}

function AddTreeviewNode(p_obj, p_type, p_json_id, p_icon, p_text, p_root, p_position, p_objPosition) {
	var l_objDiv = document.createElement('DIV');
	var l_objImg = document.createElement('IMG');
	var l_objSpan1 = document.createElement('SPAN');

	if (p_root == 'Y') {
		var l_index = 0;
	} else if (p_obj._parentId == 'NONE') {
		var l_index = 2; // Pos 1 is the icon
	} else {
		var l_index = DefineTypePosition (p_obj._type, p_type, 'L');
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
		var l_count = DefineTypePosition (p_type, ' ', 'C');
	}
	for (i = 2; i < l_count+2; i++) {
		var l_objSpan2 = document.createElement('SPAN')
		l_objSpan2._index = i;
		l_objDiv.appendChild(l_objSpan2);
	}
	l_objDiv._type = p_type;
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
	var l_comma = '';
	var l_id = '{"'+p_type+'":[';
	for (x in p_json_id) {
		l_id += l_comma+JSON.stringify(p_json_id[x]);
		l_comma = ',';
	}
	return l_id+']}';
}

function IsInHierarchy (p_objRoot, p_obj) {
	var g_obj = p_obj;
	while (p_obj._rootId != g_obj.id) {
		if (g_obj.id == p_objRoot.id) {
			return true;
		}
		g_obj = g_obj.parentNode.parentNode;
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

function OpenCloseOnClick(p_obj) {
	if (document.body._state !== "N") return;
	if (g_xmlhttp.readyState == 1) {
		document.body.style.cursor = "wait";
		return;
	}
	ResetState();
	CloseMenu();
	g_objNodeDiv = p_obj.parentNode;
	if (p_obj._state == 'O') {
		p_obj._state = 'C';
		p_obj.src = 'icons/close_h.bmp';
		CloseTreeviewNode(g_objNodeDiv);
	} else {
		p_obj._state = 'O';
		p_obj.src = 'icons/open_h.bmp';

		switch (p_obj.parentNode._type) {
 		case 'DIR_AAA':
			PerformTrans( {Service:"GetDirAaaItems"} );
			break;
 		case 'TYP_AAA':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_AAA"];
			PerformTrans( {Service:"GetAaaItems",Parameters:{Type:{Naam:l_json_id[0]}}} );
			break;
 		case 'DIR_BBB':
			PerformTrans( {Service:"GetDirBbbItems"} );
			break;
 		case 'DIR_CCC':
			PerformTrans( {Service:"GetDirCccItems"} );
			break;
 		case 'TYP_CCC':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_CCC"];
			PerformTrans( {Service:"GetCccItems",Parameters:{Type:{Code:l_json_id[0],Naam:l_json_id[1]}}} );
			break;
 		case 'DIR_PRD':
			PerformTrans( {Service:"GetDirPrdItems"} );
			break;
 		case 'TYP_PRD':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_PRD"];
			PerformTrans( {Service:"GetPrdItems",Parameters:{Type:{Code:l_json_id[0],Naam:l_json_id[1]}}} );
			break;
 		case 'TYP_PR2':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_PR2"];
			PerformTrans( {Service:"GetPr2Items",Parameters:{Type:{FkPrdCode:l_json_id[0],FkPrdNaam:l_json_id[1],Code:l_json_id[2],Naam:l_json_id[3]}}} );
			break;
 		case 'TYP_PA2':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_PA2"];
			PerformTrans( {Service:"GetPa2Items",Parameters:{Type:{FkPrdCode:l_json_id[0],FkPrdNaam:l_json_id[1],FkPr2Code:l_json_id[2],FkPr2Naam:l_json_id[3],Code:l_json_id[4],Naam:l_json_id[5]}}} );
			break;
 		case 'TYP_PRT':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_PRT"];
			PerformTrans( {Service:"GetPrtItems",Parameters:{Type:{FkPrdCode:l_json_id[0],FkPrdNaam:l_json_id[1],Code:l_json_id[2],Naam:l_json_id[3]}}} );
			break;
		} 
	}
}

function OpenDetail(p_obj) {
	if (g_xmlhttp.readyState == 1) {
		document.body.style.cursor = "wait";
		return;
	}
	CloseMenu();

	switch (document.body._state) {
	case 'N':
		ResetState();
		if (p_obj.parentNode._type.substr(0,4) == 'TYP_') {
			OpenDetailPage(p_obj.parentNode._type.substr(4), 'D', p_obj.parentNode.id, '');
		}
		break;
	case 'M':
		if (g_currentParentId == p_obj.parentNode._parentId && g_currentObjIndex >= p_obj.parentNode.parentNode._index || g_currentParentId == p_obj.parentNode.id) {
			if (g_currentParentId == p_obj.parentNode.id) {
				document.body._moveAction = "B";
				var l_obj = p_obj.parentNode.children[g_currentSpanIndex].children[0];
			} else if (p_obj.parentNode._type != g_currentObjType) {
				document.body._moveAction = "B";
				var l_obj = p_obj.parentNode.parentNode.parentNode.children[g_currentSpanIndex].children[0];
			} else {
				document.body._moveAction = "A";
				var l_obj = p_obj.parentNode;
			}
			document.body._objNodePosId = l_obj.id;
			ResetState();
			var l_json_id = JSON.parse(g_currentObjId)[l_obj._type];
			var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
			switch (l_obj._type) {
			case 'TYP_AAD':
				PerformTrans( {Service:"MoveAad",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:{FkAaaNaam:l_json_id[0],Naam:l_json_id[1]},Ref:{FkAaaNaam:l_json_id_ref[0],Naam:l_json_id_ref[1]}}} );
				break;
			case 'TYP_CCC':
				PerformTrans( {Service:"MoveCcc",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:{Code:l_json_id[0],Naam:l_json_id[1]},Ref:{Code:l_json_id_ref[0],Naam:l_json_id_ref[1]}}} );
				break;
			}
		}
		break;
	case 'P':
		if ((g_currentRootId == p_obj.parentNode._rootId && g_currentObjType == p_obj.parentNode._type || g_currentRootId == p_obj.parentNode.id) && !IsInHierarchy(g_objNodeDiv, p_obj.parentNode) ) {
			if (g_currentRootId == p_obj.parentNode.id) {
				g_currentSpanIndex = 2;
			} else {
				g_currentSpanIndex = g_currentObjIndex;
			}
			if (document.body._flagPosition == 'Y' && p_obj.parentNode.children[g_currentSpanIndex].children.length > 0) {
				document.body.style.cursor = "url(icons/pointer-pos.cur), default";
				document.body._state = "M";
				g_currentParentId = p_obj.parentNode.id;
			} else {
				var l_obj = p_obj.parentNode;
				document.body._moveAction = "L";
				document.body._objNodePosId = l_obj.id;
				ResetState();
				var l_json_id = JSON.parse(g_currentObjId)[g_currentObjType];
				switch (l_obj._type) {
				case 'DIR_AAA':
					PerformTrans( {Service:"ChangeParentAaa",Parameters:{Option:{CubeFlagRoot:"Y"},Type:{Naam:l_json_id[0]}}} );
					break;
				case 'TYP_AAA':
					var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
					PerformTrans( {Service:"ChangeParentAaa",Parameters:{Option:{CubeFlagRoot:"N"},Type:{Naam:l_json_id[0]},Ref:{Naam:l_json_id_ref[0]}}} );
					break;
				case 'TYP_CCC':
					var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
					PerformTrans( {Service:"MoveCcc",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:{Code:l_json_id[0],Naam:l_json_id[1]},Ref:{Code:l_json_id_ref[0],Naam:l_json_id_ref[1]}}} );
					break;
				case 'TYP_PRD':
					var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
					if (document.body._menuItemType == 'CUBE_P_PRT') {
						PerformTrans( {Service:"ChangeParentPrt",Parameters:{Option:{CubeFlagRoot:"Y"},Type:{FkPrdCode:l_json_id[0],FkPrdNaam:l_json_id[1],Code:l_json_id[2],Naam:l_json_id[3]}}} );			
						break;
					}
					PerformTrans( {Service:"ChangeParentPrd",Parameters:{Option:{CubeFlagRoot:"N"},Type:{Code:l_json_id[0],Naam:l_json_id[1]},Ref:{Code:l_json_id_ref[0],Naam:l_json_id_ref[1]}}} );
					break;
				case 'TYP_PR2':
					var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
					if (document.body._menuItemType == 'CUBE_P_PA2') {
						PerformTrans( {Service:"ChangeParentPa2",Parameters:{Option:{CubeFlagRoot:"Y"},Type:{FkPrdCode:l_json_id[0],FkPrdNaam:l_json_id[1],FkPr2Code:l_json_id[2],FkPr2Naam:l_json_id[3],Code:l_json_id[4],Naam:l_json_id[5]}}} );			
						break;
					}
					PerformTrans( {Service:"ChangeParentPr2",Parameters:{Option:{CubeFlagRoot:"N"},Type:{FkPrdCode:l_json_id[0],FkPrdNaam:l_json_id[1],Code:l_json_id[2],Naam:l_json_id[3]},Ref:{FkPrdCode:l_json_id_ref[0],FkPrdNaam:l_json_id_ref[1],Code:l_json_id_ref[2],Naam:l_json_id_ref[3]}}} );
					break;
				case 'TYP_PA2':
					var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
					PerformTrans( {Service:"ChangeParentPa2",Parameters:{Option:{CubeFlagRoot:"N"},Type:{FkPrdCode:l_json_id[0],FkPrdNaam:l_json_id[1],FkPr2Code:l_json_id[2],FkPr2Naam:l_json_id[3],Code:l_json_id[4],Naam:l_json_id[5]},Ref:{FkPrdCode:l_json_id_ref[0],FkPrdNaam:l_json_id_ref[1],FkPr2Code:l_json_id_ref[2],FkPr2Naam:l_json_id_ref[3],Code:l_json_id_ref[4],Naam:l_json_id_ref[5]}}} );
					break;
				case 'TYP_PRT':
					var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
					PerformTrans( {Service:"ChangeParentPrt",Parameters:{Option:{CubeFlagRoot:"N"},Type:{FkPrdCode:l_json_id[0],FkPrdNaam:l_json_id[1],Code:l_json_id[2],Naam:l_json_id[3]},Ref:{FkPrdCode:l_json_id_ref[0],FkPrdNaam:l_json_id_ref[1],Code:l_json_id_ref[2],Naam:l_json_id_ref[3]}}} );
					break;
				}
			}
		}
		break;
	case 'A':
		if (g_currentObjId == p_obj.parentNode._parentId && g_currentChildIndex >= p_obj.parentNode.parentNode._index || g_currentObjId == p_obj.parentNode.id) {
			if (g_currentObjId == p_obj.parentNode._parentId && g_currentChildIndex == p_obj.parentNode.parentNode._index) {
				var l_option = 'A<||>' + p_obj.parentNode.id.split("<||>")[1];
			} else {
				var l_option = 'B<||>' + g_objNodeDiv.children[g_currentChildIndex].firstChild.id.split("<||>")[1];
			}
			ResetState();
			OpenDetailPage(g_currentObjType.substr(4), g_currentNodeType, g_currentObjId, l_option);
		}
		break;
	}
}

function OpenDetailPage (p_code, p_nodeType, p_objId, p_options) {
	parent.DETAIL.location.replace('CubeTestDetail'+p_code+'.php?'+encodeURIComponent('<|||>'+p_nodeType+'<|||>'+p_objId+'<|||>'+p_options));
}

function OpenMenu(p_obj) {
	if (g_xmlhttp.readyState == 1) {
		document.body.style.cursor = "wait";
		return;
	}
	ResetState(); 
	CloseMenu();
	var l_childCount = p_obj.parentNode.parentNode.children.length;
	var l_json_node_id = JSON.parse(p_obj.parentNode.id);
	var l_type_id = Object.keys(l_json_node_id)[0];
	p_obj.style.backgroundColor = "#FFFFFF";
	var l_x = event.clientX-20;
	var l_y = event.clientY-20+document.body.scrollTop;

	var l_objDiv = document.createElement('DIV');
	var l_objTable = document.createElement('TABLE');
	var l_objImg = document.createElement('IMG');
	var l_objSpan = document.createElement('SPAN');
	var l_objImgExit = document.createElement('IMG');

	g_objNodeDiv = p_obj.parentNode;
	g_currentObjId = g_objNodeDiv.id;
	g_currentObjType = g_objNodeDiv._type;
	g_currentSpanIndex = g_objNodeDiv.parentNode._index;
	g_currentObjIndex = g_objNodeDiv._index;
	g_currentParentId = g_objNodeDiv._parentId;
	g_currentRootId = g_objNodeDiv._rootId;
	document.body.appendChild(l_objDiv);

	l_objDiv.appendChild(l_objTable);
	l_objRow_0 = l_objTable.insertRow();
	l_objCell_0_0 = l_objRow_0.insertCell();
	l_objCell_0_1 = l_objRow_0.insertCell();
	l_objRow_1 = l_objTable.insertRow();
	g_objMenuList = l_objRow_1.insertCell();
	l_objCell_0_0.appendChild(l_objImg);
	l_objCell_0_0.appendChild(l_objSpan);
	l_objCell_0_1.appendChild(l_objImgExit);
	
	l_objDiv.id = 'Menu';
	l_objDiv.style.paddingLeft = '0px';
	l_objDiv.style.position = 'absolute';
	l_objDiv.style.left = l_x+'px';
	l_objDiv.style.top = l_y+'px';
	l_objDiv.style.border = 'thin solid #7F7F7F';
	l_objDiv.style.boxShadow = '10px 10px 5px #888888';
	l_objDiv.draggable = 'true';
	l_objDiv.ondragstart = function(){StartMove(event)};
	l_objDiv.ondragend = function(){EndMove(event)};

	l_objImg.src = p_obj.childNodes[0].src;
	l_objImg.style.border = '2 solid transparent';
	l_objSpan.innerHTML = '&nbsp;&nbsp;'+p_obj.childNodes[1].nodeValue;
	l_objCell_0_1.style.textAlign = 'right';
	l_objImgExit.style.cursor = 'pointer';
	l_objImgExit.src = 'icons/exit.bmp';
	l_objImgExit.onclick = function(){CloseMenu()};
	g_objMenuList.colSpan = '2';

	switch (l_type_id) {
 	case 'DIR_AAA':
		AddMenuItem(g_objMenuList, 'add aaa', 'icons/produkt.bmp','DetailAAA','N','TYP_AAA',0,'N',2);
		break;
 	case 'TYP_AAA':
		var l_json_parent_node_id = JSON.parse(p_obj.parentNode.parentNode.parentNode.id);
		var l_parent_type_id = Object.keys(l_json_parent_node_id)[0];
		if (l_childCount > 1 || l_type_id == l_parent_type_id) {
			AddMenuItem(g_objMenuList, 'change parent', 'icons/cube_change_par.bmp','CubeChangePar','','CUBE_P_AAA',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add aaa_deel', 'icons/attrib.bmp','CubeAdd','N','TYP_AAD',0,'N',2);
		AddMenuItem(g_objMenuList, 'add aaa', 'icons/produkt.bmp','DetailAAA','R','TYP_AAA',0,'N',3);
		break;
 	case 'TYP_AAD':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_AAD',0,'N',0);
		}
		break;
 	case 'DIR_BBB':
		AddMenuItem(g_objMenuList, 'add bbb', 'icons/part.bmp','DetailBBB','N','TYP_BBB',0,'N',2);
		break;
 	case 'DIR_CCC':
		AddMenuItem(g_objMenuList, 'add ccc', 'icons/produkt.bmp','CubeAdd','N','TYP_CCC',2,'N',2);
		PerformTrans( {Service:"CountCcc"} );
		break;
 	case 'TYP_CCC':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_CCC',0,'N',0);
		}
		var l_json_parent_node_id = JSON.parse(p_obj.parentNode.parentNode.parentNode.id);
		var l_parent_type_id = Object.keys(l_json_parent_node_id)[0];
		if (l_childCount > 1 || l_type_id == l_parent_type_id) {
			AddMenuItem(g_objMenuList, 'change parent', 'icons/cube_change_par.bmp','CubeChangePar','','CUBE_P_CCC',0,'Y',0);
		}
		AddMenuItem(g_objMenuList, 'add ccc', 'icons/produkt.bmp','CubeAdd','R','TYP_CCC',3,'N',2);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans( {Service:"CountCccRestrictedItems",Parameters:{Type:{Code:l_json_id[0],Naam:l_json_id[1]}}} );
		break;
 	case 'DIR_PRD':
		AddMenuItem(g_objMenuList, 'add prod', 'icons/produkt.bmp','DetailPRD','N','TYP_PRD',0,'N',2);
		break;
 	case 'TYP_PRD':
		AddMenuItem(g_objMenuList, 'add prod2', 'icons/produkt.bmp','DetailPR2','N','TYP_PR2',0,'N',2);
		AddMenuItem(g_objMenuList, 'add part', 'icons/part.bmp','DetailPRT','N','TYP_PRT',0,'N',3);
		break;
 	case 'TYP_PR2':
		AddMenuItem(g_objMenuList, 'add part2', 'icons/part.bmp','DetailPA2','N','TYP_PA2',0,'N',2);
		break;
 	case 'TYP_PA2':
		AddMenuItem(g_objMenuList, 'add part2', 'icons/part.bmp','DetailPA2','R','TYP_PA2',0,'N',2);
		break;
 	case 'TYP_PRT':
		AddMenuItem(g_objMenuList, 'add part', 'icons/part.bmp','DetailPRT','R','TYP_PRT',0,'N',2);
		break;
	}
}

function AddMenuItem(p_obj, p_text, p_icon, p_code, p_nodeType, p_type, p_cardinality, p_flagPosition, p_childIndex) {

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
			OpenDetailPage(p_obj._type.substr(4), p_obj._nodeType, g_currentObjId, 'L');
		} else if (g_objNodeDiv.children[p_obj._childIndex].children.length == 0) {
			OpenDetailPage(p_obj._type.substr(4), p_obj._nodeType, g_currentObjId, 'F');
		} else {
			document.body.style.cursor = "url(icons/pointer-pos.cur), default";
			document.body._state = "A";
			g_currentChildIndex = p_obj._childIndex;
			g_currentNodeType = p_obj._nodeType;
			g_currentObjType = p_obj._type;
		}
		break;
	default:
		OpenDetailPage(p_obj._type.substr(4), p_obj._nodeType, g_currentObjId, '');
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
</script>
</head>
<body oncontextmenu="ResetState(); return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)"><span/>
</body>
</html>
