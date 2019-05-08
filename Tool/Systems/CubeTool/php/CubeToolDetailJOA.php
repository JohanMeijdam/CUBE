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
					case "SELECT_JOA":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
						break;
					case "CREATE_JOA":
						document.getElementById("InputFkBotName").readOnly=true;
						document.getElementById("InputFkTypName").readOnly=true;
						document.getElementById("InputFkJsnName").readOnly=true;
						document.getElementById("InputFkJsnLocation").readOnly=true;
						document.getElementById("InputXfAtbTypName").readOnly=true;
						document.getElementById("InputXkAtbName").readOnly=true;
						document.getElementById("RefSelect001").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkTypName:document.getElementById("InputFkTypName").value,FkJsnName:document.getElementById("InputFkJsnName").value,FkJsnLocation:document.getElementById("InputFkJsnLocation").value,XfAtbTypName:document.getElementById("InputXfAtbTypName").value,XkAtbName:document.getElementById("InputXkAtbName").value};
						g_node_id = '{"TYP_JOA":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								var l_position = 'L';
								l_objNodePos = null;
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_JOA',
									l_json_node_id,
									'icons/atb_ref.bmp', 
									document.getElementById("InputXfAtbTypName").value.toLowerCase()+' '+document.getElementById("InputXkAtbName").value.toLowerCase(),
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_JOA":
						break;
					case "DELETE_JOA":
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
					case "LIST_ATB":
						OpenListBox(l_json_array[i].Rows,'attrib','Attribute','Y');
						break;
					case "SELECT_FKEY_JSN":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputFkBotName").value=l_json_values.FkBotName;
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
	g_xmlhttp.open('POST','CubeToolServer.php',true);
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
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_JOA.FkTypName;
		document.getElementById("InputFkJsnName").value=l_json_objectKey.TYP_JOA.FkJsnName;
		document.getElementById("InputFkJsnLocation").value=l_json_objectKey.TYP_JOA.FkJsnLocation;
		document.getElementById("InputXfAtbTypName").value=l_json_objectKey.TYP_JOA.XfAtbTypName;
		document.getElementById("InputXkAtbName").value=l_json_objectKey.TYP_JOA.XkAtbName;
		document.getElementById("ButtonCreate").disabled=true;
		performTrans( {
			Service: "GetJoa",
			Parameters: {
				Type: l_json_objectKey.TYP_JOA
			}
		} );
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("InputFkBotName").readOnly=true;
		document.getElementById("InputFkTypName").readOnly=true;
		document.getElementById("InputFkJsnName").readOnly=true;
		document.getElementById("InputFkJsnLocation").readOnly=true;
		document.getElementById("InputXfAtbTypName").readOnly=true;
		document.getElementById("InputXkAtbName").readOnly=true;
		document.getElementById("RefSelect001").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkTypName").value=l_json_objectKey.TYP_JSN.FkTypName;
		document.getElementById("InputFkJsnName").value=l_json_objectKey.TYP_JSN.Name;
		document.getElementById("InputFkJsnLocation").value=l_json_objectKey.TYP_JSN.Location;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		performTrans( {
			Service: "GetJsnFkey",
			Parameters: {
				Type: l_json_objectKey.TYP_JSN
			}
		} );
		document.getElementById("InputFkBotName").readOnly=true;
		document.getElementById("InputFkTypName").readOnly=true;
		document.getElementById("InputFkJsnName").readOnly=true;
		document.getElementById("InputFkJsnLocation").readOnly=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateJoa() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkJsnName: document.getElementById("InputFkJsnName").value,
		FkJsnLocation: document.getElementById("InputFkJsnLocation").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value
	};
	performTrans( {
		Service: "CreateJoa",
		Parameters: {
			Type
		}
	} );
}

function UpdateJoa() {
	var Type = {
		FkBotName: document.getElementById("InputFkBotName").value,
		FkTypName: document.getElementById("InputFkTypName").value,
		FkJsnName: document.getElementById("InputFkJsnName").value,
		FkJsnLocation: document.getElementById("InputFkJsnLocation").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value
	};
	performTrans( {
		Service: "UpdateJoa",
		Parameters: {
			Type
		}
	} );
}

function DeleteJoa() {
	var Type = {
		FkTypName: document.getElementById("InputFkTypName").value,
		FkJsnName: document.getElementById("InputFkJsnName").value,
		FkJsnLocation: document.getElementById("InputFkJsnLocation").value,
		XfAtbTypName: document.getElementById("InputXfAtbTypName").value,
		XkAtbName: document.getElementById("InputXkAtbName").value
	};
	performTrans( {
		Service: "DeleteJoa",
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
			document.getElementById("InputXfAtbTypName").value = '';
		} else {
			document.getElementById("InputXfAtbTypName").value = l_json_values.FkTypName;
		}
		if (l_values == '') {
			document.getElementById("InputXkAtbName").value = '';
		} else {
			document.getElementById("InputXkAtbName").value = l_json_values.Name;
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
		Option: {
			CubeScopeLevel:0
		},
		Type: {
			FkTypName:document.getElementById("InputFkTypName").value
		}
	};
	performTrans( {
		Service: "GetAtbForTypList",
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
<div><img src="icons/atb_ref_large.bmp" /><span> JSON_OBJECT_ATTRIBUTE</span></div>
<hr/>
<table>
<tr><td>BusinessObjectType.Name</td><td><div style="max-width:30em;">
<input id="InputFkBotName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>Type.Name</u></td><td><div style="max-width:30em;">
<input id="InputFkTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td><u>JsonObject.Name</u></td><td><div style="max-width:32em;">
<input id="InputFkJsnName" type="text" maxlength="32" style="width:100%;"></input></div></td></tr>
<tr><td><u>JsonObject.Location</u></td><td><div style="max-width:9em;">
<input id="InputFkJsnLocation" type="text" maxlength="9" style="width:100%;"></input></div></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/attrib.bmp"/> Attribute (Concerns)</legend>
<table style="width:100%;">
<tr><td><u>Type.Name</u></td><td style="width:100%;"><div style="max-width:30em;">
<input id="InputXfAtbTypName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td><u>Attribute.Name</u></td><td style="width:100%;"><div style="max-width:30em;">
<input id="InputXkAtbName" type="text" maxlength="30" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" readonly></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateJoa()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateJoa()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteJoa()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
