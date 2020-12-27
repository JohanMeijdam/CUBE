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
	$ResponseObj->ResultName = 'LIST_ITP';
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
	$ResponseObj->ResultName = 'LIST_ITP';
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
	$ResponseObj->ResultName = 'LIST_ITE';
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
		:p_name,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_ITP';
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
	$ResponseObj->ResultName = 'DELETE_ITP';
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
	$ResponseObj->ResultName = 'SELECT_ITE';
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
	$ResponseObj->ResultName = 'LIST_VAL';
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
		:p_fk_itp_name,
		:p_sequence,
		:p_suffix,
		:p_domain,
		:p_length,
		:p_decimals,
		:p_case_sensitive,
		:p_default_value,
		:p_spaces_allowed,
		:p_presentation,
		:p_cube_row);
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
	$ResponseObj->ResultName = 'CREATE_ITE';
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
	$ResponseObj->ResultName = 'UPDATE_ITE';
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
	$ResponseObj->ResultName = 'DELETE_ITE';
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
	$ResponseObj->ResultName = 'SELECT_VAL';
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
	$ResponseObj->ResultName = 'MOVE_VAL';
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
	$ResponseObj->ResultName = 'CREATE_VAL';
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
	$ResponseObj->ResultName = 'UPDATE_VAL';
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
	$ResponseObj->ResultName = 'DELETE_VAL';
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

