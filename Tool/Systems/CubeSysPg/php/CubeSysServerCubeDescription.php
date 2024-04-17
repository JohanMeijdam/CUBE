<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");
set_exception_handler("CubeException");
$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);
$ResponseText = '[';

switch ($RequestObj->Service) {
case 'GetDirCubeDscItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_CUBE_DSC';
	$conn->query("CALL cube_dsc.get_cube_dsc_root_items ()");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	if ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->TypeName = $row["type_name"];
		$RowObj->Key->AttributeTypeName = $row["attribute_type_name"];
		$RowObj->Key->Sequence = $row["sequence"];
		$RowObj->Display = $row["type_name"].' '.$row["attribute_type_name"].' '.$row["sequence"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetCubeDsc':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_CUBE_DSC';
	$conn->query("CALL cube_dsc.get_cube_dsc ('".$RequestObj->Parameters->Type->TypeName."','".$RequestObj->Parameters->Type->AttributeTypeName."',".($RequestObj->Parameters->Type->Sequence??"null").")");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	if ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->Value = $row["value"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateCubeDsc':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_CUBE_DSC';
	$conn->query("CALL cube_dsc.insert_cube_dsc ('".$RequestObj->Parameters->Type->TypeName."','".$RequestObj->Parameters->Type->AttributeTypeName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->Value."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateCubeDsc':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_CUBE_DSC';
	$conn->query("CALL cube_dsc.update_cube_dsc ('".$RequestObj->Parameters->Type->TypeName."','".$RequestObj->Parameters->Type->AttributeTypeName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->Value."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteCubeDsc':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_CUBE_DSC';
	$conn->query("CALL cube_dsc.delete_cube_dsc ('".$RequestObj->Parameters->Type->TypeName."','".$RequestObj->Parameters->Type->AttributeTypeName."',".($RequestObj->Parameters->Type->Sequence??"null").")");
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