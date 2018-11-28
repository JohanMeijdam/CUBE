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
		case "SELECT_PA2":
			var l_values = l_argument[1].split("<|>");
			document.getElementById("InputFkPa2Code").value=l_values[0];
			document.getElementById("InputFkPa2Naam").value=l_values[1];
			document.getElementById("InputOmschrijving").value=l_values[2];
			document.getElementById("InputXfPa2PrdCode").value=l_values[3];
			document.getElementById("InputXfPa2PrdNaam").value=l_values[4];
			document.getElementById("InputXfPa2Pr2Code").value=l_values[5];
			document.getElementById("InputXfPa2Pr2Naam").value=l_values[6];
			document.getElementById("InputXkPa2Code").value=l_values[7];
			document.getElementById("InputXkPa2Naam").value=l_values[8];
			break;
		case "CREATE_PA2":
			document.getElementById("InputFkPrdCode").readOnly=true;
			document.getElementById("InputFkPrdNaam").readOnly=true;
			document.getElementById("InputFkPr2Code").readOnly=true;
			document.getElementById("InputFkPr2Naam").readOnly=true;
			document.getElementById("InputFkPa2Code").readOnly=true;
			document.getElementById("InputFkPa2Naam").readOnly=true;
			document.getElementById("InputCode").readOnly=true;
			document.getElementById("InputNaam").readOnly=true;
			document.getElementById("ButtonCreate").disabled=true;
			document.getElementById("ButtonUpdate").disabled=false;
			document.getElementById("ButtonDelete").disabled=false;
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			document._nodeId = 'TYP_PA2<||>'+document.getElementById("InputFkPrdCode").value+'<|>'+document.getElementById("InputFkPrdNaam").value+'<|>'+document.getElementById("InputFkPr2Code").value+'<|>'+document.getElementById("InputFkPr2Naam").value+'<|>'+document.getElementById("InputCode").value+'<|>'+document.getElementById("InputNaam").value;
			if (l_objNode != null) {
				if (l_objNode.firstChild._state == 'O') {
					var l_position = 'L';
					l_objNodePos = null;
					parent.TREE.AddTreeviewNode(
						l_objNode,
						'TYP_PA2',
						document._nodeId,
						'icons/part.bmp', 
						document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputNaam").value.toLowerCase(),
						'N',
						l_position,
						l_objNodePos);
				}
			}
			break;
		case "UPDATE_PA2":
			break;
		case "DELETE_PA2":
			document.getElementById("ButtonUpdate").disabled=true;
			document.getElementById("ButtonDelete").disabled=true;
			l_objNode = parent.TREE.document.getElementById(document._nodeId);
			if (l_objNode != null) {
				l_objNode = l_objNode;
				l_objNode.parentNode.removeChild(l_objNode);
			}
			break;
		case "LIST_PA2":
			OpenListBox(l_argument,'part','Part2','Y');
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

function performTrans(p_objParm) {
	var l_requestText = JSON.stringify(p_objParm);
	g_xmlhttp.open('POST','CubeTestServer.php',true);
//	g_xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	g_xmlhttp.send(l_requestText);
}

