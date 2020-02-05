<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeInclude.js"></script>
<script language="javascript" type="text/javascript" src="..\CubeGeneral\CubeDetailInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeTestInclude.js"></script>
<script language="javascript" type="text/javascript" src="CubeTestDetailInclude.js"></script>
<script language="javascript" type="text/javascript">
<!--
var g_option = null;
var g_json_option = null;
var g_parent_node_id = null;
var g_node_id = null;

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
					case "SELECT_ORR":
						var l_json_values = l_json_array[i].Rows[0].Data;
						document.getElementById("InputProduktPrijs").value=l_json_values.ProduktPrijs;
						document.getElementById("InputAantal").value=l_json_values.Aantal;
						document.getElementById("InputTotaalPrijs").value=l_json_values.TotaalPrijs;
						document.getElementById("InputXkPrdCubeTsgType").value=l_json_values.XkPrdCubeTsgType;
						document.getElementById("InputXkPrdCode").value=l_json_values.XkPrdCode;
						break;
					case "CREATE_ORR":
						document.getElementById("InputFkOrdCode").disabled=true;
						document.getElementById("ButtonCreate").disabled=true;
						document.getElementById("ButtonUpdate").disabled=false;
						document.getElementById("ButtonDelete").disabled=false;
						var l_objNode = parent.document.getElementById(g_parent_node_id);
						var l_json_node_id = {FkOrdCode:document.getElementById("InputFkOrdCode").value};
						g_node_id = '{"TYP_ORR":'+JSON.stringify(l_json_node_id)+'}';
						if (l_objNode != null) {
							if (l_objNode.firstChild._state == 'O') {
								if (l_json_array[i].Rows.length == 0) {
									var l_position = 'L';
									l_objNodePos = null;
								} else {
									var l_position = 'B';
									var l_objNodePos = parent.document.getElementById('{"TYP_ORR":'+JSON.stringify(l_json_array[i].Rows[0].Key)+'}');
								}
								parent.AddTreeviewNode(
									l_objNode,
									'TYP_ORR',
									l_json_node_id,
									'icons/ordprod.bmp', 
									'('+document.getElementById("InputTotaalPrijs").value.toLowerCase()+')',
									'N',
									l_position,
									l_objNodePos);
							}
						}
						break;
					case "UPDATE_ORR":
						var l_objNode = parent.document.getElementById(g_node_id);
						if (l_objNode != null) {
							l_objNode.children[1].lastChild.nodeValue = ' '+'('+document.getElementById("InputTotaalPrijs").value.toLowerCase()+')';
					}
						break;
					case "DELETE_ORR":
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
					case "LIST_PRD":
						OpenListBox(l_json_array[i].Rows,'produkt','Produkt','Y');
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

function InitBody() {
	var l_json_argument = JSON.parse(decodeURIComponent(location.href.split("?")[1]));
	document.body._FlagDragging = 0;
	document.body._DraggingId = ' ';
	document.body._ListBoxCode="Ref000";
	var l_json_objectKey = l_json_argument.objectId;
	switch (l_json_argument.nodeType) {
	case "D":
		g_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkOrdCode").value=l_json_objectKey.TYP_ORR.FkOrdCode;
		document.getElementById("ButtonCreate").disabled=true;
		PerformTrans( {
			Service: "GetOrr",
			Parameters: {
				Type: l_json_objectKey.TYP_ORR
			}
		} );
		document.getElementById("InputFkOrdCode").disabled=true;
		break;
	case "N":
		g_parent_node_id = JSON.stringify(l_json_argument.objectId);
		document.getElementById("InputFkOrdCode").value=l_json_objectKey.TYP_ORD.Code;
		document.getElementById("ButtonUpdate").disabled=true;
		document.getElementById("ButtonDelete").disabled=true;
		document.getElementById("InputFkOrdCode").disabled=true;
		break;
	default:
		alert ('Error InitBody: '+l_argument[1]);
	}
}

