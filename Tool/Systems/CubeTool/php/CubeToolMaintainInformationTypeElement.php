<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeInclude.js?filever=<?=filemtime('../CubeGeneral/CubeInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeDetailInclude.js?filever=<?=filemtime('../CubeGeneral/CubeDetailInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeToolInclude.js?filever=<?=filemtime('CubeToolInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeToolDetailInclude.js?filever=<?=filemtime('CubeToolDetailInclude.js')?>"></script>
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
					case "SELECT_ITE":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputSuffix").value=l_json_values.Suffix;
						document.getElementById("InputDomain").value=l_json_values.Domain;
						document.getElementById("InputLength").value=l_json_values.Length;
						document.getElementById("InputDecimals").value=l_json_values.Decimals;
						document.getElementById("InputCaseSensitive").value=l_json_values.CaseSensitive;
						document.getElementById("InputDefaultValue").value=l_json_values.DefaultValue;
						document.getElementById("InputSpacesAllowed").value=l_json_values.SpacesAllowed;
						document.getElementById("InputPresentation").value=l_json_values.Presentation;
						break;
					case "CREATE_ITE":
						document.getElementById("InputFkItpName").disabled=true;
						document.getElementById("InputSequence").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkItpName:document.getElementById("InputFkItpName").value,Sequence:document.getElementById("InputSequence").value};
						g_node_id = '{"TYP_ITE":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								if (l_json_array[i].Rows.length == 0) {
									var l_position = 'L';
									l_objNodePos = null;
								} else {
									var l_position = 'B';
									var l_objNodePos = parent.document.getElementById('{"TYP_ITE":'+JSON.stringify(l_json_array[i].Rows[0].Key)+'}');
								}
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_ITE',
									l_json_node_id,
									'icons/infelem.bmp',
									'InformationTypeElement',
									document.getElementById("InputSuffix").value.toLowerCase()+' ('+document.getElementById("InputDomain").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateIte()};						
						ResetChangePending();
						break;
					case "UPDATE_ITE":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputSuffix").value.toLowerCase()+' ('+document.getElementById("InputDomain").value.toLowerCase()+')';
						}
						ResetChangePending();
						break;
					case "DELETE_ITE":
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

function CreateIte() {
	if (document.getElementById("InputFkItpName").value == '') {
		alert ('Error: Primary key FkItpName not filled');
		return;
	}
	if (document.getElementById("InputSequence").value == '') {
		alert ('Error: Primary key Sequence not filled');
		return;
	}
	var Type = {
		FkItpName: document.getElementById("InputFkItpName").value,
		Sequence: document.getElementById("InputSequence").value,
		Suffix: document.getElementById("InputSuffix").value,
		Domain: document.getElementById("InputDomain").value,
		Length: document.getElementById("InputLength").value,
		Decimals: document.getElementById("InputDecimals").value,
		CaseSensitive: document.getElementById("InputCaseSensitive").value,
		DefaultValue: document.getElementById("InputDefaultValue").value,
		SpacesAllowed: document.getElementById("InputSpacesAllowed").value,
		Presentation: document.getElementById("InputPresentation").value
	};
	PerformTrans( {
		Service: "CreateIte",
		Parameters: {
			Type
		}
	} );
}

function UpdateIte() {
	var Type = {
		FkItpName: document.getElementById("InputFkItpName").value,
		Sequence: document.getElementById("InputSequence").value,
		Suffix: document.getElementById("InputSuffix").value,
		Domain: document.getElementById("InputDomain").value,
		Length: document.getElementById("InputLength").value,
		Decimals: document.getElementById("InputDecimals").value,
		CaseSensitive: document.getElementById("InputCaseSensitive").value,
		DefaultValue: document.getElementById("InputDefaultValue").value,
		SpacesAllowed: document.getElementById("InputSpacesAllowed").value,
		Presentation: document.getElementById("InputPresentation").value
	};
	PerformTrans( {
		Service: "UpdateIte",
		Parameters: {
			Type
		}
	} );
}

