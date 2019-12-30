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
					case "SELECT_REF":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputName").value=l_json_values.Name;
						document.getElementById("InputPrimaryKey").value=l_json_values.PrimaryKey;
						document.getElementById("InputCodeDisplayKey").value=l_json_values.CodeDisplayKey;
						document.getElementById("InputScope").value=l_json_values.Scope;
						document.getElementById("InputUnchangeable").value=l_json_values.Unchangeable;
						document.getElementById("InputWithinScopeExtension").value=l_json_values.WithinScopeExtension;
						document.getElementById("InputXkTypName1").value=l_json_values.XkTypName1;
						break;
					case "CREATE_REF":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputSequence").disabled=true;
						document.getElementById("InputXkTypName").disabled=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,Sequence:document.getElementById("InputSequence").value,XkTypName:document.getElementById("InputXkTypName").value};
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
									document.getElementById("InputName").value.toLowerCase()+' '+document.getElementById("InputXkTypName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_REF":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputName").value.toLowerCase()+' '+document.getElementById("InputXkTypName").value.toLowerCase();
					}
						break;
					case "DELETE_REF":
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
						OpenListBox(l_json_array[i].Rows,'type','Type','N');
						break;
					case "LIST_TYP":
						OpenListBox(l_json_array[i].Rows,'type','Type','Y');
						break;
					case "SELECT_FKEY_TYP":
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
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_REF.FkTypName;
		document.getElementById("InputSequence").value=l_json_objectKey.TYP_REF.Sequence;
		document.getElementById("InputXkTypName").value=l_json_objectKey.TYP_REF.XkTypName;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetRef",
			Parameters: {
				Type: l_json_objectKey.TYP_REF
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputSequence").disabled=true;
		document.getElementById("InputXkTypName").disabled=true;
		document.getElementById("RefSelect001").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_TYP.Name;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		PerformTrans( {
			Service: "GetTypFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_TYP
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
	document.getElementById("InputScope").value='ALL';
	document.getElementById("InputUnchangeable").value='N';
}

function CreateRef() {
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
	var Parameters = {
		Type: {
			FkBotName:document.getElementById("InputFkBotName").value
		}
	};
	PerformTrans( {
		Service: "GetTypListEncapsulated",
		Parameters
	} );
}

function StartSelect002(p_event) {
	document.body._SelectLeft = p_event.clientX;
	document.body._SelectTop = p_event.clientY;
	document.body._ListBoxCode = 'Ref002';
	var Parameters = {
		Option: {
			CubeUpOrDown:"U",
			CubeXLevel:9999
		},
		Type: {
			Name:document.getElementById("InputFkTypName").value
		}
	};
	PerformTrans( {
		Service: "GetTypListRecursive",
		Parameters
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/ref_large.bmp" /><span> REFERENCE</span></div>
<hr/>
<table>
<tr><td>BusinessObjectType.Name</td><td><div style="max-width:30em;">
<input id="InputFkBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Type.Name</u></td><td><div style="max-width:30em;">
<input id="InputFkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Name</td><td><div style="max-width:30em;">
<input id="InputName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td style="cursor:help;" oncontextmenu="parent.OpenDescBox('REF','Reference.PrimaryKey','REFERENCE','PRIMARY_KEY',-1)">PrimaryKey</td><td><div>
<select id="InputPrimaryKey" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr><td>CodeDisplayKey</td><td><div>
<select id="InputCodeDisplayKey" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="S">Sub</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr><td><u>Sequence</u></td><td><div style="max-width:2em;">
<input id="InputSequence" type="text" maxlength="2" style="width:100%;"></input></div></td></tr>
<tr><td style="cursor:help;" oncontextmenu="parent.OpenDescBox('REF','Reference.Scope','REFERENCE','SCOPE',-1)">Scope</td><td><div>
<select id="InputScope" type="text">
	<option value=" " selected> </option>
	<option value="ALL">All</option>
	<option value="ENC">Encapsulated</option>
	<option value="PRA">Parents all</option>
	<option value="PR1">Parents first level</option>
	<option value="CHA">Children all</option>
	<option value="CH1">Children first level</option>
</select></div></td></tr>
<tr><td style="cursor:help;" oncontextmenu="parent.OpenDescBox('REF','Reference.Unchangeable','REFERENCE','UNCHANGEABLE',-1)">Unchangeable</td><td><div>
<select id="InputUnchangeable" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr><td>WithinScopeExtension</td><td><div>
<select id="InputWithinScopeExtension" type="text">
	<option value=" " selected> </option>
	<option value="PAR">Recursive parent</option>
	<option value="REF">Referenced type</option>
</select></div></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend style="cursor:help" oncontextmenu="parent.OpenDescBox('REF','Reference.Type (Refer)','REFERENCE','TYPE',0)"><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (Refer)</legend>
<table style="width:100%;">
<tr><td><u>Type.Name</u></td><td style="width:100%;"><div style="max-width:30em;">
<input id="InputXkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend style="cursor:help" oncontextmenu="parent.OpenDescBox('REF','Reference.Type (WithinScopeOf)','REFERENCE','TYPE',1)"><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (WithinScopeOf)</legend>
<table style="width:100%;">
<tr><td>Type.Name</td><td style="width:100%;"><div style="max-width:30em;">
<input id="InputXkTypName1" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateRef()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateRef()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteRef()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
