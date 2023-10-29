<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);

switch ($RequestObj->Service) {

case 'GetDirItpItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_itp_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_ITP';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["NAME"];
		$RowObj->Display = $row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetItpList':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_itp_list (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_ITP';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["NAME"];
		$RowObj->Display = $row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetItpItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_itp_ite_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_ITE';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkItpName = $row["FK_ITP_NAME"];
		$RowObj->Key->Sequence = $row["SEQUENCE"];
		$RowObj->Display = $row["SUFFIX"].' ('.$row["DOMAIN"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateItp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.insert_itp (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_ITP';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'DeleteItp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.delete_itp (
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_ITP';
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

case 'GetIte':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_ite (
		:p_cube_row,
		:p_fk_itp_name,
		:p_sequence);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$RequestObj->Parameters->Type->FkItpName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_ITE';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->Suffix = $row["SUFFIX"];
		$RowObj->Data->Domain = $row["DOMAIN"];
		$RowObj->Data->Length = $row["LENGTH"];
		$RowObj->Data->Decimals = $row["DECIMALS"];
		$RowObj->Data->CaseSensitive = $row["CASE_SENSITIVE"];
		$RowObj->Data->DefaultValue = $row["DEFAULT_VALUE"];
		$RowObj->Data->SpacesAllowed = $row["SPACES_ALLOWED"];
		$RowObj->Data->Presentation = $row["PRESENTATION"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetIteItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_ite_val_items (
		:p_cube_row,
		:p_fk_itp_name,
		:p_sequence);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$RequestObj->Parameters->Type->FkItpName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_VAL';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkItpName = $row["FK_ITP_NAME"];
		$RowObj->Key->FkIteSequence = $row["FK_ITE_SEQUENCE"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = $row["CODE"].' '.$row["PROMPT"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateIte':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.insert_ite (
		:p_cube_row,
		:p_fk_itp_name,
		:p_sequence,
		:p_suffix,
		:p_domain,
		:p_length,
		:p_decimals,
		:p_case_sensitive,
		:p_default_value,
		:p_spaces_allowed,
		:p_presentation);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$RequestObj->Parameters->Type->FkItpName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_suffix",$RequestObj->Parameters->Type->Suffix);
	oci_bind_by_name($stid,":p_domain",$RequestObj->Parameters->Type->Domain);
	oci_bind_by_name($stid,":p_length",$RequestObj->Parameters->Type->Length);
	oci_bind_by_name($stid,":p_decimals",$RequestObj->Parameters->Type->Decimals);
	oci_bind_by_name($stid,":p_case_sensitive",$RequestObj->Parameters->Type->CaseSensitive);
	oci_bind_by_name($stid,":p_default_value",$RequestObj->Parameters->Type->DefaultValue);
	oci_bind_by_name($stid,":p_spaces_allowed",$RequestObj->Parameters->Type->SpacesAllowed);
	oci_bind_by_name($stid,":p_presentation",$RequestObj->Parameters->Type->Presentation);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_ITE';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkItpName = $row["FK_ITP_NAME"];
		$RowObj->Key->Sequence = $row["SEQUENCE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdateIte':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.update_ite (
		:p_fk_itp_name,
		:p_sequence,
		:p_suffix,
		:p_domain,
		:p_length,
		:p_decimals,
		:p_case_sensitive,
		:p_default_value,
		:p_spaces_allowed,
		:p_presentation);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$RequestObj->Parameters->Type->FkItpName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_suffix",$RequestObj->Parameters->Type->Suffix);
	oci_bind_by_name($stid,":p_domain",$RequestObj->Parameters->Type->Domain);
	oci_bind_by_name($stid,":p_length",$RequestObj->Parameters->Type->Length);
	oci_bind_by_name($stid,":p_decimals",$RequestObj->Parameters->Type->Decimals);
	oci_bind_by_name($stid,":p_case_sensitive",$RequestObj->Parameters->Type->CaseSensitive);
	oci_bind_by_name($stid,":p_default_value",$RequestObj->Parameters->Type->DefaultValue);
	oci_bind_by_name($stid,":p_spaces_allowed",$RequestObj->Parameters->Type->SpacesAllowed);
	oci_bind_by_name($stid,":p_presentation",$RequestObj->Parameters->Type->Presentation);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_ITE';
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

case 'DeleteIte':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.delete_ite (
		:p_fk_itp_name,
		:p_sequence);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$RequestObj->Parameters->Type->FkItpName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_ITE';
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

case 'GetVal':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_val (
		:p_cube_row,
		:p_fk_itp_name,
		:p_fk_ite_sequence,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$RequestObj->Parameters->Type->FkItpName);
	oci_bind_by_name($stid,":p_fk_ite_sequence",$RequestObj->Parameters->Type->FkIteSequence);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_VAL';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->Prompt = $row["PROMPT"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'MoveVal':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.move_val (
		:p_cube_pos_action,
		:p_fk_itp_name,
		:p_fk_ite_sequence,
		:p_code,
		:x_fk_itp_name,
		:x_fk_ite_sequence,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_itp_name",$RequestObj->Parameters->Type->FkItpName);
	oci_bind_by_name($stid,":p_fk_ite_sequence",$RequestObj->Parameters->Type->FkIteSequence);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":x_fk_itp_name",$RequestObj->Parameters->Ref->FkItpName);
	oci_bind_by_name($stid,":x_fk_ite_sequence",$RequestObj->Parameters->Ref->FkIteSequence);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_VAL';
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

case 'CreateVal':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.insert_val (
		:p_cube_pos_action,
		:p_fk_itp_name,
		:p_fk_ite_sequence,
		:p_code,
		:p_prompt,
		:x_fk_itp_name,
		:x_fk_ite_sequence,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_itp_name",$RequestObj->Parameters->Type->FkItpName);
	oci_bind_by_name($stid,":p_fk_ite_sequence",$RequestObj->Parameters->Type->FkIteSequence);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_prompt",$RequestObj->Parameters->Type->Prompt);
	oci_bind_by_name($stid,":x_fk_itp_name",$RequestObj->Parameters->Ref->FkItpName);
	oci_bind_by_name($stid,":x_fk_ite_sequence",$RequestObj->Parameters->Ref->FkIteSequence);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_VAL';
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

case 'UpdateVal':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.update_val (
		:p_fk_itp_name,
		:p_fk_ite_sequence,
		:p_code,
		:p_prompt);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$RequestObj->Parameters->Type->FkItpName);
	oci_bind_by_name($stid,":p_fk_ite_sequence",$RequestObj->Parameters->Type->FkIteSequence);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_prompt",$RequestObj->Parameters->Type->Prompt);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_VAL';
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

case 'DeleteVal':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_itp.delete_val (
		:p_fk_itp_name,
		:p_fk_ite_sequence,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$RequestObj->Parameters->Type->FkItpName);
	oci_bind_by_name($stid,":p_fk_ite_sequence",$RequestObj->Parameters->Type->FkIteSequence);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_VAL';
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