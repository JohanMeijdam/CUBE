<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");
set_exception_handler("CubeException");
$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);
$ResponseText = '[';

switch ($RequestObj->Service) {
case 'GetDirItpItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_ITP';
	$conn->query("CALL itp.get_itp_root_items ()");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetItpList':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_ITP';
	$conn->query("CALL itp.get_itp_list ()");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetItpItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_ITE';
	$conn->query("CALL itp.get_itp_ite_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkItpName = $row["fk_itp_name"];
		$RowObj->Key->Sequence = $row["sequence"];
		$RowObj->Display = $row["suffix"].' ('.$row["domain"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateItp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_ITP';
	$conn->query("CALL itp.insert_itp ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	if ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteItp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_ITP';
	$conn->query("CALL itp.delete_itp ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetIte':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_ITE';
	$conn->query("CALL itp.get_ite ('".$RequestObj->Parameters->Type->FkItpName."',".($RequestObj->Parameters->Type->Sequence??"null").")");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->Suffix = $row["suffix"];
		$RowObj->Data->Domain = $row["domain"];
		$RowObj->Data->Length = $row["length"];
		$RowObj->Data->Decimals = $row["decimals"];
		$RowObj->Data->CaseSensitive = $row["case_sensitive"];
		$RowObj->Data->DefaultValue = $row["default_value"];
		$RowObj->Data->SpacesAllowed = $row["spaces_allowed"];
		$RowObj->Data->Presentation = $row["presentation"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetIteItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_VAL';
	$conn->query("CALL itp.get_ite_val_items ('".$RequestObj->Parameters->Type->FkItpName."',".($RequestObj->Parameters->Type->Sequence??"null").")");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkItpName = $row["fk_itp_name"];
		$RowObj->Key->FkIteSequence = $row["fk_ite_sequence"];
		$RowObj->Key->Code = $row["code"];
		$RowObj->Display = $row["code"].' '.$row["prompt"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateIte':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_ITE';
	$conn->query("CALL itp.insert_ite ('".$RequestObj->Parameters->Type->FkItpName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->Suffix."','".$RequestObj->Parameters->Type->Domain."',".($RequestObj->Parameters->Type->Length??"null").",".($RequestObj->Parameters->Type->Decimals??"null").",'".$RequestObj->Parameters->Type->CaseSensitive."','".$RequestObj->Parameters->Type->DefaultValue."','".$RequestObj->Parameters->Type->SpacesAllowed."','".$RequestObj->Parameters->Type->Presentation."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	if ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkItpName = $row["fk_itp_name"];
		$RowObj->Key->Sequence = $row["sequence"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateIte':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_ITE';
	$conn->query("CALL itp.update_ite ('".$RequestObj->Parameters->Type->FkItpName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->Suffix."','".$RequestObj->Parameters->Type->Domain."',".($RequestObj->Parameters->Type->Length??"null").",".($RequestObj->Parameters->Type->Decimals??"null").",'".$RequestObj->Parameters->Type->CaseSensitive."','".$RequestObj->Parameters->Type->DefaultValue."','".$RequestObj->Parameters->Type->SpacesAllowed."','".$RequestObj->Parameters->Type->Presentation."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteIte':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_ITE';
	$conn->query("CALL itp.delete_ite ('".$RequestObj->Parameters->Type->FkItpName."',".($RequestObj->Parameters->Type->Sequence??"null").")");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetVal':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_VAL';
	$conn->query("CALL itp.get_val ('".$RequestObj->Parameters->Type->FkItpName."',".($RequestObj->Parameters->Type->FkIteSequence??"null").",'".$RequestObj->Parameters->Type->Code."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->Prompt = $row["prompt"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'MoveVal':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_VAL';
	$conn->query("CALL itp.move_val ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkItpName."',".($RequestObj->Parameters->Type->FkIteSequence??"null").",'".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Ref->FkItpName."',".($RequestObj->Parameters->Ref->FkIteSequence??"null").",'".$RequestObj->Parameters->Ref->Code."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateVal':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_VAL';
	$conn->query("CALL itp.insert_val ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkItpName."',".($RequestObj->Parameters->Type->FkIteSequence??"null").",'".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Type->Prompt."','".$RequestObj->Parameters->Ref->FkItpName."',".($RequestObj->Parameters->Ref->FkIteSequence??"null").",'".$RequestObj->Parameters->Ref->Code."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateVal':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_VAL';
	$conn->query("CALL itp.update_val ('".$RequestObj->Parameters->Type->FkItpName."',".($RequestObj->Parameters->Type->FkIteSequence??"null").",'".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Type->Prompt."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteVal':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_VAL';
	$conn->query("CALL itp.delete_val ('".$RequestObj->Parameters->Type->FkItpName."',".($RequestObj->Parameters->Type->FkIteSequence??"null").",'".$RequestObj->Parameters->Type->Code."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;