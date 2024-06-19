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
					case "SEL_SVD":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputCubeTsgAtbRef").value=l_json_values.CubeTsgAtbRef;
						ProcessTypeSpecialisation();
						break;
					case "CRE_SVD":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkSrvName").disabled=true;
						document.getElementById("InputFkSrvCubeTsgDbScr").disabled=true;
						document.getElementById("InputXfAtbTypName").disabled=true;
						document.getElementById("InputXkAtbName").disabled=true;
						document.getElementById("InputXkRefBotName").disabled=true;
						document.getElementById("InputXkRefTypName").disabled=true;
						document.getElementById("InputXfRefTypName").disabled=true;
						document.getElementById("InputXkRefSequence").disabled=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("RefSelect002").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkSrvName:document.getElementById("InputFkSrvName").value,FkSrvCubeTsgDbScr:document.getElementById("InputFkSrvCubeTsgDbScr").value,XfAtbTypName:document.getElementById("InputXfAtbTypName").value,XkAtbName:document.getElementById("InputXkAtbName").value,XkRefBotName:document.getElementById("InputXkRefBotName").value,XkRefTypName:document.getElementById("InputXkRefTypName").value,XfRefTypName:document.getElementById("InputXfRefTypName").value,XkRefSequence:document.getElementById("InputXkRefSequence").value};
						g_node_id = '{"TYP_SVD":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_SVD',
									l_json_node_id,
									'icons/servdet.bmp',
									'ServiceDetail',
									'('+document.getElementById("InputCubeTsgAtbRef").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateSvd()};						
						ResetChangePending();
						break;
					case "UPD_SVD":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+'('+document.getElementById("InputCubeTsgAtbRef").value.toLowerCase()+')';
						}
						ResetChangePending();
						break;
					case "DEL_SVD":
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
									OpenListBox(l_json_array[i].Rows,'attrib','Attribute');
									break;
								case "Ref002":
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

function CreateSvd() {
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
	if (document.getElementById("InputXfAtbTypName").value == '') {
		alert ('Error: Primary key XfAtbTypName not filled');
		return;
	}
	if (document.getElementById("InputXkAtbName").value == '') {
		alert ('Error: Primary key XkAtbName not filled');
		return;
	}
	if (document.getElementById("InputXkRefBotName").value == '') {
		alert ('Error: Primary key XkRefBotName not filled');
		return;
	}
	if (document.getElementById("InputXkRefTypName").value == '') {
		alert ('Error: Primary key XkRefTypName not filled');
		return;
	}
	if (document.getElementById("InputXfRefTypName").value == '') {
		alert ('Error: Primary key XfRefTypName not filled');
		return;
	}
	if (document.getElementById("InputXkRefSequence").value == '') {
		alert ('Error: Primary key XkRefSequence not filled');
		return;
	}
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkSrvName: document.getElementById("InputFkSrvName").value,
		FkSrvCubeTsgDbScr: document.getElementById("InputFkSrvCubeTsgDbScr").value,
		CubeTsgAtbRef: document.getElementById("InputCubeTsgAtbRef").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value,
		XkRefBotName: document.getElementById("InputXkRefBotName").value,
		XkRefTypName: document.getElementById("InputXkRefTypName").value,
		XfRefTypName: document.getElementById("InputXfRefTypName").value,
		XkRefSequence: document.getElementById("InputXkRefSequence").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "CreateSvd",
		Parameters: {
			Type
		}
	} );
}

function UpdateSvd() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkSrvName: document.getElementById("InputFkSrvName").value,
		FkSrvCubeTsgDbScr: document.getElementById("InputFkSrvCubeTsgDbScr").value,
		CubeTsgAtbRef: document.getElementById("InputCubeTsgAtbRef").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value,
		XkRefBotName: document.getElementById("InputXkRefBotName").value,
		XkRefTypName: document.getElementById("InputXkRefTypName").value,
		XfRefTypName: document.getElementById("InputXfRefTypName").value,
		XkRefSequence: document.getElementById("InputXkRefSequence").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "UpdateSvd",
		Parameters: {
			Type
		}
	} );
}

function DeleteSvd() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkSrvName: document.getElementById("InputFkSrvName").value,
		FkSrvCubeTsgDbScr: document.getElementById("InputFkSrvCubeTsgDbScr").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value,
		XkRefBotName: document.getElementById("InputXkRefBotName").value,
		XkRefTypName: document.getElementById("InputXkRefTypName").value,
		XfRefTypName: document.getElementById("InputXfRefTypName").value,
		XkRefSequence: document.getElementById("InputXkRefSequence").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "DeleteSvd",
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
	case "Ref002":
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
	document.body._ListBoxOptional = 'N';
	PerformTrans('BusinessObjectType', {
		Service: "GetAtbList"
	} );
}

