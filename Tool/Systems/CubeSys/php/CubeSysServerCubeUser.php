<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);

switch ($RequestObj->Service) {

case 'CheckPassword':

	break;

case 'GetDirCubeUsrItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_cube_usr.get_cube_usr_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_CUBE_USR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Userid = $row["USERID"];
		$RowObj->Display = $row["USERID"].' '.$row["NAME"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetCubeUsr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_cube_usr.get_cube_usr (
		:p_cube_row,
		:p_userid);
	END;");
	oci_bind_by_name($stid,":p_userid",$RequestObj->Parameters->Type->Userid);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_CUBE_USR';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->Name = $row["NAME"];
		$RowObj->Data->Password = $row["PASSWORD"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateCubeUsr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_cube_usr.insert_cube_usr (
		:p_userid,
		:p_name,
		:p_password);
	END;");
	oci_bind_by_name($stid,":p_userid",$RequestObj->Parameters->Type->Userid);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_password",$RequestObj->Parameters->Type->Password);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_CUBE_USR';
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

case 'UpdateCubeUsr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_cube_usr.update_cube_usr (
		:p_userid,
		:p_name,
		:p_password);
	END;");
	oci_bind_by_name($stid,":p_userid",$RequestObj->Parameters->Type->Userid);
	oci_bind_by_name($stid,":p_name",$RequestObj->Parameters->Type->Name);
	oci_bind_by_name($stid,":p_password",$RequestObj->Parameters->Type->Password);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_CUBE_USR';
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

case 'DeleteCubeUsr':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_cube_usr.delete_cube_usr (
		:p_userid);
	END;");
	oci_bind_by_name($stid,":p_userid",$RequestObj->Parameters->Type->Userid);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_CUBE_USR';
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