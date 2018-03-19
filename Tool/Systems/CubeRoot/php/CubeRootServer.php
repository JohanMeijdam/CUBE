<?php
session_start();
include 'CubeDbLogon.php';

set_error_handler("CubeError");

$import=explode("<|||>",file_get_contents('php://input'));
switch ($import[0]) {

case 'GetDirItpItems':

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_itp_root_items (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_ITP";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAME"];
		echo "<||>".$row["NAME"];
	}
	break;

case 'GetItpList':

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_itp_list (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_ITP";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAME"];
		echo "<||>".$row["NAME"];
	}
	break;

case 'GetItpItems':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_itp_ite_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_ITE";}
		echo "<|||>".$row["FK_ITP_NAME"]."<|>".$row["SEQUENCE"];
		echo "<||>".$row["SUFFIX"]." (".$row["DOMAIN"].")";
	}
	break;

case 'CreateItp':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.insert_itp (
		:p_name,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "CREATE_ITP";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAME"];
	}
	break;

case 'DeleteItp':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.delete_itp (
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_ITP";
	break;

case 'GetIte':

	list($p_fk_itp_name, $p_sequence) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_ite (
		:p_cube_row,
		:p_fk_itp_name,
		:p_sequence);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$p_fk_itp_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_ITE";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["SUFFIX"]."<|>".$row["DOMAIN"]."<|>".$row["LENGTH"]."<|>".$row["DECIMALS"]."<|>".$row["CASE_SENSITIVE"]."<|>".$row["DEFAULT_VALUE"]."<|>".$row["SPACES_ALLOWED"]."<|>".$row["DESCRIPTIVE"];
	}
	break;

case 'GetIteItems':

	list($p_fk_itp_name, $p_sequence) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_ite_val_items (
		:p_cube_row,
		:p_fk_itp_name,
		:p_sequence);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$p_fk_itp_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_VAL";}
		echo "<|||>".$row["FK_ITP_NAME"]."<|>".$row["FK_ITE_SEQUENCE"]."<|>".$row["CODE"];
		echo "<||>".$row["CODE"]." ".$row["PROMPT"];
	}
	break;

case 'CreateIte':

	list($p_fk_itp_name, $p_sequence, $p_suffix, $p_domain, $p_length, $p_decimals, $p_case_sensitive, $p_default_value, $p_spaces_allowed, $p_descriptive) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.insert_ite (
		:p_fk_itp_name,
		:p_sequence,
		:p_suffix,
		:p_domain,
		:p_length,
		:p_decimals,
		:p_case_sensitive,
		:p_default_value,
		:p_spaces_allowed,
		:p_descriptive,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$p_fk_itp_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_suffix",$p_suffix);
	oci_bind_by_name($stid,":p_domain",$p_domain);
	oci_bind_by_name($stid,":p_length",$p_length);
	oci_bind_by_name($stid,":p_decimals",$p_decimals);
	oci_bind_by_name($stid,":p_case_sensitive",$p_case_sensitive);
	oci_bind_by_name($stid,":p_default_value",$p_default_value);
	oci_bind_by_name($stid,":p_spaces_allowed",$p_spaces_allowed);
	oci_bind_by_name($stid,":p_descriptive",$p_descriptive);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "CREATE_ITE";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_ITP_NAME"]."<|>".$row["SEQUENCE"];
	}
	break;

case 'UpdateIte':

	list($p_fk_itp_name, $p_sequence, $p_suffix, $p_domain, $p_length, $p_decimals, $p_case_sensitive, $p_default_value, $p_spaces_allowed, $p_descriptive) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.update_ite (
		:p_fk_itp_name,
		:p_sequence,
		:p_suffix,
		:p_domain,
		:p_length,
		:p_decimals,
		:p_case_sensitive,
		:p_default_value,
		:p_spaces_allowed,
		:p_descriptive);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$p_fk_itp_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_suffix",$p_suffix);
	oci_bind_by_name($stid,":p_domain",$p_domain);
	oci_bind_by_name($stid,":p_length",$p_length);
	oci_bind_by_name($stid,":p_decimals",$p_decimals);
	oci_bind_by_name($stid,":p_case_sensitive",$p_case_sensitive);
	oci_bind_by_name($stid,":p_default_value",$p_default_value);
	oci_bind_by_name($stid,":p_spaces_allowed",$p_spaces_allowed);
	oci_bind_by_name($stid,":p_descriptive",$p_descriptive);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_ITE";
	break;

case 'DeleteIte':

	list($p_fk_itp_name, $p_sequence) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.delete_ite (
		:p_fk_itp_name,
		:p_sequence);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$p_fk_itp_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_ITE";
	break;

case 'GetVal':

	list($p_fk_itp_name, $p_fk_ite_sequence, $p_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.get_val (
		:p_cube_row,
		:p_fk_itp_name,
		:p_fk_ite_sequence,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$p_fk_itp_name);
	oci_bind_by_name($stid,":p_fk_ite_sequence",$p_fk_ite_sequence);
	oci_bind_by_name($stid,":p_code",$p_code);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_VAL";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["PROMPT"];
	}
	break;

