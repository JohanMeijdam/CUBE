<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language='javascript' type='text/javascript'>
<!--
var g_option;
var g_json_option;

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
					case "SELECT_AAA":
						document.getElementById("InputFkAaaNaam").value=l_json_array[i].Rows[0].Data.FkAaaNaam;
						document.getElementById("InputOmschrijving").value=l_json_array[i].Rows[0].Data.Omschrijving;
						document.getElementById("InputXkAaaNaam").value=l_json_array[i].Rows[0].Data.XkAaaNaam;
						break;
					case "CREATE_AAA":
						document.getElementById("InputFkAaaNaam").readOnly=true;
						document.getElementById("InputNaam").readOnly=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						l_objNode = parent.TREE.document.getElementById(document._nodeId);
						document._nodeId = 'TYP_AAA<||>'+document.getElementById("InputNaam").value;
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								if (l_argument[1] == null) {
									var l_position = 'L';
									l_objNodePos = null;
								} else {
									var l_position = 'B';
									l_objNodePos = parent.TREE.document.getElementById('TYP_AAA<||>'+l_argument[1]);
								}
								parent.TREE.AddTreeviewNode(
									l_objNode,
									'TYP_AAA',
									document._nodeId,
									'icons/produkt.bmp', 
									document.getElementById("InputNaam").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_AAA":
						break;
					case "DELETE_AAA":
						document.getElementById("ButtonUpdate").disabled=true;
						document.getElementById("ButtonDelete").disabled=true;
						l_objNode = parent.TREE.document.getElementById(document._nodeId);
						if (l_objNode != null) {
							l_objNode = l_objNode;
							l_objNode.parentNode.removeChild(l_objNode);
						}
						break;
					case "LIST_AAA":
						OpenListBox(l_argument,'produkt','Aaa','Y');
						break;
					case "SELECT_CUBE_DSC":
						document.getElementById("CubeDesc").value = l_argument[1];
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

function performTrans(p_objParm) {
	var l_requestText = JSON.stringify(p_objParm);
	g_xmlhttp.open('POST','CubeTestServer.php',true);
//	g_xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	g_xmlhttp.send(l_requestText);
}

function InitBody() {
	var l_json_argument = JSON.parse(decodeURIComponent(location.href.split("?")[1]));
//	var l_argument = decodeURIComponent(document.location.href).split("<|||>");
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	document.body._ListBoxCode="Ref000";
	var l_json_objectKey = l_json_argument.objectId;
	document._nodeId = JSON.stringify(l_json_argument.objectId);
	switch (l_json_argument.nodeType) {
	case "D":
		document.getElementById("InputNaam").value=l_json_objectKey.TYP_AAA.Naam;
		document.getElementById("ButtonCreate").disabled=true;
		l_objParm = {Service:"GetAaa",Parameters:{Type:l_json_objectKey.TYP_AAA}};
		performTrans(l_objParm);
		document.getElementById("InputFkAaaNaam").readOnly=true;
		document.getElementById("InputNaam").readOnly=true;
		document.getElementById("InputXkAaaNaam").readOnly=true;
		document.getElementById("RefSelect001").disabled=true;
		break;
	case "N":
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkAaaNaam").readOnly=true;
		break;  
	case "R":
		document.getElementById("InputFkAaaNaam").value=l_json_objectKey.TYP_AAA.Naam;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkAaaNaam").readOnly=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
	document.getElementById("InputCubeLevel").value='1';
}

function CreateAaa() {
	var l_parameters = 
		document.getElementById("InputFkAaaNaam").value+'<|>'+
		document.getElementById("InputNaam").value+'<|>'+
		document.getElementById("InputOmschrijving").value+'<|>'+
		document.getElementById("InputXkAaaNaam").value;
	performTrans('CreateAaa<|||>'+l_parameters);
}

function UpdateAaa() {
	var l_parameters = 
		document.getElementById("InputFkAaaNaam").value+'<|>'+
		document.getElementById("InputNaam").value+'<|>'+
		document.getElementById("InputOmschrijving").value+'<|>'+
		document.getElementById("InputXkAaaNaam").value;
	performTrans('UpdateAaa<|||>'+l_parameters);
}

function DeleteAaa() {
	var l_parameters = 
		document.getElementById("InputNaam").value;
	performTrans('DeleteAaa<|||>'+l_parameters);
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
			document.getElementById("InputXkAaaNaam").value = '';
		} else {
			document.getElementById("InputXkAaaNaam").value = l_values[0];
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
	performTrans('GetAaaListAll');
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
<div><img src="icons/produkt_large.bmp" /><span> AAA</span></div>
<hr/>
<table>
<tr><td>Aaa.Naam</td><td><div style="max-width:40em;">
<input id="InputFkAaaNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td><u>Naam</u></td><td><div style="max-width:40em;">
<input id="InputNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td>Omschrijving</td><td><div style="max-width:120em;">
<input id="InputOmschrijving" type="text" maxlength="120" style="width:100%;"></input></div></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/produkt.bmp"/> Aaa (Recursive)</legend>
<table style="width:100%;">
<tr><td>Aaa.Naam</td><td style="width:100%;"><div style="max-width:40em;">
<input id="InputXkAaaNaam" type="text" maxlength="40" style="width:100%;" readonly></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateAaa()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateAaa()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteAaa()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
<input id="InputCubeLevel" type="hidden"></input>
</body>
</html>
