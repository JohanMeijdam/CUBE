<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeInclude.js"></script>
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeDetailInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeDocuInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeDocuDetailInclude.js"></script>
<script language="javascript" type="text/javascript">
<!--
var g_option = null;
var g_json_option = null;
var g_parent_node_id = null;
var g_node_id = null;

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
					case "SELECT_CGM":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputHeader").value=l_json_values.Header;
						document.getElementById("InputIncludedObjectNames").value=l_json_values.IncludedObjectNames;
						document.getElementById("InputDescription").value=l_json_values.Description;
						break;
					case "CREATE_CGM":
						document.getElementById("InputFkCubName").disabled=true;
						document.getElementById("InputId").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkCubName:document.getElementById("InputFkCubName").value,Id:document.getElementById("InputId").value};
						g_node_id = '{"TYP_CGM":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_CGM',
									l_json_node_id,
									'icons/model.bmp', 
									document.getElementById("InputHeader").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_CGM":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputHeader").value.toLowerCase();
					}
						break;
					case "DELETE_CGM":
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
		document.getElementById("InputFkCubName").value=l_json_objectKey.TYP_CGM.FkCubName;
		document.getElementById("InputId").value=l_json_objectKey.TYP_CGM.Id;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetCgm",
			Parameters: {
				Type: l_json_objectKey.TYP_CGM
			}
		} );
		document.getElementById("InputFkCubName").disabled=true;
		document.getElementById("InputId").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkCubName").value=l_json_objectKey.TYP_CUB.Name;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkCubName").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateCgm() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		Id: document.getElementById("InputId").value,
		Header: document.getElementById("InputHeader").value,
		IncludedObjectNames: document.getElementById("InputIncludedObjectNames").value,
		Description: document.getElementById("InputDescription").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateCgm",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_CGM;
		PerformTrans( {
			Service: "CreateCgm",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateCgm() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		Id: document.getElementById("InputId").value,
		Header: document.getElementById("InputHeader").value,
		IncludedObjectNames: document.getElementById("InputIncludedObjectNames").value,
		Description: document.getElementById("InputDescription").value
	};
	PerformTrans( {
		Service: "UpdateCgm",
		Parameters: {
			Type
		}
	} );
}

function DeleteCgm() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		Id: document.getElementById("InputId").value
	};
	PerformTrans( {
		Service: "DeleteCgm",
		Parameters: {
			Type
		}
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/model_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('model','CubeGenExampleModel','CUBE_GEN_EXAMPLE_MODEL','_',-1)"> CUBE_GEN_EXAMPLE_MODEL</span></div>
<hr/>
<table>
<tr id="RowAtbFkCubName"><td><u><div>CubeGenDocumentation.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkCubName" type="text" maxlength="30" style="width:100%" onchange="ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbId"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('model','CubeGenExampleModel.Id','CUBE_GEN_EXAMPLE_MODEL','ID',-1)"><u><div>Id</div></u></td><td><div style="max-width:16em;"><input id="InputId" type="text" maxlength="16" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbHeader"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('model','CubeGenExampleModel.Header','CUBE_GEN_EXAMPLE_MODEL','HEADER',-1)"><div>Header</div></td><td><div style="max-width:40em;"><input id="InputHeader" type="text" maxlength="40" style="width:100%"></input></div></td></tr>
<tr id="RowAtbIncludedObjectNames"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('model','CubeGenExampleModel.IncludedObjectNames','CUBE_GEN_EXAMPLE_MODEL','INCLUDED_OBJECT_NAMES',-1)"><div>IncludedObjectNames</div></td><td><div style="max-width:120em;"><input id="InputIncludedObjectNames" type="text" maxlength="120" style="width:100%" onchange="ToUpperCase(this);"></input></div></td></tr>
<tr id="RowAtbDescription"><td><div style="padding-top:10px">Description</div></td></tr><tr><td colspan="2"><div><textarea id="InputDescription" type="text" maxlength="3999" rows="5" style="white-space:normal;width:100%"></textarea></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateCgm()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateCgm()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteCgm()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
