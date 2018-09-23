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
g_xmlhttp = new XMLHttpRequest();
g_xmlhttp.onreadystatechange = function(){
	if(g_xmlhttp.readyState == 4){
		var l_groups = g_xmlhttp.responseText.split("<||||>");
		for (ig in l_groups) {
			var l_rows = l_groups[ig].split("<|||>");
			switch (l_rows[0]) {
			case '': break;
			case 'LIST_AAA': AddTreeviewChildren(l_rows,'TYP_AAA','icons/produkt.bmp'); break;
			case 'CHANGE_PARENT_AAA': ChangeParent (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.getElementById('TYP_AAA<||>'+l_rows[1])); break;
			case 'LIST_AAD': AddTreeviewChildren(l_rows,'TYP_AAD','icons/attrib.bmp'); break;
			case 'MOVE_AAD': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
			case 'LIST_BBB': AddTreeviewChildren(l_rows,'TYP_BBB','icons/part.bmp'); break;
			case 'LIST_CCC': AddTreeviewChildren(l_rows,'TYP_CCC','icons/produkt.bmp'); break;
			case 'COUNT_CCC': CheckMenuItem('TYP_CCC',l_rows[1]); break;
			case 'MOVE_CCC': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
			case 'LIST_PRD': AddTreeviewChildren(l_rows,'TYP_PRD','icons/produkt.bmp'); break;
			case 'LIST_PR2': AddTreeviewChildren(l_rows,'TYP_PR2','icons/produkt.bmp'); break;
			case 'LIST_PA2': AddTreeviewChildren(l_rows,'TYP_PA2','icons/part.bmp'); break;
			case 'CHANGE_PARENT_PA2': ChangeParent (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.getElementById('TYP_PA2<||>'+l_rows[1])); break;
			case 'LIST_PRT': AddTreeviewChildren(l_rows,'TYP_PRT','icons/part.bmp'); break;
			case 'CHANGE_PARENT_PRT': ChangeParent (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.getElementById('TYP_PRT<||>'+l_rows[1])); break;
			case "ERROR": alert ('Error: '+l_rows[1]); break;
			default: alert ('Unknown reply: '+l_rows[0]);
			}
		}
	}
}

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

function AddTreeviewChildren(p_rows, p_type, p_icon) {
	var l_len = p_rows.length;
	for (var ir=1; ir<l_len; ir++){
		var l_rowpart = p_rows[ir].split("<||>");
		var l_lenp = l_rowpart.length;
		if (l_lenp > 1) {
			AddTreeviewNode(g_objNodeDiv, p_type, p_type+'<||>'+l_rowpart[0], p_icon, l_rowpart[1].toLowerCase(), 'N', ' ', null);
		}
	}
}

