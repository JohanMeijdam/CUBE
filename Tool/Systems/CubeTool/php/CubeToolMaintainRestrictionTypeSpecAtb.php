<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeInclude.js?filever=<?=filemtime('../CubeGeneral/CubeInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeDetailInclude.js?filever=<?=filemtime('../CubeGeneral/CubeDetailInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeToolInclude.js?filever=<?=filemtime('CubeToolInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeToolDetailInclude.js?filever=<?=filemtime('CubeToolDetailInclude.js')?>"></script>
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
					case "SELECT_RTA":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputIncludeOrExclude").value=l_json_values.IncludeOrExclude;
						break;
					case "CREATE_RTA":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkAtbName").disabled=true;
						document.getElementById("InputXfTspTypName").disabled=true;
						document.getElementById("InputXfTspTsgCode").disabled=true;
						document.getElementById("InputXkTspCode").disabled=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkAtbName:document.getElementById("InputFkAtbName").value,XfTspTypName:document.getElementById("InputXfTspTypName").value,XfTspTsgCode:document.getElementById("InputXfTspTsgCode").value,XkTspCode:document.getElementById("InputXkTspCode").value};
						g_node_id = '{"TYP_RTA":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								if (l_json_array[i].Rows.length == 0) {
									var l_position = 'L';
									l_objNodePos = null;
								} else {
									var l_position = 'B';
									var l_objNodePos = parent.document.getElementById('{"TYP_RTA":'+JSON.stringify(l_json_array[i].Rows[0].Key)+'}');
								}
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_RTA',
									l_json_node_id,
									'icons/restrict.bmp',
									'RestrictionTypeSpecAtb',
									document.getElementById("InputXfTspTypName").value.toLowerCase()+' '+document.getElementById("InputXfTspTsgCode").value.toLowerCase()+' '+document.getElementById("InputXkTspCode").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateRta()};						
						ResetChangePending();
						break;
					case "UPDATE_RTA":
						ResetChangePending();
						break;
					case "DELETE_RTA":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (g_parent_node_id == null) {
							g_parent_node_id = l_objNode.parentNode.parentNode.id;
						} 
						if (l_objNode != null) {
							l_objNode.parentNode.removeChild(l_objNode);
						}
						CancelChangePending();
						break;
					case "SELECT_FKEY_ATB":
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

function CreateRta() {
	if (document.getElementById("InputFkTypName").value == '') {
		alert ('Error: Primary key FkTypName not filled');
		return;
	}
	if (document.getElementById("InputFkAtbName").value == '') {
		alert ('Error: Primary key FkAtbName not filled');
		return;
	}
	if (document.getElementById("InputXfTspTypName").value == '') {
		alert ('Error: Primary key XfTspTypName not filled');
		return;
	}
	if (document.getElementById("InputXfTspTsgCode").value == '') {
		alert ('Error: Primary key XfTspTsgCode not filled');
		return;
	}
	if (document.getElementById("InputXkTspCode").value == '') {
		alert ('Error: Primary key XkTspCode not filled');
		return;
	}
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkAtbName: document.getElementById("InputFkAtbName").value,
		IncludeOrExclude: document.getElementById("InputIncludeOrExclude").value,
		XfTspTypName: document.getElementById("InputXfTspTypName").value,
		XfTspTsgCode: document.getElementById("InputXfTspTsgCode").value,
		XkTspCode: document.getElementById("InputXkTspCode").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "CreateRta",
		Parameters: {
			Type
		}
	} );
}

function UpdateRta() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkAtbName: document.getElementById("InputFkAtbName").value,
		IncludeOrExclude: document.getElementById("InputIncludeOrExclude").value,
		XfTspTypName: document.getElementById("InputXfTspTypName").value,
		XfTspTsgCode: document.getElementById("InputXfTspTsgCode").value,
		XkTspCode: document.getElementById("InputXkTspCode").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "UpdateRta",
		Parameters: {
			Type
		}
	} );
}

function DeleteRta() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkAtbName: document.getElementById("InputFkAtbName").value,
		XfTspTypName: document.getElementById("InputXfTspTypName").value,
		XfTspTsgCode: document.getElementById("InputXfTspTsgCode").value,
		XkTspCode: document.getElementById("InputXkTspCode").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "DeleteRta",
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
	SetChangePending();
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
			FkTypName:document.getElementById("InputFkTypName").value
		}
	};
	PerformTrans('BusinessObjectType', {
		Service: "GetTspForTypList",
		Parameters
	} );
}

