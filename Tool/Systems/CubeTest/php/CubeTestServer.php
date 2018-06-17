<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$import=explode("<|||>",file_get_contents('php://input'));
switch ($import[0]) {

case 'GetDirAaaItems':

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa_root_items (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_AAA";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAAM"];
		echo "<||>".$row["NAAM"];
	}
	break;

case 'GetAaaListAll':

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa_list_all (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_AAA";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAAM"];
		echo "<||>".$row["NAAM"];
	}
	break;

case 'GetAaaListEncapsulated':

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa_list_encapsulated (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_AAA";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAAM"];
		echo "<||>".$row["NAAM"];
	}
	break;

case 'GetAaa':

	list($p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa (
		:p_cube_row,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_AAA";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_AAA_NAAM"]."<|>".$row["OMSCHRIJVING"]."<|>".$row["XK_AAA_NAAM"];
	}
	break;

case 'GetAaaItems':

	list($p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa_aad_items (
		:p_cube_row,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_AAD";}
		echo "<|||>".$row["FK_AAA_NAAM"]."<|>".$row["NAAM"];
		echo "<||>".$row["NAAM"];
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa_aaa_items (
		:p_cube_row,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_AAA";}
		echo "<|||>".$row["NAAM"];
		echo "<||>".$row["NAAM"];
	}
	break;

case 'ChangeParentAaa':

	list($p_cube_flag_root, $p_naam, $x_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_aaa.change_parent_aaa (
		:p_cube_flag_root,
		:p_naam,
		:x_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_flag_root",$p_cube_flag_root);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":x_naam",$x_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CHANGE_PARENT_AAA";
	break;

case 'CreateAaa':

	list($p_fk_aaa_naam, $p_naam, $p_omschrijving, $p_xk_aaa_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_aaa.insert_aaa (
		:p_fk_aaa_naam,
		:p_naam,
		:p_omschrijving,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$p_fk_aaa_naam);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$p_xk_aaa_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_AAA";
	break;

case 'UpdateAaa':

	list($p_fk_aaa_naam, $p_naam, $p_omschrijving, $p_xk_aaa_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_aaa.update_aaa (
		:p_fk_aaa_naam,
		:p_naam,
		:p_omschrijving,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$p_fk_aaa_naam);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$p_xk_aaa_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_AAA";
	break;

case 'DeleteAaa':

	list($p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_aaa.delete_aaa (
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_AAA";
	break;

case 'GetAad':

	list($p_fk_aaa_naam, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aad (
		:p_cube_row,
		:p_fk_aaa_naam,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$p_fk_aaa_naam);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_AAD";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["XK_AAA_NAAM"];
	}
	break;

case 'CreateAad':

	list($p_fk_aaa_naam, $p_naam, $p_xk_aaa_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_aaa.insert_aad (
		:p_fk_aaa_naam,
		:p_naam,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$p_fk_aaa_naam);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$p_xk_aaa_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_AAD";
	break;

case 'UpdateAad':

	list($p_fk_aaa_naam, $p_naam, $p_xk_aaa_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_aaa.update_aad (
		:p_fk_aaa_naam,
		:p_naam,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$p_fk_aaa_naam);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$p_xk_aaa_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_AAD";
	break;

case 'DeleteAad':

	list($p_fk_aaa_naam, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_aaa.delete_aad (
		:p_fk_aaa_naam,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$p_fk_aaa_naam);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_AAD";
	break;

case 'GetDirBbbItems':

	$stid = oci_parse($conn, "BEGIN pkg_bbb.get_bbb_root_items (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_BBB";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAAM"];
		echo "<||>".$row["NAAM"];
	}
	break;

case 'GetBbbList':

	$stid = oci_parse($conn, "BEGIN pkg_bbb.get_bbb_list (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_BBB";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAAM"];
		echo "<||>".$row["NAAM"];
	}
	break;

case 'GetBbb':

	list($p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bbb.get_bbb (
		:p_cube_row,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_BBB";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["OMSCHRIJVING"]."<|>".$row["XK_AAA_NAAM"]."<|>".$row["XK_BBB_NAAM_1"];
	}
	break;

case 'CreateBbb':

	list($p_naam, $p_omschrijving, $p_xk_aaa_naam, $p_xk_bbb_naam_1) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bbb.insert_bbb (
		:p_naam,
		:p_omschrijving,
		:p_xk_aaa_naam,
		:p_xk_bbb_naam_1);
	END;");
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$p_xk_aaa_naam);
	oci_bind_by_name($stid,":p_xk_bbb_naam_1",$p_xk_bbb_naam_1);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_BBB";
	break;

case 'UpdateBbb':

	list($p_naam, $p_omschrijving, $p_xk_aaa_naam, $p_xk_bbb_naam_1) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bbb.update_bbb (
		:p_naam,
		:p_omschrijving,
		:p_xk_aaa_naam,
		:p_xk_bbb_naam_1);
	END;");
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$p_xk_aaa_naam);
	oci_bind_by_name($stid,":p_xk_bbb_naam_1",$p_xk_bbb_naam_1);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_BBB";
	break;

case 'DeleteBbb':

	list($p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bbb.delete_bbb (
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_BBB";
	break;

case 'GetDirCccItems':

	$stid = oci_parse($conn, "BEGIN pkg_ccc.get_ccc_root_items (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_CCC";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["CODE"]."<|>".$row["NAAM"];
		echo "<||>".$row["CODE"]." ".$row["NAAM"];
	}
	break;

case 'CountCcc':

	$stid = oci_parse($conn, "BEGIN pkg_ccc.count_ccc (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "COUNT_CCC";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["TYPE_COUNT"];
	}
	break;

case 'GetCcc':

	list($p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_ccc.get_ccc (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_CCC";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_CCC_CODE"]."<|>".$row["FK_CCC_NAAM"]."<|>".$row["OMSCHRJVING"];
	}
	break;

case 'GetCccItems':

	list($p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_ccc.get_ccc_ccc_items (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_CCC";}
		echo "<|||>".$row["CODE"]."<|>".$row["NAAM"];
		echo "<||>".$row["CODE"]." ".$row["NAAM"];
	}
	break;

case 'CountCccRestrictedItems':

	list($p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_ccc.count_ccc_ccc (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "COUNT_CCC";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["TYPE_COUNT"];
	}
	break;

case 'ChangeParentCcc':

	list($p_cube_flag_root, $p_code, $p_naam, $x_code, $x_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_ccc.change_parent_ccc (
		:p_cube_flag_root,
		:p_code,
		:p_naam,
		:x_code,
		:x_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_flag_root",$p_cube_flag_root);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":x_code",$x_code);
	oci_bind_by_name($stid,":x_naam",$x_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CHANGE_PARENT_CCC";
	break;

case 'CreateCcc':

	list($p_fk_ccc_code, $p_fk_ccc_naam, $p_code, $p_naam, $p_omschrjving) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_ccc.insert_ccc (
		:p_fk_ccc_code,
		:p_fk_ccc_naam,
		:p_code,
		:p_naam,
		:p_omschrjving);
	END;");
	oci_bind_by_name($stid,":p_fk_ccc_code",$p_fk_ccc_code);
	oci_bind_by_name($stid,":p_fk_ccc_naam",$p_fk_ccc_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrjving",$p_omschrjving);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_CCC";
	break;

case 'UpdateCcc':

	list($p_fk_ccc_code, $p_fk_ccc_naam, $p_code, $p_naam, $p_omschrjving) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_ccc.update_ccc (
		:p_fk_ccc_code,
		:p_fk_ccc_naam,
		:p_code,
		:p_naam,
		:p_omschrjving);
	END;");
	oci_bind_by_name($stid,":p_fk_ccc_code",$p_fk_ccc_code);
	oci_bind_by_name($stid,":p_fk_ccc_naam",$p_fk_ccc_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrjving",$p_omschrjving);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_CCC";
	break;

case 'DeleteCcc':

	list($p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_ccc.delete_ccc (
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_CCC";
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