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
					case "SELECT_VAL":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputPrompt").value=l_json_values.Prompt;
						break;
					case "CREATE_VAL":
						document.getElementById("InputFkItpName").disabled=true;
						document.getElementById("InputFkIteSequence").disabled=true;
						document.getElementById("InputCode").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkItpName:document.getElementById("InputFkItpName").value,FkIteSequence:document.getElementById("InputFkIteSequence").value,Code:document.getElementById("InputCode").value};
						g_node_id = '{"TYP_VAL":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_VAL',
									l_json_node_id,
									'icons/value.bmp',
									'PermittedValue',
									document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputPrompt").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateVal()};						
						ResetChangePending();
						break;
					case "UPDATE_VAL":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputPrompt").value.toLowerCase();
						}
						ResetChangePending();
						break;
					case "DELETE_VAL":
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

function CreateVal() {
	if (document.getElementById("InputFkItpName").value == '') {
		alert ('Error: Primary key FkItpName not filled');
		return;
	}
	if (document.getElementById("InputFkIteSequence").value == '') {
		alert ('Error: Primary key FkIteSequence not filled');
		return;
	}
	if (document.getElementById("InputCode").value == '') {
		alert ('Error: Primary key Code not filled');
		return;
	}
	var Type = {
		FkItpName: document.getElementById("InputFkItpName").value,
		FkIteSequence: document.getElementById("InputFkIteSequence").value,
		Code: document.getElementById("InputCode").value,
		Prompt: document.getElementById("InputPrompt").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateVal",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_VAL;
		PerformTrans( {
			Service: "CreateVal",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateVal() {
	var Type = {
		FkItpName: document.getElementById("InputFkItpName").value,
		FkIteSequence: document.getElementById("InputFkIteSequence").value,
		Code: document.getElementById("InputCode").value,
		Prompt: document.getElementById("InputPrompt").value
	};
	PerformTrans( {
		Service: "UpdateVal",
		Parameters: {
			Type
		}
	} );
}

function DeleteVal() {
	var Type = {
		FkItpName: document.getElementById("InputFkItpName").value,
		FkIteSequence: document.getElementById("InputFkIteSequence").value,
		Code: document.getElementById("InputCode").value
	};
	PerformTrans( {
		Service: "DeleteVal",
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
		document.getElementById("InputFkItpName").value = l_json_objectKey.TYP_VAL.FkItpName;
		document.getElementById("InputFkIteSequence").value = l_json_objectKey.TYP_VAL.FkIteSequence;
		document.getElementById("InputCode").value = l_json_objectKey.TYP_VAL.Code;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateVal()};
		PerformTrans( {
			Service: "GetVal",
			Parameters: {
				Type: l_json_objectKey.TYP_VAL
			}
		} );
		document.getElementById("InputFkItpName").disabled = true;
		document.getElementById("InputFkIteSequence").disabled = true;
		document.getElementById("InputCode").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkItpName").value = l_json_objectKey.TYP_ITE.FkItpName;
		document.getElementById("InputFkIteSequence").value = l_json_objectKey.TYP_ITE.Sequence;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateVal()};
		document.getElementById("InputFkItpName").disabled = true;
		document.getElementById("InputFkIteSequence").disabled = true;
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkItpName").value = l_json_objectKey.TYP_VAL.FkItpName;
		document.getElementById("InputFkIteSequence").value = l_json_objectKey.TYP_VAL.FkIteSequence;
		document.getElementById("InputCode").value = l_json_objectKey.TYP_VAL.Code;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteVal()};
		SetChangePending();
		PerformTrans( {
			Service: "GetVal",
			Parameters: {
				Type: l_json_objectKey.TYP_VAL
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeSequence").disabled = true;
		document.getElementById("InputFkItpName").disabled = true;
		document.getElementById("InputFkIteSequence").disabled = true;
		document.getElementById("InputCode").disabled = true;
		document.getElementById("InputPrompt").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/value_large.bmp" /><span> PERMITTED_VALUE</span></div>
<hr/>
<table>
<tr id="RowAtbFkItpName"><td><u><div>InformationType.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkItpName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkIteSequence"><td><u><div>InformationTypeElement.Sequence</div></u></td><td><div style="max-width:9em;"><input id="InputFkIteSequence" type="text" maxlength="9" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbCode"><td><u><div>Code</div></u></td><td><div style="max-width:16em;"><input id="InputCode" type="text" maxlength="16" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbPrompt"><td><div>Prompt</div></td><td><div style="max-width:32em;"><input id="InputPrompt" type="text" maxlength="32" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
