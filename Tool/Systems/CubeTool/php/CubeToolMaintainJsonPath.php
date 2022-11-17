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
					case "SELECT_JSN":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputFkJsnName").value=l_json_values.FkJsnName;
						document.getElementById("InputFkJsnLocation").value=l_json_values.FkJsnLocation;
						document.getElementById("InputFkJsnAtbTypName").value=l_json_values.FkJsnAtbTypName;
						document.getElementById("InputFkJsnAtbName").value=l_json_values.FkJsnAtbName;
						document.getElementById("InputFkJsnTypName").value=l_json_values.FkJsnTypName;
						document.getElementById("InputCubeTsgObjArr").value=l_json_values.CubeTsgObjArr;
						document.getElementById("InputCubeTsgType").value=l_json_values.CubeTsgType;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_JSN":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkJsnName").disabled=true;
						document.getElementById("InputFkJsnLocation").disabled=true;
						document.getElementById("InputFkJsnAtbTypName").disabled=true;
						document.getElementById("InputFkJsnAtbName").disabled=true;
						document.getElementById("InputFkJsnTypName").disabled=true;
						document.getElementById("InputName").disabled=true;
						document.getElementById("InputLocation").disabled=true;
						document.getElementById("InputXfAtbTypName").disabled=true;
						document.getElementById("InputXkAtbName").disabled=true;
						document.getElementById("InputXkTypName").disabled=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("RefSelect002").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,Name:document.getElementById("InputName").value,Location:document.getElementById("InputLocation").value,XfAtbTypName:document.getElementById("InputXfAtbTypName").value,XkAtbName:document.getElementById("InputXkAtbName").value,XkTypName:document.getElementById("InputXkTypName").value};
						g_node_id = '{"TYP_JSN":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_JSN',
									l_json_node_id,
									'icons/braces.bmp',
									'JsonPath',
									'('+document.getElementById("InputCubeTsgObjArr").value.toLowerCase()+')'+' ('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')'+' '+document.getElementById("InputName").value.toLowerCase()+' '+document.getElementById("InputLocation").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateJsn()};						
						ResetChangePending();
						break;
					case "UPDATE_JSN":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+'('+document.getElementById("InputCubeTsgObjArr").value.toLowerCase()+')'+' ('+document.getElementById("InputCubeTsgType").value.toLowerCase()+')'+' '+document.getElementById("InputName").value.toLowerCase()+' '+document.getElementById("InputLocation").value.toLowerCase();
						}
						ResetChangePending();
						break;
					case "DELETE_JSN":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (g_parent_node_id == null) {
							g_parent_node_id = l_objNode.parentNode.parentNode.id;
						} 
						if (l_objNode != null) {
							l_objNode.parentNode.removeChild(l_objNode);
						}
						CancelChangePending();
						break;
					case "SELECT_FKEY_TYP":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						break;
					case "SELECT_FKEY_JSN":
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
									OpenListBox(l_json_array[i].Rows,'attrib','Attribute');
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

