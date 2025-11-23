<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");
set_exception_handler("CubeException");
$RequestText = file_get_contents('php://input');
$RequestObj = json_decode($RequestText, false);
$ResponseText = '[';

switch ($RequestObj->Service) {
case 'GetDirBotItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_BOT';
	$conn->query("CALL bot.get_bot_root_items ()");
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
case 'GetBotList':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_BOT';
	$conn->query("CALL bot.get_bot_list ()");
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
case 'GetBot':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_BOT';
	$conn->query("CALL bot.get_bot ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->CubeTsgType = $row["cube_tsg_type"];
		$RowObj->Data->Directory = $row["directory"];
		$RowObj->Data->ApiUrl = $row["api_url"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetBotItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_TYP';
	$conn->query("CALL bot.get_bot_typ_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"].' ('.$row["code"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CountBotRestrictedItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CNT_TYP';
	$conn->query("CALL bot.count_bot_typ ('".$RequestObj->Parameters->Type->Name."')");
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
case 'MoveBot':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_BOT';
	$conn->query("CALL bot.move_bot ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Ref->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateBot':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_BOT';
	$conn->query("CALL bot.insert_bot ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgType."','".$RequestObj->Parameters->Type->Directory."','".$RequestObj->Parameters->Type->ApiUrl."','".$RequestObj->Parameters->Ref->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateBot':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_BOT';
	$conn->query("CALL bot.update_bot ('".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgType."','".$RequestObj->Parameters->Type->Directory."','".$RequestObj->Parameters->Type->ApiUrl."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteBot':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_BOT';
	$conn->query("CALL bot.delete_bot ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTypListAll':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_TYP';
	$conn->query("CALL bot.get_typ_list_all ()");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"].' ('.$row["code"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTypForBotListAll':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_TYP';
	$conn->query("CALL bot.get_typ_for_bot_list_all ('".$RequestObj->Parameters->Ref->FkBotName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"].' ('.$row["code"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTypForTypListAll':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_TYP';
	$conn->query("CALL bot.get_typ_for_typ_list_all (".($RequestObj->Parameters->Option->CubeScopeLevel??"null").",'".$RequestObj->Parameters->Ref->FkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"].' ('.$row["code"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTyp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_TYP';
	$conn->query("CALL bot.get_typ ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->FkTypName = $row["fk_typ_name"];
		$RowObj->Data->Code = $row["code"];
		$RowObj->Data->FlagPartialKey = $row["flag_partial_key"];
		$RowObj->Data->FlagRecursive = $row["flag_recursive"];
		$RowObj->Data->RecursiveCardinality = $row["recursive_cardinality"];
		$RowObj->Data->Cardinality = $row["cardinality"];
		$RowObj->Data->SortOrder = $row["sort_order"];
		$RowObj->Data->Icon = $row["icon"];
		$RowObj->Data->Transferable = $row["transferable"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTypFkey':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_FKEY_TYP';
	$conn->query("CALL bot.get_typ_fkey ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTypItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_TSG';
	$conn->query("CALL bot.get_typ_tsg_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->Code = $row["code"];
		$RowObj->Display = '('.$row["code"].')'.' '.$row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_ATB';
	$conn->query("CALL bot.get_typ_atb_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_REF';
	$conn->query("CALL bot.get_typ_ref_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->Sequence = $row["sequence"];
		$RowObj->Key->XkBotName = $row["xk_bot_name"];
		$RowObj->Key->XkTypName = $row["xk_typ_name"];
		$RowObj->Display = $row["name"].' ('.$row["cube_tsg_int_ext"].')'.' '.$row["xk_bot_name"].' '.$row["xk_typ_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_SRV';
	$conn->query("CALL bot.get_typ_srv_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->Name = $row["name"];
		$RowObj->Key->CubeTsgDbScr = $row["cube_tsg_db_scr"];
		$RowObj->Display = $row["name"].' ('.$row["cube_tsg_db_scr"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_RTT';
	$conn->query("CALL bot.get_typ_rtt_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->XfTspTypName = $row["xf_tsp_typ_name"];
		$RowObj->Key->XfTspTsgCode = $row["xf_tsp_tsg_code"];
		$RowObj->Key->XkTspCode = $row["xk_tsp_code"];
		$RowObj->Display = $row["xf_tsp_typ_name"].' '.$row["xf_tsp_tsg_code"].' '.$row["xk_tsp_code"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_JSN';
	$conn->query("CALL bot.get_typ_jsn_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->Name = $row["name"];
		$RowObj->Key->Location = $row["location"];
		$RowObj->Key->XfAtbTypName = $row["xf_atb_typ_name"];
		$RowObj->Key->XkAtbName = $row["xk_atb_name"];
		$RowObj->Key->XkTypName = $row["xk_typ_name"];
		$RowObj->Display = '('.$row["cube_tsg_obj_arr"].')'.' ('.$row["cube_tsg_type"].')'.' '.$row["name"].' '.$row["location"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_DCT';
	$conn->query("CALL bot.get_typ_dct_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Display = ' ';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_TYP';
	$conn->query("CALL bot.get_typ_typ_items ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"].' ('.$row["code"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CountTypRestrictedItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CNT_JSN';
	$conn->query("CALL bot.count_typ_jsn ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->TypeCount = $row["type_count"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CNT_DCT';
	$conn->query("CALL bot.count_typ_dct ('".$RequestObj->Parameters->Type->Name."')");
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
case 'MoveTyp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_TYP';
	$conn->query("CALL bot.move_typ ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Ref->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateTyp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_TYP';
	$conn->query("CALL bot.insert_typ ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Type->FlagPartialKey."','".$RequestObj->Parameters->Type->FlagRecursive."','".$RequestObj->Parameters->Type->RecursiveCardinality."','".$RequestObj->Parameters->Type->Cardinality."','".$RequestObj->Parameters->Type->SortOrder."','".$RequestObj->Parameters->Type->Icon."','".$RequestObj->Parameters->Type->Transferable."','".$RequestObj->Parameters->Ref->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateTyp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_TYP';
	$conn->query("CALL bot.update_typ ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Type->FlagPartialKey."','".$RequestObj->Parameters->Type->FlagRecursive."','".$RequestObj->Parameters->Type->RecursiveCardinality."','".$RequestObj->Parameters->Type->Cardinality."','".$RequestObj->Parameters->Type->SortOrder."','".$RequestObj->Parameters->Type->Icon."','".$RequestObj->Parameters->Type->Transferable."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteTyp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_TYP';
	$conn->query("CALL bot.delete_typ ('".$RequestObj->Parameters->Type->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTsg':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_TSG';
	$conn->query("CALL bot.get_tsg ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Code."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->FkTsgCode = $row["fk_tsg_code"];
		$RowObj->Data->Name = $row["name"];
		$RowObj->Data->PrimaryKey = $row["primary_key"];
		$RowObj->Data->XfAtbTypName = $row["xf_atb_typ_name"];
		$RowObj->Data->XkAtbName = $row["xk_atb_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTsgFkey':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_FKEY_TSG';
	$conn->query("CALL bot.get_tsg_fkey ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Code."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTsgItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_TSP';
	$conn->query("CALL bot.get_tsg_tsp_items ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Code."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkTsgCode = $row["fk_tsg_code"];
		$RowObj->Key->Code = $row["code"];
		$RowObj->Display = '('.$row["code"].')'.' '.$row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_TSG';
	$conn->query("CALL bot.get_tsg_tsg_items ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Code."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->Code = $row["code"];
		$RowObj->Display = '('.$row["code"].')'.' '.$row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CountTsgRestrictedItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CNT_TSG';
	$conn->query("CALL bot.count_tsg_tsg ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Code."')");
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
case 'MoveTsg':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_TSG';
	$conn->query("CALL bot.move_tsg ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->Code."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateTsg':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_TSG';
	$conn->query("CALL bot.insert_tsg ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkTsgCode."','".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->PrimaryKey."','".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->Code."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateTsg':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_TSG';
	$conn->query("CALL bot.update_tsg ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkTsgCode."','".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->PrimaryKey."','".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteTsg':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_TSG';
	$conn->query("CALL bot.delete_tsg ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Code."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTspForTypList':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_TSP';
	$conn->query("CALL bot.get_tsp_for_typ_list (".($RequestObj->Parameters->Option->CubeScopeLevel??"null").",'".$RequestObj->Parameters->Ref->FkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkTsgCode = $row["fk_tsg_code"];
		$RowObj->Key->Code = $row["code"];
		$RowObj->Display = $row["fk_typ_name"].' '.$row["fk_tsg_code"].' ('.$row["code"].')'.' '.$row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTspForTsgList':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_TSP';
	$conn->query("CALL bot.get_tsp_for_tsg_list (".($RequestObj->Parameters->Option->CubeScopeLevel??"null").",'".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->FkTsgCode."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkTsgCode = $row["fk_tsg_code"];
		$RowObj->Key->Code = $row["code"];
		$RowObj->Display = $row["fk_typ_name"].' '.$row["fk_tsg_code"].' ('.$row["code"].')'.' '.$row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetTsp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_TSP';
	$conn->query("CALL bot.get_tsp ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkTsgCode."','".$RequestObj->Parameters->Type->Code."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->Name = $row["name"];
		$RowObj->Data->XfTspTypName = $row["xf_tsp_typ_name"];
		$RowObj->Data->XfTspTsgCode = $row["xf_tsp_tsg_code"];
		$RowObj->Data->XkTspCode = $row["xk_tsp_code"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'MoveTsp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_TSP';
	$conn->query("CALL bot.move_tsp ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkTsgCode."','".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->FkTsgCode."','".$RequestObj->Parameters->Ref->Code."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateTsp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_TSP';
	$conn->query("CALL bot.insert_tsp ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkTsgCode."','".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->FkTsgCode."','".$RequestObj->Parameters->Ref->Code."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateTsp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_TSP';
	$conn->query("CALL bot.update_tsp ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkTsgCode."','".$RequestObj->Parameters->Type->Code."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteTsp':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_TSP';
	$conn->query("CALL bot.delete_tsp ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkTsgCode."','".$RequestObj->Parameters->Type->Code."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetAtbForTypList':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_ATB';
	$conn->query("CALL bot.get_atb_for_typ_list (".($RequestObj->Parameters->Option->CubeScopeLevel??"null").",'".$RequestObj->Parameters->Ref->FkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["fk_typ_name"].' '.$row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetAtb':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_ATB';
	$conn->query("CALL bot.get_atb ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->PrimaryKey = $row["primary_key"];
		$RowObj->Data->CodeDisplayKey = $row["code_display_key"];
		$RowObj->Data->CodeForeignKey = $row["code_foreign_key"];
		$RowObj->Data->FlagHidden = $row["flag_hidden"];
		$RowObj->Data->DefaultValue = $row["default_value"];
		$RowObj->Data->Unchangeable = $row["unchangeable"];
		$RowObj->Data->XkItpName = $row["xk_itp_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetAtbFkey':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_FKEY_ATB';
	$conn->query("CALL bot.get_atb_fkey ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetAtbItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_DER';
	$conn->query("CALL bot.get_atb_der_items ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkAtbName = $row["fk_atb_name"];
		$RowObj->Display = '('.$row["cube_tsg_type"].')';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_DCA';
	$conn->query("CALL bot.get_atb_dca_items ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkAtbName = $row["fk_atb_name"];
		$RowObj->Display = ' ';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_RTA';
	$conn->query("CALL bot.get_atb_rta_items ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkAtbName = $row["fk_atb_name"];
		$RowObj->Key->XfTspTypName = $row["xf_tsp_typ_name"];
		$RowObj->Key->XfTspTsgCode = $row["xf_tsp_tsg_code"];
		$RowObj->Key->XkTspCode = $row["xk_tsp_code"];
		$RowObj->Display = $row["xf_tsp_typ_name"].' '.$row["xf_tsp_tsg_code"].' '.$row["xk_tsp_code"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CountAtbRestrictedItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CNT_DER';
	$conn->query("CALL bot.count_atb_der ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->TypeCount = $row["type_count"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CNT_DCA';
	$conn->query("CALL bot.count_atb_dca ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."')");
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
case 'MoveAtb':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_ATB';
	$conn->query("CALL bot.move_atb ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateAtb':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_ATB';
	$conn->query("CALL bot.insert_atb ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->PrimaryKey."','".$RequestObj->Parameters->Type->CodeDisplayKey."','".$RequestObj->Parameters->Type->CodeForeignKey."','".$RequestObj->Parameters->Type->FlagHidden."','".$RequestObj->Parameters->Type->DefaultValue."','".$RequestObj->Parameters->Type->Unchangeable."','".$RequestObj->Parameters->Type->XkItpName."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateAtb':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_ATB';
	$conn->query("CALL bot.update_atb ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->PrimaryKey."','".$RequestObj->Parameters->Type->CodeDisplayKey."','".$RequestObj->Parameters->Type->CodeForeignKey."','".$RequestObj->Parameters->Type->FlagHidden."','".$RequestObj->Parameters->Type->DefaultValue."','".$RequestObj->Parameters->Type->Unchangeable."','".$RequestObj->Parameters->Type->XkItpName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteAtb':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_ATB';
	$conn->query("CALL bot.delete_atb ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetDer':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_DER';
	$conn->query("CALL bot.get_der ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->CubeTsgType = $row["cube_tsg_type"];
		$RowObj->Data->AggregateFunction = $row["aggregate_function"];
		$RowObj->Data->XkTypName = $row["xk_typ_name"];
		$RowObj->Data->XkTypName1 = $row["xk_typ_name_1"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateDer':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_DER';
	$conn->query("CALL bot.insert_der ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."','".$RequestObj->Parameters->Type->CubeTsgType."','".$RequestObj->Parameters->Type->AggregateFunction."','".$RequestObj->Parameters->Type->XkTypName."','".$RequestObj->Parameters->Type->XkTypName1."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateDer':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_DER';
	$conn->query("CALL bot.update_der ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."','".$RequestObj->Parameters->Type->CubeTsgType."','".$RequestObj->Parameters->Type->AggregateFunction."','".$RequestObj->Parameters->Type->XkTypName."','".$RequestObj->Parameters->Type->XkTypName1."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteDer':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_DER';
	$conn->query("CALL bot.delete_der ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetDca':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_DCA';
	$conn->query("CALL bot.get_dca ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->Text = $row["text"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateDca':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_DCA';
	$conn->query("CALL bot.insert_dca ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."','".$RequestObj->Parameters->Type->Text."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateDca':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_DCA';
	$conn->query("CALL bot.update_dca ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."','".$RequestObj->Parameters->Type->Text."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteDca':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_DCA';
	$conn->query("CALL bot.delete_dca ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetRta':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_RTA';
	$conn->query("CALL bot.get_rta ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->IncludeOrExclude = $row["include_or_exclude"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateRta':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_RTA';
	$conn->query("CALL bot.insert_rta ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."','".$RequestObj->Parameters->Type->IncludeOrExclude."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	if ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkAtbName = $row["fk_atb_name"];
		$RowObj->Key->XfTspTypName = $row["xf_tsp_typ_name"];
		$RowObj->Key->XfTspTsgCode = $row["xf_tsp_tsg_code"];
		$RowObj->Key->XkTspCode = $row["xk_tsp_code"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateRta':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_RTA';
	$conn->query("CALL bot.update_rta ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."','".$RequestObj->Parameters->Type->IncludeOrExclude."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteRta':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_RTA';
	$conn->query("CALL bot.delete_rta ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkAtbName."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetRefForTypList':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_REF';
	$conn->query("CALL bot.get_ref_for_typ_list (".($RequestObj->Parameters->Option->CubeScopeLevel??"null").",'".$RequestObj->Parameters->Ref->FkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->Sequence = $row["sequence"];
		$RowObj->Key->XkBotName = $row["xk_bot_name"];
		$RowObj->Key->XkTypName = $row["xk_typ_name"];
		$RowObj->Display = $row["fk_typ_name"].' '.$row["name"].' ('.$row["cube_tsg_int_ext"].')'.' '.$row["xk_bot_name"].' '.$row["xk_typ_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetRef':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_REF';
	$conn->query("CALL bot.get_ref ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->Name = $row["name"];
		$RowObj->Data->PrimaryKey = $row["primary_key"];
		$RowObj->Data->CodeDisplayKey = $row["code_display_key"];
		$RowObj->Data->Scope = $row["scope"];
		$RowObj->Data->Unchangeable = $row["unchangeable"];
		$RowObj->Data->WithinScopeExtension = $row["within_scope_extension"];
		$RowObj->Data->CubeTsgIntExt = $row["cube_tsg_int_ext"];
		$RowObj->Data->TypePrefix = $row["type_prefix"];
		$RowObj->Data->XkTypName1 = $row["xk_typ_name_1"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetRefFkey':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_FKEY_REF';
	$conn->query("CALL bot.get_ref_fkey ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetRefItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_DCR';
	$conn->query("CALL bot.get_ref_dcr_items ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkRefSequence = $row["fk_ref_sequence"];
		$RowObj->Key->FkRefBotName = $row["fk_ref_bot_name"];
		$RowObj->Key->FkRefTypName = $row["fk_ref_typ_name"];
		$RowObj->Display = ' ';
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_RTR';
	$conn->query("CALL bot.get_ref_rtr_items ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkRefSequence = $row["fk_ref_sequence"];
		$RowObj->Key->FkRefBotName = $row["fk_ref_bot_name"];
		$RowObj->Key->FkRefTypName = $row["fk_ref_typ_name"];
		$RowObj->Key->XfTspTypName = $row["xf_tsp_typ_name"];
		$RowObj->Key->XfTspTsgCode = $row["xf_tsp_tsg_code"];
		$RowObj->Key->XkTspCode = $row["xk_tsp_code"];
		$RowObj->Display = $row["xf_tsp_typ_name"].' '.$row["xf_tsp_tsg_code"].' '.$row["xk_tsp_code"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_RTS';
	$conn->query("CALL bot.get_ref_rts_items ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkRefSequence = $row["fk_ref_sequence"];
		$RowObj->Key->FkRefBotName = $row["fk_ref_bot_name"];
		$RowObj->Key->FkRefTypName = $row["fk_ref_typ_name"];
		$RowObj->Key->XfTspTypName = $row["xf_tsp_typ_name"];
		$RowObj->Key->XfTspTsgCode = $row["xf_tsp_tsg_code"];
		$RowObj->Key->XkTspCode = $row["xk_tsp_code"];
		$RowObj->Display = $row["include_or_exclude"].' '.$row["xf_tsp_typ_name"].' '.$row["xf_tsp_tsg_code"].' '.$row["xk_tsp_code"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CountRefRestrictedItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CNT_DCR';
	$conn->query("CALL bot.count_ref_dcr ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->TypeCount = $row["type_count"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CNT_RTS';
	$conn->query("CALL bot.count_ref_rts ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."')");
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
case 'MoveRef':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_REF';
	$conn->query("CALL bot.move_ref ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."','".$RequestObj->Parameters->Ref->FkTypName."',".($RequestObj->Parameters->Ref->Sequence??"null").",'".$RequestObj->Parameters->Ref->XkBotName."','".$RequestObj->Parameters->Ref->XkTypName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateRef':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_REF';
	$conn->query("CALL bot.insert_ref ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->PrimaryKey."','".$RequestObj->Parameters->Type->CodeDisplayKey."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->Scope."','".$RequestObj->Parameters->Type->Unchangeable."','".$RequestObj->Parameters->Type->WithinScopeExtension."','".$RequestObj->Parameters->Type->CubeTsgIntExt."','".$RequestObj->Parameters->Type->TypePrefix."','".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."','".$RequestObj->Parameters->Type->XkTypName1."','".$RequestObj->Parameters->Ref->FkTypName."',".($RequestObj->Parameters->Ref->Sequence??"null").",'".$RequestObj->Parameters->Ref->XkBotName."','".$RequestObj->Parameters->Ref->XkTypName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateRef':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_REF';
	$conn->query("CALL bot.update_ref ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->PrimaryKey."','".$RequestObj->Parameters->Type->CodeDisplayKey."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->Scope."','".$RequestObj->Parameters->Type->Unchangeable."','".$RequestObj->Parameters->Type->WithinScopeExtension."','".$RequestObj->Parameters->Type->CubeTsgIntExt."','".$RequestObj->Parameters->Type->TypePrefix."','".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."','".$RequestObj->Parameters->Type->XkTypName1."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteRef':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_REF';
	$conn->query("CALL bot.delete_ref ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->Sequence??"null").",'".$RequestObj->Parameters->Type->XkBotName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetDcr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_DCR';
	$conn->query("CALL bot.get_dcr ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->Text = $row["text"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateDcr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_DCR';
	$conn->query("CALL bot.insert_dcr ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."','".$RequestObj->Parameters->Type->Text."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateDcr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_DCR';
	$conn->query("CALL bot.update_dcr ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."','".$RequestObj->Parameters->Type->Text."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteDcr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_DCR';
	$conn->query("CALL bot.delete_dcr ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetRtr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_RTR';
	$conn->query("CALL bot.get_rtr ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->IncludeOrExclude = $row["include_or_exclude"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateRtr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_RTR';
	$conn->query("CALL bot.insert_rtr ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."','".$RequestObj->Parameters->Type->IncludeOrExclude."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	if ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkRefSequence = $row["fk_ref_sequence"];
		$RowObj->Key->FkRefBotName = $row["fk_ref_bot_name"];
		$RowObj->Key->FkRefTypName = $row["fk_ref_typ_name"];
		$RowObj->Key->XfTspTypName = $row["xf_tsp_typ_name"];
		$RowObj->Key->XfTspTsgCode = $row["xf_tsp_tsg_code"];
		$RowObj->Key->XkTspCode = $row["xk_tsp_code"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateRtr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_RTR';
	$conn->query("CALL bot.update_rtr ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."','".$RequestObj->Parameters->Type->IncludeOrExclude."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteRtr':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_RTR';
	$conn->query("CALL bot.delete_rtr ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetRts':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_RTS';
	$conn->query("CALL bot.get_rts ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->IncludeOrExclude = $row["include_or_exclude"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateRts':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_RTS';
	$conn->query("CALL bot.insert_rts ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."','".$RequestObj->Parameters->Type->IncludeOrExclude."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateRts':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_RTS';
	$conn->query("CALL bot.update_rts ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."','".$RequestObj->Parameters->Type->IncludeOrExclude."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteRts':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_RTS';
	$conn->query("CALL bot.delete_rts ('".$RequestObj->Parameters->Type->FkTypName."',".($RequestObj->Parameters->Type->FkRefSequence??"null").",'".$RequestObj->Parameters->Type->FkRefBotName."','".$RequestObj->Parameters->Type->FkRefTypName."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetSrv':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_SRV';
	$conn->query("CALL bot.get_srv ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgDbScr."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->Class = $row["class"];
		$RowObj->Data->Accessibility = $row["accessibility"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetSrvFkey':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_FKEY_SRV';
	$conn->query("CALL bot.get_srv_fkey ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgDbScr."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetSrvItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_SST';
	$conn->query("CALL bot.get_srv_sst_items ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgDbScr."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkSrvName = $row["fk_srv_name"];
		$RowObj->Key->FkSrvCubeTsgDbScr = $row["fk_srv_cube_tsg_db_scr"];
		$RowObj->Key->Name = $row["name"];
		$RowObj->Display = $row["name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).',';
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_SVD';
	$conn->query("CALL bot.get_srv_svd_items ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgDbScr."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->FkSrvName = $row["fk_srv_name"];
		$RowObj->Key->FkSrvCubeTsgDbScr = $row["fk_srv_cube_tsg_db_scr"];
		$RowObj->Key->XfAtbTypName = $row["xf_atb_typ_name"];
		$RowObj->Key->XkAtbName = $row["xk_atb_name"];
		$RowObj->Key->XkRefBotName = $row["xk_ref_bot_name"];
		$RowObj->Key->XkRefTypName = $row["xk_ref_typ_name"];
		$RowObj->Key->XfRefTypName = $row["xf_ref_typ_name"];
		$RowObj->Key->XkRefSequence = $row["xk_ref_sequence"];
		$RowObj->Display = '('.$row["cube_tsg_atb_ref"].')'.' '.$row["xf_atb_typ_name"].' '.$row["xk_atb_name"].' '.$row["xk_ref_bot_name"].' '.$row["xk_ref_typ_name"].' '.$row["xf_ref_typ_name"].' '.$row["xk_ref_sequence"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'MoveSrv':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_SRV';
	$conn->query("CALL bot.move_srv ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgDbScr."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->Name."','".$RequestObj->Parameters->Ref->CubeTsgDbScr."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateSrv':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_SRV';
	$conn->query("CALL bot.insert_srv ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgDbScr."','".$RequestObj->Parameters->Type->Class."','".$RequestObj->Parameters->Type->Accessibility."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->Name."','".$RequestObj->Parameters->Ref->CubeTsgDbScr."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateSrv':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_SRV';
	$conn->query("CALL bot.update_srv ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgDbScr."','".$RequestObj->Parameters->Type->Class."','".$RequestObj->Parameters->Type->Accessibility."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteSrv':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_SRV';
	$conn->query("CALL bot.delete_srv ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->CubeTsgDbScr."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetSst':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_SST';
	$conn->query("CALL bot.get_sst ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkSrvName."','".$RequestObj->Parameters->Type->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Type->Name."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->ScriptName = $row["script_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'MoveSst':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_SST';
	$conn->query("CALL bot.move_sst ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkSrvName."','".$RequestObj->Parameters->Type->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->FkSrvName."','".$RequestObj->Parameters->Ref->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Ref->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateSst':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_SST';
	$conn->query("CALL bot.insert_sst ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkSrvName."','".$RequestObj->Parameters->Type->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->ScriptName."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->FkSrvName."','".$RequestObj->Parameters->Ref->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Ref->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateSst':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_SST';
	$conn->query("CALL bot.update_sst ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkSrvName."','".$RequestObj->Parameters->Type->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Type->Name."','".$RequestObj->Parameters->Type->ScriptName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteSst':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_SST';
	$conn->query("CALL bot.delete_sst ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkSrvName."','".$RequestObj->Parameters->Type->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Type->Name."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetSvd':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_SVD';
	$conn->query("CALL bot.get_svd ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkSrvName."','".$RequestObj->Parameters->Type->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkRefBotName."','".$RequestObj->Parameters->Type->XkRefTypName."','".$RequestObj->Parameters->Type->XfRefTypName."',".($RequestObj->Parameters->Type->XkRefSequence??"null").")");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->CubeTsgAtbRef = $row["cube_tsg_atb_ref"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateSvd':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_SVD';
	$conn->query("CALL bot.insert_svd ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkSrvName."','".$RequestObj->Parameters->Type->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Type->CubeTsgAtbRef."','".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkRefBotName."','".$RequestObj->Parameters->Type->XkRefTypName."','".$RequestObj->Parameters->Type->XfRefTypName."',".($RequestObj->Parameters->Type->XkRefSequence??"null").")");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateSvd':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_SVD';
	$conn->query("CALL bot.update_svd ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkSrvName."','".$RequestObj->Parameters->Type->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Type->CubeTsgAtbRef."','".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkRefBotName."','".$RequestObj->Parameters->Type->XkRefTypName."','".$RequestObj->Parameters->Type->XfRefTypName."',".($RequestObj->Parameters->Type->XkRefSequence??"null").")");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteSvd':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_SVD';
	$conn->query("CALL bot.delete_svd ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkSrvName."','".$RequestObj->Parameters->Type->FkSrvCubeTsgDbScr."','".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkRefBotName."','".$RequestObj->Parameters->Type->XkRefTypName."','".$RequestObj->Parameters->Type->XfRefTypName."',".($RequestObj->Parameters->Type->XkRefSequence??"null").")");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetRtt':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_RTT';
	$conn->query("CALL bot.get_rtt ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->IncludeOrExclude = $row["include_or_exclude"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateRtt':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_RTT';
	$conn->query("CALL bot.insert_rtt ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->IncludeOrExclude."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	if ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->XfTspTypName = $row["xf_tsp_typ_name"];
		$RowObj->Key->XfTspTsgCode = $row["xf_tsp_tsg_code"];
		$RowObj->Key->XkTspCode = $row["xk_tsp_code"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateRtt':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_RTT';
	$conn->query("CALL bot.update_rtt ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->IncludeOrExclude."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteRtt':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_RTT';
	$conn->query("CALL bot.delete_rtt ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->XfTspTypName."','".$RequestObj->Parameters->Type->XfTspTsgCode."','".$RequestObj->Parameters->Type->XkTspCode."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetJsn':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_JSN';
	$conn->query("CALL bot.get_jsn ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."',".($RequestObj->Parameters->Type->Location??"null").",'".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->FkJsnName = $row["fk_jsn_name"];
		$RowObj->Data->FkJsnLocation = $row["fk_jsn_location"];
		$RowObj->Data->FkJsnAtbTypName = $row["fk_jsn_atb_typ_name"];
		$RowObj->Data->FkJsnAtbName = $row["fk_jsn_atb_name"];
		$RowObj->Data->FkJsnTypName = $row["fk_jsn_typ_name"];
		$RowObj->Data->CubeTsgObjArr = $row["cube_tsg_obj_arr"];
		$RowObj->Data->CubeTsgType = $row["cube_tsg_type"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetJsnFkey':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_FKEY_JSN';
	$conn->query("CALL bot.get_jsn_fkey ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."',".($RequestObj->Parameters->Type->Location??"null").",'".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetJsnItems':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'LST_JSN';
	$conn->query("CALL bot.get_jsn_jsn_items ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."',".($RequestObj->Parameters->Type->Location??"null").",'".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Key = new \stdClass();
		$RowObj->Key->FkTypName = $row["fk_typ_name"];
		$RowObj->Key->Name = $row["name"];
		$RowObj->Key->Location = $row["location"];
		$RowObj->Key->XfAtbTypName = $row["xf_atb_typ_name"];
		$RowObj->Key->XkAtbName = $row["xk_atb_name"];
		$RowObj->Key->XkTypName = $row["xk_typ_name"];
		$RowObj->Display = '('.$row["cube_tsg_obj_arr"].')'.' ('.$row["cube_tsg_type"].')'.' '.$row["name"].' '.$row["location"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'MoveJsn':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'MOV_JSN';
	$conn->query("CALL bot.move_jsn ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."',".($RequestObj->Parameters->Type->Location??"null").",'".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkTypName."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->Name."',".($RequestObj->Parameters->Ref->Location??"null").",'".$RequestObj->Parameters->Ref->XfAtbTypName."','".$RequestObj->Parameters->Ref->XkAtbName."','".$RequestObj->Parameters->Ref->XkTypName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateJsn':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_JSN';
	$conn->query("CALL bot.insert_jsn ('".$RequestObj->Parameters->Option->CubePosAction."','".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkJsnName."',".($RequestObj->Parameters->Type->FkJsnLocation??"null").",'".$RequestObj->Parameters->Type->FkJsnAtbTypName."','".$RequestObj->Parameters->Type->FkJsnAtbName."','".$RequestObj->Parameters->Type->FkJsnTypName."','".$RequestObj->Parameters->Type->CubeTsgObjArr."','".$RequestObj->Parameters->Type->CubeTsgType."','".$RequestObj->Parameters->Type->Name."',".($RequestObj->Parameters->Type->Location??"null").",'".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkTypName."','".$RequestObj->Parameters->Ref->FkTypName."','".$RequestObj->Parameters->Ref->Name."',".($RequestObj->Parameters->Ref->Location??"null").",'".$RequestObj->Parameters->Ref->XfAtbTypName."','".$RequestObj->Parameters->Ref->XkAtbName."','".$RequestObj->Parameters->Ref->XkTypName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateJsn':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_JSN';
	$conn->query("CALL bot.update_jsn ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->FkJsnName."',".($RequestObj->Parameters->Type->FkJsnLocation??"null").",'".$RequestObj->Parameters->Type->FkJsnAtbTypName."','".$RequestObj->Parameters->Type->FkJsnAtbName."','".$RequestObj->Parameters->Type->FkJsnTypName."','".$RequestObj->Parameters->Type->CubeTsgObjArr."','".$RequestObj->Parameters->Type->CubeTsgType."','".$RequestObj->Parameters->Type->Name."',".($RequestObj->Parameters->Type->Location??"null").",'".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteJsn':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_JSN';
	$conn->query("CALL bot.delete_jsn ('".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Name."',".($RequestObj->Parameters->Type->Location??"null").",'".$RequestObj->Parameters->Type->XfAtbTypName."','".$RequestObj->Parameters->Type->XkAtbName."','".$RequestObj->Parameters->Type->XkTypName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'GetDct':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'SEL_DCT';
	$conn->query("CALL bot.get_dct ('".$RequestObj->Parameters->Type->FkTypName."')");
	$ResponseObj->Rows = array();
	$curs = $conn->query('FETCH ALL FROM cube_cursor;');
	while ($row = $curs->fetch(PDO::FETCH_ASSOC)) {
		$RowObj = new \stdClass();
		$RowObj->Data = new \stdClass();
		$RowObj->Data->FkBotName = $row["fk_bot_name"];
		$RowObj->Data->Text = $row["text"];
		$ResponseObj->Rows[] = $RowObj;
	}
	$curs = $conn->query('CLOSE cube_cursor;');
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'CreateDct':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'CRE_DCT';
	$conn->query("CALL bot.insert_dct ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Text."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'UpdateDct':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'UPD_DCT';
	$conn->query("CALL bot.update_dct ('".$RequestObj->Parameters->Type->FkBotName."','".$RequestObj->Parameters->Type->FkTypName."','".$RequestObj->Parameters->Type->Text."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;
case 'DeleteDct':
	$conn->query("BEGIN;");
	$ResponseObj = new \stdClass();
	$ResponseObj->ResultName = 'DEL_DCT';
	$conn->query("CALL bot.delete_dct ('".$RequestObj->Parameters->Type->FkTypName."')");
	$ResponseText = $ResponseText.json_encode($ResponseObj).']';
	$conn->query("END;");
	break;