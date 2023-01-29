<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeInclude.js?filever=<?=filemtime('..\CubeGeneral\CubeInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeDetailInclude.js?filever=<?=filemtime('..\CubeGeneral\CubeDetailInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeTestInclude.js?filever=<?=filemtime('CubeTestInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeTestDetailInclude.js?filever=<?=filemtime('CubeTestDetailInclude.js')?>"></script>
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
					case "SELECT_OND":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkOndCode").value=l_json_values.FkOndCode;
						document.getElementById("InputPrijs").value=l_json_values.Prijs;
						document.getElementById("InputOmschrijving").value=l_json_values.Omschrijving;
						break;
					case "CREATE_OND":
						document.getElementById("InputFkPrdCubeTsgType").disabled=true;
						document.getElementById("InputFkPrdCode").disabled=true;
						document.getElementById("InputFkOndCode").disabled=true;
						document.getElementById("InputCode").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkPrdCubeTsgType:document.getElementById("InputFkPrdCubeTsgType").value,FkPrdCode:document.getElementById("InputFkPrdCode").value,Code:document.getElementById("InputCode").value};
						g_node_id = '{"TYP_OND":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_OND',
									l_json_node_id,
									'icons/part.bmp',
									'Onderdeel',
									document.getElementById("InputCode").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateOnd()};						
						ResetChangePending();
						break;
					case "UPDATE_OND":
						ResetChangePending();
						break;
					case "DELETE_OND":
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

function CreateOnd() {
	if (document.getElementById("InputFkPrdCubeTsgType").value == '') {
		alert ('Error: Primary key FkPrdCubeTsgType not filled');
		return;
	}
	if (document.getElementById("InputFkPrdCode").value == '') {
		alert ('Error: Primary key FkPrdCode not filled');
		return;
	}
	if (document.getElementById("InputCode").value == '') {
		alert ('Error: Primary key Code not filled');
		return;
	}
	var Type = {
		FkPrdCubeTsgType: document.getElementById("InputFkPrdCubeTsgType").value,
		FkPrdCode: document.getElementById("InputFkPrdCode").value,
		FkOndCode: document.getElementById("InputFkOndCode").value,
		Code: document.getElementById("InputCode").value,
		Prijs: document.getElementById("InputPrijs").value,
		Omschrijving: document.getElementById("InputOmschrijving").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateOnd",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_OND;
		PerformTrans( {
			Service: "CreateOnd",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateOnd() {
	var Type = {
		FkPrdCubeTsgType: document.getElementById("InputFkPrdCubeTsgType").value,
		FkPrdCode: document.getElementById("InputFkPrdCode").value,
		FkOndCode: document.getElementById("InputFkOndCode").value,
		Code: document.getElementById("InputCode").value,
		Prijs: document.getElementById("InputPrijs").value,
		Omschrijving: document.getElementById("InputOmschrijving").value
	};
	PerformTrans( {
		Service: "UpdateOnd",
		Parameters: {
			Type
		}
	} );
}

function DeleteOnd() {
	var Type = {
		FkPrdCubeTsgType: document.getElementById("InputFkPrdCubeTsgType").value,
		FkPrdCode: document.getElementById("InputFkPrdCode").value,
		Code: document.getElementById("InputCode").value
	};
	PerformTrans( {
		Service: "DeleteOnd",
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
		document.getElementById("InputFkPrdCubeTsgType").value = l_json_objectKey.TYP_OND.FkPrdCubeTsgType;
		document.getElementById("InputFkPrdCode").value = l_json_objectKey.TYP_OND.FkPrdCode;
		document.getElementById("InputCode").value = l_json_objectKey.TYP_OND.Code;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateOnd()};
		PerformTrans( {
			Service: "GetOnd",
			Parameters: {
				Type: l_json_objectKey.TYP_OND
			}
		} );
		document.getElementById("InputFkPrdCubeTsgType").disabled = true;
		document.getElementById("InputFkPrdCode").disabled = true;
		document.getElementById("InputFkOndCode").disabled = true;
		document.getElementById("InputCode").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCubeTsgType").value = l_json_objectKey.TYP_PRD.CubeTsgType;
		document.getElementById("InputFkPrdCode").value = l_json_objectKey.TYP_PRD.Code;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateOnd()};
		document.getElementById("InputFkPrdCubeTsgType").disabled = true;
		document.getElementById("InputFkPrdCode").disabled = true;
		document.getElementById("InputFkOndCode").disabled = true;
		document.getElementById("InputCubeLevel").value='1';
		break;  
	case "R": // New recursive object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCubeTsgType").value = l_json_objectKey.TYP_OND.FkPrdCubeTsgType;
		document.getElementById("InputFkPrdCode").value = l_json_objectKey.TYP_OND.FkPrdCode;
		document.getElementById("InputFkOndCode").value = l_json_objectKey.TYP_OND.Code;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateOnd()};
		document.getElementById("InputFkPrdCubeTsgType").disabled = true;
		document.getElementById("InputFkPrdCode").disabled = true;
		document.getElementById("InputFkOndCode").disabled = true;
		document.getElementById("InputCubeLevel").value='1';
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCubeTsgType").value = l_json_objectKey.TYP_OND.FkPrdCubeTsgType;
		document.getElementById("InputFkPrdCode").value = l_json_objectKey.TYP_OND.FkPrdCode;
		document.getElementById("InputCode").value = l_json_objectKey.TYP_OND.Code;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteOnd()};
		SetChangePending();
		PerformTrans( {
			Service: "GetOnd",
			Parameters: {
				Type: l_json_objectKey.TYP_OND
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeSequence").disabled = true;
		document.getElementById("InputCubeLevel").disabled = true;
		document.getElementById("InputFkPrdCubeTsgType").disabled = true;
		document.getElementById("InputFkPrdCode").disabled = true;
		document.getElementById("InputFkOndCode").disabled = true;
		document.getElementById("InputCode").disabled = true;
		document.getElementById("InputPrijs").disabled = true;
		document.getElementById("InputOmschrijving").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/part_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('part','Onderdeel','ONDERDEEL','_',-1)"> ONDERDEEL</span></div>
<hr/>
<table>
<tr id="RowAtbFkPrdCubeTsgType"><td><u><div>Produkt.Type</div></u></td><td><div><select id="InputFkPrdCubeTsgType" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionFkPrdCubeTsgType-P" style="display:inline" value="P">PARTICULIER</option>
	<option id="OptionFkPrdCubeTsgType-Z" style="display:inline" value="Z">ZAKELIJK</option>
</select></div></td></tr>
<tr id="RowAtbFkPrdCode"><td><u><div>Produkt.Code</div></u></td><td><div style="max-width:8em;"><input id="InputFkPrdCode" type="text" maxlength="8" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkOndCode"><td><div>Onderdeel.Code</div></td><td><div style="max-width:8em;"><input id="InputFkOndCode" type="text" maxlength="8" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbCode"><td><u><div>Code</div></u></td><td><div style="max-width:8em;"><input id="InputCode" type="text" maxlength="8" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbPrijs"><td><div>Prijs</div></td><td><div style="max-width:9em;"><input id="InputPrijs" type="text" maxlength="9" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbOmschrijving"><td><div style="padding-top:10px">Omschrijving</div></td></tr><tr><td colspan="2"><div><textarea id="InputOmschrijving" type="text" maxlength="120" rows="5" style="white-space:normal;width:100%" onchange="SetChangePending();"></textarea></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
<input id="InputCubeLevel" type="hidden"></input>
</body>
</html>
