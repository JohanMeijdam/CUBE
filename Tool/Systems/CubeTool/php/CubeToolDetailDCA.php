<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeInclude.js"></script>
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeDetailInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeToolInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeToolDetailInclude.js"></script>
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
					case "SELECT_DCA":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputText").value=l_json_values.Text;
						break;
					case "CREATE_DCA":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkAtbName").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkAtbName:document.getElementById("InputFkAtbName").value};
						g_node_id = '{"TYP_DCA":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_DCA',
									l_json_node_id,
									'icons/desc.bmp', 
									' ',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_DCA":
						break;
					case "DELETE_DCA":
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
					case "SELECT_FKEY_ATB":
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

function InitBody() {
	var l_json_argument = JSON.parse(decodeURIComponent(location.href.split("?")[1]));
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	document.body._ListBoxCode="Ref000";
	var l_json_objectKey = l_json_argument.objectId;
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_DCA.FkTypName;
		document.getElementById("InputFkAtbName").value=l_json_objectKey.TYP_DCA.FkAtbName;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetDca",
			Parameters: {
				Type: l_json_objectKey.TYP_DCA
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkAtbName").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_ATB.FkTypName;
		document.getElementById("InputFkAtbName").value=l_json_objectKey.TYP_ATB.Name;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		PerformTrans( {
			Service: "GetAtbFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_ATB
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkAtbName").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateDca() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkAtbName: document.getElementById("InputFkAtbName").value,
		Text: document.getElementById("InputText").value
	};
	PerformTrans( {
		Service: "CreateDca",
		Parameters: {
			Type
		}
	} );
}

function UpdateDca() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkAtbName: document.getElementById("InputFkAtbName").value,
		Text: document.getElementById("InputText").value
	};
	PerformTrans( {
		Service: "UpdateDca",
		Parameters: {
			Type
		}
	} );
}

function DeleteDca() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkAtbName: document.getElementById("InputFkAtbName").value
	};
	PerformTrans( {
		Service: "DeleteDca",
		Parameters: {
			Type
		}
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/desc_large.bmp" /><span> DESCRIPTION_ATTRIBUTE</span></div>
<hr/>
<table>
<tr><td>BusinessObjectType.Name</td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Type.Name</u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Attribute.Name</u></td><td><div style="max-width:30em;"><input id="InputFkAtbName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td style="padding-top:10px;">Text</td></tr><tr><td colspan="2"><div><textarea id="InputText" type="text" maxlength="3999" rows="5" style="white-space:normal;width:100%;"></textarea></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateDca()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateDca()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteDca()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
