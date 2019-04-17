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
var g_node_id;

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
					case "SELECT_PRD":
						document.getElementById("InputCubeTsgZzz").value=l_json_array[i].Rows[0].Data.CubeTsgZzz;
						document.getElementById("InputCubeTsgYyy").value=l_json_array[i].Rows[0].Data.CubeTsgYyy;
						document.getElementById("InputDatum").value=l_json_array[i].Rows[0].Data.Datum;
						document.getElementById("InputOmschrijving").value=l_json_array[i].Rows[0].Data.Omschrijving;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_PRD":
						document.getElementById("InputCode").readOnly=true;
						document.getElementById("InputNaam").readOnly=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_node_id);
						var l_json_node_id = {Code:document.getElementById("InputCode").value,Naam:document.getElementById("InputNaam").value};
						g_node_id = '{"TYP_PRD":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_PRD',
									l_json_node_id,
									'icons/produkt.bmp', 
									document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputNaam").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_PRD":
						break;
					case "DELETE_PRD":
						document.getElementById("ButtonUpdate").disabled=true;
						document.getElementById("ButtonDelete").disabled=true;
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode = l_objNode;
							l_objNode.parentNode.removeChild(l_objNode);
						}
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
	g_node_id = JSON.stringify(l_json_argument.objectId);
	switch (l_json_argument.nodeType) {
	case "D":
		document.getElementById("InputCode").value=l_json_objectKey.TYP_PRD.Code;
		document.getElementById("InputNaam").value=l_json_objectKey.TYP_PRD.Naam;
		document.getElementById("ButtonCreate").disabled=true;
		l_objParm = {Service:"GetPrd",Parameters:{Type:l_json_objectKey.TYP_PRD}};
		performTrans(l_objParm);
		document.getElementById("InputCubeTsgZzz").readOnly=true;
		document.getElementById("InputCubeTsgYyy").readOnly=true;
		document.getElementById("InputCode").readOnly=true;
		document.getElementById("InputNaam").readOnly=true;
		break;
	case "N":
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreatePrd() {
	var l_json_type = {Type:{CubeTsgZzz:document.getElementById("InputCubeTsgZzz").value,CubeTsgYyy:document.getElementById("InputCubeTsgYyy").value,Code:document.getElementById("InputCode").value,Naam:document.getElementById("InputNaam").value,Datum:document.getElementById("InputDatum").value,Omschrijving:document.getElementById("InputOmschrijving").value}};
	performTrans( {Service:"CreatePrd",Parameters:l_json_type} );
}

function UpdatePrd() {
	var l_json_type = {Type:{CubeTsgZzz:document.getElementById("InputCubeTsgZzz").value,CubeTsgYyy:document.getElementById("InputCubeTsgYyy").value,Code:document.getElementById("InputCode").value,Naam:document.getElementById("InputNaam").value,Datum:document.getElementById("InputDatum").value,Omschrijving:document.getElementById("InputOmschrijving").value}};;
	performTrans( {Service:"UpdatePrd",Parameters:l_json_type} );
}

function DeletePrd() {
	var l_json_type = {Type:{Code:document.getElementById("InputCode").value,Naam:document.getElementById("InputNaam").value}};;
	performTrans( {Service:"DeletePrd",Parameters:l_json_type} );
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

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgZzz").value != ' ' && document.getElementById("InputCubeTsgYyy").value != ' ') {
		document.getElementById("InputCubeTsgZzz").disabled=true;
		document.getElementById("InputCubeTsgYyy").disabled=true;
		document.getElementById("TableMain").style.display="inline";
	}
}

function ResetFieldCubeTsgYyy(p_field_id) {
	document.getElementById("InputCubeTsgYyy").value=' ';
	switch (document.getElementById(p_field_id).value){
	case "QQQ":
		break;
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/produkt_large.bmp" /><span> PROD /
<select id="InputCubeTsgZzz" type="text" onchange="ResetFieldCubeTsgYyy('InputCubeTsgZzz')">
	<option value=" " selected>&lt;zzz&gt;</option>
	<option value="QQQ"></option>
</select> <b>.</b>
<select id="InputCubeTsgYyy" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;yyy&gt;</option>
	<option id="ValCubeTsgYyy-QQQ" style="display:none" value="QQQ">QQQ</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr><td><u>Code</u></td><td><div style="max-width:8em;">
<input id="InputCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Naam</u></td><td><div style="max-width:40em;">
<input id="InputNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td>Datum</td><td><div style="max-width:12ch;">
<input id="InputDatum" type="text" maxlength="10" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Omschrijving</td><td><div style="max-width:120em;">
<input id="InputOmschrijving" type="text" maxlength="120" style="width:100%;"></input></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreatePrd()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdatePrd()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeletePrd()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
