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
					case "SELECT_DER":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputCubeTsgType").value=l_json_values.CubeTsgType;
						document.getElementById("InputAggregateFunction").value=l_json_values.AggregateFunction;
						document.getElementById("InputXkTypName").value=l_json_values.XkTypName;
						document.getElementById("InputXkTypName1").value=l_json_values.XkTypName1;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_DER":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkAtbName").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkAtbName:document.getElementById("InputFkAtbName").value};
						g_node_id = '{"TYP_DER":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_DER',
									l_json_node_id,
									'icons/deriv.bmp',
									'Derivation',
									'('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateDer()};						
						ResetChangePending();
						break;
					case "UPDATE_DER":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+'('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')';
						}
						ResetChangePending();
						break;
					case "DELETE_DER":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (g_parent_node_id == null) {
							g_parent_node_id = l_objNode.parentNode.parentNode.id;
						} 
						if (l_objNode != null) {
							l_objNode.parentNode.removeChild(l_objNode);
						}
						CancelChangePending();
						break;
					case "SELECT_FKEY_ATB":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						break;
					case "ERROR":
						alert ('Server error:\n'+l_json_array[i].ErrorText);
						break;
					default:
						if (l_json_array[i].ResultName.substring(0,5) == 'LIST_') {
							switch (document.body._ListBoxCode){
								case "Ref001":
									OpenListBox(l_json_array[i].Rows,'type','Type');
									break;
								case "Ref002":
									OpenListBox(l_json_array[i].Rows,'type','Type');
									break;
							}
						} else {
							alert ('Unknown reply:\n'+g_responseText);
						}
						
				}
			}
		} else {
			alert ('Request error:\n'+g_xmlhttp.statusText);
		}
	}
}

function CreateDer() {
	if (document.getElementById("InputFkTypName").value == '') {
		alert ('Error: Primary key FkTypName not filled');
		return;
	}
	if (document.getElementById("InputFkAtbName").value == '') {
		alert ('Error: Primary key FkAtbName not filled');
		return;
	}
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkAtbName: document.getElementById("InputFkAtbName").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		AggregateFunction: document.getElementById("InputAggregateFunction").value,
		XkTypName: document.getElementById("InputXkTypName").value,
		XkTypName1: document.getElementById("InputXkTypName1").value
	};
	PerformTrans( {
		Service: "CreateDer",
		Parameters: {
			Type
		}
	} );
}

function UpdateDer() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkAtbName: document.getElementById("InputFkAtbName").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		AggregateFunction: document.getElementById("InputAggregateFunction").value,
		XkTypName: document.getElementById("InputXkTypName").value,
		XkTypName1: document.getElementById("InputXkTypName1").value
	};
	PerformTrans( {
		Service: "UpdateDer",
		Parameters: {
			Type
		}
	} );
}

function DeleteDer() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkAtbName: document.getElementById("InputFkAtbName").value
	};
	PerformTrans( {
		Service: "DeleteDer",
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
			document.getElementById("InputXkTypName").value = '';
		} else {
			document.getElementById("InputXkTypName").value = l_json_values.Name;
		}
		break;
	case "Ref002":
		if (l_values == '') {
			document.getElementById("InputXkTypName1").value = '';
		} else {
			document.getElementById("InputXkTypName1").value = l_json_values.Name;
		}
		break;
	default:
		alert ('Error Listbox: '+document.body._ListBoxCode);
	}
	CloseListBox();
	SetChangePending();
}

function StartSelect001(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref001';
	document.body._ListBoxOptional = 'Y';
	PerformTrans( {
		Service: "GetTypListAll"
	} );
}

function StartSelect002(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref002';
	document.body._ListBoxOptional = 'Y';
	PerformTrans( {
		Service: "GetTypListAll"
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
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_DER.FkTypName;
		document.getElementById("InputFkAtbName").value = l_json_objectKey.TYP_DER.FkAtbName;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateDer()};
		PerformTrans( {
			Service: "GetDer",
			Parameters: {
				Type: l_json_objectKey.TYP_DER
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkAtbName").disabled = true;
		document.getElementById("InputCubeTsgType").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_ATB.FkTypName;
		document.getElementById("InputFkAtbName").value = l_json_objectKey.TYP_ATB.Name;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateDer()};
		PerformTrans( {
			Service: "GetAtbFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_ATB
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkAtbName").disabled = true;
		document.getElementById("InputAggregateFunction").value='SUM';
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_DER.FkTypName;
		document.getElementById("InputFkAtbName").value = l_json_objectKey.TYP_DER.FkAtbName;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteDer()};
		SetChangePending();
		PerformTrans( {
			Service: "GetDer",
			Parameters: {
				Type: l_json_objectKey.TYP_DER
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkAtbName").disabled = true;
		document.getElementById("InputCubeTsgType").disabled = true;
		document.getElementById("InputAggregateFunction").disabled = true;
		document.getElementById("InputXkTypName").disabled = true;
		document.getElementById("InputXkTypName1").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgType").value != ' ') {
		document.getElementById("InputCubeTsgType").disabled = true;
		switch (document.getElementById("InputCubeTsgType").value) {
		case "AG":
			document.getElementById("RowAtbAggregateFunction").style.display = "none";
			document.getElementById("RowAtbAggregateFunction").style.display = "none";
			break;
		}
		document.getElementById("TableMain").style.display = "inline";
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/deriv_large.bmp" /><span> DERIVATION /
<select id="InputCubeTsgType" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;type&gt;</option>
	<option id="OptionCubeTsgType-DN" style="display:inline" value="DN">DENORMALIZATION</option>
	<option id="OptionCubeTsgType-IN" style="display:inline" value="IN">INTERNAL</option>
	<option id="OptionCubeTsgType-AG" style="display:inline" value="AG">AGGREGATION</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr id="RowAtbFkBotName"><td><div>BusinessObjectType.Name</div></td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkAtbName"><td><u><div>Attribute.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkAtbName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbAggregateFunction"><td><div style="padding-top:10px">AggregateFunction</div></td></tr><tr><td colspan="2"><div><select id="InputAggregateFunction" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionAggregateFunction-SUM" style="display:inline" value="SUM">Sum</option>
	<option id="OptionAggregateFunction-AVG" style="display:inline" value="AVG">Average</option>
	<option id="OptionAggregateFunction-MIN" style="display:inline" value="MIN">Minimum</option>
	<option id="OptionAggregateFunction-MAX" style="display:inline" value="MAX">Maximum</option>
</select></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefType0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (ConcernsParent)</legend>
<table style="width:100%">
<tr><td>Type.Name</td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefType1"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (ConcernsChild)</legend>
<table style="width:100%">
<tr><td>Type.Name</td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkTypName1" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
