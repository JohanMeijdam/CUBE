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
					case "SELECT_PR2":
						document.getElementById("InputOmschrijving").value=l_json_array[i].Rows[0].Data.Omschrijving;
						break;
					case "CREATE_PR2":
						document.getElementById("InputFkPrdCode").readOnly=true;
						document.getElementById("InputFkPrdNaam").readOnly=true;
						document.getElementById("InputCode").readOnly=true;
						document.getElementById("InputNaam").readOnly=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkPrdCode:document.getElementById("InputFkPrdCode").value,FkPrdNaam:document.getElementById("InputFkPrdNaam").value,Code:document.getElementById("InputCode").value,Naam:document.getElementById("InputNaam").value};
						g_node_id = '{"TYP_PR2":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_PR2',
									l_json_node_id,
									'icons/produkt.bmp', 
									document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputNaam").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_PR2":
						break;
					case "DELETE_PR2":
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

function performTrans(p_json_parm) {
	var l_requestText = JSON.stringify(p_json_parm);
	g_xmlhttp.open('POST','CubeTestServer.php',true);
//	g_xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	g_xmlhttp.send(l_requestText);
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
		document.getElementById("InputFkPrdCode").value=l_json_objectKey.TYP_PR2.FkPrdCode;
		document.getElementById("InputFkPrdNaam").value=l_json_objectKey.TYP_PR2.FkPrdNaam;
		document.getElementById("InputCode").value=l_json_objectKey.TYP_PR2.Code;
		document.getElementById("InputNaam").value=l_json_objectKey.TYP_PR2.Naam;
		document.getElementById("ButtonCreate").disabled=true;
		l_json_parm = {Service:"GetPr2",Parameters:{Type:l_json_objectKey.TYP_PR2}};
		performTrans(l_json_parm);
		document.getElementById("InputFkPrdCode").readOnly=true;
		document.getElementById("InputFkPrdNaam").readOnly=true;
		document.getElementById("InputCode").readOnly=true;
		document.getElementById("InputNaam").readOnly=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPrdCode").value=l_json_objectKey.TYP_PRD.Code;
		document.getElementById("InputFkPrdNaam").value=l_json_objectKey.TYP_PRD.Naam;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkPrdCode").readOnly=true;
		document.getElementById("InputFkPrdNaam").readOnly=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreatePr2() {
	var l_json_type = {
		Type: {
			FkPrdCode:document.getElementById("InputFkPrdCode").value,
			FkPrdNaam:document.getElementById("InputFkPrdNaam").value,
			Code:document.getElementById("InputCode").value,
			Naam:document.getElementById("InputNaam").value,
			Omschrijving:document.getElementById("InputOmschrijving").value
		}
	};
	performTrans( {Service:"CreatePr2",Parameters:l_json_type} );
}

function UpdatePr2() {
	var l_json_type = {
		Type: {
			FkPrdCode:document.getElementById("InputFkPrdCode").value,
			FkPrdNaam:document.getElementById("InputFkPrdNaam").value,
			Code:document.getElementById("InputCode").value,
			Naam:document.getElementById("InputNaam").value,
			Omschrijving:document.getElementById("InputOmschrijving").value
		}
	};
	performTrans( {Service:"UpdatePr2",Parameters:l_json_type} );
}

function DeletePr2() {
	var l_json_type = {
		Type: {
			FkPrdCode:document.getElementById("InputFkPrdCode").value,
			FkPrdNaam:document.getElementById("InputFkPrdNaam").value,
			Code:document.getElementById("InputCode").value,
			Naam:document.getElementById("InputNaam").value
		}
	};
	performTrans( {Service:"DeletePr2",Parameters:l_json_type} );
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
<div><img src="icons/produkt_large.bmp" /><span> PROD2</span></div>
<hr/>
<table>
<tr><td><u>Prod.Code</u></td><td><div style="max-width:8em;">
<input id="InputFkPrdCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Prod.Naam</u></td><td><div style="max-width:40em;">
<input id="InputFkPrdNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td><u>Code</u></td><td><div style="max-width:8em;">
<input id="InputCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Naam</u></td><td><div style="max-width:40em;">
<input id="InputNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td>Omschrijving</td><td><div style="max-width:120em;">
<input id="InputOmschrijving" type="text" maxlength="120" style="width:100%;"></input></div></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreatePr2()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdatePr2()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeletePr2()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
