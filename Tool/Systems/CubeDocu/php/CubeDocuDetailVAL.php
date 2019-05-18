<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language='javascript' type='text/javascript'>
<!--
var g_option = null;
var g_json_option = null;
var g_parent_node_id = null;
var g_node_id = null;

var g_xmlhttp = new XMLHttpRequest();
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
					case "SELECT_VAL":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputPrompt").value=l_json_values.Prompt;
						break;
					case "CREATE_VAL":
						document.getElementById("InputFkItpName").readOnly=true;
						document.getElementById("InputFkIteSequence").readOnly=true;
						document.getElementById("InputCode").readOnly=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkItpName:document.getElementById("InputFkItpName").value,FkIteSequence:document.getElementById("InputFkIteSequence").value,Code:document.getElementById("InputCode").value};
						g_node_id = '{"TYP_VAL":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_VAL',
									l_json_node_id,
									'icons/value.bmp', 
									document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputPrompt").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_VAL":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputPrompt").value.toLowerCase();
					}
						break;
					case "DELETE_VAL":
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

function performTrans(p_json_parm) {
	var l_requestText = JSON.stringify(p_json_parm);
	g_xmlhttp.open('POST','CubeDocuServer.php',true);
	g_xmlhttp.send(l_requestText);
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
		document.getElementById("InputFkItpName").value=l_json_objectKey.TYP_VAL.FkItpName;
		document.getElementById("InputFkIteSequence").value=l_json_objectKey.TYP_VAL.FkIteSequence;
		document.getElementById("InputCode").value=l_json_objectKey.TYP_VAL.Code;
		document.getElementById("ButtonCreate").disabled=true;
		performTrans( {
			Service: "GetVal",
			Parameters: {
				Type: l_json_objectKey.TYP_VAL
			}
		} );
		document.getElementById("InputFkItpName").readOnly=true;
		document.getElementById("InputFkIteSequence").readOnly=true;
		document.getElementById("InputCode").readOnly=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkItpName").value=l_json_objectKey.TYP_ITE.FkItpName;
		document.getElementById("InputFkIteSequence").value=l_json_objectKey.TYP_ITE.Sequence;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkItpName").readOnly=true;
		document.getElementById("InputFkIteSequence").readOnly=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateVal() {
	var Type = {
		FkItpName: document.getElementById("InputFkItpName").value,
		FkIteSequence: document.getElementById("InputFkIteSequence").value,
		Code: document.getElementById("InputCode").value,
		Prompt: document.getElementById("InputPrompt").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		performTrans( {
			Service: "CreateVal",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type;
		performTrans( {
			Service: "CreateVal",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateVal() {
	var Type = {
		FkItpName: document.getElementById("InputFkItpName").value,
		FkIteSequence: document.getElementById("InputFkIteSequence").value,
		Code: document.getElementById("InputCode").value,
		Prompt: document.getElementById("InputPrompt").value
	};
	performTrans( {
		Service: "UpdateVal",
		Parameters: {
			Type
		}
	} );
}

function DeleteVal() {
	var Type = {
		FkItpName: document.getElementById("InputFkItpName").value,
		FkIteSequence: document.getElementById("InputFkIteSequence").value,
		Code: document.getElementById("InputCode").value
	};
	performTrans( {
		Service: "DeleteVal",
		Parameters: {
			Type
		}
	} );
}


function ToUpperCase(p_obj) 
{
	p_obj.value = p_obj.value.toUpperCase();

}

function ReplaceSpaces(p_obj) 
{
	p_obj.value = p_obj.value.replace(/^\s+|\s+$/g, "").replace(/ /g ,"_");
}

function StartMove(p_event) {
	var l_obj = p_event.target;
	l_obj._x = p_event.screenX - parseInt(l_obj.style.left);
	l_obj._y = p_event.screenY - parseInt(l_obj.style.top);
	document.body._FlagDragging = 1;
	document.body._DraggingId = l_obj.id;
}

function EndMove(p_event) {
 	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
}

function allowDrop(p_event) {
	if (document.body._FlagDragging) {
		p_event.preventDefault();
	}
}

function drop(p_event) {
	if (document.body._FlagDragging) {
		var l_obj = document.getElementById(document.body._DraggingId);
		var l_x = p_event.screenX - l_obj._x;
		var l_y = p_event.screenY - l_obj._y;	
		l_obj.style.left = l_x + 'px';
		l_obj.style.top = l_y + 'px';
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/value_large.bmp" /><span> PERMITTED_VALUE</span></div>
<hr/>
<table>
<tr><td><u>InformationType.Name</u></td><td><div style="max-width:30em;">
<input id="InputFkItpName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>InformationTypeElement.Sequence</u></td><td><div style="max-width:9em;">
<input id="InputFkIteSequence" type="text" maxlength="9" style="width:100%;"></input></div></td></tr>
<tr><td><u>Code</u></td><td><div style="max-width:16em;">
<input id="InputCode" type="text" maxlength="16" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Prompt</td><td><div style="max-width:32em;">
<input id="InputPrompt" type="text" maxlength="32" style="width:100%;"></input></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateVal()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateVal()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteVal()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
