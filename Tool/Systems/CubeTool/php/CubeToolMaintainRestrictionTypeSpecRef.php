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
	if (g_xmlhttp.readyState == 4) {
		if (g_xmlhttp.status == 200) {
			var g_responseText = g_xmlhttp.responseText;
			try {
				var l_json_array = JSON.parse(g_responseText);
			}
			catch (err) {
				alert ('JSON parse error:\n'+g_responseText);
			}
			for (i in l_json_array) {
				switch (l_json_array[i].ResultName) {
					case "SELECT_RTR":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputIncludeOrExclude").value=l_json_values.IncludeOrExclude;
						break;
					case "CREATE_RTR":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkRefSequence").disabled=true;
						document.getElementById("InputFkRefBotName").disabled=true;
						document.getElementById("InputFkRefTypName").disabled=true;
						document.getElementById("InputXfTspTypName").disabled=true;
						document.getElementById("InputXfTspTsgCode").disabled=true;
						document.getElementById("InputXkTspCode").disabled=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkRefSequence:document.getElementById("InputFkRefSequence").value,FkRefBotName:document.getElementById("InputFkRefBotName").value,FkRefTypName:document.getElementById("InputFkRefTypName").value,XfTspTypName:document.getElementById("InputXfTspTypName").value,XfTspTsgCode:document.getElementById("InputXfTspTsgCode").value,XkTspCode:document.getElementById("InputXkTspCode").value};
						g_node_id = '{"TYP_RTR":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								if (l_json_array[i].Rows.length == 0) {
									var l_position = 'L';
									l_objNodePos = null;
								} else {
									var l_position = 'B';
									var l_objNodePos = parent.document.getElementById('{"TYP_RTR":'+JSON.stringify(l_json_array[i].Rows[0].Key)+'}');
								}
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_RTR',
									l_json_node_id,
									'icons/restrict.bmp',
									'RestrictionTypeSpecRef',
									document.getElementById("InputXfTspTypName").value.toLowerCase()+' '+document.getElementById("InputXfTspTsgCode").value.toLowerCase()+' '+document.getElementById("InputXkTspCode").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_RTR":
						break;
					case "DELETE_RTR":
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
						if (l_json_array[i].ResultName.substring(0,5) == 'LIST_') {
							switch (document.body._ListBoxCode){
								case "Ref001":
									OpenListBox(l_json_array[i].Rows,'typespec','TypeSpecialisation');
									break;
							}
						} else {
							alert ('Unknown reply:\n'+g_responseText);
						}
						
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
	document.body._ListBoxCode = "Ref000";
	document.body._ListBoxOptional = ' ';
	var l_json_objectKey = l_json_argument.objectId;
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_RTR.FkTypName;
		document.getElementById("InputFkRefSequence").value=l_json_objectKey.TYP_RTR.FkRefSequence;
		document.getElementById("InputFkRefBotName").value=l_json_objectKey.TYP_RTR.FkRefBotName;
		document.getElementById("InputFkRefTypName").value=l_json_objectKey.TYP_RTR.FkRefTypName;
		document.getElementById("InputXfTspTypName").value=l_json_objectKey.TYP_RTR.XfTspTypName;
		document.getElementById("InputXfTspTsgCode").value=l_json_objectKey.TYP_RTR.XfTspTsgCode;
		document.getElementById("InputXkTspCode").value=l_json_objectKey.TYP_RTR.XkTspCode;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetRtr",
			Parameters: {
				Type: l_json_objectKey.TYP_RTR
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkRefSequence").disabled=true;
		document.getElementById("InputFkRefBotName").disabled=true;
		document.getElementById("InputFkRefTypName").disabled=true;
		document.getElementById("InputXfTspTypName").disabled=true;
		document.getElementById("InputXfTspTsgCode").disabled=true;
		document.getElementById("InputXkTspCode").disabled=true;
		document.getElementById("RefSelect001").disabled=true;
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
	document.getElementById("InputIncludeOrExclude").value='IN';
}

function CreateRtr() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value,
		IncludeOrExclude: document.getElementById("InputIncludeOrExclude").value,
		XfTspTypName: document.getElementById("InputXfTspTypName").value,
		XfTspTsgCode: document.getElementById("InputXfTspTsgCode").value,
		XkTspCode: document.getElementById("InputXkTspCode").value
	};
	PerformTrans( {
		Service: "CreateRtr",
		Parameters: {
			Type
		}
	} );
}

function UpdateRtr() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value,
		IncludeOrExclude: document.getElementById("InputIncludeOrExclude").value,
		XfTspTypName: document.getElementById("InputXfTspTypName").value,
		XfTspTsgCode: document.getElementById("InputXfTspTsgCode").value,
		XkTspCode: document.getElementById("InputXkTspCode").value
	};
	PerformTrans( {
		Service: "UpdateRtr",
		Parameters: {
			Type
		}
	} );
}

function DeleteRtr() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value,
		XfTspTypName: document.getElementById("InputXfTspTypName").value,
		XfTspTsgCode: document.getElementById("InputXfTspTsgCode").value,
		XkTspCode: document.getElementById("InputXkTspCode").value
	};
	PerformTrans( {
		Service: "DeleteRtr",
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
	document.body._ListBoxOptional = 'N';
	var Parameters = {
		Option: {
			CubeScopeLevel:0
		},
		Ref: {
			FkTypName:document.getElementById("InputFkTypName").value,
			FkRefTypName:document.getElementById("InputFkRefTypName").value
		}
	};
	PerformTrans( {
		Service: "GetTspForTypList",
		Parameters
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/restrict_large.bmp" /><span> RESTRICTION_TYPE_SPEC_REF</span></div>
<hr/>
<table>
<tr id="RowAtbFkBotName"><td><div>BusinessObjectType.Name</div></td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkRefSequence"><td><u><div>Reference.Sequence</div></u></td><td><div style="max-width:2em;"><input id="InputFkRefSequence" type="text" maxlength="2" style="width:100%"></input></div></td></tr>
<tr id="RowAtbFkRefBotName"><td><u><div>BusinessObjectType.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkRefBotName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkRefTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkRefTypName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbIncludeOrExclude"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('restrict','RestrictionTypeSpecRef.IncludeOrExclude','RESTRICTION_TYPE_SPEC_REF','INCLUDE_OR_EXCLUDE',-1)"><div>IncludeOrExclude</div></td><td><div><select id="InputIncludeOrExclude" type="text">
	<option value=" " selected> </option>
	<option value="IN">Include</option>
	<option value="EX">Exclude</option>
</select></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefTypeSpecialisation0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/typespec.bmp"/> TypeSpecialisation (IsValidFor)</legend>
<table style="width:100%">
<tr><td><u>Type.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXfTspTypName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td><u>TypeSpecialisationGroup.Code</u></td><td style="width:100%"><div style="max-width:16em;"><input id="InputXfTspTsgCode" type="text" maxlength="16" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td></tr>
<tr><td><u>TypeSpecialisation.Code</u></td><td style="width:100%"><div style="max-width:16em;"><input id="InputXkTspCode" type="text" maxlength="16" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateRtr()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateRtr()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteRtr()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
