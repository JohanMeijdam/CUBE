<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);

switch ($RequestObj->Service) {

case 'GetDirKlnItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_kln.get_kln_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_KLN';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Nummer = $row["NUMMER"];
		$RowObj->Display = $row["CUBE_TSG_INTEXT"].' '.$row["NUMMER"].' ('.$row["ACHTERNAAM"].')'.' '.$row["VOORNAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetKlnList':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_kln.get_kln_list (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_KLN';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Nummer = $row["NUMMER"];
		$RowObj->Display = $row["CUBE_TSG_INTEXT"].' '.$row["NUMMER"].' ('.$row["ACHTERNAAM"].')'.' '.$row["VOORNAAM"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetKln':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_kln.get_kln (
		:p_cube_row,
		:p_nummer);
	END;");
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_KLN';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->CubeTsgIntext = $row["CUBE_TSG_INTEXT"];
		$RowObj->Data->Achternaam = $row["ACHTERNAAM"];
		$RowObj->Data->GeboorteDatum = $row["GEBOORTE_DATUM"];
		$RowObj->Data->Leeftijd = $row["LEEFTIJD"];
		$RowObj->Data->Voornaam = $row["VOORNAAM"];
		$RowObj->Data->Tussenvoegsel = $row["TUSSENVOEGSEL"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetKlnItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_kln.get_kln_adr_items (
		:p_cube_row,
		:p_nummer);
	END;");
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_ADR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkKlnNummer = $row["FK_KLN_NUMMER"];
		$RowObj->Key->PostcodeCijfers = $row["POSTCODE_CIJFERS"];
		$RowObj->Key->PostcodeLetters = $row["POSTCODE_LETTERS"];
		$RowObj->Key->CubeTsgTest = $row["CUBE_TSG_TEST"];
		$RowObj->Key->Huisnummer = $row["HUISNUMMER"];
		$RowObj->Display = $row["POSTCODE_CIJFERS"].' '.$row["POSTCODE_LETTERS"].' '.$row["CUBE_TSG_TEST"].' '.$row["HUISNUMMER"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateKln':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_kln.insert_kln (
		:p_cube_tsg_intext,
		:p_nummer,
		:p_achternaam,
		:p_geboorte_datum,
		:p_leeftijd,
		:p_voornaam,
		:p_tussenvoegsel);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_intext",$RequestObj->Parameters->Type->CubeTsgIntext);
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);
	oci_bind_by_name($stid,":p_achternaam",$RequestObj->Parameters->Type->Achternaam);
	oci_bind_by_name($stid,":p_geboorte_datum",$RequestObj->Parameters->Type->GeboorteDatum);
	oci_bind_by_name($stid,":p_leeftijd",$RequestObj->Parameters->Type->Leeftijd);
	oci_bind_by_name($stid,":p_voornaam",$RequestObj->Parameters->Type->Voornaam);
	oci_bind_by_name($stid,":p_tussenvoegsel",$RequestObj->Parameters->Type->Tussenvoegsel);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_KLN';
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

case 'UpdateKln':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_kln.update_kln (
		:p_cube_tsg_intext,
		:p_nummer,
		:p_achternaam,
		:p_geboorte_datum,
		:p_leeftijd,
		:p_voornaam,
		:p_tussenvoegsel);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_intext",$RequestObj->Parameters->Type->CubeTsgIntext);
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);
	oci_bind_by_name($stid,":p_achternaam",$RequestObj->Parameters->Type->Achternaam);
	oci_bind_by_name($stid,":p_geboorte_datum",$RequestObj->Parameters->Type->GeboorteDatum);
	oci_bind_by_name($stid,":p_leeftijd",$RequestObj->Parameters->Type->Leeftijd);
	oci_bind_by_name($stid,":p_voornaam",$RequestObj->Parameters->Type->Voornaam);
	oci_bind_by_name($stid,":p_tussenvoegsel",$RequestObj->Parameters->Type->Tussenvoegsel);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_KLN';
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

case 'DeleteKln':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_kln.delete_kln (
		:p_nummer);
	END;");
	oci_bind_by_name($stid,":p_nummer",$RequestObj->Parameters->Type->Nummer);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_KLN';
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

case 'CreateAdr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_kln.insert_adr (
		:p_fk_kln_nummer,
		:p_postcode_cijfers,
		:p_postcode_letters,
		:p_cube_tsg_test,
		:p_huisnummer);
	END;");
	oci_bind_by_name($stid,":p_fk_kln_nummer",$RequestObj->Parameters->Type->FkKlnNummer);
	oci_bind_by_name($stid,":p_postcode_cijfers",$RequestObj->Parameters->Type->PostcodeCijfers);
	oci_bind_by_name($stid,":p_postcode_letters",$RequestObj->Parameters->Type->PostcodeLetters);
	oci_bind_by_name($stid,":p_cube_tsg_test",$RequestObj->Parameters->Type->CubeTsgTest);
	oci_bind_by_name($stid,":p_huisnummer",$RequestObj->Parameters->Type->Huisnummer);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_ADR';
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

