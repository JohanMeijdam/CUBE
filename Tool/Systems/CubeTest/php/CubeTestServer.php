<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);

switch ($RequestObj->Service) {

case 'GetDirAaaItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_AAA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetAaaListAll':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa_list_all (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_AAA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetAaa':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa (
		:p_cube_row,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_AAA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkAaaNaam = $row["FK_AAA_NAAM"];
		$RowObj->Data->Omschrijving = $row["OMSCHRIJVING"];
		$RowObj->Data->XkAaaNaam = $row["XK_AAA_NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetAaaItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa_aad_items (
		:p_cube_row,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_AAD';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkAaaNaam = $row["FK_AAA_NAAM"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aaa_aaa_items (
		:p_cube_row,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_AAA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'ChangeParentAaa':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.change_parent_aaa (
		:p_cube_flag_root,
		:p_naam,
		:x_naam,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_cube_flag_root",$RequestObj->Parameters->Option->CubeFlagRoot);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":x_naam",$RequestObj->Parameters->Ref->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CHANGE_PARENT_AAA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Naam = $row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateAaa':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.insert_aaa (
		:p_fk_aaa_naam,
		:p_naam,
		:p_omschrijving,
		:p_xk_aaa_naam,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$RequestObj->Parameters->Type->FkAaaNaam);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_AAA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Naam = $row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdateAaa':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.update_aaa (
		:p_fk_aaa_naam,
		:p_naam,
		:p_omschrijving,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$RequestObj->Parameters->Type->FkAaaNaam);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_AAA';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'DeleteAaa':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.delete_aaa (
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_AAA';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetAad':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.get_aad (
		:p_cube_row,
		:p_fk_aaa_naam,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$RequestObj->Parameters->Type->FkAaaNaam);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_AAD';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->XkAaaNaam = $row["XK_AAA_NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'MoveAad':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.move_aad (
		:p_cube_pos_action,
		:p_fk_aaa_naam,
		:p_naam,
		:x_fk_aaa_naam,
		:x_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_aaa_naam",$RequestObj->Parameters->Type->FkAaaNaam);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":x_fk_aaa_naam",$RequestObj->Parameters->Ref->FkAaaNaam);
	oci_bind_by_name($stid,":x_naam",$RequestObj->Parameters->Ref->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_AAD';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateAad':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.insert_aad (
		:p_cube_pos_action,
		:p_fk_aaa_naam,
		:p_naam,
		:p_xk_aaa_naam,
		:x_fk_aaa_naam,
		:x_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_aaa_naam",$RequestObj->Parameters->Type->FkAaaNaam);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);
	oci_bind_by_name($stid,":x_fk_aaa_naam",$RequestObj->Parameters->Ref->FkAaaNaam);
	oci_bind_by_name($stid,":x_naam",$RequestObj->Parameters->Ref->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_AAD';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdateAad':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.update_aad (
		:p_fk_aaa_naam,
		:p_naam,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$RequestObj->Parameters->Type->FkAaaNaam);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_AAD';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'DeleteAad':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_aaa.delete_aad (
		:p_fk_aaa_naam,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_aaa_naam",$RequestObj->Parameters->Type->FkAaaNaam);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_AAD';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetDirBbbItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bbb.get_bbb_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_BBB';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetBbbList':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bbb.get_bbb_list (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_BBB';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetBbb':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bbb.get_bbb (
		:p_cube_row,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_BBB';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->Omschrijving = $row["OMSCHRIJVING"];
		$RowObj->Data->XkAaaNaam = $row["XK_AAA_NAAM"];
		$RowObj->Data->XkBbbNaam1 = $row["XK_BBB_NAAM_1"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateBbb':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bbb.insert_bbb (
		:p_naam,
		:p_omschrijving,
		:p_xk_aaa_naam,
		:p_xk_bbb_naam_1);
	END;");
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);
	oci_bind_by_name($stid,":p_xk_bbb_naam_1",$RequestObj->Parameters->Type->XkBbbNaam1);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_BBB';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdateBbb':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bbb.update_bbb (
		:p_naam,
		:p_omschrijving,
		:p_xk_aaa_naam,
		:p_xk_bbb_naam_1);
	END;");
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);
	oci_bind_by_name($stid,":p_xk_bbb_naam_1",$RequestObj->Parameters->Type->XkBbbNaam1);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_BBB';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'DeleteBbb':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bbb.delete_bbb (
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_BBB';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetDirCccItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ccc.get_ccc_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_CCC';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["CODE"].' '.$row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetCccListAll':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ccc.get_ccc_list_all (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_CCC';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["CODE"].' '.$row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CountCcc':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ccc.count_ccc (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_CCC';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->TypeCount = $row["TYPE_COUNT"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetCcc':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ccc.get_ccc (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_CCC';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkCccCode = $row["FK_CCC_CODE"];
		$RowObj->Data->FkCccNaam = $row["FK_CCC_NAAM"];
		$RowObj->Data->Omschrjving = $row["OMSCHRJVING"];
		$RowObj->Data->XkCccCode = $row["XK_CCC_CODE"];
		$RowObj->Data->XkCccNaam = $row["XK_CCC_NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetCccItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ccc.get_ccc_ccc_items (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_CCC';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["CODE"].' '.$row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CountCccRestrictedItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ccc.count_ccc_ccc (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_CCC';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->TypeCount = $row["TYPE_COUNT"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'MoveCcc':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ccc.move_ccc (
		:p_cube_pos_action,
		:p_code,
		:p_naam,
		:x_code,
		:x_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);
	oci_bind_by_name($stid,":x_naam",$RequestObj->Parameters->Ref->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_CCC';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateCcc':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ccc.insert_ccc (
		:p_cube_pos_action,
		:p_fk_ccc_code,
		:p_fk_ccc_naam,
		:p_code,
		:p_naam,
		:p_omschrjving,
		:p_xk_ccc_code,
		:p_xk_ccc_naam,
		:x_code,
		:x_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_ccc_code",$RequestObj->Parameters->Type->FkCccCode);
	oci_bind_by_name($stid,":p_fk_ccc_naam",$RequestObj->Parameters->Type->FkCccNaam);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrjving",$RequestObj->Parameters->Type->Omschrjving);
	oci_bind_by_name($stid,":p_xk_ccc_code",$RequestObj->Parameters->Type->XkCccCode);
	oci_bind_by_name($stid,":p_xk_ccc_naam",$RequestObj->Parameters->Type->XkCccNaam);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);
	oci_bind_by_name($stid,":x_naam",$RequestObj->Parameters->Ref->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_CCC';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdateCcc':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ccc.update_ccc (
		:p_fk_ccc_code,
		:p_fk_ccc_naam,
		:p_code,
		:p_naam,
		:p_omschrjving,
		:p_xk_ccc_code,
		:p_xk_ccc_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_ccc_code",$RequestObj->Parameters->Type->FkCccCode);
	oci_bind_by_name($stid,":p_fk_ccc_naam",$RequestObj->Parameters->Type->FkCccNaam);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrjving",$RequestObj->Parameters->Type->Omschrjving);
	oci_bind_by_name($stid,":p_xk_ccc_code",$RequestObj->Parameters->Type->XkCccCode);
	oci_bind_by_name($stid,":p_xk_ccc_naam",$RequestObj->Parameters->Type->XkCccNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_CCC';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'DeleteCcc':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ccc.delete_ccc (
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_CCC';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetDirPrdItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_PRD';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Key->Nummer = $row["NUMMER"];
		$RowObj->Key->XkAaaNaam = $row["XK_AAA_NAAM"];
		$RowObj->Display = $row["CUBE_TSG_ZZZ"].' '.$row["CUBE_TSG_YYY"].' '.$row["CODE"].' '.$row["NAAM"].' '.$row["NUMMER"].' '.$row["OMSCHRIJVING"].' '.$row["XK_AAA_NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd (
		:p_cube_row,
		:p_code,
		:p_naam,
		:p_nummer,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_PRD';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->CubeTsgZzz = $row["CUBE_TSG_ZZZ"];
		$RowObj->Data->CubeTsgYyy = $row["CUBE_TSG_YYY"];
		$RowObj->Data->Datum = $row["DATUM"];
		$RowObj->Data->Omschrijving = $row["OMSCHRIJVING"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPrdItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd_pr2_items (
		:p_cube_row,
		:p_code,
		:p_naam,
		:p_nummer,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_PR2';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["CODE"].' '.$row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd_prt_items (
		:p_cube_row,
		:p_code,
		:p_naam,
		:p_nummer,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_PRT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["CODE"].' '.$row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreatePrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_prd (
		:p_cube_tsg_zzz,
		:p_cube_tsg_yyy,
		:p_code,
		:p_naam,
		:p_nummer,
		:p_datum,
		:p_omschrijving,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_zzz",$RequestObj->Parameters->Type->CubeTsgZzz);
	oci_bind_by_name($stid,":p_cube_tsg_yyy",$RequestObj->Parameters->Type->CubeTsgYyy);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);
	oci_bind_by_name($stid,":p_datum",$RequestObj->Parameters->Type->Datum);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_PRD';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdatePrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_prd (
		:p_cube_tsg_zzz,
		:p_cube_tsg_yyy,
		:p_code,
		:p_naam,
		:p_nummer,
		:p_datum,
		:p_omschrijving,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_zzz",$RequestObj->Parameters->Type->CubeTsgZzz);
	oci_bind_by_name($stid,":p_cube_tsg_yyy",$RequestObj->Parameters->Type->CubeTsgYyy);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);
	oci_bind_by_name($stid,":p_datum",$RequestObj->Parameters->Type->Datum);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_PRD';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'DeletePrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_prd (
		:p_code,
		:p_naam,
		:p_nummer,
		:p_xk_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_PRD';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPr2':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pr2 (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_PR2';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Data->FkPrdNaam = $row["FK_PRD_NAAM"];
		$RowObj->Data->FkPrdNummer = $row["FK_PRD_NUMMER"];
		$RowObj->Data->FkPrdAaaNaam = $row["FK_PRD_AAA_NAAM"];
		$RowObj->Data->Omschrijving = $row["OMSCHRIJVING"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPr2Fkey':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pr2_fkey (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_FKEY_PR2';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Data->FkPrdNaam = $row["FK_PRD_NAAM"];
		$RowObj->Data->FkPrdNummer = $row["FK_PRD_NUMMER"];
		$RowObj->Data->FkPrdAaaNaam = $row["FK_PRD_AAA_NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPr2Items':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pr2_pa2_items (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_PA2';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["CODE"].' '.$row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreatePr2':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_pr2 (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_prd_nummer,
		:p_fk_prd_aaa_naam,
		:p_code,
		:p_naam,
		:p_omschrijving);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_prd_naam",$RequestObj->Parameters->Type->FkPrdNaam);
	oci_bind_by_name($stid,":p_fk_prd_nummer",$RequestObj->Parameters->Type->FkPrdNummer);
	oci_bind_by_name($stid,":p_fk_prd_aaa_naam",$RequestObj->Parameters->Type->FkPrdAaaNaam);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_PR2';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdatePr2':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_pr2 (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_prd_nummer,
		:p_fk_prd_aaa_naam,
		:p_code,
		:p_naam,
		:p_omschrijving);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_prd_naam",$RequestObj->Parameters->Type->FkPrdNaam);
	oci_bind_by_name($stid,":p_fk_prd_nummer",$RequestObj->Parameters->Type->FkPrdNummer);
	oci_bind_by_name($stid,":p_fk_prd_aaa_naam",$RequestObj->Parameters->Type->FkPrdAaaNaam);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_PR2';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'DeletePr2':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_pr2 (
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_PR2';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPa2ForPrdListEncapsulated':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pa2_for_prd_list_encapsulated (
		:p_cube_row,
		:p_code,
		:p_naam,
		:x_fk_prd_code,
		:x_fk_prd_naam,
		:x_fk_prd_nummer,
		:x_fk_prd_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":x_fk_prd_code",$RequestObj->Parameters->Ref->FkPrdCode);
	oci_bind_by_name($stid,":x_fk_prd_naam",$RequestObj->Parameters->Ref->FkPrdNaam);
	oci_bind_by_name($stid,":x_fk_prd_nummer",$RequestObj->Parameters->Ref->FkPrdNummer);
	oci_bind_by_name($stid,":x_fk_prd_aaa_naam",$RequestObj->Parameters->Ref->FkPrdAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_PA2';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["CODE"].' '.$row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPa2':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pa2 (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_PA2';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Data->FkPrdNaam = $row["FK_PRD_NAAM"];
		$RowObj->Data->FkPrdNummer = $row["FK_PRD_NUMMER"];
		$RowObj->Data->FkPrdAaaNaam = $row["FK_PRD_AAA_NAAM"];
		$RowObj->Data->FkPr2Code = $row["FK_PR2_CODE"];
		$RowObj->Data->FkPr2Naam = $row["FK_PR2_NAAM"];
		$RowObj->Data->FkPa2Code = $row["FK_PA2_CODE"];
		$RowObj->Data->FkPa2Naam = $row["FK_PA2_NAAM"];
		$RowObj->Data->Omschrijving = $row["OMSCHRIJVING"];
		$RowObj->Data->XkPa2Code = $row["XK_PA2_CODE"];
		$RowObj->Data->XkPa2Naam = $row["XK_PA2_NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPa2Fkey':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pa2_fkey (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_FKEY_PA2';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Data->FkPrdNaam = $row["FK_PRD_NAAM"];
		$RowObj->Data->FkPrdNummer = $row["FK_PRD_NUMMER"];
		$RowObj->Data->FkPrdAaaNaam = $row["FK_PRD_AAA_NAAM"];
		$RowObj->Data->FkPr2Code = $row["FK_PR2_CODE"];
		$RowObj->Data->FkPr2Naam = $row["FK_PR2_NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPa2Items':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_pa2_pa2_items (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_PA2';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["CODE"].' '.$row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'ChangeParentPa2':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.change_parent_pa2 (
		:p_cube_flag_root,
		:p_code,
		:p_naam,
		:x_code,
		:x_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_flag_root",$RequestObj->Parameters->Option->CubeFlagRoot);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);
	oci_bind_by_name($stid,":x_naam",$RequestObj->Parameters->Ref->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CHANGE_PARENT_PA2';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreatePa2':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_pa2 (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_prd_nummer,
		:p_fk_prd_aaa_naam,
		:p_fk_pr2_code,
		:p_fk_pr2_naam,
		:p_fk_pa2_code,
		:p_fk_pa2_naam,
		:p_code,
		:p_naam,
		:p_omschrijving,
		:p_xk_pa2_code,
		:p_xk_pa2_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_prd_naam",$RequestObj->Parameters->Type->FkPrdNaam);
	oci_bind_by_name($stid,":p_fk_prd_nummer",$RequestObj->Parameters->Type->FkPrdNummer);
	oci_bind_by_name($stid,":p_fk_prd_aaa_naam",$RequestObj->Parameters->Type->FkPrdAaaNaam);
	oci_bind_by_name($stid,":p_fk_pr2_code",$RequestObj->Parameters->Type->FkPr2Code);
	oci_bind_by_name($stid,":p_fk_pr2_naam",$RequestObj->Parameters->Type->FkPr2Naam);
	oci_bind_by_name($stid,":p_fk_pa2_code",$RequestObj->Parameters->Type->FkPa2Code);
	oci_bind_by_name($stid,":p_fk_pa2_naam",$RequestObj->Parameters->Type->FkPa2Naam);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_pa2_code",$RequestObj->Parameters->Type->XkPa2Code);
	oci_bind_by_name($stid,":p_xk_pa2_naam",$RequestObj->Parameters->Type->XkPa2Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_PA2';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdatePa2':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_pa2 (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_prd_nummer,
		:p_fk_prd_aaa_naam,
		:p_fk_pr2_code,
		:p_fk_pr2_naam,
		:p_fk_pa2_code,
		:p_fk_pa2_naam,
		:p_code,
		:p_naam,
		:p_omschrijving,
		:p_xk_pa2_code,
		:p_xk_pa2_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_prd_naam",$RequestObj->Parameters->Type->FkPrdNaam);
	oci_bind_by_name($stid,":p_fk_prd_nummer",$RequestObj->Parameters->Type->FkPrdNummer);
	oci_bind_by_name($stid,":p_fk_prd_aaa_naam",$RequestObj->Parameters->Type->FkPrdAaaNaam);
	oci_bind_by_name($stid,":p_fk_pr2_code",$RequestObj->Parameters->Type->FkPr2Code);
	oci_bind_by_name($stid,":p_fk_pr2_naam",$RequestObj->Parameters->Type->FkPr2Naam);
	oci_bind_by_name($stid,":p_fk_pa2_code",$RequestObj->Parameters->Type->FkPa2Code);
	oci_bind_by_name($stid,":p_fk_pa2_naam",$RequestObj->Parameters->Type->FkPa2Naam);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_pa2_code",$RequestObj->Parameters->Type->XkPa2Code);
	oci_bind_by_name($stid,":p_xk_pa2_naam",$RequestObj->Parameters->Type->XkPa2Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_PA2';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'DeletePa2':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_pa2 (
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_PA2';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPrtForPrdListEncapsulated':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prt_for_prd_list_encapsulated (
		:p_cube_row,
		:p_code,
		:p_naam,
		:p_nummer,
		:p_xk_aaa_naam,
		:x_fk_prd_code,
		:x_fk_prd_naam,
		:x_fk_prd_nummer,
		:x_fk_prd_aaa_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);
	oci_bind_by_name($stid,":p_xk_aaa_naam",$RequestObj->Parameters->Type->XkAaaNaam);
	oci_bind_by_name($stid,":x_fk_prd_code",$RequestObj->Parameters->Ref->FkPrdCode);
	oci_bind_by_name($stid,":x_fk_prd_naam",$RequestObj->Parameters->Ref->FkPrdNaam);
	oci_bind_by_name($stid,":x_fk_prd_nummer",$RequestObj->Parameters->Ref->FkPrdNummer);
	oci_bind_by_name($stid,":x_fk_prd_aaa_naam",$RequestObj->Parameters->Ref->FkPrdAaaNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_PRT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["CODE"].' '.$row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPrt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prt (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_PRT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Data->FkPrdNaam = $row["FK_PRD_NAAM"];
		$RowObj->Data->FkPrdNummer = $row["FK_PRD_NUMMER"];
		$RowObj->Data->FkPrdAaaNaam = $row["FK_PRD_AAA_NAAM"];
		$RowObj->Data->FkPrtCode = $row["FK_PRT_CODE"];
		$RowObj->Data->FkPrtNaam = $row["FK_PRT_NAAM"];
		$RowObj->Data->Omschrijving = $row["OMSCHRIJVING"];
		$RowObj->Data->XkPrtCode = $row["XK_PRT_CODE"];
		$RowObj->Data->XkPrtNaam = $row["XK_PRT_NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPrtFkey':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prt_fkey (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_FKEY_PRT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Data->FkPrdNaam = $row["FK_PRD_NAAM"];
		$RowObj->Data->FkPrdNummer = $row["FK_PRD_NUMMER"];
		$RowObj->Data->FkPrdAaaNaam = $row["FK_PRD_AAA_NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPrtItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prt_prt_items (
		:p_cube_row,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_PRT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Key->Naam = $row["NAAM"];
		$RowObj->Display = $row["CODE"].' '.$row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'ChangeParentPrt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.change_parent_prt (
		:p_cube_flag_root,
		:p_code,
		:p_naam,
		:x_code,
		:x_naam);
	END;");
	oci_bind_by_name($stid,":p_cube_flag_root",$RequestObj->Parameters->Option->CubeFlagRoot);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);
	oci_bind_by_name($stid,":x_naam",$RequestObj->Parameters->Ref->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CHANGE_PARENT_PRT';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreatePrt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_prt (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_prd_nummer,
		:p_fk_prd_aaa_naam,
		:p_fk_prt_code,
		:p_fk_prt_naam,
		:p_code,
		:p_naam,
		:p_omschrijving,
		:p_xk_prt_code,
		:p_xk_prt_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_prd_naam",$RequestObj->Parameters->Type->FkPrdNaam);
	oci_bind_by_name($stid,":p_fk_prd_nummer",$RequestObj->Parameters->Type->FkPrdNummer);
	oci_bind_by_name($stid,":p_fk_prd_aaa_naam",$RequestObj->Parameters->Type->FkPrdAaaNaam);
	oci_bind_by_name($stid,":p_fk_prt_code",$RequestObj->Parameters->Type->FkPrtCode);
	oci_bind_by_name($stid,":p_fk_prt_naam",$RequestObj->Parameters->Type->FkPrtNaam);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_prt_code",$RequestObj->Parameters->Type->XkPrtCode);
	oci_bind_by_name($stid,":p_xk_prt_naam",$RequestObj->Parameters->Type->XkPrtNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_PRT';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdatePrt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_prt (
		:p_fk_prd_code,
		:p_fk_prd_naam,
		:p_fk_prd_nummer,
		:p_fk_prd_aaa_naam,
		:p_fk_prt_code,
		:p_fk_prt_naam,
		:p_code,
		:p_naam,
		:p_omschrijving,
		:p_xk_prt_code,
		:p_xk_prt_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_prd_naam",$RequestObj->Parameters->Type->FkPrdNaam);
	oci_bind_by_name($stid,":p_fk_prd_nummer",$RequestObj->Parameters->Type->FkPrdNummer);
	oci_bind_by_name($stid,":p_fk_prd_aaa_naam",$RequestObj->Parameters->Type->FkPrdAaaNaam);
	oci_bind_by_name($stid,":p_fk_prt_code",$RequestObj->Parameters->Type->FkPrtCode);
	oci_bind_by_name($stid,":p_fk_prt_naam",$RequestObj->Parameters->Type->FkPrtNaam);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_prt_code",$RequestObj->Parameters->Type->XkPrtCode);
	oci_bind_by_name($stid,":p_xk_prt_naam",$RequestObj->Parameters->Type->XkPrtNaam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_PRT';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'DeletePrt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_prt (
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_PRT';
	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		echo ']';
		return;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

default:
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'ERROR';
	$ResponseObj->ErrorText = $RequestText;
	$ResponseText = json_encode($ResponseObj);
	echo '['.$ResponseText.']';
}

function perform_db_request() {

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
		ProcessDbError($curs);
		return false;
	}
	return true;
}

function ProcessDbError($stid) {

	$e = oci_error($stid);
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'ERROR';
	$ResponseObj->ErrorText = 'ORA-error: '.$e['code'].': '.$e['message'];
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
}

function CubeError($errno, $errstr) {
	if ($errno > 2) {
		$ResponseObj = new \stdClass();
		$ResponseObj->ResultName = 'ERROR';
		$ResponseObj->ErrorText = "[$errno] $errstr";
		$ResponseText = json_encode($ResponseObj);
		echo '['.$ResponseText.']';
		exit;
	}
}
?>