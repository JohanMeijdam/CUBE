<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);

switch ($RequestObj->Service) {

case 'GetDirCubeDscItems':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_cube_dsc.get_cube_dsc_root_items (:p_cube_row); END;");
	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'LIST_CUBE_DSC';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	while ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->TypeName = $row["TYPE_NAME"];
		$RowObj->Key->AttributeTypeName = $row["ATTRIBUTE_TYPE_NAME"];
		$RowObj->Key->Sequence = $row["SEQUENCE"];
		$RowObj->Display = $row["TYPE_NAME"].' '.$row["ATTRIBUTE_TYPE_NAME"].' '.$row["SEQUENCE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'GetCubeDsc':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_cube_dsc.get_cube_dsc (
		:p_cube_row,
		:p_type_name,
		:p_attribute_type_name,
		:p_sequence);
	END;");
	oci_bind_by_name($stid,":p_type_name",$RequestObj->Parameters->Type->TypeName);
	oci_bind_by_name($stid,":p_attribute_type_name",$RequestObj->Parameters->Type->AttributeTypeName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'SELECT_CUBE_DSC';
	$r = perform_db_request();
	if (!$r) { 
		echo ']';
		return;
	}
	$ResponseObj->Rows = array();
	if ($row = oci_fetch_assoc($curs)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->Value = $row["VALUE"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$ResponseText = json_encode($ResponseObj);
	echo $ResponseText;
	echo ']';

	break;

case 'CreateCubeDsc':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_cube_dsc.insert_cube_dsc (
		:p_type_name,
		:p_attribute_type_name,
		:p_sequence,
		:p_value);
	END;");
	oci_bind_by_name($stid,":p_type_name",$RequestObj->Parameters->Type->TypeName);
	oci_bind_by_name($stid,":p_attribute_type_name",$RequestObj->Parameters->Type->AttributeTypeName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_value",$RequestObj->Parameters->Type->Value);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'CREATE_CUBE_DSC';
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

case 'UpdateCubeDsc':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_cube_dsc.update_cube_dsc (
		:p_type_name,
		:p_attribute_type_name,
		:p_sequence,
		:p_value);
	END;");
	oci_bind_by_name($stid,":p_type_name",$RequestObj->Parameters->Type->TypeName);
	oci_bind_by_name($stid,":p_attribute_type_name",$RequestObj->Parameters->Type->AttributeTypeName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);
	oci_bind_by_name($stid,":p_value",$RequestObj->Parameters->Type->Value);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPDATE_CUBE_DSC';
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

case 'DeleteCubeDsc':
	echo '[';

	$stid = oci_parse($conn, "BEGIN pkg_cube_dsc.delete_cube_dsc (
		:p_type_name,
		:p_attribute_type_name,
		:p_sequence);
	END;");
	oci_bind_by_name($stid,":p_type_name",$RequestObj->Parameters->Type->TypeName);
	oci_bind_by_name($stid,":p_attribute_type_name",$RequestObj->Parameters->Type->AttributeTypeName);
	oci_bind_by_name($stid,":p_sequence",$RequestObj->Parameters->Type->Sequence);

	$responseObj = new \stdClass();
	$ResponseObj->ResultName = 'DELETE_CUBE_DSC';
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