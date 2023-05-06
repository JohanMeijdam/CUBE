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
					case "SELECT_ARG":
						var l_json_values = l_json_array[i].Rows[0].Data;
						break;
					case "CREATE_ARG":
						document.getElementById("InputFkFunName").disabled=true;
						document.getElementById("InputName").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkFunName:document.getElementById("InputFkFunName").value,Name:document.getElementById("InputName").value};
						g_node_id = '{"TYP_ARG":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_ARG',
									l_json_node_id,
									'icons/funcatb.bmp',
									'Argument',
									document.getElementById("InputName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateArg()};						
						ResetChangePending();
						break;
					case "UPDATE_ARG":
						ResetChangePending();
						break;
					case "DELETE_ARG":
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

function CreateArg() {
	if (document.getElementById("InputFkFunName").value == '') {
		alert ('Error: Primary key FkFunName not filled');
		return;
	}
	if (document.getElementById("InputName").value == '') {
		alert ('Error: Primary key Name not filled');
		return;
	}
	var Type = {
		FkFunName: document.getElementById("InputFkFunName").value,
		Name: document.getElementById("InputName").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateArg",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_ARG;
		PerformTrans( {
			Service: "CreateArg",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateArg() {
	var Type = {
		FkFunName: document.getElementById("InputFkFunName").value,
		Name: document.getElementById("InputName").value
	};
	PerformTrans( {
		Service: "UpdateArg",
		Parameters: {
			Type
		}
	} );
}

function DeleteArg() {
	var Type = {
		FkFunName: document.getElementById("InputFkFunName").value,
		Name: document.getElementById("InputName").value
	};
	PerformTrans( {
		Service: "DeleteArg",
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
		document.getElementById("InputFkFunName").value = l_json_objectKey.TYP_ARG.FkFunName;
		document.getElementById("InputName").value = l_json_objectKey.TYP_ARG.Name;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateArg()};
		document.getElementById("ButtonOK").disabled = true;
		document.getElementById("InputFkFunName").disabled = true;
		document.getElementById("InputName").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkFunName").value = l_json_objectKey.TYP_FUN.Name;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateArg()};
		document.getElementById("InputFkFunName").disabled = true;
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkFunName").value = l_json_objectKey.TYP_ARG.FkFunName;
		document.getElementById("InputName").value = l_json_objectKey.TYP_ARG.Name;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteArg()};
		SetChangePending();
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeSequence").disabled = true;
		document.getElementById("InputFkFunName").disabled = true;
		document.getElementById("InputName").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/funcatb_large.bmp" /><span> ARGUMENT</span></div>
<hr/>
<table>
<tr id="RowAtbFkFunName"><td><u><div>Function.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkFunName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbName"><td><u><div>Name</div></u></td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
