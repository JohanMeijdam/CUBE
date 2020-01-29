<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeInclude.js"></script>
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeDetailInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeTestInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeTestDetailInclude.js"></script>
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
					case "SELECT_BBB":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkAaaId").value=l_json_values.FkAaaId;
						document.getElementById("InputNaam").value=l_json_values.Naam;
						break;
					case "CREATE_BBB":
						document.getElementById("InputFkAaaId").disabled=true;
						document.getElementById("InputId").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Id:document.getElementById("InputId").value};
						g_node_id = '{"TYP_BBB":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_BBB',
									l_json_node_id,
									'icons/.bmp', 
									document.getElementById("InputId").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_BBB":
						break;
					case "DELETE_BBB":
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
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputId").value=l_json_objectKey.TYP_BBB.Id;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetBbb",
			Parameters: {
				Type: l_json_objectKey.TYP_BBB
			}
		} );
		document.getElementById("InputFkAaaId").disabled=true;
		document.getElementById("InputId").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkAaaId").value=l_json_objectKey.TYP_AAA.Id;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkAaaId").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateBbb() {
	var Type = {
		FkAaaId: document.getElementById("InputFkAaaId").value,
		Id: document.getElementById("InputId").value,
		Naam: document.getElementById("InputNaam").value
	};
	PerformTrans( {
		Service: "CreateBbb",
		Parameters: {
			Type
		}
	} );
}

function UpdateBbb() {
	var Type = {
		FkAaaId: document.getElementById("InputFkAaaId").value,
		Id: document.getElementById("InputId").value,
		Naam: document.getElementById("InputNaam").value
	};
	PerformTrans( {
		Service: "UpdateBbb",
		Parameters: {
			Type
		}
	} );
}

function DeleteBbb() {
	var Type = {
		Id: document.getElementById("InputId").value
	};
	PerformTrans( {
		Service: "DeleteBbb",
		Parameters: {
			Type
		}
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/_large.bmp" /><span> BBB</span></div>
<hr/>
<table>
<tr><td>Aaa.Id</td><td><div style="max-width:9em;">
<input id="InputFkAaaId" type="text" maxlength="9" style="width:100%;"></input></div></td></tr>
<tr><td><u>Id</u></td><td><div style="max-width:9em;">
<input id="InputId" type="text" maxlength="9" style="width:100%;"></input></div></td></tr>
<tr><td>Naam</td><td><div style="max-width:40em;">
<input id="InputNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateBbb()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateBbb()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteBbb()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
