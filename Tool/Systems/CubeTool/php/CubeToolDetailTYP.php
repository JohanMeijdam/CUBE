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
					case "SELECT_TYP":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputFkTypName").value=l_json_values.FkTypName;
						document.getElementById("InputCode").value=l_json_values.Code;
						document.getElementById("InputFlagPartialKey").value=l_json_values.FlagPartialKey;
						document.getElementById("InputFlagRecursive").value=l_json_values.FlagRecursive;
						document.getElementById("InputRecursiveCardinality").value=l_json_values.RecursiveCardinality;
						document.getElementById("InputCardinality").value=l_json_values.Cardinality;
						document.getElementById("InputSortOrder").value=l_json_values.SortOrder;
						document.getElementById("InputIcon").value=l_json_values.Icon;
						document.getElementById("InputTransferable").value=l_json_values.Transferable;
						break;
					case "CREATE_TYP":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputName").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Name:document.getElementById("InputName").value};
						g_node_id = '{"TYP_TYP":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_TYP',
									l_json_node_id,
									'icons/type.bmp', 
									document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCode").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_TYP":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCode").value.toLowerCase()+')';
					}
						break;
					case "DELETE_TYP":
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
		document.getElementById("InputName").value=l_json_objectKey.TYP_TYP.Name;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetTyp",
			Parameters: {
				Type: l_json_objectKey.TYP_TYP
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputName").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkBotName").value=l_json_objectKey.TYP_BOT.Name;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		break;  
	case "R":
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
	document.getElementById("InputCubeLevel").value='1';
	document.getElementById("InputFlagPartialKey").value='Y';
	document.getElementById("InputFlagRecursive").value='N';
	document.getElementById("InputRecursiveCardinality").value='N';
	document.getElementById("InputCardinality").value='N';
	document.getElementById("InputSortOrder").value='N';
	document.getElementById("InputTransferable").value='Y';
}

function CreateTyp() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		Code: document.getElementById("InputCode").value,
		FlagPartialKey: document.getElementById("InputFlagPartialKey").value,
		FlagRecursive: document.getElementById("InputFlagRecursive").value,
		RecursiveCardinality: document.getElementById("InputRecursiveCardinality").value,
		Cardinality: document.getElementById("InputCardinality").value,
		SortOrder: document.getElementById("InputSortOrder").value,
		Icon: document.getElementById("InputIcon").value,
		Transferable: document.getElementById("InputTransferable").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateTyp",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_TYP;
		PerformTrans( {
			Service: "CreateTyp",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateTyp() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		Name: document.getElementById("InputName").value,
		Code: document.getElementById("InputCode").value,
		FlagPartialKey: document.getElementById("InputFlagPartialKey").value,
		FlagRecursive: document.getElementById("InputFlagRecursive").value,
		RecursiveCardinality: document.getElementById("InputRecursiveCardinality").value,
		Cardinality: document.getElementById("InputCardinality").value,
		SortOrder: document.getElementById("InputSortOrder").value,
		Icon: document.getElementById("InputIcon").value,
		Transferable: document.getElementById("InputTransferable").value
	};
	PerformTrans( {
		Service: "UpdateTyp",
		Parameters: {
			Type
		}
	} );
}

function DeleteTyp() {
	var Type = {
		Name: document.getElementById("InputName").value
	};
	PerformTrans( {
		Service: "DeleteTyp",
		Parameters: {
			Type
		}
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/type_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('TYPE','Type','TYPE','_',-1)"> TYPE</span></div>
<hr/>
<table>
<tr><td>BusinessObjectType.Name</td><td><div style="max-width:30em;">
<input id="InputFkBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Type.Name</td><td><div style="max-width:30em;">
<input id="InputFkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Name</u></td><td><div style="max-width:30em;">
<input id="InputName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Code</td><td><div style="max-width:3em;">
<input id="InputCode" type="text" maxlength="3" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>FlagPartialKey</td><td><div>
<select id="InputFlagPartialKey" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr><td>FlagRecursive</td><td><div>
<select id="InputFlagRecursive" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr><td>RecursiveCardinality</td><td><div>
<select id="InputRecursiveCardinality" type="text">
	<option value=" " selected> </option>
	<option value="1">1</option>
	<option value="2">2</option>
	<option value="3">3</option>
	<option value="4">4</option>
	<option value="5">5</option>
	<option value="N">Many</option>
</select></div></td></tr>
<tr><td>Cardinality</td><td><div>
<select id="InputCardinality" type="text">
	<option value=" " selected> </option>
	<option value="1">1</option>
	<option value="2">2</option>
	<option value="3">3</option>
	<option value="4">4</option>
	<option value="5">5</option>
	<option value="N">Many</option>
</select></div></td></tr>
<tr><td>SortOrder</td><td><div>
<select id="InputSortOrder" type="text">
	<option value=" " selected> </option>
	<option value="N">No sort</option>
	<option value="K">Key</option>
	<option value="P">Position</option>
</select></div></td></tr>
<tr><td>Icon</td><td><div style="max-width:8em;">
<input id="InputIcon" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td style="cursor:help;" oncontextmenu="parent.OpenDescBox('TYPE','Type.Transferable','TYPE','TRANSFERABLE',-1)">Transferable</td><td><div>
<select id="InputTransferable" type="text">
	<option value=" " selected> </option>
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateTyp()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateTyp()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteTyp()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
<input id="InputCubeLevel" type="hidden"></input>
</body>
</html>
