<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeInclude.js?filever=<?=filemtime('../CubeGeneral/CubeInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeDetailInclude.js?filever=<?=filemtime('../CubeGeneral/CubeDetailInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeSysInclude.js?filever=<?=filemtime('CubeSysInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeSysDetailInclude.js?filever=<?=filemtime('CubeSysDetailInclude.js')?>"></script>
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
					case "SEL_CUBE_USR":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputName").value=l_json_values.Name;
						document.getElementById("InputPassword").value=l_json_values.Password;
						break;
					case "CRE_CUBE_USR":
						document.getElementById("InputUserid").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Userid:document.getElementById("InputUserid").value};
						g_node_id = '{"TYP_CUBE_USR":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_CUBE_USR',
									l_json_node_id,
									'icons/user.bmp',
									'CubeUser',
									document.getElementById("InputUserid").value.toLowerCase()+' '+document.getElementById("InputName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateCubeUsr()};						
						ResetChangePending();
						break;
					case "UPD_CUBE_USR":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputUserid").value.toLowerCase()+' '+document.getElementById("InputName").value.toLowerCase();
						}
						ResetChangePending();
						break;
					case "DEL_CUBE_USR":
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

function CreateCubeUsr() {
	if (document.getElementById("InputUserid").value == '') {
		alert ('Error: Primary key Userid not filled');
		return;
	}
	var Type = {
		Userid: document.getElementById("InputUserid").value,
		Name: document.getElementById("InputName").value,
		Password: document.getElementById("InputPassword").value
	};
	PerformTrans('CubeUser', {
		Service: "CreateCubeUsr",
		Parameters: {
			Type
		}
	} );
}

function UpdateCubeUsr() {
	var Type = {
		Userid: document.getElementById("InputUserid").value,
		Name: document.getElementById("InputName").value,
		Password: document.getElementById("InputPassword").value
	};
	PerformTrans('CubeUser', {
		Service: "UpdateCubeUsr",
		Parameters: {
			Type
		}
	} );
}

function DeleteCubeUsr() {
	var Type = {
		Userid: document.getElementById("InputUserid").value
	};
	PerformTrans('CubeUser', {
		Service: "DeleteCubeUsr",
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
		document.getElementById("InputUserid").value = l_json_objectKey.TYP_CUBE_USR.Userid;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateCubeUsr()};
		PerformTrans('CubeUser', {
			Service: "GetCubeUsr",
			Parameters: {
				Type: l_json_objectKey.TYP_CUBE_USR
			}
		} );
		document.getElementById("InputUserid").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateCubeUsr()};
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputUserid").value = l_json_objectKey.TYP_CUBE_USR.Userid;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteCubeUsr()};
		SetChangePending();
		PerformTrans('CubeUser', {
			Service: "GetCubeUsr",
			Parameters: {
				Type: l_json_objectKey.TYP_CUBE_USR
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputUserid").disabled = true;
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputPassword").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/user_large.bmp" /><span> CUBE_USER</span></div>
<hr/>
<table>
<tr id="RowAtbUserid"><td><u><div>Userid</div></u></td><td><div style="max-width:8em;"><input id="InputUserid" type="text" maxlength="8" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbName"><td><div>Name</div></td><td><div style="max-width:120em;"><input id="InputName" type="text" maxlength="120" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbPassword"><td><div>Password</div></td><td><div style="max-width:20em;"><input id="InputPassword" type="text" maxlength="20" style="width:100%" onchange="SetChangePending();ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
