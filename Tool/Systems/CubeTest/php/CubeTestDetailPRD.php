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
					case "SELECT_PRD":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputCubeTsgZzz").value=l_json_values.CubeTsgZzz;
						document.getElementById("InputCubeTsgYyy").value=l_json_values.CubeTsgYyy;
						document.getElementById("InputDatum").value=l_json_values.Datum;
						document.getElementById("InputOmschrijving").value=l_json_values.Omschrijving;
						ProcessTypeSpecialisation();
						break;
					case "CREATE_PRD":
						document.getElementById("InputCode").readOnly=true;
						document.getElementById("InputNaam").readOnly=true;
						document.getElementById("InputNummer").readOnly=true;
						document.getElementById("InputXkAaaNaam").readOnly=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {Code:document.getElementById("InputCode").value,Naam:document.getElementById("InputNaam").value,Nummer:document.getElementById("InputNummer").value,XkAaaNaam:document.getElementById("InputXkAaaNaam").value};
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
									document.getElementById("InputCubeTsgZzz").value.toLowerCase()+' '+document.getElementById("InputCubeTsgYyy").value.toLowerCase()+' '+document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputNaam").value.toLowerCase()+' '+document.getElementById("InputNummer").value.toLowerCase()+' '+document.getElementById("InputOmschrijving").value.toLowerCase()+' '+document.getElementById("InputXkAaaNaam").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_PRD":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+document.getElementById("InputCubeTsgZzz").value.toLowerCase()+' '+document.getElementById("InputCubeTsgYyy").value.toLowerCase()+' '+document.getElementById("InputCode").value.toLowerCase()+' '+document.getElementById("InputNaam").value.toLowerCase()+' '+document.getElementById("InputNummer").value.toLowerCase()+' '+document.getElementById("InputOmschrijving").value.toLowerCase()+' '+document.getElementById("InputXkAaaNaam").value.toLowerCase();
					}
						break;
					case "DELETE_PRD":
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
					case "LIST_AAA":
						OpenListBox(l_json_array[i].Rows,'produkt','Aaa','N');
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
		document.getElementById("InputCode").value=l_json_objectKey.TYP_PRD.Code;
		document.getElementById("InputNaam").value=l_json_objectKey.TYP_PRD.Naam;
		document.getElementById("InputNummer").value=l_json_objectKey.TYP_PRD.Nummer;
		document.getElementById("InputXkAaaNaam").value=l_json_objectKey.TYP_PRD.XkAaaNaam;
		document.getElementById("ButtonCreate").disabled=true;
		performTrans( {
			Service: "GetPrd",
			Parameters: {
				Type: l_json_objectKey.TYP_PRD
			}
		} );
		document.getElementById("InputCubeTsgZzz").readOnly=true;
		document.getElementById("InputCubeTsgYyy").readOnly=true;
		document.getElementById("InputCode").readOnly=true;
		document.getElementById("InputNaam").readOnly=true;
		document.getElementById("InputNummer").readOnly=true;
		document.getElementById("InputXkAaaNaam").readOnly=true;
		document.getElementById("RefSelect001").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreatePrd() {
	var Type = {
		CubeTsgZzz: document.getElementById("InputCubeTsgZzz").value,
		CubeTsgYyy: document.getElementById("InputCubeTsgYyy").value,
		Code: document.getElementById("InputCode").value,
		Naam: document.getElementById("InputNaam").value,
		Nummer: document.getElementById("InputNummer").value,
		Datum: document.getElementById("InputDatum").value,
		Omschrijving: document.getElementById("InputOmschrijving").value,
		XkAaaNaam: document.getElementById("InputXkAaaNaam").value
	};
	performTrans( {
		Service: "CreatePrd",
		Parameters: {
			Type
		}
	} );
}

function UpdatePrd() {
	var Type = {
		CubeTsgZzz: document.getElementById("InputCubeTsgZzz").value,
		CubeTsgYyy: document.getElementById("InputCubeTsgYyy").value,
		Code: document.getElementById("InputCode").value,
		Naam: document.getElementById("InputNaam").value,
		Nummer: document.getElementById("InputNummer").value,
		Datum: document.getElementById("InputDatum").value,
		Omschrijving: document.getElementById("InputOmschrijving").value,
		XkAaaNaam: document.getElementById("InputXkAaaNaam").value
	};
	performTrans( {
		Service: "UpdatePrd",
		Parameters: {
			Type
		}
	} );
}

