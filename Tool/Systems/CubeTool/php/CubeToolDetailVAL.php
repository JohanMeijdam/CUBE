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
		case "SELECT_VAL":
			var l_values = l_argument[1].split("<|>");
			document.getElementById("InputPrompt").value=l_values[0];
			break;
		case "CREATE_VAL":
			document.getElementById("InputFkItpName").readOnly=true;
			document.getElementById("InputFkIteSequence").readOnly=true;
			document.getElementById("InputCode").readOnly=true;
			document.getElementById("ButtonCreate").disabled=true;
			document.getElementById("ButtonUpdate").disabled=false;
			document.getElementById("ButtonDelete").disabled=false;
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			document._nodeId = 'TYP_VAL<||>'+document.getElementById("InputFkItpName").value+'<|>'+document.getElementById("InputFkIteSequence").value+'<|>'+document.getElementById("InputCode").value;
			if (l_objNode != null) {
				if (l_objNode.firstChild._state == 'O') {
					var l_position = g_option[0];
					l_objNodePos = parent.TREE.document.getElementById('TYP_VAL<||>'+g_option[1]);
					parent.TREE.AddTreeviewNode(
						l_objNode,
						'TYP_VAL',
						document._nodeId,
						'icons/value.bmp', 
						document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputPrompt").value.toLowerCase(),
						'N',
						l_position,
						l_objNodePos);
				}
			}
			break;
		case "UPDATE_VAL":
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			if (l_objNode != null) {
				l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputPrompt").value.toLowerCase();
			}
			break;
		case "DELETE_VAL":
			document.getElementById("ButtonUpdate").disabled=true;
			document.getElementById("ButtonDelete").disabled=true;
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			if (l_objNode != null) {
				l_objNode = l_objNode;
				l_objNode.parentNode.removeChild(l_objNode);
			}
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
	g_xmlhttp.open('POST','CubeToolServer.php',true);
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
		document.getElementById("InputFkItpName").value=values[0];
		document.getElementById("InputFkIteSequence").value=values[1];
		document.getElementById("InputCode").value=values[2];
		document.getElementById("ButtonCreate").disabled=true;
		performTrans('GetVal'+'<|||>'+document._argument);
		document.getElementById("InputFkItpName").readOnly=true;
		document.getElementById("InputFkIteSequence").readOnly=true;
		document.getElementById("InputCode").readOnly=true;
		break;
	case "N":
		document.getElementById("InputFkItpName").value=values[0];
		document.getElementById("InputFkIteSequence").value=values[1];
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
	var l_parameters = 
		document.getElementById("InputFkItpName").value+'<|>'+
		document.getElementById("InputFkIteSequence").value+'<|>'+
		document.getElementById("InputCode").value+'<|>'+
		document.getElementById("InputPrompt").value;
	if (g_option[0] == 'F' || g_option[0] == 'L') {
		performTrans('CreateVal<|||>'+g_option[0]+'<|>'+l_parameters);
	} else {
		performTrans('CreateVal<|||>'+g_option[0]+'<|>'+l_parameters+'<|>'+g_option[1]);
	}
}

function UpdateVal() {
	var l_parameters = 
		document.getElementById("InputFkItpName").value+'<|>'+
		document.getElementById("InputFkIteSequence").value+'<|>'+
		document.getElementById("InputCode").value+'<|>'+
		document.getElementById("InputPrompt").value;
	performTrans('UpdateVal<|||>'+l_parameters);
}

function DeleteVal() {
	var l_parameters = 
		document.getElementById("InputFkItpName").value+'<|>'+
		document.getElementById("InputFkIteSequence").value+'<|>'+
		document.getElementById("InputCode").value;
	performTrans('DeleteVal<|||>'+l_parameters);
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
<div><img src="icons/value_large.bmp" /><span> PERMITTED_VALUE</span></div>
<hr/>
<table>
<tr ><td><u>InformationType.Name</u></td><td>
<input id="InputFkItpName" type="text" size="30" maxlength="30" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></td></tr>
<tr ><td><u>InformationTypeElement.Sequence</u></td><td>
<input id="InputFkIteSequence" type="text" size="9" maxlength="9"></input></td></tr>
<tr ><td><u>Code</u></td><td>
<input id="InputCode" type="text" size="8" maxlength="8" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></td></tr>
<tr ><td>Prompt</td><td>
<input id="InputPrompt" type="text" size="32" maxlength="32"></input></td></tr>
<tr><td><br></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateVal()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateVal()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteVal()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>