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
					case "SELECT_SBT":
						var l_json_values = l_json_array[i].Rows[0].Data;
						break;
					case "CREATE_SBT":
						document.getElementById("InputFkSysName").disabled=true;
						document.getElementById("InputXkBotName").disabled=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkSysName:document.getElementById("InputFkSysName").value,XkBotName:document.getElementById("InputXkBotName").value};
						g_node_id = '{"TYP_SBT":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_SBT',
									l_json_node_id,
									'icons/sysbot.bmp',
									'SystemBoType',
									document.getElementById("InputXkBotName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateSbt()};						
						ResetChangePending();
						break;
					case "UPDATE_SBT":
						ResetChangePending();
						break;
					case "DELETE_SBT":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (g_parent_node_id == null) {
							g_parent_node_id = l_objNode.parentNode.parentNode.id;
						} 
						if (l_objNode != null) {
							l_objNode.parentNode.removeChild(l_objNode);
						}
						CancelChangePending();
						break;
					case "ERROR":
						alert ('Server error:\n'+l_json_array[i].ErrorText);
						break;
					default:
						if (l_json_array[i].ResultName.substring(0,5) == 'LIST_') {
							switch (document.body._ListBoxCode){
								case "Ref001":
									OpenListBox(l_json_array[i].Rows,'botype','BusinessObjectType');
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

function CreateSbt() {
	if (document.getElementById("InputFkSysName").value == '') {
		alert ('Error: Primary key FkSysName not filled');
		return;
	}
	if (document.getElementById("InputXkBotName").value == '') {
		alert ('Error: Primary key XkBotName not filled');
		return;
	}
	var Type = {
		FkSysName: document.getElementById("InputFkSysName").value,
		XkBotName: document.getElementById("InputXkBotName").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateSbt",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_SBT;
		PerformTrans( {
			Service: "CreateSbt",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateSbt() {
	var Type = {
		FkSysName: document.getElementById("InputFkSysName").value,
		XkBotName: document.getElementById("InputXkBotName").value
	};
	PerformTrans( {
		Service: "UpdateSbt",
		Parameters: {
			Type
		}
	} );
}

function DeleteSbt() {
	var Type = {
		FkSysName: document.getElementById("InputFkSysName").value,
		XkBotName: document.getElementById("InputXkBotName").value
	};
	PerformTrans( {
		Service: "DeleteSbt",
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
	SetChangePending();
}

function StartSelect001(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref001';
	document.body._ListBoxOptional = 'N';
	PerformTrans( {
		Service: "GetBotList"
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
		document.getElementById("InputFkSysName").value = l_json_objectKey.TYP_SBT.FkSysName;
		document.getElementById("InputXkBotName").value = l_json_objectKey.TYP_SBT.XkBotName;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateSbt()};
		document.getElementById("ButtonOK").disabled = true;
		document.getElementById("InputFkSysName").disabled = true;
		document.getElementById("InputXkBotName").disabled = true;
		document.getElementById("RefSelect001").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkSysName").value = l_json_objectKey.TYP_SYS.Name;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateSbt()};
		document.getElementById("InputFkSysName").disabled = true;
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkSysName").value = l_json_objectKey.TYP_SBT.FkSysName;
		document.getElementById("InputXkBotName").value = l_json_objectKey.TYP_SBT.XkBotName;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteSbt()};
		SetChangePending();
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeSequence").disabled = true;
		document.getElementById("InputFkSysName").disabled = true;
		document.getElementById("InputXkBotName").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/sysbot_large.bmp" /><span> SYSTEM_BO_TYPE</span></div>
<hr/>
<table>
<tr id="RowAtbFkSysName"><td><u><div>System.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkSysName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ReplaceSpaces(this);"></input></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefBusinessObjectType0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/botype.bmp"/> BusinessObjectType (Has)</legend>
<table style="width:100%">
<tr><td><u>BusinessObjectType.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkBotName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
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
