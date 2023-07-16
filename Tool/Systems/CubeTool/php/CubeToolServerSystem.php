<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);

switch ($RequestObj->Service) {

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
		:p_cube_row,
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