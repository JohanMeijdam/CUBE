<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language='javascript' type='text/javascript'>
<!--
var g_option;
g_xmlhttp = new XMLHttpRequest();
g_xmlhttp.onreadystatechange = function() {
	if(g_xmlhttp.readyState == 4) {
		var l_argument = g_xmlhttp.responseText.split("<|||>");
		switch (l_argument[0]) {
		case "SELECT_TYP":
			var l_values = l_argument[1].split("<|>");
			document.getElementById("InputFkBotName").value=l_values[0];
			document.getElementById("InputFkTypName").value=l_values[1];
			document.getElementById("InputCode").value=l_values[2];
			document.getElementById("InputFlagPartialKey").value=l_values[3];
			document.getElementById("InputFlagRecursive").value=l_values[4];
			document.getElementById("InputRecursiveCardinality").value=l_values[5];
			document.getElementById("InputCardinality").value=l_values[6];
			document.getElementById("InputSortOrder").value=l_values[7];
			document.getElementById("InputIcon").value=l_values[8];
			document.getElementById("InputTransferable").value=l_values[9];
			break;
		case "CREATE_TYP":
			document.getElementById("InputFkBotName").readOnly=true;
			document.getElementById("InputFkTypName").readOnly=true;
			document.getElementById("InputName").readOnly=true;
			document.getElementById("ButtonCreate").disabled=true;
			document.getElementById("ButtonUpdate").disabled=false;
			document.getElementById("ButtonDelete").disabled=false;
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			document._nodeId = 'TYP_TYP<||>'+document.getElementById("InputName").value;
			if (l_objNode != null) {
				if (l_objNode.firstChild._state == 'O') {
					var l_position = g_option[0];
					l_objNodePos = parent.TREE.document.getElementById('TYP_TYP<||>'+g_option[1]);
					parent.TREE.AddTreeviewNode(
						l_objNode,
						'TYP_TYP',
						document._nodeId,
						'icons/type.bmp', 
						document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCode").value.toLowerCase()+')',
						'N',
						l_position,
						l_objNodePos);
				}
			}
			break;
		case "UPDATE_TYP":
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			if (l_objNode != null) {
				l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputName").value.toLowerCase()+' ('+document.getElementById("InputCode").value.toLowerCase()+')';
			}
			break;
		case "DELETE_TYP":
			document.getElementById("ButtonUpdate").disabled=true;
			document.getElementById("ButtonDelete").disabled=true;
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			if (l_objNode != null) {
				l_objNode = l_objNode;
				l_objNode.parentNode.removeChild(l_objNode);
			}
			break;
		case "SELECT_FKEY_TYP":
			var l_values = l_argument[1].split("<|>");
			document.getElementById("InputFkBotName").value=l_values[0];
			break;
		case "ERROR":
			alert ('Error: '+l_argument[1]);
			break;
		case "SELECT_CUBE_DSC":
			document.getElementById("CubeDesc").value = l_argument[1];
			break;
		default:
			alert (g_xmlhttp.responseText);	
		}			
	}
}

function performTrans(p_message) {
	g_xmlhttp.open('POST','CubeDocuServer.php',true);
	g_xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	g_xmlhttp.send(p_message);
}

