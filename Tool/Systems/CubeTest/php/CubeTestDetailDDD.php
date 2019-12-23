<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeInclude.js"></script>
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
					case "SELECT_DDD":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkPrdCubeTsgType").value=l_json_values.FkPrdCubeTsgType;
						document.getElementById("InputFkPrdCode").value=l_json_values.FkPrdCode;
						document.getElementById("InputFkOndCode").value=l_json_values.FkOndCode;
						document.getElementById("InputFkOddCode").value=l_json_values.FkOddCode;
						document.getElementById("InputNaam").value=l_json_values.Naam;
						document.getElementById("InputXfOndPrdCubeTsgType").value=l_json_values.XfOndPrdCubeTsgType;
						document.getElementById("InputXfOndPrdCode").value=l_json_values.XfOndPrdCode;
						document.getElementById("InputXkOndCode").value=l_json_values.XkOndCode;
						document.getElementById("InputXfOndPrdCubeTsgType3").value=l_json_values.XfOndPrdCubeTsgType3;
						document.getElementById("InputXfOndPrdCode3").value=l_json_values.XfOndPrdCode3;
						document.getElementById("InputXkOndCode3").value=l_json_values.XkOndCode3;
						document.getElementById("InputXfOndPrdCubeTsgType1").value=l_json_values.XfOndPrdCubeTsgType1;
						document.getElementById("InputXfOndPrdCode1").value=l_json_values.XfOndPrdCode1;
						document.getElementById("InputXkOndCode1").value=l_json_values.XkOndCode1;
						document.getElementById("InputXfOndPrdCubeTsgType2").value=l_json_values.XfOndPrdCubeTsgType2;
						document.getElementById("InputXfOndPrdCode2").value=l_json_values.XfOndPrdCode2;
						document.getElementById("InputXkOndCode2").value=l_json_values.XkOndCode2;
						break;
					case "CREATE_DDD":
						document.getElementById("InputFkPrdCubeTsgType").readOnly=true;
						document.getElementById("InputFkPrdCode").readOnly=true;
						document.getElementById("InputFkOndCode").readOnly=true;
						document.getElementById("InputFkOddCode").readOnly=true;
						document.getElementById("InputCode").readOnly=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Code:document.getElementById("InputCode").value};
						g_node_id = '{"TYP_DDD":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_DDD',
									l_json_node_id,
									'icons/attrib.bmp', 
									document.getElementById("InputCode").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_DDD":
						break;
					case "DELETE_DDD":
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
					case "LIST_OND":
						OpenListBox(l_json_array[i].Rows,'part','Onderdeel','Y');
						break;
					case "LIST_OND":
						OpenListBox(l_json_array[i].Rows,'part','Onderdeel','Y');
						break;
					case "LIST_OND":
						OpenListBox(l_json_array[i].Rows,'part','Onderdeel','Y');
						break;
					case "SELECT_FKEY_ODD":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkPrdCubeTsgType").value=l_json_values.FkPrdCubeTsgType;
						document.getElementById("InputFkPrdCode").value=l_json_values.FkPrdCode;
						document.getElementById("InputFkOndCode").value=l_json_values.FkOndCode;
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
		document.getElementById("InputCode").value=l_json_objectKey.TYP_DDD.Code;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetDdd",
			Parameters: {
				Type: l_json_objectKey.TYP_DDD
			}
		} );
		document.getElementById("InputFkPrdCubeTsgType").readOnly=true;
		document.getElementById("InputFkPrdCode").readOnly=true;
		document.getElementById("InputFkOndCode").readOnly=true;
		document.getElementById("InputFkOddCode").readOnly=true;
		document.getElementById("InputCode").readOnly=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkOddCode").value=l_json_objectKey.TYP_ODD.Code;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		PerformTrans( {
			Service: "GetOddFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_ODD
			}
		} );
		document.getElementById("InputFkPrdCubeTsgType").readOnly=true;
		document.getElementById("InputFkPrdCode").readOnly=true;
		document.getElementById("InputFkOndCode").readOnly=true;
		document.getElementById("InputFkOddCode").readOnly=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateDdd() {
	var Type = {
		FkPrdCubeTsgType: document.getElementById("InputFkPrdCubeTsgType").value,
		FkPrdCode: document.getElementById("InputFkPrdCode").value,
		FkOndCode: document.getElementById("InputFkOndCode").value,
		FkOddCode: document.getElementById("InputFkOddCode").value,
		Code: document.getElementById("InputCode").value,
		Naam: document.getElementById("InputNaam").value,
		XfOndPrdCubeTsgType: document.getElementById("InputXfOndPrdCubeTsgType").value,
		XfOndPrdCode: document.getElementById("InputXfOndPrdCode").value,
		XkOndCode: document.getElementById("InputXkOndCode").value,
		XfOndPrdCubeTsgType3: document.getElementById("InputXfOndPrdCubeTsgType3").value,
		XfOndPrdCode3: document.getElementById("InputXfOndPrdCode3").value,
		XkOndCode3: document.getElementById("InputXkOndCode3").value,
		XfOndPrdCubeTsgType1: document.getElementById("InputXfOndPrdCubeTsgType1").value,
		XfOndPrdCode1: document.getElementById("InputXfOndPrdCode1").value,
		XkOndCode1: document.getElementById("InputXkOndCode1").value,
		XfOndPrdCubeTsgType2: document.getElementById("InputXfOndPrdCubeTsgType2").value,
		XfOndPrdCode2: document.getElementById("InputXfOndPrdCode2").value,
		XkOndCode2: document.getElementById("InputXkOndCode2").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateDdd",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_DDD;
		PerformTrans( {
			Service: "CreateDdd",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateDdd() {
	var Type = {
		FkPrdCubeTsgType: document.getElementById("InputFkPrdCubeTsgType").value,
		FkPrdCode: document.getElementById("InputFkPrdCode").value,
		FkOndCode: document.getElementById("InputFkOndCode").value,
		FkOddCode: document.getElementById("InputFkOddCode").value,
		Code: document.getElementById("InputCode").value,
		Naam: document.getElementById("InputNaam").value,
		XfOndPrdCubeTsgType: document.getElementById("InputXfOndPrdCubeTsgType").value,
		XfOndPrdCode: document.getElementById("InputXfOndPrdCode").value,
		XkOndCode: document.getElementById("InputXkOndCode").value,
		XfOndPrdCubeTsgType3: document.getElementById("InputXfOndPrdCubeTsgType3").value,
		XfOndPrdCode3: document.getElementById("InputXfOndPrdCode3").value,
		XkOndCode3: document.getElementById("InputXkOndCode3").value,
		XfOndPrdCubeTsgType1: document.getElementById("InputXfOndPrdCubeTsgType1").value,
		XfOndPrdCode1: document.getElementById("InputXfOndPrdCode1").value,
		XkOndCode1: document.getElementById("InputXkOndCode1").value,
		XfOndPrdCubeTsgType2: document.getElementById("InputXfOndPrdCubeTsgType2").value,
		XfOndPrdCode2: document.getElementById("InputXfOndPrdCode2").value,
		XkOndCode2: document.getElementById("InputXkOndCode2").value
	};
	PerformTrans( {
		Service: "UpdateDdd",
		Parameters: {
			Type
		}
	} );
}

function DeleteDdd() {
	var Type = {
		Code: document.getElementById("InputCode").value
	};
	PerformTrans( {
		Service: "DeleteDdd",
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
	case "Ref002":
		if (l_values == '') {
			document.getElementById("InputXfOndPrdCubeTsgType3").value = '';
		} else {
			document.getElementById("InputXfOndPrdCubeTsgType3").value = l_json_values.FkPrdCubeTsgType;
		}
		if (l_values == '') {
			document.getElementById("InputXfOndPrdCode3").value = '';
		} else {
			document.getElementById("InputXfOndPrdCode3").value = l_json_values.FkPrdCode;
		}
		if (l_values == '') {
			document.getElementById("InputXkOndCode3").value = '';
		} else {
			document.getElementById("InputXkOndCode3").value = l_json_values.Code;
		}
		break;
	case "Ref003":
		if (l_values == '') {
			document.getElementById("InputXfOndPrdCubeTsgType1").value = '';
		} else {
			document.getElementById("InputXfOndPrdCubeTsgType1").value = l_json_values.FkPrdCubeTsgType;
		}
		if (l_values == '') {
			document.getElementById("InputXfOndPrdCode1").value = '';
		} else {
			document.getElementById("InputXfOndPrdCode1").value = l_json_values.FkPrdCode;
		}
		if (l_values == '') {
			document.getElementById("InputXkOndCode1").value = '';
		} else {
			document.getElementById("InputXkOndCode1").value = l_json_values.Code;
		}
		break;
	case "Ref004":
		if (l_values == '') {
			document.getElementById("InputXfOndPrdCubeTsgType2").value = '';
		} else {
			document.getElementById("InputXfOndPrdCubeTsgType2").value = l_json_values.FkPrdCubeTsgType;
		}
		if (l_values == '') {
			document.getElementById("InputXfOndPrdCode2").value = '';
		} else {
			document.getElementById("InputXfOndPrdCode2").value = l_json_values.FkPrdCode;
		}
		if (l_values == '') {
			document.getElementById("InputXkOndCode2").value = '';
		} else {
			document.getElementById("InputXkOndCode2").value = l_json_values.Code;
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
			CubeScopeLevel:1
		},
		Type: {
			FkPrdCubeTsgType:document.getElementById("InputFkPrdCubeTsgType").value,
			FkPrdCode:document.getElementById("InputFkPrdCode").value,
			FkOndCode:document.getElementById("InputFkOndCode").value
		}
	};
	PerformTrans( {
		Service: "GetOndListRecursive",
		Parameters
	} );
}

function StartSelect002(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref002';
	PerformTrans( {
		Service: "GetOndListAll"
	} );
}

function StartSelect003(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref003';
	var Parameters = {
		Option: {
			CubeUpOrDown:"D",
			CubeScopeLevel:9999
		},
		Type: {
			FkPrdCubeTsgType:document.getElementById("InputFkPrdCubeTsgType").value,
			FkPrdCode:document.getElementById("InputFkPrdCode").value,
			FkOndCode:document.getElementById("InputFkOndCode").value
		}
	};
	PerformTrans( {
		Service: "GetOndListRecursive",
		Parameters
	} );
}

function StartSelect004(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref004';
	var Parameters = {
		Option: {
			CubeUpOrDown:"D",
			CubeScopeLevel:1[ELSE]]
			CubeUpOrDown:"X",
			CubeScopeLevel:0
		},
		Type: {
			FkPrdCubeTsgType:document.getElementById("InputFkPrdCubeTsgType").value,
			FkPrdCode:document.getElementById("InputFkPrdCode").value,
			FkOndCode:document.getElementById("InputFkOndCode").value
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
<div><img src="icons/attrib_large.bmp" /><span> ONDERDEEL_DEEL_DEEL</span></div>
<hr/>
<table>
<tr><td>Produkt.Type</td><td><div style="max-width:8em;">
<input id="InputFkPrdCubeTsgType" type="text" maxlength="8" style="width:100%;" onchange="ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Produkt.Code</td><td><div style="max-width:8em;">
<input id="InputFkPrdCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Onderdeel.Code</td><td><div style="max-width:8em;">
<input id="InputFkOndCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>OnderdeelDeel.Code</td><td><div style="max-width:8em;">
<input id="InputFkOddCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Code</u></td><td><div style="max-width:8em;">
<input id="InputCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Naam</td><td><div style="max-width:40em;">
<input id="InputNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/part.bmp"/> Onderdeel (IsVanFirstLevelParent)</legend>
<table style="width:100%;">
<tr><td>Produkt.Type</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfOndPrdCubeTsgType" type="text" maxlength="8" style="width:100%;" onchange="ReplaceSpaces(this);" readonly></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td>Produkt.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfOndPrdCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
<tr><td>Onderdeel.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkOndCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/part.bmp"/> Onderdeel (IsVanParentsAll)</legend>
<table style="width:100%;">
<tr><td>Produkt.Type</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfOndPrdCubeTsgType3" type="text" maxlength="8" style="width:100%;" onchange="ReplaceSpaces(this);" readonly></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
<tr><td>Produkt.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfOndPrdCode3" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
<tr><td>Onderdeel.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkOndCode3" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/part.bmp"/> Onderdeel (IsVanChildAll)</legend>
<table style="width:100%;">
<tr><td>Produkt.Type</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfOndPrdCubeTsgType1" type="text" maxlength="8" style="width:100%;" onchange="ReplaceSpaces(this);" readonly></input></div></td>
<td><button id="RefSelect003" type="button" onclick="StartSelect003(event)">Select</button></td></tr>
<tr><td>Produkt.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfOndPrdCode1" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
<tr><td>Onderdeel.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkOndCode1" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/part.bmp"/> Onderdeel (IsVanFirstLevelChild)</legend>
<table style="width:100%;">
<tr><td>Produkt.Type</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfOndPrdCubeTsgType2" type="text" maxlength="8" style="width:100%;" onchange="ReplaceSpaces(this);" readonly></input></div></td>
<td><button id="RefSelect004" type="button" onclick="StartSelect004(event)">Select</button></td></tr>
<tr><td>Produkt.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfOndPrdCode2" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
<tr><td>Onderdeel.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkOndCode2" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateDdd()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateDdd()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteDdd()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
