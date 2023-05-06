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
						document.getElementById("ButtonOK").innerText="Update";
						document.getElementById("ButtonOK").disabled=false;
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
									'Type',
									document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCode").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						document.getElementById("ButtonOK").innerText = "Update";
						document.getElementById("ButtonOK").onclick = function(){UpdateTyp()};						
						ResetChangePending();
						break;
					case "UPDATE_TYP":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCode").value.toLowerCase()+')';
						}
						ResetChangePending();
						break;
					case "DELETE_TYP":
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
						alert ('Unknown reply:\n'+g_responseText);
						
				}
			}
		} else {
			alert ('Request error:\n'+g_xmlhttp.statusText);
		}
	}
}

function CreateTyp() {
	if (document.getElementById("InputName").value == '') {
		alert ('Error: Primary key Name not filled');
		return;
	}
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
		document.getElementById("InputName").value = l_json_objectKey.TYP_TYP.Name;
		document.getElementById("ButtonOK").innerText = "Update";
		document.getElementById("ButtonOK").onclick = function(){UpdateTyp()};
		PerformTrans( {
			Service: "GetTyp",
			Parameters: {
				Type: l_json_objectKey.TYP_TYP
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputName").disabled = true;
		break;
	case "N": // New (non recursive) object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkBotName").value = l_json_objectKey.TYP_BOT.Name;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateTyp()};
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputCubeLevel").value='1';
		document.getElementById("InputFlagPartialKey").value='Y';
		document.getElementById("InputFlagRecursive").value='N';
		document.getElementById("InputRecursiveCardinality").value='N';
		document.getElementById("InputCardinality").value='N';
		document.getElementById("InputSortOrder").value='N';
		document.getElementById("InputTransferable").value='Y';
		break;  
	case "R": // New recursive object
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value = l_json_objectKey.TYP_TYP.Name;
		document.getElementById("ButtonOK").innerText = "Create";
		document.getElementById("ButtonOK").onclick = function(){CreateTyp()};
		PerformTrans( {
			Service: "GetTypFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_TYP
			}
		} );
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputCubeLevel").value='1';
		document.getElementById("InputFlagPartialKey").value='Y';
		document.getElementById("InputFlagRecursive").value='N';
		document.getElementById("InputRecursiveCardinality").value='N';
		document.getElementById("InputCardinality").value='N';
		document.getElementById("InputSortOrder").value='N';
		document.getElementById("InputTransferable").value='Y';
		break;
	case "X": // Delete object
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputName").value = l_json_objectKey.TYP_TYP.Name;
		document.getElementById("ButtonOK").innerText = "Delete";
		document.getElementById("ButtonOK").onclick = function(){DeleteTyp()};
		SetChangePending();
		PerformTrans( {
			Service: "GetTyp",
			Parameters: {
				Type: l_json_objectKey.TYP_TYP
			}
		} );
		document.getElementById("InputCubeId").disabled = true;
		document.getElementById("InputCubeSequence").disabled = true;
		document.getElementById("InputCubeLevel").disabled = true;
		document.getElementById("InputFkBotName").disabled = true;
		document.getElementById("InputFkTypName").disabled = true;
		document.getElementById("InputName").disabled = true;
		document.getElementById("InputCode").disabled = true;
		document.getElementById("InputFlagPartialKey").disabled = true;
		document.getElementById("InputFlagRecursive").disabled = true;
		document.getElementById("InputRecursiveCardinality").disabled = true;
		document.getElementById("InputCardinality").disabled = true;
		document.getElementById("InputSortOrder").disabled = true;
		document.getElementById("InputIcon").disabled = true;
		document.getElementById("InputTransferable").disabled = true;
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/type_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('type','Type','TYPE','_',-1)"> TYPE</span></div>
<hr/>
<table>
<tr id="RowAtbFkBotName"><td><div>BusinessObjectType.Name</div></td><td><div style="max-width:30em;"><input id="InputFkBotName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFkTypName"><td><div>Type.Name</div></td><td><div style="max-width:30em;"><input id="InputFkTypName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbName"><td><u><div>Name</div></u></td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbCode"><td><div>Code</div></td><td><div style="max-width:3em;"><input id="InputCode" type="text" maxlength="3" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbFlagPartialKey"><td><div>FlagPartialKey</div></td><td><div><select id="InputFlagPartialKey" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionFlagPartialKey-Y" style="display:inline" value="Y">Yes</option>
	<option id="OptionFlagPartialKey-N" style="display:inline" value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbFlagRecursive"><td><div>FlagRecursive</div></td><td><div><select id="InputFlagRecursive" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionFlagRecursive-Y" style="display:inline" value="Y">Yes</option>
	<option id="OptionFlagRecursive-N" style="display:inline" value="N">No</option>
</select></div></td></tr>
<tr id="RowAtbRecursiveCardinality"><td><div>RecursiveCardinality</div></td><td><div><select id="InputRecursiveCardinality" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionRecursiveCardinality-1" style="display:inline" value="1">1</option>
	<option id="OptionRecursiveCardinality-2" style="display:inline" value="2">2</option>
	<option id="OptionRecursiveCardinality-3" style="display:inline" value="3">3</option>
	<option id="OptionRecursiveCardinality-4" style="display:inline" value="4">4</option>
	<option id="OptionRecursiveCardinality-5" style="display:inline" value="5">5</option>
	<option id="OptionRecursiveCardinality-N" style="display:inline" value="N">Many</option>
</select></div></td></tr>
<tr id="RowAtbCardinality"><td><div>Cardinality</div></td><td><div><select id="InputCardinality" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionCardinality-1" style="display:inline" value="1">1</option>
	<option id="OptionCardinality-2" style="display:inline" value="2">2</option>
	<option id="OptionCardinality-3" style="display:inline" value="3">3</option>
	<option id="OptionCardinality-4" style="display:inline" value="4">4</option>
	<option id="OptionCardinality-5" style="display:inline" value="5">5</option>
	<option id="OptionCardinality-N" style="display:inline" value="N">Many</option>
</select></div></td></tr>
<tr id="RowAtbSortOrder"><td><div>SortOrder</div></td><td><div><select id="InputSortOrder" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionSortOrder-N" style="display:inline" value="N">No sort</option>
	<option id="OptionSortOrder-K" style="display:inline" value="K">Key</option>
	<option id="OptionSortOrder-P" style="display:inline" value="P">Position</option>
</select></div></td></tr>
<tr id="RowAtbIcon"><td><div>Icon</div></td><td><div style="max-width:8em;"><input id="InputIcon" type="text" maxlength="8" style="width:100%" onchange="SetChangePending();ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbTransferable"><td style="cursor:help" oncontextmenu="parent.OpenDescBox('type','Type.Transferable','TYPE','TRANSFERABLE',-1)"><div>Transferable</div></td><td><div><select id="InputTransferable" type="text" onchange="SetChangePending();">
	<option value=" " selected> </option>
	<option id="OptionTransferable-Y" style="display:inline" value="Y">Yes</option>
	<option id="OptionTransferable-N" style="display:inline" value="N">No</option>
</select></div></td></tr>
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
