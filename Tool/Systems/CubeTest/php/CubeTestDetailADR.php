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
					case "SELECT_ADR":
						var l_json_values = l_json_array[i].Rows[0].Data;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_ADR":
						document.getElementById("InputFkKlnNummer").disabled=true;
						document.getElementById("InputPostcodeCijfers").disabled=true;
						document.getElementById("InputPostcodeLetters").disabled=true;
						document.getElementById("InputCubeTsgTest").disabled=true;
						document.getElementById("InputHuisnummer").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkKlnNummer:document.getElementById("InputFkKlnNummer").value,PostcodeCijfers:document.getElementById("InputPostcodeCijfers").value,PostcodeLetters:document.getElementById("InputPostcodeLetters").value,CubeTsgTest:document.getElementById("InputCubeTsgTest").value,Huisnummer:document.getElementById("InputHuisnummer").value};
						g_node_id = '{"TYP_ADR":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_ADR',
									l_json_node_id,
									'icons/adres.bmp', 
									document.getElementById("InputPostcodeCijfers").value.toLowerCase()+' '+document.getElementById("InputPostcodeLetters").value.toLowerCase()+' '+document.getElementById("InputCubeTsgTest").value.toLowerCase()+' '+document.getElementById("InputHuisnummer").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_ADR":
						break;
					case "DELETE_ADR":
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
		document.getElementById("InputFkKlnNummer").value=l_json_objectKey.TYP_ADR.FkKlnNummer;
		document.getElementById("InputPostcodeCijfers").value=l_json_objectKey.TYP_ADR.PostcodeCijfers;
		document.getElementById("InputPostcodeLetters").value=l_json_objectKey.TYP_ADR.PostcodeLetters;
		document.getElementById("InputCubeTsgTest").value=l_json_objectKey.TYP_ADR.CubeTsgTest;
		document.getElementById("InputHuisnummer").value=l_json_objectKey.TYP_ADR.Huisnummer;
		document.getElementById("ButtonCreate").disabled=true;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("InputFkKlnNummer").disabled=true;
		document.getElementById("InputPostcodeCijfers").disabled=true;
		document.getElementById("InputPostcodeLetters").disabled=true;
		document.getElementById("InputCubeTsgTest").disabled=true;
		document.getElementById("InputHuisnummer").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkKlnNummer").value=l_json_objectKey.TYP_KLN.Nummer;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkKlnNummer").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateAdr() {
	var Type = {
		FkKlnNummer: document.getElementById("InputFkKlnNummer").value,
		PostcodeCijfers: document.getElementById("InputPostcodeCijfers").value,
		PostcodeLetters: document.getElementById("InputPostcodeLetters").value,
		CubeTsgTest: document.getElementById("InputCubeTsgTest").value,
		Huisnummer: document.getElementById("InputHuisnummer").value
	};
	PerformTrans( {
		Service: "CreateAdr",
		Parameters: {
			Type
		}
	} );
}

function UpdateAdr() {
	var Type = {
		FkKlnNummer: document.getElementById("InputFkKlnNummer").value,
		PostcodeCijfers: document.getElementById("InputPostcodeCijfers").value,
		PostcodeLetters: document.getElementById("InputPostcodeLetters").value,
		CubeTsgTest: document.getElementById("InputCubeTsgTest").value,
		Huisnummer: document.getElementById("InputHuisnummer").value
	};
	PerformTrans( {
		Service: "UpdateAdr",
		Parameters: {
			Type
		}
	} );
}

function DeleteAdr() {
	var Type = {
		FkKlnNummer: document.getElementById("InputFkKlnNummer").value,
		PostcodeCijfers: document.getElementById("InputPostcodeCijfers").value,
		PostcodeLetters: document.getElementById("InputPostcodeLetters").value,
		CubeTsgTest: document.getElementById("InputCubeTsgTest").value,
		Huisnummer: document.getElementById("InputHuisnummer").value
	};
	PerformTrans( {
		Service: "DeleteAdr",
		Parameters: {
			Type
		}
	} );
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgTest").value != ' ') {
		document.getElementById("InputCubeTsgTest").disabled=true;
		document.getElementById("TableMain").style.display="inline";
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/adres_large.bmp" /><span> ADRES /
<select id="InputCubeTsgTest" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;test&gt;</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr><td><u>Klant.Nummer</u></td><td><div style="max-width:8em;">
<input id="InputFkKlnNummer" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>PostcodeCijfers</u></td><td><div style="max-width:5em;">
<input id="InputPostcodeCijfers" type="text" maxlength="5" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>PostcodeLetters</u></td><td><div style="max-width:2em;">
<input id="InputPostcodeLetters" type="text" maxlength="2" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Huisnummer</u></td><td><div style="max-width:9em;">
<input id="InputHuisnummer" type="text" maxlength="9" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateAdr()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateAdr()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteAdr()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
