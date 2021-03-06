<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeInclude.js"></script>
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeDetailInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeSysInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeSysDetailInclude.js"></script>
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
					case "SELECT_CUBE_DSC":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputValue").value=l_json_values.Value;
						break;
					case "CREATE_CUBE_DSC":
						document.getElementById("InputTypeName").disabled=true;
						document.getElementById("InputAttributeTypeName").disabled=true;
						document.getElementById("InputSequence").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {TypeName:document.getElementById("InputTypeName").value,AttributeTypeName:document.getElementById("InputAttributeTypeName").value,Sequence:document.getElementById("InputSequence").value};
						g_node_id = '{"TYP_CUBE_DSC":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_CUBE_DSC',
									l_json_node_id,
									'icons/desc.bmp',
									'CubeDescription',
									document.getElementById("InputTypeName").value.toLowerCase()+' '+document.getElementById("InputAttributeTypeName").value.toLowerCase()+' '+document.getElementById("InputSequence").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_CUBE_DSC":
						break;
					case "DELETE_CUBE_DSC":
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
		document.getElementById("InputTypeName").value=l_json_objectKey.TYP_CUBE_DSC.TypeName;
		document.getElementById("InputAttributeTypeName").value=l_json_objectKey.TYP_CUBE_DSC.AttributeTypeName;
		document.getElementById("InputSequence").value=l_json_objectKey.TYP_CUBE_DSC.Sequence;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetCubeDsc",
			Parameters: {
				Type: l_json_objectKey.TYP_CUBE_DSC
			}
		} );
		document.getElementById("InputTypeName").disabled=true;
		document.getElementById("InputAttributeTypeName").disabled=true;
		document.getElementById("InputSequence").disabled=true;
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

function CreateCubeDsc() {
	var Type = {
		TypeName: document.getElementById("InputTypeName").value,
		AttributeTypeName: document.getElementById("InputAttributeTypeName").value,
		Sequence: document.getElementById("InputSequence").value,
		Value: document.getElementById("InputValue").value
	};
	PerformTrans( {
		Service: "CreateCubeDsc",
		Parameters: {
			Type
		}
	} );
}

function UpdateCubeDsc() {
	var Type = {
		TypeName: document.getElementById("InputTypeName").value,
		AttributeTypeName: document.getElementById("InputAttributeTypeName").value,
		Sequence: document.getElementById("InputSequence").value,
		Value: document.getElementById("InputValue").value
	};
	PerformTrans( {
		Service: "UpdateCubeDsc",
		Parameters: {
			Type
		}
	} );
}

function DeleteCubeDsc() {
	var Type = {
		TypeName: document.getElementById("InputTypeName").value,
		AttributeTypeName: document.getElementById("InputAttributeTypeName").value,
		Sequence: document.getElementById("InputSequence").value
	};
	PerformTrans( {
		Service: "DeleteCubeDsc",
		Parameters: {
			Type
		}
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/desc_large.bmp" /><span> CUBE_DESCRIPTION</span></div>
<hr/>
<table>
<tr id="RowAtbTypeName"><td><u><div>TypeName</div></u></td><td><div style="max-width:30em;"><input id="InputTypeName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbAttributeTypeName"><td><u><div>AttributeTypeName</div></u></td><td><div style="max-width:30em;"><input id="InputAttributeTypeName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbSequence"><td><u><div>Sequence</div></u></td><td><div style="max-width:2em;"><input id="InputSequence" type="text" maxlength="2" style="width:100%"></input></div></td></tr>
<tr id="RowAtbValue"><td><div style="padding-top:10px">Value</div></td></tr><tr><td colspan="2"><div><textarea id="InputValue" type="text" maxlength="3999" rows="5" style="white-space:normal;width:100%"></textarea></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateCubeDsc()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateCubeDsc()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteCubeDsc()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
