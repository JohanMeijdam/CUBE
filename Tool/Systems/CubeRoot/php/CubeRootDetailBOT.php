<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language='javascript' type='text/javascript'>
<!--
var g_option = null;
var g_json_option = null;
var g_parent_node_id = null;
var g_node_id = null;

var g_xmlhttp = new XMLHttpRequest();
g_xmlhttp.onreadystatechange = function() {
	if(g_xmlhttp.readyState == 4) {
		if(g_xmlhttp.status == 200) {
			var g_responseText = g_xmlhttp.responseText;
			try {
				var l_json_array = JSON.parse(g_responseText);
			}
			catch (err) {
				alert ('JSON parse error:\n'+g_responseText);
			}
			for (i in l_json_array) {
				switch (l_json_array[i].ResultName) {
					case "SELECT_BOT":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputCubeTsgType").value=l_json_values.CubeTsgType;
						document.getElementById("InputDirectory").value=l_json_values.Directory;
						document.getElementById("InputApiUrl").value=l_json_values.ApiUrl;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_BOT":
						document.getElementById("InputName").readOnly=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Name:document.getElementById("InputName").value};
						g_node_id = '{"TYP_BOT":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_BOT',
									l_json_node_id,
									'icons/botype.bmp', 
									document.getElementById("InputName").value.toLowerCase()+' '+document.getElementById("InputCubeTsgType").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_BOT":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputName").value.toLowerCase()+' '+document.getElementById("InputCubeTsgType").value.toLowerCase();
					}
						break;
					case "DELETE_BOT":
						document.getElementById("ButtonCreate").disabled=false;
						document.getElementById("ButtonUpdate").disabled=true;
						document.getElementById("ButtonDelete").disabled=true;
						var l_objNode = parent.document.getElementById(g_node_id);
						if (g_parent_node_id == null) {
							g_parent_node_id = l_objNode.parentNode.parentNode.id;
						} 
						if (l_objNode != null) {
							l_objNode.parentNode.removeChild(l_objNode);
						}
						break;
					case "ERROR":
						alert ('Server error:\n'+l_json_array[i].ErrorText);
						break;
					default:
						alert ('Unknown reply:\n'+g_responseText);
				}
			}
		} else {
			alert ('Request error:\n'+g_xmlhttp.statusText);
		}
		
	}
}

function performTrans(p_json_parm) {
	var l_requestText = JSON.stringify(p_json_parm);
	g_xmlhttp.open('POST','CubeRootServer.php',true);
	g_xmlhttp.send(l_requestText);
}

function InitBody() {
	var l_json_argument = JSON.parse(decodeURIComponent(location.href.split("?")[1]));
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	document.body._ListBoxCode="Ref000";
	var l_json_objectKey = l_json_argument.objectId;
	g_json_option = l_json_argument.Option;
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputName").value=l_json_objectKey.TYP_BOT.Name;
		document.getElementById("ButtonCreate").disabled=true;
		performTrans( {
			Service: "GetBot",
			Parameters: {
				Type: l_json_objectKey.TYP_BOT
			}
		} );
		document.getElementById("InputName").readOnly=true;
		document.getElementById("InputCubeTsgType").readOnly=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateBot() {
	var Type = {
		Name: document.getElementById("InputName").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Directory: document.getElementById("InputDirectory").value,
		ApiUrl: document.getElementById("InputApiUrl").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		performTrans( {
			Service: "CreateBot",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_BOT;
		performTrans( {
			Service: "CreateBot",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateBot() {
	var Type = {
		Name: document.getElementById("InputName").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Directory: document.getElementById("InputDirectory").value,
		ApiUrl: document.getElementById("InputApiUrl").value
	};
	performTrans( {
		Service: "UpdateBot",
		Parameters: {
			Type
		}
	} );
}

function DeleteBot() {
	var Type = {
		Name: document.getElementById("InputName").value
	};
	performTrans( {
		Service: "DeleteBot",
		Parameters: {
			Type
		}
	} );
}


function ToUpperCase(p_obj) 
{
	p_obj.value = p_obj.value.toUpperCase();

}

function ReplaceSpaces(p_obj) 
{
	p_obj.value = p_obj.value.replace(/^\s+|\s+$/g, "").replace(/ /g ,"_");
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

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgType").value != ' ') {
		document.getElementById("InputCubeTsgType").disabled=true;
		switch (document.getElementById("InputCubeTsgType").value) {
		case "INT":
			document.getElementById("RowAtbApiUrl").style.display="none";
			break;
		case "RET":
			document.getElementById("RowAtbDirectory").style.display="none";
			document.getElementById("RowAtbApiUrl").style.display="none";
			break;
		}
		document.getElementById("TableMain").style.display="inline";
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/botype_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('BOTYPE','BusinessObjectType','BUSINESS_OBJECT_TYPE','_',-1)"> BUSINESS_OBJECT_TYPE /
<select id="InputCubeTsgType" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;type&gt;</option>
	<option value="INT">INTERNAL</option>
	<option value="EXT">EXTERNAL</option>
	<option value="RET">REUSABLE_TYPE</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr><td><u>Name</u></td><td><div style="max-width:30em;">
<input id="InputName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbDirectory"><td>Directory</td><td><div style="max-width:80em;">
<input id="InputDirectory" type="text" maxlength="80" style="width:100%;" onchange="ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbApiUrl"><td style="cursor:help;" oncontextmenu="parent.OpenDescBox('BOTYPE','BusinessObjectType.ApiUrl','BUSINESS_OBJECT_TYPE','API_URL',-1)">ApiUrl</td><td><div style="max-width:300em;">
<input id="InputApiUrl" type="text" maxlength="300" style="width:100%;" onchange="ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateBot()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateBot()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteBot()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
