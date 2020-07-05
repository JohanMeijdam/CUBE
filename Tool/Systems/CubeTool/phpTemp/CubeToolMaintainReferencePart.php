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
					case "SELECT_RFP":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						document.getElementById("InputFkRfpTypName").value=l_json_values.FkRfpTypName;
						document.getElementById("InputFkRfpTypName1").value=l_json_values.FkRfpTypName1;
						break;
					case "CREATE_RFP":
						document.getElementById("InputFkBotName").disabled=true;
						document.getElementById("InputFkTypName").disabled=true;
						document.getElementById("InputFkRefSequence").disabled=true;
						document.getElementById("InputFkRefBotName").disabled=true;
						document.getElementById("InputFkRefTypName").disabled=true;
						document.getElementById("InputFkRfpTypName").disabled=true;
						document.getElementById("InputFkRfpTypName1").disabled=true;
						document.getElementById("InputXkTypName").disabled=true;
						document.getElementById("InputXkTypName1").disabled=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("RefSelect002").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkRefSequence:document.getElementById("InputFkRefSequence").value,FkRefBotName:document.getElementById("InputFkRefBotName").value,FkRefTypName:document.getElementById("InputFkRefTypName").value,XkTypName:document.getElementById("InputXkTypName").value,XkTypName1:document.getElementById("InputXkTypName1").value};
						g_node_id = '{"TYP_RFP":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_RFP',
									l_json_node_id,
									'icons/refpart.bmp', 
									document.getElementById("InputXkTypName").value.toLowerCase()+' '+document.getElementById("InputXkTypName1").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_RFP":
						break;
					case "DELETE_RFP":
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
						OpenListBox(l_json_array[i].Rows,'type','Type','N');
						break;
					case "SELECT_FKEY_<<TYPE(N-1)1:U>>":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						break;
					case "SELECT_FKEY_RFP":
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
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_RFP.FkTypName;
		document.getElementById("InputFkRefSequence").value=l_json_objectKey.TYP_RFP.FkRefSequence;
		document.getElementById("InputFkRefBotName").value=l_json_objectKey.TYP_RFP.FkRefBotName;
		document.getElementById("InputFkRefTypName").value=l_json_objectKey.TYP_RFP.FkRefTypName;
		document.getElementById("InputXkTypName").value=l_json_objectKey.TYP_RFP.XkTypName;
		document.getElementById("InputXkTypName1").value=l_json_objectKey.TYP_RFP.XkTypName1;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetRfp",
			Parameters: {
				Type: l_json_objectKey.TYP_RFP
			}
		} );
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkRefSequence").disabled=true;
		document.getElementById("InputFkRefBotName").disabled=true;
		document.getElementById("InputFkRefTypName").disabled=true;
		document.getElementById("InputFkRfpTypName").disabled=true;
		document.getElementById("InputFkRfpTypName1").disabled=true;
		document.getElementById("InputXkTypName").disabled=true;
		document.getElementById("InputXkTypName1").disabled=true;
		document.getElementById("RefSelect001").disabled=true;
		document.getElementById("RefSelect002").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_<<TYPE(N-1)1>>.FkTypName;
		document.getElementById("InputFkRefSequence").value=l_json_objectKey.TYP_<<TYPE(N-1)1>>.Sequence;
		document.getElementById("InputFkRefBotName").value=l_json_objectKey.TYP_<<TYPE(N-1)1>>.XkBotName;
		document.getElementById("InputFkRefTypName").value=l_json_objectKey.TYP_<<TYPE(N-1)1>>.XkTypName;
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
		document.getElementById("InputFkRefSequence").disabled=true;
		document.getElementById("InputFkRefBotName").disabled=true;
		document.getElementById("InputFkRefTypName").disabled=true;
		document.getElementById("InputFkRfpTypName").disabled=true;
		document.getElementById("InputFkRfpTypName1").disabled=true;
		break;  
	case "R":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_RFP.FkTypName;
		document.getElementById("InputFkRefSequence").value=l_json_objectKey.TYP_RFP.FkRefSequence;
		document.getElementById("InputFkRefBotName").value=l_json_objectKey.TYP_RFP.FkRefBotName;
		document.getElementById("InputFkRefTypName").value=l_json_objectKey.TYP_RFP.FkRefTypName;
		document.getElementById("InputFkRfpTypName").value=l_json_objectKey.TYP_RFP.XkTypName;
		document.getElementById("InputFkRfpTypName1").value=l_json_objectKey.TYP_RFP.XkTypName1;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		PerformTrans( {
			Service: "GetRfpFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_RFP
			}
		} );
		document.getElementById("InputFkBotName").disabled=true;
		document.getElementById("InputFkTypName").disabled=true;
		document.getElementById("InputFkRefSequence").disabled=true;
		document.getElementById("InputFkRefBotName").disabled=true;
		document.getElementById("InputFkRefTypName").disabled=true;
		document.getElementById("InputFkRfpTypName").disabled=true;
		document.getElementById("InputFkRfpTypName1").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
	document.getElementById("InputCubeLevel").value='1';
}

