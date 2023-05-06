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
					case "SELECT_SYS":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputCubeTsgType").value=l_json_values.CubeTsgType;
						document.getElementById("InputDatabase").value=l_json_values.Database;
						document.getElementById("InputSchema").value=l_json_values.Schema;
						document.getElementById("InputPassword").value=l_json_values.Password;
						document.getElementById("InputTablePrefix").value=l_json_values.TablePrefix;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_SYS":
						document.getElementById("InputName").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Name:document.getElementById("InputName").value};
						g_node_id = '{"TYP_SYS":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								if (l_json_array[i].Rows.length == 0) {
									var l_position = 'L';
									l_objNodePos = null;
								} else {
									var l_position = 'B';
									var l_objNodePos = parent.document.getElementById('{"TYP_SYS":'+JSON.stringify(l_json_array[i].Rows[0].Key)+'}');
								}
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_SYS',
									l_json_node_id,
									'icons/system.bmp',
									'System',
									document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateSys()};						
						ResetChangePending();
						break;
					case "UPDATE_SYS":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')';
						}
						ResetChangePending();
						break;
					case "DELETE_SYS":
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
						alert ('Unknown reply:\n'+g_responseText);
						
				}
			}
		} else {
			alert ('Request error:\n'+g_xmlhttp.statusText);
		}
	}
}

function CreateSys() {
	if (document.getElementById("InputName").value == '') {
		alert ('Error: Primary key Name not filled');
		return;
	}
	var Type = {
		Name: document.getElementById("InputName").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Database: document.getElementById("InputDatabase").value,
		Schema: document.getElementById("InputSchema").value,
		Password: document.getElementById("InputPassword").value,
		TablePrefix: document.getElementById("InputTablePrefix").value
	};
	PerformTrans( {
		Service: "CreateSys",
		Parameters: {
			Type
		}
	} );
}

function UpdateSys() {
	var Type = {
		Name: document.getElementById("InputName").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Database: document.getElementById("InputDatabase").value,
		Schema: document.getElementById("InputSchema").value,
		Password: document.getElementById("InputPassword").value,
		TablePrefix: document.getElementById("InputTablePrefix").value
	};
	PerformTrans( {
		Service: "UpdateSys",
		Parameters: {
			Type
		}
	} );
}

function DeleteSys() {
	var Type = {
		Name: document.getElementById("InputName").value
	};
	PerformTrans( {
		Service: "DeleteSys",
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
	switch (l_json_argument.nodeType) {
	case "D": // Details of existing object 
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputName").value = l_json_objectKey.TYP_SYS.Name;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateSys()};
		PerformTrans( {
			Service: "GetSys",
			Parameters: {
				Type: l_json_objectKey.TYP_SYS
			}
		} );
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputCubeTsgType").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateSys()};
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputName").value = l_json_objectKey.TYP_SYS.Name;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteSys()};
		SetChangePending();
		PerformTrans( {
			Service: "GetSys",
			Parameters: {
				Type: l_json_objectKey.TYP_SYS
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputCubeTsgType").disabled = true;
		document.getElementById("InputDatabase").disabled = true;
		document.getElementById("InputSchema").disabled = true;
		document.getElementById("InputPassword").disabled = true;
		document.getElementById("InputTablePrefix").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgType").value != ' ') {
		document.getElementById("InputCubeTsgType").disabled = true;
		switch (document.getElementById("InputCubeTsgType").value) {
		case "PRIMARY":
			document.getElementById("RowAtbTablePrefix").style.display = "none";
			break;
		case "SUPPORT":
			document.getElementById("RowAtbDatabase").style.display = "none";
			document.getElementById("RowAtbSchema").style.display = "none";
			document.getElementById("RowAtbPassword").style.display = "none";
			break;
		}
		document.getElementById("TableMain").style.display = "inline";
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/system_large.bmp" /><span> SYSTEM /
<select id="InputCubeTsgType" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;type&gt;</option>
	<option id="OptionCubeTsgType-PRIMARY" style="display:inline" value="PRIMARY">PRIMARY_SYSTEM</option>
	<option id="OptionCubeTsgType-SUPPORT" style="display:inline" value="SUPPORT">SUPPORTING_SYSTEM</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr id="RowAtbName"><td><u><div>Name</div></u></td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbDatabase"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('system','System.Database','SYSTEM','DATABASE',-1)"><div>Database</div></td><td><div style="max-width:30em;"><input id="InputDatabase" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbSchema"><td><div>Schema</div></td><td><div style="max-width:30em;"><input id="InputSchema" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbPassword"><td><div>Password</div></td><td><div style="max-width:20em;"><input id="InputPassword" type="text" maxlength="20" style="width:100%" onchange="SetChangePending();ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbTablePrefix"><td><div>TablePrefix</div></td><td><div style="max-width:4em;"><input id="InputTablePrefix" type="text" maxlength="4" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
