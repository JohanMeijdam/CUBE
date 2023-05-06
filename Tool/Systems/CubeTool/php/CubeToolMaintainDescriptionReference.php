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
					case "SELECT_DCR":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputText").value=l_json_values.Text;
						break;
					case "CREATE_DCR":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkRefSequence").disabled=true;
						document.getElementById("InputFkRefBotName").disabled=true;
						document.getElementById("InputFkRefTypName").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkRefSequence:document.getElementById("InputFkRefSequence").value,FkRefBotName:document.getElementById("InputFkRefBotName").value,FkRefTypName:document.getElementById("InputFkRefTypName").value};
						g_node_id = '{"TYP_DCR":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_DCR',
									l_json_node_id,
									'icons/desc.bmp',
									'DescriptionReference',
									' ',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateDcr()};						
						ResetChangePending();
						break;
					case "UPDATE_DCR":
						ResetChangePending();
						break;
					case "DELETE_DCR":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (g_parent_node_id == null) {
							g_parent_node_id = l_objNode.parentNode.parentNode.id;
						} 
						if (l_objNode != null) {
							l_objNode.parentNode.removeChild(l_objNode);
						}
						CancelChangePending();
						break;
					case "SELECT_FKEY_REF":
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

function CreateDcr() {
	if (document.getElementById("InputFkTypName").value == '') {
		alert ('Error: Primary key FkTypName not filled');
		return;
	}
	if (document.getElementById("InputFkRefSequence").value == '') {
		alert ('Error: Primary key FkRefSequence not filled');
		return;
	}
	if (document.getElementById("InputFkRefBotName").value == '') {
		alert ('Error: Primary key FkRefBotName not filled');
		return;
	}
	if (document.getElementById("InputFkRefTypName").value == '') {
		alert ('Error: Primary key FkRefTypName not filled');
		return;
	}
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value,
		Text: document.getElementById("InputText").value
	};
	PerformTrans( {
		Service: "CreateDcr",
		Parameters: {
			Type
		}
	} );
}

function UpdateDcr() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value,
		Text: document.getElementById("InputText").value
	};
	PerformTrans( {
		Service: "UpdateDcr",
		Parameters: {
			Type
		}
	} );
}

function DeleteDcr() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value
	};
	PerformTrans( {
		Service: "DeleteDcr",
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
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_DCR.FkTypName;
		document.getElementById("InputFkRefSequence").value = l_json_objectKey.TYP_DCR.FkRefSequence;
		document.getElementById("InputFkRefBotName").value = l_json_objectKey.TYP_DCR.FkRefBotName;
		document.getElementById("InputFkRefTypName").value = l_json_objectKey.TYP_DCR.FkRefTypName;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateDcr()};
		PerformTrans( {
			Service: "GetDcr",
			Parameters: {
				Type: l_json_objectKey.TYP_DCR
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkRefSequence").disabled = true;
		document.getElementById("InputFkRefBotName").disabled = true;
		document.getElementById("InputFkRefTypName").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_REF.FkTypName;
		document.getElementById("InputFkRefSequence").value = l_json_objectKey.TYP_REF.Sequence;
		document.getElementById("InputFkRefBotName").value = l_json_objectKey.TYP_REF.XkBotName;
		document.getElementById("InputFkRefTypName").value = l_json_objectKey.TYP_REF.XkTypName;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateDcr()};
		PerformTrans( {
			Service: "GetRefFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_REF
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkRefSequence").disabled = true;
		document.getElementById("InputFkRefBotName").disabled = true;
		document.getElementById("InputFkRefTypName").disabled = true;
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_DCR.FkTypName;
		document.getElementById("InputFkRefSequence").value = l_json_objectKey.TYP_DCR.FkRefSequence;
		document.getElementById("InputFkRefBotName").value = l_json_objectKey.TYP_DCR.FkRefBotName;
		document.getElementById("InputFkRefTypName").value = l_json_objectKey.TYP_DCR.FkRefTypName;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteDcr()};
		SetChangePending();
		PerformTrans( {
			Service: "GetDcr",
			Parameters: {
				Type: l_json_objectKey.TYP_DCR
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkRefSequence").disabled = true;
		document.getElementById("InputFkRefBotName").disabled = true;
		document.getElementById("InputFkRefTypName").disabled = true;
		document.getElementById("InputText").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/desc_large.bmp" /><span> DESCRIPTION_REFERENCE</span></div>
<hr/>
<table>
<tr id="RowAtbFkBotName"><td><div>BusinessObjectType.Name</div></td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkRefSequence"><td><u><div>Reference.Sequence</div></u></td><td><div style="max-width:2em;"><input id="InputFkRefSequence" type="text" maxlength="2" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbFkRefBotName"><td><u><div>BusinessObjectType.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkRefBotName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkRefTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkRefTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbText"><td><div style="padding-top:10px">Text</div></td></tr><tr><td colspan="2"><div><textarea id="InputText" type="text" maxlength="3999" rows="5" style="white-space:normal;width:100%" onchange="SetChangePending();"></textarea></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
