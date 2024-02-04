<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeInclude.js?filever=<?=filemtime('../CubeGeneral/CubeInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeDetailInclude.js?filever=<?=filemtime('../CubeGeneral/CubeDetailInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeRootInclude.js?filever=<?=filemtime('CubeRootInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeRootDetailInclude.js?filever=<?=filemtime('CubeRootDetailInclude.js')?>"></script>
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
					case "SEL_SVA":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputCubeTsgSvaType").value=l_json_values.CubeTsgSvaType;
						document.getElementById("InputInputOrOutput").value=l_json_values.InputOrOutput;
						document.getElementById("InputXkItpName").value=l_json_values.XkItpName;
						document.getElementById("InputXkRefBotName").value=l_json_values.XkRefBotName;
						document.getElementById("InputXkRefTypName").value=l_json_values.XkRefTypName;
						document.getElementById("InputXfRefTypName").value=l_json_values.XfRefTypName;
						document.getElementById("InputXkRefSequence").value=l_json_values.XkRefSequence;
						ProcessTypeSpecialisation();
						break;
					case "CRE_SVA":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkSrvName").disabled=true;
						document.getElementById("InputFkSrvCubeTsgDbScr").disabled=true;
						document.getElementById("InputOptionName").disabled=true;
						document.getElementById("InputXfAtbTypName").disabled=true;
						document.getElementById("InputXkAtbName").disabled=true;
						document.getElementById("RefSelect002").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkSrvName:document.getElementById("InputFkSrvName").value,FkSrvCubeTsgDbScr:document.getElementById("InputFkSrvCubeTsgDbScr").value,OptionName:document.getElementById("InputOptionName").value,XfAtbTypName:document.getElementById("InputXfAtbTypName").value,XkAtbName:document.getElementById("InputXkAtbName").value};
						g_node_id = '{"TYP_SVA":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_SVA',
									l_json_node_id,
									'icons/servarg.bmp',
									'ServiceArgument',
									'('+document.getElementById("InputCubeTsgSvaType").value.toLowerCase()+')'+' '+document.getElementById("InputXfAtbTypName").value.toLowerCase()+' '+document.getElementById("InputXkAtbName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateSva()};						
						ResetChangePending();
						break;
					case "UPD_SVA":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+'('+document.getElementById("InputCubeTsgSvaType").value.toLowerCase()+')'+' '+document.getElementById("InputXfAtbTypName").value.toLowerCase()+' '+document.getElementById("InputXkAtbName").value.toLowerCase();
						}
						ResetChangePending();
						break;
					case "DEL_SVA":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (g_parent_node_id == null) {
							g_parent_node_id = l_objNode.parentNode.parentNode.id;
						} 
						if (l_objNode != null) {
							l_objNode.parentNode.removeChild(l_objNode);
						}
						CancelChangePending();
						break;
					case "SEL_FKEY_SRV":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						break;
					case "ERROR":
						alert ('Server error:\n'+l_json_array[i].ErrorText);
						break;
					default:
						if (l_json_array[i].ResultName.substring(0,4) == 'LST_') {
							switch (document.body._ListBoxCode){
								case "Ref001":
									OpenListBox(l_json_array[i].Rows,'inftype','InformationType');
									break;
								case "Ref002":
									OpenListBox(l_json_array[i].Rows,'attrib','Attribute');
									break;
								case "Ref003":
									OpenListBox(l_json_array[i].Rows,'ref','Reference');
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

function CreateSva() {
	if (document.getElementById("InputFkTypName").value == '') {
		alert ('Error: Primary key FkTypName not filled');
		return;
	}
	if (document.getElementById("InputFkSrvName").value == '') {
		alert ('Error: Primary key FkSrvName not filled');
		return;
	}
	if (document.getElementById("InputFkSrvCubeTsgDbScr").value == '') {
		alert ('Error: Primary key FkSrvCubeTsgDbScr not filled');
		return;
	}
	if (document.getElementById("InputOptionName").value == '') {
		alert ('Error: Primary key OptionName not filled');
		return;
	}
	if (document.getElementById("InputXfAtbTypName").value == '') {
		alert ('Error: Primary key XfAtbTypName not filled');
		return;
	}
	if (document.getElementById("InputXkAtbName").value == '') {
		alert ('Error: Primary key XkAtbName not filled');
		return;
	}
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkSrvName: document.getElementById("InputFkSrvName").value,
		FkSrvCubeTsgDbScr: document.getElementById("InputFkSrvCubeTsgDbScr").value,
		CubeTsgSvaType: document.getElementById("InputCubeTsgSvaType").value,
		OptionName: document.getElementById("InputOptionName").value,
		InputOrOutput: document.getElementById("InputInputOrOutput").value,
		XkItpName: document.getElementById("InputXkItpName").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value,
		XkRefBotName: document.getElementById("InputXkRefBotName").value,
		XkRefTypName: document.getElementById("InputXkRefTypName").value,
		XfRefTypName: document.getElementById("InputXfRefTypName").value,
		XkRefSequence: document.getElementById("InputXkRefSequence").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans('BusinessObjectType', {
			Service: "CreateSva",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_SVA;
		PerformTrans('BusinessObjectType', {
			Service: "CreateSva",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateSva() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkSrvName: document.getElementById("InputFkSrvName").value,
		FkSrvCubeTsgDbScr: document.getElementById("InputFkSrvCubeTsgDbScr").value,
		CubeTsgSvaType: document.getElementById("InputCubeTsgSvaType").value,
		OptionName: document.getElementById("InputOptionName").value,
		InputOrOutput: document.getElementById("InputInputOrOutput").value,
		XkItpName: document.getElementById("InputXkItpName").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value,
		XkRefBotName: document.getElementById("InputXkRefBotName").value,
		XkRefTypName: document.getElementById("InputXkRefTypName").value,
		XfRefTypName: document.getElementById("InputXfRefTypName").value,
		XkRefSequence: document.getElementById("InputXkRefSequence").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "UpdateSva",
		Parameters: {
			Type
		}
	} );
}

function DeleteSva() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkSrvName: document.getElementById("InputFkSrvName").value,
		FkSrvCubeTsgDbScr: document.getElementById("InputFkSrvCubeTsgDbScr").value,
		OptionName: document.getElementById("InputOptionName").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "DeleteSva",
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
			document.getElementById("InputXkItpName").value = '';
		} else {
			document.getElementById("InputXkItpName").value = l_json_values.Name;
		}
		break;
	case "Ref002":
		if (l_values == '') {
			document.getElementById("InputXfAtbTypName").value = '';
		} else {
			document.getElementById("InputXfAtbTypName").value = l_json_values.FkTypName;
		}
		if (l_values == '') {
			document.getElementById("InputXkAtbName").value = '';
		} else {
			document.getElementById("InputXkAtbName").value = l_json_values.Name;
		}
		break;
	case "Ref003":
		if (l_values == '') {
			document.getElementById("InputXfRefTypName").value = '';
		} else {
			document.getElementById("InputXfRefTypName").value = l_json_values.FkTypName;
		}
		if (l_values == '') {
			document.getElementById("InputXkRefSequence").value = '';
		} else {
			document.getElementById("InputXkRefSequence").value = l_json_values.Sequence;
		}
		if (l_values == '') {
			document.getElementById("InputXkRefBotName").value = '';
		} else {
			document.getElementById("InputXkRefBotName").value = l_json_values.XkBotName;
		}
		if (l_values == '') {
			document.getElementById("InputXkRefTypName").value = '';
		} else {
			document.getElementById("InputXkRefTypName").value = l_json_values.XkTypName;
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
	document.body._ListBoxOptional = 'Y';
	PerformTrans('InformationType', {
		Service: "GetItpList"
	} );
}

function StartSelect002(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref002';
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
		Service: "GetAtbForTypList",
		Parameters
	} );
}

function StartSelect003(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref003';
	document.body._ListBoxOptional = 'Y';
	var Parameters = {
		Option: {
			CubeScopeLevel:0
		},
		Ref: {
			FkTypName:document.getElementById("InputFkTypName").value
		}
	};
	PerformTrans('BusinessObjectType', {
		Service: "GetRefForTypList",
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
	g_json_option = l_json_argument.Option;
	switch (l_json_argument.nodeType) {
	case "D": // Details of existing object 
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_SVA.FkTypName;
		document.getElementById("InputFkSrvName").value = l_json_objectKey.TYP_SVA.FkSrvName;
		document.getElementById("InputFkSrvCubeTsgDbScr").value = l_json_objectKey.TYP_SVA.FkSrvCubeTsgDbScr;
		document.getElementById("InputOptionName").value = l_json_objectKey.TYP_SVA.OptionName;
		document.getElementById("InputXfAtbTypName").value = l_json_objectKey.TYP_SVA.XfAtbTypName;
		document.getElementById("InputXkAtbName").value = l_json_objectKey.TYP_SVA.XkAtbName;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateSva()};
		PerformTrans('BusinessObjectType', {
			Service: "GetSva",
			Parameters: {
				Type: l_json_objectKey.TYP_SVA
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkSrvName").disabled = true;
		document.getElementById("InputFkSrvCubeTsgDbScr").disabled = true;
		document.getElementById("InputCubeTsgSvaType").disabled = true;
		document.getElementById("InputOptionName").disabled = true;
		document.getElementById("InputXfAtbTypName").disabled = true;
		document.getElementById("InputXkAtbName").disabled = true;
		document.getElementById("RefSelect002").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_SRV.FkTypName;
		document.getElementById("InputFkSrvName").value = l_json_objectKey.TYP_SRV.Name;
		document.getElementById("InputFkSrvCubeTsgDbScr").value = l_json_objectKey.TYP_SRV.CubeTsgDbScr;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateSva()};
		PerformTrans('BusinessObjectType', {
			Service: "GetSrvFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_SRV
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkSrvName").disabled = true;
		document.getElementById("InputFkSrvCubeTsgDbScr").disabled = true;
		document.getElementById("InputInputOrOutput").value='I';
		document.getElementById("InputXkRefSequence").value='0';
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_SVA.FkTypName;
		document.getElementById("InputFkSrvName").value = l_json_objectKey.TYP_SVA.FkSrvName;
		document.getElementById("InputFkSrvCubeTsgDbScr").value = l_json_objectKey.TYP_SVA.FkSrvCubeTsgDbScr;
		document.getElementById("InputOptionName").value = l_json_objectKey.TYP_SVA.OptionName;
		document.getElementById("InputXfAtbTypName").value = l_json_objectKey.TYP_SVA.XfAtbTypName;
		document.getElementById("InputXkAtbName").value = l_json_objectKey.TYP_SVA.XkAtbName;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteSva()};
		SetChangePending();
		PerformTrans('BusinessObjectType', {
			Service: "GetSva",
			Parameters: {
				Type: l_json_objectKey.TYP_SVA
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeSequence").disabled = true;
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkSrvName").disabled = true;
		document.getElementById("InputFkSrvCubeTsgDbScr").disabled = true;
		document.getElementById("InputCubeTsgSvaType").disabled = true;
		document.getElementById("InputOptionName").disabled = true;
		document.getElementById("InputInputOrOutput").disabled = true;
		document.getElementById("InputXkItpName").disabled = true;
		document.getElementById("InputXfAtbTypName").disabled = true;
		document.getElementById("InputXkAtbName").disabled = true;
		document.getElementById("InputXkRefBotName").disabled = true;
		document.getElementById("InputXkRefTypName").disabled = true;
		document.getElementById("InputXfRefTypName").disabled = true;
		document.getElementById("InputXkRefSequence").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgSvaType").value != ' ') {
		document.getElementById("InputCubeTsgSvaType").disabled = true;
		switch (document.getElementById("InputCubeTsgSvaType").value) {
		case "OPT":
			document.getElementById("RowAtbOptionName").style.display = "none";
			document.getElementById("InputOptionName").value = " ";
			document.getElementById("RowRefInformationType0").style.display = "none";
			break;
		case "REF":
			document.getElementById("RowRefReference0").style.display = "none";
			break;
		case "ATB":
			document.getElementById("InputXfAtbTypName").value = " ";
			document.getElementById("InputXkAtbName").value = " ";
			document.getElementById("RowRefAttribute0").style.display = "none";
			break;
		}
		document.getElementById("TableMain").style.display = "inline";
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/servarg_large.bmp" /><span> SERVICE_ARGUMENT /
<select id="InputCubeTsgSvaType" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;sva_type&gt;</option>
	<option id="OptionCubeTsgSvaType-OPT" style="display:inline" value="OPT">OPTION</option>
	<option id="OptionCubeTsgSvaType-PAR" style="display:inline" value="PAR">PARENT_TYPE</option>
	<option id="OptionCubeTsgSvaType-RPA" style="display:inline" value="RPA">RECURSIVE_PARENT_TYPE</option>
	<option id="OptionCubeTsgSvaType-REF" style="display:inline" value="REF">REFERENCE</option>
	<option id="OptionCubeTsgSvaType-ATB" style="display:inline" value="ATB">ATTRIBUTE</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr id="RowAtbFkBotName"><td><div>BusinessObjectType.Name</div></td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkSrvName"><td><u><div>Service.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkSrvName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkSrvCubeTsgDbScr"><td><u><div>Service.DbInteractionOrSvrScript</div></u></td><td><div><select id="InputFkSrvCubeTsgDbScr" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionFkSrvCubeTsgDbScr-D" style="display:inline" value="D">DATABASE_INTERACTION</option>
	<option id="OptionFkSrvCubeTsgDbScr-S" style="display:inline" value="S">SERVER_SCRIPT</option>
</select></div></td></tr>
<tr id="RowAtbOptionName"><td><u><div>OptionName</div></u></td><td><div style="max-width:30em;"><input id="InputOptionName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbInputOrOutput"><td><div>InputOrOutput</div></td><td><div><select id="InputInputOrOutput" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionInputOrOutput-I" style="display:inline" value="I">Input</option>
	<option id="OptionInputOrOutput-O" style="display:inline" value="O">Output</option>
</select></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefInformationType0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/inftype.bmp"/> InformationType (HasDomain)</legend>
<table style="width:100%">
<tr><td>InformationType.Name</td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkItpName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefAttribute0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/attrib.bmp"/> Attribute (Concerns)</legend>
<table style="width:100%">
<tr><td><u>Type.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXfAtbTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
<tr><td><u>Attribute.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkAtbName" type="text" maxlength="30" style="width:100%" disabled></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefReference0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/ref.bmp"/> Reference (Concerns)</legend>
<table style="width:100%">
<tr><td>Type.Name</td><td style="width:100%"><div style="max-width:30em;"><input id="InputXfRefTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect003" type="button" onclick="StartSelect003(event)">Select</button></td></tr>
<tr><td>Reference.Sequence</td><td style="width:100%"><div style="max-width:2em;"><input id="InputXkRefSequence" type="text" maxlength="2" style="width:100%" disabled></input></div></td></tr>
<tr><td>BusinessObjectType.Name</td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkRefBotName" type="text" maxlength="30" style="width:100%" disabled></input></div></td></tr>
<tr><td>Type.Name</td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkRefTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