function InitBody() {
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	ResetState();
	l_objBody = document.body;
	l_objBody._type = 'ROOT';
	l_objBody.childNodes[0]._index = 0;
	AddTreeviewNode(l_objBody, 'DIR_AAA', 'DIR_AAA', 'icons/folder.bmp', 'Test_AAA', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_BBB', 'DIR_BBB', 'icons/folder.bmp', 'Test_BBB', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_CCC', 'DIR_CCC', 'icons/folder.bmp', 'Test_CCC', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_PRD', 'DIR_PRD', 'icons/folder.bmp', 'Producten', 'Y', ' ', null);
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

function PerformTrans(p_message) {
	g_xmlhttp.open('POST','CubeTestServer.php',true);
	g_xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	g_xmlhttp.send(p_message);
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

function AddTreeviewNode(p_obj, p_type, p_ident, p_icon, p_text, p_root, p_position, p_objPosition) {
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

	l_objDiv.id = p_ident;
	l_objDiv._type = p_type;

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

function ChangeParent (p_obj, p_objParent, p_objPosition) {
	if (p_objParent.firstChild._state == 'O') {
		p_objParent.childNodes[g_currentSpanIndex].insertBefore(p_obj, p_objPosition);
	} else {
		p_obj.parentNode.removeChild(p_obj);
	}
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
	switch (document.body._state) {
	case 'N':
		document.body.style.cursor="pointer";
		break;
	case 'M':
		if ((g_currentParentId != p_obj.parentNode._parentId || g_currentObjIndex < p_obj.parentNode.parentNode._index) && g_currentParentId != p_obj.parentNode.id) {
			document.body.style.cursor="url(icons/pointer-pos-nok.cur), default";	
		}
		break;
	case 'P':
		if ((g_currentRootId != p_obj.parentNode._rootId || g_currentObjType != p_obj.parentNode._type) && g_currentRootId != p_obj.parentNode.id || IsInHierarchy(g_objNodeDiv, p_obj.parentNode)) {
			document.body.style.cursor="url(icons/pointer-par-nok.cur), default";
		}
		break;
	case 'A':
		if ((g_currentObjId != p_obj.parentNode._parentId || g_currentChildIndex < p_obj.parentNode.parentNode._index ) && g_currentObjId != p_obj.parentNode.id) {
			document.body.style.cursor="url(icons/pointer-pos-nok.cur), default";	
		}
		break;
	}
}

function DeHighlight(p_obj) {
	p_obj.style.backgroundColor="#FFFFFF";
	switch (document.body._state) {
	case 'N':
		document.body.style.cursor="default";
		break;
	case 'M':
		document.body.style.cursor="url(icons/pointer-pos.cur), default";	
		break;
	case 'P':
		document.body.style.cursor="url(icons/pointer-par.cur), default";	
		break;
	case 'A':
		document.body.style.cursor="url(icons/pointer-pos.cur), default";	
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
			PerformTrans('GetDirAaaItems');
			break;
 		case 'TYP_AAA':
			PerformTrans('GetAaaItems'+'<|||>'+p_obj.parentNode.id.split("<||>")[1]);
			break;
 		case 'DIR_BBB':
			PerformTrans('GetDirBbbItems');
			break;
 		case 'DIR_CCC':
			PerformTrans('GetDirCccItems');
			break;
 		case 'TYP_CCC':
			PerformTrans('GetCccItems'+'<|||>'+p_obj.parentNode.id.split("<||>")[1]);
			break;
 		case 'DIR_PRD':
			PerformTrans('GetDirPrdItems');
			break;
 		case 'TYP_PRD':
			PerformTrans('GetPrdItems'+'<|||>'+p_obj.parentNode.id.split("<||>")[1]);
			break;
 		case 'TYP_PR2':
			PerformTrans('GetPr2Items'+'<|||>'+p_obj.parentNode.id.split("<||>")[1]);
			break;
 		case 'TYP_PA2':
			PerformTrans('GetPa2Items'+'<|||>'+p_obj.parentNode.id.split("<||>")[1]);
			break;
 		case 'TYP_PRT':
			PerformTrans('GetPrtItems'+'<|||>'+p_obj.parentNode.id.split("<||>")[1]);
			break;
		} 
	}
}

function OpenDetail(p_obj) {
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
			switch (l_obj._type) {
			case 'TYP_AAD':
				PerformTrans('MoveAad'+'<|||>'+document.body._moveAction+'<|>'+g_currentObjId.split("<||>")[1]+'<|>'+document.body._objNodePosId.split("<||>")[1]);
				break;
			case 'TYP_CCC':
				PerformTrans('MoveCcc'+'<|||>'+document.body._moveAction+'<|>'+g_currentObjId.split("<||>")[1]+'<|>'+document.body._objNodePosId.split("<||>")[1]);
				break;
			}
		}
		break;
	case 'P':
		if ((g_currentRootId == p_obj.parentNode._rootId && g_currentObjType == p_obj.parentNode._type || g_currentRootId == p_obj.parentNode.id) && !IsInHierarchy(g_objNodeDiv, p_obj.parentNode) ) {
			if (g_currentRootId == p_obj.parentNode.id) {
				g_currentSpanIndex = g_currentObjIndex;
			} else {
				g_currentSpanIndex = 2;
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
				switch (l_obj._type) {
				case 'DIR_AAA':
					PerformTrans('ChangeParentAaa'+'<|||>Y<|>'+g_currentObjId.split("<||>")[1]+'<|>');
					break;
				case 'TYP_AAA':
					PerformTrans('ChangeParentAaa'+'<|||>N<|>'+g_currentObjId.split("<||>")[1]+'<|>'+l_obj.id.split("<||>")[1]);
					break;
				case 'TYP_CCC':
					PerformTrans('MoveCcc'+'<|||>'+document.body._moveAction+'<|>'+g_currentObjId.split("<||>")[1]+'<|>'+l_obj.id.split("<||>")[1]);
					break;
				case 'TYP_PRD':
					if (document.body._menuItemType == 'CUBE_P_PRT') {
						PerformTrans('ChangeParentPrt'+'<|||>Y<|>'+g_currentObjId.split("<||>")[1]+'<|><|><|><|>');			
						break;
					}
					PerformTrans('ChangeParentPrd'+'<|||>N<|>'+g_currentObjId.split("<||>")[1]+'<|>'+l_obj.id.split("<||>")[1]);
					break;
				case 'TYP_PR2':
					if (document.body._menuItemType == 'CUBE_P_PA2') {
						PerformTrans('ChangeParentPa2'+'<|||>Y<|>'+g_currentObjId.split("<||>")[1]+'<|><|><|><|><|><|>');			
						break;
					}
					PerformTrans('ChangeParentPr2'+'<|||>N<|>'+g_currentObjId.split("<||>")[1]+'<|>'+l_obj.id.split("<||>")[1]);
					break;
				case 'TYP_PA2':
					PerformTrans('ChangeParentPa2'+'<|||>N<|>'+g_currentObjId.split("<||>")[1]+'<|>'+l_obj.id.split("<||>")[1]);
					break;
				case 'TYP_PRT':
					PerformTrans('ChangeParentPrt'+'<|||>N<|>'+g_currentObjId.split("<||>")[1]+'<|>'+l_obj.id.split("<||>")[1]);
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
	ResetState(); 
	CloseMenu();
	var l_childCount = p_obj.parentNode.parentNode.children.length;
	var l_obj_id = p_obj.parentNode.id;
	var l_type_id = l_obj_id.split("<||>");
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

	switch (l_type_id[0]) {
 	case 'DIR_AAA':
		AddMenuItem(g_objMenuList, 'add aaa', 'icons/produkt.bmp','DetailAAA','N','TYP_AAA',0,'N',2);
		break;
 	case 'TYP_AAA':
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
		PerformTrans('CountCcc');
		break;
 	case 'TYP_CCC':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_CCC',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add ccc', 'icons/produkt.bmp','CubeAdd','R','TYP_CCC',3,'N',2);
		PerformTrans('CountCccRestrictedItems'+'<|||>'+l_type_id[1]);
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
