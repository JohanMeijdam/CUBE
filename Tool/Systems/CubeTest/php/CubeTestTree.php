<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<title>CubeTest</title>
<meta charset="UTF-8">
<link rel="icon" href="icons/composys_icon.png">
<link rel="stylesheet" href="base_css.php" />
<style type="text/css">
</style>
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeInclude.js"></script>
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeTreeInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeTestInclude.js"></script>
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
					case 'LIST_PRD': AddTreeviewChildren(l_json_array[i].Rows,'TYP_PRD','icons/produkt.bmp','Produkt'); break;
					case 'COUNT_PRD': CheckMenuItem('TYP_PRD',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'LIST_OND': AddTreeviewChildren(l_json_array[i].Rows,'TYP_OND','icons/part.bmp','Onderdeel'); break;
					case 'COUNT_OND': CheckMenuItem('TYP_OND',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'MOVE_OND': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_ODD': AddTreeviewChildren(l_json_array[i].Rows,'TYP_ODD','icons/type.bmp','OnderdeelDeel'); break;
					case 'COUNT_ODD': CheckMenuItem('TYP_ODD',l_json_array[i].Rows[0].Data.TypeCount); break;
					case 'MOVE_ODD': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_DDD': AddTreeviewChildren(l_json_array[i].Rows,'TYP_DDD','icons/attrib.bmp','OnderdeelDeelDeel'); break;
					case 'MOVE_DDD': MoveNode (document.getElementById(g_currentObjId), document.getElementById(document.body._objNodePosId), document.body._moveAction); break;
					case 'LIST_CST': AddTreeviewChildren(l_json_array[i].Rows,'TYP_CST','icons/type.bmp','Constructie'); break;
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
	AddTreeviewNode(l_objBody, 'DIR_PRD', null, 'icons/folder.bmp', null, 'Produkten', 'Y', ' ', null);
}

function DefineTypePosition (p_parentType, p_type, p_switch) {
	var l_index = 0;
	switch (p_parentType) {
	case 'TYP_PRD':
		switch (p_type) { case 'TYP_OND': l_index = 2; break;}
		var l_count = 1; break;
	case 'TYP_OND':
		switch (p_type) { case 'TYP_ODD': l_index = 2; break; case 'TYP_CST': l_index = 3; break;case 'TYP_OND': l_index = 4; break;}
		var l_count = 3; break;
	case 'TYP_ODD':
		switch (p_type) { case 'TYP_DDD': l_index = 2; break;}
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
 		case 'DIR_PRD':
			PerformTrans( {Service:"GetDirPrdItems"} );
			break;
 		case 'TYP_PRD':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_PRD"];
			PerformTrans( {Service:"GetPrdItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_OND':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_OND"];
			PerformTrans( {Service:"GetOndItems",Parameters:{Type:l_json_id}} );
			break;
 		case 'TYP_ODD':
			var l_json_id = JSON.parse(p_obj.parentNode.id)["TYP_ODD"];
			PerformTrans( {Service:"GetOddItems",Parameters:{Type:l_json_id}} );
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
			case 'TYP_OND':
				PerformTrans( {Service:"MoveOnd",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_ODD':
				PerformTrans( {Service:"MoveOdd",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
				break;
			case 'TYP_DDD':
				PerformTrans( {Service:"MoveDdd",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
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
				case 'TYP_OND':
					var l_json_id_ref = JSON.parse(document.body._objNodePosId)[l_obj._type];
					PerformTrans( {Service:"MoveOnd",Parameters:{Option:{CubePosAction:document.body._moveAction},Type:l_json_id,Ref:l_json_id_ref}} );
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
	document.getElementById('DetailFrame').src='CubeTestMaintain'+p_name+'.php?'+encodeURIComponent('{"nodeType":"'+p_nodeType+'","objectId":'+p_objId+l_option+'}');
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
 	case 'DIR_PRD':
		AddMenuItem(g_objMenuList, 'add produkt', 'icons/produkt.bmp','DetailPRD','N','TYP_PRD','Produkt',4,'N',2);
		PerformTrans( {Service:"CountPrd"} );
		break;
 	case 'TYP_PRD':
		AddMenuItem(g_objMenuList, 'add onderdeel', 'icons/part.bmp','CubeAdd','N','TYP_OND','Onderdeel',3,'N',2);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans( {Service:"CountPrdRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_OND':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_OND','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add onderdeel_deel', 'icons/type.bmp','CubeAdd','N','TYP_ODD','OnderdeelDeel',2,'N',2);
		AddMenuItem(g_objMenuList, 'add constructie', 'icons/type.bmp','DetailCST','N','TYP_CST','Constructie',0,'N',3);
		AddMenuItem(g_objMenuList, 'add onderdeel', 'icons/part.bmp','CubeAdd','R','TYP_OND','Onderdeel',2,'N',4);
		var l_json_id = l_json_node_id[l_type_id];
		PerformTrans( {Service:"CountOndRestrictedItems",Parameters:{Type:l_json_id}} );
		break;
 	case 'TYP_ODD':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_ODD','',0,'N',0);
		}
		AddMenuItem(g_objMenuList, 'add onderdeel_deel_deel', 'icons/attrib.bmp','CubeAdd','N','TYP_DDD','OnderdeelDeelDeel',0,'N',2);
		break;
 	case 'TYP_DDD':
		if (l_childCount > 1) {
			AddMenuItem(g_objMenuList, 'move', 'icons/cube_move.bmp','CubeMove','','CUBE_M_DDD','',0,'N',0);
		}
		break;
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
<iframe id="DetailFrame" style="position:absolute;height:100%;width:100%;" onmouseover="ResetState()"></iframe>
</div></body></html>