function InitBody() {
	var l_argument = decodeURIComponent(document.location.href).split("<|||>");
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	document.body._ListBoxCode="Ref000";
	document._nodeId = l_argument[2];
	document._argument = document._nodeId.split("<||>")[1];
	if (document._argument != null) {
		var values = document._argument.split("<|>");
	}
	switch (l_argument[1]) {
	case "D":
		document.getElementById("InputFkPrdCode").value=values[0];
		document.getElementById("InputFkPrdNaam").value=values[1];
		document.getElementById("InputFkPr2Code").value=values[2];
		document.getElementById("InputFkPr2Naam").value=values[3];
		document.getElementById("InputCode").value=values[4];
		document.getElementById("InputNaam").value=values[5];
		document.getElementById("ButtonCreate").disabled=true;
		l_objParm = { service : "GetPa2", parameters : "HIER _ARGUMENT VULLEN ALS OBJECT"};
		performTrans(l_objParm);
		document.getElementById("InputFkPrdCode").readOnly=true;
		document.getElementById("InputFkPrdNaam").readOnly=true;
		document.getElementById("InputFkPr2Code").readOnly=true;
		document.getElementById("InputFkPr2Naam").readOnly=true;
		document.getElementById("InputFkPa2Code").readOnly=true;
		document.getElementById("InputFkPa2Naam").readOnly=true;
		document.getElementById("InputCode").readOnly=true;
		document.getElementById("InputNaam").readOnly=true;
		break;
	case "N":
		document.getElementById("InputFkPrdCode").value=values[0];
		document.getElementById("InputFkPrdNaam").value=values[1];
		document.getElementById("InputFkPr2Code").value=values[2];
		document.getElementById("InputFkPr2Naam").value=values[3];
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkPrdCode").readOnly=true;
		document.getElementById("InputFkPrdNaam").readOnly=true;
		document.getElementById("InputFkPr2Code").readOnly=true;
		document.getElementById("InputFkPr2Naam").readOnly=true;
		document.getElementById("InputFkPa2Code").readOnly=true;
		document.getElementById("InputFkPa2Naam").readOnly=true;
		break;  
	case "R":
		document.getElementById("InputFkPrdCode").value=values[0];
		document.getElementById("InputFkPrdNaam").value=values[1];
		document.getElementById("InputFkPr2Code").value=values[2];
		document.getElementById("InputFkPr2Naam").value=values[3];
		document.getElementById("InputFkPa2Code").value=values[4];
		document.getElementById("InputFkPa2Naam").value=values[5];
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkPrdCode").readOnly=true;
		document.getElementById("InputFkPrdNaam").readOnly=true;
		document.getElementById("InputFkPr2Code").readOnly=true;
		document.getElementById("InputFkPr2Naam").readOnly=true;
		document.getElementById("InputFkPa2Code").readOnly=true;
		document.getElementById("InputFkPa2Naam").readOnly=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
	document.getElementById("InputCubeLevel").value='1';
}

function CreatePa2() {
	var l_parameters = 
		document.getElementById("InputFkPrdCode").value+'<|>'+
		document.getElementById("InputFkPrdNaam").value+'<|>'+
		document.getElementById("InputFkPr2Code").value+'<|>'+
		document.getElementById("InputFkPr2Naam").value+'<|>'+
		document.getElementById("InputFkPa2Code").value+'<|>'+
		document.getElementById("InputFkPa2Naam").value+'<|>'+
		document.getElementById("InputCode").value+'<|>'+
		document.getElementById("InputNaam").value+'<|>'+
		document.getElementById("InputOmschrijving").value+'<|>'+
		document.getElementById("InputXfPa2PrdCode").value+'<|>'+
		document.getElementById("InputXfPa2PrdNaam").value+'<|>'+
		document.getElementById("InputXfPa2Pr2Code").value+'<|>'+
		document.getElementById("InputXfPa2Pr2Naam").value+'<|>'+
		document.getElementById("InputXkPa2Code").value+'<|>'+
		document.getElementById("InputXkPa2Naam").value;
	performTrans('CreatePa2<|||>'+l_parameters);
}

function UpdatePa2() {
	var l_parameters = 
		document.getElementById("InputFkPrdCode").value+'<|>'+
		document.getElementById("InputFkPrdNaam").value+'<|>'+
		document.getElementById("InputFkPr2Code").value+'<|>'+
		document.getElementById("InputFkPr2Naam").value+'<|>'+
		document.getElementById("InputFkPa2Code").value+'<|>'+
		document.getElementById("InputFkPa2Naam").value+'<|>'+
		document.getElementById("InputCode").value+'<|>'+
		document.getElementById("InputNaam").value+'<|>'+
		document.getElementById("InputOmschrijving").value+'<|>'+
		document.getElementById("InputXfPa2PrdCode").value+'<|>'+
		document.getElementById("InputXfPa2PrdNaam").value+'<|>'+
		document.getElementById("InputXfPa2Pr2Code").value+'<|>'+
		document.getElementById("InputXfPa2Pr2Naam").value+'<|>'+
		document.getElementById("InputXkPa2Code").value+'<|>'+
		document.getElementById("InputXkPa2Naam").value;
	performTrans('UpdatePa2<|||>'+l_parameters);
}

function DeletePa2() {
	var l_parameters = 
		document.getElementById("InputFkPrdCode").value+'<|>'+
		document.getElementById("InputFkPrdNaam").value+'<|>'+
		document.getElementById("InputFkPr2Code").value+'<|>'+
		document.getElementById("InputFkPr2Naam").value+'<|>'+
		document.getElementById("InputCode").value+'<|>'+
		document.getElementById("InputNaam").value;
	performTrans('DeletePa2<|||>'+l_parameters);
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
			document.getElementById("InputXfPa2PrdCode").value = '';
		} else {
			document.getElementById("InputXfPa2PrdCode").value = l_values[0];
		}
		if (l_obj_option.value == '') {
			document.getElementById("InputXfPa2PrdNaam").value = '';
		} else {
			document.getElementById("InputXfPa2PrdNaam").value = l_values[1];
		}
		if (l_obj_option.value == '') {
			document.getElementById("InputXfPa2Pr2Code").value = '';
		} else {
			document.getElementById("InputXfPa2Pr2Code").value = l_values[2];
		}
		if (l_obj_option.value == '') {
			document.getElementById("InputXfPa2Pr2Naam").value = '';
		} else {
			document.getElementById("InputXfPa2Pr2Naam").value = l_values[3];
		}
		if (l_obj_option.value == '') {
			document.getElementById("InputXkPa2Code").value = '';
		} else {
			document.getElementById("InputXkPa2Code").value = l_values[4];
		}
		if (l_obj_option.value == '') {
			document.getElementById("InputXkPa2Naam").value = '';
		} else {
			document.getElementById("InputXkPa2Naam").value = l_values[5];
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
	var l_parameters = 
		document.getElementById("InputFkPrdCode").value+'<|>'+
		document.getElementById("InputFkPrdNaam").value+'<|>'+
		document.getElementById("InputFkPr2Code").value+'<|>'+
		document.getElementById("InputFkPr2Naam").value+'<|>'+
		document.getElementById("InputFkPrdCode").value+'<|>'+
		document.getElementById("InputFkPrdNaam").value;
	performTrans('GetPa2ForPrdListEncapsulated<|||>'+l_parameters);
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
<div><img src="icons/part_large.bmp" /><span> PART2</span></div>
<hr/>
<table>
<tr><td><u>Prod.Code</u></td><td><div style="max-width:8em;">
<input id="InputFkPrdCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Prod.Naam</u></td><td><div style="max-width:40em;">
<input id="InputFkPrdNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td><u>Prod2.Code</u></td><td><div style="max-width:8em;">
<input id="InputFkPr2Code" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Prod2.Naam</u></td><td><div style="max-width:40em;">
<input id="InputFkPr2Naam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td>Part2.Code</td><td><div style="max-width:8em;">
<input id="InputFkPa2Code" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Part2.Naam</td><td><div style="max-width:40em;">
<input id="InputFkPa2Naam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td><u>Code</u></td><td><div style="max-width:8em;">
<input id="InputCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Naam</u></td><td><div style="max-width:40em;">
<input id="InputNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td>Omschrijving</td><td><div style="max-width:120em;">
<input id="InputOmschrijving" type="text" maxlength="120" style="width:100%;"></input></div></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/part.bmp"/> Part2 (Concerns)</legend>
<table style="width:100%;">
<tr><td>Prod.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfPa2PrdCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td>Prod.Naam</td><td style="width:100%;"><div style="max-width:40em;">
<input id="InputXfPa2PrdNaam" type="text" maxlength="40" style="width:100%;" readonly></input></div></td></tr>
<tr><td>Prod2.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXfPa2Pr2Code" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
<tr><td>Prod2.Naam</td><td style="width:100%;"><div style="max-width:40em;">
<input id="InputXfPa2Pr2Naam" type="text" maxlength="40" style="width:100%;" readonly></input></div></td></tr>
<tr><td>Part2.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkPa2Code" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
<tr><td>Part2.Naam</td><td style="width:100%;"><div style="max-width:40em;">
<input id="InputXkPa2Naam" type="text" maxlength="40" style="width:100%;" readonly></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreatePa2()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdatePa2()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeletePa2()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeLevel" type="hidden"></input>
</body>
</html>
