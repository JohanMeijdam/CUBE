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
					case "SELECT_PRD":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputCubeTsgSoort").value=l_json_values.CubeTsgSoort;
						document.getElementById("InputCubeTsgSoort1").value=l_json_values.CubeTsgSoort1;
						document.getElementById("InputPrijs").value=l_json_values.Prijs;
						document.getElementById("InputMakelaarNaam").value=l_json_values.MakelaarNaam;
						document.getElementById("InputBedragBtw").value=l_json_values.BedragBtw;
						document.getElementById("InputXkKlnNummer").value=l_json_values.XkKlnNummer;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_PRD":
						document.getElementById("InputCubeTsgType").disabled=true;
						document.getElementById("InputCode").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {CubeTsgType:document.getElementById("InputCubeTsgType").value,Code:document.getElementById("InputCode").value};
						g_node_id = '{"TYP_PRD":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								if (l_json_array[i].Rows.length == 0) {
									var l_position = 'L';
									l_objNodePos = null;
								} else {
									var l_position = 'B';
									var l_objNodePos = parent.document.getElementById('{"TYP_PRD":'+JSON.stringify(l_json_array[i].Rows[0].Key)+'}');
								}
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_PRD',
									l_json_node_id,
									'icons/produkt.bmp', 
									document.getElementById("InputCubeTsgType").value.toLowerCase()+' '+document.getElementById("InputCubeTsgSoort").value.toLowerCase()+' '+document.getElementById("InputCubeTsgSoort1").value.toLowerCase()+' '+document.getElementById("InputCode").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_PRD":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputCubeTsgType").value.toLowerCase()+' '+document.getElementById("InputCubeTsgSoort").value.toLowerCase()+' '+document.getElementById("InputCubeTsgSoort1").value.toLowerCase()+' '+document.getElementById("InputCode").value.toLowerCase();
					}
						break;
					case "DELETE_PRD":
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
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputCubeTsgType").value=l_json_objectKey.TYP_PRD.CubeTsgType;
		document.getElementById("InputCode").value=l_json_objectKey.TYP_PRD.Code;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetPrd",
			Parameters: {
				Type: l_json_objectKey.TYP_PRD
			}
		} );
		document.getElementById("InputCubeTsgType").disabled=true;
		document.getElementById("InputCubeTsgSoort").disabled=true;
		document.getElementById("InputCubeTsgSoort1").disabled=true;
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

function CreatePrd() {
	var Type = {
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		CubeTsgSoort: document.getElementById("InputCubeTsgSoort").value,
		CubeTsgSoort1: document.getElementById("InputCubeTsgSoort1").value,
		Code: document.getElementById("InputCode").value,
		Prijs: document.getElementById("InputPrijs").value,
		MakelaarNaam: document.getElementById("InputMakelaarNaam").value,
		BedragBtw: document.getElementById("InputBedragBtw").value,
		XkKlnNummer: document.getElementById("InputXkKlnNummer").value
	};
	PerformTrans( {
		Service: "CreatePrd",
		Parameters: {
			Type
		}
	} );
}

function UpdatePrd() {
	var Type = {
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		CubeTsgSoort: document.getElementById("InputCubeTsgSoort").value,
		CubeTsgSoort1: document.getElementById("InputCubeTsgSoort1").value,
		Code: document.getElementById("InputCode").value,
		Prijs: document.getElementById("InputPrijs").value,
		MakelaarNaam: document.getElementById("InputMakelaarNaam").value,
		BedragBtw: document.getElementById("InputBedragBtw").value,
		XkKlnNummer: document.getElementById("InputXkKlnNummer").value
	};
	PerformTrans( {
		Service: "UpdatePrd",
		Parameters: {
			Type
		}
	} );
}

function DeletePrd() {
	var Type = {
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Code: document.getElementById("InputCode").value
	};
	PerformTrans( {
		Service: "DeletePrd",
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
	if (document.getElementById("InputCubeTsgType").value != ' ' && document.getElementById("InputCubeTsgSoort").value != ' ' && document.getElementById("InputCubeTsgSoort1").value != ' ') {
		document.getElementById("InputCubeTsgType").disabled=true;
		document.getElementById("InputCubeTsgSoort").disabled=true;
		document.getElementById("InputCubeTsgSoort1").disabled=true;
		switch (document.getElementById("InputCubeTsgType").value) {
		case "P":
			document.getElementById("RowAtbBedragBtw").style.display="none";
			break;
		case "Z":
			document.getElementById("RowRefKlant0").style.display="none";
			break;
		}
		switch (document.getElementById("InputCubeTsgSoort").value) {
		case "R":
			document.getElementById("RowAtbMakelaarNaam").style.display="none";
			break;
		}
		document.getElementById("TableMain").style.display="inline";
	}
}

function ResetFieldCubeTsgSoort1(p_field_id) {
	document.getElementById("InputCubeTsgSoort1").value=' ';
	switch (document.getElementById(p_field_id).value){
	case "R":
		document.getElementById("ValCubeTsgSoort1-GARAGE").style.display="none";
		document.getElementById("ValCubeTsgSoort1-WOON").style.display="none";
		document.getElementById("ValCubeTsgSoort1-VERVOER").style.display="inline";
		break;
	case "O":
		document.getElementById("ValCubeTsgSoort1-GARAGE").style.display="inline";
		document.getElementById("ValCubeTsgSoort1-WOON").style.display="inline";
		document.getElementById("ValCubeTsgSoort1-VERVOER").style.display="none";
		break;
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/produkt_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('PRODUKT','Produkt','PRODUKT','_',-1)"> PRODUKT /
<select id="InputCubeTsgType" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;type&gt;</option>
	<option value="P">PARTICULIER</option>
	<option value="Z">ZAKELIJK</option>
</select> /
<select id="InputCubeTsgSoort" type="text" onchange="ResetFieldCubeTsgSoort1('InputCubeTsgSoort')">
	<option value=" " selected>&lt;soort&gt;</option>
	<option value="R">ROEREND_GOED</option>
	<option value="O">ONROEREND_GOED</option>
</select> <b>.</b>
<select id="InputCubeTsgSoort1" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;soort1&gt;</option>
	<option id="ValCubeTsgSoort1-GARAGE" style="display:none" value="GARAGE">GARAGE</option>
	<option id="ValCubeTsgSoort1-WOON" style="display:none" value="WOON">WOONHUIS</option>
	<option id="ValCubeTsgSoort1-VERVOER" style="display:none" value="VERVOER">VERVOERMIDDEL</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr><td style="cursor:help;" oncontextmenu="parent.OpenDescBox('PRODUKT','Produkt.Code','PRODUKT','CODE',-1)"><u>Code</u></td><td><div style="max-width:8em;">
<input id="InputCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Prijs</td><td><div style="max-width:9em;">
<input id="InputPrijs" type="text" maxlength="9" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbMakelaarNaam"><td>MakelaarNaam</td><td><div style="max-width:40em;">
<input id="InputMakelaarNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr id="RowAtbBedragBtw"><td>BedragBtw</td><td><div style="max-width:9em;">
<input id="InputBedragBtw" type="text" maxlength="9" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefKlant0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/klant.bmp"/> Klant (IsVoor)</legend>
<table style="width:100%;">
<tr><td>Klant.Nummer</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkKlnNummer" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreatePrd()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdatePrd()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeletePrd()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