function InitBody() {
	var l_argument = decodeURIComponent(document.location.href).split("<|||>");
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	document.body._ListBoxCode="Ref000";
	document._nodeId = l_argument[2];
	document._argument = document._nodeId.split("<||>")[1];
	g_option = l_argument[3].split("<||>");
	if (document._argument != null) {
		var values = document._argument.split("<|>");
	}
	switch (l_argument[1]) {
	case "D":
		document.getElementById("InputName").value=values[0];
		document.getElementById("ButtonCreate").disabled=true;
		performTrans('GetTyp'+'<|||>'+document._argument);
		document.getElementById("InputFkBotName").readOnly=true;
		document.getElementById("InputFkTypName").readOnly=true;
		document.getElementById("InputName").readOnly=true;
		break;
	case "N":
		document.getElementById("InputFkBotName").value=values[0];
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkBotName").readOnly=true;
		document.getElementById("InputFkTypName").readOnly=true;
		break;  
	case "R":
		document.getElementById("InputFkTypName").value=values[0];
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		performTrans('GetTypFkey'+'<|||>'+document._argument);
		document.getElementById("InputFkBotName").readOnly=true;
		document.getElementById("InputFkTypName").readOnly=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
	document.getElementById("InputCubeLevel").value='1';
	document.getElementById("InputFlagPartialKey").value='N';
	document.getElementById("InputFlagRecursive").value='N';
	document.getElementById("InputRecursiveCardinality").value='N';
	document.getElementById("InputCardinality").value='N';
	document.getElementById("InputSortOrder").value='N';
	document.getElementById("InputTransferable").value='Y';
}

function CreateTyp() {
	var l_parameters = 
		document.getElementById("InputFkBotName").value+'<|>'+
		document.getElementById("InputFkTypName").value+'<|>'+
		document.getElementById("InputName").value+'<|>'+
		document.getElementById("InputCode").value+'<|>'+
		document.getElementById("InputFlagPartialKey").value+'<|>'+
		document.getElementById("InputFlagRecursive").value+'<|>'+
		document.getElementById("InputRecursiveCardinality").value+'<|>'+
		document.getElementById("InputCardinality").value+'<|>'+
		document.getElementById("InputSortOrder").value+'<|>'+
		document.getElementById("InputIcon").value+'<|>'+
		document.getElementById("InputTransferable").value;
	if (g_option[0] == 'F' || g_option[0] == 'L') {
		performTrans('CreateTyp<|||>'+g_option[0]+'<|>'+l_parameters);
	} else {
		performTrans('CreateTyp<|||>'+g_option[0]+'<|>'+l_parameters+'<|>'+g_option[1]);
	}
}

function UpdateTyp() {
	var l_parameters = 
		document.getElementById("InputFkBotName").value+'<|>'+
		document.getElementById("InputFkTypName").value+'<|>'+
		document.getElementById("InputName").value+'<|>'+
		document.getElementById("InputCode").value+'<|>'+
		document.getElementById("InputFlagPartialKey").value+'<|>'+
		document.getElementById("InputFlagRecursive").value+'<|>'+
		document.getElementById("InputRecursiveCardinality").value+'<|>'+
		document.getElementById("InputCardinality").value+'<|>'+
		document.getElementById("InputSortOrder").value+'<|>'+
		document.getElementById("InputIcon").value+'<|>'+
		document.getElementById("InputTransferable").value;
	performTrans('UpdateTyp<|||>'+l_parameters);
}

function DeleteTyp() {
	var l_parameters = 
		document.getElementById("InputName").value;
	performTrans('DeleteTyp<|||>'+l_parameters);
}

function OpenDescBox(p_icon,p_name,p_type,p_attribute_type,p_sequence) {

	CloseDescBox();

	var l_objDiv = document.createElement('DIV');
	var l_objTable = document.createElement('TABLE');
	var l_objImg = document.createElement('IMG');
	var l_objSpan = document.createElement('SPAN');
	var l_objImgExit = document.createElement('IMG');
	var l_objTextarea = document.createElement('TEXTAREA');

	document.body.appendChild(l_objDiv);

	l_objDiv.appendChild(l_objTable);
	l_objRow_0 = l_objTable.insertRow();
	l_objCell_0_0 = l_objRow_0.insertCell();
	l_objCell_0_1 = l_objRow_0.insertCell();
	l_objRow_1 = l_objTable.insertRow();
	l_objCell_1_0 = l_objRow_1.insertCell();
	l_objCell_0_0.appendChild(l_objImg);
	l_objCell_0_0.appendChild(l_objSpan);
	l_objCell_0_1.appendChild(l_objImgExit);
	l_objCell_1_0.appendChild(l_objTextarea);

	l_objDiv.id = 'DescBox';
	l_objDiv.style.position = 'absolute';
	l_objDiv.style.left = event.clientX+30;
	l_objDiv.style.top = event.clientY+10;
	l_objDiv.style.border = 'thin solid #7F7F7F';
	l_objDiv.style.boxShadow = '10px 10px 5px #888888';
	l_objDiv.draggable = 'true';
	l_objDiv.ondragstart = function(){StartMove(event)};
	l_objDiv.ondragend = function(){EndMove(event)};
	l_objImg.src = 'icons/' + p_icon + '.bmp';
	l_objSpan.innerHTML = '&nbsp;&nbsp;' + p_name;
	l_objCell_0_1.style.textAlign = 'right';
	l_objImgExit.style.cursor = 'pointer';
	l_objImgExit.src = 'icons/exit.bmp';
	l_objImgExit.onclick = function(){CloseDescBox()};
	l_objCell_1_0.colSpan = '2';
	l_objTextarea.readOnly = true;
	l_objTextarea.id = 'CubeDesc';
	l_objTextarea.rows = '5';
	l_objTextarea.cols = '80';
	l_objTextarea.style.whiteSpace = 'normal';
	l_objTextarea.maxLength = '3999';

	GetDescription(p_type,p_attribute_type,p_sequence);
}

function CloseDescBox() {
	l_obj = document.getElementById("DescBox");
	if (l_obj) { l_obj.parentNode.removeChild(l_obj);}
}

function GetDescription(p_type,p_attribute_type,p_sequence) {
	g_xmlhttp.open('POST','CubeSysServer.php',true);
	g_xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	g_xmlhttp.send('GetCubeDsc'+'<|||>'+p_type+'<|>'+p_attribute_type+'<|>'+p_sequence);
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
<div><img src="icons/type_large.bmp" /><span style="cursor:help" oncontextmenu="OpenDescBox('TYPE','Type','TYPE','_',-1)"> TYPE</span></div>
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
<tr><td style="cursor:help;" oncontextmenu="OpenDescBox('TYPE','Type.Transferable','TYPE','TRANSFERABLE',-1)">Transferable</td><td><div>
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
