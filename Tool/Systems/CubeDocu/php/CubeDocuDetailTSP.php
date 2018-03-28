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
		case "SELECT_TSP":
			var l_values = l_argument[1].split("<|>");
			document.getElementById("InputFkBotName").value=l_values[0];
			document.getElementById("InputName").value=l_values[1];
			document.getElementById("InputXfTspTypName").value=l_values[2];
			document.getElementById("InputXfTspTsgCode").value=l_values[3];
			document.getElementById("InputXkTspCode").value=l_values[4];
			break;
		case "CREATE_TSP":
			document.getElementById("InputFkBotName").readOnly=true;
			document.getElementById("InputFkTypName").readOnly=true;
			document.getElementById("InputFkTsgCode").readOnly=true;
			document.getElementById("InputCode").readOnly=true;
			document.getElementById("ButtonCreate").disabled=true;
			document.getElementById("ButtonUpdate").disabled=false;
			document.getElementById("ButtonDelete").disabled=false;
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			document._nodeId = 'TYP_TSP<||>'+document.getElementById("InputFkTypName").value+'<|>'+document.getElementById("InputFkTsgCode").value+'<|>'+document.getElementById("InputCode").value;
			if (l_objNode != null) {
				if (l_objNode.firstChild._state == 'O') {
					var l_position = g_option[0];
					l_objNodePos = parent.TREE.document.getElementById('TYP_TSP<||>'+g_option[1]);
					parent.TREE.AddTreeviewNode(
						l_objNode,
						'TYP_TSP',
						document._nodeId,
						'icons/typespec.bmp', 
						'('+document.getElementById("InputCode").value.toLowerCase()+')'+' '+document.getElementById("InputName").value.toLowerCase(),
						'N',
						l_position,
						l_objNodePos);
				}
			}
			break;
		case "UPDATE_TSP":
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			if (l_objNode != null) {
				l_objNode.children[1].lastChild.nodeValue = ' '+'('+document.getElementById("InputCode").value.toLowerCase()+')'+' '+document.getElementById("InputName").value.toLowerCase();
			}
			break;
		case "DELETE_TSP":
			document.getElementById("ButtonUpdate").disabled=true;
			document.getElementById("ButtonDelete").disabled=true;
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			if (l_objNode != null) {
				l_objNode = l_objNode;
				l_objNode.parentNode.removeChild(l_objNode);
			}
			break;
		case "LIST_TSP":
			OpenListBox(l_argument,'typespec','TypeSpecialisation','Y');
			break;
		case "SELECT_FKEY_TSG":
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
		document.getElementById("InputFkTypName").value=values[0];
		document.getElementById("InputFkTsgCode").value=values[1];
		document.getElementById("InputCode").value=values[2];
		document.getElementById("ButtonCreate").disabled=true;
		performTrans('GetTsp'+'<|||>'+document._argument);
		document.getElementById("InputFkBotName").readOnly=true;
		document.getElementById("InputFkTypName").readOnly=true;
		document.getElementById("InputFkTsgCode").readOnly=true;
		document.getElementById("InputCode").readOnly=true;
		break;
	case "N":
		document.getElementById("InputFkTypName").value=values[0];
		document.getElementById("InputFkTsgCode").value=values[1];
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		performTrans('GetTsgFkey'+'<|||>'+document._argument);
		document.getElementById("InputFkBotName").readOnly=true;
		document.getElementById("InputFkTypName").readOnly=true;
		document.getElementById("InputFkTsgCode").readOnly=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateTsp() {
	var l_parameters = 
		document.getElementById("InputFkBotName").value+'<|>'+
		document.getElementById("InputFkTypName").value+'<|>'+
		document.getElementById("InputFkTsgCode").value+'<|>'+
		document.getElementById("InputCode").value+'<|>'+
		document.getElementById("InputName").value+'<|>'+
		document.getElementById("InputXfTspTypName").value+'<|>'+
		document.getElementById("InputXfTspTsgCode").value+'<|>'+
		document.getElementById("InputXkTspCode").value;
	if (g_option[0] == 'F' || g_option[0] == 'L') {
		performTrans('CreateTsp<|||>'+g_option[0]+'<|>'+l_parameters);
	} else {
		performTrans('CreateTsp<|||>'+g_option[0]+'<|>'+l_parameters+'<|>'+g_option[1]);
	}
}

function UpdateTsp() {
	var l_parameters = 
		document.getElementById("InputFkBotName").value+'<|>'+
		document.getElementById("InputFkTypName").value+'<|>'+
		document.getElementById("InputFkTsgCode").value+'<|>'+
		document.getElementById("InputCode").value+'<|>'+
		document.getElementById("InputName").value+'<|>'+
		document.getElementById("InputXfTspTypName").value+'<|>'+
		document.getElementById("InputXfTspTsgCode").value+'<|>'+
		document.getElementById("InputXkTspCode").value;
	performTrans('UpdateTsp<|||>'+l_parameters);
}

