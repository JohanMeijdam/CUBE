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
					case "SELECT_OND":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkOndCode").value=l_json_values.FkOndCode;
						document.getElementById("InputPrijs").value=l_json_values.Prijs;
						document.getElementById("InputOmschrijving").value=l_json_values.Omschrijving;
						document.getElementById("InputXfOndPrdCubeTsgType").value=l_json_values.XfOndPrdCubeTsgType;
						document.getElementById("InputXfOndPrdCode").value=l_json_values.XfOndPrdCode;
						document.getElementById("InputXkOndCode").value=l_json_values.XkOndCode;
						break;
					case "CREATE_OND":
						document.getElementById("InputFkPrdCubeTsgType").disabled=true;
						document.getElementById("InputFkPrdCode").disabled=true;
						document.getElementById("InputFkOndCode").disabled=true;
						document.getElementById("InputCode").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
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
									document.getElementById("InputCode").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_OND":
						break;
					case "DELETE_OND":
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
					case "LIST_OND":
						OpenListBox(l_json_array[i].Rows,'part','Onderdeel','Y');
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
	g_json_option = l_json_argument.Option;
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCubeTsgType").value=l_json_objectKey.TYP_OND.FkPrdCubeTsgType;
		document.getElementById("InputFkPrdCode").value=l_json_objectKey.TYP_OND.FkPrdCode;
		document.getElementById("InputCode").value=l_json_objectKey.TYP_OND.Code;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetOnd",
			Parameters: {
				Type: l_json_objectKey.TYP_OND
			}
		} );
		document.getElementById("InputFkPrdCubeTsgType").disabled=true;
		document.getElementById("InputFkPrdCode").disabled=true;
		document.getElementById("InputFkOndCode").disabled=true;
		document.getElementById("InputCode").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCubeTsgType").value=l_json_objectKey.TYP_PRD.CubeTsgType;
		document.getElementById("InputFkPrdCode").value=l_json_objectKey.TYP_PRD.Code;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkPrdCubeTsgType").disabled=true;
		document.getElementById("InputFkPrdCode").disabled=true;
		document.getElementById("InputFkOndCode").disabled=true;
		break;  
	case "R":
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
	document.getElementById("InputCubeLevel").value='1';
}

function CreateOnd() {
	var Type = {
		FkPrdCubeTsgType: document.getElementById("InputFkPrdCubeTsgType").value,
		FkPrdCode: document.getElementById("InputFkPrdCode").value,
		FkOndCode: document.getElementById("InputFkOndCode").value,
		Code: document.getElementById("InputCode").value,
		Prijs: document.getElementById("InputPrijs").value,
		Omschrijving: document.getElementById("InputOmschrijving").value,
		XfOndPrdCubeTsgType: document.getElementById("InputXfOndPrdCubeTsgType").value,
		XfOndPrdCode: document.getElementById("InputXfOndPrdCode").value,
		XkOndCode: document.getElementById("InputXkOndCode").value
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
		Omschrijving: document.getElementById("InputOmschrijving").value,
		XfOndPrdCubeTsgType: document.getElementById("InputXfOndPrdCubeTsgType").value,
		XfOndPrdCode: document.getElementById("InputXfOndPrdCode").value,
		XkOndCode: document.getElementById("InputXkOndCode").value
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

function UpdateForeignKey(p_obj) {
	var l_values = p_obj.options[p_obj.selectedIndex].value;
	if (l_values != '') {
		var l_json_values = JSON.parse(l_values);
	}
	switch (document.body._ListBoxCode){
	case "Ref001":
		if (l_values == '') {
			document.getElementById("InputXfOndPrdCubeTsgType").value = '';
		} else {
			document.getElementById("InputXfOndPrdCubeTsgType").value = l_json_values.FkPrdCubeTsgType;
		}
		if (l_values == '') {
			document.getElementById("InputXfOndPrdCode").value = '';
		} else {
			document.getElementById("InputXfOndPrdCode").value = l_json_values.FkPrdCode;
		}
		if (l_values == '') {
			document.getElementById("InputXkOndCode").value = '';
		} else {
			document.getElementById("InputXkOndCode").value = l_json_values.Code;
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
	var Parameters = {
		Option: {
			CubeUpOrDown:"U",
			CubeScopeLevel:9999
		},
		Type: {
			FkPrdCubeTsgType:document.getElementById("InputFkPrdCubeTsgType").value,
			FkPrdCode:document.getElementById("InputFkPrdCode").value,
			Code:document.getElementById("InputCode").value
		}
	};
	PerformTrans( {
		Service: "GetOndListRecursive",
		Parameters
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/part_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('PART','Onderdeel','ONDERDEEL','_',-1)"> ONDERDEEL</span></div>
<hr/>
<table>
<tr><td><u>Produkt.Type</u></td><td><div>
<select id="InputFkPrdCubeTsgType" type="text">
	<option value=" " selected> </option>
	<option value="P">PARTICULIER</option>
	<option value="Z">ZAKELIJK</option>
</select></div></td></tr>
<tr><td><u>Produkt.Code</u></td><td><div style="max-width:8em;">
<input id="InputFkPrdCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Onderdeel.Code</td><td><div style="max-width:8em;">
<input id="InputFkOndCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Code</u></td><td><div style="max-width:8em;">
<input id="InputCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Prijs</td><td><div style="max-width:9em;">
<input id="InputPrijs" type="text" maxlength="9" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td style="padding-top:10px;">Omschrijving</td></tr><tr><td colspan="2"><div>
<textarea id="InputOmschrijving" type="text" maxlength="120" rows="5" style="white-space:normal;width:100%;"></textarea></div></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/part.bmp"/> Onderdeel (LijktOp)</legend>
<table style="width:100%;">
<tr><td>Produkt.Type</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfOndPrdCubeTsgType" type="text" maxlength="8" style="width:100%;" onchange="ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td>Produkt.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfOndPrdCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td></tr>
<tr><td>Onderdeel.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkOndCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateOnd()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateOnd()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteOnd()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
<input id="InputCubeLevel" type="hidden"></input>
</body>
</html>
