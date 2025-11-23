<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");
set_exception_handler("CubeException");
$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);
$ResponseText = '[';

switch ($RequestObj->Service) {
case 'GetDirFunItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_FUN';
	$conn->query("CALL fun.get_fun_root_items ()");
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
case 'CountFun':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CNT_FUN';
	$conn->query("CALL fun.count_fun ()");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->TypeCount = $row["type_count"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetFunItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_ARG';
	$conn->query("CALL fun.get_fun_arg_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkFunName = $row["fk_fun_name"];
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateFun':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_FUN';
	$conn->query("CALL fun.insert_fun ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteFun':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_FUN';
	$conn->query("CALL fun.delete_fun ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'MoveArg':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_ARG';
	$conn->query("CALL fun.move_arg ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkFunName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Ref->FkFunName."','".$RequestObj->Parameters->Ref->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateArg':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_ARG';
	$conn->query("CALL fun.insert_arg ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkFunName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Ref->FkFunName."','".$RequestObj->Parameters->Ref->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteArg':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_ARG';
	$conn->query("CALL fun.delete_arg ('".$RequestObj->Parameters->Type->FkFunName."','".$RequestObj->Parameters->Type->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;

default:
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'ERROR';
	$ResponseObj->ErrorText = $RequestText;
	$ResponseText = '['.json_encode($ResponseObj).']';
}
echo $ResponseText;

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
	$ResponseText = '['.json_encode($ResponseObj).']';
	echo $ResponseText;
}

function CubeError($errno, $errstr) {
	if ($errno > 2) {
		$ResponseObj = new \stdClass();
		$ResponseObj->ResultName = 'ERROR';
		$ResponseObj->ErrorText = "[$errno] $errstr";
		$ResponseText = '['.json_encode($ResponseObj).']';
		echo $ResponseText;
		exit;
	}
}

function CubeException($exception) {
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'ERROR';
	$ResponseObj->ErrorText = "$exception";
	$ResponseText = json_encode($ResponseObj);
	echo '['.$ResponseText.']';
	exit;
}
?>