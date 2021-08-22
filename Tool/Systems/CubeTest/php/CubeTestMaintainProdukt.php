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
					case "SELECT_PRD":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputCubeTsgSoort").value=l_json_values.CubeTsgSoort;
						document.getElementById("InputCubeTsgSoort1").value=l_json_values.CubeTsgSoort1;
						document.getElementById("InputPrijs").value=l_json_values.Prijs;
						document.getElementById("InputMakelaarNaam").value=l_json_values.MakelaarNaam;
						document.getElementById("InputBedragBtw").value=l_json_values.BedragBtw;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_PRD":
						document.getElementById("InputCubeTsgType").disabled=true;
						document.getElementById("InputCode").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
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
									'Produkt',
									'('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')'+' ('+document.getElementById("InputCubeTsgSoort").value.toLowerCase()+')'+' ('+document.getElementById("InputCubeTsgSoort1").value.toLowerCase()+')'+' '+document.getElementById("InputCode").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdatePrd()};						
						ResetChangePending();
						break;
					case "UPDATE_PRD":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+'('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')'+' ('+document.getElementById("InputCubeTsgSoort").value.toLowerCase()+')'+' ('+document.getElementById("InputCubeTsgSoort1").value.toLowerCase()+')'+' '+document.getElementById("InputCode").value.toLowerCase();
						}
						ResetChangePending();
						break;
					case "DELETE_PRD":
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

function CreatePrd() {
	if (document.getElementById("InputCode").value == '') {
		alert ('Error: Primary key Code not filled');
		return;
	}
	var Type = {
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		CubeTsgSoort: document.getElementById("InputCubeTsgSoort").value,
		CubeTsgSoort1: document.getElementById("InputCubeTsgSoort1").value,
		Code: document.getElementById("InputCode").value,
		Prijs: document.getElementById("InputPrijs").value,
		MakelaarNaam: document.getElementById("InputMakelaarNaam").value,
		BedragBtw: document.getElementById("InputBedragBtw").value
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
		BedragBtw: document.getElementById("InputBedragBtw").value
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
		document.getElementById("InputCubeTsgType").value = l_json_objectKey.TYP_PRD.CubeTsgType;
		document.getElementById("InputCode").value = l_json_objectKey.TYP_PRD.Code;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdatePrd()};
		PerformTrans( {
			Service: "GetPrd",
			Parameters: {
				Type: l_json_objectKey.TYP_PRD
			}
		} );
		document.getElementById("InputCubeTsgType").disabled = true;
		document.getElementById("InputCubeTsgSoort").disabled = true;
		document.getElementById("InputCubeTsgSoort1").disabled = true;
		document.getElementById("InputCode").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreatePrd()};
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputCubeTsgType").value = l_json_objectKey.TYP_PRD.CubeTsgType;
		document.getElementById("InputCode").value = l_json_objectKey.TYP_PRD.Code;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeletePrd()};
		SetChangePending();
		PerformTrans( {
			Service: "GetPrd",
			Parameters: {
				Type: l_json_objectKey.TYP_PRD
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeTsgType").disabled = true;
		document.getElementById("InputCubeTsgSoort").disabled = true;
		document.getElementById("InputCubeTsgSoort1").disabled = true;
		document.getElementById("InputCode").disabled = true;
		document.getElementById("InputPrijs").disabled = true;
		document.getElementById("InputMakelaarNaam").disabled = true;
		document.getElementById("InputBedragBtw").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgType").value != ' ' && document.getElementById("InputCubeTsgSoort").value != ' ' && document.getElementById("InputCubeTsgSoort1").value != ' ') {
		document.getElementById("InputCubeTsgType").disabled = true;
		switch (document.getElementById("InputCubeTsgType").value) {
		case "P":
			document.getElementById("RowAtbBedragBtw").style.display = "none";
			break;
		}
		document.getElementById("InputCubeTsgSoort").disabled = true;
		switch (document.getElementById("InputCubeTsgSoort").value) {
		case "R":
			document.getElementById("RowAtbMakelaarNaam").style.display = "none";
			break;
		}
		document.getElementById("InputCubeTsgSoort1").disabled = true;
		document.getElementById("TableMain").style.display = "inline";
	}
}

function ProcessChangeInputCubeTsgSoort(p_obj) {
	document.getElementById("InputCubeTsgSoort1").value = ' ';
	switch (p_obj.value){
	case " ":
		document.getElementById("OptionCubeTsgSoort1-VERVOER").style.display = "none";
		document.getElementById("OptionCubeTsgSoort1-GARAGE").style.display = "none";
		document.getElementById("OptionCubeTsgSoort1-WOON").style.display = "none";
		break;
	case "R":
		document.getElementById("OptionCubeTsgSoort1-VERVOER").style.display = "inline";
		document.getElementById("OptionCubeTsgSoort1-GARAGE").style.display = "none";
		document.getElementById("OptionCubeTsgSoort1-WOON").style.display = "none";
		break;
	case "O":
		document.getElementById("OptionCubeTsgSoort1-VERVOER").style.display = "none";
		document.getElementById("OptionCubeTsgSoort1-GARAGE").style.display = "inline";
		document.getElementById("OptionCubeTsgSoort1-WOON").style.display = "inline";
		break;
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/produkt_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('produkt','Produkt','PRODUKT','_',-1)"> PRODUKT /
<select id="InputCubeTsgType" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;type&gt;</option>
	<option id="OptionCubeTsgType-P" style="display:inline" value="P">PARTICULIER</option>
	<option id="OptionCubeTsgType-Z" style="display:inline" value="Z">ZAKELIJK</option>
</select> /
<select id="InputCubeTsgSoort" type="text" onchange="ProcessChangeInputCubeTsgSoort(this);">
	<option value=" " selected>&lt;soort&gt;</option>
	<option id="OptionCubeTsgSoort-R" style="display:inline" value="R">ROEREND_GOED</option>
	<option id="OptionCubeTsgSoort-O" style="display:inline" value="O">ONROEREND_GOED</option>
</select> <b>.</b>
<select id="InputCubeTsgSoort1" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;soort1&gt;</option>
	<option id="OptionCubeTsgSoort1-GARAGE" style="display:inline" value="GARAGE">GARAGE</option>
	<option id="OptionCubeTsgSoort1-WOON" style="display:inline" value="WOON">WOONHUIS</option>
	<option id="OptionCubeTsgSoort1-VERVOER" style="display:inline" value="VERVOER">VERVOERMIDDEL</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr id="RowAtbCode"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('produkt','Produkt.Code','PRODUKT','CODE',-1)"><u><div>Code</div></u></td><td><div style="max-width:8em;"><input id="InputCode" type="text" maxlength="8" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbPrijs"><td><div>Prijs</div></td><td><div style="max-width:9em;"><input id="InputPrijs" type="text" maxlength="9" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbMakelaarNaam"><td><div>MakelaarNaam</div></td><td><div style="max-width:40em;"><input id="InputMakelaarNaam" type="text" maxlength="40" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbBedragBtw"><td><div>BedragBtw</div></td><td><div style="max-width:9em;"><input id="InputBedragBtw" type="text" maxlength="9" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
