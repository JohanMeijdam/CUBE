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
					case "SELECT_PA2":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkPrdCode").value=l_json_values.FkPrdCode;
						document.getElementById("InputFkPrdNaam").value=l_json_values.FkPrdNaam;
						document.getElementById("InputFkPr2Code").value=l_json_values.FkPr2Code;
						document.getElementById("InputFkPr2Naam").value=l_json_values.FkPr2Naam;
						document.getElementById("InputFkPa2Code").value=l_json_values.FkPa2Code;
						document.getElementById("InputFkPa2Naam").value=l_json_values.FkPa2Naam;
						document.getElementById("InputOmschrijving").value=l_json_values.Omschrijving;
						document.getElementById("InputXkPa2Code").value=l_json_values.XkPa2Code;
						document.getElementById("InputXkPa2Naam").value=l_json_values.XkPa2Naam;
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
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Code:document.getElementById("InputCode").value,Naam:document.getElementById("InputNaam").value};
						g_node_id = '{"TYP_PA2":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_PA2',
									l_json_node_id,
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
					case "LIST_PA2":
						OpenListBox(l_json_array[i].Rows,'part','Part2','Y');
						break;
					case "SELECT_FKEY_PR2":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkPrdCode").value=l_json_values.FkPrdCode;
						document.getElementById("InputFkPrdNaam").value=l_json_values.FkPrdNaam;
						break;
					case "SELECT_FKEY_PA2":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkPrdCode").value=l_json_values.FkPrdCode;
						document.getElementById("InputFkPrdNaam").value=l_json_values.FkPrdNaam;
						document.getElementById("InputFkPr2Code").value=l_json_values.FkPr2Code;
						document.getElementById("InputFkPr2Naam").value=l_json_values.FkPr2Naam;
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
		document.getElementById("InputCode").value=l_json_objectKey.TYP_PA2.Code;
		document.getElementById("InputNaam").value=l_json_objectKey.TYP_PA2.Naam;
		document.getElementById("ButtonCreate").disabled=true;
		performTrans( {
			Service: "GetPa2",
			Parameters: {
				Type: l_json_objectKey.TYP_PA2
			}
		} );
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
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPr2Code").value=l_json_objectKey.TYP_PR2.Code;
		document.getElementById("InputFkPr2Naam").value=l_json_objectKey.TYP_PR2.Naam;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		performTrans( {
			Service: "GetPr2Fkey",
			Parameters: {
				Type: l_json_objectKey.TYP_PR2
			}
		} );
		document.getElementById("InputFkPrdCode").readOnly=true;
		document.getElementById("InputFkPrdNaam").readOnly=true;
		document.getElementById("InputFkPr2Code").readOnly=true;
		document.getElementById("InputFkPr2Naam").readOnly=true;
		document.getElementById("InputFkPa2Code").readOnly=true;
		document.getElementById("InputFkPa2Naam").readOnly=true;
		break;  
	case "R":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkPa2Code").value=l_json_objectKey.TYP_PA2.Code;
		document.getElementById("InputFkPa2Naam").value=l_json_objectKey.TYP_PA2.Naam;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		performTrans( {
			Service: "GetPa2Fkey",
			Parameters: {
				Type: l_json_objectKey.TYP_PA2
			}
		} );
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
	var Type = {
		FkPrdCode: document.getElementById("InputFkPrdCode").value,
		FkPrdNaam: document.getElementById("InputFkPrdNaam").value,
		FkPr2Code: document.getElementById("InputFkPr2Code").value,
		FkPr2Naam: document.getElementById("InputFkPr2Naam").value,
		FkPa2Code: document.getElementById("InputFkPa2Code").value,
		FkPa2Naam: document.getElementById("InputFkPa2Naam").value,
		Code: document.getElementById("InputCode").value,
		Naam: document.getElementById("InputNaam").value,
		Omschrijving: document.getElementById("InputOmschrijving").value,
		XkPa2Code: document.getElementById("InputXkPa2Code").value,
		XkPa2Naam: document.getElementById("InputXkPa2Naam").value
	};
	performTrans( {
		Service: "CreatePa2",
		Parameters: {
			Type
		}
	} );
}

