<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$import=explode("<|||>",file_get_contents('php://input'));
switch ($import[0]) {

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