function CreateRfp() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value,
		FkRfpTypName: document.getElementById("InputFkRfpTypName").value,
		FkRfpTypName1: document.getElementById("InputFkRfpTypName1").value,
		XkTypName: document.getElementById("InputXkTypName").value,
		XkTypName1: document.getElementById("InputXkTypName1").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateRfp",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_RFP;
		PerformTrans( {
			Service: "CreateRfp",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateRfp() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value,
		FkRfpTypName: document.getElementById("InputFkRfpTypName").value,
		FkRfpTypName1: document.getElementById("InputFkRfpTypName1").value,
		XkTypName: document.getElementById("InputXkTypName").value,
		XkTypName1: document.getElementById("InputXkTypName1").value
	};
	PerformTrans( {
		Service: "UpdateRfp",
		Parameters: {
			Type
		}
	} );
}

function DeleteRfp() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkRefSequence: document.getElementById("InputFkRefSequence").value,
		FkRefBotName: document.getElementById("InputFkRefBotName").value,
		FkRefTypName: document.getElementById("InputFkRefTypName").value,
		XkTypName: document.getElementById("InputXkTypName").value,
		XkTypName1: document.getElementById("InputXkTypName1").value
	};
	PerformTrans( {
		Service: "DeleteRfp",
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
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/refpart_large.bmp" /><span> REFERENCE_PART</span></div>
<hr/>
<table>
<tr><td>BusinessObjectType.Name</td><td><div style="max-width:30em;">
<input id="InputFkBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Type.Name</u></td><td><div style="max-width:30em;">
<input id="InputFkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Reference.Sequence</u></td><td><div style="max-width:2em;">
<input id="InputFkRefSequence" type="text" maxlength="2" style="width:100%;"></input></div></td></tr>
<tr><td><u>Reference.Name</u></td><td><div style="max-width:30em;">
<input id="InputFkRefBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Reference.Name</u></td><td><div style="max-width:30em;">
<input id="InputFkRefTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Type.Name</td><td><div style="max-width:30em;">
<input id="InputFkRfpTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Type.Name</td><td><div style="max-width:30em;">
<input id="InputFkRfpTypName1" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>BusinessObjectType.Name</td><td><div>
<input id="InputFkBotName" type="text">
<tr><td>Type.Name</td><td><div>
<input id="InputFkTypName" type="text">
<tr><td>Reference.Sequence</td><td><div>
<input id="InputFkRefSequence" type="text">
<tr><td>Reference.Name</td><td><div>
<input id="InputFkRefBotName" type="text">
<tr><td>Reference.Name</td><td><div>
<input id="InputFkRefTypName" type="text">
<tr><td>Type.Name</td><td><div>
<input id="InputFkRfpTypName" type="text">
<tr><td>Type.Name</td><td><div>
<input id="InputFkRfpTypName1" type="text">
<tr><td height=6></td></tr><tr id="RowRefType0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (IsSource)</legend>
<table style="width:100%;">
<tr><td><u>Type.Name</u></td><td style="width:100%;"><div style="max-width:;">
<input id="InputXkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td height=6></td></tr><tr id="RowRefType1"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/type.bmp"/> Type (IsTarget)</legend>
<table style="width:100%;">
<tr><td><u>Type.Name</u></td><td style="width:100%;"><div style="max-width:;">
<input id="InputXkTypName1" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect002" type="button" onclick="StartSelect002(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateRfp()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateRfp()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteRfp()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
<input id="InputCubeLevel" type="hidden"></input>
</body>
</html>
