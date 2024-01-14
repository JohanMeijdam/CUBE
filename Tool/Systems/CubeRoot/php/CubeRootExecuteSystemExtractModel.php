<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeInclude.js?filever=<?=filemtime('../CubeGeneral/CubeInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="../CubeGeneral/CubeDetailInclude.js?filever=<?=filemtime('../CubeGeneral/CubeDetailInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeRootInclude.js?filever=<?=filemtime('CubeRootInclude.js')?>"></script>
<script language="javascript" type="text/javascript" src="CubeRootDetailInclude.js?filever=<?=filemtime('CubeRootDetailInclude.js')?>"></script>
<script language="javascript" type="text/javascript">
<!--
var g_option = null;
var g_json_option = null;
var g_parent_node_id = null;
var g_node_id = null;

g_xmlhttp.onreadystatechange = function() {
	switch (g_xmlhttp.readyState) {
		case 3:
			var g_code = g_xmlhttp.responseText;
			document.getElementById("ServiceOutput").innerText += "#3# " + g_code;
			break;
		case 4:
			var g_code = g_xmlhttp.responseText;
			document.getElementById("ServiceOutput").innerText += "#4# " + g_code;
			break;
	}
}

function InitBody() {
	var l_json_argument = JSON.parse(decodeURIComponent(location.href.split("?")[1]));
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	var l_json_objectKey = l_json_argument.objectId;
	switch (l_json_argument.nodeType) {
	case "E": // Execute Script
		g_node_id = JSON.stringify(l_json_argument.objectId);
		break;
	default:
		alert ('Error InitBody: nodeType='+l_json_argument.nodeType);
	}
}

function ExecuteService() {
	var l_message = 'test';
	g_xmlhttp.open('POST','CubeToolScriptExtractModel.php',true);
	g_xmlhttp.responseType = "text";
	g_xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	g_xmlhttp.send(l_message);
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/dot_large.bmp" /><span> SYSTEM - execute ExtractModel</span></div>
<hr/>
<table>
<tr id="RowAtbName"><td><u><div>Name</div></u></td><td><div style="max-width:30em;"><input id="InputName" type="text" maxlength="30" style="width:100%" onchange="SetChangePending();ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonExec" type="button" onclick="ExecuteService()">Execute</button></td></tr>
</table>
<hr/>
<span id="ServiceOutput" style="display:block;">script output:<br></span>
</body>
</html>