case 'GetDirBotItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_bot_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_BOT';
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
		$RowObj->Display = $row["NAME"].' ('.$row["CUBE_TSG_TYPE"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetBotList':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_bot_list (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_BOT';
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
		$RowObj->Display = $row["NAME"].' ('.$row["CUBE_TSG_TYPE"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetBot':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_bot (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_BOT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->CubeTsgType = $row["CUBE_TSG_TYPE"];
		$RowObj->Data->Directory = $row["DIRECTORY"];
		$RowObj->Data->ApiUrl = $row["API_URL"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetBotItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_bot_typ_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_TYP';
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
		$RowObj->Display = $row["NAME"].' ('.$row["CODE"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CountBotRestrictedItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_bot_typ (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_TYP';
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

case 'MoveBot':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_bot (
		:p_cube_pos_action,
		:p_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":x_name",$RequestObj->Parameters->Ref->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_BOT';
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

case 'CreateBot':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_bot (
		:p_cube_pos_action,
		:p_name,
		:p_cube_tsg_type,
		:p_directory,
		:p_api_url,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_directory",$RequestObj->Parameters->Type->Directory);
	oci_bind_by_name($stid,":p_api_url",$RequestObj->Parameters->Type->ApiUrl);
	oci_bind_by_name($stid,":x_name",$RequestObj->Parameters->Ref->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_BOT';
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

case 'UpdateBot':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_bot (
		:p_name,
		:p_cube_tsg_type,
		:p_directory,
		:p_api_url);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_directory",$RequestObj->Parameters->Type->Directory);
	oci_bind_by_name($stid,":p_api_url",$RequestObj->Parameters->Type->ApiUrl);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_BOT';
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

case 'DeleteBot':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_bot (
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_BOT';
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

case 'GetTypListAll':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_list_all (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_TYP';
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
		$RowObj->Display = $row["NAME"].' ('.$row["CODE"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetTypForTypListAll':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_for_typ_list_all (
		:p_cube_row,
		:p_cube_scope_level,
		:x_fk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_cube_scope_level",$RequestObj->Parameters->Option->CubeScopeLevel);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_TYP';
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
		$RowObj->Display = $row["NAME"].' ('.$row["CODE"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetTyp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_TYP';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Data->Code = $row["CODE"];
		$RowObj->Data->FlagPartialKey = $row["FLAG_PARTIAL_KEY"];
		$RowObj->Data->FlagRecursive = $row["FLAG_RECURSIVE"];
		$RowObj->Data->RecursiveCardinality = $row["RECURSIVE_CARDINALITY"];
		$RowObj->Data->Cardinality = $row["CARDINALITY"];
		$RowObj->Data->SortOrder = $row["SORT_ORDER"];
		$RowObj->Data->Icon = $row["ICON"];
		$RowObj->Data->Transferable = $row["TRANSFERABLE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetTypFkey':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_fkey (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_FKEY_TYP';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetTypItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_tsg_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_TSG';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = '('.$row["CODE"].')'.' '.$row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_atb_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_ATB';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->Name = $row["NAME"];
		$RowObj->Display = $row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_ref_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_REF';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->Sequence = $row["SEQUENCE"];
		$RowObj->Key->XkBotName = $row["XK_BOT_NAME"];
		$RowObj->Key->XkTypName = $row["XK_TYP_NAME"];
		$RowObj->Display = $row["NAME"].' ('.$row["CUBE_TSG_INT_EXT"].')'.' '.$row["XK_BOT_NAME"].' '.$row["XK_TYP_NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_rtt_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_RTT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->XfTspTypName = $row["XF_TSP_TYP_NAME"];
		$RowObj->Key->XfTspTsgCode = $row["XF_TSP_TSG_CODE"];
		$RowObj->Key->XkTspCode = $row["XK_TSP_CODE"];
		$RowObj->Display = $row["XF_TSP_TYP_NAME"].' '.$row["XF_TSP_TSG_CODE"].' '.$row["XK_TSP_CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_jsn_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_JSN';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->Name = $row["NAME"];
		$RowObj->Key->Location = $row["LOCATION"];
		$RowObj->Key->XfAtbTypName = $row["XF_ATB_TYP_NAME"];
		$RowObj->Key->XkAtbName = $row["XK_ATB_NAME"];
		$RowObj->Key->XkTypName = $row["XK_TYP_NAME"];
		$RowObj->Display = '('.$row["CUBE_TSG_OBJ_ARR"].')'.' ('.$row["CUBE_TSG_TYPE"].')'.' '.$row["NAME"].' '.$row["LOCATION"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_dct_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_DCT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Display = ' ';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_typ_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_TYP';
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
		$RowObj->Display = $row["NAME"].' ('.$row["CODE"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CountTypRestrictedItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_typ_jsn (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_JSN';
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

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_typ_dct (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_DCT';
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

case 'MoveTyp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_typ (
		:p_cube_pos_action,
		:p_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":x_name",$RequestObj->Parameters->Ref->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_TYP';
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

case 'CreateTyp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_typ (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_code,
		:p_flag_partial_key,
		:p_flag_recursive,
		:p_recursive_cardinality,
		:p_cardinality,
		:p_sort_order,
		:p_icon,
		:p_transferable,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_flag_partial_key",$RequestObj->Parameters->Type->FlagPartialKey);
	oci_bind_by_name($stid,":p_flag_recursive",$RequestObj->Parameters->Type->FlagRecursive);
	oci_bind_by_name($stid,":p_recursive_cardinality",$RequestObj->Parameters->Type->RecursiveCardinality);
	oci_bind_by_name($stid,":p_cardinality",$RequestObj->Parameters->Type->Cardinality);
	oci_bind_by_name($stid,":p_sort_order",$RequestObj->Parameters->Type->SortOrder);
	oci_bind_by_name($stid,":p_icon",$RequestObj->Parameters->Type->Icon);
	oci_bind_by_name($stid,":p_transferable",$RequestObj->Parameters->Type->Transferable);
	oci_bind_by_name($stid,":x_name",$RequestObj->Parameters->Ref->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_TYP';
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

case 'UpdateTyp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_typ (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_code,
		:p_flag_partial_key,
		:p_flag_recursive,
		:p_recursive_cardinality,
		:p_cardinality,
		:p_sort_order,
		:p_icon,
		:p_transferable);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_flag_partial_key",$RequestObj->Parameters->Type->FlagPartialKey);
	oci_bind_by_name($stid,":p_flag_recursive",$RequestObj->Parameters->Type->FlagRecursive);
	oci_bind_by_name($stid,":p_recursive_cardinality",$RequestObj->Parameters->Type->RecursiveCardinality);
	oci_bind_by_name($stid,":p_cardinality",$RequestObj->Parameters->Type->Cardinality);
	oci_bind_by_name($stid,":p_sort_order",$RequestObj->Parameters->Type->SortOrder);
	oci_bind_by_name($stid,":p_icon",$RequestObj->Parameters->Type->Icon);
	oci_bind_by_name($stid,":p_transferable",$RequestObj->Parameters->Type->Transferable);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_TYP';
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

case 'DeleteTyp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_typ (
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_TYP';
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

case 'GetTsg':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsg (
		:p_cube_row,
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_TSG';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->FkTsgCode = $row["FK_TSG_CODE"];
		$RowObj->Data->Name = $row["NAME"];
		$RowObj->Data->PrimaryKey = $row["PRIMARY_KEY"];
		$RowObj->Data->XfAtbTypName = $row["XF_ATB_TYP_NAME"];
		$RowObj->Data->XkAtbName = $row["XK_ATB_NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetTsgFkey':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsg_fkey (
		:p_cube_row,
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_FKEY_TSG';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetTsgItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsg_tsp_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_TSP';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkTsgCode = $row["FK_TSG_CODE"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = '('.$row["CODE"].')'.' '.$row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsg_tsg_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_TSG';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = '('.$row["CODE"].')'.' '.$row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CountTsgRestrictedItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_tsg_tsg (
		:p_cube_row,
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_TSG';
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

case 'MoveTsg':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_tsg (
		:p_cube_pos_action,
		:p_fk_typ_name,
		:p_code,
		:x_fk_typ_name,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_TSG';
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

case 'CreateTsg':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_tsg (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code,
		:p_name,
		:p_primary_key,
		:p_xf_atb_typ_name,
		:p_xk_atb_name,
		:x_fk_typ_name,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_tsg_code",$RequestObj->Parameters->Type->FkTsgCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_primary_key",$RequestObj->Parameters->Type->PrimaryKey);
	oci_bind_by_name($stid,":p_xf_atb_typ_name",$RequestObj->Parameters->Type->XfAtbTypName);
	oci_bind_by_name($stid,":p_xk_atb_name",$RequestObj->Parameters->Type->XkAtbName);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_TSG';
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

case 'UpdateTsg':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_tsg (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code,
		:p_name,
		:p_primary_key,
		:p_xf_atb_typ_name,
		:p_xk_atb_name);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_tsg_code",$RequestObj->Parameters->Type->FkTsgCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_primary_key",$RequestObj->Parameters->Type->PrimaryKey);
	oci_bind_by_name($stid,":p_xf_atb_typ_name",$RequestObj->Parameters->Type->XfAtbTypName);
	oci_bind_by_name($stid,":p_xk_atb_name",$RequestObj->Parameters->Type->XkAtbName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_TSG';
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

case 'DeleteTsg':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_tsg (
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_TSG';
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

case 'GetTspForTypList':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsp_for_typ_list (
		:p_cube_row,
		:p_cube_scope_level,
		:x_fk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_cube_scope_level",$RequestObj->Parameters->Option->CubeScopeLevel);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_TSP';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkTsgCode = $row["FK_TSG_CODE"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = $row["FK_TYP_NAME"].' '.$row["FK_TSG_CODE"].' ('.$row["CODE"].')'.' '.$row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetTspForTsgList':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsp_for_tsg_list (
		:p_cube_row,
		:p_cube_scope_level,
		:x_fk_typ_name,
		:x_fk_tsg_code);
	END;");
	oci_bind_by_name($stid,":p_cube_scope_level",$RequestObj->Parameters->Option->CubeScopeLevel);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_fk_tsg_code",$RequestObj->Parameters->Ref->FkTsgCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_TSP';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkTsgCode = $row["FK_TSG_CODE"];
		$RowObj->Key->Code = $row["CODE"];
		$RowObj->Display = $row["FK_TYP_NAME"].' '.$row["FK_TSG_CODE"].' ('.$row["CODE"].')'.' '.$row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetTsp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsp (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_tsg_code",$RequestObj->Parameters->Type->FkTsgCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_TSP';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->Name = $row["NAME"];
		$RowObj->Data->XfTspTypName = $row["XF_TSP_TYP_NAME"];
		$RowObj->Data->XfTspTsgCode = $row["XF_TSP_TSG_CODE"];
		$RowObj->Data->XkTspCode = $row["XK_TSP_CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'MoveTsp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_tsp (
		:p_cube_pos_action,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code,
		:x_fk_typ_name,
		:x_fk_tsg_code,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_tsg_code",$RequestObj->Parameters->Type->FkTsgCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_fk_tsg_code",$RequestObj->Parameters->Ref->FkTsgCode);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_TSP';
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

case 'CreateTsp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_tsp (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code,
		:p_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code,
		:x_fk_typ_name,
		:x_fk_tsg_code,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_tsg_code",$RequestObj->Parameters->Type->FkTsgCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_fk_tsg_code",$RequestObj->Parameters->Ref->FkTsgCode);
	oci_bind_by_name($stid,":x_code",$RequestObj->Parameters->Ref->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_TSP';
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

case 'UpdateTsp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_tsp (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code,
		:p_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_tsg_code",$RequestObj->Parameters->Type->FkTsgCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_TSP';
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

case 'DeleteTsp':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_tsp (
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_tsg_code",$RequestObj->Parameters->Type->FkTsgCode);
	oci_bind_by_name($stid,":p_code",$RequestObj->Parameters->Type->Code);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_TSP';
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

case 'GetAtbForTypList':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb_for_typ_list (
		:p_cube_row,
		:p_cube_scope_level,
		:x_fk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_cube_scope_level",$RequestObj->Parameters->Option->CubeScopeLevel);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_ATB';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->Name = $row["NAME"];
		$RowObj->Display = $row["FK_TYP_NAME"].' '.$row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetAtb':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_ATB';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->PrimaryKey = $row["PRIMARY_KEY"];
		$RowObj->Data->CodeDisplayKey = $row["CODE_DISPLAY_KEY"];
		$RowObj->Data->CodeForeignKey = $row["CODE_FOREIGN_KEY"];
		$RowObj->Data->FlagHidden = $row["FLAG_HIDDEN"];
		$RowObj->Data->DefaultValue = $row["DEFAULT_VALUE"];
		$RowObj->Data->Unchangeable = $row["UNCHANGEABLE"];
		$RowObj->Data->XkItpName = $row["XK_ITP_NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetAtbFkey':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb_fkey (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_FKEY_ATB';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetAtbItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb_der_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_DER';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkAtbName = $row["FK_ATB_NAME"];
		$RowObj->Display = '('.$row["CUBE_TSG_TYPE"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb_dca_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_DCA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkAtbName = $row["FK_ATB_NAME"];
		$RowObj->Display = ' ';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb_rta_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_RTA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkAtbName = $row["FK_ATB_NAME"];
		$RowObj->Key->XfTspTypName = $row["XF_TSP_TYP_NAME"];
		$RowObj->Key->XfTspTsgCode = $row["XF_TSP_TSG_CODE"];
		$RowObj->Key->XkTspCode = $row["XK_TSP_CODE"];
		$RowObj->Display = $row["XF_TSP_TYP_NAME"].' '.$row["XF_TSP_TSG_CODE"].' '.$row["XK_TSP_CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CountAtbRestrictedItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_atb_der (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_DER';
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

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_atb_dca (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_DCA';
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

case 'MoveAtb':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_atb (
		:p_cube_pos_action,
		:p_fk_typ_name,
		:p_name,
		:x_fk_typ_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_name",$RequestObj->Parameters->Ref->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_ATB';
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

case 'CreateAtb':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_atb (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_primary_key,
		:p_code_display_key,
		:p_code_foreign_key,
		:p_flag_hidden,
		:p_default_value,
		:p_unchangeable,
		:p_xk_itp_name,
		:x_fk_typ_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_primary_key",$RequestObj->Parameters->Type->PrimaryKey);
	oci_bind_by_name($stid,":p_code_display_key",$RequestObj->Parameters->Type->CodeDisplayKey);
	oci_bind_by_name($stid,":p_code_foreign_key",$RequestObj->Parameters->Type->CodeForeignKey);
	oci_bind_by_name($stid,":p_flag_hidden",$RequestObj->Parameters->Type->FlagHidden);
	oci_bind_by_name($stid,":p_default_value",$RequestObj->Parameters->Type->DefaultValue);
	oci_bind_by_name($stid,":p_unchangeable",$RequestObj->Parameters->Type->Unchangeable);
	oci_bind_by_name($stid,":p_xk_itp_name",$RequestObj->Parameters->Type->XkItpName);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_name",$RequestObj->Parameters->Ref->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_ATB';
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

case 'UpdateAtb':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_atb (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_primary_key,
		:p_code_display_key,
		:p_code_foreign_key,
		:p_flag_hidden,
		:p_default_value,
		:p_unchangeable,
		:p_xk_itp_name);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_primary_key",$RequestObj->Parameters->Type->PrimaryKey);
	oci_bind_by_name($stid,":p_code_display_key",$RequestObj->Parameters->Type->CodeDisplayKey);
	oci_bind_by_name($stid,":p_code_foreign_key",$RequestObj->Parameters->Type->CodeForeignKey);
	oci_bind_by_name($stid,":p_flag_hidden",$RequestObj->Parameters->Type->FlagHidden);
	oci_bind_by_name($stid,":p_default_value",$RequestObj->Parameters->Type->DefaultValue);
	oci_bind_by_name($stid,":p_unchangeable",$RequestObj->Parameters->Type->Unchangeable);
	oci_bind_by_name($stid,":p_xk_itp_name",$RequestObj->Parameters->Type->XkItpName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_ATB';
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

case 'DeleteAtb':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_atb (
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_ATB';
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

case 'GetDer':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_der (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_atb_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_DER';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->CubeTsgType = $row["CUBE_TSG_TYPE"];
		$RowObj->Data->AggregateFunction = $row["AGGREGATE_FUNCTION"];
		$RowObj->Data->XkTypName = $row["XK_TYP_NAME"];
		$RowObj->Data->XkTypName1 = $row["XK_TYP_NAME_1"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateDer':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_der (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_cube_tsg_type,
		:p_aggregate_function,
		:p_xk_typ_name,
		:p_xk_typ_name_1);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_aggregate_function",$RequestObj->Parameters->Type->AggregateFunction);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);
	oci_bind_by_name($stid,":p_xk_typ_name_1",$RequestObj->Parameters->Type->XkTypName1);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_DER';
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

case 'UpdateDer':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_der (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_cube_tsg_type,
		:p_aggregate_function,
		:p_xk_typ_name,
		:p_xk_typ_name_1);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_aggregate_function",$RequestObj->Parameters->Type->AggregateFunction);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);
	oci_bind_by_name($stid,":p_xk_typ_name_1",$RequestObj->Parameters->Type->XkTypName1);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_DER';
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

case 'DeleteDer':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_der (
		:p_fk_typ_name,
		:p_fk_atb_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_DER';
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

case 'GetDca':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_dca (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_atb_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_DCA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->Text = $row["TEXT"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateDca':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_dca (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);
	oci_bind_by_name($stid,":p_text",$RequestObj->Parameters->Type->Text);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_DCA';
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

case 'UpdateDca':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_dca (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);
	oci_bind_by_name($stid,":p_text",$RequestObj->Parameters->Type->Text);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_DCA';
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

case 'DeleteDca':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_dca (
		:p_fk_typ_name,
		:p_fk_atb_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_DCA';
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

case 'GetRta':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_rta (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_RTA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->IncludeOrExclude = $row["INCLUDE_OR_EXCLUDE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateRta':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_rta (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);
	oci_bind_by_name($stid,":p_include_or_exclude",$RequestObj->Parameters->Type->IncludeOrExclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_RTA';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkAtbName = $row["FK_ATB_NAME"];
		$RowObj->Key->XfTspTypName = $row["XF_TSP_TYP_NAME"];
		$RowObj->Key->XfTspTsgCode = $row["XF_TSP_TSG_CODE"];
		$RowObj->Key->XkTspCode = $row["XK_TSP_CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdateRta':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_rta (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);
	oci_bind_by_name($stid,":p_include_or_exclude",$RequestObj->Parameters->Type->IncludeOrExclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_RTA';
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

case 'DeleteRta':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_rta (
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_atb_name",$RequestObj->Parameters->Type->FkAtbName);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_RTA';
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

case 'GetRef':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_ref (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_bot_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_REF';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->Name = $row["NAME"];
		$RowObj->Data->PrimaryKey = $row["PRIMARY_KEY"];
		$RowObj->Data->CodeDisplayKey = $row["CODE_DISPLAY_KEY"];
		$RowObj->Data->Scope = $row["SCOPE"];
		$RowObj->Data->Unchangeable = $row["UNCHANGEABLE"];
		$RowObj->Data->WithinScopeExtension = $row["WITHIN_SCOPE_EXTENSION"];
		$RowObj->Data->CubeTsgIntExt = $row["CUBE_TSG_INT_EXT"];
		$RowObj->Data->XkTypName1 = $row["XK_TYP_NAME_1"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetRefFkey':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_ref_fkey (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_bot_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_FKEY_REF';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetRefItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_ref_dcr_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_bot_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_DCR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkRefSequence = $row["FK_REF_SEQUENCE"];
		$RowObj->Key->FkRefBotName = $row["FK_REF_BOT_NAME"];
		$RowObj->Key->FkRefTypName = $row["FK_REF_TYP_NAME"];
		$RowObj->Display = ' ';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_ref_rtr_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_bot_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_RTR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkRefSequence = $row["FK_REF_SEQUENCE"];
		$RowObj->Key->FkRefBotName = $row["FK_REF_BOT_NAME"];
		$RowObj->Key->FkRefTypName = $row["FK_REF_TYP_NAME"];
		$RowObj->Key->XfTspTypName = $row["XF_TSP_TYP_NAME"];
		$RowObj->Key->XfTspTsgCode = $row["XF_TSP_TSG_CODE"];
		$RowObj->Key->XkTspCode = $row["XK_TSP_CODE"];
		$RowObj->Display = $row["XF_TSP_TYP_NAME"].' '.$row["XF_TSP_TSG_CODE"].' '.$row["XK_TSP_CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ',';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_ref_rts_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_bot_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_RTS';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkRefSequence = $row["FK_REF_SEQUENCE"];
		$RowObj->Key->FkRefBotName = $row["FK_REF_BOT_NAME"];
		$RowObj->Key->FkRefTypName = $row["FK_REF_TYP_NAME"];
		$RowObj->Key->XfTspTypName = $row["XF_TSP_TYP_NAME"];
		$RowObj->Key->XfTspTsgCode = $row["XF_TSP_TSG_CODE"];
		$RowObj->Key->XkTspCode = $row["XK_TSP_CODE"];
		$RowObj->Display = $row["INCLUDE_OR_EXCLUDE"].' '.$row["XF_TSP_TYP_NAME"].' '.$row["XF_TSP_TSG_CODE"].' '.$row["XK_TSP_CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CountRefRestrictedItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_ref_dcr (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_bot_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_DCR';
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

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_ref_rts (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_bot_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_RTS';
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

case 'MoveRef':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_ref (
		:p_cube_pos_action,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_bot_name,
		:p_xk_typ_name,
		:x_fk_typ_name,
		:x_sequence,
		:x_xk_bot_name,
		:x_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_sequence",$RequestObj->Parameters->Ref->Sequence);
	oci_bind_by_name($stid,":x_xk_bot_name",$RequestObj->Parameters->Ref->XkBotName);
	oci_bind_by_name($stid,":x_xk_typ_name",$RequestObj->Parameters->Ref->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_REF';
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

case 'CreateRef':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_ref (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_primary_key,
		:p_code_display_key,
		:p_sequence,
		:p_scope,
		:p_unchangeable,
		:p_within_scope_extension,
		:p_cube_tsg_int_ext,
		:p_xk_bot_name,
		:p_xk_typ_name,
		:p_xk_typ_name_1,
		:x_fk_typ_name,
		:x_sequence,
		:x_xk_bot_name,
		:x_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_primary_key",$RequestObj->Parameters->Type->PrimaryKey);
	oci_bind_by_name($stid,":p_code_display_key",$RequestObj->Parameters->Type->CodeDisplayKey);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_scope",$RequestObj->Parameters->Type->Scope);
	oci_bind_by_name($stid,":p_unchangeable",$RequestObj->Parameters->Type->Unchangeable);
	oci_bind_by_name($stid,":p_within_scope_extension",$RequestObj->Parameters->Type->WithinScopeExtension);
	oci_bind_by_name($stid,":p_cube_tsg_int_ext",$RequestObj->Parameters->Type->CubeTsgIntExt);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);
	oci_bind_by_name($stid,":p_xk_typ_name_1",$RequestObj->Parameters->Type->XkTypName1);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_sequence",$RequestObj->Parameters->Ref->Sequence);
	oci_bind_by_name($stid,":x_xk_bot_name",$RequestObj->Parameters->Ref->XkBotName);
	oci_bind_by_name($stid,":x_xk_typ_name",$RequestObj->Parameters->Ref->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_REF';
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

case 'UpdateRef':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_ref (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_primary_key,
		:p_code_display_key,
		:p_sequence,
		:p_scope,
		:p_unchangeable,
		:p_within_scope_extension,
		:p_cube_tsg_int_ext,
		:p_xk_bot_name,
		:p_xk_typ_name,
		:p_xk_typ_name_1);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_primary_key",$RequestObj->Parameters->Type->PrimaryKey);
	oci_bind_by_name($stid,":p_code_display_key",$RequestObj->Parameters->Type->CodeDisplayKey);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_scope",$RequestObj->Parameters->Type->Scope);
	oci_bind_by_name($stid,":p_unchangeable",$RequestObj->Parameters->Type->Unchangeable);
	oci_bind_by_name($stid,":p_within_scope_extension",$RequestObj->Parameters->Type->WithinScopeExtension);
	oci_bind_by_name($stid,":p_cube_tsg_int_ext",$RequestObj->Parameters->Type->CubeTsgIntExt);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);
	oci_bind_by_name($stid,":p_xk_typ_name_1",$RequestObj->Parameters->Type->XkTypName1);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_REF';
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

case 'DeleteRef':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_ref (
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_bot_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_REF';
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

case 'GetDcr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_dcr (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_DCR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->Text = $row["TEXT"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateDcr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_dcr (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);
	oci_bind_by_name($stid,":p_text",$RequestObj->Parameters->Type->Text);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_DCR';
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

case 'UpdateDcr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_dcr (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);
	oci_bind_by_name($stid,":p_text",$RequestObj->Parameters->Type->Text);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_DCR';
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

case 'DeleteDcr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_dcr (
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_DCR';
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

case 'GetRtr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_rtr (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_RTR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->IncludeOrExclude = $row["INCLUDE_OR_EXCLUDE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateRtr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_rtr (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);
	oci_bind_by_name($stid,":p_include_or_exclude",$RequestObj->Parameters->Type->IncludeOrExclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_RTR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->FkRefSequence = $row["FK_REF_SEQUENCE"];
		$RowObj->Key->FkRefBotName = $row["FK_REF_BOT_NAME"];
		$RowObj->Key->FkRefTypName = $row["FK_REF_TYP_NAME"];
		$RowObj->Key->XfTspTypName = $row["XF_TSP_TYP_NAME"];
		$RowObj->Key->XfTspTsgCode = $row["XF_TSP_TSG_CODE"];
		$RowObj->Key->XkTspCode = $row["XK_TSP_CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdateRtr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_rtr (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);
	oci_bind_by_name($stid,":p_include_or_exclude",$RequestObj->Parameters->Type->IncludeOrExclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_RTR';
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

case 'DeleteRtr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_rtr (
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_RTR';
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

case 'GetRts':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_rts (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_RTS';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->IncludeOrExclude = $row["INCLUDE_OR_EXCLUDE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateRts':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_rts (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);
	oci_bind_by_name($stid,":p_include_or_exclude",$RequestObj->Parameters->Type->IncludeOrExclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_RTS';
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

case 'UpdateRts':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_rts (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);
	oci_bind_by_name($stid,":p_include_or_exclude",$RequestObj->Parameters->Type->IncludeOrExclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_RTS';
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

case 'DeleteRts':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_rts (
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_bot_name,
		:p_fk_ref_typ_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$RequestObj->Parameters->Type->FkRefSequence);
	oci_bind_by_name($stid,":p_fk_ref_bot_name",$RequestObj->Parameters->Type->FkRefBotName);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$RequestObj->Parameters->Type->FkRefTypName);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_RTS';
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

case 'GetRtt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_rtt (
		:p_cube_row,
		:p_fk_typ_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_RTT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->IncludeOrExclude = $row["INCLUDE_OR_EXCLUDE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateRtt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_rtt (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_include_or_exclude",$RequestObj->Parameters->Type->IncludeOrExclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_RTT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->XfTspTypName = $row["XF_TSP_TYP_NAME"];
		$RowObj->Key->XfTspTsgCode = $row["XF_TSP_TSG_CODE"];
		$RowObj->Key->XkTspCode = $row["XK_TSP_CODE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'UpdateRtt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_rtt (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_include_or_exclude",$RequestObj->Parameters->Type->IncludeOrExclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_RTT';
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

case 'DeleteRtt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_rtt (
		:p_fk_typ_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$RequestObj->Parameters->Type->XfTspTypName);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$RequestObj->Parameters->Type->XfTspTsgCode);
	oci_bind_by_name($stid,":p_xk_tsp_code",$RequestObj->Parameters->Type->XkTspCode);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_RTT';
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

case 'GetJsn':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_jsn (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name,
		:p_location,
		:p_xf_atb_typ_name,
		:p_xk_atb_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_location",$RequestObj->Parameters->Type->Location);
	oci_bind_by_name($stid,":p_xf_atb_typ_name",$RequestObj->Parameters->Type->XfAtbTypName);
	oci_bind_by_name($stid,":p_xk_atb_name",$RequestObj->Parameters->Type->XkAtbName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_JSN';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->FkJsnName = $row["FK_JSN_NAME"];
		$RowObj->Data->FkJsnLocation = $row["FK_JSN_LOCATION"];
		$RowObj->Data->FkJsnAtbTypName = $row["FK_JSN_ATB_TYP_NAME"];
		$RowObj->Data->FkJsnAtbName = $row["FK_JSN_ATB_NAME"];
		$RowObj->Data->FkJsnTypName = $row["FK_JSN_TYP_NAME"];
		$RowObj->Data->CubeTsgObjArr = $row["CUBE_TSG_OBJ_ARR"];
		$RowObj->Data->CubeTsgType = $row["CUBE_TSG_TYPE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetJsnFkey':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_jsn_fkey (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name,
		:p_location,
		:p_xf_atb_typ_name,
		:p_xk_atb_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_location",$RequestObj->Parameters->Type->Location);
	oci_bind_by_name($stid,":p_xf_atb_typ_name",$RequestObj->Parameters->Type->XfAtbTypName);
	oci_bind_by_name($stid,":p_xk_atb_name",$RequestObj->Parameters->Type->XkAtbName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_FKEY_JSN';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetJsnItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_jsn_jsn_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name,
		:p_location,
		:p_xf_atb_typ_name,
		:p_xk_atb_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_location",$RequestObj->Parameters->Type->Location);
	oci_bind_by_name($stid,":p_xf_atb_typ_name",$RequestObj->Parameters->Type->XfAtbTypName);
	oci_bind_by_name($stid,":p_xk_atb_name",$RequestObj->Parameters->Type->XkAtbName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_JSN';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["FK_TYP_NAME"];
		$RowObj->Key->Name = $row["NAME"];
		$RowObj->Key->Location = $row["LOCATION"];
		$RowObj->Key->XfAtbTypName = $row["XF_ATB_TYP_NAME"];
		$RowObj->Key->XkAtbName = $row["XK_ATB_NAME"];
		$RowObj->Key->XkTypName = $row["XK_TYP_NAME"];
		$RowObj->Display = '('.$row["CUBE_TSG_OBJ_ARR"].')'.' ('.$row["CUBE_TSG_TYPE"].')'.' '.$row["NAME"].' '.$row["LOCATION"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'MoveJsn':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_jsn (
		:p_cube_pos_action,
		:p_fk_typ_name,
		:p_name,
		:p_location,
		:p_xf_atb_typ_name,
		:p_xk_atb_name,
		:p_xk_typ_name,
		:x_fk_typ_name,
		:x_name,
		:x_location,
		:x_xf_atb_typ_name,
		:x_xk_atb_name,
		:x_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_location",$RequestObj->Parameters->Type->Location);
	oci_bind_by_name($stid,":p_xf_atb_typ_name",$RequestObj->Parameters->Type->XfAtbTypName);
	oci_bind_by_name($stid,":p_xk_atb_name",$RequestObj->Parameters->Type->XkAtbName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_name",$RequestObj->Parameters->Ref->Name);
	oci_bind_by_name($stid,":x_location",$RequestObj->Parameters->Ref->Location);
	oci_bind_by_name($stid,":x_xf_atb_typ_name",$RequestObj->Parameters->Ref->XfAtbTypName);
	oci_bind_by_name($stid,":x_xk_atb_name",$RequestObj->Parameters->Ref->XkAtbName);
	oci_bind_by_name($stid,":x_xk_typ_name",$RequestObj->Parameters->Ref->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_JSN';
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

case 'CreateJsn':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_jsn (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_jsn_name,
		:p_fk_jsn_location,
		:p_fk_jsn_atb_typ_name,
		:p_fk_jsn_atb_name,
		:p_fk_jsn_typ_name,
		:p_cube_tsg_obj_arr,
		:p_cube_tsg_type,
		:p_name,
		:p_location,
		:p_xf_atb_typ_name,
		:p_xk_atb_name,
		:p_xk_typ_name,
		:x_fk_typ_name,
		:x_name,
		:x_location,
		:x_xf_atb_typ_name,
		:x_xk_atb_name,
		:x_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_jsn_name",$RequestObj->Parameters->Type->FkJsnName);
	oci_bind_by_name($stid,":p_fk_jsn_location",$RequestObj->Parameters->Type->FkJsnLocation);
	oci_bind_by_name($stid,":p_fk_jsn_atb_typ_name",$RequestObj->Parameters->Type->FkJsnAtbTypName);
	oci_bind_by_name($stid,":p_fk_jsn_atb_name",$RequestObj->Parameters->Type->FkJsnAtbName);
	oci_bind_by_name($stid,":p_fk_jsn_typ_name",$RequestObj->Parameters->Type->FkJsnTypName);
	oci_bind_by_name($stid,":p_cube_tsg_obj_arr",$RequestObj->Parameters->Type->CubeTsgObjArr);
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_location",$RequestObj->Parameters->Type->Location);
	oci_bind_by_name($stid,":p_xf_atb_typ_name",$RequestObj->Parameters->Type->XfAtbTypName);
	oci_bind_by_name($stid,":p_xk_atb_name",$RequestObj->Parameters->Type->XkAtbName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);
	oci_bind_by_name($stid,":x_fk_typ_name",$RequestObj->Parameters->Ref->FkTypName);
	oci_bind_by_name($stid,":x_name",$RequestObj->Parameters->Ref->Name);
	oci_bind_by_name($stid,":x_location",$RequestObj->Parameters->Ref->Location);
	oci_bind_by_name($stid,":x_xf_atb_typ_name",$RequestObj->Parameters->Ref->XfAtbTypName);
	oci_bind_by_name($stid,":x_xk_atb_name",$RequestObj->Parameters->Ref->XkAtbName);
	oci_bind_by_name($stid,":x_xk_typ_name",$RequestObj->Parameters->Ref->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_JSN';
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

case 'UpdateJsn':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_jsn (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_jsn_name,
		:p_fk_jsn_location,
		:p_fk_jsn_atb_typ_name,
		:p_fk_jsn_atb_name,
		:p_fk_jsn_typ_name,
		:p_cube_tsg_obj_arr,
		:p_cube_tsg_type,
		:p_name,
		:p_location,
		:p_xf_atb_typ_name,
		:p_xk_atb_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_fk_jsn_name",$RequestObj->Parameters->Type->FkJsnName);
	oci_bind_by_name($stid,":p_fk_jsn_location",$RequestObj->Parameters->Type->FkJsnLocation);
	oci_bind_by_name($stid,":p_fk_jsn_atb_typ_name",$RequestObj->Parameters->Type->FkJsnAtbTypName);
	oci_bind_by_name($stid,":p_fk_jsn_atb_name",$RequestObj->Parameters->Type->FkJsnAtbName);
	oci_bind_by_name($stid,":p_fk_jsn_typ_name",$RequestObj->Parameters->Type->FkJsnTypName);
	oci_bind_by_name($stid,":p_cube_tsg_obj_arr",$RequestObj->Parameters->Type->CubeTsgObjArr);
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_location",$RequestObj->Parameters->Type->Location);
	oci_bind_by_name($stid,":p_xf_atb_typ_name",$RequestObj->Parameters->Type->XfAtbTypName);
	oci_bind_by_name($stid,":p_xk_atb_name",$RequestObj->Parameters->Type->XkAtbName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_JSN';
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

case 'DeleteJsn':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_jsn (
		:p_fk_typ_name,
		:p_name,
		:p_location,
		:p_xf_atb_typ_name,
		:p_xk_atb_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_location",$RequestObj->Parameters->Type->Location);
	oci_bind_by_name($stid,":p_xf_atb_typ_name",$RequestObj->Parameters->Type->XfAtbTypName);
	oci_bind_by_name($stid,":p_xk_atb_name",$RequestObj->Parameters->Type->XkAtbName);
	oci_bind_by_name($stid,":p_xk_typ_name",$RequestObj->Parameters->Type->XkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_JSN';
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

case 'GetDct':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_dct (
		:p_cube_row,
		:p_fk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_DCT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["FK_BOT_NAME"];
		$RowObj->Data->Text = $row["TEXT"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateDct':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_dct (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_text",$RequestObj->Parameters->Type->Text);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_DCT';
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

case 'UpdateDct':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_dct (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$RequestObj->Parameters->Type->FkBotName);
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);
	oci_bind_by_name($stid,":p_text",$RequestObj->Parameters->Type->Text);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_DCT';
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

case 'DeleteDct':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_dct (
		:p_fk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$RequestObj->Parameters->Type->FkTypName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_DCT';
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

case 'GetDirSysItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_sys.get_sys_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_SYS';
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
		$RowObj->Display = $row["NAME"].' ('.$row["CUBE_TSG_TYPE"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetSys':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_sys.get_sys (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_SYS';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->CubeTsgType = $row["CUBE_TSG_TYPE"];
		$RowObj->Data->Database = $row["DATABASE"];
		$RowObj->Data->Schema = $row["SCHEMA"];
		$RowObj->Data->Password = $row["PASSWORD"];
		$RowObj->Data->TablePrefix = $row["TABLE_PREFIX"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetSysItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_sys.get_sys_sbt_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_SBT';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkSysName = $row["FK_SYS_NAME"];
		$RowObj->Key->XkBotName = $row["XK_BOT_NAME"];
		$RowObj->Display = $row["XK_BOT_NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateSys':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_sys.insert_sys (
		:p_name,
		:p_cube_tsg_type,
		:p_database,
		:p_schema,
		:p_password,
		:p_table_prefix,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_database",$RequestObj->Parameters->Type->Database);
	oci_bind_by_name($stid,":p_schema",$RequestObj->Parameters->Type->Schema);
	oci_bind_by_name($stid,":p_password",$RequestObj->Parameters->Type->Password);
	oci_bind_by_name($stid,":p_table_prefix",$RequestObj->Parameters->Type->TablePrefix);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_SYS';
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

case 'UpdateSys':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_sys.update_sys (
		:p_name,
		:p_cube_tsg_type,
		:p_database,
		:p_schema,
		:p_password,
		:p_table_prefix);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_cube_tsg_type",$RequestObj->Parameters->Type->CubeTsgType);
	oci_bind_by_name($stid,":p_database",$RequestObj->Parameters->Type->Database);
	oci_bind_by_name($stid,":p_schema",$RequestObj->Parameters->Type->Schema);
	oci_bind_by_name($stid,":p_password",$RequestObj->Parameters->Type->Password);
	oci_bind_by_name($stid,":p_table_prefix",$RequestObj->Parameters->Type->TablePrefix);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_SYS';
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

case 'DeleteSys':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_sys.delete_sys (
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_SYS';
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

case 'MoveSbt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_sys.move_sbt (
		:p_cube_pos_action,
		:p_fk_sys_name,
		:p_xk_bot_name,
		:x_fk_sys_name,
		:x_xk_bot_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_sys_name",$RequestObj->Parameters->Type->FkSysName);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":x_fk_sys_name",$RequestObj->Parameters->Ref->FkSysName);
	oci_bind_by_name($stid,":x_xk_bot_name",$RequestObj->Parameters->Ref->XkBotName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_SBT';
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

case 'CreateSbt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_sys.insert_sbt (
		:p_cube_pos_action,
		:p_fk_sys_name,
		:p_xk_bot_name,
		:x_fk_sys_name,
		:x_xk_bot_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_sys_name",$RequestObj->Parameters->Type->FkSysName);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);
	oci_bind_by_name($stid,":x_fk_sys_name",$RequestObj->Parameters->Ref->FkSysName);
	oci_bind_by_name($stid,":x_xk_bot_name",$RequestObj->Parameters->Ref->XkBotName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_SBT';
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

case 'DeleteSbt':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_sys.delete_sbt (
		:p_fk_sys_name,
		:p_xk_bot_name);
	END;");
	oci_bind_by_name($stid,":p_fk_sys_name",$RequestObj->Parameters->Type->FkSysName);
	oci_bind_by_name($stid,":p_xk_bot_name",$RequestObj->Parameters->Type->XkBotName);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_SBT';
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

case 'GetDirFunItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_fun.get_fun_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_FUN';
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

case 'CountFun':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_fun.count_fun (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'COUNT_FUN';
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

case 'GetFunItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_fun.get_fun_arg_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_ARG';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkFunName = $row["FK_FUN_NAME"];
		$RowObj->Key->Name = $row["NAME"];
		$RowObj->Display = $row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateFun':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_fun.insert_fun (
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_FUN';
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

case 'DeleteFun':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_fun.delete_fun (
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_FUN';
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

case 'MoveArg':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_fun.move_arg (
		:p_cube_pos_action,
		:p_fk_fun_name,
		:p_name,
		:x_fk_fun_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_fun_name",$RequestObj->Parameters->Type->FkFunName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":x_fk_fun_name",$RequestObj->Parameters->Ref->FkFunName);
	oci_bind_by_name($stid,":x_name",$RequestObj->Parameters->Ref->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOVE_ARG';
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

case 'CreateArg':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_fun.insert_arg (
		:p_cube_pos_action,
		:p_fk_fun_name,
		:p_name,
		:x_fk_fun_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$RequestObj->Parameters->Option->CubePosAction);
	oci_bind_by_name($stid,":p_fk_fun_name",$RequestObj->Parameters->Type->FkFunName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":x_fk_fun_name",$RequestObj->Parameters->Ref->FkFunName);
	oci_bind_by_name($stid,":x_name",$RequestObj->Parameters->Ref->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_ARG';
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

case 'DeleteArg':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_fun.delete_arg (
		:p_fk_fun_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_fun_name",$RequestObj->Parameters->Type->FkFunName);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_ARG';
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