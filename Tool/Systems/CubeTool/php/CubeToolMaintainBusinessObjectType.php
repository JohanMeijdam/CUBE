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
					case "SEL_BOT":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputCubeTsgType").value=l_json_values.CubeTsgType;
						document.getElementById("InputDirectory").value=l_json_values.Directory;
						document.getElementById("InputApiUrl").value=l_json_values.ApiUrl;
						ProcessTypeSpecialisation();
						break;
					case "CRE_BOT":
						document.getElementById("InputName").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Name:document.getElementById("InputName").value};
						g_node_id = '{"TYP_BOT":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_BOT',
									l_json_node_id,
									'icons/botype.bmp',
									'BusinessObjectType',
									document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateBot()};						
						ResetChangePending();
						break;
					case "UPD_BOT":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')';
						}
						ResetChangePending();
						break;
					case "DEL_BOT":
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

function CreateBot() {
	if (document.getElementById("InputName").value == '') {
		alert ('Error: Primary key Name not filled');
		return;
	}
	var Type = {
		Name: document.getElementById("InputName").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Directory: document.getElementById("InputDirectory").value,
		ApiUrl: document.getElementById("InputApiUrl").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans('BusinessObjectType', {
			Service: "CreateBot",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_BOT;
		PerformTrans('BusinessObjectType', {
			Service: "CreateBot",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateBot() {
	var Type = {
		Name: document.getElementById("InputName").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Directory: document.getElementById("InputDirectory").value,
		ApiUrl: document.getElementById("InputApiUrl").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "UpdateBot",
		Parameters: {
			Type
		}
	} );
}

function DeleteBot() {
	var Type = {
		Name: document.getElementById("InputName").value
	};
	PerformTrans('BusinessObjectType', {
		Service: "DeleteBot",
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
		document.getElementById("InputName").value = l_json_objectKey.TYP_BOT.Name;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateBot()};
		PerformTrans('BusinessObjectType', {
			Service: "GetBot",
			Parameters: {
				Type: l_json_objectKey.TYP_BOT
			}
		} );
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputCubeTsgType").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateBot()};
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputName").value = l_json_objectKey.TYP_BOT.Name;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteBot()};
		SetChangePending();
		PerformTrans('BusinessObjectType', {
			Service: "GetBot",
			Parameters: {
				Type: l_json_objectKey.TYP_BOT
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeSequence").disabled = true;
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputCubeTsgType").disabled = true;
		document.getElementById("InputDirectory").disabled = true;
		document.getElementById("InputApiUrl").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgType").value != ' ') {
		document.getElementById("InputCubeTsgType").disabled = true;
		switch (document.getElementById("InputCubeTsgType").value) {
		case "INT":
			document.getElementById("RowAtbApiUrl").style.display = "none";
			break;
		case "RET":
			document.getElementById("RowAtbDirectory").style.display = "none";
			document.getElementById("RowAtbApiUrl").style.display = "none";
			break;
		}
		document.getElementById("TableMain").style.display = "inline";
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/botype_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('botype','BusinessObjectType','BUSINESS_OBJECT_TYPE','_',-1)"> BUSINESS_OBJECT_TYPE /
<select id="InputCubeTsgType" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;type&gt;</option>
	<option id="OptionCubeTsgType-INT" style="display:inline" value="INT">INTERNAL</option>
	<option id="OptionCubeTsgType-EXT" style="display:inline" value="EXT">EXTERNAL</option>
	<option id="OptionCubeTsgType-RET" style="display:inline" value="RET">REUSABLE_TYPE</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr id="RowAtbName"><td><u><div>Name</div></u></td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbDirectory"><td><div>Directory</div></td><td><div style="max-width:80em;"><input id="InputDirectory" type="text" maxlength="80" style="width:100%" onchange="SetChangePending();ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbApiUrl"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('botype','BusinessObjectType.ApiUrl','BUSINESS_OBJECT_TYPE','API_URL',-1)"><div>ApiUrl</div></td><td><div style="max-width:300em;"><input id="InputApiUrl" type="text" maxlength="300" style="width:100%" onchange="SetChangePending();ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
