-- CUBEDOCU Packages
--
BEGIN
	FOR r_p IN (
		SELECT object_name
		FROM user_procedures
		WHERE procedure_name = 'CUBE_PKG_CUBEDOCU' )
	LOOP
		EXECUTE IMMEDIATE 'DROP PACKAGE '||r_p.object_name;
	END LOOP;
END;
/
CREATE OR REPLACE PACKAGE pkg_cube IS
	FUNCTION cube_pkg_cubedocu RETURN VARCHAR2;
	FUNCTION years(p_date DATE) RETURN NUMBER;
	FUNCTION multiply(p_num_1 NUMBER, p_num_2 NUMBER) RETURN NUMBER;
	FUNCTION add(p_num_1 NUMBER, p_num_2 NUMBER) RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY pkg_cube IS
	FUNCTION cube_pkg_cubedocu RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubedocu';
	END;
	FUNCTION years(p_date DATE) RETURN NUMBER IS
	BEGIN
		RETURN (TRUNC(MONTHS_BETWEEN (CURRENT_DATE, p_date) / 12));
	END;
	FUNCTION multiply(p_num_1 NUMBER, p_num_2 NUMBER) RETURN NUMBER IS
	BEGIN
		RETURN (p_num_1 * p_num_2);
	END;
	FUNCTION add(p_num_1 NUMBER, p_num_2 NUMBER) RETURN NUMBER IS
	BEGIN
		RETURN (p_num_1 + p_num_2);
	END;