function InitBody() {
	parent.g_change_pending = 'N';
	var l_json_argument = JSON.parse(decodeURIComponent(location.href.split("?")[1]));
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	document.body._ListBoxCode = "Ref000";
	document.body._ListBoxOptional = ' ';
	var l_json_objectKey = l_json_argument.objectId;
	switch (l_json_argument.nodeType) {
	case "D": // Details of existing object 
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_RTA.FkTypName;
		document.getElementById("InputFkAtbName").value = l_json_objectKey.TYP_RTA.FkAtbName;
		document.getElementById("InputXfTspTypName").value = l_json_objectKey.TYP_RTA.XfTspTypName;
		document.getElementById("InputXfTspTsgCode").value = l_json_objectKey.TYP_RTA.XfTspTsgCode;
		document.getElementById("InputXkTspCode").value = l_json_objectKey.TYP_RTA.XkTspCode;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateRta()};
		PerformTrans('BusinessObjectType', {
			Service: "GetRta",
			Parameters: {
				Type: l_json_objectKey.TYP_RTA
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkAtbName").disabled = true;
		document.getElementById("InputXfTspTypName").disabled = true;
		document.getElementById("InputXfTspTsgCode").disabled = true;
		document.getElementById("InputXkTspCode").disabled = true;
		document.getElementById("RefSelect001").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_ATB.FkTypName;
		document.getElementById("InputFkAtbName").value = l_json_objectKey.TYP_ATB.Name;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateRta()};
		PerformTrans('BusinessObjectType', {
			Service: "GetAtbFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_ATB
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkAtbName").disabled = true;
		document.getElementById("InputIncludeOrExclude").value='IN';
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_RTA.FkTypName;
		document.getElementById("InputFkAtbName").value = l_json_objectKey.TYP_RTA.FkAtbName;
		document.getElementById("InputXfTspTypName").value = l_json_objectKey.TYP_RTA.XfTspTypName;
		document.getElementById("InputXfTspTsgCode").value = l_json_objectKey.TYP_RTA.XfTspTsgCode;
		document.getElementById("InputXkTspCode").value = l_json_objectKey.TYP_RTA.XkTspCode;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteRta()};
		SetChangePending();
		PerformTrans('BusinessObjectType', {
			Service: "GetRta",
			Parameters: {
				Type: l_json_objectKey.TYP_RTA
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkAtbName").disabled = true;
		document.getElementById("InputIncludeOrExclude").disabled = true;
		document.getElementById("InputXfTspTypName").disabled = true;
		document.getElementById("InputXfTspTsgCode").disabled = true;
		document.getElementById("InputXkTspCode").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/restrict_large.bmp" /><span> RESTRICTION_TYPE_SPEC_ATB</span></div>
<hr/>
<table>
<tr id="RowAtbFkBotName"><td><div>BusinessObjectType.Name</div></td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkAtbName"><td><u><div>Attribute.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkAtbName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbIncludeOrExclude"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('restrict','RestrictionTypeSpecAtb.IncludeOrExclude','RESTRICTION_TYPE_SPEC_ATB','INCLUDE_OR_EXCLUDE',-1)"><div>IncludeOrExclude</div></td><td><div><select id="InputIncludeOrExclude" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionIncludeOrExclude-IN" style="display:inline" value="IN">Include</option>
	<option id="OptionIncludeOrExclude-EX" style="display:inline" value="EX">Exclude</option>
</select></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefTypeSpecialisation0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/typespec.bmp"/> TypeSpecialisation (IsValidFor)</legend>
<table style="width:100%">
<tr><td><u>Type.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXfTspTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td><u>TypeSpecialisationGroup.Code</u></td><td style="width:100%"><div style="max-width:16em;"><input id="InputXfTspTsgCode" type="text" maxlength="16" style="width:100%" disabled></input></div></td></tr>
<tr><td><u>TypeSpecialisation.Code</u></td><td style="width:100%"><div style="max-width:16em;"><input id="InputXkTspCode" type="text" maxlength="16" style="width:100%" disabled></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
