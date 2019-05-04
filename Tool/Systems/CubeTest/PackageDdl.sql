-- CUBETEST Packages
--
BEGIN
	FOR r_pck IN (
		SELECT object_name
		FROM all_procedures p
		WHERE p.owner = 'CUBETEST'
		  AND p.procedure_name = 'CUBE_PACKAGE' )
	LOOP
		EXECUTE IMMEDIATE 'DROP PACKAGE CUBETEST.'||r_pck.object_name;
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
CREATE OR REPLACE PACKAGE pkg_aaa IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_package RETURN VARCHAR2;
	PROCEDURE get_aaa_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_aaa_list_all (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_aaa (
			p_cube_row IN OUT c_cube_row,
			p_naam IN VARCHAR2);
	PROCEDURE get_aaa_aad_items (
			p_cube_row IN OUT c_cube_row,
			p_naam IN VARCHAR2);
	PROCEDURE get_aaa_aaa_items (
			p_cube_row IN OUT c_cube_row,
			p_naam IN VARCHAR2);
	PROCEDURE change_parent_aaa (
			p_cube_flag_root IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_naam IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE insert_aaa (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_aaa (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2);
	PROCEDURE delete_aaa (
			p_naam IN VARCHAR2);
	PROCEDURE get_aad (
			p_cube_row IN OUT c_cube_row,
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE move_aad (
			p_cube_pos_action IN VARCHAR2,
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_fk_aaa_naam IN VARCHAR2,
			x_naam IN VARCHAR2);
	PROCEDURE insert_aad (
			p_cube_pos_action IN VARCHAR2,
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2,
			x_fk_aaa_naam IN VARCHAR2,
			x_naam IN VARCHAR2);
	PROCEDURE update_aad (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2);
	PROCEDURE delete_aad (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_aaa IS
	FUNCTION cube_package RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_package';
	END;

	PROCEDURE get_aaa_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  naam
			FROM v_aaa
			WHERE fk_aaa_naam IS NULL
			ORDER BY naam;
	END;

	PROCEDURE get_aaa_list_all (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  naam
			FROM v_aaa
			ORDER BY naam;
	END;

	PROCEDURE get_aaa (
			p_cube_row IN OUT c_cube_row,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_aaa_naam,
			  omschrijving,
			  xk_aaa_naam
			FROM v_aaa
			WHERE naam = p_naam;
	END;

	PROCEDURE get_aaa_aad_items (
			p_cube_row IN OUT c_cube_row,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_aaa_naam,
			  naam
			FROM v_aaa_deel
			WHERE fk_aaa_naam = p_naam
			ORDER BY fk_aaa_naam, cube_sequence;
	END;

	PROCEDURE get_aaa_aaa_items (
			p_cube_row IN OUT c_cube_row,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  naam
			FROM v_aaa
			WHERE fk_aaa_naam = p_naam
			ORDER BY naam;
	END;

	PROCEDURE check_no_part_aaa (
			p_naam IN VARCHAR2,
			x_naam IN VARCHAR2) IS
		l_naam v_aaa.naam%TYPE;
	BEGIN
		l_naam := x_naam;
		LOOP
			IF l_naam IS NULL THEN
				EXIT; -- OK
			END IF;
			IF l_naam = p_naam THEN
				RAISE_APPLICATION_ERROR (-20003, 'Target Type aaa in hierarchy of moving object');
			END IF;
			SELECT fk_aaa_naam
			INTO l_naam
			FROM v_aaa
			WHERE naam = l_naam;
		END LOOP;
	END;

	PROCEDURE get_next_aaa (
			p_cube_row IN OUT c_cube_row,
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  naam
			FROM v_aaa
			WHERE naam > p_naam
			  AND 	    ( 	    ( fk_aaa_naam IS NULL
					  AND p_fk_aaa_naam IS NULL )
				   OR fk_aaa_naam = p_fk_aaa_naam )
			ORDER BY naam;
	END;

	PROCEDURE change_parent_aaa (
			p_cube_flag_root IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_naam IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		IF p_cube_flag_root = 'Y' THEN
			UPDATE v_aaa SET
				fk_aaa_naam = NULL
			WHERE naam = p_naam;
			IF SQL%NOTFOUND THEN
				RAISE_APPLICATION_ERROR (-20002, 'Type aaa not found');
			END IF;
			get_next_aaa (p_cube_row, NULL, p_naam);
		ELSE
			check_no_part_aaa (p_naam, x_naam);
			UPDATE v_aaa SET
				fk_aaa_naam = x_naam
			WHERE naam = p_naam;
			IF SQL%NOTFOUND THEN
				RAISE_APPLICATION_ERROR (-20002, 'Type aaa not found');
			END IF;
			get_next_aaa (p_cube_row, x_naam, p_naam);
		END IF;
	END;

	PROCEDURE insert_aaa (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_aaa (
			cube_id,
			cube_level,
			fk_aaa_naam,
			naam,
			omschrijving,
			xk_aaa_naam)
		VALUES (
			NULL,
			NULL,
			p_fk_aaa_naam,
			p_naam,
			p_omschrijving,
			p_xk_aaa_naam);

		get_next_aaa (p_cube_row, p_fk_aaa_naam, p_naam);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type aaa already exists');
	END;

	PROCEDURE update_aaa (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2) IS
	BEGIN
		UPDATE v_aaa SET
			fk_aaa_naam = p_fk_aaa_naam,
			omschrijving = p_omschrijving,
			xk_aaa_naam = p_xk_aaa_naam
		WHERE naam = p_naam;
	END;

	PROCEDURE delete_aaa (
			p_naam IN VARCHAR2) IS
	BEGIN
		DELETE v_aaa
		WHERE naam = p_naam;
	END;

	PROCEDURE get_aad (
			p_cube_row IN OUT c_cube_row,
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  xk_aaa_naam
			FROM v_aaa_deel
			WHERE fk_aaa_naam = p_fk_aaa_naam
			  AND naam = p_naam;
	END;

	PROCEDURE determine_position_aad (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2) IS
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
				FROM v_aaa_deel
				WHERE fk_aaa_naam = p_fk_aaa_naam
				  AND naam = p_naam;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_aaa_deel
			WHERE fk_aaa_naam = p_fk_aaa_naam
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_aad IN (
					SELECT
					  rowid row_id
					FROM v_aaa_deel
					WHERE fk_aaa_naam = p_fk_aaa_naam
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_aaa_deel SET
						cube_sequence = l_cube_count
					WHERE rowid = r_aad.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_aad (
			p_cube_pos_action IN VARCHAR2,
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_fk_aaa_naam IN VARCHAR2,
			x_naam IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_aad (l_cube_sequence, p_cube_pos_action, x_fk_aaa_naam, x_naam);
		UPDATE v_aaa_deel SET
			cube_sequence = l_cube_sequence
		WHERE fk_aaa_naam = p_fk_aaa_naam
		  AND naam = p_naam;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type aaa_deel not found');
		END IF;
	END;

	PROCEDURE insert_aad (
			p_cube_pos_action IN VARCHAR2,
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2,
			x_fk_aaa_naam IN VARCHAR2,
			x_naam IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_aad (l_cube_sequence, p_cube_pos_action, x_fk_aaa_naam, x_naam);
		INSERT INTO v_aaa_deel (
			cube_id,
			cube_sequence,
			fk_aaa_naam,
			naam,
			xk_aaa_naam)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_aaa_naam,
			p_naam,
			p_xk_aaa_naam);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type aaa_deel already exists');
	END;

	PROCEDURE update_aad (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2) IS
	BEGIN
		UPDATE v_aaa_deel SET
			xk_aaa_naam = p_xk_aaa_naam
		WHERE fk_aaa_naam = p_fk_aaa_naam
		  AND naam = p_naam;
	END;

	PROCEDURE delete_aad (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		DELETE v_aaa_deel
		WHERE fk_aaa_naam = p_fk_aaa_naam
		  AND naam = p_naam;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE pkg_bbb IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_package RETURN VARCHAR2;
	PROCEDURE get_bbb_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_bbb_list (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_bbb (
			p_cube_row IN OUT c_cube_row,
			p_naam IN VARCHAR2);
	PROCEDURE insert_bbb (
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2,
			p_xk_bbb_naam_1 IN VARCHAR2);
	PROCEDURE update_bbb (
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2,
			p_xk_bbb_naam_1 IN VARCHAR2);
	PROCEDURE delete_bbb (
			p_naam IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_bbb IS
	FUNCTION cube_package RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_package';
	END;

	PROCEDURE get_bbb_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  naam
			FROM v_bbb
			ORDER BY naam;
	END;

	PROCEDURE get_bbb_list (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  naam
			FROM v_bbb
			ORDER BY naam;
	END;

	PROCEDURE get_bbb (
			p_cube_row IN OUT c_cube_row,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  omschrijving,
			  xk_aaa_naam,
			  xk_bbb_naam_1
			FROM v_bbb
			WHERE naam = p_naam;
	END;

	PROCEDURE insert_bbb (
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2,
			p_xk_bbb_naam_1 IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_bbb (
			cube_id,
			naam,
			omschrijving,
			xk_aaa_naam,
			xk_bbb_naam_1)
		VALUES (
			NULL,
			p_naam,
			p_omschrijving,
			p_xk_aaa_naam,
			p_xk_bbb_naam_1);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type bbb already exists');
	END;

	PROCEDURE update_bbb (
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2,
			p_xk_bbb_naam_1 IN VARCHAR2) IS
	BEGIN
		UPDATE v_bbb SET
			omschrijving = p_omschrijving,
			xk_aaa_naam = p_xk_aaa_naam,
			xk_bbb_naam_1 = p_xk_bbb_naam_1
		WHERE naam = p_naam;
	END;

	PROCEDURE delete_bbb (
			p_naam IN VARCHAR2) IS
	BEGIN
		DELETE v_bbb
		WHERE naam = p_naam;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE pkg_ccc IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_package RETURN VARCHAR2;
	PROCEDURE get_ccc_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_ccc_list_all (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE count_ccc (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_ccc (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_ccc_ccc_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE count_ccc_ccc (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE move_ccc (
			p_cube_pos_action IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2);
	PROCEDURE insert_ccc (
			p_cube_pos_action IN VARCHAR2,
			p_fk_ccc_code IN VARCHAR2,
			p_fk_ccc_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrjving IN VARCHAR2,
			p_xk_ccc_code IN VARCHAR2,
			p_xk_ccc_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2);
	PROCEDURE update_ccc (
			p_fk_ccc_code IN VARCHAR2,
			p_fk_ccc_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrjving IN VARCHAR2,
			p_xk_ccc_code IN VARCHAR2,
			p_xk_ccc_naam IN VARCHAR2);
	PROCEDURE delete_ccc (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_ccc IS
	FUNCTION cube_package RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_package';
	END;

	PROCEDURE get_ccc_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  code,
			  naam
			FROM v_ccc
			WHERE fk_ccc_code IS NULL
			  AND fk_ccc_naam IS NULL
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_ccc_list_all (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  code,
			  naam
			FROM v_ccc
			ORDER BY cube_sequence;
	END;

	PROCEDURE count_ccc (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_ccc
			WHERE fk_ccc_code IS NULL
			  AND fk_ccc_naam IS NULL;
	END;

	PROCEDURE get_ccc (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_ccc_code,
			  fk_ccc_naam,
			  omschrjving,
			  xk_ccc_code,
			  xk_ccc_naam
			FROM v_ccc
			WHERE code = p_code
			  AND naam = p_naam;
	END;

	PROCEDURE get_ccc_ccc_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  code,
			  naam
			FROM v_ccc
			WHERE fk_ccc_code = p_code
			  AND fk_ccc_naam = p_naam
			ORDER BY cube_sequence;
	END;

	PROCEDURE count_ccc_ccc (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_ccc
			WHERE fk_ccc_code = p_code
			  AND fk_ccc_code IS NOT NULL
			  AND fk_ccc_naam = p_naam
			  AND fk_ccc_naam IS NOT NULL;
	END;

	PROCEDURE check_no_part_ccc (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2) IS
		l_code v_ccc.code%TYPE;
		l_naam v_ccc.naam%TYPE;
	BEGIN
		l_code := x_code;
		l_naam := x_naam;
		LOOP
			IF l_code IS NULL
			  AND l_naam IS NULL THEN
				EXIT; -- OK
			END IF;
			IF l_code = p_code
			  AND l_naam = p_naam THEN
				RAISE_APPLICATION_ERROR (-20003, 'Target Type ccc in hierarchy of moving object');
			END IF;
			SELECT fk_ccc_code, fk_ccc_naam
			INTO l_code, l_naam
			FROM v_ccc
			WHERE code = l_code
			  AND naam = l_naam;
		END LOOP;
	END;

	PROCEDURE determine_position_ccc (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_ccc_code IN VARCHAR2,
			p_fk_ccc_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
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
				FROM v_ccc
				WHERE code = p_code
				  AND naam = p_naam;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_ccc
			WHERE 	    ( 	    ( fk_ccc_code IS NULL
					  AND p_fk_ccc_code IS NULL )
				   OR 	    ( fk_ccc_naam IS NULL
					  AND p_fk_ccc_naam IS NULL )
				   OR fk_ccc_code = p_fk_ccc_code
				   OR fk_ccc_naam = p_fk_ccc_naam )
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_ccc IN (
					SELECT
					  rowid row_id
					FROM v_ccc
					WHERE 	    ( fk_ccc_code IS NULL
						  AND p_fk_ccc_code IS NULL )
					   OR 	    ( fk_ccc_naam IS NULL
						  AND p_fk_ccc_naam IS NULL )
					   OR fk_ccc_code = p_fk_ccc_code
					   OR fk_ccc_naam = p_fk_ccc_naam
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_ccc SET
						cube_sequence = l_cube_count
					WHERE rowid = r_ccc.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_ccc (
			p_cube_pos_action IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
		l_fk_ccc_code v_ccc.fk_ccc_code%TYPE;
		l_fk_ccc_naam v_ccc.fk_ccc_naam%TYPE;
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN ('B', 'A') THEN
			SELECT fk_ccc_code, fk_ccc_naam
			INTO l_fk_ccc_code, l_fk_ccc_naam
			FROM v_ccc
			WHERE code = x_code
			  AND naam = x_naam;
		ELSE
			l_fk_ccc_code := x_code;
			l_fk_ccc_naam := x_naam;
		END IF;
		check_no_part_ccc (p_code, p_naam, l_fk_ccc_code, l_fk_ccc_naam);
		determine_position_ccc (l_cube_sequence, p_cube_pos_action, l_fk_ccc_code, l_fk_ccc_naam, x_code, x_naam);
		UPDATE v_ccc SET
			fk_ccc_code = l_fk_ccc_code,
			fk_ccc_naam = l_fk_ccc_naam,
			cube_sequence = l_cube_sequence
		WHERE code = p_code
		  AND naam = p_naam;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type ccc not found');
		END IF;
	END;

	PROCEDURE insert_ccc (
			p_cube_pos_action IN VARCHAR2,
			p_fk_ccc_code IN VARCHAR2,
			p_fk_ccc_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrjving IN VARCHAR2,
			p_xk_ccc_code IN VARCHAR2,
			p_xk_ccc_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_ccc (l_cube_sequence, p_cube_pos_action, p_fk_ccc_code, p_fk_ccc_naam, x_code, x_naam);
		INSERT INTO v_ccc (
			cube_id,
			cube_sequence,
			cube_level,
			fk_ccc_code,
			fk_ccc_naam,
			code,
			naam,
			omschrjving,
			xk_ccc_code,
			xk_ccc_naam)
		VALUES (
			NULL,
			l_cube_sequence,
			NULL,
			p_fk_ccc_code,
			p_fk_ccc_naam,
			p_code,
			p_naam,
			p_omschrjving,
			p_xk_ccc_code,
			p_xk_ccc_naam);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type ccc already exists');
	END;

	PROCEDURE update_ccc (
			p_fk_ccc_code IN VARCHAR2,
			p_fk_ccc_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrjving IN VARCHAR2,
			p_xk_ccc_code IN VARCHAR2,
			p_xk_ccc_naam IN VARCHAR2) IS
	BEGIN
		UPDATE v_ccc SET
			fk_ccc_code = p_fk_ccc_code,
			fk_ccc_naam = p_fk_ccc_naam,
			omschrjving = p_omschrjving,
			xk_ccc_code = p_xk_ccc_code,
			xk_ccc_naam = p_xk_ccc_naam
		WHERE code = p_code
		  AND naam = p_naam;
	END;

	PROCEDURE delete_ccc (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		DELETE v_ccc
		WHERE code = p_code
		  AND naam = p_naam;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE pkg_prd IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_package RETURN VARCHAR2;
	PROCEDURE get_prd_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_prd (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_prd_pr2_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_prd_prt_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE insert_prd (
			p_cube_tsg_zzz IN VARCHAR2,
			p_cube_tsg_yyy IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_datum IN DATE,
			p_omschrijving IN VARCHAR2);
	PROCEDURE update_prd (
			p_cube_tsg_zzz IN VARCHAR2,
			p_cube_tsg_yyy IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_datum IN DATE,
			p_omschrijving IN VARCHAR2);
	PROCEDURE delete_prd (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_pr2 (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_pr2_fkey (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_pr2_pa2_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE insert_pr2 (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2);
	PROCEDURE update_pr2 (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2);
	PROCEDURE delete_pr2 (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_pa2_for_prd_list_encapsulated (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_fk_prd_naam IN VARCHAR2);
	PROCEDURE get_pa2 (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_pa2_fkey (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_pa2_pa2_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE change_parent_pa2 (
			p_cube_flag_root IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2);
	PROCEDURE insert_pa2 (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_fk_pr2_code IN VARCHAR2,
			p_fk_pr2_naam IN VARCHAR2,
			p_fk_pa2_code IN VARCHAR2,
			p_fk_pa2_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_pa2_code IN VARCHAR2,
			p_xk_pa2_naam IN VARCHAR2);
	PROCEDURE update_pa2 (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_fk_pr2_code IN VARCHAR2,
			p_fk_pr2_naam IN VARCHAR2,
			p_fk_pa2_code IN VARCHAR2,
			p_fk_pa2_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_pa2_code IN VARCHAR2,
			p_xk_pa2_naam IN VARCHAR2);
	PROCEDURE delete_pa2 (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_prt_for_prd_list_encapsulated (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_fk_prd_naam IN VARCHAR2);
	PROCEDURE get_prt (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_prt_fkey (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE get_prt_prt_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE change_parent_prt (
			p_cube_flag_root IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2);
	PROCEDURE insert_prt (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_fk_prt_code IN VARCHAR2,
			p_fk_prt_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_prt_code IN VARCHAR2,
			p_xk_prt_naam IN VARCHAR2);
	PROCEDURE update_prt (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_fk_prt_code IN VARCHAR2,
			p_fk_prt_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_prt_code IN VARCHAR2,
			p_xk_prt_naam IN VARCHAR2);
	PROCEDURE delete_prt (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_prd IS
	FUNCTION cube_package RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_package';
	END;

	PROCEDURE get_prd_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  code,
			  naam
			FROM v_prod
			ORDER BY code, naam;
	END;

	PROCEDURE get_prd (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_zzz,
			  cube_tsg_yyy,
			  datum,
			  omschrijving
			FROM v_prod
			WHERE code = p_code
			  AND naam = p_naam;
	END;

	PROCEDURE get_prd_pr2_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  code,
			  naam
			FROM v_prod2
			WHERE fk_prd_code = p_code
			  AND fk_prd_naam = p_naam
			ORDER BY code, naam;
	END;

	PROCEDURE get_prd_prt_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  code,
			  naam
			FROM v_part
			WHERE fk_prd_code = p_code
			  AND fk_prd_naam = p_naam
			  AND fk_prt_code IS NULL
			  AND fk_prt_naam IS NULL
			ORDER BY code, naam;
	END;

	PROCEDURE insert_prd (
			p_cube_tsg_zzz IN VARCHAR2,
			p_cube_tsg_yyy IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_datum IN DATE,
			p_omschrijving IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_prod (
			cube_id,
			cube_tsg_zzz,
			cube_tsg_yyy,
			code,
			naam,
			datum,
			omschrijving)
		VALUES (
			NULL,
			p_cube_tsg_zzz,
			p_cube_tsg_yyy,
			p_code,
			p_naam,
			p_datum,
			p_omschrijving);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type prod already exists');
	END;

	PROCEDURE update_prd (
			p_cube_tsg_zzz IN VARCHAR2,
			p_cube_tsg_yyy IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_datum IN DATE,
			p_omschrijving IN VARCHAR2) IS
	BEGIN
		UPDATE v_prod SET
			cube_tsg_zzz = p_cube_tsg_zzz,
			cube_tsg_yyy = p_cube_tsg_yyy,
			datum = p_datum,
			omschrijving = p_omschrijving
		WHERE code = p_code
		  AND naam = p_naam;
	END;

	PROCEDURE delete_prd (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		DELETE v_prod
		WHERE code = p_code
		  AND naam = p_naam;
	END;

	PROCEDURE get_pr2 (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_prd_code,
			  fk_prd_naam,
			  omschrijving
			FROM v_prod2
			WHERE code = p_code
			  AND naam = p_naam;
	END;

	PROCEDURE get_pr2_fkey (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_prd_code,
			  fk_prd_naam
			FROM v_prod2
			WHERE code = p_code
			  AND naam = p_naam;
	END;

	PROCEDURE get_pr2_pa2_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  code,
			  naam
			FROM v_part2
			WHERE fk_pr2_code = p_code
			  AND fk_pr2_naam = p_naam
			  AND fk_pa2_code IS NULL
			  AND fk_pa2_naam IS NULL
			ORDER BY code, naam;
	END;

	PROCEDURE insert_pr2 (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_prod2 (
			cube_id,
			fk_prd_code,
			fk_prd_naam,
			code,
			naam,
			omschrijving)
		VALUES (
			NULL,
			p_fk_prd_code,
			p_fk_prd_naam,
			p_code,
			p_naam,
			p_omschrijving);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type prod2 already exists');
	END;

	PROCEDURE update_pr2 (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2) IS
	BEGIN
		UPDATE v_prod2 SET
			fk_prd_code = p_fk_prd_code,
			fk_prd_naam = p_fk_prd_naam,
			omschrijving = p_omschrijving
		WHERE code = p_code
		  AND naam = p_naam;
	END;

	PROCEDURE delete_pr2 (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		DELETE v_prod2
		WHERE code = p_code
		  AND naam = p_naam;
	END;

	PROCEDURE get_pa2_for_prd_list_encapsulated (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_fk_prd_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  code,
			  naam
			FROM v_part2
			WHERE 	    ( fk_pr2_code = p_code
				  AND fk_pr2_naam = p_naam )
			   OR 	    ( 	NOT ( fk_pr2_code = p_code
					  AND p_code IS NOT NULL
					  AND fk_pr2_naam = p_naam
					  AND p_naam IS NOT NULL )
				  AND fk_pa2_code IS NULL
				  AND fk_pa2_naam IS NULL
				  AND fk_prd_code = x_fk_prd_code
				  AND fk_prd_naam = x_fk_prd_naam )
			ORDER BY code, naam;
	END;

	PROCEDURE get_pa2 (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_prd_code,
			  fk_prd_naam,
			  fk_pr2_code,
			  fk_pr2_naam,
			  fk_pa2_code,
			  fk_pa2_naam,
			  omschrijving,
			  xk_pa2_code,
			  xk_pa2_naam
			FROM v_part2
			WHERE code = p_code
			  AND naam = p_naam;
	END;

	PROCEDURE get_pa2_fkey (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_prd_code,
			  fk_prd_naam,
			  fk_pr2_code,
			  fk_pr2_naam
			FROM v_part2
			WHERE code = p_code
			  AND naam = p_naam;
	END;

	PROCEDURE get_pa2_pa2_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  code,
			  naam
			FROM v_part2
			WHERE fk_pa2_code = p_code
			  AND fk_pa2_naam = p_naam
			ORDER BY code, naam;
	END;

	PROCEDURE check_no_part_pa2 (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2) IS
		l_code v_part2.code%TYPE;
		l_naam v_part2.naam%TYPE;
	BEGIN
		l_code := x_code;
		l_naam := x_naam;
		LOOP
			IF l_code IS NULL
			  AND l_naam IS NULL THEN
				EXIT; -- OK
			END IF;
			IF l_code = p_code
			  AND l_naam = p_naam THEN
				RAISE_APPLICATION_ERROR (-20003, 'Target Type part2 in hierarchy of moving object');
			END IF;
			SELECT fk_pa2_code, fk_pa2_naam
			INTO l_code, l_naam
			FROM v_part2
			WHERE code = l_code
			  AND naam = l_naam;
		END LOOP;
	END;

	PROCEDURE change_parent_pa2 (
			p_cube_flag_root IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2) IS
	BEGIN
		IF p_cube_flag_root = 'Y' THEN
			UPDATE v_part2 SET
				fk_pa2_code = NULL,
				fk_pa2_naam = NULL
			WHERE code = p_code
			  AND naam = p_naam;
			IF SQL%NOTFOUND THEN
				RAISE_APPLICATION_ERROR (-20002, 'Type part2 not found');
			END IF;
		ELSE
			check_no_part_pa2 (p_code, p_naam, x_code, x_naam);
			UPDATE v_part2 SET
				fk_pa2_code = x_code,
				fk_pa2_naam = x_naam
			WHERE code = p_code
			  AND naam = p_naam;
			IF SQL%NOTFOUND THEN
				RAISE_APPLICATION_ERROR (-20002, 'Type part2 not found');
			END IF;
		END IF;
	END;

	PROCEDURE insert_pa2 (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_fk_pr2_code IN VARCHAR2,
			p_fk_pr2_naam IN VARCHAR2,
			p_fk_pa2_code IN VARCHAR2,
			p_fk_pa2_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_pa2_code IN VARCHAR2,
			p_xk_pa2_naam IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_part2 (
			cube_id,
			cube_level,
			fk_prd_code,
			fk_prd_naam,
			fk_pr2_code,
			fk_pr2_naam,
			fk_pa2_code,
			fk_pa2_naam,
			code,
			naam,
			omschrijving,
			xk_pa2_code,
			xk_pa2_naam)
		VALUES (
			NULL,
			NULL,
			p_fk_prd_code,
			p_fk_prd_naam,
			p_fk_pr2_code,
			p_fk_pr2_naam,
			p_fk_pa2_code,
			p_fk_pa2_naam,
			p_code,
			p_naam,
			p_omschrijving,
			p_xk_pa2_code,
			p_xk_pa2_naam);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type part2 already exists');
	END;

	PROCEDURE update_pa2 (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_fk_pr2_code IN VARCHAR2,
			p_fk_pr2_naam IN VARCHAR2,
			p_fk_pa2_code IN VARCHAR2,
			p_fk_pa2_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_pa2_code IN VARCHAR2,
			p_xk_pa2_naam IN VARCHAR2) IS
	BEGIN
		UPDATE v_part2 SET
			fk_prd_code = p_fk_prd_code,
			fk_prd_naam = p_fk_prd_naam,
			fk_pr2_code = p_fk_pr2_code,
			fk_pr2_naam = p_fk_pr2_naam,
			fk_pa2_code = p_fk_pa2_code,
			fk_pa2_naam = p_fk_pa2_naam,
			omschrijving = p_omschrijving,
			xk_pa2_code = p_xk_pa2_code,
			xk_pa2_naam = p_xk_pa2_naam
		WHERE code = p_code
		  AND naam = p_naam;
	END;

	PROCEDURE delete_pa2 (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		DELETE v_part2
		WHERE code = p_code
		  AND naam = p_naam;
	END;

	PROCEDURE get_prt_for_prd_list_encapsulated (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_fk_prd_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  code,
			  naam
			FROM v_part
			WHERE 	    ( fk_prd_code = p_code
				  AND fk_prd_naam = p_naam )
			   OR 	    ( 	NOT ( fk_prd_code = p_code
					  AND p_code IS NOT NULL
					  AND fk_prd_naam = p_naam
					  AND p_naam IS NOT NULL )
				  AND fk_prt_code IS NULL
				  AND fk_prt_naam IS NULL
				  AND fk_prd_code = x_fk_prd_code
				  AND fk_prd_naam = x_fk_prd_naam )
			ORDER BY code, naam;
	END;

	PROCEDURE get_prt (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_prd_code,
			  fk_prd_naam,
			  fk_prt_code,
			  fk_prt_naam,
			  omschrijving,
			  xk_prt_code,
			  xk_prt_naam
			FROM v_part
			WHERE code = p_code
			  AND naam = p_naam;
	END;

	PROCEDURE get_prt_fkey (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_prd_code,
			  fk_prd_naam
			FROM v_part
			WHERE code = p_code
			  AND naam = p_naam;
	END;

	PROCEDURE get_prt_prt_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  code,
			  naam
			FROM v_part
			WHERE fk_prt_code = p_code
			  AND fk_prt_naam = p_naam
			ORDER BY code, naam;
	END;

	PROCEDURE check_no_part_prt (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2) IS
		l_code v_part.code%TYPE;
		l_naam v_part.naam%TYPE;
	BEGIN
		l_code := x_code;
		l_naam := x_naam;
		LOOP
			IF l_code IS NULL
			  AND l_naam IS NULL THEN
				EXIT; -- OK
			END IF;
			IF l_code = p_code
			  AND l_naam = p_naam THEN
				RAISE_APPLICATION_ERROR (-20003, 'Target Type part in hierarchy of moving object');
			END IF;
			SELECT fk_prt_code, fk_prt_naam
			INTO l_code, l_naam
			FROM v_part
			WHERE code = l_code
			  AND naam = l_naam;
		END LOOP;
	END;

	PROCEDURE change_parent_prt (
			p_cube_flag_root IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2) IS
	BEGIN
		IF p_cube_flag_root = 'Y' THEN
			UPDATE v_part SET
				fk_prt_code = NULL,
				fk_prt_naam = NULL
			WHERE code = p_code
			  AND naam = p_naam;
			IF SQL%NOTFOUND THEN
				RAISE_APPLICATION_ERROR (-20002, 'Type part not found');
			END IF;
		ELSE
			check_no_part_prt (p_code, p_naam, x_code, x_naam);
			UPDATE v_part SET
				fk_prt_code = x_code,
				fk_prt_naam = x_naam
			WHERE code = p_code
			  AND naam = p_naam;
			IF SQL%NOTFOUND THEN
				RAISE_APPLICATION_ERROR (-20002, 'Type part not found');
			END IF;
		END IF;
	END;

	PROCEDURE insert_prt (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_fk_prt_code IN VARCHAR2,
			p_fk_prt_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_prt_code IN VARCHAR2,
			p_xk_prt_naam IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_part (
			cube_id,
			cube_level,
			fk_prd_code,
			fk_prd_naam,
			fk_prt_code,
			fk_prt_naam,
			code,
			naam,
			omschrijving,
			xk_prt_code,
			xk_prt_naam)
		VALUES (
			NULL,
			NULL,
			p_fk_prd_code,
			p_fk_prd_naam,
			p_fk_prt_code,
			p_fk_prt_naam,
			p_code,
			p_naam,
			p_omschrijving,
			p_xk_prt_code,
			p_xk_prt_naam);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type part already exists');
	END;

	PROCEDURE update_prt (
			p_fk_prd_code IN VARCHAR2,
			p_fk_prd_naam IN VARCHAR2,
			p_fk_prt_code IN VARCHAR2,
			p_fk_prt_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_prt_code IN VARCHAR2,
			p_xk_prt_naam IN VARCHAR2) IS
	BEGIN
		UPDATE v_part SET
			fk_prd_code = p_fk_prd_code,
			fk_prd_naam = p_fk_prd_naam,
			fk_prt_code = p_fk_prt_code,
			fk_prt_naam = p_fk_prt_naam,
			omschrijving = p_omschrijving,
			xk_prt_code = p_xk_prt_code,
			xk_prt_naam = p_xk_prt_naam
		WHERE code = p_code
		  AND naam = p_naam;
	END;

	PROCEDURE delete_prt (
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		DELETE v_part
		WHERE code = p_code
		  AND naam = p_naam;
	END;
END;
/
SHOW ERRORS;

EXIT;