<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);

switch ($RequestObj->Service) {

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