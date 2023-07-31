<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<title>CubeTool</title>
<meta charset="UTF-8">
<link rel="icon" href="icons/composys_icon.png">
<link rel="stylesheet" href="base_css.php" />
<style type="text/css">
</style>
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeInclude.js?filever=<?=filemtime('../CubeGeneral/CubeInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeTreeInclude.js?filever=<?=filemtime('../CubeGeneral/CubeTreeInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeToolInclude.js?filever=<?=filemtime('CubeToolInclude.js')?>"></script>
<script language="javascript" type="text/javascript">
<!--

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
					case 'LIST_ITP': AddTreeviewChildren(l_json_array[i].Rows,'TYP_ITP','icons/inftype.bmp','InformationType'); break;
					case 'LIST_ITE': AddTreeviewChildren(l_json_array[i].Rows,'TYP_ITE','icons/infelem.bmp','InformationTypeElement'); break;
					case 'LIST_VAL': AddTreeviewChildren(l_json_array[i].Rows,'TYP_VAL','icons/value.bmp','PermittedValue'); break;
					case 'MOVE_VAL': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_BOT': AddTreeviewChildren(l_json_array[i].Rows,'TYP_BOT','icons/botype.bmp','BusinessObjectType'); break;
					case 'MOVE_BOT': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_TYP': AddTreeviewChildren(l_json_array[i].Rows,'TYP_TYP','icons/type.bmp','Type'); break;
					case 'COUNT_TYP': CheckMenuItem('TYP_TYP',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'MOVE_TYP': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_TSG': AddTreeviewChildren(l_json_array[i].Rows,'TYP_TSG','icons/tspgroup.bmp','TypeSpecialisationGroup'); break;
					case 'COUNT_TSG': CheckMenuItem('TYP_TSG',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'MOVE_TSG': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_TSP': AddTreeviewChildren(l_json_array[i].Rows,'TYP_TSP','icons/typespec.bmp','TypeSpecialisation'); break;
					case 'MOVE_TSP': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_SRV': AddTreeviewChildren(l_json_array[i].Rows,'TYP_SRV','icons/service.bmp','Service'); break;
					case 'MOVE_SRV': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_SVA': AddTreeviewChildren(l_json_array[i].Rows,'TYP_SVA','icons/servatb.bmp','ServiceArgument'); break;
					case 'MOVE_SVA': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_ATB': AddTreeviewChildren(l_json_array[i].Rows,'TYP_ATB','icons/attrib.bmp','Attribute'); break;
					case 'MOVE_ATB': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_DER': AddTreeviewChildren(l_json_array[i].Rows,'TYP_DER','icons/deriv.bmp','Derivation'); break;
					case 'COUNT_DER': CheckMenuItem('TYP_DER',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_DCA': AddTreeviewChildren(l_json_array[i].Rows,'TYP_DCA','icons/desc.bmp','DescriptionAttribute'); break;
					case 'COUNT_DCA': CheckMenuItem('TYP_DCA',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_RTA': AddTreeviewChildren(l_json_array[i].Rows,'TYP_RTA','icons/restrict.bmp','RestrictionTypeSpecAtb'); break;
					case 'LIST_REF': AddTreeviewChildren(l_json_array[i].Rows,'TYP_REF','icons/ref.bmp','Reference'); break;
					case 'MOVE_REF': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_DCR': AddTreeviewChildren(l_json_array[i].Rows,'TYP_DCR','icons/desc.bmp','DescriptionReference'); break;
					case 'COUNT_DCR': CheckMenuItem('TYP_DCR',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_RTR': AddTreeviewChildren(l_json_array[i].Rows,'TYP_RTR','icons/restrict.bmp','RestrictionTypeSpecRef'); break;
					case 'LIST_RTS': AddTreeviewChildren(l_json_array[i].Rows,'TYP_RTS','icons/restrtgt.bmp','RestrictionTargetTypeSpec'); break;
					case 'COUNT_RTS': CheckMenuItem('TYP_RTS',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_RTT': AddTreeviewChildren(l_json_array[i].Rows,'TYP_RTT','icons/restrict.bmp','RestrictionTypeSpecTyp'); break;
					case 'LIST_JSN': AddTreeviewChildren(l_json_array[i].Rows,'TYP_JSN','icons/braces.bmp','JsonPath'); break;
					case 'COUNT_JSN': CheckMenuItem('TYP_JSN',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'MOVE_JSN': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_DCT': AddTreeviewChildren(l_json_array[i].Rows,'TYP_DCT','icons/desc.bmp','DescriptionType'); break;
					case 'COUNT_DCT': CheckMenuItem('TYP_DCT',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_SYS': AddTreeviewChildren(l_json_array[i].Rows,'TYP_SYS','icons/system.bmp','System'); break;
					case 'LIST_SBT': AddTreeviewChildren(l_json_array[i].Rows,'TYP_SBT','icons/sysbot.bmp','SystemBoType'); break;
					case 'MOVE_SBT': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_FUN': AddTreeviewChildren(l_json_array[i].Rows,'TYP_FUN','icons/function.bmp','Function'); break;
					case 'COUNT_FUN': CheckMenuItem('TYP_FUN',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_ARG': AddTreeviewChildren(l_json_array[i].Rows,'TYP_ARG','icons/funcatb.bmp','Argument'); break;
					case 'MOVE_ARG': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
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
	
function InitBody() {
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	ResetState();
	l_objBody = document.getElementById('TreeBody');
	l_objBody._type = 'ROOT';
	l_objBody.childNodes[0]._index = 0;
	AddTreeviewNode(l_objBody, 'DIR_ITP', null, 'icons/folder.bmp', null, 'Information_Types', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_BOT', null, 'icons/folder.bmp', null, 'Business_Object_Types', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_SYS', null, 'icons/folder.bmp', null, 'Systems', 'Y', ' ', null);
	AddTreeviewNode(l_objBody, 'DIR_FUN', null, 'icons/folder.bmp', null, 'Functions', 'Y', ' ', null);
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
		switch (p_type) { case 'TYP_TSG': l_index = 2; break; case 'TYP_SRV': l_index = 3; break; case 'TYP_ATB': l_index = 4; break; case 'TYP_REF': l_index = 5; break; case 'TYP_RTT': l_index = 6; break; case 'TYP_JSN': l_index = 7; break; case 'TYP_DCT': l_index = 8; break;case 'TYP_TYP': l_index = 9; break;}
		var l_count = 8; break;
	case 'TYP_TSG':
		switch (p_type) { case 'TYP_TSP': l_index = 2; break;case 'TYP_TSG': l_index = 3; break;}
		var l_count = 2; break;
	case 'TYP_SRV':
		switch (p_type) { case 'TYP_SVA': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_ATB':
		switch (p_type) { case 'TYP_DER': l_index = 2; break; case 'TYP_DCA': l_index = 3; break; case 'TYP_RTA': l_index = 4; break;}
		var l_count = 3; break;
	case 'TYP_REF':
		switch (p_type) { case 'TYP_DCR': l_index = 2; break; case 'TYP_RTR': l_index = 3; break; case 'TYP_RTS': l_index = 4; break;}
		var l_count = 3; break;
	case 'TYP_JSN':
		switch (p_type) {case 'TYP_JSN': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_SYS':
		switch (p_type) { case 'TYP_SBT': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_FUN':
		switch (p_type) { case 'TYP_ARG': l_index = 2; break;}
		var l_count = 1; break;
	default: var l_count = 0;
	}
	if (p_switch == 'C') {
		return l_count;
	} else {
		return l_index;
	}
}

function OpenCloseOnClick(p_obj) {
	if (document.body._state !== "N") return;  // User interaction in progres
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
			PerformTrans('InformationType', {Service:"GetDirItpItems"} );
			break;
 		case 'TYP_ITP':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_ITP"];
			PerformTrans('InformationType', {Service:"GetItpItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_ITE':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_ITE"];
			PerformTrans('InformationType', {Service:"GetIteItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'DIR_BOT':
			PerformTrans('BusinessObjectType', {Service:"GetDirBotItems"} );
			break;
 		case 'TYP_BOT':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_BOT"];
			PerformTrans('BusinessObjectType', {Service:"GetBotItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_TYP':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_TYP"];
			PerformTrans('BusinessObjectType', {Service:"GetTypItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_TSG':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_TSG"];
			PerformTrans('BusinessObjectType', {Service:"GetTsgItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_SRV':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_SRV"];
			PerformTrans('BusinessObjectType', {Service:"GetSrvItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_ATB':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_ATB"];
			PerformTrans('BusinessObjectType', {Service:"GetAtbItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_REF':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_REF"];
			PerformTrans('BusinessObjectType', {Service:"GetRefItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_JSN':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_JSN"];
			PerformTrans('BusinessObjectType', {Service:"GetJsnItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'DIR_SYS':
			PerformTrans('System', {Service:"GetDirSysItems"} );
			break;
 		case 'TYP_SYS':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_SYS"];
			PerformTrans('System', {Service:"GetSysItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'DIR_FUN':
			PerformTrans('Function', {Service:"GetDirFunItems"} );
			break;
 		case 'TYP_FUN':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_FUN"];
			PerformTrans('Function', {Service:"GetFunItems",Parameters:{Type:l_json_id}} );
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
	case 'N': // Normal (no user interaction)
		ResetState();
		if (p_obj.parentNode._type.substr(0,4) == 'TYP_') {
			OpenDetailPage(p_obj.parentNode._name, 'D', p_obj.parentNode.id, null);
		}
		break;
	case 'M': // Moving object
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
				PerformTrans('InformationType', {Service:"MoveVal",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_BOT':
				PerformTrans('BusinessObjectType', {Service:"MoveBot",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_TYP':
				PerformTrans('BusinessObjectType', {Service:"MoveTyp",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_TSG':
				PerformTrans('BusinessObjectType', {Service:"MoveTsg",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_TSP':
				PerformTrans('BusinessObjectType', {Service:"MoveTsp",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_SRV':
				PerformTrans('BusinessObjectType', {Service:"MoveSrv",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_SVA':
				PerformTrans('BusinessObjectType', {Service:"MoveSva",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_ATB':
				PerformTrans('BusinessObjectType', {Service:"MoveAtb",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_REF':
				PerformTrans('BusinessObjectType', {Service:"MoveRef",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_JSN':
				PerformTrans('BusinessObjectType', {Service:"MoveJsn",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_SBT':
				PerformTrans('System', {Service:"MoveSbt",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_ARG':
				PerformTrans('Function', {Service:"MoveArg",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			}
		}
		break;
	case 'P': // Changing object parent
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
					PerformTrans('BusinessObjectType', {Service:"MoveTyp",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
					break;
				case 'TYP_JSN':
					var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
					PerformTrans('BusinessObjectType', {Service:"MoveJsn",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
					break;
				}
			}
		}
		break;
	case 'A': // Adding object
		if (g_currentObjId == p_obj.parentNode._parentId && g_currentChildIndex >= p_obj.parentNode.parentNode._index || g_currentObjId == p_obj.parentNode.id) {
			if (g_currentObjId == p_obj.parentNode._parentId && g_currentChildIndex == p_obj.parentNode.parentNode._index) {
				var l_option = '{"Code":"A","Type":'+p_obj.parentNode.id+'}';
			} else {
				var l_option = '{"Code":"B","Type":'+g_objNodeDiv.children[g_currentChildIndex].firstChild.id+'}';
			}
			ResetState();
			OpenDetailPage(g_currentObjName, g_currentNodeType, g_currentObjId, l_option);
		}
		break;
	}
}

function OpenDetailPage (p_name, p_nodeType, p_objId, p_option) {
	if (p_option == null) {
		var l_option = '';
	} else {
		var l_option = ',"Option":'+p_option;
	}
	document.getElementById('DetailFrame').src='CubeToolMaintain'+p_name+'.php?'+encodeURIComponent('{"nodeType":"'+p_nodeType+'","objectId":'+p_objId+l_option+'}');
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
	g_currentObjName = g_objNodeDiv._name;
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
		AddMenuItem(g_objMenuList, 'add information_type', 'icons/inftype.bmp','DetailITP','N','TYP_ITP','InformationType',0,'N',2);
		break;
 	case 'TYP_ITP':
		AddMenuItem(g_objMenuList, 'add information_type_element', 'icons/infelem.bmp','DetailITE','N','TYP_ITE','InformationTypeElement',0,'N',2);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','InformationType',0,'N',0);
		break;
 	case 'TYP_ITE':
		AddMenuItem(g_objMenuList, 'add permitted_value', 'icons/value.bmp','CubeAdd','N','TYP_VAL','PermittedValue',0,'N',2);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','InformationTypeElement',0,'N',0);
		break;
 	case 'TYP_VAL':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_VAL','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','PermittedValue',0,'N',0);
		break;
 	case 'DIR_BOT':
		AddMenuItem(g_objMenuList, 'add business_object_type', 'icons/botype.bmp','CubeAdd','N','TYP_BOT','BusinessObjectType',0,'N',2);
		break;
 	case 'TYP_BOT':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_BOT','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add type', 'icons/type.bmp','CubeAdd','N','TYP_TYP','Type',1,'N',2);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','BusinessObjectType',0,'N',0);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans('BusinessObjectType', {Service:"CountBotRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_TYP':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_TYP','',0,'N',0);
		}
		var l_json_parent_node_id = JSON.parse(p_obj.parentNode.parentNode.parentNode.id);
		var l_parent_type_id = Object.keys(l_json_parent_node_id)[0];
		if (l_childCount > 1 || l_type_id == l_parent_type_id) {
			AddMenuItem(g_objMenuList, 'change parent', 'icons/cube_change_par.bmp','CubeChangePar','','CUBE_P_TYP','',0,'Y',0);
		}
		AddMenuItem(g_objMenuList, 'add type_specialisation_group', 'icons/tspgroup.bmp','CubeAdd','N','TYP_TSG','TypeSpecialisationGroup',0,'N',2);
		AddMenuItem(g_objMenuList, 'add service', 'icons/service.bmp','CubeAdd','N','TYP_SRV','Service',0,'N',3);
		AddMenuItem(g_objMenuList, 'add attribute', 'icons/attrib.bmp','CubeAdd','N','TYP_ATB','Attribute',0,'N',4);
		AddMenuItem(g_objMenuList, 'add reference', 'icons/ref.bmp','CubeAdd','N','TYP_REF','Reference',0,'N',5);
		AddMenuItem(g_objMenuList, 'add restriction_type_spec_typ', 'icons/restrict.bmp','DetailRTT','N','TYP_RTT','RestrictionTypeSpecTyp',0,'N',6);
		AddMenuItem(g_objMenuList, 'add json_path', 'icons/braces.bmp','CubeAdd','N','TYP_JSN','JsonPath',1,'N',7);
		AddMenuItem(g_objMenuList, 'add description_type', 'icons/desc.bmp','DetailDCT','N','TYP_DCT','DescriptionType',1,'N',8);
		AddMenuItem(g_objMenuList, 'add type', 'icons/type.bmp','CubeAdd','R','TYP_TYP','Type',0,'N',9);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','Type',0,'N',0);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans('BusinessObjectType', {Service:"CountTypRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_TSG':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_TSG','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add type_specialisation', 'icons/typespec.bmp','CubeAdd','N','TYP_TSP','TypeSpecialisation',0,'N',2);
		AddMenuItem(g_objMenuList, 'add type_specialisation_group', 'icons/tspgroup.bmp','CubeAdd','R','TYP_TSG','TypeSpecialisationGroup',1,'N',3);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','TypeSpecialisationGroup',0,'N',0);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans('BusinessObjectType', {Service:"CountTsgRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_TSP':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_TSP','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','TypeSpecialisation',0,'N',0);
		break;
 	case 'TYP_SRV':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_SRV','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add service_argument', 'icons/servatb.bmp','CubeAdd','N','TYP_SVA','ServiceArgument',0,'N',2);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','Service',0,'N',0);
		break;
 	case 'TYP_SVA':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_SVA','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','ServiceArgument',0,'N',0);
		break;
 	case 'TYP_ATB':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_ATB','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add derivation', 'icons/deriv.bmp','DetailDER','N','TYP_DER','Derivation',1,'N',2);
		AddMenuItem(g_objMenuList, 'add description_attribute', 'icons/desc.bmp','DetailDCA','N','TYP_DCA','DescriptionAttribute',1,'N',3);
		AddMenuItem(g_objMenuList, 'add restriction_type_spec_atb', 'icons/restrict.bmp','DetailRTA','N','TYP_RTA','RestrictionTypeSpecAtb',0,'N',4);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','Attribute',0,'N',0);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans('BusinessObjectType', {Service:"CountAtbRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_REF':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_REF','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add description_reference', 'icons/desc.bmp','DetailDCR','N','TYP_DCR','DescriptionReference',1,'N',2);
		AddMenuItem(g_objMenuList, 'add restriction_type_spec_ref', 'icons/restrict.bmp','DetailRTR','N','TYP_RTR','RestrictionTypeSpecRef',0,'N',3);
		AddMenuItem(g_objMenuList, 'add restriction_target_type_spec', 'icons/restrtgt.bmp','DetailRTS','N','TYP_RTS','RestrictionTargetTypeSpec',1,'N',4);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','Reference',0,'N',0);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans('BusinessObjectType', {Service:"CountRefRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_JSN':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_JSN','',0,'N',0);
		}
		var l_json_parent_node_id = JSON.parse(p_obj.parentNode.parentNode.parentNode.id);
		var l_parent_type_id = Object.keys(l_json_parent_node_id)[0];
		if (l_childCount > 1 || l_type_id == l_parent_type_id) {
			AddMenuItem(g_objMenuList, 'change parent', 'icons/cube_change_par.bmp','CubeChangePar','','CUBE_P_JSN','',0,'Y',0);
		}
		AddMenuItem(g_objMenuList, 'add json_path', 'icons/braces.bmp','CubeAdd','R','TYP_JSN','JsonPath',0,'N',2);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','JsonPath',0,'N',0);
		break;
 	case 'DIR_SYS':
		AddMenuItem(g_objMenuList, 'add system', 'icons/system.bmp','DetailSYS','N','TYP_SYS','System',0,'N',2);
		break;
 	case 'TYP_SYS':
		AddMenuItem(g_objMenuList, 'add system_bo_type', 'icons/sysbot.bmp','CubeAdd','N','TYP_SBT','SystemBoType',0,'N',2);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','System',0,'N',0);
		break;
 	case 'TYP_SBT':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_SBT','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','SystemBoType',0,'N',0);
		break;
 	case 'DIR_FUN':
		AddMenuItem(g_objMenuList, 'add function', 'icons/function.bmp','DetailFUN','N','TYP_FUN','Function',1,'N',2);
		PerformTrans('Function', {Service:"CountFun"} );
		break;
 	case 'TYP_FUN':
		AddMenuItem(g_objMenuList, 'add argument', 'icons/funcatb.bmp','CubeAdd','N','TYP_ARG','Argument',0,'N',2);
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','Function',0,'N',0);
		break;
 	case 'TYP_ARG':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_ARG','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'delete', 'icons/cube_delete.bmp','CubeDelete','X','','Argument',0,'N',0);
		break;
	}
}

-->
</script>
</head>
<body lang="en" oncontextmenu="ResetState(); return false;" onload="InitBody()" onbeforeunload="return CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
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
<iframe id="DetailFrame" style="position:absolute;height:100%;width:100%;" onmouseover="ResetState()"></iframe>
</div></body></html>