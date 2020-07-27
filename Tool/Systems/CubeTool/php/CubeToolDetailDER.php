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
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
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
									'('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_DER":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+'('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')';
					}
						break;
					case "DELETE_DER":
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
					case "LIST_TYP":
						OpenListBox(l_json_array[i].Rows,'type','Type','Y');
						break;
					case "LIST_TYP":
						OpenListBox(l_json_array[i].Rows,'type','Type','Y');
						break;
					case "SELECT_FKEY_ATB":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
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
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_DER.FkTypName;
		document.getElementById("InputFkAtbName").value=l_json_objectKey.TYP_DER.FkAtbName;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetDer",
			Parameters: {
				Type: l_json_objectKey.TYP_DER
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkAtbName").disabled=true;
		document.getElementById("InputCubeTsgType").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_ATB.FkTypName;
		document.getElementById("InputFkAtbName").value=l_json_objectKey.TYP_ATB.Name;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		PerformTrans( {
			Service: "GetAtbFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_ATB
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkAtbName").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
	document.getElementById("InputAggregateFunction").value='SUM';
}

function CreateDer() {
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
}

function StartSelect001(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref001';
	PerformTrans( {
		Service: "GetTypListAll"
	} );
}

function StartSelect002(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref002';
	PerformTrans( {
		Service: "GetTypListAll"
	} );
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgType").value != ' ') {
		document.getElementById("InputCubeTsgType").disabled=true;
		switch (document.getElementById("InputCubeTsgType").value) {
		case "AG":
			document.getElementById("RowAtbAggregateFunction").style.display="none";
			document.getElementById("RowAtbAggregateFunction").style.display="none";
			break;
		}
		document.getElementById("TableMain").style.display="inline";
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/deriv_large.bmp" /><span> DERIVATION /
<select id="InputCubeTsgType" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;type&gt;</option>
	<option value="DN">DENORMALIZATION</option>
	<option value="IN">INTERNAL</option>
	<option value="AG">AGGREGATION</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr id="RowAtbFkBotName"><td>BusinessObjectType.Name</td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u>Type.Name</u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkAtbName"><td><u>Attribute.Name</u></td><td><div style="max-width:30em;"><input id="InputFkAtbName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbAggregateFunction"><td style="padding-top:10px;">AggregateFunction</td></tr><tr><td colspan="2"><div><select id="InputAggregateFunction" type="text">
	<option value=" " selected> </option>
	<option value="SUM">Sum</option>
	<option value="AVG">Average</option>
	<option value="MIN">Minimum</option>
	<option value="MAX">Maximum</option>
</select></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefType0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (ConcernsParent)</legend>
<table style="width:100%;">
<tr><td>Type.Name</td><td style="width:100%;"><div style="max-width:30em;"><input id="InputXkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefType1"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (ConcernsChild)</legend>
<table style="width:100%;">
<tr><td>Type.Name</td><td style="width:100%;"><div style="max-width:30em;"><input id="InputXkTypName1" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateDer()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateDer()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteDer()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