case 'MoveVal':

	list($p_cube_pos_action, $p_fk_itp_name, $p_fk_ite_sequence, $p_code, $x_fk_itp_name, $x_fk_ite_sequence, $x_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.move_val (
		:p_cube_pos_action,
		:p_fk_itp_name,
		:p_fk_ite_sequence,
		:p_code,
		:x_fk_itp_name,
		:x_fk_ite_sequence,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_itp_name",$p_fk_itp_name);
	oci_bind_by_name($stid,":p_fk_ite_sequence",$p_fk_ite_sequence);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":x_fk_itp_name",$x_fk_itp_name);
	oci_bind_by_name($stid,":x_fk_ite_sequence",$x_fk_ite_sequence);
	oci_bind_by_name($stid,":x_code",$x_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "MOVE_VAL";
	break;

case 'CreateVal':

	list($p_cube_pos_action, $p_fk_itp_name, $p_fk_ite_sequence, $p_code, $p_prompt, $x_fk_itp_name, $x_fk_ite_sequence, $x_code) = explode("<|>", $import[1]."<|><|><|>");

	$stid = oci_parse($conn, "BEGIN pkg_itp.insert_val (
		:p_cube_pos_action,
		:p_fk_itp_name,
		:p_fk_ite_sequence,
		:p_code,
		:p_prompt,
		:x_fk_itp_name,
		:x_fk_ite_sequence,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_itp_name",$p_fk_itp_name);
	oci_bind_by_name($stid,":p_fk_ite_sequence",$p_fk_ite_sequence);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_prompt",$p_prompt);
	oci_bind_by_name($stid,":x_fk_itp_name",$x_fk_itp_name);
	oci_bind_by_name($stid,":x_fk_ite_sequence",$x_fk_ite_sequence);
	oci_bind_by_name($stid,":x_code",$x_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_VAL";
	break;

case 'UpdateVal':

	list($p_fk_itp_name, $p_fk_ite_sequence, $p_code, $p_prompt) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.update_val (
		:p_fk_itp_name,
		:p_fk_ite_sequence,
		:p_code,
		:p_prompt);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$p_fk_itp_name);
	oci_bind_by_name($stid,":p_fk_ite_sequence",$p_fk_ite_sequence);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_prompt",$p_prompt);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_VAL";
	break;

case 'DeleteVal':

	list($p_fk_itp_name, $p_fk_ite_sequence, $p_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_itp.delete_val (
		:p_fk_itp_name,
		:p_fk_ite_sequence,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_itp_name",$p_fk_itp_name);
	oci_bind_by_name($stid,":p_fk_ite_sequence",$p_fk_ite_sequence);
	oci_bind_by_name($stid,":p_code",$p_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_VAL";
	break;

case 'GetDirBotItems':

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_bot_root_items (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_BOT";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAME"];
		echo "<||>".$row["NAME"];
	}
	break;

case 'GetBotList':

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_bot_list (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_BOT";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAME"];
		echo "<||>".$row["NAME"];
	}
	break;

case 'GetBot':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_bot (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_BOT";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["DIRECTORY"];
	}
	break;

case 'GetBotItems':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_bot_typ_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_TYP";}
		echo "<|||>".$row["NAME"];
		echo "<||>".$row["NAME"]." (".$row["CODE"].")";
	}
	break;

case 'CountBotRestrictedItems':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_bot_typ (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "COUNT_TYP";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["TYPE_COUNT"];
	}
	break;

case 'MoveBot':

	list($p_cube_pos_action, $p_name, $x_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_bot (
		:p_cube_pos_action,
		:p_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":x_name",$x_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "MOVE_BOT";
	break;

case 'CreateBot':

	list($p_cube_pos_action, $p_name, $p_directory, $x_name) = explode("<|>", $import[1]."<|>");

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_bot (
		:p_cube_pos_action,
		:p_name,
		:p_directory,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_directory",$p_directory);
	oci_bind_by_name($stid,":x_name",$x_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_BOT";
	break;

case 'UpdateBot':

	list($p_name, $p_directory) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_bot (
		:p_name,
		:p_directory);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_directory",$p_directory);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_BOT";
	break;

case 'DeleteBot':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_bot (
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_BOT";
	break;

case 'GetTypListAll':

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_list_all (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_TYP";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAME"];
		echo "<||>".$row["NAME"]." (".$row["CODE"].")";
	}
	break;

case 'GetTypListEncapsulated':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_list_encapsulated (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_TYP";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAME"];
		echo "<||>".$row["NAME"]." (".$row["CODE"].")";
	}
	break;

case 'GetTypListRecursive':

	list($p_cube_up_or_down, $p_cube_x_level, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_list_recursive (
		:p_cube_row,
		:p_cube_up_or_down,
		:p_cube_x_level,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_cube_up_or_down",$p_cube_up_or_down);
	oci_bind_by_name($stid,":p_cube_x_level",$p_cube_x_level);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_TYP";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAME"];
		echo "<||>".$row["NAME"]." (".$row["CODE"].")";
	}
	break;

case 'GetTyp':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_TYP";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["FK_TYP_NAME"]."<|>".$row["CODE"]."<|>".$row["FLAG_PARTIAL_KEY"]."<|>".$row["FLAG_RECURSIVE"]."<|>".$row["RECURSIVE_CARDINALITY"]."<|>".$row["CARDINALITY"]."<|>".$row["SORT_ORDER"]."<|>".$row["ICON"]."<|>".$row["TRANSFERABLE"];
	}
	break;

case 'GetTypFkey':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_fkey (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_FKEY_TYP";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"];
	}
	break;

case 'GetTypItems':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_atb_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_ATB";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["NAME"];
		echo "<||>".$row["NAME"];
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_ref_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_REF";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["SEQUENCE"]."<|>".$row["XK_TYP_NAME"];
		echo "<||>".$row["NAME"]." ".$row["XK_TYP_NAME"];
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_tyr_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_TYR";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["XK_TYP_NAME"];
		echo "<||>".$row["XK_TYP_NAME"];
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_par_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_PAR";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["NAME"];
		echo "<||>".$row["NAME"];
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_tsg_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_TSG";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["CODE"];
		echo "<||>"."(".$row["CODE"].")"." ".$row["NAME"];
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_dct_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_DCT";}
		echo "<|||>".$row["FK_TYP_NAME"];
		echo "<||>";
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_typ_typ_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_TYP";}
		echo "<|||>".$row["NAME"];
		echo "<||>".$row["NAME"]." (".$row["CODE"].")";
	}
	break;

case 'CountTypRestrictedItems':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_typ_dct (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "COUNT_DCT";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["TYPE_COUNT"];
	}
	break;

case 'MoveTyp':

	list($p_cube_pos_action, $p_name, $x_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_typ (
		:p_cube_pos_action,
		:p_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":x_name",$x_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "MOVE_TYP";
	break;

case 'CreateTyp':

	list($p_cube_pos_action, $p_fk_bot_name, $p_fk_typ_name, $p_name, $p_code, $p_flag_partial_key, $p_flag_recursive, $p_recursive_cardinality, $p_cardinality, $p_sort_order, $p_icon, $p_transferable, $x_name) = explode("<|>", $import[1]."<|>");

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_typ (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_code,
		:p_flag_partial_key,
		:p_flag_recursive,
		:p_recursive_cardinality,
		:p_cardinality,
		:p_sort_order,
		:p_icon,
		:p_transferable,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_flag_partial_key",$p_flag_partial_key);
	oci_bind_by_name($stid,":p_flag_recursive",$p_flag_recursive);
	oci_bind_by_name($stid,":p_recursive_cardinality",$p_recursive_cardinality);
	oci_bind_by_name($stid,":p_cardinality",$p_cardinality);
	oci_bind_by_name($stid,":p_sort_order",$p_sort_order);
	oci_bind_by_name($stid,":p_icon",$p_icon);
	oci_bind_by_name($stid,":p_transferable",$p_transferable);
	oci_bind_by_name($stid,":x_name",$x_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_TYP";
	break;

case 'UpdateTyp':

	list($p_fk_bot_name, $p_fk_typ_name, $p_name, $p_code, $p_flag_partial_key, $p_flag_recursive, $p_recursive_cardinality, $p_cardinality, $p_sort_order, $p_icon, $p_transferable) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_typ (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_code,
		:p_flag_partial_key,
		:p_flag_recursive,
		:p_recursive_cardinality,
		:p_cardinality,
		:p_sort_order,
		:p_icon,
		:p_transferable);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_flag_partial_key",$p_flag_partial_key);
	oci_bind_by_name($stid,":p_flag_recursive",$p_flag_recursive);
	oci_bind_by_name($stid,":p_recursive_cardinality",$p_recursive_cardinality);
	oci_bind_by_name($stid,":p_cardinality",$p_cardinality);
	oci_bind_by_name($stid,":p_sort_order",$p_sort_order);
	oci_bind_by_name($stid,":p_icon",$p_icon);
	oci_bind_by_name($stid,":p_transferable",$p_transferable);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_TYP";
	break;

case 'DeleteTyp':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_typ (
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_TYP";
	break;

case 'GetAtb':

	list($p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_ATB";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["PRIMARY_KEY"]."<|>".$row["CODE_DISPLAY_KEY"]."<|>".$row["CODE_FOREIGN_KEY"]."<|>".$row["FLAG_HIDDEN"]."<|>".$row["DEFAULT_VALUE"]."<|>".$row["UNCHANGEABLE"]."<|>".$row["XK_ITP_NAME"];
	}
	break;

case 'GetAtbFkey':

	list($p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb_fkey (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_FKEY_ATB";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"];
	}
	break;

case 'GetAtbItems':

	list($p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb_der_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_DER";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_ATB_NAME"];
		echo "<||>";
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb_dca_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_DCA";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_ATB_NAME"];
		echo "<||>";
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_atb_rta_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_RTA";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_ATB_NAME"]."<|>".$row["XF_TSP_TYP_NAME"]."<|>".$row["XF_TSP_TSG_CODE"]."<|>".$row["XK_TSP_CODE"];
		echo "<||>".$row["XF_TSP_TYP_NAME"]." ".$row["XF_TSP_TSG_CODE"]." ".$row["XK_TSP_CODE"];
	}
	break;

case 'CountAtbRestrictedItems':

	list($p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_atb_der (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "COUNT_DER";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["TYPE_COUNT"];
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_atb_dca (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "COUNT_DCA";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["TYPE_COUNT"];
	}
	break;

case 'MoveAtb':

	list($p_cube_pos_action, $p_fk_typ_name, $p_name, $x_fk_typ_name, $x_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_atb (
		:p_cube_pos_action,
		:p_fk_typ_name,
		:p_name,
		:x_fk_typ_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_name",$x_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "MOVE_ATB";
	break;

case 'CreateAtb':

	list($p_cube_pos_action, $p_fk_bot_name, $p_fk_typ_name, $p_name, $p_primary_key, $p_code_display_key, $p_code_foreign_key, $p_flag_hidden, $p_default_value, $p_unchangeable, $p_xk_itp_name, $x_fk_typ_name, $x_name) = explode("<|>", $import[1]."<|><|>");

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_atb (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_primary_key,
		:p_code_display_key,
		:p_code_foreign_key,
		:p_flag_hidden,
		:p_default_value,
		:p_unchangeable,
		:p_xk_itp_name,
		:x_fk_typ_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_primary_key",$p_primary_key);
	oci_bind_by_name($stid,":p_code_display_key",$p_code_display_key);
	oci_bind_by_name($stid,":p_code_foreign_key",$p_code_foreign_key);
	oci_bind_by_name($stid,":p_flag_hidden",$p_flag_hidden);
	oci_bind_by_name($stid,":p_default_value",$p_default_value);
	oci_bind_by_name($stid,":p_unchangeable",$p_unchangeable);
	oci_bind_by_name($stid,":p_xk_itp_name",$p_xk_itp_name);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_name",$x_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_ATB";
	break;

case 'UpdateAtb':

	list($p_fk_bot_name, $p_fk_typ_name, $p_name, $p_primary_key, $p_code_display_key, $p_code_foreign_key, $p_flag_hidden, $p_default_value, $p_unchangeable, $p_xk_itp_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_atb (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_primary_key,
		:p_code_display_key,
		:p_code_foreign_key,
		:p_flag_hidden,
		:p_default_value,
		:p_unchangeable,
		:p_xk_itp_name);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_primary_key",$p_primary_key);
	oci_bind_by_name($stid,":p_code_display_key",$p_code_display_key);
	oci_bind_by_name($stid,":p_code_foreign_key",$p_code_foreign_key);
	oci_bind_by_name($stid,":p_flag_hidden",$p_flag_hidden);
	oci_bind_by_name($stid,":p_default_value",$p_default_value);
	oci_bind_by_name($stid,":p_unchangeable",$p_unchangeable);
	oci_bind_by_name($stid,":p_xk_itp_name",$p_xk_itp_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_ATB";
	break;

case 'DeleteAtb':

	list($p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_atb (
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_ATB";
	break;

case 'GetDer':

	list($p_fk_typ_name, $p_fk_atb_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_der (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_atb_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_DER";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["CUBE_TSG_TYPE"]."<|>".$row["AGGREGATE_FUNCTION"]."<|>".$row["XK_TYP_NAME"]."<|>".$row["XK_TYP_NAME_1"];
	}
	break;

case 'CreateDer':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_atb_name, $p_cube_tsg_type, $p_aggregate_function, $p_xk_typ_name, $p_xk_typ_name_1) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_der (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_cube_tsg_type,
		:p_aggregate_function,
		:p_xk_typ_name,
		:p_xk_typ_name_1);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);
	oci_bind_by_name($stid,":p_cube_tsg_type",$p_cube_tsg_type);
	oci_bind_by_name($stid,":p_aggregate_function",$p_aggregate_function);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);
	oci_bind_by_name($stid,":p_xk_typ_name_1",$p_xk_typ_name_1);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_DER";
	break;

case 'UpdateDer':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_atb_name, $p_cube_tsg_type, $p_aggregate_function, $p_xk_typ_name, $p_xk_typ_name_1) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_der (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_cube_tsg_type,
		:p_aggregate_function,
		:p_xk_typ_name,
		:p_xk_typ_name_1);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);
	oci_bind_by_name($stid,":p_cube_tsg_type",$p_cube_tsg_type);
	oci_bind_by_name($stid,":p_aggregate_function",$p_aggregate_function);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);
	oci_bind_by_name($stid,":p_xk_typ_name_1",$p_xk_typ_name_1);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_DER";
	break;

case 'DeleteDer':

	list($p_fk_typ_name, $p_fk_atb_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_der (
		:p_fk_typ_name,
		:p_fk_atb_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_DER";
	break;

case 'GetDca':

	list($p_fk_typ_name, $p_fk_atb_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_dca (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_atb_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_DCA";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["TEXT"];
	}
	break;

case 'CreateDca':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_atb_name, $p_text) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_dca (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);
	oci_bind_by_name($stid,":p_text",$p_text);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_DCA";
	break;

case 'UpdateDca':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_atb_name, $p_text) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_dca (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);
	oci_bind_by_name($stid,":p_text",$p_text);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_DCA";
	break;

case 'DeleteDca':

	list($p_fk_typ_name, $p_fk_atb_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_dca (
		:p_fk_typ_name,
		:p_fk_atb_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_DCA";
	break;

case 'GetRta':

	list($p_fk_typ_name, $p_fk_atb_name, $p_xf_tsp_typ_name, $p_xf_tsp_tsg_code, $p_xk_tsp_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_rta (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$p_xf_tsp_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$p_xf_tsp_tsg_code);
	oci_bind_by_name($stid,":p_xk_tsp_code",$p_xk_tsp_code);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_RTA";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["INCLUDE_OR_EXCLUDE"];
	}
	break;

case 'CreateRta':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_atb_name, $p_include_or_exclude, $p_xf_tsp_typ_name, $p_xf_tsp_tsg_code, $p_xk_tsp_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_rta (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);
	oci_bind_by_name($stid,":p_include_or_exclude",$p_include_or_exclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$p_xf_tsp_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$p_xf_tsp_tsg_code);
	oci_bind_by_name($stid,":p_xk_tsp_code",$p_xk_tsp_code);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "CREATE_RTA";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_ATB_NAME"]."<|>".$row["XF_TSP_TYP_NAME"]."<|>".$row["XF_TSP_TSG_CODE"]."<|>".$row["XK_TSP_CODE"];
	}
	break;

case 'UpdateRta':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_atb_name, $p_include_or_exclude, $p_xf_tsp_typ_name, $p_xf_tsp_tsg_code, $p_xk_tsp_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_rta (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);
	oci_bind_by_name($stid,":p_include_or_exclude",$p_include_or_exclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$p_xf_tsp_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$p_xf_tsp_tsg_code);
	oci_bind_by_name($stid,":p_xk_tsp_code",$p_xk_tsp_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_RTA";
	break;

case 'DeleteRta':

	list($p_fk_typ_name, $p_fk_atb_name, $p_xf_tsp_typ_name, $p_xf_tsp_tsg_code, $p_xk_tsp_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_rta (
		:p_fk_typ_name,
		:p_fk_atb_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_atb_name",$p_fk_atb_name);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$p_xf_tsp_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$p_xf_tsp_tsg_code);
	oci_bind_by_name($stid,":p_xk_tsp_code",$p_xk_tsp_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_RTA";
	break;

case 'GetRef':

	list($p_fk_typ_name, $p_sequence, $p_xk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_ref (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_REF";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["NAME"]."<|>".$row["PRIMARY_KEY"]."<|>".$row["CODE_DISPLAY_KEY"]."<|>".$row["SCOPE"]."<|>".$row["UNCHANGEABLE"]."<|>".$row["WITHIN_SCOPE_LEVEL"]."<|>".$row["XK_TYP_NAME_1"];
	}
	break;

case 'GetRefFkey':

	list($p_fk_typ_name, $p_sequence, $p_xk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_ref_fkey (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_FKEY_REF";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"];
	}
	break;

case 'GetRefItems':

	list($p_fk_typ_name, $p_sequence, $p_xk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_ref_dcr_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_DCR";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_REF_SEQUENCE"]."<|>".$row["FK_REF_TYP_NAME"];
		echo "<||>";
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_ref_rtr_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_RTR";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_REF_SEQUENCE"]."<|>".$row["FK_REF_TYP_NAME"]."<|>".$row["XF_TSP_TYP_NAME"]."<|>".$row["XF_TSP_TSG_CODE"]."<|>".$row["XK_TSP_CODE"];
		echo "<||>".$row["XF_TSP_TYP_NAME"]." ".$row["XF_TSP_TSG_CODE"]." ".$row["XK_TSP_CODE"];
	}
	break;

case 'CountRefRestrictedItems':

	list($p_fk_typ_name, $p_sequence, $p_xk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_ref_dcr (
		:p_cube_row,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "COUNT_DCR";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["TYPE_COUNT"];
	}
	break;

case 'MoveRef':

	list($p_cube_pos_action, $p_fk_typ_name, $p_sequence, $p_xk_typ_name, $x_fk_typ_name, $x_sequence, $x_xk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_ref (
		:p_cube_pos_action,
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_typ_name,
		:x_fk_typ_name,
		:x_sequence,
		:x_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_sequence",$x_sequence);
	oci_bind_by_name($stid,":x_xk_typ_name",$x_xk_typ_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "MOVE_REF";
	break;

case 'CreateRef':

	list($p_cube_pos_action, $p_fk_bot_name, $p_fk_typ_name, $p_name, $p_primary_key, $p_code_display_key, $p_sequence, $p_scope, $p_unchangeable, $p_within_scope_level, $p_xk_typ_name, $p_xk_typ_name_1, $x_fk_typ_name, $x_sequence, $x_xk_typ_name) = explode("<|>", $import[1]."<|><|><|>");

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_ref (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_primary_key,
		:p_code_display_key,
		:p_sequence,
		:p_scope,
		:p_unchangeable,
		:p_within_scope_level,
		:p_xk_typ_name,
		:p_xk_typ_name_1,
		:x_fk_typ_name,
		:x_sequence,
		:x_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_primary_key",$p_primary_key);
	oci_bind_by_name($stid,":p_code_display_key",$p_code_display_key);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_scope",$p_scope);
	oci_bind_by_name($stid,":p_unchangeable",$p_unchangeable);
	oci_bind_by_name($stid,":p_within_scope_level",$p_within_scope_level);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);
	oci_bind_by_name($stid,":p_xk_typ_name_1",$p_xk_typ_name_1);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_sequence",$x_sequence);
	oci_bind_by_name($stid,":x_xk_typ_name",$x_xk_typ_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_REF";
	break;

case 'UpdateRef':

	list($p_fk_bot_name, $p_fk_typ_name, $p_name, $p_primary_key, $p_code_display_key, $p_sequence, $p_scope, $p_unchangeable, $p_within_scope_level, $p_xk_typ_name, $p_xk_typ_name_1) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_ref (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name,
		:p_primary_key,
		:p_code_display_key,
		:p_sequence,
		:p_scope,
		:p_unchangeable,
		:p_within_scope_level,
		:p_xk_typ_name,
		:p_xk_typ_name_1);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_primary_key",$p_primary_key);
	oci_bind_by_name($stid,":p_code_display_key",$p_code_display_key);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_scope",$p_scope);
	oci_bind_by_name($stid,":p_unchangeable",$p_unchangeable);
	oci_bind_by_name($stid,":p_within_scope_level",$p_within_scope_level);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);
	oci_bind_by_name($stid,":p_xk_typ_name_1",$p_xk_typ_name_1);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_REF";
	break;

case 'DeleteRef':

	list($p_fk_typ_name, $p_sequence, $p_xk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_ref (
		:p_fk_typ_name,
		:p_sequence,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_sequence",$p_sequence);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_REF";
	break;

case 'GetDcr':

	list($p_fk_typ_name, $p_fk_ref_sequence, $p_fk_ref_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_dcr (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$p_fk_ref_sequence);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$p_fk_ref_typ_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_DCR";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["TEXT"];
	}
	break;

case 'CreateDcr':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_ref_sequence, $p_fk_ref_typ_name, $p_text) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_dcr (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_typ_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$p_fk_ref_sequence);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$p_fk_ref_typ_name);
	oci_bind_by_name($stid,":p_text",$p_text);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_DCR";
	break;

case 'UpdateDcr':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_ref_sequence, $p_fk_ref_typ_name, $p_text) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_dcr (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_typ_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$p_fk_ref_sequence);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$p_fk_ref_typ_name);
	oci_bind_by_name($stid,":p_text",$p_text);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_DCR";
	break;

case 'DeleteDcr':

	list($p_fk_typ_name, $p_fk_ref_sequence, $p_fk_ref_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_dcr (
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$p_fk_ref_sequence);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$p_fk_ref_typ_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_DCR";
	break;

case 'GetRtr':

	list($p_fk_typ_name, $p_fk_ref_sequence, $p_fk_ref_typ_name, $p_xf_tsp_typ_name, $p_xf_tsp_tsg_code, $p_xk_tsp_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_rtr (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_typ_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$p_fk_ref_sequence);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$p_fk_ref_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$p_xf_tsp_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$p_xf_tsp_tsg_code);
	oci_bind_by_name($stid,":p_xk_tsp_code",$p_xk_tsp_code);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_RTR";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["INCLUDE_OR_EXCLUDE"];
	}
	break;

case 'CreateRtr':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_ref_sequence, $p_fk_ref_typ_name, $p_include_or_exclude, $p_xf_tsp_typ_name, $p_xf_tsp_tsg_code, $p_xk_tsp_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_rtr (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_typ_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$p_fk_ref_sequence);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$p_fk_ref_typ_name);
	oci_bind_by_name($stid,":p_include_or_exclude",$p_include_or_exclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$p_xf_tsp_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$p_xf_tsp_tsg_code);
	oci_bind_by_name($stid,":p_xk_tsp_code",$p_xk_tsp_code);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "CREATE_RTR";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_REF_SEQUENCE"]."<|>".$row["FK_REF_TYP_NAME"]."<|>".$row["XF_TSP_TYP_NAME"]."<|>".$row["XF_TSP_TSG_CODE"]."<|>".$row["XK_TSP_CODE"];
	}
	break;

case 'UpdateRtr':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_ref_sequence, $p_fk_ref_typ_name, $p_include_or_exclude, $p_xf_tsp_typ_name, $p_xf_tsp_tsg_code, $p_xk_tsp_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_rtr (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_typ_name,
		:p_include_or_exclude,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$p_fk_ref_sequence);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$p_fk_ref_typ_name);
	oci_bind_by_name($stid,":p_include_or_exclude",$p_include_or_exclude);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$p_xf_tsp_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$p_xf_tsp_tsg_code);
	oci_bind_by_name($stid,":p_xk_tsp_code",$p_xk_tsp_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_RTR";
	break;

case 'DeleteRtr':

	list($p_fk_typ_name, $p_fk_ref_sequence, $p_fk_ref_typ_name, $p_xf_tsp_typ_name, $p_xf_tsp_tsg_code, $p_xk_tsp_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_rtr (
		:p_fk_typ_name,
		:p_fk_ref_sequence,
		:p_fk_ref_typ_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_ref_sequence",$p_fk_ref_sequence);
	oci_bind_by_name($stid,":p_fk_ref_typ_name",$p_fk_ref_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$p_xf_tsp_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$p_xf_tsp_tsg_code);
	oci_bind_by_name($stid,":p_xk_tsp_code",$p_xk_tsp_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_RTR";
	break;

case 'GetTyr':

	list($p_fk_typ_name, $p_xk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tyr (
		:p_cube_row,
		:p_fk_typ_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_TYR";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["CARDINALITY"];
	}
	break;

case 'CreateTyr':

	list($p_fk_bot_name, $p_fk_typ_name, $p_cardinality, $p_xk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_tyr (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_cardinality,
		:p_xk_typ_name,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_cardinality",$p_cardinality);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "CREATE_TYR";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["XK_TYP_NAME"];
	}
	break;

case 'UpdateTyr':

	list($p_fk_bot_name, $p_fk_typ_name, $p_cardinality, $p_xk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_tyr (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_cardinality,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_cardinality",$p_cardinality);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_TYR";
	break;

case 'DeleteTyr':

	list($p_fk_typ_name, $p_xk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_tyr (
		:p_fk_typ_name,
		:p_xk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_xk_typ_name",$p_xk_typ_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_TYR";
	break;

case 'GetPar':

	list($p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_par (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_PAR";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"];
	}
	break;

case 'GetParFkey':

	list($p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_par_fkey (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_FKEY_PAR";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"];
	}
	break;

case 'GetParItems':

	list($p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_par_stp_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_STP";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_PAR_NAME"]."<|>".$row["NAME"];
		echo "<||>".$row["NAME"];
	}
	break;

case 'CreatePar':

	list($p_fk_bot_name, $p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_par (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_PAR";
	break;

case 'UpdatePar':

	list($p_fk_bot_name, $p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_par (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_PAR";
	break;

case 'DeletePar':

	list($p_fk_typ_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_par (
		:p_fk_typ_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_PAR";
	break;

case 'GetStp':

	list($p_fk_typ_name, $p_fk_par_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_stp (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_par_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_par_name",$p_fk_par_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_STP";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"];
	}
	break;

case 'MoveStp':

	list($p_cube_pos_action, $p_fk_typ_name, $p_fk_par_name, $p_name, $x_fk_typ_name, $x_fk_par_name, $x_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_stp (
		:p_cube_pos_action,
		:p_fk_typ_name,
		:p_fk_par_name,
		:p_name,
		:x_fk_typ_name,
		:x_fk_par_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_par_name",$p_fk_par_name);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_fk_par_name",$x_fk_par_name);
	oci_bind_by_name($stid,":x_name",$x_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "MOVE_STP";
	break;

case 'CreateStp':

	list($p_cube_pos_action, $p_fk_bot_name, $p_fk_typ_name, $p_fk_par_name, $p_name, $x_fk_typ_name, $x_fk_par_name, $x_name) = explode("<|>", $import[1]."<|><|><|>");

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_stp (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_par_name,
		:p_name,
		:x_fk_typ_name,
		:x_fk_par_name,
		:x_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_par_name",$p_fk_par_name);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_fk_par_name",$x_fk_par_name);
	oci_bind_by_name($stid,":x_name",$x_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_STP";
	break;

case 'UpdateStp':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_par_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_stp (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_par_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_par_name",$p_fk_par_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_STP";
	break;

case 'DeleteStp':

	list($p_fk_typ_name, $p_fk_par_name, $p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_stp (
		:p_fk_typ_name,
		:p_fk_par_name,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_par_name",$p_fk_par_name);
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_STP";
	break;

case 'GetTsg':

	list($p_fk_typ_name, $p_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsg (
		:p_cube_row,
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_code",$p_code);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_TSG";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["FK_TSG_CODE"]."<|>".$row["NAME"]."<|>".$row["PRIMARY_KEY"];
	}
	break;

case 'GetTsgFkey':

	list($p_fk_typ_name, $p_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsg_fkey (
		:p_cube_row,
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_code",$p_code);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_FKEY_TSG";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"];
	}
	break;

case 'GetTsgItems':

	list($p_fk_typ_name, $p_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsg_tsp_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_code",$p_code);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_TSP";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_TSG_CODE"]."<|>".$row["CODE"];
		echo "<||>"."(".$row["CODE"].")"." ".$row["NAME"];
	}
	echo "<||||>";

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsg_tsg_items (
		:p_cube_row,
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_code",$p_code);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_TSG";}
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["CODE"];
		echo "<||>"."(".$row["CODE"].")"." ".$row["NAME"];
	}
	break;

case 'CountTsgRestrictedItems':

	list($p_fk_typ_name, $p_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.count_tsg_tsg (
		:p_cube_row,
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_code",$p_code);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "COUNT_TSG";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["TYPE_COUNT"];
	}
	break;

case 'MoveTsg':

	list($p_cube_pos_action, $p_fk_typ_name, $p_code, $x_fk_typ_name, $x_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_tsg (
		:p_cube_pos_action,
		:p_fk_typ_name,
		:p_code,
		:x_fk_typ_name,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_code",$x_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "MOVE_TSG";
	break;

case 'CreateTsg':

	list($p_cube_pos_action, $p_fk_bot_name, $p_fk_typ_name, $p_fk_tsg_code, $p_code, $p_name, $p_primary_key, $x_fk_typ_name, $x_code) = explode("<|>", $import[1]."<|><|>");

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_tsg (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code,
		:p_name,
		:p_primary_key,
		:x_fk_typ_name,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_tsg_code",$p_fk_tsg_code);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_primary_key",$p_primary_key);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_code",$x_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_TSG";
	break;

case 'UpdateTsg':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_tsg_code, $p_code, $p_name, $p_primary_key) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_tsg (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code,
		:p_name,
		:p_primary_key);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_tsg_code",$p_fk_tsg_code);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_primary_key",$p_primary_key);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_TSG";
	break;

case 'DeleteTsg':

	list($p_fk_typ_name, $p_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_tsg (
		:p_fk_typ_name,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_code",$p_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_TSG";
	break;

case 'GetTspForTypList':

	list($p_cube_scope_level, $x_fk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsp_for_typ_list (
		:p_cube_row,
		:p_cube_scope_level,
		:x_fk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_cube_scope_level",$p_cube_scope_level);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_TSP";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_TSG_CODE"]."<|>".$row["CODE"];
		echo "<||>".$row["FK_TYP_NAME"]." ".$row["FK_TSG_CODE"]." (".$row["CODE"].")"." ".$row["NAME"];
	}
	break;

case 'GetTspForTsgList':

	list($p_cube_scope_level, $x_fk_typ_name, $x_fk_tsg_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsp_for_tsg_list (
		:p_cube_row,
		:p_cube_scope_level,
		:x_fk_typ_name,
		:x_fk_tsg_code);
	END;");
	oci_bind_by_name($stid,":p_cube_scope_level",$p_cube_scope_level);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_fk_tsg_code",$x_fk_tsg_code);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_TSP";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_TYP_NAME"]."<|>".$row["FK_TSG_CODE"]."<|>".$row["CODE"];
		echo "<||>".$row["FK_TYP_NAME"]." ".$row["FK_TSG_CODE"]." (".$row["CODE"].")"." ".$row["NAME"];
	}
	break;

case 'GetTsp':

	list($p_fk_typ_name, $p_fk_tsg_code, $p_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_tsp (
		:p_cube_row,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_tsg_code",$p_fk_tsg_code);
	oci_bind_by_name($stid,":p_code",$p_code);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_TSP";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["NAME"]."<|>".$row["XF_TSP_TYP_NAME"]."<|>".$row["XF_TSP_TSG_CODE"]."<|>".$row["XK_TSP_CODE"];
	}
	break;

case 'MoveTsp':

	list($p_cube_pos_action, $p_fk_typ_name, $p_fk_tsg_code, $p_code, $x_fk_typ_name, $x_fk_tsg_code, $x_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.move_tsp (
		:p_cube_pos_action,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code,
		:x_fk_typ_name,
		:x_fk_tsg_code,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_tsg_code",$p_fk_tsg_code);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_fk_tsg_code",$x_fk_tsg_code);
	oci_bind_by_name($stid,":x_code",$x_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "MOVE_TSP";
	break;

case 'CreateTsp':

	list($p_cube_pos_action, $p_fk_bot_name, $p_fk_typ_name, $p_fk_tsg_code, $p_code, $p_name, $p_xf_tsp_typ_name, $p_xf_tsp_tsg_code, $p_xk_tsp_code, $x_fk_typ_name, $x_fk_tsg_code, $x_code) = explode("<|>", $import[1]."<|><|><|>");

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_tsp (
		:p_cube_pos_action,
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code,
		:p_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code,
		:x_fk_typ_name,
		:x_fk_tsg_code,
		:x_code);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_tsg_code",$p_fk_tsg_code);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$p_xf_tsp_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$p_xf_tsp_tsg_code);
	oci_bind_by_name($stid,":p_xk_tsp_code",$p_xk_tsp_code);
	oci_bind_by_name($stid,":x_fk_typ_name",$x_fk_typ_name);
	oci_bind_by_name($stid,":x_fk_tsg_code",$x_fk_tsg_code);
	oci_bind_by_name($stid,":x_code",$x_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_TSP";
	break;

case 'UpdateTsp':

	list($p_fk_bot_name, $p_fk_typ_name, $p_fk_tsg_code, $p_code, $p_name, $p_xf_tsp_typ_name, $p_xf_tsp_tsg_code, $p_xk_tsp_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_tsp (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code,
		:p_name,
		:p_xf_tsp_typ_name,
		:p_xf_tsp_tsg_code,
		:p_xk_tsp_code);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_tsg_code",$p_fk_tsg_code);
	oci_bind_by_name($stid,":p_code",$p_code);
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_xf_tsp_typ_name",$p_xf_tsp_typ_name);
	oci_bind_by_name($stid,":p_xf_tsp_tsg_code",$p_xf_tsp_tsg_code);
	oci_bind_by_name($stid,":p_xk_tsp_code",$p_xk_tsp_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_TSP";
	break;

case 'DeleteTsp':

	list($p_fk_typ_name, $p_fk_tsg_code, $p_code) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_tsp (
		:p_fk_typ_name,
		:p_fk_tsg_code,
		:p_code);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_fk_tsg_code",$p_fk_tsg_code);
	oci_bind_by_name($stid,":p_code",$p_code);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_TSP";
	break;

case 'GetDct':

	list($p_fk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.get_dct (
		:p_cube_row,
		:p_fk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_DCT";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["FK_BOT_NAME"]."<|>".$row["TEXT"];
	}
	break;

case 'CreateDct':

	list($p_fk_bot_name, $p_fk_typ_name, $p_text) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.insert_dct (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_text",$p_text);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_DCT";
	break;

case 'UpdateDct':

	list($p_fk_bot_name, $p_fk_typ_name, $p_text) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.update_dct (
		:p_fk_bot_name,
		:p_fk_typ_name,
		:p_text);
	END;");
	oci_bind_by_name($stid,":p_fk_bot_name",$p_fk_bot_name);
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);
	oci_bind_by_name($stid,":p_text",$p_text);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_DCT";
	break;

case 'DeleteDct':

	list($p_fk_typ_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_bot.delete_dct (
		:p_fk_typ_name);
	END;");
	oci_bind_by_name($stid,":p_fk_typ_name",$p_fk_typ_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_DCT";
	break;

case 'GetDirSysItems':

	$stid = oci_parse($conn, "BEGIN pkg_sys.get_sys_root_items (:p_cube_row); END;");
	$r = perform_db_request();
	if (!$r) { return; }
	echo "LIST_SYS";
	while ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAME"];
		echo "<||>".$row["NAME"];
	}
	break;

case 'GetSys':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_sys.get_sys (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "SELECT_SYS";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["DATABASE"]."<|>".$row["SCHEMA"]."<|>".$row["PASSWORD"];
	}
	break;

case 'GetSysItems':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_sys.get_sys_sbt_items (
		:p_cube_row,
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = perform_db_request();
	if (!$r) { return; }
	$first = True;
	while ($row = oci_fetch_assoc($curs)) {
		if ($first) { $first = False; echo "LIST_SBT";}
		echo "<|||>".$row["FK_SYS_NAME"]."<|>".$row["XK_BOT_NAME"];
		echo "<||>".$row["XK_BOT_NAME"];
	}
	break;

case 'CreateSys':

	list($p_name, $p_database, $p_schema, $p_password) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_sys.insert_sys (
		:p_name,
		:p_database,
		:p_schema,
		:p_password,
		:p_cube_row);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_database",$p_database);
	oci_bind_by_name($stid,":p_schema",$p_schema);
	oci_bind_by_name($stid,":p_password",$p_password);

	$r = perform_db_request();
	if (!$r) { return; }
	echo "CREATE_SYS";
	if ($row = oci_fetch_assoc($curs)) {
		echo "<|||>".$row["NAME"];
	}
	break;

case 'UpdateSys':

	list($p_name, $p_database, $p_schema, $p_password) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_sys.update_sys (
		:p_name,
		:p_database,
		:p_schema,
		:p_password);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);
	oci_bind_by_name($stid,":p_database",$p_database);
	oci_bind_by_name($stid,":p_schema",$p_schema);
	oci_bind_by_name($stid,":p_password",$p_password);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "UPDATE_SYS";
	break;

case 'DeleteSys':

	list($p_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_sys.delete_sys (
		:p_name);
	END;");
	oci_bind_by_name($stid,":p_name",$p_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_SYS";
	break;

case 'MoveSbt':

	list($p_cube_pos_action, $p_fk_sys_name, $p_xk_bot_name, $x_fk_sys_name, $x_xk_bot_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_sys.move_sbt (
		:p_cube_pos_action,
		:p_fk_sys_name,
		:p_xk_bot_name,
		:x_fk_sys_name,
		:x_xk_bot_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_sys_name",$p_fk_sys_name);
	oci_bind_by_name($stid,":p_xk_bot_name",$p_xk_bot_name);
	oci_bind_by_name($stid,":x_fk_sys_name",$x_fk_sys_name);
	oci_bind_by_name($stid,":x_xk_bot_name",$x_xk_bot_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "MOVE_SBT";
	break;

case 'CreateSbt':

	list($p_cube_pos_action, $p_fk_sys_name, $p_xk_bot_name, $x_fk_sys_name, $x_xk_bot_name) = explode("<|>", $import[1]."<|><|>");

	$stid = oci_parse($conn, "BEGIN pkg_sys.insert_sbt (
		:p_cube_pos_action,
		:p_fk_sys_name,
		:p_xk_bot_name,
		:x_fk_sys_name,
		:x_xk_bot_name);
	END;");
	oci_bind_by_name($stid,":p_cube_pos_action",$p_cube_pos_action);
	oci_bind_by_name($stid,":p_fk_sys_name",$p_fk_sys_name);
	oci_bind_by_name($stid,":p_xk_bot_name",$p_xk_bot_name);
	oci_bind_by_name($stid,":x_fk_sys_name",$x_fk_sys_name);
	oci_bind_by_name($stid,":x_xk_bot_name",$x_xk_bot_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "CREATE_SBT";
	break;

case 'DeleteSbt':

	list($p_fk_sys_name, $p_xk_bot_name) = explode("<|>", $import[1]);

	$stid = oci_parse($conn, "BEGIN pkg_sys.delete_sbt (
		:p_fk_sys_name,
		:p_xk_bot_name);
	END;");
	oci_bind_by_name($stid,":p_fk_sys_name",$p_fk_sys_name);
	oci_bind_by_name($stid,":p_xk_bot_name",$p_xk_bot_name);

	$r = oci_execute($stid);
	if (!$r) {
		ProcessDbError($stid);
		return;
	}
	echo "DELETE_SBT";
	break;

default:
	echo "ERROR<|||>";
	echo file_get_contents('php://input');
}

function perform_db_request()
{
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
		ProcessDbError($stid);
		return false;
	}
	return true;
}

function ProcessDbError($stid) {
	$e = oci_error($stid);
	echo "ERROR<|||>ORA-error: ".$e['code'].": ".$e['message'];
}

function CubeError($errno, $errstr) {
	if ($errno > 2) {
		echo "Error: [$errno] $errstr";   
	}
}
?>