-- CUBETOOL Packages
--
BEGIN
	FOR r_pck IN (
		SELECT object_name
		FROM all_procedures p
		WHERE p.owner = 'CUBETOOL'
		  AND p.procedure_name = 'CUBE_PACKAGE' )
	LOOP
		EXECUTE IMMEDIATE 'DROP PACKAGE CUBETOOL.'||r_pck.object_name;
	END LOOP;
END;
/
CREATE OR REPLACE PACKAGE pkg_cube IS
	FUNCTION cube_package RETURN VARCHAR2;
	FUNCTION years(p_date DATE) RETURN NUMBER;
	FUNCTION multiply(p_num_1 NUMBER, p_num_2 NUMBER) RETURN NUMBER;
	FUNCTION add(p_num_1 NUMBER, p_num_2 NUMBER) RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY pkg_cube IS
	FUNCTION cube_package RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_package';
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
	FUNCTION cube_package RETURN VARCHAR2;
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
			p_domain IN CHAR,
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
			p_domain IN CHAR,
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
	FUNCTION cube_package RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_package';
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
			p_domain IN CHAR,
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
			p_domain IN CHAR,
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
	FUNCTION cube_package RETURN VARCHAR2;
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
			p_cube_tsg_int_ext IN VARCHAR2,
			p_directory IN VARCHAR2,
			p_api_url IN VARCHAR2,
			x_name IN VARCHAR2);
	PROCEDURE update_bot (
			p_name IN VARCHAR2,
			p_cube_tsg_int_ext IN VARCHAR2,
			p_directory IN VARCHAR2,
			p_api_url IN VARCHAR2);
	PROCEDURE delete_bot (
			p_name IN VARCHAR2);
	PROCEDURE get_typ_list_all (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_typ_list_encapsulated (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_list_recursive (
			p_cube_row IN OUT c_cube_row,
			p_cube_up_or_down IN VARCHAR2,
			p_cube_x_level IN NUMBER,
			p_name IN VARCHAR2);
	PROCEDURE get_typ (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_fkey (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_atb_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_ref_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_tyr_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_par_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_tsg_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_dct_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE get_typ_typ_items (
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
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_ref_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_ref_dcr_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_ref_rtr_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE count_ref_dcr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE move_ref (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_sequence IN NUMBER,
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
			p_within_scope_level IN NUMBER,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_sequence IN NUMBER,
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
			p_within_scope_level IN NUMBER,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2);
	PROCEDURE delete_ref (
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_dcr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2);
	PROCEDURE insert_dcr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2,
			p_text IN VARCHAR2);
	PROCEDURE update_dcr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2,
			p_text IN VARCHAR2);
	PROCEDURE delete_dcr (
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2);
	PROCEDURE get_rtr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE insert_rtr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
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
			p_fk_ref_typ_name IN VARCHAR2,
			p_include_or_exclude IN CHAR,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE delete_rtr (
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2);
	PROCEDURE get_tyr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE insert_tyr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_cardinality IN CHAR,
			p_xk_typ_name IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_tyr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_cardinality IN CHAR,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE delete_tyr (
			p_fk_typ_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2);
	PROCEDURE get_par (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE get_par_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE get_par_stp_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE insert_par (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE update_par (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE delete_par (
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE get_stp (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE move_stp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
			p_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_fk_par_name IN VARCHAR2,
			x_name IN VARCHAR2);
	PROCEDURE insert_stp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
			p_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_fk_par_name IN VARCHAR2,
			x_name IN VARCHAR2);
	PROCEDURE update_stp (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
			p_name IN VARCHAR2);
	PROCEDURE delete_stp (
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
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
	FUNCTION cube_package RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_package';
	END;

	PROCEDURE get_bot_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  name
			FROM v_business_object_type
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_bot_list (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  name
			FROM v_business_object_type
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_bot (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_int_ext,
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
			p_cube_tsg_int_ext IN VARCHAR2,
			p_directory IN VARCHAR2,
			p_api_url IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_bot (l_cube_sequence, p_cube_pos_action, x_name);
		INSERT INTO v_business_object_type (
			cube_id,
			cube_sequence,
			name,
			cube_tsg_int_ext,
			directory,
			api_url)
		VALUES (
			NULL,
			l_cube_sequence,
			p_name,
			p_cube_tsg_int_ext,
			p_directory,
			p_api_url);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type business_object_type already exists');
	END;

	PROCEDURE update_bot (
			p_name IN VARCHAR2,
			p_cube_tsg_int_ext IN VARCHAR2,
			p_directory IN VARCHAR2,
			p_api_url IN VARCHAR2) IS
	BEGIN
		UPDATE v_business_object_type SET
			cube_tsg_int_ext = p_cube_tsg_int_ext,
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

	PROCEDURE get_typ_list_encapsulated (
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
			   OR 	    ( 	NOT ( fk_bot_name = p_name
					  AND p_name IS NOT NULL )
				  AND fk_typ_name IS NULL )
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_typ_list_recursive (
			p_cube_row IN OUT c_cube_row,
			p_cube_up_or_down IN VARCHAR2,
			p_cube_x_level IN NUMBER,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			WITH anchor (
				cube_sequence,
				name,
				code,
				fk_typ_name,
				cube_x_level) AS (
				SELECT
					cube_sequence,
					name,
					code,
					fk_typ_name,
					0 
				FROM v_type
				WHERE name = p_name
				UNION ALL
				SELECT
					recursive.cube_sequence,
					recursive.name,
					recursive.code,
					recursive.fk_typ_name,
					anchor.cube_x_level+1
				FROM v_type recursive, anchor
				WHERE 	    ( 	    ( p_cube_up_or_down = 'D'
						  AND anchor.name = recursive.fk_typ_name )
					   OR 	    ( p_cube_up_or_down = 'U'
						  AND anchor.fk_typ_name = recursive.name ) )
				  AND anchor.cube_x_level < p_cube_x_level
				)
			SELECT DISTINCT cube_sequence, name, code
			FROM anchor
			WHERE cube_x_level > 0
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
			  xk_typ_name
			FROM v_reference
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name, cube_sequence;
	END;

	PROCEDURE get_typ_tyr_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  xk_typ_name
			FROM v_type_reuse
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name, xk_typ_name;
	END;

	PROCEDURE get_typ_par_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  name
			FROM v_partition
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name, name;
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
			  fk_atb_name
			FROM v_derivation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name
			ORDER BY fk_typ_name, fk_atb_name;
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
			  within_scope_level,
			  xk_typ_name_1
			FROM v_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND sequence = p_sequence
			  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_ref_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name
			FROM v_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND sequence = p_sequence
			  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_ref_dcr_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
			  fk_ref_typ_name
			FROM v_description_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_typ_name = p_xk_typ_name
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_typ_name;
	END;

	PROCEDURE get_ref_rtr_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
			  fk_ref_typ_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM v_restriction_type_spec_ref
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_typ_name = p_xk_typ_name
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;

	PROCEDURE count_ref_dcr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_description_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_typ_name = p_xk_typ_name;
	END;

	PROCEDURE determine_position_ref (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
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
			p_xk_typ_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_sequence IN NUMBER,
			x_xk_typ_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_ref (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_sequence, x_xk_typ_name);
		UPDATE v_reference SET
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND sequence = p_sequence
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
			p_within_scope_level IN NUMBER,
			p_xk_typ_name IN VARCHAR2,
			p_xk_typ_name_1 IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_sequence IN NUMBER,
			x_xk_typ_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_ref (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_sequence, x_xk_typ_name);
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
			within_scope_level,
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
			p_within_scope_level,
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
			p_within_scope_level IN NUMBER,
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
			within_scope_level = p_within_scope_level,
			xk_typ_name_1 = p_xk_typ_name_1
		WHERE fk_typ_name = p_fk_typ_name
		  AND sequence = p_sequence
		  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE delete_ref (
			p_fk_typ_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		DELETE v_reference
		WHERE fk_typ_name = p_fk_typ_name
		  AND sequence = p_sequence
		  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_dcr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  text
			FROM v_description_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_fk_ref_sequence
			  AND fk_ref_typ_name = p_fk_ref_typ_name;
	END;

	PROCEDURE insert_dcr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2,
			p_text IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_description_reference (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_typ_name,
			text)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_ref_sequence,
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
			p_fk_ref_typ_name IN VARCHAR2,
			p_text IN VARCHAR2) IS
	BEGIN
		UPDATE v_description_reference SET
			fk_bot_name = p_fk_bot_name,
			text = p_text
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_typ_name = p_fk_ref_typ_name;
	END;

	PROCEDURE delete_dcr (
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2) IS
	BEGIN
		DELETE v_description_reference
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_typ_name = p_fk_ref_typ_name;
	END;

	PROCEDURE get_rtr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
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
			  AND fk_ref_typ_name = p_fk_ref_typ_name
			  AND xf_tsp_typ_name = p_xf_tsp_typ_name
			  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
			  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE get_next_rtr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
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
				  AND fk_ref_typ_name > p_fk_ref_typ_name )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_ref_sequence = p_fk_ref_sequence
				  AND fk_ref_typ_name = p_fk_ref_typ_name
				  AND xf_tsp_typ_name > p_xf_tsp_typ_name )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_ref_sequence = p_fk_ref_sequence
				  AND fk_ref_typ_name = p_fk_ref_typ_name
				  AND xf_tsp_typ_name = p_xf_tsp_typ_name
				  AND xf_tsp_tsg_code > p_xf_tsp_tsg_code )
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND fk_ref_sequence = p_fk_ref_sequence
				  AND fk_ref_typ_name = p_fk_ref_typ_name
				  AND xf_tsp_typ_name = p_xf_tsp_typ_name
				  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
				  AND xk_tsp_code > p_xk_tsp_code )
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;

	PROCEDURE insert_rtr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
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
			p_fk_ref_typ_name,
			p_include_or_exclude,
			p_xf_tsp_typ_name,
			p_xf_tsp_tsg_code,
			p_xk_tsp_code);

		get_next_rtr (p_cube_row, p_fk_typ_name, p_fk_ref_sequence, p_fk_ref_typ_name, p_xf_tsp_typ_name, p_xf_tsp_tsg_code, p_xk_tsp_code);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type restriction_type_spec_ref already exists');
	END;

	PROCEDURE update_rtr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
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
		  AND fk_ref_typ_name = p_fk_ref_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE delete_rtr (
			p_fk_typ_name IN VARCHAR2,
			p_fk_ref_sequence IN NUMBER,
			p_fk_ref_typ_name IN VARCHAR2,
			p_xf_tsp_typ_name IN VARCHAR2,
			p_xf_tsp_tsg_code IN VARCHAR2,
			p_xk_tsp_code IN VARCHAR2) IS
	BEGIN
		DELETE v_restriction_type_spec_ref
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_typ_name = p_fk_ref_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;

	PROCEDURE get_tyr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name,
			  cardinality
			FROM v_type_reuse
			WHERE fk_typ_name = p_fk_typ_name
			  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_next_tyr (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_typ_name,
			  xk_typ_name
			FROM v_type_reuse
			WHERE fk_typ_name > p_fk_typ_name
			   OR 	    ( fk_typ_name = p_fk_typ_name
				  AND xk_typ_name > p_xk_typ_name )
			ORDER BY fk_typ_name, xk_typ_name;
	END;

	PROCEDURE insert_tyr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_cardinality IN CHAR,
			p_xk_typ_name IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_type_reuse (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			cardinality,
			xk_typ_name)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_cardinality,
			p_xk_typ_name);

		get_next_tyr (p_cube_row, p_fk_typ_name, p_xk_typ_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type type_reuse already exists');
	END;

	PROCEDURE update_tyr (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_cardinality IN CHAR,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		UPDATE v_type_reuse SET
			fk_bot_name = p_fk_bot_name,
			cardinality = p_cardinality
		WHERE fk_typ_name = p_fk_typ_name
		  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE delete_tyr (
			p_fk_typ_name IN VARCHAR2,
			p_xk_typ_name IN VARCHAR2) IS
	BEGIN
		DELETE v_type_reuse
		WHERE fk_typ_name = p_fk_typ_name
		  AND xk_typ_name = p_xk_typ_name;
	END;

	PROCEDURE get_par (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name
			FROM v_partition
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = p_name;
	END;

	PROCEDURE get_par_fkey (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name
			FROM v_partition
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = p_name;
	END;

	PROCEDURE get_par_stp_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  fk_par_name,
			  name
			FROM v_subtype
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_par_name = p_name
			ORDER BY fk_typ_name, fk_par_name, cube_sequence;
	END;

	PROCEDURE insert_par (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_partition (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			name)
		VALUES (
			NULL,
			p_fk_bot_name,
			p_fk_typ_name,
			p_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type partition already exists');
	END;

	PROCEDURE update_par (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		UPDATE v_partition SET
			fk_bot_name = p_fk_bot_name
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name;
	END;

	PROCEDURE delete_par (
			p_fk_typ_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		DELETE v_partition
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name;
	END;

	PROCEDURE get_stp (
			p_cube_row IN OUT c_cube_row,
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_bot_name
			FROM v_subtype
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_par_name = p_fk_par_name
			  AND name = p_name;
	END;

	PROCEDURE determine_position_stp (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
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
				FROM v_subtype
				WHERE fk_typ_name = p_fk_typ_name
				  AND fk_par_name = p_fk_par_name
				  AND name = p_name;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_subtype
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_par_name = p_fk_par_name
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_stp IN (
					SELECT
					  rowid row_id
					FROM v_subtype
					WHERE fk_typ_name = p_fk_typ_name
					  AND fk_par_name = p_fk_par_name
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_subtype SET
						cube_sequence = l_cube_count
					WHERE rowid = r_stp.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_stp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
			p_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_fk_par_name IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_stp (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_fk_par_name, x_name);
		UPDATE v_subtype SET
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_par_name = p_fk_par_name
		  AND name = p_name;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type subtype not found');
		END IF;
	END;

	PROCEDURE insert_stp (
			p_cube_pos_action IN VARCHAR2,
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
			p_name IN VARCHAR2,
			x_fk_typ_name IN VARCHAR2,
			x_fk_par_name IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_stp (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_fk_par_name, x_name);
		INSERT INTO v_subtype (
			cube_id,
			cube_sequence,
			fk_bot_name,
			fk_typ_name,
			fk_par_name,
			name)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_bot_name,
			p_fk_typ_name,
			p_fk_par_name,
			p_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type subtype already exists');
	END;

	PROCEDURE update_stp (
			p_fk_bot_name IN VARCHAR2,
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		UPDATE v_subtype SET
			fk_bot_name = p_fk_bot_name
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_par_name = p_fk_par_name
		  AND name = p_name;
	END;

	PROCEDURE delete_stp (
			p_fk_typ_name IN VARCHAR2,
			p_fk_par_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		DELETE v_subtype
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_par_name = p_fk_par_name
		  AND name = p_name;
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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

CREATE OR REPLACE PACKAGE pkg_sys IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_package RETURN VARCHAR2;
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
			p_database IN VARCHAR2,
			p_schema IN VARCHAR2,
			p_password IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_sys (
			p_name IN VARCHAR2,
			p_database IN VARCHAR2,
			p_schema IN VARCHAR2,
			p_password IN VARCHAR2);
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
	FUNCTION cube_package RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_package';
	END;

	PROCEDURE get_sys_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  name
			FROM v_system
			ORDER BY name;
	END;

	PROCEDURE get_sys (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  database,
			  schema,
			  password
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
			p_database IN VARCHAR2,
			p_schema IN VARCHAR2,
			p_password IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_system (
			cube_id,
			name,
			database,
			schema,
			password)
		VALUES (
			NULL,
			p_name,
			p_database,
			p_schema,
			p_password);

		get_next_sys (p_cube_row, p_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type system already exists');
	END;

	PROCEDURE update_sys (
			p_name IN VARCHAR2,
			p_database IN VARCHAR2,
			p_schema IN VARCHAR2,
			p_password IN VARCHAR2) IS
	BEGIN
		UPDATE v_system SET
			database = p_database,
			schema = p_schema,
			password = p_password
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
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

CREATE OR REPLACE PACKAGE pkg_fun IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_package RETURN VARCHAR2;
	PROCEDURE get_fun_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE count_fun (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_fun_arg_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2);
	PROCEDURE insert_fun (
			p_name IN VARCHAR2);
	PROCEDURE delete_fun (
			p_name IN VARCHAR2);
	PROCEDURE move_arg (
			p_cube_pos_action IN VARCHAR2,
			p_fk_fun_name IN VARCHAR2,
			p_name IN VARCHAR2,
			x_fk_fun_name IN VARCHAR2,
			x_name IN VARCHAR2);
	PROCEDURE insert_arg (
			p_cube_pos_action IN VARCHAR2,
			p_fk_fun_name IN VARCHAR2,
			p_name IN VARCHAR2,
			x_fk_fun_name IN VARCHAR2,
			x_name IN VARCHAR2);
	PROCEDURE delete_arg (
			p_fk_fun_name IN VARCHAR2,
			p_name IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_fun IS
	FUNCTION cube_package RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_package';
	END;

	PROCEDURE get_fun_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  name
			FROM v_function
			ORDER BY name;
	END;

	PROCEDURE count_fun (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_function;
	END;

	PROCEDURE get_fun_arg_items (
			p_cube_row IN OUT c_cube_row,
			p_name IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_fun_name,
			  name
			FROM v_argument
			WHERE fk_fun_name = p_name
			ORDER BY fk_fun_name, cube_sequence;
	END;

	PROCEDURE insert_fun (
			p_name IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_function (
			cube_id,
			name)
		VALUES (
			NULL,
			p_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type function already exists');
	END;

	PROCEDURE delete_fun (
			p_name IN VARCHAR2) IS
	BEGIN
		DELETE v_function
		WHERE name = p_name;
	END;

	PROCEDURE determine_position_arg (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_fun_name IN VARCHAR2,
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
				FROM v_argument
				WHERE fk_fun_name = p_fk_fun_name
				  AND name = p_name;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_argument
			WHERE fk_fun_name = p_fk_fun_name
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_arg IN (
					SELECT
					  rowid row_id
					FROM v_argument
					WHERE fk_fun_name = p_fk_fun_name
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_argument SET
						cube_sequence = l_cube_count
					WHERE rowid = r_arg.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_arg (
			p_cube_pos_action IN VARCHAR2,
			p_fk_fun_name IN VARCHAR2,
			p_name IN VARCHAR2,
			x_fk_fun_name IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_arg (l_cube_sequence, p_cube_pos_action, x_fk_fun_name, x_name);
		UPDATE v_argument SET
			cube_sequence = l_cube_sequence
		WHERE fk_fun_name = p_fk_fun_name
		  AND name = p_name;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type argument not found');
		END IF;
	END;

	PROCEDURE insert_arg (
			p_cube_pos_action IN VARCHAR2,
			p_fk_fun_name IN VARCHAR2,
			p_name IN VARCHAR2,
			x_fk_fun_name IN VARCHAR2,
			x_name IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF p_cube_pos_action NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_arg (l_cube_sequence, p_cube_pos_action, x_fk_fun_name, x_name);
		INSERT INTO v_argument (
			cube_id,
			cube_sequence,
			fk_fun_name,
			name)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_fun_name,
			p_name);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type argument already exists');
	END;

	PROCEDURE delete_arg (
			p_fk_fun_name IN VARCHAR2,
			p_name IN VARCHAR2) IS
	BEGIN
		DELETE v_argument
		WHERE fk_fun_name = p_fk_fun_name
		  AND name = p_name;
	END;
END;
/
SHOW ERRORS;

EXIT;