function CreateJsn() {
	if (document.getElementById("InputFkTypName").value == '') {
		alert ('Error: Primary key FkTypName not filled');
		return;
	}
	if (document.getElementById("InputName").value == '') {
		alert ('Error: Primary key Name not filled');
		return;
	}
	if (document.getElementById("InputLocation").value == '') {
		alert ('Error: Primary key Location not filled');
		return;
	}
	if (document.getElementById("InputXfAtbTypName").value == '') {
		alert ('Error: Primary key XfAtbTypName not filled');
		return;
	}
	if (document.getElementById("InputXkAtbName").value == '') {
		alert ('Error: Primary key XkAtbName not filled');
		return;
	}
	if (document.getElementById("InputXkTypName").value == '') {
		alert ('Error: Primary key XkTypName not filled');
		return;
	}
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkJsnName: document.getElementById("InputFkJsnName").value,
		FkJsnLocation: document.getElementById("InputFkJsnLocation").value,
		FkJsnAtbTypName: document.getElementById("InputFkJsnAtbTypName").value,
		FkJsnAtbName: document.getElementById("InputFkJsnAtbName").value,
		FkJsnTypName: document.getElementById("InputFkJsnTypName").value,
		CubeTsgObjArr: document.getElementById("InputCubeTsgObjArr").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Name: document.getElementById("InputName").value,
		Location: document.getElementById("InputLocation").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value,
		XkTypName: document.getElementById("InputXkTypName").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateJsn",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_JSN;
		PerformTrans( {
			Service: "CreateJsn",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateJsn() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkJsnName: document.getElementById("InputFkJsnName").value,
		FkJsnLocation: document.getElementById("InputFkJsnLocation").value,
		FkJsnAtbTypName: document.getElementById("InputFkJsnAtbTypName").value,
		FkJsnAtbName: document.getElementById("InputFkJsnAtbName").value,
		FkJsnTypName: document.getElementById("InputFkJsnTypName").value,
		CubeTsgObjArr: document.getElementById("InputCubeTsgObjArr").value,
		CubeTsgType: document.getElementById("InputCubeTsgType").value,
		Name: document.getElementById("InputName").value,
		Location: document.getElementById("InputLocation").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value,
		XkTypName: document.getElementById("InputXkTypName").value
	};
	PerformTrans( {
		Service: "UpdateJsn",
		Parameters: {
			Type
		}
	} );
}

function DeleteJsn() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		Location: document.getElementById("InputLocation").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value,
		XkTypName: document.getElementById("InputXkTypName").value
	};
	PerformTrans( {
		Service: "DeleteJsn",
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
			document.getElementById("InputXfAtbTypName").value = '';
		} else {
			document.getElementById("InputXfAtbTypName").value = l_json_values.FkTypName;
		}
		if (l_values == '') {
			document.getElementById("InputXkAtbName").value = '';
		} else {
			document.getElementById("InputXkAtbName").value = l_json_values.Name;
		}
		break;
	case "Ref002":
		if (l_values == '') {
			document.getElementById("InputXkTypName").value = '';
		} else {
			document.getElementById("InputXkTypName").value = l_json_values.Name;
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
	document.body._ListBoxOptional = 'N';
	var Parameters = {
		Option: {
			CubeScopeLevel:0
		},
		Ref: {
			FkTypName:document.getElementById("InputFkTypName").value
		}
	};
	PerformTrans( {
		Service: "GetAtbForTypList",
		Parameters
	} );
}

function StartSelect002(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref002';
	document.body._ListBoxOptional = 'N';
	var Parameters = {
		Option: {
			CubeScopeLevel:0
		},
		Ref: {
			FkTypName:document.getElementById("InputFkTypName").value
		}
	};
	PerformTrans( {
		Service: "GetTypForTypListAll",
		Parameters
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
	g_json_option = l_json_argument.Option;
	switch (l_json_argument.nodeType) {
	case "D": // Details of existing object 
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_JSN.FkTypName;
		document.getElementById("InputName").value = l_json_objectKey.TYP_JSN.Name;
		document.getElementById("InputLocation").value = l_json_objectKey.TYP_JSN.Location;
		document.getElementById("InputXfAtbTypName").value = l_json_objectKey.TYP_JSN.XfAtbTypName;
		document.getElementById("InputXkAtbName").value = l_json_objectKey.TYP_JSN.XkAtbName;
		document.getElementById("InputXkTypName").value = l_json_objectKey.TYP_JSN.XkTypName;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateJsn()};
		PerformTrans( {
			Service: "GetJsn",
			Parameters: {
				Type: l_json_objectKey.TYP_JSN
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkJsnName").disabled = true;
		document.getElementById("InputFkJsnLocation").disabled = true;
		document.getElementById("InputFkJsnAtbTypName").disabled = true;
		document.getElementById("InputFkJsnAtbName").disabled = true;
		document.getElementById("InputFkJsnTypName").disabled = true;
		document.getElementById("InputCubeTsgObjArr").disabled = true;
		document.getElementById("InputCubeTsgType").disabled = true;
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputLocation").disabled = true;
		document.getElementById("InputXfAtbTypName").disabled = true;
		document.getElementById("InputXkAtbName").disabled = true;
		document.getElementById("InputXkTypName").disabled = true;
		document.getElementById("RefSelect001").disabled = true;
		document.getElementById("RefSelect002").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_TYP.Name;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateJsn()};
		PerformTrans( {
			Service: "GetTypFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_TYP
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkJsnName").disabled = true;
		document.getElementById("InputFkJsnLocation").disabled = true;
		document.getElementById("InputFkJsnAtbTypName").disabled = true;
		document.getElementById("InputFkJsnAtbName").disabled = true;
		document.getElementById("InputFkJsnTypName").disabled = true;
		document.getElementById("InputCubeLevel").value='1';
		document.getElementById("InputLocation").value='0';
		break;  
	case "R": // New recursive object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_JSN.FkTypName;
		document.getElementById("InputFkJsnName").value = l_json_objectKey.TYP_JSN.Name;
		document.getElementById("InputFkJsnLocation").value = l_json_objectKey.TYP_JSN.Location;
		document.getElementById("InputFkJsnAtbTypName").value = l_json_objectKey.TYP_JSN.XfAtbTypName;
		document.getElementById("InputFkJsnAtbName").value = l_json_objectKey.TYP_JSN.XkAtbName;
		document.getElementById("InputFkJsnTypName").value = l_json_objectKey.TYP_JSN.XkTypName;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateJsn()};
		PerformTrans( {
			Service: "GetJsnFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_JSN
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkJsnName").disabled = true;
		document.getElementById("InputFkJsnLocation").disabled = true;
		document.getElementById("InputFkJsnAtbTypName").disabled = true;
		document.getElementById("InputFkJsnAtbName").disabled = true;
		document.getElementById("InputFkJsnTypName").disabled = true;
		document.getElementById("InputCubeLevel").value='1';
		document.getElementById("InputLocation").value='0';
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_JSN.FkTypName;
		document.getElementById("InputName").value = l_json_objectKey.TYP_JSN.Name;
		document.getElementById("InputLocation").value = l_json_objectKey.TYP_JSN.Location;
		document.getElementById("InputXfAtbTypName").value = l_json_objectKey.TYP_JSN.XfAtbTypName;
		document.getElementById("InputXkAtbName").value = l_json_objectKey.TYP_JSN.XkAtbName;
		document.getElementById("InputXkTypName").value = l_json_objectKey.TYP_JSN.XkTypName;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteJsn()};
		SetChangePending();
		PerformTrans( {
			Service: "GetJsn",
			Parameters: {
				Type: l_json_objectKey.TYP_JSN
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeSequence").disabled = true;
		document.getElementById("InputCubeLevel").disabled = true;
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputFkJsnName").disabled = true;
		document.getElementById("InputFkJsnLocation").disabled = true;
		document.getElementById("InputFkJsnAtbTypName").disabled = true;
		document.getElementById("InputFkJsnAtbName").disabled = true;
		document.getElementById("InputFkJsnTypName").disabled = true;
		document.getElementById("InputCubeTsgObjArr").disabled = true;
		document.getElementById("InputCubeTsgType").disabled = true;
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputLocation").disabled = true;
		document.getElementById("InputXfAtbTypName").disabled = true;
		document.getElementById("InputXkAtbName").disabled = true;
		document.getElementById("InputXkTypName").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgObjArr").value != ' ' && document.getElementById("InputCubeTsgType").value != ' ') {
		document.getElementById("InputCubeTsgObjArr").disabled = true;
		switch (document.getElementById("InputCubeTsgObjArr").value) {
		case "OBJ":
			document.getElementById("RowAtbLocation").style.display = "none";
			document.getElementById("InputLocation").value = "0";
			break;
		case "ARR":
			document.getElementById("RowAtbName").style.display = "none";
			document.getElementById("InputName").value = " ";
			break;
		}
		document.getElementById("InputCubeTsgType").disabled = true;
		switch (document.getElementById("InputCubeTsgType").value) {
		case "GRP":
			document.getElementById("InputXfAtbTypName").value = " ";
			document.getElementById("InputXkAtbName").value = " ";
			document.getElementById("InputXkTypName").value = " ";
			document.getElementById("RowRefAttribute0").style.display = "none";
			document.getElementById("RowRefType0").style.display = "none";
			break;
		case "ATRIBREF":
			document.getElementById("InputXkTypName").value = " ";
			document.getElementById("RowRefType0").style.display = "none";
			break;
		case "TYPEREF":
			document.getElementById("InputXfAtbTypName").value = " ";
			document.getElementById("InputXkAtbName").value = " ";
			document.getElementById("RowRefAttribute0").style.display = "none";
			break;
		}
		document.getElementById("TableMain").style.display = "inline";
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/braces_large.bmp" /><span> JSON_PATH /
<select id="InputCubeTsgObjArr" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;obj_arr&gt;</option>
	<option id="OptionCubeTsgObjArr-OBJ" style="display:inline" value="OBJ">OBJECT</option>
	<option id="OptionCubeTsgObjArr-ARR" style="display:inline" value="ARR">ARRAY</option>
</select> /
<select id="InputCubeTsgType" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;type&gt;</option>
	<option id="OptionCubeTsgType-GRP" style="display:inline" value="GRP">GROUP</option>
	<option id="OptionCubeTsgType-ATRIBREF" style="display:inline" value="ATRIBREF">ATTRIBUTE_REFERENCE</option>
	<option id="OptionCubeTsgType-TYPEREF" style="display:inline" value="TYPEREF">TYPE_REFERENCE</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr id="RowAtbFkBotName"><td><div>BusinessObjectType.Name</div></td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkJsnName"><td><div>JsonPath.Name</div></td><td><div style="max-width:32em;"><input id="InputFkJsnName" type="text" maxlength="32" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbFkJsnLocation"><td><div>JsonPath.Location</div></td><td><div style="max-width:9em;"><input id="InputFkJsnLocation" type="text" maxlength="9" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbFkJsnAtbTypName"><td><div>Type.Name</div></td><td><div style="max-width:30em;"><input id="InputFkJsnAtbTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkJsnAtbName"><td><div>Attribute.Name</div></td><td><div style="max-width:30em;"><input id="InputFkJsnAtbName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkJsnTypName"><td><div>Type.Name</div></td><td><div style="max-width:30em;"><input id="InputFkJsnTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbName"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('braces','JsonPath.Name','JSON_PATH','NAME',-1)"><u><div>Name</div></u></td><td><div style="max-width:32em;"><input id="InputName" type="text" maxlength="32" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbLocation"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('braces','JsonPath.Location','JSON_PATH','LOCATION',-1)"><u><div>Location</div></u></td><td><div style="max-width:9em;"><input id="InputLocation" type="text" maxlength="9" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefAttribute0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/attrib.bmp"/> Attribute (Concerns)</legend>
<table style="width:100%">
<tr><td><u>Type.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXfAtbTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td><u>Attribute.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkAtbName" type="text" maxlength="30" style="width:100%" disabled></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefType0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (Concerns)</legend>
<table style="width:100%">
<tr><td><u>Type.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
<input id="InputCubeLevel" type="hidden"></input>
</body>
</html>
