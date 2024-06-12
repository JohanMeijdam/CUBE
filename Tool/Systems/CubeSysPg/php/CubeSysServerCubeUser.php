<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");
set_exception_handler("CubeException");
$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);
$ResponseText = '[';

switch ($RequestObj->Service) {
case 'CheckPassword':
	$conn->query("BEGIN;");
	$conn->query("END;");
	break;
case 'GetDirCubeUsrItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_CUBE_USR';
	$conn->query("CALL cube_usr.get_cube_usr_root_items ()");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Userid = $row["userid"];
		$RowObj->Display = $row["userid"].' '.$row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetCubeUsr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_CUBE_USR';
	$conn->query("CALL cube_usr.get_cube_usr ('".$RequestObj->Parameters->Type->Userid."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->Name = $row["name"];
		$RowObj->Data->Password = $row["password"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateCubeUsr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_CUBE_USR';
	$conn->query("CALL cube_usr.insert_cube_usr ('".$RequestObj->Parameters->Type->Userid."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->Password."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateCubeUsr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_CUBE_USR';
	$conn->query("CALL cube_usr.update_cube_usr ('".$RequestObj->Parameters->Type->Userid."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->Password."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteCubeUsr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_CUBE_USR';
	$conn->query("CALL cube_usr.delete_cube_usr ('".$RequestObj->Parameters->Type->Userid."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;