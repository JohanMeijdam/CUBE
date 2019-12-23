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
					case "SELECT_KLN":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputCubeTsgIntext").value=l_json_values.CubeTsgIntext;
						document.getElementById("InputCubeTsgVip").value=l_json_values.CubeTsgVip;
						document.getElementById("InputCubeTsgTest").value=l_json_values.CubeTsgTest;
						document.getElementById("InputAchternaam").value=l_json_values.Achternaam;
						document.getElementById("InputGeboorteDatum").value=l_json_values.GeboorteDatum;
						document.getElementById("InputLeeftijd").value=l_json_values.Leeftijd;
						document.getElementById("InputVoornaam").value=l_json_values.Voornaam;
						document.getElementById("InputTussenvoegsel").value=l_json_values.Tussenvoegsel;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_KLN":
						document.getElementById("InputNummer").readOnly=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Nummer:document.getElementById("InputNummer").value};
						g_node_id = '{"TYP_KLN":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_KLN',
									l_json_node_id,
									'icons/klant.bmp', 
									document.getElementById("InputCubeTsgIntext").value.toLowerCase()+' '+document.getElementById("InputCubeTsgVip").value.toLowerCase()+' '+document.getElementById("InputCubeTsgTest").value.toLowerCase()+' '+document.getElementById("InputNummer").value.toLowerCase()+' ('+document.getElementById("InputAchternaam").value.toLowerCase()+')'+' '+document.getElementById("InputVoornaam").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_KLN":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputCubeTsgIntext").value.toLowerCase()+' '+document.getElementById("InputCubeTsgVip").value.toLowerCase()+' '+document.getElementById("InputCubeTsgTest").value.toLowerCase()+' '+document.getElementById("InputNummer").value.toLowerCase()+' ('+document.getElementById("InputAchternaam").value.toLowerCase()+')'+' '+document.getElementById("InputVoornaam").value.toLowerCase();
					}
						break;
					case "DELETE_KLN":
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
		document.getElementById("InputNummer").value=l_json_objectKey.TYP_KLN.Nummer;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetKln",
			Parameters: {
				Type: l_json_objectKey.TYP_KLN
			}
		} );
		document.getElementById("InputCubeTsgIntext").readOnly=true;
		document.getElementById("InputCubeTsgVip").readOnly=true;
		document.getElementById("InputCubeTsgTest").readOnly=true;
		document.getElementById("InputNummer").readOnly=true;
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

function CreateKln() {
	var Type = {
		CubeTsgIntext: document.getElementById("InputCubeTsgIntext").value,
		CubeTsgVip: document.getElementById("InputCubeTsgVip").value,
		CubeTsgTest: document.getElementById("InputCubeTsgTest").value,
		Nummer: document.getElementById("InputNummer").value,
		Achternaam: document.getElementById("InputAchternaam").value,
		GeboorteDatum: document.getElementById("InputGeboorteDatum").value,
		Leeftijd: document.getElementById("InputLeeftijd").value,
		Voornaam: document.getElementById("InputVoornaam").value,
		Tussenvoegsel: document.getElementById("InputTussenvoegsel").value
	};
	PerformTrans( {
		Service: "CreateKln",
		Parameters: {
			Type
		}
	} );
}

function UpdateKln() {
	var Type = {
		CubeTsgIntext: document.getElementById("InputCubeTsgIntext").value,
		CubeTsgVip: document.getElementById("InputCubeTsgVip").value,
		CubeTsgTest: document.getElementById("InputCubeTsgTest").value,
		Nummer: document.getElementById("InputNummer").value,
		Achternaam: document.getElementById("InputAchternaam").value,
		GeboorteDatum: document.getElementById("InputGeboorteDatum").value,
		Leeftijd: document.getElementById("InputLeeftijd").value,
		Voornaam: document.getElementById("InputVoornaam").value,
		Tussenvoegsel: document.getElementById("InputTussenvoegsel").value
	};
	PerformTrans( {
		Service: "UpdateKln",
		Parameters: {
			Type
		}
	} );
}

function DeleteKln() {
	var Type = {
		Nummer: document.getElementById("InputNummer").value
	};
	PerformTrans( {
		Service: "DeleteKln",
		Parameters: {
			Type
		}
	} );
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgIntext").value != ' ' && document.getElementById("InputCubeTsgVip").value != ' ' && document.getElementById("InputCubeTsgTest").value != ' ') {
		document.getElementById("InputCubeTsgIntext").disabled=true;
		document.getElementById("InputCubeTsgVip").disabled=true;
		document.getElementById("InputCubeTsgTest").disabled=true;
		document.getElementById("TableMain").style.display="inline";
	}
}

function ResetFieldCubeTsgVip(p_field_id) {
	document.getElementById("InputCubeTsgVip").value=' ';
	switch (document.getElementById(p_field_id).value){
	case "INT":
		break;
	case "EXT":
		break;
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/klant_large.bmp" /><span> KLANT /
<select id="InputCubeTsgIntext" type="text" onchange="ResetFieldCubeTsgVip('InputCubeTsgIntext')">
	<option value=" " selected>&lt;intext&gt;</option>
	<option value="INT">INTERN</option>
	<option value="EXT">EXTERN</option>
</select> <b>.</b>
<select id="InputCubeTsgVip" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;vip&gt;</option>
	<option id="ValCubeTsgVip-VIP" style="display:none" value="VIP"></option>
</select> /
<select id="InputCubeTsgTest" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;test&gt;</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr><td><u>Nummer</u></td><td><div style="max-width:8em;">
<input id="InputNummer" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Achternaam</td><td><div style="max-width:40em;">
<input id="InputAchternaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td>GeboorteDatum</td><td><div style="max-width:12ch;">
<input id="InputGeboorteDatum" type="text" maxlength="10" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Leeftijd</td><td><div style="max-width:9em;">
<input id="InputLeeftijd" type="text" maxlength="9" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Voornaam</td><td><div style="max-width:40em;">
<input id="InputVoornaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td>Tussenvoegsel</td><td><div style="max-width:40em;">
<input id="InputTussenvoegsel" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateKln()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateKln()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteKln()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
