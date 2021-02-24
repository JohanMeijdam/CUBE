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
					case "SELECT_DCR":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputText").value=l_json_values.Text;
						break;
					case "CREATE_DCR":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkRefSequence").disabled=true;
						document.getElementById("InputFkRefBotName").disabled=true;
						document.getElementById("InputFkRefTypName").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkRefSequence:document.getElementById("InputFkRefSequence").value,FkRefBotName:document.getElementById("InputFkRefBotName").value,FkRefTypName:document.getElementById("InputFkRefTypName").value};
						g_node_id = '{"TYP_DCR":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_DCR',
									l_json_node_id,
									'icons/desc.bmp',
									'DescriptionReference',
									' ',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_DCR":
						break;
					case "DELETE_DCR":
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
					case "SELECT_FKEY_REF":
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
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_DCR.FkTypName;
		document.getElementById("InputFkRefSequence").value=l_json_objectKey.TYP_DCR.FkRefSequence;
		document.getElementById("InputFkRefBotName").value=l_json_objectKey.TYP_DCR.FkRefBotName;
		document.getElementById("InputFkRefTypName").value=l_json_objectKey.TYP_DCR.FkRefTypName;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetDcr",
			Parameters: {
				Type: l_json_objectKey.TYP_DCR
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkRefSequence").disabled=true;
		document.getElementById("InputFkRefBotName").disabled=true;
		document.getElementById("InputFkRefTypName").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_REF.FkTypName;
		document.getElementById("InputFkRefSequence").value=l_json_objectKey.TYP_REF.Sequence;
		document.getElementById("InputFkRefBotName").value=l_json_objectKey.TYP_REF.XkBotName;
		document.getElementById("InputFkRefTypName").value=l_json_objectKey.TYP_REF.XkTypName;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		PerformTrans( {
			Service: "GetRefFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_REF
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkRefSequence").disabled=true;
		document.getElementById("InputFkRefBotName").disabled=true;
		document.getElementById("InputFkRefTypName").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateDcr() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value,
		Text: document.getElementById("InputText").value
	};
	PerformTrans( {
		Service: "CreateDcr",
		Parameters: {
			Type
		}
	} );
}

function UpdateDcr() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value,
		Text: document.getElementById("InputText").value
	};
	PerformTrans( {
		Service: "UpdateDcr",
		Parameters: {
			Type
		}
	} );
}

function DeleteDcr() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value
	};
	PerformTrans( {
		Service: "DeleteDcr",
		Parameters: {
			Type
		}
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/desc_large.bmp" /><span> DESCRIPTION_REFERENCE</span></div>
<hr/>
<table>
<tr id="RowAtbFkBotName"><td><div>BusinessObjectType.Name</div></td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkRefSequence"><td><u><div>Reference.Sequence</div></u></td><td><div style="max-width:2em;"><input id="InputFkRefSequence" type="text" maxlength="2" style="width:100%"></input></div></td></tr>
<tr id="RowAtbFkRefBotName"><td><u><div>BusinessObjectType.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkRefBotName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkRefTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkRefTypName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbText"><td><div style="padding-top:10px">Text</div></td></tr><tr><td colspan="2"><div><textarea id="InputText" type="text" maxlength="3999" rows="5" style="white-space:normal;width:100%"></textarea></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateDcr()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateDcr()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteDcr()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
