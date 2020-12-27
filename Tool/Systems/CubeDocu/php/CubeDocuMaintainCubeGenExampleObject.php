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
					case "SELECT_CGO":
						var l_json_values = l_json_array[i].Rows[0].Data;
						break;
					case "CREATE_CGO":
						document.getElementById("InputFkCubName").disabled=true;
						document.getElementById("InputFkCgmId").disabled=true;
						document.getElementById("InputXkBotName").disabled=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkCubName:document.getElementById("InputFkCubName").value,FkCgmId:document.getElementById("InputFkCgmId").value,XkBotName:document.getElementById("InputXkBotName").value};
						g_node_id = '{"TYP_CGO":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_CGO',
									l_json_node_id,
									'icons/botype.bmp', 
									document.getElementById("InputXkBotName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_CGO":
						break;
					case "DELETE_CGO":
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
					case "LIST_BOT":
						OpenListBox(l_json_array[i].Rows,'botype','BusinessObjectType','N');
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
		document.getElementById("InputFkCubName").value=l_json_objectKey.TYP_CGO.FkCubName;
		document.getElementById("InputFkCgmId").value=l_json_objectKey.TYP_CGO.FkCgmId;
		document.getElementById("InputXkBotName").value=l_json_objectKey.TYP_CGO.XkBotName;
		document.getElementById("ButtonCreate").disabled=true;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("InputFkCubName").disabled=true;
		document.getElementById("InputFkCgmId").disabled=true;
		document.getElementById("InputXkBotName").disabled=true;
		document.getElementById("RefSelect001").disabled=true;
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

function CreateCgo() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		FkCgmId: document.getElementById("InputFkCgmId").value,
		XkBotName: document.getElementById("InputXkBotName").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateCgo",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_CGO;
		PerformTrans( {
			Service: "CreateCgo",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateCgo() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		FkCgmId: document.getElementById("InputFkCgmId").value,
		XkBotName: document.getElementById("InputXkBotName").value
	};
	PerformTrans( {
		Service: "UpdateCgo",
		Parameters: {
			Type
		}
	} );
}

function DeleteCgo() {
	var Type = {
		FkCubName: document.getElementById("InputFkCubName").value,
		FkCgmId: document.getElementById("InputFkCgmId").value,
		XkBotName: document.getElementById("InputXkBotName").value
	};
	PerformTrans( {
		Service: "DeleteCgo",
		Parameters: {
			Type
		}
	} );
}

function UpdateForeignKey(p_obj) {
	var l_values = p_obj.options[p_obj.selectedIndex].value;
	if (l_values != '') {
		var l_json_values = JSON.parse(l_values);
	}
	switch (document.body._ListBoxCode){
	case "Ref001":
		if (l_values == '') {
			document.getElementById("InputXkBotName").value = '';
		} else {
			document.getElementById("InputXkBotName").value = l_json_values.Name;
		}
		break;
	default:
		alert ('Error Listbox: '+document.body._ListBoxCode);
	}
	CloseListBox();
}

function StartSelect001(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref001';
	PerformTrans( {
		Service: "GetBotList"
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/botype_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('botype','CubeGenExampleObject','CUBE_GEN_EXAMPLE_OBJECT','_',-1)"> CUBE_GEN_EXAMPLE_OBJECT</span></div>
<hr/>
<table>
<tr id="RowAtbFkCubName"><td><u><div>CubeGenDocumentation.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkCubName" type="text" maxlength="30" style="width:100%" onchange="ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkCgmId"><td><u><div>CubeGenExampleModel.Id</div></u></td><td><div style="max-width:16em;"><input id="InputFkCgmId" type="text" maxlength="16" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefBusinessObjectType0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/botype.bmp"/> BusinessObjectType (UsesAsExample)</legend>
<table style="width:100%">
<tr><td><u>BusinessObjectType.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkBotName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateCgo()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateCgo()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteCgo()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
