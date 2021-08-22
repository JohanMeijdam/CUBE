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
					case "SELECT_CST":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputOmschrijving").value=l_json_values.Omschrijving;
						document.getElementById("InputXkOddCode").value=l_json_values.XkOddCode;
						document.getElementById("InputXkOddCode1").value=l_json_values.XkOddCode1;
						break;
					case "CREATE_CST":
						document.getElementById("InputFkPrdCubeTsgType").disabled=true;
						document.getElementById("InputFkPrdCode").disabled=true;
						document.getElementById("InputFkOndCode").disabled=true;
						document.getElementById("InputCode").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkPrdCubeTsgType:document.getElementById("InputFkPrdCubeTsgType").value,FkPrdCode:document.getElementById("InputFkPrdCode").value,FkOndCode:document.getElementById("InputFkOndCode").value,Code:document.getElementById("InputCode").value};
						g_node_id = '{"TYP_CST":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_CST',
									l_json_node_id,
									'icons/type.bmp',
									'Constructie',
									document.getElementById("InputCode").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateCst()};						
						ResetChangePending();
						break;
					case "UPDATE_CST":
						ResetChangePending();
						break;
					case "DELETE_CST":
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
									OpenListBox(l_json_array[i].Rows,'type','OnderdeelDeel');
									break;
								case "Ref002":
									OpenListBox(l_json_array[i].Rows,'type','OnderdeelDeel');
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

function CreateCst() {
	if (document.getElementById("InputFkPrdCubeTsgType").value == '') {
		alert ('Error: Primary key FkPrdCubeTsgType not filled');
		return;
	}
	if (document.getElementById("InputFkPrdCode").value == '') {
		alert ('Error: Primary key FkPrdCode not filled');
		return;
	}
	if (document.getElementById("InputFkOndCode").value == '') {
		alert ('Error: Primary key FkOndCode not filled');
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
		Omschrijving: document.getElementById("InputOmschrijving").value,
		XkOddCode: document.getElementById("InputXkOddCode").value,
		XkOddCode1: document.getElementById("InputXkOddCode1").value
	};
	PerformTrans( {
		Service: "CreateCst",
		Parameters: {
			Type
		}
	} );
}

function UpdateCst() {
	var Type = {
		FkPrdCubeTsgType: document.getElementById("InputFkPrdCubeTsgType").value,
		FkPrdCode: document.getElementById("InputFkPrdCode").value,
		FkOndCode: document.getElementById("InputFkOndCode").value,
		Code: document.getElementById("InputCode").value,
		Omschrijving: document.getElementById("InputOmschrijving").value,
		XkOddCode: document.getElementById("InputXkOddCode").value,
		XkOddCode1: document.getElementById("InputXkOddCode1").value
	};
	PerformTrans( {
		Service: "UpdateCst",
		Parameters: {
			Type
		}
	} );
}

function DeleteCst() {
	var Type = {
		FkPrdCubeTsgType: document.getElementById("InputFkPrdCubeTsgType").value,
		FkPrdCode: document.getElementById("InputFkPrdCode").value,
		FkOndCode: document.getElementById("InputFkOndCode").value,
		Code: document.getElementById("InputCode").value
	};
	PerformTrans( {
		Service: "DeleteCst",
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
			document.getElementById("InputXkOddCode").value = '';
		} else {
			document.getElementById("InputXkOddCode").value = l_json_values.Code;
		}
		break;
	case "Ref002":
		if (l_values == '') {
			document.getElementById("InputXkOddCode1").value = '';
		} else {
			document.getElementById("InputXkOddCode1").value = l_json_values.Code;
		}
		break;
	default:
		alert ('Error Listbox: '+document.body._ListBoxCode);
	}
	CloseListBox();
}

function StartSelect001(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref001';
	document.body._ListBoxOptional = 'Y';
	PerformTrans( {
		Service: "GetOddList"
	} );
}

