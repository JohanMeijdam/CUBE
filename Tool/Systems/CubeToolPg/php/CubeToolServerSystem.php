<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");
set_exception_handler("CubeException");
$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);
$ResponseText = '[';

switch ($RequestObj->Service) {
case 'GetDirSysItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_SYS';
	$conn->query("CALL sys.get_sys_root_items ()");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"].' ('.$row["cube_tsg_type"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetSys':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_SYS';
	$conn->query("CALL sys.get_sys ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->CubeTsgType = $row["cube_tsg_type"];
		$RowObj->Data->Database = $row["database"];
		$RowObj->Data->Schema = $row["schema"];
		$RowObj->Data->Password = $row["password"];
		$RowObj->Data->TablePrefix = $row["table_prefix"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetSysItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_SBT';
	$conn->query("CALL sys.get_sys_sbt_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkSysName = $row["fk_sys_name"];
		$RowObj->Key->XkBotName = $row["xk_bot_name"];
		$RowObj->Display = $row["xk_bot_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateSys':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_SYS';
	$conn->query("CALL sys.insert_sys ('".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgType."','".$RequestObj->Parameters->Type->Database."','".$RequestObj->Parameters->Type->Schema."','".$RequestObj->Parameters->Type->Password."','".$RequestObj->Parameters->Type->TablePrefix."')");
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
case 'UpdateSys':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_SYS';
	$conn->query("CALL sys.update_sys ('".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgType."','".$RequestObj->Parameters->Type->Database."','".$RequestObj->Parameters->Type->Schema."','".$RequestObj->Parameters->Type->Password."','".$RequestObj->Parameters->Type->TablePrefix."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteSys':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_SYS';
	$conn->query("CALL sys.delete_sys ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'MoveSbt':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_SBT';
	$conn->query("CALL sys.move_sbt ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkSysName."','".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Ref->FkSysName."','".$RequestObj->Parameters->Ref->XkBotName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateSbt':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_SBT';
	$conn->query("CALL sys.insert_sbt ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkSysName."','".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Ref->FkSysName."','".$RequestObj->Parameters->Ref->XkBotName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteSbt':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_SBT';
	$conn->query("CALL sys.delete_sbt ('".$RequestObj->Parameters->Type->FkSysName."','".$RequestObj->Parameters->Type->XkBotName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;