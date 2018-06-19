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

case 'GetCccListEncapsulated':

	$stid = oci_parse($conn, "BEGIN pkg_ccc.get_ccc_list_encapsulated (:p_cube_row); END;");
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
		echo "<|||>".$row["FK_CCC_CODE"]."<|>".$row["FK_CCC_NAAM"]."<|>".$row["OMSCHRJVING"]."<|>".$row["XK_CCC_CODE"]."<|>".$row["XK_CCC_NAAM"];
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

	list($p_fk_ccc_code, $p_fk_ccc_naam, $p_code, $p_naam, $p_omschrjving, $p_xk_ccc_code, $p_xk_ccc_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_ccc.insert_ccc (
		:p_fk_ccc_code,
		:p_fk_ccc_naam,
		:p_code,
		:p_naam,
		:p_omschrjving,
		:p_xk_ccc_code,
		:p_xk_ccc_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_ccc_code",$p_fk_ccc_code);
	oci_bind_by_name($stid,":p_fk_ccc_naam",$p_fk_ccc_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrjving",$p_omschrjving);
	oci_bind_by_name($stid,":p_xk_ccc_code",$p_xk_ccc_code);
	oci_bind_by_name($stid,":p_xk_ccc_naam",$p_xk_ccc_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_CCC";
	break;

case 'UpdateCcc':

	list($p_fk_ccc_code, $p_fk_ccc_naam, $p_code, $p_naam, $p_omschrjving, $p_xk_ccc_code, $p_xk_ccc_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_ccc.update_ccc (
		:p_fk_ccc_code,
		:p_fk_ccc_naam,
		:p_code,
		:p_naam,
		:p_omschrjving,
		:p_xk_ccc_code,
		:p_xk_ccc_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_ccc_code",$p_fk_ccc_code);
	oci_bind_by_name($stid,":p_fk_ccc_naam",$p_fk_ccc_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrjving",$p_omschrjving);
	oci_bind_by_name($stid,":p_xk_ccc_code",$p_xk_ccc_code);
	oci_bind_by_name($stid,":p_xk_ccc_naam",$p_xk_ccc_naam);

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

case 'GetDirPrdItems':

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd_root_items (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_PRD";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["CODE"]."<|>".$row["NAAM"];
		echo "<||>".$row["CODE"]." ".$row["NAAM"];
	}
	break;

case 'GetPrd':

	list($p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_PRD";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["OMSCHRIJVING"];
	}
	break;

case 'GetPrdItems':

	list($p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd_pr2_items (
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
		if ($first) { $first = False; echo "LIST_PR2";}
		echo "<|||>".$row["FK_PRD_CODE"]."<|>".$row["FK_PRD_NAAM"]."<|>".$row["CODE"]."<|>".$row["NAAM"];
		echo "<||>".$row["CODE"]." ".$row["NAAM"];
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd_prt_items (
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
		if ($first) { $first = False; echo "LIST_PRT";}
		echo "<|||>".$row["FK_PRD_CODE"]."<|>".$row["FK_PRD_NAAM"]."<|>".$row["CODE"]."<|>".$row["NAAM"];
		echo "<||>".$row["CODE"]." ".$row["NAAM"];
	}
	break;

case 'CreatePrd':

	list($p_code, $p_naam, $p_omschrijving) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_prd (
		:p_code,
		:p_naam,
		:p_omschrijving);
	END;");
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_PRD";
	break;

case 'UpdatePrd':

	list($p_code, $p_naam, $p_omschrijving) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_prd (
		:p_code,
		:p_naam,
		:p_omschrijving);
	END;");
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_PRD";
	break;

case 'DeletePrd':

	list($p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_prd (
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
	echo "DELETE_PRD";
	break;

case 'GetPr2':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pr2 (
		:p_cube_row,
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_PR2";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["OMSCHRIJVING"];
	}
	break;

case 'GetPr2Items':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pr2_pa2_items (
		:p_cube_row,
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_PA2";}
		echo "<|||>".$row["FK_PRD_CODE"]."<|>".$row["FK_PRD_NAAM"]."<|>".$row["FK_PR2_CODE"]."<|>".$row["FK_PR2_NAAM"]."<|>".$row["CODE"]."<|>".$row["NAAM"];
		echo "<||>".$row["CODE"]." ".$row["NAAM"];
	}
	break;

case 'CreatePr2':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_code, $p_naam, $p_omschrijving) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_pr2 (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_code,
		:p_naam,
		:p_omschrijving);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_PR2";
	break;

case 'UpdatePr2':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_code, $p_naam, $p_omschrijving) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_pr2 (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_code,
		:p_naam,
		:p_omschrijving);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_PR2";
	break;

case 'DeletePr2':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_pr2 (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_PR2";
	break;

case 'GetPa2ListEncapsulated':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pa2_list_encapsulated (
		:p_cube_row,
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_PA2";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_PRD_CODE"]."<|>".$row["FK_PRD_NAAM"]."<|>".$row["FK_PR2_CODE"]."<|>".$row["FK_PR2_NAAM"]."<|>".$row["CODE"]."<|>".$row["NAAM"];
		echo "<||>".$row["FK_PRD_CODE"]." ".$row["FK_PRD_NAAM"]." ".$row["FK_PR2_CODE"]." ".$row["FK_PR2_NAAM"]." ".$row["CODE"]." ".$row["NAAM"];
	}
	break;

case 'GetPa2':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_fk_pr2_code, $p_fk_pr2_naam, $p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pa2 (
		:p_cube_row,
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_pr2_code,
		:p_fk_pr2_naam,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_fk_pr2_code",$p_fk_pr2_code);
	oci_bind_by_name($stid,":p_fk_pr2_naam",$p_fk_pr2_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_PA2";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_PA2_CODE"]."<|>".$row["FK_PA2_NAAM"]."<|>".$row["OMSCHRIJVING"]."<|>".$row["XF_PA2_PRD_CODE"]."<|>".$row["XF_PA2_PRD_NAAM"]."<|>".$row["XF_PA2_PR2_CODE"]."<|>".$row["XF_PA2_PR2_NAAM"]."<|>".$row["XK_PA2_CODE"]."<|>".$row["XK_PA2_NAAM"];
	}
	break;

case 'GetPa2Items':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_fk_pr2_code, $p_fk_pr2_naam, $p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pa2_pa2_items (
		:p_cube_row,
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_pr2_code,
		:p_fk_pr2_naam,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_fk_pr2_code",$p_fk_pr2_code);
	oci_bind_by_name($stid,":p_fk_pr2_naam",$p_fk_pr2_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_PA2";}
		echo "<|||>".$row["FK_PRD_CODE"]."<|>".$row["FK_PRD_NAAM"]."<|>".$row["FK_PR2_CODE"]."<|>".$row["FK_PR2_NAAM"]."<|>".$row["CODE"]."<|>".$row["NAAM"];
		echo "<||>".$row["CODE"]." ".$row["NAAM"];
	}
	break;

case 'ChangeParentPa2':

	list($p_cube_flag_root, $p_fk_prd_code, $p_fk_prd_naam, $p_fk_pr2_code, $p_fk_pr2_naam, $p_code, $p_naam, $x_fk_prd_code, $x_fk_prd_naam, $x_fk_pr2_code, $x_fk_pr2_naam, $x_code, $x_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.change_parent_pa2 (
		:p_cube_flag_root,
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_pr2_code,
		:p_fk_pr2_naam,
		:p_code,
		:p_naam,
		:x_fk_prd_code,
		:x_fk_prd_naam,
		:x_fk_pr2_code,
		:x_fk_pr2_naam,
		:x_code,
		:x_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_flag_root",$p_cube_flag_root);
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_fk_pr2_code",$p_fk_pr2_code);
	oci_bind_by_name($stid,":p_fk_pr2_naam",$p_fk_pr2_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":x_fk_prd_code",$x_fk_prd_code);
	oci_bind_by_name($stid,":x_fk_prd_naam",$x_fk_prd_naam);
	oci_bind_by_name($stid,":x_fk_pr2_code",$x_fk_pr2_code);
	oci_bind_by_name($stid,":x_fk_pr2_naam",$x_fk_pr2_naam);
	oci_bind_by_name($stid,":x_code",$x_code);
	oci_bind_by_name($stid,":x_naam",$x_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CHANGE_PARENT_PA2";
	break;

case 'CreatePa2':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_fk_pr2_code, $p_fk_pr2_naam, $p_fk_pa2_code, $p_fk_pa2_naam, $p_code, $p_naam, $p_omschrijving, $p_xf_pa2_prd_code, $p_xf_pa2_prd_naam, $p_xf_pa2_pr2_code, $p_xf_pa2_pr2_naam, $p_xk_pa2_code, $p_xk_pa2_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_pa2 (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_pr2_code,
		:p_fk_pr2_naam,
		:p_fk_pa2_code,
		:p_fk_pa2_naam,
		:p_code,
		:p_naam,
		:p_omschrijving,
		:p_xf_pa2_prd_code,
		:p_xf_pa2_prd_naam,
		:p_xf_pa2_pr2_code,
		:p_xf_pa2_pr2_naam,
		:p_xk_pa2_code,
		:p_xk_pa2_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_fk_pr2_code",$p_fk_pr2_code);
	oci_bind_by_name($stid,":p_fk_pr2_naam",$p_fk_pr2_naam);
	oci_bind_by_name($stid,":p_fk_pa2_code",$p_fk_pa2_code);
	oci_bind_by_name($stid,":p_fk_pa2_naam",$p_fk_pa2_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);
	oci_bind_by_name($stid,":p_xf_pa2_prd_code",$p_xf_pa2_prd_code);
	oci_bind_by_name($stid,":p_xf_pa2_prd_naam",$p_xf_pa2_prd_naam);
	oci_bind_by_name($stid,":p_xf_pa2_pr2_code",$p_xf_pa2_pr2_code);
	oci_bind_by_name($stid,":p_xf_pa2_pr2_naam",$p_xf_pa2_pr2_naam);
	oci_bind_by_name($stid,":p_xk_pa2_code",$p_xk_pa2_code);
	oci_bind_by_name($stid,":p_xk_pa2_naam",$p_xk_pa2_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_PA2";
	break;

case 'UpdatePa2':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_fk_pr2_code, $p_fk_pr2_naam, $p_fk_pa2_code, $p_fk_pa2_naam, $p_code, $p_naam, $p_omschrijving, $p_xf_pa2_prd_code, $p_xf_pa2_prd_naam, $p_xf_pa2_pr2_code, $p_xf_pa2_pr2_naam, $p_xk_pa2_code, $p_xk_pa2_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_pa2 (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_pr2_code,
		:p_fk_pr2_naam,
		:p_fk_pa2_code,
		:p_fk_pa2_naam,
		:p_code,
		:p_naam,
		:p_omschrijving,
		:p_xf_pa2_prd_code,
		:p_xf_pa2_prd_naam,
		:p_xf_pa2_pr2_code,
		:p_xf_pa2_pr2_naam,
		:p_xk_pa2_code,
		:p_xk_pa2_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_fk_pr2_code",$p_fk_pr2_code);
	oci_bind_by_name($stid,":p_fk_pr2_naam",$p_fk_pr2_naam);
	oci_bind_by_name($stid,":p_fk_pa2_code",$p_fk_pa2_code);
	oci_bind_by_name($stid,":p_fk_pa2_naam",$p_fk_pa2_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);
	oci_bind_by_name($stid,":p_xf_pa2_prd_code",$p_xf_pa2_prd_code);
	oci_bind_by_name($stid,":p_xf_pa2_prd_naam",$p_xf_pa2_prd_naam);
	oci_bind_by_name($stid,":p_xf_pa2_pr2_code",$p_xf_pa2_pr2_code);
	oci_bind_by_name($stid,":p_xf_pa2_pr2_naam",$p_xf_pa2_pr2_naam);
	oci_bind_by_name($stid,":p_xk_pa2_code",$p_xk_pa2_code);
	oci_bind_by_name($stid,":p_xk_pa2_naam",$p_xk_pa2_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_PA2";
	break;

case 'DeletePa2':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_fk_pr2_code, $p_fk_pr2_naam, $p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_pa2 (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_pr2_code,
		:p_fk_pr2_naam,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_fk_pr2_code",$p_fk_pr2_code);
	oci_bind_by_name($stid,":p_fk_pr2_naam",$p_fk_pr2_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_PA2";
	break;

case 'GetPrtForPrdListEncapsulated':

	list($p_code, $p_naam, $x_fk_prd_code, $x_fk_prd_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prt_for_prd_list_encapsulated (
		:p_cube_row,
		:p_code,
		:p_naam,
		:x_fk_prd_code,
		:x_fk_prd_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":x_fk_prd_code",$x_fk_prd_code);
	oci_bind_by_name($stid,":x_fk_prd_naam",$x_fk_prd_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_PRT";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_PRD_CODE"]."<|>".$row["FK_PRD_NAAM"]."<|>".$row["CODE"]."<|>".$row["NAAM"];
		echo "<||>".$row["FK_PRD_CODE"]." ".$row["FK_PRD_NAAM"]." ".$row["CODE"]." ".$row["NAAM"];
	}
	break;

case 'GetPrt':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prt (
		:p_cube_row,
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_PRT";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_PRT_CODE"]."<|>".$row["FK_PRT_NAAM"]."<|>".$row["OMSCHRIJVING"]."<|>".$row["XF_PRT_PRD_CODE"]."<|>".$row["XF_PRT_PRD_NAAM"]."<|>".$row["XK_PRT_CODE"]."<|>".$row["XK_PRT_NAAM"];
	}
	break;

case 'GetPrtItems':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prt_prt_items (
		:p_cube_row,
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_PRT";}
		echo "<|||>".$row["FK_PRD_CODE"]."<|>".$row["FK_PRD_NAAM"]."<|>".$row["CODE"]."<|>".$row["NAAM"];
		echo "<||>".$row["CODE"]." ".$row["NAAM"];
	}
	break;

case 'ChangeParentPrt':

	list($p_cube_flag_root, $p_fk_prd_code, $p_fk_prd_naam, $p_code, $p_naam, $x_fk_prd_code, $x_fk_prd_naam, $x_code, $x_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.change_parent_prt (
		:p_cube_flag_root,
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_code,
		:p_naam,
		:x_fk_prd_code,
		:x_fk_prd_naam,
		:x_code,
		:x_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_flag_root",$p_cube_flag_root);
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":x_fk_prd_code",$x_fk_prd_code);
	oci_bind_by_name($stid,":x_fk_prd_naam",$x_fk_prd_naam);
	oci_bind_by_name($stid,":x_code",$x_code);
	oci_bind_by_name($stid,":x_naam",$x_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CHANGE_PARENT_PRT";
	break;

case 'CreatePrt':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_fk_prt_code, $p_fk_prt_naam, $p_code, $p_naam, $p_omschrijving, $p_xf_prt_prd_code, $p_xf_prt_prd_naam, $p_xk_prt_code, $p_xk_prt_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_prt (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_prt_code,
		:p_fk_prt_naam,
		:p_code,
		:p_naam,
		:p_omschrijving,
		:p_xf_prt_prd_code,
		:p_xf_prt_prd_naam,
		:p_xk_prt_code,
		:p_xk_prt_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_fk_prt_code",$p_fk_prt_code);
	oci_bind_by_name($stid,":p_fk_prt_naam",$p_fk_prt_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);
	oci_bind_by_name($stid,":p_xf_prt_prd_code",$p_xf_prt_prd_code);
	oci_bind_by_name($stid,":p_xf_prt_prd_naam",$p_xf_prt_prd_naam);
	oci_bind_by_name($stid,":p_xk_prt_code",$p_xk_prt_code);
	oci_bind_by_name($stid,":p_xk_prt_naam",$p_xk_prt_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_PRT";
	break;

case 'UpdatePrt':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_fk_prt_code, $p_fk_prt_naam, $p_code, $p_naam, $p_omschrijving, $p_xf_prt_prd_code, $p_xf_prt_prd_naam, $p_xk_prt_code, $p_xk_prt_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_prt (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_prt_code,
		:p_fk_prt_naam,
		:p_code,
		:p_naam,
		:p_omschrijving,
		:p_xf_prt_prd_code,
		:p_xf_prt_prd_naam,
		:p_xk_prt_code,
		:p_xk_prt_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_fk_prt_code",$p_fk_prt_code);
	oci_bind_by_name($stid,":p_fk_prt_naam",$p_fk_prt_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);
	oci_bind_by_name($stid,":p_omschrijving",$p_omschrijving);
	oci_bind_by_name($stid,":p_xf_prt_prd_code",$p_xf_prt_prd_code);
	oci_bind_by_name($stid,":p_xf_prt_prd_naam",$p_xf_prt_prd_naam);
	oci_bind_by_name($stid,":p_xk_prt_code",$p_xk_prt_code);
	oci_bind_by_name($stid,":p_xk_prt_naam",$p_xk_prt_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_PRT";
	break;

case 'DeletePrt':

	list($p_fk_prd_code, $p_fk_prd_naam, $p_code, $p_naam) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_prt (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$p_fk_prd_code);
	oci_bind_by_name($stid,":p_fk_prd_naam",$p_fk_prd_naam);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_naam",$p_naam);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_PRT";
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