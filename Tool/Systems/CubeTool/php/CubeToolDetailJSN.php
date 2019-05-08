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
					case "SELECT_JSN":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputFkJsnName").value=l_json_values.FkJsnName;
						document.getElementById("InputFkJsnLocation").value=l_json_values.FkJsnLocation;
						document.getElementById("InputCubeTsgType").value=l_json_values.CubeTsgType;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_JSN":
						document.getElementById("InputFkBotName").readOnly=true;
						document.getElementById("InputFkTypName").readOnly=true;
						document.getElementById("InputFkJsnName").readOnly=true;
						document.getElementById("InputFkJsnLocation").readOnly=true;
						document.getElementById("InputName").readOnly=true;
						document.getElementById("InputLocation").readOnly=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,Name:document.getElementById("InputName").value,Location:document.getElementById("InputLocation").value};
						g_node_id = '{"TYP_JSN":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_JSN',
									l_json_node_id,
									'icons/braces.bmp', 
									document.getElementById("InputName").value.toLowerCase()+' '+document.getElementById("InputLocation").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_JSN":
						break;
					case "DELETE_JSN":
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
					case "SELECT_FKEY_TYP":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						break;
					case "SELECT_FKEY_JSN":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
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
	g_xmlhttp.open('POST','CubeToolServer.php',true);
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
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_JSN.FkTypName;
		document.getElementById("InputName").value=l_json_objectKey.TYP_JSN.Name;
		document.getElementById("InputLocation").value=l_json_objectKey.TYP_JSN.Location;
		document.getElementById("ButtonCreate").disabled=true;
		performTrans( {
			Service: "GetJsn",
			Parameters: {
				Type: l_json_objectKey.TYP_JSN
			}
		} );
		document.getElementById("InputFkBotName").readOnly=true;
		document.getElementById("InputFkTypName").readOnly=true;
		document.getElementById("InputFkJsnName").readOnly=true;
		document.getElementById("InputFkJsnLocation").readOnly=true;
		document.getElementById("InputCubeTsgType").readOnly=true;
		document.getElementById("InputName").readOnly=true;
		document.getElementById("InputLocation").readOnly=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_TYP.Name;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		performTrans( {
			Service: "GetTypFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_TYP
			}
		} );
		document.getElementById("InputFkBotName").readOnly=true;
		document.getElementById("InputFkTypName").readOnly=true;
		document.getElementById("InputFkJsnName").readOnly=true;
		document.getElementById("InputFkJsnLocation").readOnly=true;
		break;  
	case "R":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_JSN.Name;
		document.getElementById("InputFkJsnName").value=l_json_objectKey.TYP_JSN.Name;
		document.getElementById("InputFkJsnLocation").value=l_json_objectKey.TYP_JSN.Location;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		performTrans( {
			Service: "GetJsnFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_JSN
			}
		} );
		document.getElementById("InputFkBotName").readOnly=true;
		document.getElementById("InputFkTypName").readOnly=true;
		document.getElementById("InputFkJsnName").readOnly=true;
		document.getElementById("InputFkJsnLocation").readOnly=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
	document.getElementById("InputCubeLevel").value='1';
}

function CreateJsn() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkJsnName: document.getElementById("InputFkJsnName").value,
		FkJsnLocation: document.getElementById("InputFkJsnLocation").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Name: document.getElementById("InputName").value,
		Location: document.getElementById("InputLocation").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		performTrans( {
			Service: "CreateJsn",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type;
		performTrans( {
			Service: "CreateJsn",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateJsn() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkJsnName: document.getElementById("InputFkJsnName").value,
		FkJsnLocation: document.getElementById("InputFkJsnLocation").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Name: document.getElementById("InputName").value,
		Location: document.getElementById("InputLocation").value
	};
	performTrans( {
		Service: "UpdateJsn",
		Parameters: {
			Type
		}
	} );
}

function DeleteJsn() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		Location: document.getElementById("InputLocation").value
	};
	performTrans( {
		Service: "DeleteJsn",
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
		case "OBJECT":
			document.getElementById("RowAtbLocation").style.display="none";
			break;
		case "ARRAY":
			document.getElementById("RowAtbName").style.display="none";
			break;
		case "ATRIBREF":
			document.getElementById("RowAtbLocation").style.display="none";
			break;
		}
		document.getElementById("TableMain").style.display="inline";
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/braces_large.bmp" /><span> JSON_OBJECT /
<select id="InputCubeTsgType" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;type&gt;</option>
	<option value="OBJECT">OBJECT</option>
	<option value="ARRAY">ARRAY</option>
	<option value="ATRIBREF">ATTRIBUTE_REFERENCE</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr><td>BusinessObjectType.Name</td><td><div style="max-width:30em;">
<input id="InputFkBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Type.Name</u></td><td><div style="max-width:30em;">
<input id="InputFkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>JsonObject.Name</td><td><div style="max-width:32em;">
<input id="InputFkJsnName" type="text" maxlength="32" style="width:100%;"></input></div></td></tr>
<tr><td>JsonObject.Location</td><td><div style="max-width:9em;">
<input id="InputFkJsnLocation" type="text" maxlength="9" style="width:100%;"></input></div></td></tr>
<tr id="RowAtbName"><td style="cursor:help;" oncontextmenu="OpenDescBox('BRACES','JsonObject.Name','JSON_OBJECT','NAME',-1)"><u>Name</u></td><td><div style="max-width:32em;">
<input id="InputName" type="text" maxlength="32" style="width:100%;"></input></div></td></tr>
<tr id="RowAtbLocation"><td style="cursor:help;" oncontextmenu="OpenDescBox('BRACES','JsonObject.Location','JSON_OBJECT','LOCATION',-1)"><u>Location</u></td><td><div style="max-width:9em;">
<input id="InputLocation" type="text" maxlength="9" style="width:100%;"></input></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateJsn()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateJsn()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteJsn()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
<input id="InputCubeLevel" type="hidden"></input>
</body>
</html>
