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
					case "SELECT_ATB":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputPrimaryKey").value=l_json_values.PrimaryKey;
						document.getElementById("InputCodeDisplayKey").value=l_json_values.CodeDisplayKey;
						document.getElementById("InputCodeForeignKey").value=l_json_values.CodeForeignKey;
						document.getElementById("InputFlagHidden").value=l_json_values.FlagHidden;
						document.getElementById("InputDefaultValue").value=l_json_values.DefaultValue;
						document.getElementById("InputUnchangeable").value=l_json_values.Unchangeable;
						document.getElementById("InputXkItpName").value=l_json_values.XkItpName;
						break;
					case "CREATE_ATB":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputName").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,Name:document.getElementById("InputName").value};
						g_node_id = '{"TYP_ATB":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_ATB',
									l_json_node_id,
									'icons/attrib.bmp', 
									document.getElementById("InputName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_ATB":
						break;
					case "DELETE_ATB":
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
					case "LIST_ITP":
						OpenListBox(l_json_array[i].Rows,'inftype','InformationType','Y');
						break;
					case "SELECT_FKEY_<<TYPE(N-1)1:U>>":
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
	g_json_option = l_json_argument.Option;
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_ATB.FkTypName;
		document.getElementById("InputName").value=l_json_objectKey.TYP_ATB.Name;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetAtb",
			Parameters: {
				Type: l_json_objectKey.TYP_ATB
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputName").disabled=true;
		document.getElementById("InputXkItpName").disabled=true;
		document.getElementById("RefSelect001").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_<<TYPE(N-1)1>>.Name;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		PerformTrans( {
			Service: "Get<<TYPE(N-1)1:C>>Fkey",
			Parameters: {
				Type: l_json_objectKey.TYP_<<TYPE(N-1)1>>
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
	document.getElementById("InputPrimaryKey").value='N';
	document.getElementById("InputCodeDisplayKey").value='N';
	document.getElementById("InputCodeForeignKey").value='N';
	document.getElementById("InputFlagHidden").value='N';
	document.getElementById("InputUnchangeable").value='N';
}

function CreateAtb() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		PrimaryKey: document.getElementById("InputPrimaryKey").value,
		CodeDisplayKey: document.getElementById("InputCodeDisplayKey").value,
		CodeForeignKey: document.getElementById("InputCodeForeignKey").value,
		FlagHidden: document.getElementById("InputFlagHidden").value,
		DefaultValue: document.getElementById("InputDefaultValue").value,
		Unchangeable: document.getElementById("InputUnchangeable").value,
		XkItpName: document.getElementById("InputXkItpName").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateAtb",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_ATB;
		PerformTrans( {
			Service: "CreateAtb",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateAtb() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		PrimaryKey: document.getElementById("InputPrimaryKey").value,
		CodeDisplayKey: document.getElementById("InputCodeDisplayKey").value,
		CodeForeignKey: document.getElementById("InputCodeForeignKey").value,
		FlagHidden: document.getElementById("InputFlagHidden").value,
		DefaultValue: document.getElementById("InputDefaultValue").value,
		Unchangeable: document.getElementById("InputUnchangeable").value,
		XkItpName: document.getElementById("InputXkItpName").value
	};
	PerformTrans( {
		Service: "UpdateAtb",
		Parameters: {
			Type
		}
	} );
}

function DeleteAtb() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value
	};
	PerformTrans( {
		Service: "DeleteAtb",
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
			document.getElementById("InputXkItpName").value = '';
		} else {
			document.getElementById("InputXkItpName").value = l_json_values.Name;
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
		Service: "GetItpList"
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/attrib_large.bmp" /><span> ATTRIBUTE</span></div>
<hr/>
<table>
<tr id="RowAtbFkBotName"><td>BusinessObjectType.Name</td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><u>Type.Name</u></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbName"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('ATTRIB','Attribute.Name','ATTRIBUTE','NAME',-1)"><u>Name</u></td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbPrimaryKey"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('ATTRIB','Attribute.PrimaryKey','ATTRIBUTE','PRIMARY_KEY',-1)">PrimaryKey</td><td><div><select id="InputPrimaryKey" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbCodeDisplayKey"><td>CodeDisplayKey</td><td><div><select id="InputCodeDisplayKey" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="S">Sub</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbCodeForeignKey"><td>CodeForeignKey</td><td><div><select id="InputCodeForeignKey" type="text">
	<option value=" " selected> </option>
	<option value="N">None</option>
</select></div></td></tr>
<tr id="RowAtbFlagHidden"><td>FlagHidden</td><td><div><select id="InputFlagHidden" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbDefaultValue"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('ATTRIB','Attribute.DefaultValue','ATTRIBUTE','DEFAULT_VALUE',-1)">DefaultValue</td><td><div style="max-width:40em;"><input id="InputDefaultValue" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr id="RowAtbUnchangeable"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('ATTRIB','Attribute.Unchangeable','ATTRIBUTE','UNCHANGEABLE',-1)">Unchangeable</td><td><div><select id="InputUnchangeable" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefInformationType0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/inftype.bmp"/> InformationType (HasDomain)</legend>
<table style="width:100%;">
<tr><td>InformationType.Name</td><td style="width:100%;"><div style="max-width:30em;"><input id="InputXkItpName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateAtb()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateAtb()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteAtb()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
