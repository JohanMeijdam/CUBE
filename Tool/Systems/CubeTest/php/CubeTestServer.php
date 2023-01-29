<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);

switch ($RequestObj->Service) {

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
		$RowObj->Key->CubeTsgType = $row["CUBE_TSG_TYPE"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = '('.$row["CUBE_TSG_TYPE"].')'.' ('.$row["CUBE_TSG_SOORT"].')'.' ('.$row["CUBE_TSG_SOORT1"].')'.' '.$row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CountPrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.count_prd (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_PRD';
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

case 'GetPrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd (
		:p_cube_row,
		:p_cube_tsg_type,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

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
		$RowObj->Data->CubeTsgSoort = $row["CUBE_TSG_SOORT"];
		$RowObj->Data->CubeTsgSoort1 = $row["CUBE_TSG_SOORT1"];
		$RowObj->Data->Prijs = $row["PRIJS"];
		$RowObj->Data->MakelaarNaam = $row["MAKELAAR_NAAM"];
		$RowObj->Data->BedragBtw = $row["BEDRAG_BTW"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPrdItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd_ond_items (
		:p_cube_row,
		:p_cube_tsg_type,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_OND';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkPrdCubeTsgType = $row["FK_PRD_CUBE_TSG_TYPE"];
		$RowObj->Key->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = $row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CountPrdRestrictedItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.count_prd_ond (
		:p_cube_row,
		:p_cube_tsg_type,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_OND';
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

case 'CreatePrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_prd (
		:p_cube_tsg_type,
		:p_cube_tsg_soort,
		:p_cube_tsg_soort1,
		:p_code,
		:p_prijs,
		:p_makelaar_naam,
		:p_bedrag_btw,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_cube_tsg_soort",$RequestObj->Parameters->Type->CubeTsgSoort);
	oci_bind_by_name($stid,":p_cube_tsg_soort1",$RequestObj->Parameters->Type->CubeTsgSoort1);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_prijs",$RequestObj->Parameters->Type->Prijs);
	oci_bind_by_name($stid,":p_makelaar_naam",$RequestObj->Parameters->Type->MakelaarNaam);
	oci_bind_by_name($stid,":p_bedrag_btw",$RequestObj->Parameters->Type->BedragBtw);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_PRD';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->CubeTsgType = $row["CUBE_TSG_TYPE"];
		$RowObj->Key->Code = $row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdatePrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_prd (
		:p_cube_tsg_type,
		:p_cube_tsg_soort,
		:p_cube_tsg_soort1,
		:p_code,
		:p_prijs,
		:p_makelaar_naam,
		:p_bedrag_btw);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_cube_tsg_soort",$RequestObj->Parameters->Type->CubeTsgSoort);
	oci_bind_by_name($stid,":p_cube_tsg_soort1",$RequestObj->Parameters->Type->CubeTsgSoort1);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_prijs",$RequestObj->Parameters->Type->Prijs);
	oci_bind_by_name($stid,":p_makelaar_naam",$RequestObj->Parameters->Type->MakelaarNaam);
	oci_bind_by_name($stid,":p_bedrag_btw",$RequestObj->Parameters->Type->BedragBtw);

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
		:p_cube_tsg_type,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

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

case 'GetOnd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_ond (
		:p_cube_row,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_OND';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkOndCode = $row["FK_OND_CODE"];
		$RowObj->Data->Prijs = $row["PRIJS"];
		$RowObj->Data->Omschrijving = $row["OMSCHRIJVING"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetOndItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_ond_odd_items (
		:p_cube_row,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_ODD';
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
		$RowObj->Display = $row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_ond_cst_items (
		:p_cube_row,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_CST';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkPrdCubeTsgType = $row["FK_PRD_CUBE_TSG_TYPE"];
		$RowObj->Key->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Key->FkOndCode = $row["FK_OND_CODE"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = $row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_ond_ond_items (
		:p_cube_row,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_OND';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkPrdCubeTsgType = $row["FK_PRD_CUBE_TSG_TYPE"];
		$RowObj->Key->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = $row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CountOndRestrictedItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.count_ond_ond (
		:p_cube_row,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_OND';
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
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_prd.count_ond_odd (
		:p_cube_row,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_ODD';
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

case 'MoveOnd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.move_ond (
		:p_cube_pos_action,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_code,
		:x_fk_prd_cube_tsg_type,
		:x_fk_prd_code,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":x_fk_prd_cube_tsg_type",$RequestObj->Parameters->Ref->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":x_fk_prd_code",$RequestObj->Parameters->Ref->FkPrdCode);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_OND';
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

case 'CreateOnd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_ond (
		:p_cube_pos_action,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_fk_ond_code,
		:p_code,
		:p_prijs,
		:p_omschrijving,
		:x_fk_prd_cube_tsg_type,
		:x_fk_prd_code,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_prijs",$RequestObj->Parameters->Type->Prijs);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":x_fk_prd_cube_tsg_type",$RequestObj->Parameters->Ref->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":x_fk_prd_code",$RequestObj->Parameters->Ref->FkPrdCode);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_OND';
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

case 'UpdateOnd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_ond (
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_fk_ond_code,
		:p_code,
		:p_prijs,
		:p_omschrijving);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_prijs",$RequestObj->Parameters->Type->Prijs);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_OND';
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

case 'DeleteOnd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_ond (
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_OND';
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

case 'GetOddList':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_odd_list (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_ODD';
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
		$RowObj->Display = $row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetOddForOndList':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_odd_for_ond_list (
		:p_cube_row,
		:p_cube_scope_level,
		:x_fk_prd_cube_tsg_type,
		:x_fk_prd_code,
		:x_fk_ond_code);
	END;");
	oci_bind_by_name($stid,":p_cube_scope_level",$RequestObj->Parameters->Option->CubeScopeLevel);
	oci_bind_by_name($stid,":x_fk_prd_cube_tsg_type",$RequestObj->Parameters->Ref->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":x_fk_prd_code",$RequestObj->Parameters->Ref->FkPrdCode);
	oci_bind_by_name($stid,":x_fk_ond_code",$RequestObj->Parameters->Ref->FkOndCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_ODD';
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
		$RowObj->Display = $row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetOdd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_odd (
		:p_cube_row,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_ODD';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkPrdCubeTsgType = $row["FK_PRD_CUBE_TSG_TYPE"];
		$RowObj->Data->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Data->FkOndCode = $row["FK_OND_CODE"];
		$RowObj->Data->Naam = $row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetOddFkey':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_odd_fkey (
		:p_cube_row,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_FKEY_ODD';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkPrdCubeTsgType = $row["FK_PRD_CUBE_TSG_TYPE"];
		$RowObj->Data->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Data->FkOndCode = $row["FK_OND_CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetOddItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_odd_ddd_items (
		:p_cube_row,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_DDD';
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
		$RowObj->Display = $row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'MoveOdd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.move_odd (
		:p_cube_pos_action,
		:p_code,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_ODD';
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

case 'CreateOdd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_odd (
		:p_cube_pos_action,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_fk_ond_code,
		:p_code,
		:p_naam,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_ODD';
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

case 'UpdateOdd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_odd (
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_fk_ond_code,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_ODD';
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

case 'DeleteOdd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_odd (
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_ODD';
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

case 'GetDdd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_ddd (
		:p_cube_row,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_DDD';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkPrdCubeTsgType = $row["FK_PRD_CUBE_TSG_TYPE"];
		$RowObj->Data->FkPrdCode = $row["FK_PRD_CODE"];
		$RowObj->Data->FkOndCode = $row["FK_OND_CODE"];
		$RowObj->Data->FkOddCode = $row["FK_ODD_CODE"];
		$RowObj->Data->Naam = $row["NAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'MoveDdd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.move_ddd (
		:p_cube_pos_action,
		:p_code,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_DDD';
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

case 'CreateDdd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_ddd (
		:p_cube_pos_action,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_fk_ond_code,
		:p_fk_odd_code,
		:p_code,
		:p_naam,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_fk_odd_code",$RequestObj->Parameters->Type->FkOddCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_DDD';
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

case 'UpdateDdd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_ddd (
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_fk_ond_code,
		:p_fk_odd_code,
		:p_code,
		:p_naam);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_fk_odd_code",$RequestObj->Parameters->Type->FkOddCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_DDD';
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

case 'DeleteDdd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_ddd (
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_DDD';
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

case 'GetCst':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_cst (
		:p_cube_row,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_fk_ond_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_CST';
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
		$RowObj->Data->XkOddCode = $row["XK_ODD_CODE"];
		$RowObj->Data->XkOddCode1 = $row["XK_ODD_CODE_1"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateCst':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.insert_cst (
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_fk_ond_code,
		:p_code,
		:p_omschrijving,
		:p_xk_odd_code,
		:p_xk_odd_code_1);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_odd_code",$RequestObj->Parameters->Type->XkOddCode);
	oci_bind_by_name($stid,":p_xk_odd_code_1",$RequestObj->Parameters->Type->XkOddCode1);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_CST';
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

case 'UpdateCst':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.update_cst (
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_fk_ond_code,
		:p_code,
		:p_omschrijving,
		:p_xk_odd_code,
		:p_xk_odd_code_1);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xk_odd_code",$RequestObj->Parameters->Type->XkOddCode);
	oci_bind_by_name($stid,":p_xk_odd_code_1",$RequestObj->Parameters->Type->XkOddCode1);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_CST';
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

case 'DeleteCst':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.delete_cst (
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_fk_ond_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_CST';
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