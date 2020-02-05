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
					case "SELECT_ORD":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputCubeTsgIntExt").value=l_json_values.CubeTsgIntExt;
						document.getElementById("InputXkKlnNummer").value=l_json_values.XkKlnNummer;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_ORD":
						document.getElementById("InputCode").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Code:document.getElementById("InputCode").value};
						g_node_id = '{"TYP_ORD":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_ORD',
									l_json_node_id,
									'icons/order.bmp', 
									'('+document.getElementById("InputCubeTsgIntExt").value.toLowerCase()+')'+' '+document.getElementById("InputCode").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_ORD":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+'('+document.getElementById("InputCubeTsgIntExt").value.toLowerCase()+')'+' '+document.getElementById("InputCode").value.toLowerCase();
					}
						break;
					case "DELETE_ORD":
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
					case "LIST_KLN":
						OpenListBox(l_json_array[i].Rows,'klant','Klant','Y');
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
		document.getElementById("InputCode").value=l_json_objectKey.TYP_ORD.Code;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetOrd",
			Parameters: {
				Type: l_json_objectKey.TYP_ORD
			}
		} );
		document.getElementById("InputCubeTsgIntExt").disabled=true;
		document.getElementById("InputCode").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateOrd() {
	var Type = {
		CubeTsgIntExt: document.getElementById("InputCubeTsgIntExt").value,
		Code: document.getElementById("InputCode").value,
		XkKlnNummer: document.getElementById("InputXkKlnNummer").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateOrd",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_ORD;
		PerformTrans( {
			Service: "CreateOrd",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateOrd() {
	var Type = {
		CubeTsgIntExt: document.getElementById("InputCubeTsgIntExt").value,
		Code: document.getElementById("InputCode").value,
		XkKlnNummer: document.getElementById("InputXkKlnNummer").value
	};
	PerformTrans( {
		Service: "UpdateOrd",
		Parameters: {
			Type
		}
	} );
}

function DeleteOrd() {
	var Type = {
		Code: document.getElementById("InputCode").value
	};
	PerformTrans( {
		Service: "DeleteOrd",
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
			document.getElementById("InputXkKlnNummer").value = '';
		} else {
			document.getElementById("InputXkKlnNummer").value = l_json_values.Nummer;
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
		Service: "GetKlnList"
	} );
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgIntExt").value != ' ') {
		document.getElementById("InputCubeTsgIntExt").disabled=true;
		document.getElementById("TableMain").style.display="inline";
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/order_large.bmp" /><span> ORDER /
<select id="InputCubeTsgIntExt" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;int_ext&gt;</option>
	<option value="INT">INTERNAL</option>
	<option value="EXT">EXTERNAL</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr><td><u>Code</u></td><td><div style="max-width:8em;">
<input id="InputCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/klant.bmp"/> Klant (IsBesteldDoor)</legend>
<table style="width:100%;">
<tr><td>Klant.Nummer</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkKlnNummer" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateOrd()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateOrd()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteOrd()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