END;
/
CREATE OR REPLACE PACKAGE pkg_itp IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_pkg_cubedocu RETURN VARCHAR2;
	PROCEDURE get_itp_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_itp_list (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_itp_ite_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE insert_itp (
			p_name IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE delete_itp (
			p_name IN VARCHAR2);
	PROCEDURE get_ite (
			p_cube_row IN OUT c_cube_row,
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER);
	PROCEDURE get_ite_val_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER);
	PROCEDURE insert_ite (
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_suffix IN VARCHAR2,
			p_domain IN VARCHAR2,
			p_length IN NUMBER,
			p_decimals IN NUMBER,
			p_case_sensitive IN CHAR,
			p_default_value IN VARCHAR2,
			p_spaces_allowed IN CHAR,
			p_presentation IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_ite (
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_suffix IN VARCHAR2,
			p_domain IN VARCHAR2,
			p_length IN NUMBER,
			p_decimals IN NUMBER,
			p_case_sensitive IN CHAR,
			p_default_value IN VARCHAR2,
			p_spaces_allowed IN CHAR,
			p_presentation IN VARCHAR2);
	PROCEDURE delete_ite (
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER);
	PROCEDURE get_val (
			p_cube_row IN OUT c_cube_row,
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2);
	PROCEDURE move_val (
			p_cube_pos_action IN VARCHAR2,
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2,
			x_fk_itp_name IN VARCHAR2,
			x_fk_ite_sequence IN NUMBER,
			x_code IN VARCHAR2);
	PROCEDURE insert_val (
			p_cube_pos_action IN VARCHAR2,
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2,
			p_prompt IN VARCHAR2,
			x_fk_itp_name IN VARCHAR2,
			x_fk_ite_sequence IN NUMBER,
			x_code IN VARCHAR2);
	PROCEDURE update_val (
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2,
			p_prompt IN VARCHAR2);
	PROCEDURE delete_val (
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_itp IS
	FUNCTION cube_pkg_cubedocu RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubedocu';
	END;

	PROCEDURE get_itp_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  name
			FROM v_information_type
			ORDER BY name;
	END;

	PROCEDURE get_itp_list (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  name
			FROM v_information_type
			ORDER BY name;
	END;

	PROCEDURE get_itp_ite_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_itp_name,
			  sequence,
			  suffix,
			  domain
			FROM v_information_type_element
			WHERE fk_itp_name = p_name
			ORDER BY fk_itp_name, sequence, suffix, domain;
	END;

	PROCEDURE get_next_itp (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  name
			FROM v_information_type
			WHERE name > p_name
			ORDER BY name;
	END;

	PROCEDURE insert_itp (
			p_name IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_information_type (
			cube_id,
			name)
		VALUES (
			NULL,
			p_name);

		get_next_itp (p_cube_row, p_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type information_type already exists');
	END;

	PROCEDURE delete_itp (
			p_name IN VARCHAR2) IS
	BEGIN
		DELETE v_information_type
		WHERE name = p_name;
	END;

	PROCEDURE get_ite (
			p_cube_row IN OUT c_cube_row,
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  suffix,
			  domain,
			  length,
			  decimals,
			  case_sensitive,
			  default_value,
			  spaces_allowed,
			  presentation
			FROM v_information_type_element
			WHERE fk_itp_name = p_fk_itp_name
			  AND sequence = p_sequence;
	END;

	PROCEDURE get_ite_val_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_itp_name,
			  fk_ite_sequence,
			  code,
			  prompt
			FROM v_permitted_value
			WHERE fk_itp_name = p_fk_itp_name
			  AND fk_ite_sequence = p_sequence
			ORDER BY fk_itp_name, fk_ite_sequence, cube_sequence;
	END;

	PROCEDURE get_next_ite (
			p_cube_row IN OUT c_cube_row,
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_itp_name,
			  sequence
			FROM v_information_type_element
			WHERE fk_itp_name > p_fk_itp_name
			   OR 	    ( fk_itp_name = p_fk_itp_name
				  AND sequence > p_sequence )
			ORDER BY fk_itp_name, sequence;
	END;

	PROCEDURE insert_ite (
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_suffix IN VARCHAR2,
			p_domain IN VARCHAR2,
			p_length IN NUMBER,
			p_decimals IN NUMBER,
			p_case_sensitive IN CHAR,
			p_default_value IN VARCHAR2,
			p_spaces_allowed IN CHAR,
			p_presentation IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_information_type_element (
			cube_id,
			fk_itp_name,
			sequence,
			suffix,
			domain,
			length,
			decimals,
			case_sensitive,
			default_value,
			spaces_allowed,
			presentation)
		VALUES (
			NULL,
			p_fk_itp_name,
			p_sequence,
			p_suffix,
			p_domain,
			p_length,
			p_decimals,
			p_case_sensitive,
			p_default_value,
			p_spaces_allowed,
			p_presentation);

		get_next_ite (p_cube_row, p_fk_itp_name, p_sequence);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type information_type_element already exists');
	END;

	PROCEDURE update_ite (
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_suffix IN VARCHAR2,
			p_domain IN VARCHAR2,
			p_length IN NUMBER,
			p_decimals IN NUMBER,
			p_case_sensitive IN CHAR,
			p_default_value IN VARCHAR2,
			p_spaces_allowed IN CHAR,
			p_presentation IN VARCHAR2) IS
	BEGIN
		UPDATE v_information_type_element SET
			suffix = p_suffix,
			domain = p_domain,
			length = p_length,
			decimals = p_decimals,
			case_sensitive = p_case_sensitive,
			default_value = p_default_value,
			spaces_allowed = p_spaces_allowed,
			presentation = p_presentation
		WHERE fk_itp_name = p_fk_itp_name
		  AND sequence = p_sequence;
	END;

	PROCEDURE delete_ite (
			p_fk_itp_name IN VARCHAR2,
			p_sequence IN NUMBER) IS
	BEGIN
		DELETE v_information_type_element
		WHERE fk_itp_name = p_fk_itp_name
		  AND sequence = p_sequence;
	END;

	PROCEDURE get_val (
			p_cube_row IN OUT c_cube_row,
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  prompt
			FROM v_permitted_value
			WHERE fk_itp_name = p_fk_itp_name
			  AND fk_ite_sequence = p_fk_ite_sequence
			  AND code = p_code;
	END;

	PROCEDURE determine_position_val (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_permitted_value
				WHERE fk_itp_name = p_fk_itp_name
				  AND fk_ite_sequence = p_fk_ite_sequence
				  AND code = p_code;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_permitted_value
			WHERE fk_itp_name = p_fk_itp_name
			  AND fk_ite_sequence = p_fk_ite_sequence
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_val IN (
					SELECT
					  rowid row_id
					FROM v_permitted_value
					WHERE fk_itp_name = p_fk_itp_name
					  AND fk_ite_sequence = p_fk_ite_sequence
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_permitted_value SET
						cube_sequence = l_cube_count
					WHERE rowid = r_val.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_val (
			p_cube_pos_action IN VARCHAR2,
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2,
			x_fk_itp_name IN VARCHAR2,
			x_fk_ite_sequence IN NUMBER,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_val (l_cube_sequence, p_cube_pos_action, x_fk_itp_name, x_fk_ite_sequence, x_code);
		UPDATE v_permitted_value SET
			cube_sequence = l_cube_sequence
		WHERE fk_itp_name = p_fk_itp_name
		  AND fk_ite_sequence = p_fk_ite_sequence
		  AND code = p_code;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type permitted_value not found');
		END IF;
	END;

	PROCEDURE insert_val (
			p_cube_pos_action IN VARCHAR2,
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2,
			p_prompt IN VARCHAR2,
			x_fk_itp_name IN VARCHAR2,
			x_fk_ite_sequence IN NUMBER,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_val (l_cube_sequence, p_cube_pos_action, x_fk_itp_name, x_fk_ite_sequence, x_code);
		INSERT INTO v_permitted_value (
			cube_id,
			cube_sequence,
			fk_itp_name,
			fk_ite_sequence,
			code,
			prompt)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_itp_name,
			p_fk_ite_sequence,
			p_code,
			p_prompt);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type permitted_value already exists');
	END;

	PROCEDURE update_val (
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2,
			p_prompt IN VARCHAR2) IS
	BEGIN
		UPDATE v_permitted_value SET
			prompt = p_prompt
		WHERE fk_itp_name = p_fk_itp_name
		  AND fk_ite_sequence = p_fk_ite_sequence
		  AND code = p_code;
	END;

	PROCEDURE delete_val (
			p_fk_itp_name IN VARCHAR2,
			p_fk_ite_sequence IN NUMBER,
			p_code IN VARCHAR2) IS
	BEGIN
		DELETE v_permitted_value
		WHERE fk_itp_name = p_fk_itp_name
		  AND fk_ite_sequence = p_fk_ite_sequence
		  AND code = p_code;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE pkg_bot IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_pkg_cubedocu RETURN VARCHAR2;
	PROCEDURE get_bot_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_bot_list (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_bot (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_bot_typ_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE count_bot_typ (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE move_bot (
			p_cube_pos_action IN VARCHAR2,
			p_name IN VARCHAR2,
			x_name IN VARCHAR2);
	PROCEDURE insert_bot (
			p_cube_pos_action IN VARCHAR2,
			p_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_directory IN VARCHAR2,
			p_api_url IN VARCHAR2,
			x_name IN VARCHAR2);
	PROCEDURE update_bot (
			p_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_directory IN VARCHAR2,
			p_api_url IN VARCHAR2);
	PROCEDURE delete_bot (
			p_name IN VARCHAR2);
	PROCEDURE get_typ_list_all (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_typ_for_typ_list_all (
			p_cube_row IN OUT c_cube_row,
			p_cube_scope_level IN NUMBER,
			x_fk_typ_name IN VARCHAR2);
	PROCEDURE get_typ (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_fkey (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_tsg_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_atb_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_ref_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_rtt_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_jsn_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_dct_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_typ_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE count_typ_jsn (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE count_typ_dct (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE move_typ (
			p_cube_pos_action IN VARCHAR2,
			p_name IN VARCHAR2,
			x_name IN VARCHAR2);
	PROCEDURE insert_typ (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_code IN VARCHAR2,
			p_flag_partial_key IN CHAR,
			p_flag_recursive IN CHAR,
			p_recursive_cardinality IN CHAR,
			p_cardinality IN CHAR,
			p_sort_order IN CHAR,
			p_icon IN VARCHAR2,
			p_transferable IN CHAR,
			x_name IN VARCHAR2);
	PROCEDURE update_typ (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_code IN VARCHAR2,
			p_flag_partial_key IN CHAR,
			p_flag_recursive IN CHAR,
			p_recursive_cardinality IN CHAR,
			p_cardinality IN CHAR,
			p_sort_order IN CHAR,
			p_icon IN VARCHAR2,
			p_transferable IN CHAR);
	PROCEDURE delete_typ (
			p_name IN VARCHAR2);
	PROCEDURE get_tsg (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_tsg_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_tsg_tsp_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_tsg_tsg_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE count_tsg_tsg (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE move_tsg (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE insert_tsg (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE update_tsg (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2);
	PROCEDURE delete_tsg (
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_tsp_for_typ_list (
			p_cube_row IN OUT c_cube_row,
			p_cube_scope_level IN NUMBER,
			x_fk_typ_name IN VARCHAR2);
	PROCEDURE get_tsp_for_tsg_list (
			p_cube_row IN OUT c_cube_row,
			p_cube_scope_level IN NUMBER,
			x_fk_typ_name IN VARCHAR2,
			x_fk_tsg_code IN VARCHAR2);
	PROCEDURE get_tsp (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE move_tsp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_fk_tsg_code IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE insert_tsp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_fk_tsg_code IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE update_tsp (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE delete_tsp (
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_atb_for_typ_list (
			p_cube_row IN OUT c_cube_row,
			p_cube_scope_level IN NUMBER,
			x_fk_typ_name IN VARCHAR2);
	PROCEDURE get_atb (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE get_atb_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE get_atb_der_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE get_atb_dca_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE get_atb_rta_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE count_atb_der (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE count_atb_dca (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE move_atb (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_name IN VARCHAR2);
	PROCEDURE insert_atb (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_code_display_key IN CHAR,
			p_code_foreign_key IN CHAR,
			p_flag_hidden IN CHAR,
			p_default_value IN VARCHAR2,
			p_unchangeable IN CHAR,
			p_xk_itp_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_name IN VARCHAR2);
	PROCEDURE update_atb (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_code_display_key IN CHAR,
			p_code_foreign_key IN CHAR,
			p_flag_hidden IN CHAR,
			p_default_value IN VARCHAR2,
			p_unchangeable IN CHAR,
			p_xk_itp_name IN VARCHAR2);
	PROCEDURE delete_atb (
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE get_der (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2);
	PROCEDURE insert_der (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_aggregate_function IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2);
	PROCEDURE update_der (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_aggregate_function IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2);
	PROCEDURE delete_der (
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2);
	PROCEDURE get_dca (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2);
	PROCEDURE insert_dca (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_text IN VARCHAR2);
	PROCEDURE update_dca (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_text IN VARCHAR2);
	PROCEDURE delete_dca (
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2);
	PROCEDURE get_rta (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE insert_rta (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_rta (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE delete_rta (
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE get_ref (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_ref_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_ref_dcr_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_ref_rtr_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_ref_rts_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE count_ref_dcr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE count_ref_rts (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE move_ref (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_sequence IN NUMBER,
			x_xk_bot_name IN VARCHAR2,
			x_xk_typ_name IN VARCHAR2);
	PROCEDURE insert_ref (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_code_display_key IN CHAR,
			p_sequence IN NUMBER,
			p_scope IN VARCHAR2,
			p_unchangeable IN CHAR,
			p_within_scope_extension IN VARCHAR2,
			p_cube_tsg_int_ext IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_sequence IN NUMBER,
			x_xk_bot_name IN VARCHAR2,
			x_xk_typ_name IN VARCHAR2);
	PROCEDURE update_ref (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_code_display_key IN CHAR,
			p_sequence IN NUMBER,
			p_scope IN VARCHAR2,
			p_unchangeable IN CHAR,
			p_within_scope_extension IN VARCHAR2,
			p_cube_tsg_int_ext IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2);
	PROCEDURE delete_ref (
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_dcr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2);
	PROCEDURE insert_dcr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_text IN VARCHAR2);
	PROCEDURE update_dcr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_text IN VARCHAR2);
	PROCEDURE delete_dcr (
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2);
	PROCEDURE get_rtr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE insert_rtr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_rtr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE delete_rtr (
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE get_rts (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE insert_rts (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE update_rts (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE delete_rts (
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE get_rtt (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE insert_rtt (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_rtt (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE delete_rtt (
			p_fk_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE get_jsn (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_jsn_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_jsn_jsn_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE move_jsn (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_name IN VARCHAR2,
			x_location IN NUMBER,
			x_xf_atb_typ_name IN VARCHAR2,
			x_xk_atb_name IN VARCHAR2,
			x_xk_typ_name IN VARCHAR2);
	PROCEDURE insert_jsn (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_jsn_name IN VARCHAR2,
			p_fk_jsn_location IN NUMBER,
			p_fk_jsn_atb_typ_name IN VARCHAR2,
			p_fk_jsn_atb_name IN VARCHAR2,
			p_fk_jsn_typ_name IN VARCHAR2,
			p_cube_tsg_obj_arr IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_name IN VARCHAR2,
			x_location IN NUMBER,
			x_xf_atb_typ_name IN VARCHAR2,
			x_xk_atb_name IN VARCHAR2,
			x_xk_typ_name IN VARCHAR2);
	PROCEDURE update_jsn (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_jsn_name IN VARCHAR2,
			p_fk_jsn_location IN NUMBER,
			p_fk_jsn_atb_typ_name IN VARCHAR2,
			p_fk_jsn_atb_name IN VARCHAR2,
			p_fk_jsn_typ_name IN VARCHAR2,
			p_cube_tsg_obj_arr IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE delete_jsn (
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_dct (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2);
	PROCEDURE insert_dct (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_text IN VARCHAR2);
	PROCEDURE update_dct (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_text IN VARCHAR2);
	PROCEDURE delete_dct (
			p_fk_typ_name IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_bot IS
	FUNCTION cube_pkg_cubedocu RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubedocu';
	END;

	PROCEDURE get_bot_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  name,
			  cube_tsg_type
			FROM v_business_object_type
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_bot_list (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  name,
			  cube_tsg_type
			FROM v_business_object_type
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_bot (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_type,
			  directory,
			  api_url
			FROM v_business_object_type
			WHERE name = p_name;
	END;

	PROCEDURE get_bot_typ_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  name,
			  code
			FROM v_type
			WHERE fk_bot_name = p_name
			  AND fk_typ_name IS NULL
			ORDER BY cube_sequence;
	END;

	PROCEDURE count_bot_typ (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_type
			WHERE fk_bot_name = p_name
			  AND fk_typ_name IS NULL;
	END;

	PROCEDURE determine_position_bot (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_name IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_business_object_type
				WHERE name = p_name;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_business_object_type
			WHERE 	    ( l_cube_pos_action = 'B'
				  AND cube_sequence < l_cube_position_sequ )
			   OR 	    ( l_cube_pos_action = 'A'
				  AND cube_sequence > l_cube_position_sequ );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_bot IN (
					SELECT
					  rowid row_id
					FROM v_business_object_type
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_business_object_type SET
						cube_sequence = l_cube_count
					WHERE rowid = r_bot.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_bot (
			p_cube_pos_action IN VARCHAR2,
			p_name IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_bot (l_cube_sequence, p_cube_pos_action, x_name);
		UPDATE v_business_object_type SET
			cube_sequence = l_cube_sequence
		WHERE name = p_name;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type business_object_type not found');
		END IF;
	END;

	PROCEDURE insert_bot (
			p_cube_pos_action IN VARCHAR2,
			p_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_directory IN VARCHAR2,
			p_api_url IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_bot (l_cube_sequence, p_cube_pos_action, x_name);
		INSERT INTO v_business_object_type (
			cube_id,
			cube_sequence,
			name,
			cube_tsg_type,
			directory,
			api_url)
		VALUES (
			NULL,
			l_cube_sequence,
			p_name,
			p_cube_tsg_type,
			p_directory,
			p_api_url);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type business_object_type already exists');
	END;

	PROCEDURE update_bot (
			p_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_directory IN VARCHAR2,
			p_api_url IN VARCHAR2) IS
	BEGIN
		UPDATE v_business_object_type SET
			cube_tsg_type = p_cube_tsg_type,
			directory = p_directory,
			api_url = p_api_url
		WHERE name = p_name;
	END;

	PROCEDURE delete_bot (
			p_name IN VARCHAR2) IS
	BEGIN
		DELETE v_business_object_type
		WHERE name = p_name;
	END;

	PROCEDURE get_typ_list_all (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  name,
			  code
			FROM v_type
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_typ_for_typ_list_all (
			p_cube_row IN OUT c_cube_row,
			p_cube_scope_level IN NUMBER,
			x_fk_typ_name IN VARCHAR2) IS
		l_cube_scope_level NUMBER(1) := 0;
		l_name v_type.name%TYPE;
	BEGIN
		l_name := x_fk_typ_name;
		IF p_cube_scope_level > 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level + 1;
				SELECT fk_typ_name
				INTO l_name
				FROM v_type
				WHERE name = l_name;
			END LOOP;
		ELSIF p_cube_scope_level < 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level - 1;
				SELECT name
				INTO l_name
				FROM v_type
				WHERE fk_typ_name = l_name;
			END LOOP;
		END IF;
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  name,
			  code
			FROM v_type
			WHERE fk_typ_name = l_name
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_typ (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  fk_typ_name,
			  code,
			  flag_partial_key,
			  flag_recursive,
			  recursive_cardinality,
			  cardinality,
			  sort_order,
			  icon,
			  transferable
			FROM v_type
			WHERE name = p_name;
	END;

	PROCEDURE get_typ_fkey (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name
			FROM v_type
			WHERE name = p_name;
	END;

	PROCEDURE get_typ_tsg_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  code,
			  name
			FROM v_type_specialisation_group
			WHERE fk_typ_name = p_name
			  AND fk_tsg_code IS NULL
			ORDER BY fk_typ_name, cube_sequence;
	END;

	PROCEDURE get_typ_atb_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  name
			FROM v_attribute
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name, cube_sequence;
	END;

	PROCEDURE get_typ_ref_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  name,
			  sequence,
			  cube_tsg_int_ext,
			  xk_bot_name,
			  xk_typ_name
			FROM v_reference
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name, cube_sequence;
	END;

	PROCEDURE get_typ_rtt_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM v_restriction_type_spec_typ
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;

	PROCEDURE get_typ_jsn_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  cube_tsg_obj_arr,
			  cube_tsg_type,
			  name,
			  location,
			  xf_atb_typ_name,
			  xk_atb_name,
			  xk_typ_name
			FROM v_json_path
			WHERE fk_typ_name = p_name
			  AND fk_jsn_name IS NULL
			  AND fk_jsn_location IS NULL
			  AND fk_jsn_atb_typ_name IS NULL
			  AND fk_jsn_atb_name IS NULL
			  AND fk_jsn_typ_name IS NULL
			ORDER BY fk_typ_name, cube_sequence;
	END;

	PROCEDURE get_typ_dct_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name
			FROM v_description_type
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name;
	END;

	PROCEDURE get_typ_typ_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  name,
			  code
			FROM v_type
			WHERE fk_typ_name = p_name
			ORDER BY cube_sequence;
	END;

	PROCEDURE count_typ_jsn (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_json_path
			WHERE fk_typ_name = p_name
			  AND fk_jsn_name IS NULL
			  AND fk_jsn_location IS NULL
			  AND fk_jsn_atb_typ_name IS NULL
			  AND fk_jsn_atb_name IS NULL
			  AND fk_jsn_typ_name IS NULL;
	END;

	PROCEDURE count_typ_dct (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_description_type
			WHERE fk_typ_name = p_name;
	END;

	PROCEDURE check_no_part_typ (
			p_name IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_name v_type.name%TYPE;
	BEGIN
		l_name := x_name;
		LOOP
			IF l_name IS NULL THEN
				EXIT; -- OK
			END IF;
			IF l_name = p_name THEN
				RAISE_APPLICATION_ERROR (-20003, 'Target Type type in hierarchy of moving object');
			END IF;
			SELECT fk_typ_name
			INTO l_name
			FROM v_type
			WHERE name = l_name;
		END LOOP;
	END;

	PROCEDURE determine_position_typ (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_type
				WHERE name = p_name;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_type
			WHERE fk_bot_name = p_fk_bot_name
			  AND 	    ( 	    ( fk_typ_name IS NULL
					  AND p_fk_typ_name IS NULL )
				   OR fk_typ_name = p_fk_typ_name )
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_typ IN (
					SELECT
					  rowid row_id
					FROM v_type
					WHERE fk_bot_name = p_fk_bot_name
					  AND 	    ( 	    ( fk_typ_name IS NULL
							  AND p_fk_typ_name IS NULL )
						   OR fk_typ_name = p_fk_typ_name )
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_type SET
						cube_sequence = l_cube_count
					WHERE rowid = r_typ.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_typ (
			p_cube_pos_action IN VARCHAR2,
			p_name IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
		l_fk_bot_name v_type.fk_bot_name%TYPE;
		l_fk_typ_name v_type.fk_typ_name%TYPE;
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN ('B', 'A') THEN
			SELECT fk_bot_name, fk_typ_name
			INTO l_fk_bot_name, l_fk_typ_name
			FROM v_type
			WHERE name = x_name;
		ELSE
			SELECT fk_bot_name
			INTO l_fk_bot_name
			FROM v_type
			WHERE name = x_name;
			l_fk_typ_name := x_name;
		END IF;
		check_no_part_typ (p_name, l_fk_typ_name);
		determine_position_typ (l_cube_sequence, p_cube_pos_action, l_fk_bot_name, l_fk_typ_name, x_name);
		UPDATE v_type SET
			fk_bot_name = l_fk_bot_name,
			fk_typ_name = l_fk_typ_name,
			cube_sequence = l_cube_sequence
		WHERE name = p_name;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type type not found');
		END IF;
	END;

	PROCEDURE insert_typ (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_code IN VARCHAR2,
			p_flag_partial_key IN CHAR,
			p_flag_recursive IN CHAR,
			p_recursive_cardinality IN CHAR,
			p_cardinality IN CHAR,
			p_sort_order IN CHAR,
			p_icon IN VARCHAR2,
			p_transferable IN CHAR,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_typ (l_cube_sequence, p_cube_pos_action, p_fk_bot_name, p_fk_typ_name, x_name);
		INSERT INTO v_type (
			cube_id,
			cube_sequence,
			cube_level,
			fk_bot_name,
			fk_typ_name,
			name,
			code,
			flag_partial_key,
			flag_recursive,
			recursive_cardinality,
			cardinality,
			sort_order,
			icon,
			transferable)
		VALUES (
			NULL,
			l_cube_sequence,
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_name,
			p_code,
			p_flag_partial_key,
			p_flag_recursive,
			p_recursive_cardinality,
			p_cardinality,
			p_sort_order,
			p_icon,
			p_transferable);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type type already exists');
	END;

	PROCEDURE update_typ (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_code IN VARCHAR2,
			p_flag_partial_key IN CHAR,
			p_flag_recursive IN CHAR,
			p_recursive_cardinality IN CHAR,
			p_cardinality IN CHAR,
			p_sort_order IN CHAR,
			p_icon IN VARCHAR2,
			p_transferable IN CHAR) IS
	BEGIN
		UPDATE v_type SET
			fk_bot_name = p_fk_bot_name,
			fk_typ_name = p_fk_typ_name,
			code = p_code,
			flag_partial_key = p_flag_partial_key,
			flag_recursive = p_flag_recursive,
			recursive_cardinality = p_recursive_cardinality,
			cardinality = p_cardinality,
			sort_order = p_sort_order,
			icon = p_icon,
			transferable = p_transferable
		WHERE name = p_name;
	END;

	PROCEDURE delete_typ (
			p_name IN VARCHAR2) IS
	BEGIN
		DELETE v_type
		WHERE name = p_name;
	END;

	PROCEDURE get_tsg (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  fk_tsg_code,
			  name,
			  primary_key,
			  xf_atb_typ_name,
			  xk_atb_name
			FROM v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND code = p_code;
	END;

	PROCEDURE get_tsg_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name
			FROM v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND code = p_code;
	END;

	PROCEDURE get_tsg_tsp_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  fk_tsg_code,
			  code,
			  name
			FROM v_type_specialisation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_tsg_code = p_code
			ORDER BY fk_typ_name, fk_tsg_code, cube_sequence;
	END;

	PROCEDURE get_tsg_tsg_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  code,
			  name
			FROM v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_tsg_code = p_code
			ORDER BY fk_typ_name, cube_sequence;
	END;

	PROCEDURE count_tsg_tsg (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_tsg_code = p_code
			  AND fk_tsg_code IS NOT NULL;
	END;

	PROCEDURE check_no_part_tsg (
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_code v_type_specialisation_group.code%TYPE;
	BEGIN
		l_code := x_code;
		LOOP
			IF l_code IS NULL THEN
				EXIT; -- OK
			END IF;
			IF l_code = p_code THEN
				RAISE_APPLICATION_ERROR (-20003, 'Target Type type_specialisation_group in hierarchy of moving object');
			END IF;
			SELECT fk_tsg_code
			INTO l_code
			FROM v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND code = l_code;
		END LOOP;
	END;

	PROCEDURE determine_position_tsg (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_type_specialisation_group
				WHERE fk_typ_name = p_fk_typ_name
				  AND code = p_code;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND 	    ( 	    ( fk_tsg_code IS NULL
					  AND p_fk_tsg_code IS NULL )
				   OR fk_tsg_code = p_fk_tsg_code )
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_tsg IN (
					SELECT
					  rowid row_id
					FROM v_type_specialisation_group
					WHERE fk_typ_name = p_fk_typ_name
					  AND 	    ( 	    ( fk_tsg_code IS NULL
							  AND p_fk_tsg_code IS NULL )
						   OR fk_tsg_code = p_fk_tsg_code )
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_type_specialisation_group SET
						cube_sequence = l_cube_count
					WHERE rowid = r_tsg.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_tsg (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
		l_fk_tsg_code v_type_specialisation_group.fk_tsg_code%TYPE;
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN ('B', 'A') THEN
			SELECT fk_tsg_code
			INTO l_fk_tsg_code
			FROM v_type_specialisation_group
			WHERE fk_typ_name = x_fk_typ_name
			  AND code = x_code;
		ELSE
			l_fk_tsg_code := x_code;
		END IF;
		check_no_part_tsg (p_fk_typ_name, p_code, l_fk_tsg_code);
		determine_position_tsg (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, l_fk_tsg_code, x_code);
		UPDATE v_type_specialisation_group SET
			fk_tsg_code = l_fk_tsg_code,
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND code = p_code;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type type_specialisation_group not found');
		END IF;
	END;

	PROCEDURE insert_tsg (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_tsg (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, p_fk_tsg_code, x_code);
		INSERT INTO v_type_specialisation_group (
			cube_id,
			cube_sequence,
			cube_level,
			fk_bot_name,
			fk_typ_name,
			fk_tsg_code,
			code,
			name,
			primary_key,
			xf_atb_typ_name,
			xk_atb_name)
		VALUES (
			NULL,
			l_cube_sequence,
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_tsg_code,
			p_code,
			p_name,
			p_primary_key,
			p_xf_atb_typ_name,
			p_xk_atb_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type type_specialisation_group already exists');
	END;

	PROCEDURE update_tsg (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2) IS
	BEGIN
		UPDATE v_type_specialisation_group SET
			fk_bot_name = p_fk_bot_name,
			fk_tsg_code = p_fk_tsg_code,
			name = p_name,
			primary_key = p_primary_key,
			xf_atb_typ_name = p_xf_atb_typ_name,
			xk_atb_name = p_xk_atb_name
		WHERE fk_typ_name = p_fk_typ_name
		  AND code = p_code;
	END;

	PROCEDURE delete_tsg (
			p_fk_typ_name IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		DELETE v_type_specialisation_group
		WHERE fk_typ_name = p_fk_typ_name
		  AND code = p_code;
	END;

	PROCEDURE get_tsp_for_typ_list (
			p_cube_row IN OUT c_cube_row,
			p_cube_scope_level IN NUMBER,
			x_fk_typ_name IN VARCHAR2) IS
		l_cube_scope_level NUMBER(1) := 0;
		l_name v_type.name%TYPE;
	BEGIN
		l_name := x_fk_typ_name;
		IF p_cube_scope_level > 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level + 1;
				SELECT fk_typ_name
				INTO l_name
				FROM v_type
				WHERE name = l_name;
			END LOOP;
		ELSIF p_cube_scope_level < 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level - 1;
				SELECT name
				INTO l_name
				FROM v_type
				WHERE fk_typ_name = l_name;
			END LOOP;
		END IF;
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  fk_tsg_code,
			  code,
			  name
			FROM v_type_specialisation
			WHERE fk_typ_name = l_name
			ORDER BY fk_typ_name, fk_tsg_code, cube_sequence;
	END;

	PROCEDURE get_tsp_for_tsg_list (
			p_cube_row IN OUT c_cube_row,
			p_cube_scope_level IN NUMBER,
			x_fk_typ_name IN VARCHAR2,
			x_fk_tsg_code IN VARCHAR2) IS
		l_cube_scope_level NUMBER(1) := 0;
		l_code v_type_specialisation_group.code%TYPE;
	BEGIN
		l_code := x_fk_tsg_code;
		IF p_cube_scope_level > 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level + 1;
				SELECT fk_tsg_code
				INTO l_code
				FROM v_type_specialisation_group
				WHERE code = l_code
				  AND fk_typ_name = x_fk_typ_name;
			END LOOP;
		ELSIF p_cube_scope_level < 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level - 1;
				SELECT code
				INTO l_code
				FROM v_type_specialisation_group
				WHERE fk_tsg_code = l_code
				  AND fk_typ_name = x_fk_typ_name;
			END LOOP;
		END IF;
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  fk_tsg_code,
			  code,
			  name
			FROM v_type_specialisation
			WHERE fk_typ_name = x_fk_typ_name
			  AND fk_tsg_code = l_code
			ORDER BY fk_typ_name, fk_tsg_code, cube_sequence;
	END;

	PROCEDURE get_tsp (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM v_type_specialisation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_tsg_code = p_fk_tsg_code
			  AND code = p_code;
	END;

	PROCEDURE determine_position_tsp (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_type_specialisation
				WHERE fk_typ_name = p_fk_typ_name
				  AND fk_tsg_code = p_fk_tsg_code
				  AND code = p_code;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_type_specialisation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_tsg_code = p_fk_tsg_code
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_tsp IN (
					SELECT
					  rowid row_id
					FROM v_type_specialisation
					WHERE fk_typ_name = p_fk_typ_name
					  AND fk_tsg_code = p_fk_tsg_code
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_type_specialisation SET
						cube_sequence = l_cube_count
					WHERE rowid = r_tsp.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_tsp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_fk_tsg_code IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_tsp (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_fk_tsg_code, x_code);
		UPDATE v_type_specialisation SET
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_tsg_code = p_fk_tsg_code
		  AND code = p_code;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type type_specialisation not found');
		END IF;
	END;

	PROCEDURE insert_tsp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_fk_tsg_code IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_tsp (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_fk_tsg_code, x_code);
		INSERT INTO v_type_specialisation (
			cube_id,
			cube_sequence,
			fk_bot_name,
			fk_typ_name,
			fk_tsg_code,
			code,
			name,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_tsg_code,
			p_code,
			p_name,
			p_xf_tsp_typ_name,
			p_xf_tsp_tsg_code,
			p_xk_tsp_code);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type type_specialisation already exists');
	END;

	PROCEDURE update_tsp (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		UPDATE v_type_specialisation SET
			fk_bot_name = p_fk_bot_name,
			name = p_name,
			xf_tsp_typ_name = p_xf_tsp_typ_name,
			xf_tsp_tsg_code = p_xf_tsp_tsg_code,
			xk_tsp_code = p_xk_tsp_code
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_tsg_code = p_fk_tsg_code
		  AND code = p_code;
	END;

	PROCEDURE delete_tsp (
			p_fk_typ_name IN VARCHAR2,
			p_fk_tsg_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		DELETE v_type_specialisation
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_tsg_code = p_fk_tsg_code
		  AND code = p_code;
	END;

	PROCEDURE get_atb_for_typ_list (
			p_cube_row IN OUT c_cube_row,
			p_cube_scope_level IN NUMBER,
			x_fk_typ_name IN VARCHAR2) IS
		l_cube_scope_level NUMBER(1) := 0;
		l_name v_type.name%TYPE;
	BEGIN
		l_name := x_fk_typ_name;
		IF p_cube_scope_level > 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level + 1;
				SELECT fk_typ_name
				INTO l_name
				FROM v_type
				WHERE name = l_name;
			END LOOP;
		ELSIF p_cube_scope_level < 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level - 1;
				SELECT name
				INTO l_name
				FROM v_type
				WHERE fk_typ_name = l_name;
			END LOOP;
		END IF;
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  name
			FROM v_attribute
			WHERE fk_typ_name = l_name
			ORDER BY fk_typ_name, cube_sequence;
	END;

	PROCEDURE get_atb (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  primary_key,
			  code_display_key,
			  code_foreign_key,
			  flag_hidden,
			  default_value,
			  unchangeable,
			  xk_itp_name
			FROM v_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = p_name;
	END;

	PROCEDURE get_atb_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name
			FROM v_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = p_name;
	END;

	PROCEDURE get_atb_der_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_atb_name,
			  cube_tsg_type
			FROM v_derivation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name
			ORDER BY fk_typ_name, fk_atb_name, cube_tsg_type;
	END;

	PROCEDURE get_atb_dca_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_atb_name
			FROM v_description_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name
			ORDER BY fk_typ_name, fk_atb_name;
	END;

	PROCEDURE get_atb_rta_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_atb_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM v_restriction_type_spec_atb
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name
			ORDER BY fk_typ_name, fk_atb_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;

	PROCEDURE count_atb_der (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_derivation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name;
	END;

	PROCEDURE count_atb_dca (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_description_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name;
	END;

	PROCEDURE determine_position_atb (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_attribute
				WHERE fk_typ_name = p_fk_typ_name
				  AND name = p_name;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_atb IN (
					SELECT
					  rowid row_id
					FROM v_attribute
					WHERE fk_typ_name = p_fk_typ_name
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_attribute SET
						cube_sequence = l_cube_count
					WHERE rowid = r_atb.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_atb (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_atb (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_name);
		UPDATE v_attribute SET
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type attribute not found');
		END IF;
	END;

	PROCEDURE insert_atb (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_code_display_key IN CHAR,
			p_code_foreign_key IN CHAR,
			p_flag_hidden IN CHAR,
			p_default_value IN VARCHAR2,
			p_unchangeable IN CHAR,
			p_xk_itp_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_atb (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_name);
		INSERT INTO v_attribute (
			cube_id,
			cube_sequence,
			fk_bot_name,
			fk_typ_name,
			name,
			primary_key,
			code_display_key,
			code_foreign_key,
			flag_hidden,
			default_value,
			unchangeable,
			xk_itp_name)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_bot_name,
			p_fk_typ_name,
			p_name,
			p_primary_key,
			p_code_display_key,
			p_code_foreign_key,
			p_flag_hidden,
			p_default_value,
			p_unchangeable,
			p_xk_itp_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type attribute already exists');
	END;

	PROCEDURE update_atb (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_code_display_key IN CHAR,
			p_code_foreign_key IN CHAR,
			p_flag_hidden IN CHAR,
			p_default_value IN VARCHAR2,
			p_unchangeable IN CHAR,
			p_xk_itp_name IN VARCHAR2) IS
	BEGIN
		UPDATE v_attribute SET
			fk_bot_name = p_fk_bot_name,
			primary_key = p_primary_key,
			code_display_key = p_code_display_key,
			code_foreign_key = p_code_foreign_key,
			flag_hidden = p_flag_hidden,
			default_value = p_default_value,
			unchangeable = p_unchangeable,
			xk_itp_name = p_xk_itp_name
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name;
	END;

	PROCEDURE delete_atb (
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		DELETE v_attribute
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name;
	END;

	PROCEDURE get_der (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  cube_tsg_type,
			  aggregate_function,
			  xk_typ_name,
			  xk_typ_name_1
			FROM v_derivation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_fk_atb_name;
	END;

	PROCEDURE insert_der (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_aggregate_function IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_derivation (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_atb_name,
			cube_tsg_type,
			aggregate_function,
			xk_typ_name,
			xk_typ_name_1)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_atb_name,
			p_cube_tsg_type,
			p_aggregate_function,
			p_xk_typ_name,
			p_xk_typ_name_1);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type derivation already exists');
	END;

	PROCEDURE update_der (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_aggregate_function IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2) IS
	BEGIN
		UPDATE v_derivation SET
			fk_bot_name = p_fk_bot_name,
			cube_tsg_type = p_cube_tsg_type,
			aggregate_function = p_aggregate_function,
			xk_typ_name = p_xk_typ_name,
			xk_typ_name_1 = p_xk_typ_name_1
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name;
	END;

	PROCEDURE delete_der (
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2) IS
	BEGIN
		DELETE v_derivation
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name;
	END;

	PROCEDURE get_dca (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  text
			FROM v_description_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_fk_atb_name;
	END;

	PROCEDURE insert_dca (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_text IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_description_attribute (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_atb_name,
			text)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_atb_name,
			p_text);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type description_attribute already exists');
	END;

	PROCEDURE update_dca (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_text IN VARCHAR2) IS
	BEGIN
		UPDATE v_description_attribute SET
			fk_bot_name = p_fk_bot_name,
			text = p_text
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name;
	END;

	PROCEDURE delete_dca (
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2) IS
	BEGIN
		DELETE v_description_attribute
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name;
	END;

	PROCEDURE get_rta (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  include_or_exclude
			FROM v_restriction_type_spec_atb
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_fk_atb_name
			  AND xf_tsp_typ_name = p_xf_tsp_typ_name
			  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
			  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE get_next_rta (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_atb_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM v_restriction_type_spec_atb
			WHERE fk_typ_name > p_fk_typ_name
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_atb_name > p_fk_atb_name )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_atb_name = p_fk_atb_name
				  AND xf_tsp_typ_name > p_xf_tsp_typ_name )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_atb_name = p_fk_atb_name
				  AND xf_tsp_typ_name = p_xf_tsp_typ_name
				  AND xf_tsp_tsg_code > p_xf_tsp_tsg_code )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_atb_name = p_fk_atb_name
				  AND xf_tsp_typ_name = p_xf_tsp_typ_name
				  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
				  AND xk_tsp_code > p_xk_tsp_code )
			ORDER BY fk_typ_name, fk_atb_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;

	PROCEDURE insert_rta (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_restriction_type_spec_atb (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_atb_name,
			include_or_exclude,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_atb_name,
			p_include_or_exclude,
			p_xf_tsp_typ_name,
			p_xf_tsp_tsg_code,
			p_xk_tsp_code);

		get_next_rta (p_cube_row, p_fk_typ_name, p_fk_atb_name, p_xf_tsp_typ_name, p_xf_tsp_tsg_code, p_xk_tsp_code);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type restriction_type_spec_atb already exists');
	END;

	PROCEDURE update_rta (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		UPDATE v_restriction_type_spec_atb SET
			fk_bot_name = p_fk_bot_name,
			include_or_exclude = p_include_or_exclude
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE delete_rta (
			p_fk_typ_name IN VARCHAR2,
			p_fk_atb_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		DELETE v_restriction_type_spec_atb
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE get_ref (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  name,
			  primary_key,
			  code_display_key,
			  scope,
			  unchangeable,
			  within_scope_extension,
			  cube_tsg_int_ext,
			  xk_typ_name_1
			FROM v_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND sequence = p_sequence
			  AND xk_bot_name = p_xk_bot_name
			  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_ref_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name
			FROM v_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND sequence = p_sequence
			  AND xk_bot_name = p_xk_bot_name
			  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_ref_dcr_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
			  fk_ref_bot_name,
			  fk_ref_typ_name
			FROM v_description_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_bot_name = p_xk_bot_name
			  AND fk_ref_typ_name = p_xk_typ_name
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name;
	END;

	PROCEDURE get_ref_rtr_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
			  fk_ref_bot_name,
			  fk_ref_typ_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM v_restriction_type_spec_ref
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_bot_name = p_xk_bot_name
			  AND fk_ref_typ_name = p_xk_typ_name
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;

	PROCEDURE get_ref_rts_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
			  fk_ref_bot_name,
			  fk_ref_typ_name,
			  include_or_exclude,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM v_restriction_target_type_spec
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_bot_name = p_xk_bot_name
			  AND fk_ref_typ_name = p_xk_typ_name
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, include_or_exclude, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;

	PROCEDURE count_ref_dcr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_description_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_bot_name = p_xk_bot_name
			  AND fk_ref_typ_name = p_xk_typ_name;
	END;

	PROCEDURE count_ref_rts (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_restriction_target_type_spec
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_bot_name = p_xk_bot_name
			  AND fk_ref_typ_name = p_xk_typ_name;
	END;

	PROCEDURE determine_position_ref (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_reference
				WHERE fk_typ_name = p_fk_typ_name
				  AND sequence = p_sequence
				  AND xk_bot_name = p_xk_bot_name
				  AND xk_typ_name = p_xk_typ_name;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_ref IN (
					SELECT
					  rowid row_id
					FROM v_reference
					WHERE fk_typ_name = p_fk_typ_name
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_reference SET
						cube_sequence = l_cube_count
					WHERE rowid = r_ref.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_ref (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_sequence IN NUMBER,
			x_xk_bot_name IN VARCHAR2,
			x_xk_typ_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_ref (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_sequence, x_xk_bot_name, x_xk_typ_name);
		UPDATE v_reference SET
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND sequence = p_sequence
		  AND xk_bot_name = p_xk_bot_name
		  AND xk_typ_name = p_xk_typ_name;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type reference not found');
		END IF;
	END;

	PROCEDURE insert_ref (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_code_display_key IN CHAR,
			p_sequence IN NUMBER,
			p_scope IN VARCHAR2,
			p_unchangeable IN CHAR,
			p_within_scope_extension IN VARCHAR2,
			p_cube_tsg_int_ext IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_sequence IN NUMBER,
			x_xk_bot_name IN VARCHAR2,
			x_xk_typ_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_ref (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_sequence, x_xk_bot_name, x_xk_typ_name);
		INSERT INTO v_reference (
			cube_id,
			cube_sequence,
			fk_bot_name,
			fk_typ_name,
			name,
			primary_key,
			code_display_key,
			sequence,
			scope,
			unchangeable,
			within_scope_extension,
			cube_tsg_int_ext,
			xk_bot_name,
			xk_typ_name,
			xk_typ_name_1)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_bot_name,
			p_fk_typ_name,
			p_name,
			p_primary_key,
			p_code_display_key,
			p_sequence,
			p_scope,
			p_unchangeable,
			p_within_scope_extension,
			p_cube_tsg_int_ext,
			p_xk_bot_name,
			p_xk_typ_name,
			p_xk_typ_name_1);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type reference already exists');
	END;

	PROCEDURE update_ref (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_primary_key IN CHAR,
			p_code_display_key IN CHAR,
			p_sequence IN NUMBER,
			p_scope IN VARCHAR2,
			p_unchangeable IN CHAR,
			p_within_scope_extension IN VARCHAR2,
			p_cube_tsg_int_ext IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2) IS
	BEGIN
		UPDATE v_reference SET
			fk_bot_name = p_fk_bot_name,
			name = p_name,
			primary_key = p_primary_key,
			code_display_key = p_code_display_key,
			scope = p_scope,
			unchangeable = p_unchangeable,
			within_scope_extension = p_within_scope_extension,
			cube_tsg_int_ext = p_cube_tsg_int_ext,
			xk_typ_name_1 = p_xk_typ_name_1
		WHERE fk_typ_name = p_fk_typ_name
		  AND sequence = p_sequence
		  AND xk_bot_name = p_xk_bot_name
		  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE delete_ref (
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_bot_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		DELETE v_reference
		WHERE fk_typ_name = p_fk_typ_name
		  AND sequence = p_sequence
		  AND xk_bot_name = p_xk_bot_name
		  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_dcr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  text
			FROM v_description_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_fk_ref_sequence
			  AND fk_ref_bot_name = p_fk_ref_bot_name
			  AND fk_ref_typ_name = p_fk_ref_typ_name;
	END;

	PROCEDURE insert_dcr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_text IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_description_reference (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_bot_name,
			fk_ref_typ_name,
			text)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_ref_sequence,
			p_fk_ref_bot_name,
			p_fk_ref_typ_name,
			p_text);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type description_reference already exists');
	END;

	PROCEDURE update_dcr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_text IN VARCHAR2) IS
	BEGIN
		UPDATE v_description_reference SET
			fk_bot_name = p_fk_bot_name,
			text = p_text
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_bot_name = p_fk_ref_bot_name
		  AND fk_ref_typ_name = p_fk_ref_typ_name;
	END;

	PROCEDURE delete_dcr (
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2) IS
	BEGIN
		DELETE v_description_reference
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_bot_name = p_fk_ref_bot_name
		  AND fk_ref_typ_name = p_fk_ref_typ_name;
	END;

	PROCEDURE get_rtr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  include_or_exclude
			FROM v_restriction_type_spec_ref
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_fk_ref_sequence
			  AND fk_ref_bot_name = p_fk_ref_bot_name
			  AND fk_ref_typ_name = p_fk_ref_typ_name
			  AND xf_tsp_typ_name = p_xf_tsp_typ_name
			  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
			  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE get_next_rtr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
			  fk_ref_bot_name,
			  fk_ref_typ_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM v_restriction_type_spec_ref
			WHERE fk_typ_name > p_fk_typ_name
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_ref_sequence > p_fk_ref_sequence )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_ref_sequence = p_fk_ref_sequence
				  AND fk_ref_bot_name > p_fk_ref_bot_name )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_ref_sequence = p_fk_ref_sequence
				  AND fk_ref_bot_name = p_fk_ref_bot_name
				  AND fk_ref_typ_name > p_fk_ref_typ_name )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_ref_sequence = p_fk_ref_sequence
				  AND fk_ref_bot_name = p_fk_ref_bot_name
				  AND fk_ref_typ_name = p_fk_ref_typ_name
				  AND xf_tsp_typ_name > p_xf_tsp_typ_name )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_ref_sequence = p_fk_ref_sequence
				  AND fk_ref_bot_name = p_fk_ref_bot_name
				  AND fk_ref_typ_name = p_fk_ref_typ_name
				  AND xf_tsp_typ_name = p_xf_tsp_typ_name
				  AND xf_tsp_tsg_code > p_xf_tsp_tsg_code )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_ref_sequence = p_fk_ref_sequence
				  AND fk_ref_bot_name = p_fk_ref_bot_name
				  AND fk_ref_typ_name = p_fk_ref_typ_name
				  AND xf_tsp_typ_name = p_xf_tsp_typ_name
				  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
				  AND xk_tsp_code > p_xk_tsp_code )
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;

	PROCEDURE insert_rtr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_restriction_type_spec_ref (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_bot_name,
			fk_ref_typ_name,
			include_or_exclude,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_ref_sequence,
			p_fk_ref_bot_name,
			p_fk_ref_typ_name,
			p_include_or_exclude,
			p_xf_tsp_typ_name,
			p_xf_tsp_tsg_code,
			p_xk_tsp_code);

		get_next_rtr (p_cube_row, p_fk_typ_name, p_fk_ref_sequence, p_fk_ref_bot_name, p_fk_ref_typ_name, p_xf_tsp_typ_name, p_xf_tsp_tsg_code, p_xk_tsp_code);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type restriction_type_spec_ref already exists');
	END;

	PROCEDURE update_rtr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		UPDATE v_restriction_type_spec_ref SET
			fk_bot_name = p_fk_bot_name,
			include_or_exclude = p_include_or_exclude
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_bot_name = p_fk_ref_bot_name
		  AND fk_ref_typ_name = p_fk_ref_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE delete_rtr (
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		DELETE v_restriction_type_spec_ref
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_bot_name = p_fk_ref_bot_name
		  AND fk_ref_typ_name = p_fk_ref_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE get_rts (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  include_or_exclude
			FROM v_restriction_target_type_spec
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_fk_ref_sequence
			  AND fk_ref_bot_name = p_fk_ref_bot_name
			  AND fk_ref_typ_name = p_fk_ref_typ_name
			  AND xf_tsp_typ_name = p_xf_tsp_typ_name
			  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
			  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE insert_rts (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_restriction_target_type_spec (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_bot_name,
			fk_ref_typ_name,
			include_or_exclude,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_ref_sequence,
			p_fk_ref_bot_name,
			p_fk_ref_typ_name,
			p_include_or_exclude,
			p_xf_tsp_typ_name,
			p_xf_tsp_tsg_code,
			p_xk_tsp_code);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type restriction_target_type_spec already exists');
	END;

	PROCEDURE update_rts (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		UPDATE v_restriction_target_type_spec SET
			fk_bot_name = p_fk_bot_name,
			include_or_exclude = p_include_or_exclude
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_bot_name = p_fk_ref_bot_name
		  AND fk_ref_typ_name = p_fk_ref_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE delete_rts (
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_bot_name IN VARCHAR2,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		DELETE v_restriction_target_type_spec
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_bot_name = p_fk_ref_bot_name
		  AND fk_ref_typ_name = p_fk_ref_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE get_rtt (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  include_or_exclude
			FROM v_restriction_type_spec_typ
			WHERE fk_typ_name = p_fk_typ_name
			  AND xf_tsp_typ_name = p_xf_tsp_typ_name
			  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
			  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE get_next_rtt (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM v_restriction_type_spec_typ
			WHERE fk_typ_name > p_fk_typ_name
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND xf_tsp_typ_name > p_xf_tsp_typ_name )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND xf_tsp_typ_name = p_xf_tsp_typ_name
				  AND xf_tsp_tsg_code > p_xf_tsp_tsg_code )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND xf_tsp_typ_name = p_xf_tsp_typ_name
				  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
				  AND xk_tsp_code > p_xk_tsp_code )
			ORDER BY fk_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;

	PROCEDURE insert_rtt (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_restriction_type_spec_typ (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			include_or_exclude,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_include_or_exclude,
			p_xf_tsp_typ_name,
			p_xf_tsp_tsg_code,
			p_xk_tsp_code);

		get_next_rtt (p_cube_row, p_fk_typ_name, p_xf_tsp_typ_name, p_xf_tsp_tsg_code, p_xk_tsp_code);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type restriction_type_spec_typ already exists');
	END;

	PROCEDURE update_rtt (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		UPDATE v_restriction_type_spec_typ SET
			fk_bot_name = p_fk_bot_name,
			include_or_exclude = p_include_or_exclude
		WHERE fk_typ_name = p_fk_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE delete_rtt (
			p_fk_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		DELETE v_restriction_type_spec_typ
		WHERE fk_typ_name = p_fk_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE get_jsn (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  fk_jsn_name,
			  fk_jsn_location,
			  fk_jsn_atb_typ_name,
			  fk_jsn_atb_name,
			  fk_jsn_typ_name,
			  cube_tsg_obj_arr,
			  cube_tsg_type
			FROM v_json_path
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = p_name
			  AND location = p_location
			  AND xf_atb_typ_name = p_xf_atb_typ_name
			  AND xk_atb_name = p_xk_atb_name
			  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_jsn_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name
			FROM v_json_path
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = p_name
			  AND location = p_location
			  AND xf_atb_typ_name = p_xf_atb_typ_name
			  AND xk_atb_name = p_xk_atb_name
			  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_jsn_jsn_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  cube_tsg_obj_arr,
			  cube_tsg_type,
			  name,
			  location,
			  xf_atb_typ_name,
			  xk_atb_name,
			  xk_typ_name
			FROM v_json_path
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_jsn_name = p_name
			  AND fk_jsn_location = p_location
			  AND fk_jsn_atb_typ_name = p_xf_atb_typ_name
			  AND fk_jsn_atb_name = p_xk_atb_name
			  AND fk_jsn_typ_name = p_xk_typ_name
			ORDER BY fk_typ_name, cube_sequence;
	END;

	PROCEDURE check_no_part_jsn (
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			x_name IN VARCHAR2,
			x_location IN NUMBER,
			x_xf_atb_typ_name IN VARCHAR2,
			x_xk_atb_name IN VARCHAR2,
			x_xk_typ_name IN VARCHAR2) IS
		l_name v_json_path.name%TYPE;
		l_location v_json_path.location%TYPE;
		l_xf_atb_typ_name v_json_path.xf_atb_typ_name%TYPE;
		l_xk_atb_name v_json_path.xk_atb_name%TYPE;
		l_xk_typ_name v_json_path.xk_typ_name%TYPE;
	BEGIN
		l_name := x_name;
		l_location := x_location;
		l_xf_atb_typ_name := x_xf_atb_typ_name;
		l_xk_atb_name := x_xk_atb_name;
		l_xk_typ_name := x_xk_typ_name;
		LOOP
			IF l_name IS NULL
			  AND l_location IS NULL
			  AND l_xf_atb_typ_name IS NULL
			  AND l_xk_atb_name IS NULL
			  AND l_xk_typ_name IS NULL THEN
				EXIT; -- OK
			END IF;
			IF l_name = p_name
			  AND l_location = p_location
			  AND l_xf_atb_typ_name = p_xf_atb_typ_name
			  AND l_xk_atb_name = p_xk_atb_name
			  AND l_xk_typ_name = p_xk_typ_name THEN
				RAISE_APPLICATION_ERROR (-20003, 'Target Type json_path in hierarchy of moving object');
			END IF;
			SELECT fk_jsn_name, fk_jsn_location, fk_jsn_atb_typ_name, fk_jsn_atb_name, fk_jsn_typ_name
			INTO l_name, l_location, l_xf_atb_typ_name, l_xk_atb_name, l_xk_typ_name
			FROM v_json_path
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = l_name
			  AND location = l_location
			  AND xf_atb_typ_name = l_xf_atb_typ_name
			  AND xk_atb_name = l_xk_atb_name
			  AND xk_typ_name = l_xk_typ_name;
		END LOOP;
	END;

	PROCEDURE determine_position_jsn (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_jsn_name IN VARCHAR2,
			p_fk_jsn_location IN NUMBER,
			p_fk_jsn_atb_typ_name IN VARCHAR2,
			p_fk_jsn_atb_name IN VARCHAR2,
			p_fk_jsn_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_json_path
				WHERE fk_typ_name = p_fk_typ_name
				  AND name = p_name
				  AND location = p_location
				  AND xf_atb_typ_name = p_xf_atb_typ_name
				  AND xk_atb_name = p_xk_atb_name
				  AND xk_typ_name = p_xk_typ_name;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_json_path
			WHERE fk_typ_name = p_fk_typ_name
			  AND 	    ( 	    ( fk_jsn_name IS NULL
					  AND p_fk_jsn_name IS NULL )
				   OR 	    ( fk_jsn_location IS NULL
					  AND p_fk_jsn_location IS NULL )
				   OR 	    ( fk_jsn_atb_typ_name IS NULL
					  AND p_fk_jsn_atb_typ_name IS NULL )
				   OR 	    ( fk_jsn_atb_name IS NULL
					  AND p_fk_jsn_atb_name IS NULL )
				   OR 	    ( fk_jsn_typ_name IS NULL
					  AND p_fk_jsn_typ_name IS NULL )
				   OR fk_jsn_name = p_fk_jsn_name
				   OR fk_jsn_location = p_fk_jsn_location
				   OR fk_jsn_atb_typ_name = p_fk_jsn_atb_typ_name
				   OR fk_jsn_atb_name = p_fk_jsn_atb_name
				   OR fk_jsn_typ_name = p_fk_jsn_typ_name )
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_jsn IN (
					SELECT
					  rowid row_id
					FROM v_json_path
					WHERE fk_typ_name = p_fk_typ_name
					  AND 	    ( 	    ( fk_jsn_name IS NULL
							  AND p_fk_jsn_name IS NULL )
						   OR 	    ( fk_jsn_location IS NULL
							  AND p_fk_jsn_location IS NULL )
						   OR 	    ( fk_jsn_atb_typ_name IS NULL
							  AND p_fk_jsn_atb_typ_name IS NULL )
						   OR 	    ( fk_jsn_atb_name IS NULL
							  AND p_fk_jsn_atb_name IS NULL )
						   OR 	    ( fk_jsn_typ_name IS NULL
							  AND p_fk_jsn_typ_name IS NULL )
						   OR fk_jsn_name = p_fk_jsn_name
						   OR fk_jsn_location = p_fk_jsn_location
						   OR fk_jsn_atb_typ_name = p_fk_jsn_atb_typ_name
						   OR fk_jsn_atb_name = p_fk_jsn_atb_name
						   OR fk_jsn_typ_name = p_fk_jsn_typ_name )
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_json_path SET
						cube_sequence = l_cube_count
					WHERE rowid = r_jsn.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_jsn (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_name IN VARCHAR2,
			x_location IN NUMBER,
			x_xf_atb_typ_name IN VARCHAR2,
			x_xk_atb_name IN VARCHAR2,
			x_xk_typ_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
		l_fk_jsn_name v_json_path.fk_jsn_name%TYPE;
		l_fk_jsn_location v_json_path.fk_jsn_location%TYPE;
		l_fk_jsn_atb_typ_name v_json_path.fk_jsn_atb_typ_name%TYPE;
		l_fk_jsn_atb_name v_json_path.fk_jsn_atb_name%TYPE;
		l_fk_jsn_typ_name v_json_path.fk_jsn_typ_name%TYPE;
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN ('B', 'A') THEN
			SELECT fk_jsn_name, fk_jsn_location, fk_jsn_atb_typ_name, fk_jsn_atb_name, fk_jsn_typ_name
			INTO l_fk_jsn_name, l_fk_jsn_location, l_fk_jsn_atb_typ_name, l_fk_jsn_atb_name, l_fk_jsn_typ_name
			FROM v_json_path
			WHERE fk_typ_name = x_fk_typ_name
			  AND name = x_name
			  AND location = x_location
			  AND xf_atb_typ_name = x_xf_atb_typ_name
			  AND xk_atb_name = x_xk_atb_name
			  AND xk_typ_name = x_xk_typ_name;
		ELSE
			l_fk_jsn_name := x_name;
			l_fk_jsn_location := x_location;
			l_fk_jsn_atb_typ_name := x_xf_atb_typ_name;
			l_fk_jsn_atb_name := x_xk_atb_name;
			l_fk_jsn_typ_name := x_xk_typ_name;
		END IF;
		check_no_part_jsn (p_fk_typ_name, p_name, p_location, p_xf_atb_typ_name, p_xk_atb_name, p_xk_typ_name, l_fk_jsn_name, l_fk_jsn_location, l_fk_jsn_atb_typ_name, l_fk_jsn_atb_name, l_fk_jsn_typ_name);
		determine_position_jsn (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, l_fk_jsn_name, l_fk_jsn_location, l_fk_jsn_atb_typ_name, l_fk_jsn_atb_name, l_fk_jsn_typ_name, x_name, x_location, x_xf_atb_typ_name, x_xk_atb_name, x_xk_typ_name);
		UPDATE v_json_path SET
			fk_jsn_name = l_fk_jsn_name,
			fk_jsn_location = l_fk_jsn_location,
			fk_jsn_atb_typ_name = l_fk_jsn_atb_typ_name,
			fk_jsn_atb_name = l_fk_jsn_atb_name,
			fk_jsn_typ_name = l_fk_jsn_typ_name,
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name
		  AND location = p_location
		  AND xf_atb_typ_name = p_xf_atb_typ_name
		  AND xk_atb_name = p_xk_atb_name
		  AND xk_typ_name = p_xk_typ_name;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type json_path not found');
		END IF;
	END;

	PROCEDURE insert_jsn (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_jsn_name IN VARCHAR2,
			p_fk_jsn_location IN NUMBER,
			p_fk_jsn_atb_typ_name IN VARCHAR2,
			p_fk_jsn_atb_name IN VARCHAR2,
			p_fk_jsn_typ_name IN VARCHAR2,
			p_cube_tsg_obj_arr IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_name IN VARCHAR2,
			x_location IN NUMBER,
			x_xf_atb_typ_name IN VARCHAR2,
			x_xk_atb_name IN VARCHAR2,
			x_xk_typ_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_jsn (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, p_fk_jsn_name, p_fk_jsn_location, p_fk_jsn_atb_typ_name, p_fk_jsn_atb_name, p_fk_jsn_typ_name, x_name, x_location, x_xf_atb_typ_name, x_xk_atb_name, x_xk_typ_name);
		INSERT INTO v_json_path (
			cube_id,
			cube_sequence,
			cube_level,
			fk_bot_name,
			fk_typ_name,
			fk_jsn_name,
			fk_jsn_location,
			fk_jsn_atb_typ_name,
			fk_jsn_atb_name,
			fk_jsn_typ_name,
			cube_tsg_obj_arr,
			cube_tsg_type,
			name,
			location,
			xf_atb_typ_name,
			xk_atb_name,
			xk_typ_name)
		VALUES (
			NULL,
			l_cube_sequence,
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_jsn_name,
			p_fk_jsn_location,
			p_fk_jsn_atb_typ_name,
			p_fk_jsn_atb_name,
			p_fk_jsn_typ_name,
			p_cube_tsg_obj_arr,
			p_cube_tsg_type,
			p_name,
			p_location,
			p_xf_atb_typ_name,
			p_xk_atb_name,
			p_xk_typ_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type json_path already exists');
	END;

	PROCEDURE update_jsn (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_jsn_name IN VARCHAR2,
			p_fk_jsn_location IN NUMBER,
			p_fk_jsn_atb_typ_name IN VARCHAR2,
			p_fk_jsn_atb_name IN VARCHAR2,
			p_fk_jsn_typ_name IN VARCHAR2,
			p_cube_tsg_obj_arr IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		UPDATE v_json_path SET
			fk_bot_name = p_fk_bot_name,
			fk_jsn_name = p_fk_jsn_name,
			fk_jsn_location = p_fk_jsn_location,
			fk_jsn_atb_typ_name = p_fk_jsn_atb_typ_name,
			fk_jsn_atb_name = p_fk_jsn_atb_name,
			fk_jsn_typ_name = p_fk_jsn_typ_name,
			cube_tsg_obj_arr = p_cube_tsg_obj_arr,
			cube_tsg_type = p_cube_tsg_type
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name
		  AND location = p_location
		  AND xf_atb_typ_name = p_xf_atb_typ_name
		  AND xk_atb_name = p_xk_atb_name
		  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE delete_jsn (
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_location IN NUMBER,
			p_xf_atb_typ_name IN VARCHAR2,
			p_xk_atb_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		DELETE v_json_path
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name
		  AND location = p_location
		  AND xf_atb_typ_name = p_xf_atb_typ_name
		  AND xk_atb_name = p_xk_atb_name
		  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_dct (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  text
			FROM v_description_type
			WHERE fk_typ_name = p_fk_typ_name;
	END;

	PROCEDURE insert_dct (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_text IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_description_type (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			text)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_text);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type description_type already exists');
	END;

	PROCEDURE update_dct (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_text IN VARCHAR2) IS
	BEGIN
		UPDATE v_description_type SET
			fk_bot_name = p_fk_bot_name,
			text = p_text
		WHERE fk_typ_name = p_fk_typ_name;
	END;

	PROCEDURE delete_dct (
			p_fk_typ_name IN VARCHAR2) IS
	BEGIN
		DELETE v_description_type
		WHERE fk_typ_name = p_fk_typ_name;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE pkg_cub IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_pkg_cubedocu RETURN VARCHAR2;
	PROCEDURE get_cub_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_cub (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_cub_cgp_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_cub_cgm_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_cub_ctf_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE insert_cub (
			p_name IN VARCHAR2,
			p_description IN VARCHAR2,
			p_description_functions IN VARCHAR2,
			p_description_logical_expression IN VARCHAR2);
	PROCEDURE update_cub (
			p_name IN VARCHAR2,
			p_description IN VARCHAR2,
			p_description_functions IN VARCHAR2,
			p_description_logical_expression IN VARCHAR2);
	PROCEDURE delete_cub (
			p_name IN VARCHAR2);
	PROCEDURE get_cgp (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2);
	PROCEDURE move_cgp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_id IN VARCHAR2);
	PROCEDURE insert_cgp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_description IN VARCHAR2,
			p_example IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_id IN VARCHAR2);
	PROCEDURE update_cgp (
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_description IN VARCHAR2,
			p_example IN VARCHAR2);
	PROCEDURE delete_cgp (
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2);
	PROCEDURE get_cgm (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2);
	PROCEDURE get_cgm_cgo_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2);
	PROCEDURE get_cgm_cgf_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2);
	PROCEDURE move_cgm (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_id IN VARCHAR2);
	PROCEDURE insert_cgm (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_included_object_names IN VARCHAR2,
			p_description IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_id IN VARCHAR2);
	PROCEDURE update_cgm (
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_included_object_names IN VARCHAR2,
			p_description IN VARCHAR2);
	PROCEDURE delete_cgm (
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2);
	PROCEDURE move_cgo (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_fk_cgm_id IN VARCHAR2,
			x_xk_bot_name IN VARCHAR2);
	PROCEDURE insert_cgo (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_fk_cgm_id IN VARCHAR2,
			x_xk_bot_name IN VARCHAR2);
	PROCEDURE delete_cgo (
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2);
	PROCEDURE get_cgf (
			p_cube_row IN OUT c_cube_row,
			p_id IN VARCHAR2);
	PROCEDURE move_cgf (
			p_cube_pos_action IN VARCHAR2,
			p_id IN VARCHAR2,
			x_id IN VARCHAR2);
	PROCEDURE insert_cgf (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_description IN VARCHAR2,
			p_template IN VARCHAR2,
			x_id IN VARCHAR2);
	PROCEDURE update_cgf (
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_description IN VARCHAR2,
			p_template IN VARCHAR2);
	PROCEDURE delete_cgf (
			p_id IN VARCHAR2);
	PROCEDURE get_ctf (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_indication_logical IN CHAR);
	PROCEDURE insert_ctf (
			p_fk_cub_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_indication_logical IN CHAR,
			p_description IN VARCHAR2,
			p_syntax IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_ctf (
			p_fk_cub_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_indication_logical IN CHAR,
			p_description IN VARCHAR2,
			p_syntax IN VARCHAR2);
	PROCEDURE delete_ctf (
			p_fk_cub_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_indication_logical IN CHAR);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_cub IS
	FUNCTION cube_pkg_cubedocu RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubedocu';
	END;

	PROCEDURE get_cub_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  name
			FROM v_cube_gen_documentation
			ORDER BY name;
	END;

	PROCEDURE get_cub (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  description,
			  description_functions,
			  description_logical_expression
			FROM v_cube_gen_documentation
			WHERE name = p_name;
	END;

	PROCEDURE get_cub_cgp_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_cub_name,
			  id,
			  header
			FROM v_cube_gen_paragraph
			WHERE fk_cub_name = p_name
			ORDER BY fk_cub_name, cube_sequence;
	END;

	PROCEDURE get_cub_cgm_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_cub_name,
			  id,
			  header
			FROM v_cube_gen_example_model
			WHERE fk_cub_name = p_name
			ORDER BY fk_cub_name, cube_sequence;
	END;

	PROCEDURE get_cub_ctf_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_cub_name,
			  name,
			  indication_logical
			FROM v_cube_gen_template_function
			WHERE fk_cub_name = p_name
			ORDER BY fk_cub_name, name, indication_logical;
	END;

	PROCEDURE insert_cub (
			p_name IN VARCHAR2,
			p_description IN VARCHAR2,
			p_description_functions IN VARCHAR2,
			p_description_logical_expression IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_cube_gen_documentation (
			cube_id,
			name,
			description,
			description_functions,
			description_logical_expression)
		VALUES (
			NULL,
			p_name,
			p_description,
			p_description_functions,
			p_description_logical_expression);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type cube_gen_documentation already exists');
	END;

	PROCEDURE update_cub (
			p_name IN VARCHAR2,
			p_description IN VARCHAR2,
			p_description_functions IN VARCHAR2,
			p_description_logical_expression IN VARCHAR2) IS
	BEGIN
		UPDATE v_cube_gen_documentation SET
			description = p_description,
			description_functions = p_description_functions,
			description_logical_expression = p_description_logical_expression
		WHERE name = p_name;
	END;

	PROCEDURE delete_cub (
			p_name IN VARCHAR2) IS
	BEGIN
		DELETE v_cube_gen_documentation
		WHERE name = p_name;
	END;

	PROCEDURE get_cgp (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  header,
			  description,
			  example
			FROM v_cube_gen_paragraph
			WHERE fk_cub_name = p_fk_cub_name
			  AND id = p_id;
	END;

	PROCEDURE determine_position_cgp (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_cube_gen_paragraph
				WHERE fk_cub_name = p_fk_cub_name
				  AND id = p_id;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_cube_gen_paragraph
			WHERE fk_cub_name = p_fk_cub_name
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_cgp IN (
					SELECT
					  rowid row_id
					FROM v_cube_gen_paragraph
					WHERE fk_cub_name = p_fk_cub_name
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_cube_gen_paragraph SET
						cube_sequence = l_cube_count
					WHERE rowid = r_cgp.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_cgp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_id IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_cgp (l_cube_sequence, p_cube_pos_action, x_fk_cub_name, x_id);
		UPDATE v_cube_gen_paragraph SET
			cube_sequence = l_cube_sequence
		WHERE fk_cub_name = p_fk_cub_name
		  AND id = p_id;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type cube_gen_paragraph not found');
		END IF;
	END;

	PROCEDURE insert_cgp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_description IN VARCHAR2,
			p_example IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_id IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_cgp (l_cube_sequence, p_cube_pos_action, x_fk_cub_name, x_id);
		INSERT INTO v_cube_gen_paragraph (
			cube_id,
			cube_sequence,
			fk_cub_name,
			id,
			header,
			description,
			example)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_cub_name,
			p_id,
			p_header,
			p_description,
			p_example);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type cube_gen_paragraph already exists');
	END;

	PROCEDURE update_cgp (
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_description IN VARCHAR2,
			p_example IN VARCHAR2) IS
	BEGIN
		UPDATE v_cube_gen_paragraph SET
			header = p_header,
			description = p_description,
			example = p_example
		WHERE fk_cub_name = p_fk_cub_name
		  AND id = p_id;
	END;

	PROCEDURE delete_cgp (
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2) IS
	BEGIN
		DELETE v_cube_gen_paragraph
		WHERE fk_cub_name = p_fk_cub_name
		  AND id = p_id;
	END;

	PROCEDURE get_cgm (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  header,
			  included_object_names,
			  description
			FROM v_cube_gen_example_model
			WHERE fk_cub_name = p_fk_cub_name
			  AND id = p_id;
	END;

	PROCEDURE get_cgm_cgo_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_cub_name,
			  fk_cgm_id,
			  xk_bot_name
			FROM v_cube_gen_example_object
			WHERE fk_cub_name = p_fk_cub_name
			  AND fk_cgm_id = p_id
			ORDER BY fk_cub_name, fk_cgm_id, cube_sequence;
	END;

	PROCEDURE get_cgm_cgf_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  id,
			  header
			FROM v_cube_gen_function
			WHERE fk_cub_name = p_fk_cub_name
			  AND fk_cgm_id = p_id
			ORDER BY cube_sequence;
	END;

	PROCEDURE determine_position_cgm (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_cube_gen_example_model
				WHERE fk_cub_name = p_fk_cub_name
				  AND id = p_id;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_cube_gen_example_model
			WHERE fk_cub_name = p_fk_cub_name
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_cgm IN (
					SELECT
					  rowid row_id
					FROM v_cube_gen_example_model
					WHERE fk_cub_name = p_fk_cub_name
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_cube_gen_example_model SET
						cube_sequence = l_cube_count
					WHERE rowid = r_cgm.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_cgm (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_id IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_cgm (l_cube_sequence, p_cube_pos_action, x_fk_cub_name, x_id);
		UPDATE v_cube_gen_example_model SET
			cube_sequence = l_cube_sequence
		WHERE fk_cub_name = p_fk_cub_name
		  AND id = p_id;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type cube_gen_example_model not found');
		END IF;
	END;

	PROCEDURE insert_cgm (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_included_object_names IN VARCHAR2,
			p_description IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_id IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_cgm (l_cube_sequence, p_cube_pos_action, x_fk_cub_name, x_id);
		INSERT INTO v_cube_gen_example_model (
			cube_id,
			cube_sequence,
			fk_cub_name,
			id,
			header,
			included_object_names,
			description)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_cub_name,
			p_id,
			p_header,
			p_included_object_names,
			p_description);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type cube_gen_example_model already exists');
	END;

	PROCEDURE update_cgm (
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_included_object_names IN VARCHAR2,
			p_description IN VARCHAR2) IS
	BEGIN
		UPDATE v_cube_gen_example_model SET
			header = p_header,
			included_object_names = p_included_object_names,
			description = p_description
		WHERE fk_cub_name = p_fk_cub_name
		  AND id = p_id;
	END;

	PROCEDURE delete_cgm (
			p_fk_cub_name IN VARCHAR2,
			p_id IN VARCHAR2) IS
	BEGIN
		DELETE v_cube_gen_example_model
		WHERE fk_cub_name = p_fk_cub_name
		  AND id = p_id;
	END;

	PROCEDURE determine_position_cgo (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_cube_gen_example_object
				WHERE fk_cub_name = p_fk_cub_name
				  AND fk_cgm_id = p_fk_cgm_id
				  AND xk_bot_name = p_xk_bot_name;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_cube_gen_example_object
			WHERE fk_cub_name = p_fk_cub_name
			  AND fk_cgm_id = p_fk_cgm_id
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_cgo IN (
					SELECT
					  rowid row_id
					FROM v_cube_gen_example_object
					WHERE fk_cub_name = p_fk_cub_name
					  AND fk_cgm_id = p_fk_cgm_id
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_cube_gen_example_object SET
						cube_sequence = l_cube_count
					WHERE rowid = r_cgo.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_cgo (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_fk_cgm_id IN VARCHAR2,
			x_xk_bot_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_cgo (l_cube_sequence, p_cube_pos_action, x_fk_cub_name, x_fk_cgm_id, x_xk_bot_name);
		UPDATE v_cube_gen_example_object SET
			cube_sequence = l_cube_sequence
		WHERE fk_cub_name = p_fk_cub_name
		  AND fk_cgm_id = p_fk_cgm_id
		  AND xk_bot_name = p_xk_bot_name;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type cube_gen_example_object not found');
		END IF;
	END;

	PROCEDURE insert_cgo (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			x_fk_cub_name IN VARCHAR2,
			x_fk_cgm_id IN VARCHAR2,
			x_xk_bot_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_cgo (l_cube_sequence, p_cube_pos_action, x_fk_cub_name, x_fk_cgm_id, x_xk_bot_name);
		INSERT INTO v_cube_gen_example_object (
			cube_id,
			cube_sequence,
			fk_cub_name,
			fk_cgm_id,
			xk_bot_name)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_cub_name,
			p_fk_cgm_id,
			p_xk_bot_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type cube_gen_example_object already exists');
	END;

	PROCEDURE delete_cgo (
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2) IS
	BEGIN
		DELETE v_cube_gen_example_object
		WHERE fk_cub_name = p_fk_cub_name
		  AND fk_cgm_id = p_fk_cgm_id
		  AND xk_bot_name = p_xk_bot_name;
	END;

	PROCEDURE get_cgf (
			p_cube_row IN OUT c_cube_row,
			p_id IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_cub_name,
			  fk_cgm_id,
			  header,
			  description,
			  template
			FROM v_cube_gen_function
			WHERE id = p_id;
	END;

	PROCEDURE determine_position_cgf (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_id IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_cube_gen_function
				WHERE id = p_id;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_cube_gen_function
			WHERE fk_cub_name = p_fk_cub_name
			  AND fk_cgm_id = p_fk_cgm_id
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_cgf IN (
					SELECT
					  rowid row_id
					FROM v_cube_gen_function
					WHERE fk_cub_name = p_fk_cub_name
					  AND fk_cgm_id = p_fk_cgm_id
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_cube_gen_function SET
						cube_sequence = l_cube_count
					WHERE rowid = r_cgf.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_cgf (
			p_cube_pos_action IN VARCHAR2,
			p_id IN VARCHAR2,
			x_id IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
		l_fk_cub_name v_cube_gen_function.fk_cub_name%TYPE;
		l_fk_cgm_id v_cube_gen_function.fk_cgm_id%TYPE;
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN ('B', 'A') THEN
			SELECT fk_cub_name, fk_cgm_id
			INTO l_fk_cub_name, l_fk_cgm_id
			FROM v_cube_gen_function
			WHERE id = x_id;
		ELSE
			SELECT fk_cub_name, fk_cgm_id
			INTO l_fk_cub_name, l_fk_cgm_id
			FROM v_cube_gen_function
			WHERE id = x_id;
		END IF;
		determine_position_cgf (l_cube_sequence, p_cube_pos_action, l_fk_cub_name, l_fk_cgm_id, x_id);
		UPDATE v_cube_gen_function SET
			fk_cub_name = l_fk_cub_name,
			fk_cgm_id = l_fk_cgm_id,
			cube_sequence = l_cube_sequence
		WHERE id = p_id;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type cube_gen_function not found');
		END IF;
	END;

	PROCEDURE insert_cgf (
			p_cube_pos_action IN VARCHAR2,
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_description IN VARCHAR2,
			p_template IN VARCHAR2,
			x_id IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_cgf (l_cube_sequence, p_cube_pos_action, p_fk_cub_name, p_fk_cgm_id, x_id);
		INSERT INTO v_cube_gen_function (
			cube_id,
			cube_sequence,
			fk_cub_name,
			fk_cgm_id,
			id,
			header,
			description,
			template)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_cub_name,
			p_fk_cgm_id,
			p_id,
			p_header,
			p_description,
			p_template);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type cube_gen_function already exists');
	END;

	PROCEDURE update_cgf (
			p_fk_cub_name IN VARCHAR2,
			p_fk_cgm_id IN VARCHAR2,
			p_id IN VARCHAR2,
			p_header IN VARCHAR2,
			p_description IN VARCHAR2,
			p_template IN VARCHAR2) IS
	BEGIN
		UPDATE v_cube_gen_function SET
			fk_cub_name = p_fk_cub_name,
			fk_cgm_id = p_fk_cgm_id,
			header = p_header,
			description = p_description,
			template = p_template
		WHERE id = p_id;
	END;

	PROCEDURE delete_cgf (
			p_id IN VARCHAR2) IS
	BEGIN
		DELETE v_cube_gen_function
		WHERE id = p_id;
	END;

	PROCEDURE get_ctf (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_indication_logical IN CHAR) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  description,
			  syntax
			FROM v_cube_gen_template_function
			WHERE fk_cub_name = p_fk_cub_name
			  AND name = p_name
			  AND indication_logical = p_indication_logical;
	END;

	PROCEDURE get_next_ctf (
			p_cube_row IN OUT c_cube_row,
			p_fk_cub_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_indication_logical IN CHAR) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_cub_name,
			  name,
			  indication_logical
			FROM v_cube_gen_template_function
			WHERE fk_cub_name > p_fk_cub_name
			   OR 	    ( fk_cub_name = p_fk_cub_name
				  AND name > p_name )
			   OR 	    ( fk_cub_name = p_fk_cub_name
				  AND name = p_name
				  AND indication_logical > p_indication_logical )
			ORDER BY fk_cub_name, name, indication_logical;
	END;

	PROCEDURE insert_ctf (
			p_fk_cub_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_indication_logical IN CHAR,
			p_description IN VARCHAR2,
			p_syntax IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_cube_gen_template_function (
			cube_id,
			fk_cub_name,
			name,
			indication_logical,
			description,
			syntax)
		VALUES (
			NULL,
			p_fk_cub_name,
			p_name,
			p_indication_logical,
			p_description,
			p_syntax);

		get_next_ctf (p_cube_row, p_fk_cub_name, p_name, p_indication_logical);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type cube_gen_template_function already exists');
	END;

	PROCEDURE update_ctf (
			p_fk_cub_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_indication_logical IN CHAR,
			p_description IN VARCHAR2,
			p_syntax IN VARCHAR2) IS
	BEGIN
		UPDATE v_cube_gen_template_function SET
			description = p_description,
			syntax = p_syntax
		WHERE fk_cub_name = p_fk_cub_name
		  AND name = p_name
		  AND indication_logical = p_indication_logical;
	END;

	PROCEDURE delete_ctf (
			p_fk_cub_name IN VARCHAR2,
			p_name IN VARCHAR2,
			p_indication_logical IN CHAR) IS
	BEGIN
		DELETE v_cube_gen_template_function
		WHERE fk_cub_name = p_fk_cub_name
		  AND name = p_name
		  AND indication_logical = p_indication_logical;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE pkg_sys IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_pkg_cubedocu RETURN VARCHAR2;
	PROCEDURE get_sys_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_sys (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_sys_sbt_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE insert_sys (
			p_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_database IN VARCHAR2,
			p_schema IN VARCHAR2,
			p_password IN VARCHAR2,
			p_table_prefix IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_sys (
			p_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_database IN VARCHAR2,
			p_schema IN VARCHAR2,
			p_password IN VARCHAR2,
			p_table_prefix IN VARCHAR2);
	PROCEDURE delete_sys (
			p_name IN VARCHAR2);
	PROCEDURE move_sbt (
			p_cube_pos_action IN VARCHAR2,
			p_fk_sys_name IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			x_fk_sys_name IN VARCHAR2,
			x_xk_bot_name IN VARCHAR2);
	PROCEDURE insert_sbt (
			p_cube_pos_action IN VARCHAR2,
			p_fk_sys_name IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			x_fk_sys_name IN VARCHAR2,
			x_xk_bot_name IN VARCHAR2);
	PROCEDURE delete_sbt (
			p_fk_sys_name IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_sys IS
	FUNCTION cube_pkg_cubedocu RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubedocu';
	END;

	PROCEDURE get_sys_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  name,
			  cube_tsg_type
			FROM v_system
			ORDER BY name, cube_tsg_type;
	END;

	PROCEDURE get_sys (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_type,
			  database,
			  schema,
			  password,
			  table_prefix
			FROM v_system
			WHERE name = p_name;
	END;

	PROCEDURE get_sys_sbt_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_sys_name,
			  xk_bot_name
			FROM v_system_bo_type
			WHERE fk_sys_name = p_name
			ORDER BY fk_sys_name, cube_sequence;
	END;

	PROCEDURE get_next_sys (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  name
			FROM v_system
			WHERE name > p_name
			ORDER BY name;
	END;

	PROCEDURE insert_sys (
			p_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_database IN VARCHAR2,
			p_schema IN VARCHAR2,
			p_password IN VARCHAR2,
			p_table_prefix IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_system (
			cube_id,
			name,
			cube_tsg_type,
			database,
			schema,
			password,
			table_prefix)
		VALUES (
			NULL,
			p_name,
			p_cube_tsg_type,
			p_database,
			p_schema,
			p_password,
			p_table_prefix);

		get_next_sys (p_cube_row, p_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type system already exists');
	END;

	PROCEDURE update_sys (
			p_name IN VARCHAR2,
			p_cube_tsg_type IN VARCHAR2,
			p_database IN VARCHAR2,
			p_schema IN VARCHAR2,
			p_password IN VARCHAR2,
			p_table_prefix IN VARCHAR2) IS
	BEGIN
		UPDATE v_system SET
			cube_tsg_type = p_cube_tsg_type,
			database = p_database,
			schema = p_schema,
			password = p_password,
			table_prefix = p_table_prefix
		WHERE name = p_name;
	END;

	PROCEDURE delete_sys (
			p_name IN VARCHAR2) IS
	BEGIN
		DELETE v_system
		WHERE name = p_name;
	END;

	PROCEDURE determine_position_sbt (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_sys_name IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2) IS
		l_cube_pos_action VARCHAR2(1);
		l_cube_position_sequ NUMBER(8);
		l_cube_near_sequ NUMBER(8);
		l_cube_count NUMBER(8) := 1024;
	BEGIN
		-- A=After B=Before F=First L=Last
		CASE p_cube_pos_action
		WHEN 'F' THEN
			l_cube_position_sequ := 0;
			l_cube_pos_action := 'A';
		WHEN 'L' THEN
			l_cube_position_sequ := 99999999;
			l_cube_pos_action := 'B';
		ELSE
			l_cube_pos_action := p_cube_pos_action;
		END CASE;
		LOOP
			IF p_cube_pos_action IN ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT NVL (MAX (cube_sequence), DECODE (p_cube_pos_action, 'B', 99999999, 0))
				INTO l_cube_position_sequ
				FROM v_system_bo_type
				WHERE fk_sys_name = p_fk_sys_name
				  AND xk_bot_name = p_xk_bot_name;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_system_bo_type
			WHERE fk_sys_name = p_fk_sys_name
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_sbt IN (
					SELECT
					  rowid row_id
					FROM v_system_bo_type
					WHERE fk_sys_name = p_fk_sys_name
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_system_bo_type SET
						cube_sequence = l_cube_count
					WHERE rowid = r_sbt.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_sbt (
			p_cube_pos_action IN VARCHAR2,
			p_fk_sys_name IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			x_fk_sys_name IN VARCHAR2,
			x_xk_bot_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_sbt (l_cube_sequence, p_cube_pos_action, x_fk_sys_name, x_xk_bot_name);
		UPDATE v_system_bo_type SET
			cube_sequence = l_cube_sequence
		WHERE fk_sys_name = p_fk_sys_name
		  AND xk_bot_name = p_xk_bot_name;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type system_bo_type not found');
		END IF;
	END;

	PROCEDURE insert_sbt (
			p_cube_pos_action IN VARCHAR2,
			p_fk_sys_name IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2,
			x_fk_sys_name IN VARCHAR2,
			x_xk_bot_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_sbt (l_cube_sequence, p_cube_pos_action, x_fk_sys_name, x_xk_bot_name);
		INSERT INTO v_system_bo_type (
			cube_id,
			cube_sequence,
			fk_sys_name,
			xk_bot_name)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_sys_name,
			p_xk_bot_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type system_bo_type already exists');
	END;

	PROCEDURE delete_sbt (
			p_fk_sys_name IN VARCHAR2,
			p_xk_bot_name IN VARCHAR2) IS
	BEGIN
		DELETE v_system_bo_type
		WHERE fk_sys_name = p_fk_sys_name
		  AND xk_bot_name = p_xk_bot_name;
	END;
END;
/
SHOW ERRORS;

EXIT;