function DeleteIte() {
	var Type = {
		FkItpName: document.getElementById("InputFkItpName").value,
		Sequence: document.getElementById("InputSequence").value
	};
	PerformTrans( {
		Service: "DeleteIte",
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
		document.getElementById("InputFkItpName").value = l_json_objectKey.TYP_ITE.FkItpName;
		document.getElementById("InputSequence").value = l_json_objectKey.TYP_ITE.Sequence;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateIte()};
		PerformTrans( {
			Service: "GetIte",
			Parameters: {
				Type: l_json_objectKey.TYP_ITE
			}
		} );
		document.getElementById("InputFkItpName").disabled = true;
		document.getElementById("InputSequence").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkItpName").value = l_json_objectKey.TYP_ITP.Name;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateIte()};
		document.getElementById("InputFkItpName").disabled = true;
		document.getElementById("InputSequence").value='0';
		document.getElementById("InputSuffix").value='#';
		document.getElementById("InputDomain").value='TEXT';
		document.getElementById("InputLength").value='0';
		document.getElementById("InputDecimals").value='0';
		document.getElementById("InputCaseSensitive").value='N';
		document.getElementById("InputSpacesAllowed").value='N';
		document.getElementById("InputPresentation").value='LIN';
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkItpName").value = l_json_objectKey.TYP_ITE.FkItpName;
		document.getElementById("InputSequence").value = l_json_objectKey.TYP_ITE.Sequence;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteIte()};
		SetChangePending();
		PerformTrans( {
			Service: "GetIte",
			Parameters: {
				Type: l_json_objectKey.TYP_ITE
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputFkItpName").disabled = true;
		document.getElementById("InputSequence").disabled = true;
		document.getElementById("InputSuffix").disabled = true;
		document.getElementById("InputDomain").disabled = true;
		document.getElementById("InputLength").disabled = true;
		document.getElementById("InputDecimals").disabled = true;
		document.getElementById("InputCaseSensitive").disabled = true;
		document.getElementById("InputDefaultValue").disabled = true;
		document.getElementById("InputSpacesAllowed").disabled = true;
		document.getElementById("InputPresentation").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/infelem_large.bmp" /><span> INFORMATION_TYPE_ELEMENT</span></div>
<hr/>
<table>
<tr id="RowAtbFkItpName"><td><u><div>InformationType.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkItpName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbSequence"><td><u><div>Sequence</div></u></td><td><div style="max-width:9em;"><input id="InputSequence" type="text" maxlength="9" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbSuffix"><td><div>Suffix</div></td><td><div style="max-width:12em;"><input id="InputSuffix" type="text" maxlength="12" style="width:100%" onchange="SetChangePending();ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbDomain"><td><div>Domain</div></td><td><div><select id="InputDomain" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionDomain-TEXT" style="display:inline" value="TEXT">Text</option>
	<option id="OptionDomain-NUMBER" style="display:inline" value="NUMBER">Number</option>
	<option id="OptionDomain-DATE" style="display:inline" value="DATE">Date</option>
	<option id="OptionDomain-TIME" style="display:inline" value="TIME">Time</option>
	<option id="OptionDomain-DATETIME-LOCAL" style="display:inline" value="DATETIME-LOCAL">Timestamp</option>
</select></div></td></tr>
<tr id="RowAtbLength"><td><div>Length</div></td><td><div style="max-width:9em;"><input id="InputLength" type="text" maxlength="9" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbDecimals"><td><div>Decimals</div></td><td><div style="max-width:9em;"><input id="InputDecimals" type="text" maxlength="9" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbCaseSensitive"><td><div>CaseSensitive</div></td><td><div><select id="InputCaseSensitive" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionCaseSensitive-Y" style="display:inline" value="Y">Yes</option>
	<option id="OptionCaseSensitive-N" style="display:inline" value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbDefaultValue"><td><div>DefaultValue</div></td><td><div style="max-width:32em;"><input id="InputDefaultValue" type="text" maxlength="32" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbSpacesAllowed"><td><div>SpacesAllowed</div></td><td><div><select id="InputSpacesAllowed" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionSpacesAllowed-Y" style="display:inline" value="Y">Yes</option>
	<option id="OptionSpacesAllowed-N" style="display:inline" value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbPresentation"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('infelem','InformationTypeElement.Presentation','INFORMATION_TYPE_ELEMENT','PRESENTATION',-1)"><div>Presentation</div></td><td><div><select id="InputPresentation" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionPresentation-LIN" style="display:inline" value="LIN">Line</option>
	<option id="OptionPresentation-DES" style="display:inline" value="DES">Description</option>
	<option id="OptionPresentation-COD" style="display:inline" value="COD">Code</option>
</select></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
