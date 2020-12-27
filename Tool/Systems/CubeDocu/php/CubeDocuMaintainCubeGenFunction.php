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
					case "SELECT_CGF":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkCubName").value=l_json_values.FkCubName;
						document.getElementById("InputFkCgmId").value=l_json_values.FkCgmId;
						document.getElementById("InputHeader").value=l_json_values.Header;
						document.getElementById("InputDescription").value=l_json_values.Description;
						document.getElementById("InputTemplate").value=l_json_values.Template;
						break;
					case "CREATE_CGF":
						document.getElementById("InputFkCubName").disabled=true;
						document.getElementById("InputFkCgmId").disabled=true;
						document.getElementById("InputId").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Id:document.getElementById("InputId").value};
						g_node_id = '{"TYP_CGF":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_CGF',
									l_json_node_id,
									'icons/template.bmp', 
									document.getElementById("InputHeader").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_CGF":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputHeader").value.toLowerCase();
					}
						break;
					case "DELETE_CGF":
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
		document.getElementById("InputId").value=l_json_objectKey.TYP_CGF.Id;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetCgf",
			Parameters: {
				Type: l_json_objectKey.TYP_CGF
			}
		} );
		document.getElementById("InputFkCubName").disabled=true;
		document.getElementById("InputFkCgmId").disabled=true;
		document.getElementById("InputId").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkCubName").value=l_json_objectKey.TYP_CGM.FkCubName;
		document.getElementById("InputFkCgmId").value=l_json_objectKey.TYP_CGM.Id;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkCubName").disabled=true;
		document.getElementById("InputFkCgmId").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateCgf() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		FkCgmId: document.getElementById("InputFkCgmId").value,
		Id: document.getElementById("InputId").value,
		Header: document.getElementById("InputHeader").value,
		Description: document.getElementById("InputDescription").value,
		Template: document.getElementById("InputTemplate").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateCgf",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_CGF;
		PerformTrans( {
			Service: "CreateCgf",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateCgf() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		FkCgmId: document.getElementById("InputFkCgmId").value,
		Id: document.getElementById("InputId").value,
		Header: document.getElementById("InputHeader").value,
		Description: document.getElementById("InputDescription").value,
		Template: document.getElementById("InputTemplate").value
	};
	PerformTrans( {
		Service: "UpdateCgf",
		Parameters: {
			Type
		}
	} );
}

function DeleteCgf() {
	var Type = {
		Id: document.getElementById("InputId").value
	};
	PerformTrans( {
		Service: "DeleteCgf",
		Parameters: {
			Type
		}
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/template_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('template','CubeGenFunction','CUBE_GEN_FUNCTION','_',-1)"> CUBE_GEN_FUNCTION</span></div>
<hr/>
<table>
<tr id="RowAtbFkCubName"><td><div>CubeGenDocumentation.Name</div></td><td><div style="max-width:30em;"><input id="InputFkCubName" type="text" maxlength="30" style="width:100%" onchange="ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkCgmId"><td><div>CubeGenExampleModel.Id</div></td><td><div style="max-width:16em;"><input id="InputFkCgmId" type="text" maxlength="16" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbId"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('template','CubeGenFunction.Id','CUBE_GEN_FUNCTION','ID',-1)"><u><div>Id</div></u></td><td><div style="max-width:16em;"><input id="InputId" type="text" maxlength="16" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbHeader"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('template','CubeGenFunction.Header','CUBE_GEN_FUNCTION','HEADER',-1)"><div>Header</div></td><td><div style="max-width:40em;"><input id="InputHeader" type="text" maxlength="40" style="width:100%"></input></div></td></tr>
<tr id="RowAtbDescription"><td><div style="padding-top:10px">Description</div></td></tr><tr><td colspan="2"><div><textarea id="InputDescription" type="text" maxlength="3999" rows="5" style="white-space:normal;width:100%"></textarea></div></td></tr>
<tr id="RowAtbTemplate"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('template','CubeGenFunction.Template','CUBE_GEN_FUNCTION','TEMPLATE',-1)"><div style="padding-top:10px">Template</div></td></tr><tr><td colspan="2"><div><textarea id="InputTemplate" type="text" maxlength="3999" rows="11" style="overflow:auto;white-space:pre;font-family:courier new;font-size:12px;width:100%"></textarea></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateCgf()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateCgf()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteCgf()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
