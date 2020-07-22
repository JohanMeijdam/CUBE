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
					case "SELECT_TSP":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputName").value=l_json_values.Name;
						document.getElementById("InputXfTspTypName").value=l_json_values.XfTspTypName;
						document.getElementById("InputXfTspTsgCode").value=l_json_values.XfTspTsgCode;
						document.getElementById("InputXkTspCode").value=l_json_values.XkTspCode;
						break;
					case "CREATE_TSP":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkTsgCode").disabled=true;
						document.getElementById("InputCode").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkTsgCode:document.getElementById("InputFkTsgCode").value,Code:document.getElementById("InputCode").value};
						g_node_id = '{"TYP_TSP":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_TSP',
									l_json_node_id,
									'icons/typespec.bmp', 
									'('+document.getElementById("InputCode").value.toLowerCase()+')'+' '+document.getElementById("InputName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_TSP":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+'('+document.getElementById("InputCode").value.toLowerCase()+')'+' '+document.getElementById("InputName").value.toLowerCase();
					}
						break;
					case "DELETE_TSP":
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
					case "LIST_TSP":
						OpenListBox(l_json_array[i].Rows,'typespec','TypeSpecialisation','Y');
						break;
					case "SELECT_FKEY_TSG":
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
	g_json_option = l_json_argument.Option;
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_TSP.FkTypName;
		document.getElementById("InputFkTsgCode").value=l_json_objectKey.TYP_TSP.FkTsgCode;
		document.getElementById("InputCode").value=l_json_objectKey.TYP_TSP.Code;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetTsp",
			Parameters: {
				Type: l_json_objectKey.TYP_TSP
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkTsgCode").disabled=true;
		document.getElementById("InputCode").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_TSG.FkTypName;
		document.getElementById("InputFkTsgCode").value=l_json_objectKey.TYP_TSG.Code;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		PerformTrans( {
			Service: "GetTsgFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_TSG
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkTsgCode").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateTsp() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkTsgCode: document.getElementById("InputFkTsgCode").value,
		Code: document.getElementById("InputCode").value,
		Name: document.getElementById("InputName").value,
		XfTspTypName: document.getElementById("InputXfTspTypName").value,
		XfTspTsgCode: document.getElementById("InputXfTspTsgCode").value,
		XkTspCode: document.getElementById("InputXkTspCode").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateTsp",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_TSP;
		PerformTrans( {
			Service: "CreateTsp",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateTsp() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkTsgCode: document.getElementById("InputFkTsgCode").value,
		Code: document.getElementById("InputCode").value,
		Name: document.getElementById("InputName").value,
		XfTspTypName: document.getElementById("InputXfTspTypName").value,
		XfTspTsgCode: document.getElementById("InputXfTspTsgCode").value,
		XkTspCode: document.getElementById("InputXkTspCode").value
	};
	PerformTrans( {
		Service: "UpdateTsp",
		Parameters: {
			Type
		}
	} );
}

function DeleteTsp() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkTsgCode: document.getElementById("InputFkTsgCode").value,
		Code: document.getElementById("InputCode").value
	};
	PerformTrans( {
		Service: "DeleteTsp",
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
			document.getElementById("InputXfTspTypName").value = '';
		} else {
			document.getElementById("InputXfTspTypName").value = l_json_values.FkTypName;
		}
		if (l_values == '') {
			document.getElementById("InputXfTspTsgCode").value = '';
		} else {
			document.getElementById("InputXfTspTsgCode").value = l_json_values.FkTsgCode;
		}
		if (l_values == '') {
			document.getElementById("InputXkTspCode").value = '';
		} else {
			document.getElementById("InputXkTspCode").value = l_json_values.Code;
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
	var Parameters = {
		Option: {
			CubeScopeLevel:1
		},
		Ref: {
			FkTypName:document.getElementById("InputFkTypName").value,
			FkTsgCode:document.getElementById("InputFkTsgCode").value
		}
	};
	PerformTrans( {
		Service: "GetTspForTsgList",
		Parameters
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/typespec_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('TYPESPEC','TypeSpecialisation','TYPE_SPECIALISATION','_',-1)"> TYPE_SPECIALISATION</span></div>
<hr/>
<table>
<tr><td>BusinessObjectType.Name</td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Type.Name</u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>TypeSpecialisationGroup.Code</u></td><td><div style="max-width:16em;"><input id="InputFkTsgCode" type="text" maxlength="16" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Code</u></td><td><div style="max-width:16em;"><input id="InputCode" type="text" maxlength="16" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Name</td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefTypeSpecialisation0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/typespec.bmp"/> TypeSpecialisation (Specialise)</legend>
<table style="width:100%;">
<tr><td>Type.Name</td><td style="width:100%;"><div style="max-width:30em;"><input id="InputXfTspTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td>TypeSpecialisationGroup.Code</td><td style="width:100%;"><div style="max-width:16em;"><input id="InputXfTspTsgCode" type="text" maxlength="16" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td></tr>
<tr><td>TypeSpecialisation.Code</td><td style="width:100%;"><div style="max-width:16em;"><input id="InputXkTspCode" type="text" maxlength="16" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateTsp()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateTsp()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteTsp()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
