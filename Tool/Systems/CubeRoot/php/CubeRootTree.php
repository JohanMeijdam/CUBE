<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<title>CubeRoot</title>
<meta charset="UTF-8">
<link rel="icon" href="icons/composys_icon.png">
<link rel="stylesheet" href="base_css.php" />
<style type="text/css">
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
					case 'LIST_ITP': AddTreeviewChildren(l_json_array[i].Rows,'TYP_ITP','icons/inftype.bmp'); break;
					case 'LIST_ITE': AddTreeviewChildren(l_json_array[i].Rows,'TYP_ITE','icons/infelem.bmp'); break;
					case 'LIST_VAL': AddTreeviewChildren(l_json_array[i].Rows,'TYP_VAL','icons/value.bmp'); break;
					case 'MOVE_VAL': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_BOT': AddTreeviewChildren(l_json_array[i].Rows,'TYP_BOT','icons/botype.bmp'); break;
					case 'MOVE_BOT': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_TYP': AddTreeviewChildren(l_json_array[i].Rows,'TYP_TYP','icons/type.bmp'); break;
					case 'COUNT_TYP': CheckMenuItem('TYP_TYP',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'MOVE_TYP': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_ATB': AddTreeviewChildren(l_json_array[i].Rows,'TYP_ATB','icons/attrib.bmp'); break;
					case 'MOVE_ATB': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_DER': AddTreeviewChildren(l_json_array[i].Rows,'TYP_DER','icons/deriv.bmp'); break;
					case 'COUNT_DER': CheckMenuItem('TYP_DER',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_DCA': AddTreeviewChildren(l_json_array[i].Rows,'TYP_DCA','icons/desc.bmp'); break;
					case 'COUNT_DCA': CheckMenuItem('TYP_DCA',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_RTA': AddTreeviewChildren(l_json_array[i].Rows,'TYP_RTA','icons/restrict.bmp'); break;
					case 'LIST_REF': AddTreeviewChildren(l_json_array[i].Rows,'TYP_REF','icons/ref.bmp'); break;
					case 'MOVE_REF': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_DCR': AddTreeviewChildren(l_json_array[i].Rows,'TYP_DCR','icons/desc.bmp'); break;
					case 'COUNT_DCR': CheckMenuItem('TYP_DCR',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_RTR': AddTreeviewChildren(l_json_array[i].Rows,'TYP_RTR','icons/restrict.bmp'); break;
					case 'LIST_RTT': AddTreeviewChildren(l_json_array[i].Rows,'TYP_RTT','icons/restrict.bmp'); break;
					case 'LIST_JSN': AddTreeviewChildren(l_json_array[i].Rows,'TYP_JSN','icons/braces.bmp'); break;
					case 'COUNT_JSN': CheckMenuItem('TYP_JSN',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'MOVE_JSN': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_TSG': AddTreeviewChildren(l_json_array[i].Rows,'TYP_TSG','icons/tspgroup.bmp'); break;
					case 'COUNT_TSG': CheckMenuItem('TYP_TSG',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'MOVE_TSG': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_TSP': AddTreeviewChildren(l_json_array[i].Rows,'TYP_TSP','icons/typespec.bmp'); break;
					case 'MOVE_TSP': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_DCT': AddTreeviewChildren(l_json_array[i].Rows,'TYP_DCT','icons/desc.bmp'); break;
					case 'COUNT_DCT': CheckMenuItem('TYP_DCT',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_SYS': AddTreeviewChildren(l_json_array[i].Rows,'TYP_SYS','icons/system.bmp'); break;
					case 'LIST_SBT': AddTreeviewChildren(l_json_array[i].Rows,'TYP_SBT','icons/sysbot.bmp'); break;
					case 'MOVE_SBT': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case "SELECT_CUBE_DSC":	document.getElementById("CubeDesc").value = l_json_array[i].Rows[0].Data.Value;	break;
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
	l_objBody = document.getElementById('TreeBody');
	l_objBody._type = 'ROOT';
	l_objBody.childNodes[0]._index = 0;
	AddTreeviewNode(l_objBody, 'DIR_ITP', null, 'icons/folder.bmp', 'Information_Types', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_BOT', null, 'icons/folder.bmp', 'Business_Object_Types', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_SYS', null, 'icons/folder.bmp', 'Systems', 'Y', ' ', null);
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
	g_xmlhttp.open('POST','CubeRootServer.php',true);
//	g_xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	g_xmlhttp.send(l_requestText);
}

function DefineTypePosition (p_parentType, p_type, p_switch) {
	var l_index = 0;
	switch (p_parentType) {
	case 'TYP_ITP':
		switch (p_type) { case 'TYP_ITE': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_ITE':
		switch (p_type) { case 'TYP_VAL': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_BOT':
		switch (p_type) { case 'TYP_TYP': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_TYP':
		switch (p_type) { case 'TYP_ATB': l_index = 2; break; case 'TYP_REF': l_index = 3; break; case 'TYP_RTT': l_index = 4; break; case 'TYP_JSN': l_index = 5; break; case 'TYP_TSG': l_index = 6; break; case 'TYP_DCT': l_index = 7; break;case 'TYP_TYP': l_index = 8; break;}
		var l_count = 7; break;
	case 'TYP_ATB':
		switch (p_type) { case 'TYP_DER': l_index = 2; break; case 'TYP_DCA': l_index = 3; break; case 'TYP_RTA': l_index = 4; break;}
		var l_count = 3; break;
	case 'TYP_REF':
		switch (p_type) { case 'TYP_DCR': l_index = 2; break; case 'TYP_RTR': l_index = 3; break;}
		var l_count = 2; break;
	case 'TYP_JSN':
		switch (p_type) {case 'TYP_JSN': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_TSG':
		switch (p_type) { case 'TYP_TSP': l_index = 2; break;case 'TYP_TSG': l_index = 3; break;}
		var l_count = 2; break;
	case 'TYP_SYS':
		switch (p_type) { case 'TYP_SBT': l_index = 2; break;}
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
	l_objDiv.style.paddingLeft = "12px";
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
	return '{"'+p_type+'":'+JSON.stringify(p_json_id)+'}'
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
 		case 'DIR_ITP':
			PerformTrans( {Service:"GetDirItpItems"} );
			break;
 		case 'TYP_ITP':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_ITP"];
			PerformTrans( {Service:"GetItpItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_ITE':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_ITE"];
			PerformTrans( {Service:"GetIteItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'DIR_BOT':
			PerformTrans( {Service:"GetDirBotItems"} );
			break;
 		case 'TYP_BOT':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_BOT"];
			PerformTrans( {Service:"GetBotItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_TYP':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_TYP"];
			PerformTrans( {Service:"GetTypItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_ATB':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_ATB"];
			PerformTrans( {Service:"GetAtbItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_REF':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_REF"];
			PerformTrans( {Service:"GetRefItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_JSN':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_JSN"];
			PerformTrans( {Service:"GetJsnItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_TSG':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_TSG"];
			PerformTrans( {Service:"GetTsgItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'DIR_SYS':
			PerformTrans( {Service:"GetDirSysItems"} );
			break;
 		case 'TYP_SYS':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_SYS"];
			PerformTrans( {Service:"GetSysItems",Parameters:{Type:l_json_id}} );
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
			OpenDetailPage(p_obj.parentNode._type.substr(4), 'D', p_obj.parentNode.id, null);
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
			case 'TYP_VAL':
				PerformTrans( {Service:"MoveVal",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_BOT':
				PerformTrans( {Service:"MoveBot",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_TYP':
				PerformTrans( {Service:"MoveTyp",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_ATB':
				PerformTrans( {Service:"MoveAtb",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_REF':
				PerformTrans( {Service:"MoveRef",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_JSN':
				PerformTrans( {Service:"MoveJsn",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_TSG':
				PerformTrans( {Service:"MoveTsg",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_TSP':
				PerformTrans( {Service:"MoveTsp",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_SBT':
				PerformTrans( {Service:"MoveSbt",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
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
				case 'TYP_TYP':
					var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
					PerformTrans( {Service:"MoveTyp",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
					break;
				case 'TYP_JSN':
					var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
					PerformTrans( {Service:"MoveJsn",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
					break;
				}
			}
		}
		break;
	case 'A':
		if (g_currentObjId == p_obj.parentNode._parentId && g_currentChildIndex >= p_obj.parentNode.parentNode._index || g_currentObjId == p_obj.parentNode.id) {
			if (g_currentObjId == p_obj.parentNode._parentId && g_currentChildIndex == p_obj.parentNode.parentNode._index) {
				var l_option = '{"Code":"A","Type":'+p_obj.parentNode.id+'}';
			} else {
				var l_option = '{"Code":"B","Type":'+g_objNodeDiv.children[g_currentChildIndex].firstChild.id+'}';
			}
			ResetState();
			OpenDetailPage(g_currentObjType.substr(4), g_currentNodeType, g_currentObjId, l_option);
		}
		break;
	}
}

function OpenDetailPage (p_code, p_nodeType, p_objId, p_option) {
	if (p_option == null) {
		var l_option = '';
	} else {
		var l_option = ',"Option":'+p_option;
	}
	document.getElementById('DetailFrame').src='CubeRootDetail'+p_code+'.php?'+encodeURIComponent('{"nodeType":"'+p_nodeType+'","objectId":'+p_objId+l_option+'}');
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
 	case 'DIR_ITP':
		AddMenuItem(g_objMenuList, 'add information_type', 'icons/inftype.bmp','DetailITP','N','TYP_ITP',0,'N',2);
		break;
 	case 'TYP_ITP':
		AddMenuItem(g_objMenuList, 'add information_type_element', 'icons/infelem.bmp','DetailITE','N','TYP_ITE',0,'N',2);
		break;
 	case 'TYP_ITE':
		AddMenuItem(g_objMenuList, 'add permitted_value', 'icons/value.bmp','CubeAdd','N','TYP_VAL',0,'N',2);
		break;
 	case 'TYP_VAL':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_VAL',0,'N',0);
		}
		break;
 	case 'DIR_BOT':
		AddMenuItem(g_objMenuList, 'add business_object_type', 'icons/botype.bmp','CubeAdd','N','TYP_BOT',0,'N',2);
		break;
 	case 'TYP_BOT':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_BOT',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add type', 'icons/type.bmp','CubeAdd','N','TYP_TYP',1,'N',2);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans( {Service:"CountBotRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_TYP':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_TYP',0,'N',0);
		}
		var l_json_parent_node_id = JSON.parse(p_obj.parentNode.parentNode.parentNode.id);
		var l_parent_type_id = Object.keys(l_json_parent_node_id)[0];
		if (l_childCount > 1 || l_type_id == l_parent_type_id) {
			AddMenuItem(g_objMenuList, 'change parent', 'icons/cube_change_par.bmp','CubeChangePar','','CUBE_P_TYP',0,'Y',0);
		}
		AddMenuItem(g_objMenuList, 'add attribute', 'icons/attrib.bmp','CubeAdd','N','TYP_ATB',0,'N',2);
		AddMenuItem(g_objMenuList, 'add reference', 'icons/ref.bmp','CubeAdd','N','TYP_REF',0,'N',3);
		AddMenuItem(g_objMenuList, 'add restriction_type_spec_typ', 'icons/restrict.bmp','DetailRTT','N','TYP_RTT',0,'N',4);
		AddMenuItem(g_objMenuList, 'add json_path', 'icons/braces.bmp','CubeAdd','N','TYP_JSN',1,'N',5);
		AddMenuItem(g_objMenuList, 'add type_specialisation_group', 'icons/tspgroup.bmp','CubeAdd','N','TYP_TSG',0,'N',6);
		AddMenuItem(g_objMenuList, 'add description_type', 'icons/desc.bmp','DetailDCT','N','TYP_DCT',1,'N',7);
		AddMenuItem(g_objMenuList, 'add type', 'icons/type.bmp','CubeAdd','R','TYP_TYP',0,'N',8);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans( {Service:"CountTypRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_ATB':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_ATB',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add derivation', 'icons/deriv.bmp','DetailDER','N','TYP_DER',1,'N',2);
		AddMenuItem(g_objMenuList, 'add description_attribute', 'icons/desc.bmp','DetailDCA','N','TYP_DCA',1,'N',3);
		AddMenuItem(g_objMenuList, 'add restriction_type_spec_atb', 'icons/restrict.bmp','DetailRTA','N','TYP_RTA',0,'N',4);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans( {Service:"CountAtbRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_REF':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_REF',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add description_reference', 'icons/desc.bmp','DetailDCR','N','TYP_DCR',1,'N',2);
		AddMenuItem(g_objMenuList, 'add restriction_type_spec_ref', 'icons/restrict.bmp','DetailRTR','N','TYP_RTR',0,'N',3);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans( {Service:"CountRefRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_JSN':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_JSN',0,'N',0);
		}
		var l_json_parent_node_id = JSON.parse(p_obj.parentNode.parentNode.parentNode.id);
		var l_parent_type_id = Object.keys(l_json_parent_node_id)[0];
		if (l_childCount > 1 || l_type_id == l_parent_type_id) {
			AddMenuItem(g_objMenuList, 'change parent', 'icons/cube_change_par.bmp','CubeChangePar','','CUBE_P_JSN',0,'Y',0);
		}
		AddMenuItem(g_objMenuList, 'add json_path', 'icons/braces.bmp','CubeAdd','R','TYP_JSN',0,'N',2);
		break;
 	case 'TYP_TSG':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_TSG',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add type_specialisation', 'icons/typespec.bmp','CubeAdd','N','TYP_TSP',0,'N',2);
		AddMenuItem(g_objMenuList, 'add type_specialisation_group', 'icons/tspgroup.bmp','CubeAdd','R','TYP_TSG',1,'N',3);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans( {Service:"CountTsgRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_TSP':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_TSP',0,'N',0);
		}
		break;
 	case 'DIR_SYS':
		AddMenuItem(g_objMenuList, 'add system', 'icons/system.bmp','DetailSYS','N','TYP_SYS',0,'N',2);
		break;
 	case 'TYP_SYS':
		AddMenuItem(g_objMenuList, 'add system_bo_type', 'icons/sysbot.bmp','CubeAdd','N','TYP_SBT',0,'N',2);
		break;
 	case 'TYP_SBT':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_SBT',0,'N',0);
		}
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
			OpenDetailPage(p_obj._type.substr(4), p_obj._nodeType, g_currentObjId, '{"Code":"L"}');
		} else if (g_objNodeDiv.children[p_obj._childIndex].children.length == 0) {
			OpenDetailPage(p_obj._type.substr(4), p_obj._nodeType, g_currentObjId, '{"Code":"F"}');
		} else {
			document.body.style.cursor = "url(icons/pointer-pos.cur), default";
			document.body._state = "A";
			g_currentChildIndex = p_obj._childIndex;
			g_currentNodeType = p_obj._nodeType;
			g_currentObjType = p_obj._type;
		}
		break;
	default:
		OpenDetailPage(p_obj._type.substr(4), p_obj._nodeType, g_currentObjId, null);
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
<body lang="en" oncontextmenu="ResetState(); return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div style="position:fixed;top:8px;left:8px;right:8px;bottom:8px;">
<iframe src="composys_header.html" style="position:absolute;height:76px;width:100%;"></iframe>
<div class="header0" style="position:absolute;top:76px;left:0px;width:40%;height:30px;">
Treeview</div>
<div style="overflow:auto;position:absolute;top:106px;bottom:0px;left:0px;width:40%;">
<div style="position:absolute;top:8px;">
<span id="TreeBody"><span/></span>
</div></div>
<div class="header0" style="overflow:hidden;position:absolute;top:76px;left:40%;right:0;height:30px;">
Detail</div><div style="overflow:auto;position:absolute;top:106px;bottom:0px;left:40%;right:0;background-color:white;border-left: 2px solid darkslategray;">
<iframe id="DetailFrame" style="position:absolute;height:100%;width:100%;"></iframe>
</div></body></html>
