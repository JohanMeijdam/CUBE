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
					case "SELECT_REF":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputName").value=l_json_values.Name;
						document.getElementById("InputPrimaryKey").value=l_json_values.PrimaryKey;
						document.getElementById("InputCodeDisplayKey").value=l_json_values.CodeDisplayKey;
						document.getElementById("InputScope").value=l_json_values.Scope;
						document.getElementById("InputUnchangeable").value=l_json_values.Unchangeable;
						document.getElementById("InputWithinScopeExtension").value=l_json_values.WithinScopeExtension;
						document.getElementById("InputCubeTsgIntExt").value=l_json_values.CubeTsgIntExt;
						document.getElementById("InputXkTypName1").value=l_json_values.XkTypName1;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_REF":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputSequence").disabled=true;
						document.getElementById("InputXkBotName").disabled=true;
						document.getElementById("InputXkTypName").disabled=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("RefSelect002").disabled=true;
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,Sequence:document.getElementById("InputSequence").value,XkBotName:document.getElementById("InputXkBotName").value,XkTypName:document.getElementById("InputXkTypName").value};
						g_node_id = '{"TYP_REF":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_REF',
									l_json_node_id,
									'icons/ref.bmp',
									'Reference',
									document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCubeTsgIntExt").value.toLowerCase()+')'+' '+document.getElementById("InputXkBotName").value.toLowerCase()+' '+document.getElementById("InputXkTypName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateRef()};						
						ResetChangePending();
						break;
					case "UPDATE_REF":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCubeTsgIntExt").value.toLowerCase()+')'+' '+document.getElementById("InputXkBotName").value.toLowerCase()+' '+document.getElementById("InputXkTypName").value.toLowerCase();
						}
						ResetChangePending();
						break;
					case "DELETE_REF":
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
					case "ERROR":
						alert ('Server error:\n'+l_json_array[i].ErrorText);
						break;
					default:
						if (l_json_array[i].ResultName.substring(0,5) == 'LIST_') {
							switch (document.body._ListBoxCode){
								case "Ref001":
									OpenListBox(l_json_array[i].Rows,'botype','BusinessObjectType');
									break;
								case "Ref002":
									OpenListBox(l_json_array[i].Rows,'type','Type');
									break;
								case "Ref003":
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

function CreateRef() {
	if (document.getElementById("InputFkTypName").value == '') {
		alert ('Error: Primary key FkTypName not filled');
		return;
	}
	if (document.getElementById("InputSequence").value == '') {
		alert ('Error: Primary key Sequence not filled');
		return;
	}
	if (document.getElementById("InputXkBotName").value == '') {
		alert ('Error: Primary key XkBotName not filled');
		return;
	}
	if (document.getElementById("InputXkTypName").value == '') {
		alert ('Error: Primary key XkTypName not filled');
		return;
	}
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		PrimaryKey: document.getElementById("InputPrimaryKey").value,
		CodeDisplayKey: document.getElementById("InputCodeDisplayKey").value,
		Sequence: document.getElementById("InputSequence").value,
		Scope: document.getElementById("InputScope").value,
		Unchangeable: document.getElementById("InputUnchangeable").value,
		WithinScopeExtension: document.getElementById("InputWithinScopeExtension").value,
		CubeTsgIntExt: document.getElementById("InputCubeTsgIntExt").value,
		XkBotName: document.getElementById("InputXkBotName").value,
		XkTypName: document.getElementById("InputXkTypName").value,
		XkTypName1: document.getElementById("InputXkTypName1").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateRef",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_REF;
		PerformTrans( {
			Service: "CreateRef",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateRef() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		PrimaryKey: document.getElementById("InputPrimaryKey").value,
		CodeDisplayKey: document.getElementById("InputCodeDisplayKey").value,
		Sequence: document.getElementById("InputSequence").value,
		Scope: document.getElementById("InputScope").value,
		Unchangeable: document.getElementById("InputUnchangeable").value,
		WithinScopeExtension: document.getElementById("InputWithinScopeExtension").value,
		CubeTsgIntExt: document.getElementById("InputCubeTsgIntExt").value,
		XkBotName: document.getElementById("InputXkBotName").value,
		XkTypName: document.getElementById("InputXkTypName").value,
		XkTypName1: document.getElementById("InputXkTypName1").value
	};
	PerformTrans( {
		Service: "UpdateRef",
		Parameters: {
			Type
		}
	} );
}

function DeleteRef() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		Sequence: document.getElementById("InputSequence").value,
		XkBotName: document.getElementById("InputXkBotName").value,
		XkTypName: document.getElementById("InputXkTypName").value
	};
	PerformTrans( {
		Service: "DeleteRef",
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
			document.getElementById("InputXkBotName").value = '';
		} else {
			document.getElementById("InputXkBotName").value = l_json_values.Name;
		}
		break;
	case "Ref002":
		if (l_values == '') {
			document.getElementById("InputXkTypName").value = '';
		} else {
			document.getElementById("InputXkTypName").value = l_json_values.Name;
		}
		break;
	case "Ref003":
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
	document.body._ListBoxOptional = 'N';
	PerformTrans( {
		Service: "GetBotList"
	} );
}

function StartSelect002(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref002';
	document.body._ListBoxOptional = 'N';
	var Parameters = {
		Ref: {
			FkBotName:document.getElementById("InputFkBotName").value
		}
	};
	PerformTrans( {
		Service: "GetTypForBotListAll",
		Parameters
	} );
}

function StartSelect003(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref003';
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
	g_json_option = l_json_argument.Option;
	switch (l_json_argument.nodeType) {
	case "D": // Details of existing object 
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_REF.FkTypName;
		document.getElementById("InputSequence").value = l_json_objectKey.TYP_REF.Sequence;
		document.getElementById("InputXkBotName").value = l_json_objectKey.TYP_REF.XkBotName;
		document.getElementById("InputXkTypName").value = l_json_objectKey.TYP_REF.XkTypName;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateRef()};
		PerformTrans( {
			Service: "GetRef",
			Parameters: {
				Type: l_json_objectKey.TYP_REF
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputSequence").disabled = true;
		document.getElementById("InputCubeTsgIntExt").disabled = true;
		document.getElementById("InputXkBotName").disabled = true;
		document.getElementById("InputXkTypName").disabled = true;
		document.getElementById("RefSelect001").disabled = true;
		document.getElementById("RefSelect002").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_TYP.Name;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateRef()};
		PerformTrans( {
			Service: "GetTypFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_TYP
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputPrimaryKey").value='N';
		document.getElementById("InputCodeDisplayKey").value='N';
		document.getElementById("InputSequence").value='0';
		document.getElementById("InputScope").value='ALL';
		document.getElementById("InputUnchangeable").value='N';
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_REF.FkTypName;
		document.getElementById("InputSequence").value = l_json_objectKey.TYP_REF.Sequence;
		document.getElementById("InputXkBotName").value = l_json_objectKey.TYP_REF.XkBotName;
		document.getElementById("InputXkTypName").value = l_json_objectKey.TYP_REF.XkTypName;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteRef()};
		SetChangePending();
		PerformTrans( {
			Service: "GetRef",
			Parameters: {
				Type: l_json_objectKey.TYP_REF
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeSequence").disabled = true;
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputPrimaryKey").disabled = true;
		document.getElementById("InputCodeDisplayKey").disabled = true;
		document.getElementById("InputSequence").disabled = true;
		document.getElementById("InputScope").disabled = true;
		document.getElementById("InputUnchangeable").disabled = true;
		document.getElementById("InputWithinScopeExtension").disabled = true;
		document.getElementById("InputCubeTsgIntExt").disabled = true;
		document.getElementById("InputXkBotName").disabled = true;
		document.getElementById("InputXkTypName").disabled = true;
		document.getElementById("InputXkTypName1").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgIntExt").value != ' ') {
		document.getElementById("InputCubeTsgIntExt").disabled = true;
		switch (document.getElementById("InputCubeTsgIntExt").value) {
		case "INT":
			document.getElementById("InputXkBotName").value = " ";
			document.getElementById("RowRefBusinessObjectType0").style.display = "none";
			break;
		case "EXT":
			document.getElementById("RowAtbScope").style.display = "none";
			document.getElementById("RowAtbWithinScopeExtension").style.display = "none";
			document.getElementById("InputXkTypName").value = " ";
			document.getElementById("RowRefType0").style.display = "none";
			document.getElementById("RowRefType1").style.display = "none";
			break;
		}
		document.getElementById("TableMain").style.display = "inline";
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/ref_large.bmp" /><span> REFERENCE /
<select id="InputCubeTsgIntExt" type="text" onchange="ProcessTypeSpecialisation();">
	<option value=" " selected>&lt;int_ext&gt;</option>
	<option id="OptionCubeTsgIntExt-INT" style="display:inline" value="INT">INTERNAL</option>
	<option id="OptionCubeTsgIntExt-EXT" style="display:inline" value="EXT">EXTERNAL</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr id="RowAtbFkBotName"><td><div>BusinessObjectType.Name</div></td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u><div>Type.Name</div></u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbName"><td><div>Name</div></td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbPrimaryKey"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('ref','Reference.PrimaryKey','REFERENCE','PRIMARY_KEY',-1)"><div>PrimaryKey</div></td><td><div><select id="InputPrimaryKey" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionPrimaryKey-Y" style="display:inline" value="Y">Yes</option>
	<option id="OptionPrimaryKey-N" style="display:inline" value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbCodeDisplayKey"><td><div>CodeDisplayKey</div></td><td><div><select id="InputCodeDisplayKey" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionCodeDisplayKey-Y" style="display:inline" value="Y">Yes</option>
	<option id="OptionCodeDisplayKey-S" style="display:inline" value="S">Sub</option>
	<option id="OptionCodeDisplayKey-N" style="display:inline" value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbSequence"><td><u><div>Sequence</div></u></td><td><div style="max-width:2em;"><input id="InputSequence" type="text" maxlength="2" style="width:100%" onchange="SetChangePending();"></input></div></td></tr>
<tr id="RowAtbScope"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('ref','Reference.Scope','REFERENCE','SCOPE',-1)"><div>Scope</div></td><td><div><select id="InputScope" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionScope-ALL" style="display:inline" value="ALL">All</option>
	<option id="OptionScope-PRA" style="display:inline" value="PRA">Parents all</option>
	<option id="OptionScope-PR1" style="display:inline" value="PR1">Parents first level</option>
	<option id="OptionScope-CHA" style="display:inline" value="CHA">Children all</option>
	<option id="OptionScope-CH1" style="display:inline" value="CH1">Children first level</option>
</select></div></td></tr>
<tr id="RowAtbUnchangeable"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('ref','Reference.Unchangeable','REFERENCE','UNCHANGEABLE',-1)"><div>Unchangeable</div></td><td><div><select id="InputUnchangeable" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionUnchangeable-Y" style="display:inline" value="Y">Yes</option>
	<option id="OptionUnchangeable-N" style="display:inline" value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbWithinScopeExtension"><td><div>WithinScopeExtension</div></td><td><div><select id="InputWithinScopeExtension" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionWithinScopeExtension-PAR" style="display:inline" value="PAR">Recursive parent</option>
	<option id="OptionWithinScopeExtension-REF" style="display:inline" value="REF">Referenced type</option>
</select></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefBusinessObjectType0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/botype.bmp"/> BusinessObjectType (Refer)</legend>
<table style="width:100%">
<tr><td><u>BusinessObjectType.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkBotName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefType0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (Refer)</legend>
<table style="width:100%">
<tr><td><u>Type.Name</u></td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkTypName" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefType1"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (WithinScopeOf)</legend>
<table style="width:100%">
<tr><td>Type.Name</td><td style="width:100%"><div style="max-width:30em;"><input id="InputXkTypName1" type="text" maxlength="30" style="width:100%" disabled></input></div></td>
<td><button id="RefSelect003" type="button" onclick="StartSelect003(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonOK" type="button" disabled>OK</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelChangePending()">Cancel</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