function CreateOrr() {
	var Type = {
		FkOrdCode: document.getElementById("InputFkOrdCode").value,
		ProduktPrijs: document.getElementById("InputProduktPrijs").value,
		Aantal: document.getElementById("InputAantal").value,
		TotaalPrijs: document.getElementById("InputTotaalPrijs").value,
		XkPrdCubeTsgType: document.getElementById("InputXkPrdCubeTsgType").value,
		XkPrdCode: document.getElementById("InputXkPrdCode").value
	};
	PerformTrans( {
		Service: "CreateOrr",
		Parameters: {
			Type
		}
	} );
}

function UpdateOrr() {
	var Type = {
		FkOrdCode: document.getElementById("InputFkOrdCode").value,
		ProduktPrijs: document.getElementById("InputProduktPrijs").value,
		Aantal: document.getElementById("InputAantal").value,
		TotaalPrijs: document.getElementById("InputTotaalPrijs").value,
		XkPrdCubeTsgType: document.getElementById("InputXkPrdCubeTsgType").value,
		XkPrdCode: document.getElementById("InputXkPrdCode").value
	};
	PerformTrans( {
		Service: "UpdateOrr",
		Parameters: {
			Type
		}
	} );
}

function DeleteOrr() {
	var Type = {
		FkOrdCode: document.getElementById("InputFkOrdCode").value
	};
	PerformTrans( {
		Service: "DeleteOrr",
		Parameters: {
			Type
		}
	} );
}

function UpdateForeignKey(p_obj) {
	var l_values = p_obj.options[p_obj.selectedIndex].value;
	if (l_values != '') {
		var l_json_values = JSON.parse(l_values);
	}
	switch (document.body._ListBoxCode){
	case "Ref001":
		if (l_values == '') {
			document.getElementById("InputXkPrdCubeTsgType").value = '';
		} else {
			document.getElementById("InputXkPrdCubeTsgType").value = l_json_values.CubeTsgType;
		}
		if (l_values == '') {
			document.getElementById("InputXkPrdCode").value = '';
		} else {
			document.getElementById("InputXkPrdCode").value = l_json_values.Code;
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
	PerformTrans( {
		Service: "GetPrdList"
	} );
}
-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" ondrop="drop(event)" ondragover="allowDrop(event)">
<div><img src="icons/ordprod_large.bmp" /><span> ORDER_REGEL</span></div>
<hr/>
<table>
<tr><td><u>Order.Code</u></td><td><div style="max-width:8em;">
<input id="InputFkOrdCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>ProduktPrijs</td><td><div style="max-width:9em;">
<input id="InputProduktPrijs" type="text" maxlength="9" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>Aantal</td><td><div style="max-width:9em;">
<input id="InputAantal" type="text" maxlength="9" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td>TotaalPrijs</td><td><div style="max-width:9em;">
<input id="InputTotaalPrijs" type="text" maxlength="9" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);"></input></div></td></tr>
<tr><td height=6></td></tr><tr><td colspan=2><fieldset><legend><img style="border:1 solid transparent;" src="icons/produkt.bmp"/> Produkt (Betreft)</legend>
<table style="width:100%;">
<tr><td>Produkt.Type</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkPrdCubeTsgType" type="text" maxlength="8" style="width:100%;" onchange="ReplaceSpaces(this);" disabled></input></div></td>
<td><button id="RefSelect001" type="button" onclick="StartSelect001(event)">Select</button></td></tr>
<tr><td>Produkt.Code</td><td style="width:100%;"><div style="max-width:8em;">
<input id="InputXkPrdCode" type="text" maxlength="8" style="width:100%;" onchange="ToUpperCase(this);ReplaceSpaces(this);" disabled></input></div></td></tr>
</table></fieldset></td></tr>
<tr><td><br></td><td style="width:100%;"></td></tr>
<tr><td/><td>
<button id="ButtonCreate" type="button" onclick="CreateOrr()">Create</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonUpdate" type="button" onclick="UpdateOrr()">Update</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonDelete" type="button" onclick="DeleteOrr()">Delete</button></td></tr>
</table>
<input id="InputCubeId" type="hidden"></input>
</body>
</html>
