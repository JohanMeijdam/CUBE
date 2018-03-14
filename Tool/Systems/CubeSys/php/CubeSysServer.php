<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$import=explode("<|||>",file_get_contents('php://input'));
switch ($import[0]) {

case 'GetDirCubeDscItems':

	$stid = oci_parse($conn, "BEGIN pkg_cube_dsc.get_cube_dsc_root_items (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_CUBE_DSC";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["TYPE_NAME"]."<|>".$row["ATTRIBUTE_TYPE_NAME"]."<|>".$row["SEQUENCE"];
		echo "<||>".$row["TYPE_NAME"]." ".$row["ATTRIBUTE_TYPE_NAME"]." ".$row["SEQUENCE"];
	}
	break;

case 'GetCubeDsc':

	list($p_type_name, $p_attribute_type_name, $p_sequence) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_cube_dsc.get_cube_dsc (
		:p_cube_row,
		:p_type_name,
		:p_attribute_type_name,
		:p_sequence);
	END;");
	oci_bind_by_name($stid,":p_type_name",$p_type_name);
	oci_bind_by_name($stid,":p_attribute_type_name",$p_attribute_type_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_CUBE_DSC";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["VALUE"];
	}
	break;

case 'CreateCubeDsc':

	list($p_type_name, $p_attribute_type_name, $p_sequence, $p_value) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_cube_dsc.insert_cube_dsc (
		:p_type_name,
		:p_attribute_type_name,
		:p_sequence,
		:p_value);
	END;");
	oci_bind_by_name($stid,":p_type_name",$p_type_name);
	oci_bind_by_name($stid,":p_attribute_type_name",$p_attribute_type_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_value",$p_value);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_CUBE_DSC";
	break;

case 'UpdateCubeDsc':

	list($p_type_name, $p_attribute_type_name, $p_sequence, $p_value) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_cube_dsc.update_cube_dsc (
		:p_type_name,
		:p_attribute_type_name,
		:p_sequence,
		:p_value);
	END;");
	oci_bind_by_name($stid,":p_type_name",$p_type_name);
	oci_bind_by_name($stid,":p_attribute_type_name",$p_attribute_type_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_value",$p_value);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_CUBE_DSC";
	break;

case 'DeleteCubeDsc':

	list($p_type_name, $p_attribute_type_name, $p_sequence) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_cube_dsc.delete_cube_dsc (
		:p_type_name,
		:p_attribute_type_name,
		:p_sequence);
	END;");
	oci_bind_by_name($stid,":p_type_name",$p_type_name);
	oci_bind_by_name($stid,":p_attribute_type_name",$p_attribute_type_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_CUBE_DSC";
	break;

default:
	echo "ERROR<|||>";
	echo file_get_contents('php://input');
}

function perform_db_request()
{
	global $conn, $stid, $curs;

	$curs = oci_new_cursor($conn);
	oci_bind_by_name($stid,":p_cube_row",$curs,-1,OCI_B_CURSOR);
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return false;
	}
	//echo $r;
	$r = oci_execute($curs);
	if (!$r) {
		ProcessDbError($stid);
		return false;
	}
	return true;
}

function ProcessDbError($stid) {
	$e = oci_error($stid);
	echo "ERROR<|||>ORA-error: ".$e['code'].": ".$e['message'];
}

function CubeError($errno, $errstr) {
	if ($errno > 2) {
		echo "Error: [$errno] $errstr";   
	}
}
?>