case 'DeleteAdr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_kln.delete_adr (
		:p_fk_kln_nummer,
		:p_postcode_cijfers,
		:p_postcode_letters,
		:p_cube_tsg_test,
		:p_huisnummer);
	END;");
	oci_bind_by_name($stid,":p_fk_kln_nummer",$RequestObj->Parameters->Type->FkKlnNummer);
	oci_bind_by_name($stid,":p_postcode_cijfers",$RequestObj->Parameters->Type->PostcodeCijfers);
	oci_bind_by_name($stid,":p_postcode_letters",$RequestObj->Parameters->Type->PostcodeLetters);
	oci_bind_by_name($stid,":p_cube_tsg_test",$RequestObj->Parameters->Type->CubeTsgTest);
	oci_bind_by_name($stid,":p_huisnummer",$RequestObj->Parameters->Type->Huisnummer);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_ADR';
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
		$RowObj->Key->CubeTsgType = $row["CUBE_TSG_TYPE"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = $row["CUBE_TSG_TYPE"].' '.$row["CUBE_TSG_SOORT"].' '.$row["CUBE_TSG_SOORT1"].' '.$row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetPrdList':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_prd_list (:p_cube_row); END;");
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
		$RowObj->Display = $row["CUBE_TSG_TYPE"].' '.$row["CUBE_TSG_SOORT"].' '.$row["CUBE_TSG_SOORT1"].' '.$row["CODE"];
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
		$RowObj->Data->XkKlnNummer = $row["XK_KLN_NUMMER"];
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
		:p_xk_kln_nummer,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_cube_tsg_soort",$RequestObj->Parameters->Type->CubeTsgSoort);
	oci_bind_by_name($stid,":p_cube_tsg_soort1",$RequestObj->Parameters->Type->CubeTsgSoort1);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_prijs",$RequestObj->Parameters->Type->Prijs);
	oci_bind_by_name($stid,":p_makelaar_naam",$RequestObj->Parameters->Type->MakelaarNaam);
	oci_bind_by_name($stid,":p_bedrag_btw",$RequestObj->Parameters->Type->BedragBtw);
	oci_bind_by_name($stid,":p_xk_kln_nummer",$RequestObj->Parameters->Type->XkKlnNummer);

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
		:p_bedrag_btw,
		:p_xk_kln_nummer);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_cube_tsg_soort",$RequestObj->Parameters->Type->CubeTsgSoort);
	oci_bind_by_name($stid,":p_cube_tsg_soort1",$RequestObj->Parameters->Type->CubeTsgSoort1);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_prijs",$RequestObj->Parameters->Type->Prijs);
	oci_bind_by_name($stid,":p_makelaar_naam",$RequestObj->Parameters->Type->MakelaarNaam);
	oci_bind_by_name($stid,":p_bedrag_btw",$RequestObj->Parameters->Type->BedragBtw);
	oci_bind_by_name($stid,":p_xk_kln_nummer",$RequestObj->Parameters->Type->XkKlnNummer);

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

