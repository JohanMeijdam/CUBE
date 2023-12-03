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
					case "SEL_SRV":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputClass").value=l_json_values.Class;
						document.getElementById("InputAccessibility").value=l_json_values.Accessibility;
						ProcessTypeSpecialisation();
						break;
					case "CRE_SRV":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputName").disabled=true;
						document.getElementById("InputCubeTsgDbScr").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,Name:document.getElementById("InputName").value,CubeTsgDbScr:document.getElementById("InputCubeTsgDbScr").value};
						g_node_id = '{"TYP_SRV":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_SRV',
									l_json_node_id,
									'icons/service.bmp',
									'Service',
									document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCubeTsgDbScr").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateSrv()};						
						ResetChangePending();
						break;
					case "UPD_SRV":
						ResetChangePending();
						break;
					case "DEL_SRV":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (g_parent_node_id == null) {
							g_parent_node_id = l_objNode.parentNode.parentNode.id;
						} 
						if (l_objNode != null) {
							l_objNode.parentNode.removeChild(l_objNode);
						}
						CancelChangePending();
						break;
					case "SEL_FKEY_TYP":
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

function CreateSrv() {
	if (document.getElementById("InputFkTypName").value == '') {
		alert ('Error: Primary key FkTypName not filled');
		return;
	}
	if (document.getElementById("InputName").value == '') {
		alert ('Error: Primary key Name not filled');
		return;
	}
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		CubeTsgDbScr: document.getElementById("InputCubeTsgDbScr").value,
		Class: document.getElementById("InputClass").value,
		Accessibility: document.getElementById("InputAccessibility").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans('BusinessObjectType', {
			Service: "CreateSrv",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_SRV;
		PerformTrans('BusinessObjectType', {
			Service: "CreateSrv",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateSrv() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		CubeTsgDbScr: document.getElementById("InputCubeTsgDbScr").value,
		Class: document.getElementById("InputClass").value,
		Accessibility: document.getElementById("InputAccessibility").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "UpdateSrv",
		Parameters: {
			Type
		}
	} );
}

function DeleteSrv() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		CubeTsgDbScr: document.getElementById("InputCubeTsgDbScr").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "DeleteSrv",
		Parameters: {
			Type
		}
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
	g_json_option = l_json_argument.Option;
	switch (l_json_argument.nodeType) {
	case "D": // Details of existing object 
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_SRV.FkTypName;
		document.getElementById("InputName").value = l_json_objectKey.TYP_SRV.Name;
		document.getElementById("InputCubeTsgDbScr").value = l_json_objectKey.TYP_SRV.CubeTsgDbScr;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateSrv()};
		PerformTrans('BusinessObjectType', {
			Service: "GetSrv",
			Parameters: {
				Type: l_json_objectKey.TYP_SRV
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputCubeTsgDbScr").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_TYP.Name;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateSrv()};
		PerformTrans('BusinessObjectType', {
			Service: "GetTypFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_TYP
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_SRV.FkTypName;
		document.getElementById("InputName").value = l_json_objectKey.TYP_SRV.Name;
		document.getElementById("InputCubeTsgDbScr").value = l_json_objectKey.TYP_SRV.CubeTsgDbScr;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteSrv()};
		SetChangePending();
		PerformTrans('BusinessObjectType', {
			Service: "GetSrv",
			Parameters: {
				Type: l_json_objectKey.TYP_SRV
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeSequence").disabled = true;
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputCubeTsgDbScr").disabled = true;
		document.getElementById("InputClass").disabled = true;
		document.getElementById("InputAccessibility").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgDbScr").value != ' ') {
		document.getElementById("InputCubeTsgDbScr").disabled = true;
		switch (document.getElementById("InputCubeTsgDbScr").value) {
		case "S":
			document.getElementById("RowAtbClass").style.display = "none";
			break;
		}
		document.getElementById("TableMain").style.display = "inline";
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/service_large.bmp" /><span> SERVICE /
<select id="InputCubeTsgDbScr" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;db_scr&gt;</option>
	<option id="OptionCubeTsgDbScr-D" style="display:inline" value="D">DATABASE_INTERACTION</option>
	<option id="OptionCubeTsgDbScr-S" style="display:inline" value="S">SERVER_SCRIPT</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr id="RowAtbFkBotName"><td><div>BusinessObjectType.Name</div></td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbName"><td><u><div>Name</div></u></td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbClass"><td><div>Class</div></td><td><div><select id="InputClass" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionClass-LST" style="display:inline" value="LST">List</option>
	<option id="OptionClass-CNT" style="display:inline" value="CNT">Count</option>
	<option id="OptionClass-SEL" style="display:inline" value="SEL">Select</option>
	<option id="OptionClass-CNP" style="display:inline" value="CNP">Check no part</option>
	<option id="OptionClass-DPO" style="display:inline" value="DPO">Determine position</option>
	<option id="OptionClass-MOV" style="display:inline" value="MOV">Move</option>
	<option id="OptionClass-GTN" style="display:inline" value="GTN">Get next</option>
	<option id="OptionClass-CPA" style="display:inline" value="CPA">Change parent</option>
	<option id="OptionClass-CRE" style="display:inline" value="CRE">Create</option>
	<option id="OptionClass-UPD" style="display:inline" value="UPD">Update</option>
	<option id="OptionClass-DEL" style="display:inline" value="DEL">Delete</option>
</select></div></td></tr>
<tr id="RowAtbAccessibility"><td><div>Accessibility</div></td><td><div><select id="InputAccessibility" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionAccessibility-I" style="display:inline" value="I">Internal</option>
	<option id="OptionAccessibility-E" style="display:inline" value="E">External</option>
	<option id="OptionAccessibility-U" style="display:inline" value="U">User</option>
</select></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
