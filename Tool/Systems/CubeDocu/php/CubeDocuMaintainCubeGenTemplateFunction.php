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
					case "SELECT_CTF":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputDescription").value=l_json_values.Description;
						document.getElementById("InputSyntax").value=l_json_values.Syntax;
						break;
					case "CREATE_CTF":
						document.getElementById("InputFkCubName").disabled=true;
						document.getElementById("InputName").disabled=true;
						document.getElementById("InputIndicationLogical").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkCubName:document.getElementById("InputFkCubName").value,Name:document.getElementById("InputName").value,IndicationLogical:document.getElementById("InputIndicationLogical").value};
						g_node_id = '{"TYP_CTF":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								if (l_json_array[i].Rows.length == 0) {
									var l_position = 'L';
									l_objNodePos = null;
								} else {
									var l_position = 'B';
									var l_objNodePos = parent.document.getElementById('{"TYP_CTF":'+JSON.stringify(l_json_array[i].Rows[0].Key)+'}');
								}
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_CTF',
									l_json_node_id,
									'icons/function.bmp', 
									document.getElementById("InputName").value.toLowerCase()+' '+document.getElementById("InputIndicationLogical").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_CTF":
						break;
					case "DELETE_CTF":
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
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkCubName").value=l_json_objectKey.TYP_CTF.FkCubName;
		document.getElementById("InputName").value=l_json_objectKey.TYP_CTF.Name;
		document.getElementById("InputIndicationLogical").value=l_json_objectKey.TYP_CTF.IndicationLogical;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetCtf",
			Parameters: {
				Type: l_json_objectKey.TYP_CTF
			}
		} );
		document.getElementById("InputFkCubName").disabled=true;
		document.getElementById("InputName").disabled=true;
		document.getElementById("InputIndicationLogical").disabled=true;
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

function CreateCtf() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		Name: document.getElementById("InputName").value,
		IndicationLogical: document.getElementById("InputIndicationLogical").value,
		Description: document.getElementById("InputDescription").value,
		Syntax: document.getElementById("InputSyntax").value
	};
	PerformTrans( {
		Service: "CreateCtf",
		Parameters: {
			Type
		}
	} );
}

function UpdateCtf() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		Name: document.getElementById("InputName").value,
		IndicationLogical: document.getElementById("InputIndicationLogical").value,
		Description: document.getElementById("InputDescription").value,
		Syntax: document.getElementById("InputSyntax").value
	};
	PerformTrans( {
		Service: "UpdateCtf",
		Parameters: {
			Type
		}
	} );
}

function DeleteCtf() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		Name: document.getElementById("InputName").value,
		IndicationLogical: document.getElementById("InputIndicationLogical").value
	};
	PerformTrans( {
		Service: "DeleteCtf",
		Parameters: {
			Type
		}
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/function_large.bmp" /><span> CUBE_GEN_TEMPLATE_FUNCTION</span></div>
<hr/>
<table>
<tr id="RowAtbFkCubName"><td><u><div>CubeGenDocumentation.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkCubName" type="text" maxlength="30" style="width:100%" onchange="ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbName"><td><u><div>Name</div></u></td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%" onchange="ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbIndicationLogical"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('function','CubeGenTemplateFunction.IndicationLogical','CUBE_GEN_TEMPLATE_FUNCTION','INDICATION_LOGICAL',-1)"><u><div>IndicationLogical</div></u></td><td><div><select id="InputIndicationLogical" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbDescription"><td><div style="padding-top:10px">Description</div></td></tr><tr><td colspan="2"><div><textarea id="InputDescription" type="text" maxlength="3999" rows="5" style="white-space:normal;width:100%"></textarea></div></td></tr>
<tr id="RowAtbSyntax"><td><div style="padding-top:10px">Syntax</div></td></tr><tr><td colspan="2"><div><textarea id="InputSyntax" type="text" maxlength="3999" rows="11" style="overflow:auto;white-space:pre;font-family:courier new;font-size:12px;width:100%"></textarea></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateCtf()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateCtf()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteCtf()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