function DeleteTsp() {
	var l_parameters = 
		document.getElementById("InputFkTypName").value+'<|>'+
		document.getElementById("InputFkTsgCode").value+'<|>'+
		document.getElementById("InputCode").value;
	performTrans('DeleteTsp<|||>'+l_parameters);
}

function OpenListBox(p_rows,p_icon,p_header,p_optional) {
	CloseListBox();
	if (p_rows.length > 1) {

		var l_objDiv = document.createElement('DIV');
		var l_objTable = document.createElement('TABLE');
		var l_objImg = document.createElement('IMG');
		var l_objSpan = document.createElement('SPAN');
		var l_objImgExit = document.createElement('IMG');
		var l_objSelect = document.createElement('SELECT');

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
		l_objCell_1_0.appendChild(l_objSelect);

		l_objDiv.id = 'ListBox';
		l_objDiv.style.position = 'absolute';
		l_objDiv.style.left = document.body._SelectLeft-260;
		l_objDiv.style.top = document.body._SelectTop-80;
		l_objDiv.style.border = 'thin solid #7F7F7F';
		l_objDiv.style.boxShadow = '10px 10px 5px #888888';
		l_objDiv.draggable = 'true';
		l_objDiv.ondragstart = function(){StartMove(event)};
		l_objDiv.ondragend = function(){EndMove(event)};

		l_objImg.src = 'icons/'+p_icon+'.bmp';
		l_objImg.style.border = '2 solid transparent';
		l_objSpan.innerHTML = '&nbsp;&nbsp;'+p_header+'&nbsp;&nbsp;';
		l_objCell_0_1.style.textAlign = 'right';
		l_objImgExit.style.cursor = 'pointer';
		l_objImgExit.src = 'icons/exit.bmp';
		l_objImgExit.style.border = '1 solid transparent';
		l_objImgExit.onclick = function(){CloseListBox()};
		l_objCell_1_0.colSpan = '2';


		l_objSelect.size = Math.min(p_rows.length-1,16)
		l_objSelect.onclick = function(){UpdateForeignKey(this)};

		if (p_optional == 'Y') {
			l_objSelect.size = l_objSelect.size + 1;
			var l_objOption = document.createElement('OPTION');
			l_objSelect.appendChild(l_objOption);
			l_objOption.value = '';
			l_objOption.innerHTML = '';
		}

		for (ir in p_rows) {
			if (ir > 0) {
				var l_rowpart = p_rows[ir].split("<||>");
				var l_objOption = document.createElement('OPTION');
				l_objSelect.appendChild(l_objOption);
				l_objOption.value = l_rowpart[0];
				l_objOption.innerHTML = l_rowpart[1].toLowerCase();
			}
		}
	} else {
		alert ("No Items Found");
	}
}

function CloseListBox() {
	var l_obj = document.getElementById("ListBox");
	if (l_obj) {l_obj.parentNode.removeChild(l_obj);}
}

function UpdateForeignKey(p_obj) {
	var l_obj_option = p_obj.options[p_obj.selectedIndex];
	var l_values = l_obj_option.value.split("<|>");
	switch (document.body._ListBoxCode){
	case "Ref001":
		if (l_obj_option.value == '') {
			document.getElementById("InputXfTspTypName").value = '';
		} else {
			document.getElementById("InputXfTspTypName").value = l_values[0];
		}
		if (l_obj_option.value == '') {
			document.getElementById("InputXfTspTsgCode").value = '';
		} else {
			document.getElementById("InputXfTspTsgCode").value = l_values[1];
		}
		if (l_obj_option.value == '') {
			document.getElementById("InputXkTspCode").value = '';
		} else {
			document.getElementById("InputXkTspCode").value = l_values[2];
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
	var l_parameters = '1<|>'+document.getElementById("InputFkTypName").value+'<|>'+document.getElementById("InputFkTsgCode").value
	performTrans('GetTspForTsgList<|||>'+l_parameters);
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
<div><img src="icons/typespec_large.bmp" /><span> TYPE_SPECIALISATION</span></div>
<hr/>
<table>
<tr><td>BusinessObjectType.Name</td><td><div style="max-width:30em;">
<input id="InputFkBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Type.Name</u></td><td><div style="max-width:30em;">
<input id="InputFkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>TypeSpecialisationGroup.Code</u></td><td><div style="max-width:8em;">
<input id="InputFkTsgCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Code</u></td><td><div style="max-width:8em;">
<input id="InputCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Name</td><td><div style="max-width:30em;">
<input id="InputName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/typespec.bmp"/> TypeSpecialisation (Specialise)</legend>
<table style="width:100%;">
<tr><td>Type.Name</td><td style="width:100%;"><div style="max-width:30em;">
<input id="InputXfTspTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td>TypeSpecialisationGroup.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfTspTsgCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
<tr><td>TypeSpecialisation.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkTspCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateTsp()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateTsp()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteTsp()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeSequence" type="hidden"></input>
</body>
</html>
