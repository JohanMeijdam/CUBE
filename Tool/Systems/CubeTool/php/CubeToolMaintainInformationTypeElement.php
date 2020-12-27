<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeInclude.js"></script>
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeDetailInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeToolInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeToolDetailInclude.js"></script>
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
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
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
									document.getElementById("InputSuffix").value.toLowerCase()+' ('+document.getElementById("InputDomain").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_ITE":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputSuffix").value.toLowerCase()+' ('+document.getElementById("InputDomain").value.toLowerCase()+')';
					}
						break;
					case "DELETE_ITE":
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
		document.getElementById("InputFkItpName").value=l_json_objectKey.TYP_ITE.FkItpName;
		document.getElementById("InputSequence").value=l_json_objectKey.TYP_ITE.Sequence;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetIte",
			Parameters: {
				Type: l_json_objectKey.TYP_ITE
			}
		} );
		document.getElementById("InputFkItpName").disabled=true;
		document.getElementById("InputSequence").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkItpName").value=l_json_objectKey.TYP_ITP.Name;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkItpName").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
	document.getElementById("InputDomain").value='TEXT';
	document.getElementById("InputLength").value='0';
	document.getElementById("InputDecimals").value='0';
	document.getElementById("InputCaseSensitive").value='N';
	document.getElementById("InputSpacesAllowed").value='N';
	document.getElementById("InputPresentation").value='LIN';
}

function CreateIte() {
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
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/infelem_large.bmp" /><span> INFORMATION_TYPE_ELEMENT</span></div>
<hr/>
<table>
<tr id="RowAtbFkItpName"><td><u><div>InformationType.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkItpName" type="text" maxlength="30" style="width:100%" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbSequence"><td><u><div>Sequence</div></u></td><td><div style="max-width:9em;"><input id="InputSequence" type="text" maxlength="9" style="width:100%"></input></div></td></tr>
<tr id="RowAtbSuffix"><td><div>Suffix</div></td><td><div style="max-width:12em;"><input id="InputSuffix" type="text" maxlength="12" style="width:100%" onchange="ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbDomain"><td><div>Domain</div></td><td><div><select id="InputDomain" type="text">
	<option value=" " selected> </option>
	<option value="TEXT">Text</option>
	<option value="NUMBER">Number</option>
	<option value="DATE">Date</option>
	<option value="TIME">Time</option>
	<option value="DATETIME-LOCAL">Timestamp</option>
</select></div></td></tr>
<tr id="RowAtbLength"><td><div>Length</div></td><td><div style="max-width:9em;"><input id="InputLength" type="text" maxlength="9" style="width:100%"></input></div></td></tr>
<tr id="RowAtbDecimals"><td><div>Decimals</div></td><td><div style="max-width:9em;"><input id="InputDecimals" type="text" maxlength="9" style="width:100%"></input></div></td></tr>
<tr id="RowAtbCaseSensitive"><td><div>CaseSensitive</div></td><td><div><select id="InputCaseSensitive" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbDefaultValue"><td><div>DefaultValue</div></td><td><div style="max-width:32em;"><input id="InputDefaultValue" type="text" maxlength="32" style="width:100%"></input></div></td></tr>
<tr id="RowAtbSpacesAllowed"><td><div>SpacesAllowed</div></td><td><div><select id="InputSpacesAllowed" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbPresentation"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('infelem','InformationTypeElement.Presentation','INFORMATION_TYPE_ELEMENT','PRESENTATION',-1)"><div>Presentation</div></td><td><div><select id="InputPresentation" type="text">
	<option value=" " selected> </option>
	<option value="LIN">Line</option>
	<option value="DES">Description</option>
	<option value="COD">Code</option>
</select></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateIte()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateIte()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteIte()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