function StartSelect002(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref002';
	document.body._ListBoxOptional = 'N';
	PerformTrans('BusinessObjectType', {
		Service: "GetRefList"
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
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_SVD.FkTypName;
		document.getElementById("InputFkSrvName").value = l_json_objectKey.TYP_SVD.FkSrvName;
		document.getElementById("InputFkSrvCubeTsgDbScr").value = l_json_objectKey.TYP_SVD.FkSrvCubeTsgDbScr;
		document.getElementById("InputXfAtbTypName").value = l_json_objectKey.TYP_SVD.XfAtbTypName;
		document.getElementById("InputXkAtbName").value = l_json_objectKey.TYP_SVD.XkAtbName;
		document.getElementById("InputXkRefBotName").value = l_json_objectKey.TYP_SVD.XkRefBotName;
		document.getElementById("InputXkRefTypName").value = l_json_objectKey.TYP_SVD.XkRefTypName;
		document.getElementById("InputXfRefTypName").value = l_json_objectKey.TYP_SVD.XfRefTypName;
		document.getElementById("InputXkRefSequence").value = l_json_objectKey.TYP_SVD.XkRefSequence;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateSvd()};
		PerformTrans('BusinessObjectType', {
			Service: "GetSvd",
			Parameters: {
				Type: l_json_objectKey.TYP_SVD
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkSrvName").disabled = true;
		document.getElementById("InputFkSrvCubeTsgDbScr").disabled = true;
		document.getElementById("InputCubeTsgAtbRef").disabled = true;
		document.getElementById("InputXfAtbTypName").disabled = true;
		document.getElementById("InputXkAtbName").disabled = true;
		document.getElementById("InputXkRefBotName").disabled = true;
		document.getElementById("InputXkRefTypName").disabled = true;
		document.getElementById("InputXfRefTypName").disabled = true;
		document.getElementById("InputXkRefSequence").disabled = true;
		document.getElementById("RefSelect001").disabled = true;
		document.getElementById("RefSelect002").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_SRV.FkTypName;
		document.getElementById("InputFkSrvName").value = l_json_objectKey.TYP_SRV.Name;
		document.getElementById("InputFkSrvCubeTsgDbScr").value = l_json_objectKey.TYP_SRV.CubeTsgDbScr;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateSvd()};
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
		document.getElementById("InputXkRefSequence").value='0';
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_SVD.FkTypName;
		document.getElementById("InputFkSrvName").value = l_json_objectKey.TYP_SVD.FkSrvName;
		document.getElementById("InputFkSrvCubeTsgDbScr").value = l_json_objectKey.TYP_SVD.FkSrvCubeTsgDbScr;
		document.getElementById("InputXfAtbTypName").value = l_json_objectKey.TYP_SVD.XfAtbTypName;
		document.getElementById("InputXkAtbName").value = l_json_objectKey.TYP_SVD.XkAtbName;
		document.getElementById("InputXkRefBotName").value = l_json_objectKey.TYP_SVD.XkRefBotName;
		document.getElementById("InputXkRefTypName").value = l_json_objectKey.TYP_SVD.XkRefTypName;
		document.getElementById("InputXfRefTypName").value = l_json_objectKey.TYP_SVD.XfRefTypName;
		document.getElementById("InputXkRefSequence").value = l_json_objectKey.TYP_SVD.XkRefSequence;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteSvd()};
		SetChangePending();
		PerformTrans('BusinessObjectType', {
			Service: "GetSvd",
			Parameters: {
				Type: l_json_objectKey.TYP_SVD
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkSrvName").disabled = true;
		document.getElementById("InputFkSrvCubeTsgDbScr").disabled = true;
		document.getElementById("InputCubeTsgAtbRef").disabled = true;
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
	if (document.getElementById("InputCubeTsgAtbRef").value != ' ') {
		document.getElementById("InputCubeTsgAtbRef").disabled = true;
		switch (document.getElementById("InputCubeTsgAtbRef").value) {
		case "ATB":
			document.getElementById("InputXkRefBotName").value = " ";
			document.getElementById("InputXkRefTypName").value = " ";
			document.getElementById("InputXfRefTypName").value = " ";
			document.getElementById("InputXkRefSequence").value = "0";
			document.getElementById("RowRefReference0").style.display = "none";
			break;
		case "REF":
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
<div><img src="icons/servdet_large.bmp" /><span> SERVICE_DETAIL /
<select id="InputCubeTsgAtbRef" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;atb_ref&gt;</option>
	<option id="OptionCubeTsgAtbRef-ATB" style="display:inline" value="ATB">ATTRIBUTE</option>
	<option id="OptionCubeTsgAtbRef-REF" style="display:inline" value="REF">REFERENCE</option>
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
<tr><td height=6></td></tr><tr id="RowRefAttribute0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/attrib.bmp"/> Attribute (Concerns)</legend>
<table style="width:100%">
<tr><td><u>Type.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXfAtbTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td><u>Attribute.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkAtbName" type="text" maxlength="30" style="width:100%" disabled></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefReference0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/ref.bmp"/> Reference (Concerns)</legend>
<table style="width:100%">
<tr><td><u>Type.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXfRefTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
<tr><td><u>Reference.Sequence</u></td><td style="width:100%"><div style="max-width:2em;"><input id="InputXkRefSequence" type="text" maxlength="2" style="width:100%" disabled></input></div></td></tr>
<tr><td><u>BusinessObjectType.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkRefBotName" type="text" maxlength="30" style="width:100%" disabled></input></div></td></tr>
<tr><td><u>Type.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkRefTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