function UpdatePa2() {
	var Type = {
		FkPrdCode: document.getElementById("InputFkPrdCode").value,
		FkPrdNaam: document.getElementById("InputFkPrdNaam").value,
		FkPr2Code: document.getElementById("InputFkPr2Code").value,
		FkPr2Naam: document.getElementById("InputFkPr2Naam").value,
		FkPa2Code: document.getElementById("InputFkPa2Code").value,
		FkPa2Naam: document.getElementById("InputFkPa2Naam").value,
		Code: document.getElementById("InputCode").value,
		Naam: document.getElementById("InputNaam").value,
		Omschrijving: document.getElementById("InputOmschrijving").value,
		XkPa2Code: document.getElementById("InputXkPa2Code").value,
		XkPa2Naam: document.getElementById("InputXkPa2Naam").value
	};
	performTrans( {
		Service: "UpdatePa2",
		Parameters: {
			Type
		}
	} );
}

function DeletePa2() {
	var Type = {
		Code: document.getElementById("InputCode").value,
		Naam: document.getElementById("InputNaam").value
	};
	performTrans( {
		Service: "DeletePa2",
		Parameters: {
			Type
		}
	} );
}

function OpenListBox(p_json_rows,p_icon,p_header,p_optional) {
	CloseListBox();
	if (p_json_rows.length > 1) {

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


		l_objSelect.size = Math.min(p_json_rows.length-1,16)
		l_objSelect.onclick = function(){UpdateForeignKey(this)};

		if (p_optional == 'Y') {
			l_objSelect.size = l_objSelect.size + 1;
			var l_objOption = document.createElement('OPTION');
			l_objSelect.appendChild(l_objOption);
			l_objOption.value = '';
			l_objOption.innerHTML = '';
		}

		for (ir in p_json_rows) {
			var l_objOption = document.createElement('OPTION');
			l_objSelect.appendChild(l_objOption);
			l_objOption.value = JSON.stringify(p_json_rows[ir].Key); 
			l_objOption.innerHTML = p_json_rows[ir].Display.toLowerCase();
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
	var l_values = p_obj.options[p_obj.selectedIndex].value;
	if (l_values != '') {
		var l_json_values = JSON.parse(l_values);
	}
	switch (document.body._ListBoxCode){
	case "Ref001":
		if (l_values == '') {
			document.getElementById("InputXkPa2Code").value = '';
		} else {
			document.getElementById("InputXkPa2Code").value = l_json_values.Code;
		}
		if (l_values == '') {
			document.getElementById("InputXkPa2Naam").value = '';
		} else {
			document.getElementById("InputXkPa2Naam").value = l_json_values.Naam;
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
	var Parameters = {
		Type: {
			FkPr2Code:document.getElementById("InputFkPr2Code").value,
			FkPr2Naam:document.getElementById("InputFkPr2Naam").value
		},
		Ref: {
			FkPrdCode:document.getElementById("InputFkPrdCode").value,
			FkPrdNaam:document.getElementById("InputFkPrdNaam").value
		}
	};
	performTrans( {
		Service: "GetPa2ForPrdListEncapsulated",
		Parameters
	} );
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
<div><img src="icons/part_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('PART','Part2','PART2','_',-1)"> PART2</span></div>
<hr/>
<table>
<tr><td>Prod.Code</td><td><div style="max-width:8em;">
<input id="InputFkPrdCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Prod.Naam</td><td><div style="max-width:40em;">
<input id="InputFkPrdNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr><td>Prod2.Code</td><td><div style="max-width:8em;">
<input id="InputFkPr2Code" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Prod2.Naam</td><td><div style="max-width:40em;">
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
<tr><td>Part2.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkPa2Code" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
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
