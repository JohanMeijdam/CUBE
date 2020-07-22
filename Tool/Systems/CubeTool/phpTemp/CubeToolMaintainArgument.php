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
					case "SELECT_ARG":
						var l_json_values = l_json_array[i].Rows[0].Data;
						break;
					case "CREATE_ARG":
						document.getElementById("InputFkFunName").disabled=true;
						document.getElementById("InputName").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkFunName:document.getElementById("InputFkFunName").value,Name:document.getElementById("InputName").value};
						g_node_id = '{"TYP_ARG":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = g_json_option.Code;
								l_objNodePos = parent.document.getElementById(JSON.stringify(g_json_option.Type));
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_ARG',
									l_json_node_id,
									'icons/funcatb.bmp', 
									document.getElementById("InputName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_ARG":
						break;
					case "DELETE_ARG":
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
		document.getElementById("InputFkFunName").value=l_json_objectKey.TYP_ARG.FkFunName;
		document.getElementById("InputName").value=l_json_objectKey.TYP_ARG.Name;
		document.getElementById("ButtonCreate").disabled=true;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("InputFkFunName").disabled=true;
		document.getElementById("InputName").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkFunName").value=l_json_objectKey.TYP_<<TYPE(N-1)1>>.Name;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkFunName").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateArg() {
	var Type = {
		FkFunName: document.getElementById("InputFkFunName").value,
		Name: document.getElementById("InputName").value
	};
	var l_pos_action = g_json_option.Code;
	var Option = {
		CubePosAction: l_pos_action
	};
	if (l_pos_action == 'F' || l_pos_action == 'L') {
		PerformTrans( {
			Service: "CreateArg",
			Parameters: {
				Option,
				Type
			}
		} );
	} else {
		var Ref = g_json_option.Type.TYP_ARG;
		PerformTrans( {
			Service: "CreateArg",
				Parameters: {
					Option,
					Type,
					Ref
				}
			} );
	}
}

function UpdateArg() {
	var Type = {
		FkFunName: document.getElementById("InputFkFunName").value,
		Name: document.getElementById("InputName").value
	};
	PerformTrans( {
		Service: "UpdateArg",
		Parameters: {
			Type
		}
	} );
}

function DeleteArg() {
	var Type = {
		FkFunName: document.getElementById("InputFkFunName").value,
		Name: document.getElementById("InputName").value
	};
	PerformTrans( {
		Service: "DeleteArg",
		Parameters: {
			Type
		}
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/funcatb_large.bmp" /><span> ARGUMENT</span></div>
<hr/>
<table>
<tr><td><u>Function.Name</u></td><td><div style="max-width:30em;"><input id="InputFkFunName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Name</u></td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateArg()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateArg()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteArg()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