function DeletePrd() {
	var Type = {
		Code: document.getElementById("InputCode").value,
		Naam: document.getElementById("InputNaam").value,
		Nummer: document.getElementById("InputNummer").value,
		XkAaaNaam: document.getElementById("InputXkAaaNaam").value
	};
	performTrans( {
		Service: "DeletePrd",
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


		l_objSelect.size = Math.min(p_json_rows.length,16)
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
			document.getElementById("InputXkAaaNaam").value = '';
		} else {
			document.getElementById("InputXkAaaNaam").value = l_json_values.Naam;
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
	performTrans( {
		Service: "GetAaaListAll"
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

function ProcessTypeSpecialisation() {
	if (document.getElementById("InputCubeTsgZzz").value != ' ' && document.getElementById("InputCubeTsgYyy").value != ' ') {
		document.getElementById("InputCubeTsgZzz").disabled=true;
		document.getElementById("InputCubeTsgYyy").disabled=true;
		switch (document.getElementById("InputCubeTsgYyy").value) {
		case "RRR":
			document.getElementById("RowAtbNaam").style.display="none";
			document.getElementById("InputNaam").value=" ";
			break;
		case "SSS":
			document.getElementById("RowAtbNummer").style.display="none";
			document.getElementById("InputNummer").value="0";
			document.getElementById("InputXkAaaNaam").value=" ";
			document.getElementById("RowRefAaa0").style.display="none";
			break;
		}
		document.getElementById("TableMain").style.display="inline";
	}
}

function ResetFieldCubeTsgYyy(p_field_id) {
	document.getElementById("InputCubeTsgYyy").value=' ';
	switch (document.getElementById(p_field_id).value){
	case "QQQ":
		document.getElementById("ValCubeTsgYyy-RRR").style.display="inline";
		document.getElementById("ValCubeTsgYyy-SSS").style.display="inline";
		break;
	case "RRR":
		document.getElementById("ValCubeTsgYyy-RRR").style.display="none";
		document.getElementById("ValCubeTsgYyy-SSS").style.display="none";
		break;
	case "SSS":
		document.getElementById("ValCubeTsgYyy-RRR").style.display="none";
		document.getElementById("ValCubeTsgYyy-SSS").style.display="none";
		break;
	}
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/produkt_large.bmp" /><span style="cursor:help" oncontextmenu="parent.OpenDescBox('PRODUKT','Prod','PROD','_',-1)"> PROD /
<select id="InputCubeTsgZzz" type="text" onchange="ResetFieldCubeTsgYyy('InputCubeTsgZzz')">
	<option value=" " selected>&lt;zzz&gt;</option>
	<option value="QQQ">QQQ</option>
	<option value="RRR">RRR</option>
	<option value="SSS">SSS</option>
</select> <b>.</b>
<select id="InputCubeTsgYyy" type="text" onchange="ProcessTypeSpecialisation()">
	<option value=" " selected>&lt;yyy&gt;</option>
	<option id="ValCubeTsgYyy-RRR" style="display:none" value="RRR">RRR</option>
	<option id="ValCubeTsgYyy-SSS" style="display:none" value="SSS">SSS</option>
</select></span></div>
<hr/>
<table id="TableMain" style="display:none">
<tr><td><u>Code</u></td><td><div style="max-width:8em;">
<input id="InputCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr id="RowAtbNaam"><td><u>Naam</u></td><td><div style="max-width:40em;">
<input id="InputNaam" type="text" maxlength="40" style="width:100%;"></input></div></td></tr>
<tr id="RowAtbNummer"><td><u>Nummer</u></td><td><div style="max-width:9em;">
<input id="InputNummer" type="text" maxlength="9" style="width:100%;"></input></div></td></tr>
<tr><td>Datum</td><td><div style="max-width:12ch;">
<input id="InputDatum" type="text" maxlength="10" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Omschrijving</td><td><div style="max-width:120em;">
<input id="InputOmschrijving" type="text" maxlength="120" style="width:100%;"></input></div></td></tr>
<tr><td height=6></td></tr><tr id="RowRefAaa0"><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/produkt.bmp"/> Aaa (IsVoor)</legend>
<table style="width:100%;">
<tr><td><u>Aaa.Naam</u></td><td style="width:100%;"><div style="max-width:40em;">
<input id="InputXkAaaNaam" type="text" maxlength="40" style="width:100%;" readonly></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreatePrd()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdatePrd()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeletePrd()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