case 'GetOndListRecursive':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_prd.get_ond_list_recursive (
		:p_cube_row,
		:p_cube_up_or_down,
		:p_cube_x_level,
		:p_fk_prd_cube_tsg_type,
		:p_fk_prd_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_cube_up_or_down",$RequestObj->Parameters->Option->CubeUpOrDown);
	oci_bind_by_name($stid,":p_cube_x_level",$RequestObj->Parameters->Option->CubeXLevel);
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
		$RowObj->Display = $row["FK_PRD_CUBE_TSG_TYPE"].' '.$row["FK_PRD_CODE"].' '.$row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
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
		$RowObj->Data->XfOndPrdCubeTsgType = $row["XF_OND_PRD_CUBE_TSG_TYPE"];
		$RowObj->Data->XfOndPrdCode = $row["XF_OND_PRD_CODE"];
		$RowObj->Data->XkOndCode = $row["XK_OND_CODE"];
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
		:p_xf_ond_prd_cube_tsg_type,
		:p_xf_ond_prd_code,
		:p_xk_ond_code,
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
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType);
	oci_bind_by_name($stid,":p_xf_ond_prd_code",$RequestObj->Parameters->Type->XfOndPrdCode);
	oci_bind_by_name($stid,":p_xk_ond_code",$RequestObj->Parameters->Type->XkOndCode);
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
		:p_omschrijving,
		:p_xf_ond_prd_cube_tsg_type,
		:p_xf_ond_prd_code,
		:p_xk_ond_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_prijs",$RequestObj->Parameters->Type->Prijs);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType);
	oci_bind_by_name($stid,":p_xf_ond_prd_code",$RequestObj->Parameters->Type->XfOndPrdCode);
	oci_bind_by_name($stid,":p_xk_ond_code",$RequestObj->Parameters->Type->XkOndCode);

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
		$RowObj->Data->XfOndPrdCubeTsgType = $row["XF_OND_PRD_CUBE_TSG_TYPE"];
		$RowObj->Data->XfOndPrdCode = $row["XF_OND_PRD_CODE"];
		$RowObj->Data->XkOndCode = $row["XK_OND_CODE"];
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
		:p_xf_ond_prd_cube_tsg_type,
		:p_xf_ond_prd_code,
		:p_xk_ond_code,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType);
	oci_bind_by_name($stid,":p_xf_ond_prd_code",$RequestObj->Parameters->Type->XfOndPrdCode);
	oci_bind_by_name($stid,":p_xk_ond_code",$RequestObj->Parameters->Type->XkOndCode);
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
		:p_naam,
		:p_xf_ond_prd_cube_tsg_type,
		:p_xf_ond_prd_code,
		:p_xk_ond_code);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType);
	oci_bind_by_name($stid,":p_xf_ond_prd_code",$RequestObj->Parameters->Type->XfOndPrdCode);
	oci_bind_by_name($stid,":p_xk_ond_code",$RequestObj->Parameters->Type->XkOndCode);

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
		$RowObj->Data->XfOndPrdCubeTsgType = $row["XF_OND_PRD_CUBE_TSG_TYPE"];
		$RowObj->Data->XfOndPrdCode = $row["XF_OND_PRD_CODE"];
		$RowObj->Data->XkOndCode = $row["XK_OND_CODE"];
		$RowObj->Data->XfOndPrdCubeTsgType3 = $row["XF_OND_PRD_CUBE_TSG_TYPE_3"];
		$RowObj->Data->XfOndPrdCode3 = $row["XF_OND_PRD_CODE_3"];
		$RowObj->Data->XkOndCode3 = $row["XK_OND_CODE_3"];
		$RowObj->Data->XfOndPrdCubeTsgType1 = $row["XF_OND_PRD_CUBE_TSG_TYPE_1"];
		$RowObj->Data->XfOndPrdCode1 = $row["XF_OND_PRD_CODE_1"];
		$RowObj->Data->XkOndCode1 = $row["XK_OND_CODE_1"];
		$RowObj->Data->XfOndPrdCubeTsgType2 = $row["XF_OND_PRD_CUBE_TSG_TYPE_2"];
		$RowObj->Data->XfOndPrdCode2 = $row["XF_OND_PRD_CODE_2"];
		$RowObj->Data->XkOndCode2 = $row["XK_OND_CODE_2"];
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
		:p_xf_ond_prd_cube_tsg_type,
		:p_xf_ond_prd_code,
		:p_xk_ond_code,
		:p_xf_ond_prd_cube_tsg_type_3,
		:p_xf_ond_prd_code_3,
		:p_xk_ond_code_3,
		:p_xf_ond_prd_cube_tsg_type_1,
		:p_xf_ond_prd_code_1,
		:p_xk_ond_code_1,
		:p_xf_ond_prd_cube_tsg_type_2,
		:p_xf_ond_prd_code_2,
		:p_xk_ond_code_2,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_fk_odd_code",$RequestObj->Parameters->Type->FkOddCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType);
	oci_bind_by_name($stid,":p_xf_ond_prd_code",$RequestObj->Parameters->Type->XfOndPrdCode);
	oci_bind_by_name($stid,":p_xk_ond_code",$RequestObj->Parameters->Type->XkOndCode);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type_3",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType3);
	oci_bind_by_name($stid,":p_xf_ond_prd_code_3",$RequestObj->Parameters->Type->XfOndPrdCode3);
	oci_bind_by_name($stid,":p_xk_ond_code_3",$RequestObj->Parameters->Type->XkOndCode3);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type_1",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType1);
	oci_bind_by_name($stid,":p_xf_ond_prd_code_1",$RequestObj->Parameters->Type->XfOndPrdCode1);
	oci_bind_by_name($stid,":p_xk_ond_code_1",$RequestObj->Parameters->Type->XkOndCode1);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type_2",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType2);
	oci_bind_by_name($stid,":p_xf_ond_prd_code_2",$RequestObj->Parameters->Type->XfOndPrdCode2);
	oci_bind_by_name($stid,":p_xk_ond_code_2",$RequestObj->Parameters->Type->XkOndCode2);
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
		:p_naam,
		:p_xf_ond_prd_cube_tsg_type,
		:p_xf_ond_prd_code,
		:p_xk_ond_code,
		:p_xf_ond_prd_cube_tsg_type_3,
		:p_xf_ond_prd_code_3,
		:p_xk_ond_code_3,
		:p_xf_ond_prd_cube_tsg_type_1,
		:p_xf_ond_prd_code_1,
		:p_xk_ond_code_1,
		:p_xf_ond_prd_cube_tsg_type_2,
		:p_xf_ond_prd_code_2,
		:p_xk_ond_code_2);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_fk_odd_code",$RequestObj->Parameters->Type->FkOddCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_naam",$RequestObj->Parameters->Type->Naam);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType);
	oci_bind_by_name($stid,":p_xf_ond_prd_code",$RequestObj->Parameters->Type->XfOndPrdCode);
	oci_bind_by_name($stid,":p_xk_ond_code",$RequestObj->Parameters->Type->XkOndCode);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type_3",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType3);
	oci_bind_by_name($stid,":p_xf_ond_prd_code_3",$RequestObj->Parameters->Type->XfOndPrdCode3);
	oci_bind_by_name($stid,":p_xk_ond_code_3",$RequestObj->Parameters->Type->XkOndCode3);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type_1",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType1);
	oci_bind_by_name($stid,":p_xf_ond_prd_code_1",$RequestObj->Parameters->Type->XfOndPrdCode1);
	oci_bind_by_name($stid,":p_xk_ond_code_1",$RequestObj->Parameters->Type->XkOndCode1);
	oci_bind_by_name($stid,":p_xf_ond_prd_cube_tsg_type_2",$RequestObj->Parameters->Type->XfOndPrdCubeTsgType2);
	oci_bind_by_name($stid,":p_xf_ond_prd_code_2",$RequestObj->Parameters->Type->XfOndPrdCode2);
	oci_bind_by_name($stid,":p_xk_ond_code_2",$RequestObj->Parameters->Type->XkOndCode2);

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
		:p_xk_odd_code_1);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
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
		:p_xk_odd_code_1);
	END;");
	oci_bind_by_name($stid,":p_fk_prd_cube_tsg_type",$RequestObj->Parameters->Type->FkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_fk_prd_code",$RequestObj->Parameters->Type->FkPrdCode);
	oci_bind_by_name($stid,":p_fk_ond_code",$RequestObj->Parameters->Type->FkOndCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_omschrijving",$RequestObj->Parameters->Type->Omschrijving);
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

case 'GetDirOrdItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.get_ord_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_ORD';
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
		$RowObj->Display = $row["CUBE_TSG_INT_EXT"].' '.$row["CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetOrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.get_ord (
		:p_cube_row,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_ORD';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->CubeTsgIntExt = $row["CUBE_TSG_INT_EXT"];
		$RowObj->Data->XkKlnNummer = $row["XK_KLN_NUMMER"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetOrdItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.get_ord_orr_items (
		:p_cube_row,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_ORR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkOrdCode = $row["FK_ORD_CODE"];
		$RowObj->Display = '('.$row["TOTAAL_PRIJS"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'MoveOrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.move_ord (
		:p_cube_pos_action,
		:p_code,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_ORD';
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

case 'CreateOrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.insert_ord (
		:p_cube_pos_action,
		:p_cube_tsg_int_ext,
		:p_code,
		:p_xk_kln_nummer,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_cube_tsg_int_ext",$RequestObj->Parameters->Type->CubeTsgIntExt);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_xk_kln_nummer",$RequestObj->Parameters->Type->XkKlnNummer);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_ORD';
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

case 'UpdateOrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.update_ord (
		:p_cube_tsg_int_ext,
		:p_code,
		:p_xk_kln_nummer);
	END;");
	oci_bind_by_name($stid,":p_cube_tsg_int_ext",$RequestObj->Parameters->Type->CubeTsgIntExt);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_xk_kln_nummer",$RequestObj->Parameters->Type->XkKlnNummer);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_ORD';
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

case 'DeleteOrd':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.delete_ord (
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_ORD';
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

case 'GetOrr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.get_orr (
		:p_cube_row,
		:p_fk_ord_code);
	END;");
	oci_bind_by_name($stid,":p_fk_ord_code",$RequestObj->Parameters->Type->FkOrdCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_ORR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->ProduktPrijs = $row["PRODUKT_PRIJS"];
		$RowObj->Data->Aantal = $row["AANTAL"];
		$RowObj->Data->TotaalPrijs = $row["TOTAAL_PRIJS"];
		$RowObj->Data->XkPrdCubeTsgType = $row["XK_PRD_CUBE_TSG_TYPE"];
		$RowObj->Data->XkPrdCode = $row["XK_PRD_CODE"];
		$RowObj->Data->XkPrdCubeTsgType1 = $row["XK_PRD_CUBE_TSG_TYPE_1"];
		$RowObj->Data->XkPrdCode1 = $row["XK_PRD_CODE_1"];
		$RowObj->Data->XkKlnNummer = $row["XK_KLN_NUMMER"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateOrr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.insert_orr (
		:p_fk_ord_code,
		:p_produkt_prijs,
		:p_aantal,
		:p_totaal_prijs,
		:p_xk_prd_cube_tsg_type,
		:p_xk_prd_code,
		:p_xk_prd_cube_tsg_type_1,
		:p_xk_prd_code_1,
		:p_xk_kln_nummer,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_fk_ord_code",$RequestObj->Parameters->Type->FkOrdCode);
	oci_bind_by_name($stid,":p_produkt_prijs",$RequestObj->Parameters->Type->ProduktPrijs);
	oci_bind_by_name($stid,":p_aantal",$RequestObj->Parameters->Type->Aantal);
	oci_bind_by_name($stid,":p_totaal_prijs",$RequestObj->Parameters->Type->TotaalPrijs);
	oci_bind_by_name($stid,":p_xk_prd_cube_tsg_type",$RequestObj->Parameters->Type->XkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_xk_prd_code",$RequestObj->Parameters->Type->XkPrdCode);
	oci_bind_by_name($stid,":p_xk_prd_cube_tsg_type_1",$RequestObj->Parameters->Type->XkPrdCubeTsgType1);
	oci_bind_by_name($stid,":p_xk_prd_code_1",$RequestObj->Parameters->Type->XkPrdCode1);
	oci_bind_by_name($stid,":p_xk_kln_nummer",$RequestObj->Parameters->Type->XkKlnNummer);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_ORR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkOrdCode = $row["FK_ORD_CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdateOrr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.update_orr (
		:p_fk_ord_code,
		:p_produkt_prijs,
		:p_aantal,
		:p_totaal_prijs,
		:p_xk_prd_cube_tsg_type,
		:p_xk_prd_code,
		:p_xk_prd_cube_tsg_type_1,
		:p_xk_prd_code_1,
		:p_xk_kln_nummer);
	END;");
	oci_bind_by_name($stid,":p_fk_ord_code",$RequestObj->Parameters->Type->FkOrdCode);
	oci_bind_by_name($stid,":p_produkt_prijs",$RequestObj->Parameters->Type->ProduktPrijs);
	oci_bind_by_name($stid,":p_aantal",$RequestObj->Parameters->Type->Aantal);
	oci_bind_by_name($stid,":p_totaal_prijs",$RequestObj->Parameters->Type->TotaalPrijs);
	oci_bind_by_name($stid,":p_xk_prd_cube_tsg_type",$RequestObj->Parameters->Type->XkPrdCubeTsgType);
	oci_bind_by_name($stid,":p_xk_prd_code",$RequestObj->Parameters->Type->XkPrdCode);
	oci_bind_by_name($stid,":p_xk_prd_cube_tsg_type_1",$RequestObj->Parameters->Type->XkPrdCubeTsgType1);
	oci_bind_by_name($stid,":p_xk_prd_code_1",$RequestObj->Parameters->Type->XkPrdCode1);
	oci_bind_by_name($stid,":p_xk_kln_nummer",$RequestObj->Parameters->Type->XkKlnNummer);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_ORR';
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

case 'DeleteOrr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_ord.delete_orr (
		:p_fk_ord_code);
	END;");
	oci_bind_by_name($stid,":p_fk_ord_code",$RequestObj->Parameters->Type->FkOrdCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_ORR';
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