function StartSelect002(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref002';
	document.body._ListBoxOptional = 'Y';
	var Parameters = {
		Option: {
			CubeScopeLevel:0
		},
		Ref: {
			FkPrdCubeTsgType:document.getElementById("InputFkPrdCubeTsgType").value,
			FkPrdCode:document.getElementById("InputFkPrdCode").value,
			FkOndCode:document.getElementById("InputFkOndCode").value
		}
	};
	PerformTrans( {
		Service: "GetOddForOndList",
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
	switch (l_json_argument.nodeType) {
	case "D": // Details of existing object 
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCubeTsgType").value = l_json_objectKey.TYP_CST.FkPrdCubeTsgType;
		document.getElementById("InputFkPrdCode").value = l_json_objectKey.TYP_CST.FkPrdCode;
		document.getElementById("InputFkOndCode").value = l_json_objectKey.TYP_CST.FkOndCode;
		document.getElementById("InputCode").value = l_json_objectKey.TYP_CST.Code;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateCst()};
		PerformTrans( {
			Service: "GetCst",
			Parameters: {
				Type: l_json_objectKey.TYP_CST
			}
		} );
		document.getElementById("InputFkPrdCubeTsgType").disabled = true;
		document.getElementById("InputFkPrdCode").disabled = true;
		document.getElementById("InputFkOndCode").disabled = true;
		document.getElementById("InputCode").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCubeTsgType").value = l_json_objectKey.TYP_OND.FkPrdCubeTsgType;
		document.getElementById("InputFkPrdCode").value = l_json_objectKey.TYP_OND.FkPrdCode;
		document.getElementById("InputFkOndCode").value = l_json_objectKey.TYP_OND.Code;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateCst()};
		document.getElementById("InputFkPrdCubeTsgType").disabled = true;
		document.getElementById("InputFkPrdCode").disabled = true;
		document.getElementById("InputFkOndCode").disabled = true;
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCubeTsgType").value = l_json_objectKey.TYP_CST.FkPrdCubeTsgType;
		document.getElementById("InputFkPrdCode").value = l_json_objectKey.TYP_CST.FkPrdCode;
		document.getElementById("InputFkOndCode").value = l_json_objectKey.TYP_CST.FkOndCode;
		document.getElementById("InputCode").value = l_json_objectKey.TYP_CST.Code;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteCst()};
		SetChangePending();
		PerformTrans( {
			Service: "GetCst",
			Parameters: {
				Type: l_json_objectKey.TYP_CST
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputFkPrdCubeTsgType").disabled = true;
		document.getElementById("InputFkPrdCode").disabled = true;
		document.getElementById("InputFkOndCode").disabled = true;
		document.getElementById("InputCode").disabled = true;
		document.getElementById("InputOmschrijving").disabled = true;
		document.getElementById("InputXkOddCode").disabled = true;
		document.getElementById("InputXkOddCode1").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/type_large.bmp" /><span> CONSTRUCTIE</span></div>
<hr/>
<table>
<tr id="RowAtbFkPrdCubeTsgType"><td><u><div>Produkt.Type</div></u></td><td><div><select id="InputFkPrdCubeTsgType" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionFkPrdCubeTsgType-P" style="display:inline" value="P">PARTICULIER</option>
	<option id="OptionFkPrdCubeTsgType-Z" style="display:inline" value="Z">ZAKELIJK</option>
</select></div></td></tr>
<tr id="RowAtbFkPrdCode"><td><u><div>Produkt.Code</div></u></td><td><div style="max-width:8em;"><input id="InputFkPrdCode" type="text" maxlength="8" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkOndCode"><td><u><div>Onderdeel.Code</div></u></td><td><div style="max-width:8em;"><input id="InputFkOndCode" type="text" maxlength="8" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbCode"><td><u><div>Code</div></u></td><td><div style="max-width:8em;"><input id="InputCode" type="text" maxlength="8" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbOmschrijving"><td><div style="padding-top:10px">Omschrijving</div></td></tr><tr><td colspan="2"><div><textarea id="InputOmschrijving" type="text" maxlength="120" rows="5" style="white-space:normal;width:100%" onchange="SetChangePending();"></textarea></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefOnderdeelDeel0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> OnderdeelDeel (ZonderScope)</legend>
<table style="width:100%">
<tr><td>OnderdeelDeel.Code</td><td style="width:100%"><div style="max-width:8em;"><input id="InputXkOddCode" type="text" maxlength="8" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefOnderdeelDeel1"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> OnderdeelDeel (MetScope)</legend>
<table style="width:100%">
<tr><td>OnderdeelDeel.Code</td><td style="width:100%"><div style="max-width:8em;"><input id="InputXkOddCode1" type="text" maxlength="8" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
