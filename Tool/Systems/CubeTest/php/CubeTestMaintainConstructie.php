<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeInclude.js"></script>
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeDetailInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeTestInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeTestDetailInclude.js"></script>
<script language="javascript" type="text/javascript">
<!--
var g_option = null;
var g_json_option = null;
var g_parent_node_id = null;
var g_node_id = null;

g_xmlhttp.onreadystatechange = function() {
	if(g_xmlhttp.readyState == 4) {
		if(g_xmlhttp.status == 200) {
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
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
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
									document.getElementById("InputCode").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_CST":
						break;
					case "DELETE_CST":
						document.getElementById("ButtonCreate").disabled=false;
						document.getElementById("ButtonUpdate").disabled=true;
						document.getElementById("ButtonDelete").disabled=true;
						var l_objNode = parent.document.getElementById(g_node_id);
						if (g_parent_node_id == null) {
							g_parent_node_id = l_objNode.parentNode.parentNode.id;
						} 
						if (l_objNode != null) {
							l_objNode.parentNode.removeChild(l_objNode);
						}
						break;
					case "LIST_ODD":
						OpenListBox(l_json_array[i].Rows,'type','OnderdeelDeel','Y');
						break;
					case "LIST_ODD":
						OpenListBox(l_json_array[i].Rows,'type','OnderdeelDeel','Y');
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

function InitBody() {
	var l_json_argument = JSON.parse(decodeURIComponent(location.href.split("?")[1]));
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	document.body._ListBoxCode="Ref000";
	var l_json_objectKey = l_json_argument.objectId;
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCubeTsgType").value=l_json_objectKey.TYP_CST.FkPrdCubeTsgType;
		document.getElementById("InputFkPrdCode").value=l_json_objectKey.TYP_CST.FkPrdCode;
		document.getElementById("InputFkOndCode").value=l_json_objectKey.TYP_CST.FkOndCode;
		document.getElementById("InputCode").value=l_json_objectKey.TYP_CST.Code;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetCst",
			Parameters: {
				Type: l_json_objectKey.TYP_CST
			}
		} );
		document.getElementById("InputFkPrdCubeTsgType").disabled=true;
		document.getElementById("InputFkPrdCode").disabled=true;
		document.getElementById("InputFkOndCode").disabled=true;
		document.getElementById("InputCode").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCubeTsgType").value=l_json_objectKey.TYP_OND.FkPrdCubeTsgType;
		document.getElementById("InputFkPrdCode").value=l_json_objectKey.TYP_OND.FkPrdCode;
		document.getElementById("InputFkOndCode").value=l_json_objectKey.TYP_OND.Code;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkPrdCubeTsgType").disabled=true;
		document.getElementById("InputFkPrdCode").disabled=true;
		document.getElementById("InputFkOndCode").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateCst() {
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
	PerformTrans( {
		Service: "GetOddList"
	} );
}

function StartSelect002(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref002';
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
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/type_large.bmp" /><span> CONSTRUCTIE</span></div>
<hr/>
<table>
<tr id="RowAtbFkPrdCubeTsgType"><td><u><div>Produkt.Type</div></u></td><td><div><select id="InputFkPrdCubeTsgType" type="text">
	<option value=" " selected> </option>
	<option value="P">PARTICULIER</option>
	<option value="Z">ZAKELIJK</option>
</select></div></td></tr>
<tr id="RowAtbFkPrdCode"><td><u><div>Produkt.Code</div></u></td><td><div style="max-width:8em;"><input id="InputFkPrdCode" type="text" maxlength="8" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkOndCode"><td><u><div>Onderdeel.Code</div></u></td><td><div style="max-width:8em;"><input id="InputFkOndCode" type="text" maxlength="8" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbCode"><td><u><div>Code</div></u></td><td><div style="max-width:8em;"><input id="InputCode" type="text" maxlength="8" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbOmschrijving"><td><div style="padding-top:10px">Omschrijving</div></td></tr><tr><td colspan="2"><div><textarea id="InputOmschrijving" type="text" maxlength="120" rows="5" style="white-space:normal;width:100%"></textarea></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefOnderdeelDeel0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> OnderdeelDeel (ZonderScope)</legend>
<table style="width:100%">
<tr><td>OnderdeelDeel.Code</td><td style="width:100%"><div style="max-width:8em;"><input id="InputXkOddCode" type="text" maxlength="8" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefOnderdeelDeel1"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> OnderdeelDeel (MetScope)</legend>
<table style="width:100%">
<tr><td>OnderdeelDeel.Code</td><td style="width:100%"><div style="max-width:8em;"><input id="InputXkOddCode1" type="text" maxlength="8" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateCst()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateCst()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteCst()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
