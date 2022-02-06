-- CUBETEST Packages
--
BEGIN
	FOR r_p IN (
		SELECT object_name
		FROM user_procedures
		WHERE procedure_name = 'CUBE_PKG_CUBETEST' )
	LOOP
		EXECUTE IMMEDIATE 'DROP PACKAGE '||r_p.object_name;
	END LOOP;
END;
/
CREATE OR REPLACE PACKAGE pkg_cube IS
	FUNCTION cube_pkg_cubetest RETURN VARCHAR2;
	FUNCTION years(p_date DATE) RETURN NUMBER;
	FUNCTION multiply(p_num_1 NUMBER, p_num_2 NUMBER) RETURN NUMBER;
	FUNCTION add(p_num_1 NUMBER, p_num_2 NUMBER) RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY pkg_cube IS
	FUNCTION cube_pkg_cubetest RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubetest';
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
CREATE OR REPLACE PACKAGE pkg_prd IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_pkg_cubetest RETURN VARCHAR2;
	PROCEDURE get_prd_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE count_prd (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_prd (
			p_cube_row IN OUT c_cube_row,
			p_cube_tsg_type IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_prd_ond_items (
			p_cube_row IN OUT c_cube_row,
			p_cube_tsg_type IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE count_prd_ond (
			p_cube_row IN OUT c_cube_row,
			p_cube_tsg_type IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE insert_prd (
			p_cube_tsg_type IN VARCHAR2,
			p_cube_tsg_soort IN VARCHAR2,
			p_cube_tsg_soort1 IN VARCHAR2,
			p_code IN VARCHAR2,
			p_prijs IN NUMBER,
			p_makelaar_naam IN VARCHAR2,
			p_bedrag_btw IN NUMBER,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_prd (
			p_cube_tsg_type IN VARCHAR2,
			p_cube_tsg_soort IN VARCHAR2,
			p_cube_tsg_soort1 IN VARCHAR2,
			p_code IN VARCHAR2,
			p_prijs IN NUMBER,
			p_makelaar_naam IN VARCHAR2,
			p_bedrag_btw IN NUMBER);
	PROCEDURE delete_prd (
			p_cube_tsg_type IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_ond (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_ond_odd_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_ond_cst_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_ond_ond_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE count_ond_ond (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE count_ond_odd (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE move_ond (
			p_cube_pos_action IN VARCHAR2,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2,
			x_fk_prd_cube_tsg_type IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE insert_ond (
			p_cube_pos_action IN VARCHAR2,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_prijs IN NUMBER,
			p_omschrijving IN VARCHAR2,
			x_fk_prd_cube_tsg_type IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE update_ond (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_prijs IN NUMBER,
			p_omschrijving IN VARCHAR2);
	PROCEDURE delete_ond (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_odd_list (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_odd_for_ond_list (
			p_cube_row IN OUT c_cube_row,
			p_cube_scope_level IN NUMBER,
			x_fk_prd_cube_tsg_type IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_fk_ond_code IN VARCHAR2);
	PROCEDURE get_odd (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2);
	PROCEDURE get_odd_fkey (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2);
	PROCEDURE get_odd_ddd_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2);
	PROCEDURE move_odd (
			p_cube_pos_action IN VARCHAR2,
			p_code IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE insert_odd (
			p_cube_pos_action IN VARCHAR2,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE update_odd (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE delete_odd (
			p_code IN VARCHAR2);
	PROCEDURE get_ddd (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2);
	PROCEDURE move_ddd (
			p_cube_pos_action IN VARCHAR2,
			p_code IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE insert_ddd (
			p_cube_pos_action IN VARCHAR2,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_fk_odd_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE update_ddd (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_fk_odd_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2);
	PROCEDURE delete_ddd (
			p_code IN VARCHAR2);
	PROCEDURE get_cst (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE insert_cst (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_odd_code IN VARCHAR2,
			p_xk_odd_code_1 IN VARCHAR2);
	PROCEDURE update_cst (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_odd_code IN VARCHAR2,
			p_xk_odd_code_1 IN VARCHAR2);
	PROCEDURE delete_cst (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_prd IS
	FUNCTION cube_pkg_cubetest RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubetest';
	END;

	PROCEDURE get_prd_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_type,
			  cube_tsg_soort,
			  cube_tsg_soort1,
			  code
			FROM v_produkt
			ORDER BY cube_tsg_type, cube_tsg_soort, cube_tsg_soort1, code;
	END;

	PROCEDURE count_prd (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_produkt;
	END;

	PROCEDURE get_prd (
			p_cube_row IN OUT c_cube_row,
			p_cube_tsg_type IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_soort,
			  cube_tsg_soort1,
			  prijs,
			  makelaar_naam,
			  bedrag_btw
			FROM v_produkt
			WHERE cube_tsg_type = p_cube_tsg_type
			  AND code = p_code;
	END;

	PROCEDURE get_prd_ond_items (
			p_cube_row IN OUT c_cube_row,
			p_cube_tsg_type IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_prd_cube_tsg_type,
			  fk_prd_code,
			  code
			FROM v_onderdeel
			WHERE fk_prd_cube_tsg_type = p_cube_tsg_type
			  AND fk_prd_code = p_code
			  AND fk_ond_code IS NULL
			ORDER BY fk_prd_cube_tsg_type, fk_prd_code, cube_sequence;
	END;

	PROCEDURE count_prd_ond (
			p_cube_row IN OUT c_cube_row,
			p_cube_tsg_type IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_onderdeel
			WHERE fk_prd_cube_tsg_type = p_cube_tsg_type
			  AND fk_prd_code = p_code
			  AND fk_ond_code IS NULL;
	END;

	PROCEDURE get_next_prd (
			p_cube_row IN OUT c_cube_row,
			p_cube_tsg_type IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_type,
			  code
			FROM v_produkt
			WHERE cube_tsg_type > p_cube_tsg_type
			   OR 	    ( cube_tsg_type = p_cube_tsg_type
				  AND code > p_code )
			ORDER BY cube_tsg_type, code;
	END;

	PROCEDURE insert_prd (
			p_cube_tsg_type IN VARCHAR2,
			p_cube_tsg_soort IN VARCHAR2,
			p_cube_tsg_soort1 IN VARCHAR2,
			p_code IN VARCHAR2,
			p_prijs IN NUMBER,
			p_makelaar_naam IN VARCHAR2,
			p_bedrag_btw IN NUMBER,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_produkt (
			cube_id,
			cube_tsg_type,
			cube_tsg_soort,
			cube_tsg_soort1,
			code,
			prijs,
			makelaar_naam,
			bedrag_btw)
		VALUES (
			NULL,
			p_cube_tsg_type,
			p_cube_tsg_soort,
			p_cube_tsg_soort1,
			p_code,
			p_prijs,
			p_makelaar_naam,
			p_bedrag_btw);

		get_next_prd (p_cube_row, p_cube_tsg_type, p_code);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type produkt already exists');
	END;

	PROCEDURE update_prd (
			p_cube_tsg_type IN VARCHAR2,
			p_cube_tsg_soort IN VARCHAR2,
			p_cube_tsg_soort1 IN VARCHAR2,
			p_code IN VARCHAR2,
			p_prijs IN NUMBER,
			p_makelaar_naam IN VARCHAR2,
			p_bedrag_btw IN NUMBER) IS
	BEGIN
		UPDATE v_produkt SET
			cube_tsg_soort = p_cube_tsg_soort,
			cube_tsg_soort1 = p_cube_tsg_soort1,
			prijs = p_prijs,
			makelaar_naam = p_makelaar_naam,
			bedrag_btw = p_bedrag_btw
		WHERE cube_tsg_type = p_cube_tsg_type
		  AND code = p_code;
	END;

	PROCEDURE delete_prd (
			p_cube_tsg_type IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		DELETE v_produkt
		WHERE cube_tsg_type = p_cube_tsg_type
		  AND code = p_code;
	END;

	PROCEDURE get_ond (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_ond_code,
			  prijs,
			  omschrijving
			FROM v_onderdeel
			WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
			  AND fk_prd_code = p_fk_prd_code
			  AND code = p_code;
	END;

	PROCEDURE get_ond_odd_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  code
			FROM v_onderdeel_deel
			WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
			  AND fk_prd_code = p_fk_prd_code
			  AND fk_ond_code = p_code
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_ond_cst_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_prd_cube_tsg_type,
			  fk_prd_code,
			  fk_ond_code,
			  code
			FROM v_constructie
			WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
			  AND fk_prd_code = p_fk_prd_code
			  AND fk_ond_code = p_code
			ORDER BY fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code, code;
	END;

	PROCEDURE get_ond_ond_items (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  fk_prd_cube_tsg_type,
			  fk_prd_code,
			  code
			FROM v_onderdeel
			WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
			  AND fk_prd_code = p_fk_prd_code
			  AND fk_ond_code = p_code
			ORDER BY fk_prd_cube_tsg_type, fk_prd_code, cube_sequence;
	END;

	PROCEDURE count_ond_ond (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_onderdeel
			WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
			  AND fk_prd_code = p_fk_prd_code
			  AND fk_ond_code = p_code
			  AND fk_ond_code IS NOT NULL;
	END;

	PROCEDURE count_ond_odd (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  COUNT(1) type_count
			FROM v_onderdeel_deel
			WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
			  AND fk_prd_code = p_fk_prd_code
			  AND fk_ond_code = p_code;
	END;

	PROCEDURE check_no_part_ond (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_code v_onderdeel.code%TYPE;
	BEGIN
		l_code := x_code;
		LOOP
			IF l_code IS NULL THEN
				EXIT; -- OK
			END IF;
			IF l_code = p_code THEN
				RAISE_APPLICATION_ERROR (-20003, 'Target Type onderdeel in hierarchy of moving object');
			END IF;
			SELECT fk_ond_code
			INTO l_code
			FROM v_onderdeel
			WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
			  AND fk_prd_code = p_fk_prd_code
			  AND code = l_code;
		END LOOP;
	END;

	PROCEDURE determine_position_ond (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
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
				FROM v_onderdeel
				WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
				  AND fk_prd_code = p_fk_prd_code
				  AND code = p_code;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_onderdeel
			WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
			  AND fk_prd_code = p_fk_prd_code
			  AND 	    ( 	    ( fk_ond_code IS NULL
					  AND p_fk_ond_code IS NULL )
				   OR fk_ond_code = p_fk_ond_code )
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_ond IN (
					SELECT
					  rowid row_id
					FROM v_onderdeel
					WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
					  AND fk_prd_code = p_fk_prd_code
					  AND 	    ( 	    ( fk_ond_code IS NULL
							  AND p_fk_ond_code IS NULL )
						   OR fk_ond_code = p_fk_ond_code )
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_onderdeel SET
						cube_sequence = l_cube_count
					WHERE rowid = r_ond.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_ond (
			p_cube_pos_action IN VARCHAR2,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2,
			x_fk_prd_cube_tsg_type IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
		l_fk_ond_code v_onderdeel.fk_ond_code%TYPE;
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN ('B', 'A') THEN
			SELECT fk_ond_code
			INTO l_fk_ond_code
			FROM v_onderdeel
			WHERE fk_prd_cube_tsg_type = x_fk_prd_cube_tsg_type
			  AND fk_prd_code = x_fk_prd_code
			  AND code = x_code;
		ELSE
			l_fk_ond_code := x_code;
		END IF;
		check_no_part_ond (p_fk_prd_cube_tsg_type, p_fk_prd_code, p_code, l_fk_ond_code);
		determine_position_ond (l_cube_sequence, p_cube_pos_action, x_fk_prd_cube_tsg_type, x_fk_prd_code, l_fk_ond_code, x_code);
		UPDATE v_onderdeel SET
			fk_ond_code = l_fk_ond_code,
			cube_sequence = l_cube_sequence
		WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
		  AND fk_prd_code = p_fk_prd_code
		  AND code = p_code;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type onderdeel not found');
		END IF;
	END;

	PROCEDURE insert_ond (
			p_cube_pos_action IN VARCHAR2,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_prijs IN NUMBER,
			p_omschrijving IN VARCHAR2,
			x_fk_prd_cube_tsg_type IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_ond (l_cube_sequence, p_cube_pos_action, x_fk_prd_cube_tsg_type, x_fk_prd_code, p_fk_ond_code, x_code);
		INSERT INTO v_onderdeel (
			cube_id,
			cube_sequence,
			cube_level,
			fk_prd_cube_tsg_type,
			fk_prd_code,
			fk_ond_code,
			code,
			prijs,
			omschrijving)
		VALUES (
			NULL,
			l_cube_sequence,
			NULL,
			p_fk_prd_cube_tsg_type,
			p_fk_prd_code,
			p_fk_ond_code,
			p_code,
			p_prijs,
			p_omschrijving);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type onderdeel already exists');
	END;

	PROCEDURE update_ond (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_prijs IN NUMBER,
			p_omschrijving IN VARCHAR2) IS
	BEGIN
		UPDATE v_onderdeel SET
			fk_ond_code = p_fk_ond_code,
			prijs = p_prijs,
			omschrijving = p_omschrijving
		WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
		  AND fk_prd_code = p_fk_prd_code
		  AND code = p_code;
	END;

	PROCEDURE delete_ond (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		DELETE v_onderdeel
		WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
		  AND fk_prd_code = p_fk_prd_code
		  AND code = p_code;
	END;

	PROCEDURE get_odd_list (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  code
			FROM v_onderdeel_deel
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_odd_for_ond_list (
			p_cube_row IN OUT c_cube_row,
			p_cube_scope_level IN NUMBER,
			x_fk_prd_cube_tsg_type IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_fk_ond_code IN VARCHAR2) IS
		l_cube_scope_level NUMBER(1) := 0;
		l_code v_onderdeel.code%TYPE;
	BEGIN
		l_code := x_fk_ond_code;
		IF p_cube_scope_level > 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level + 1;
				SELECT fk_ond_code
				INTO l_code
				FROM v_onderdeel
				WHERE code = l_code
				  AND fk_prd_cube_tsg_type = x_fk_prd_cube_tsg_type
				  AND fk_prd_code = x_fk_prd_code;
			END LOOP;
		ELSIF p_cube_scope_level < 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level - 1;
				SELECT code
				INTO l_code
				FROM v_onderdeel
				WHERE fk_ond_code = l_code
				  AND fk_prd_cube_tsg_type = x_fk_prd_cube_tsg_type
				  AND fk_prd_code = x_fk_prd_code;
			END LOOP;
		END IF;
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  code
			FROM v_onderdeel_deel
			WHERE fk_prd_cube_tsg_type = x_fk_prd_cube_tsg_type
			  AND fk_prd_code = x_fk_prd_code
			  AND fk_ond_code = l_code
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_odd (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_prd_cube_tsg_type,
			  fk_prd_code,
			  fk_ond_code,
			  naam
			FROM v_onderdeel_deel
			WHERE code = p_code;
	END;

	PROCEDURE get_odd_fkey (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_prd_cube_tsg_type,
			  fk_prd_code,
			  fk_ond_code
			FROM v_onderdeel_deel
			WHERE code = p_code;
	END;

	PROCEDURE get_odd_ddd_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  code
			FROM v_onderdeel_deel_deel
			WHERE fk_odd_code = p_code
			ORDER BY cube_sequence;
	END;

	PROCEDURE determine_position_odd (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
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
				FROM v_onderdeel_deel
				WHERE code = p_code;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_onderdeel_deel
			WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
			  AND fk_prd_code = p_fk_prd_code
			  AND fk_ond_code = p_fk_ond_code
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_odd IN (
					SELECT
					  rowid row_id
					FROM v_onderdeel_deel
					WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
					  AND fk_prd_code = p_fk_prd_code
					  AND fk_ond_code = p_fk_ond_code
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_onderdeel_deel SET
						cube_sequence = l_cube_count
					WHERE rowid = r_odd.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_odd (
			p_cube_pos_action IN VARCHAR2,
			p_code IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
		l_fk_prd_cube_tsg_type v_onderdeel_deel.fk_prd_cube_tsg_type%TYPE;
		l_fk_prd_code v_onderdeel_deel.fk_prd_code%TYPE;
		l_fk_ond_code v_onderdeel_deel.fk_ond_code%TYPE;
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN ('B', 'A') THEN
			SELECT fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code
			INTO l_fk_prd_cube_tsg_type, l_fk_prd_code, l_fk_ond_code
			FROM v_onderdeel_deel
			WHERE code = x_code;
		ELSE
			SELECT fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code
			INTO l_fk_prd_cube_tsg_type, l_fk_prd_code, l_fk_ond_code
			FROM v_onderdeel_deel
			WHERE code = x_code;
		END IF;
		determine_position_odd (l_cube_sequence, p_cube_pos_action, l_fk_prd_cube_tsg_type, l_fk_prd_code, l_fk_ond_code, x_code);
		UPDATE v_onderdeel_deel SET
			fk_prd_cube_tsg_type = l_fk_prd_cube_tsg_type,
			fk_prd_code = l_fk_prd_code,
			fk_ond_code = l_fk_ond_code,
			cube_sequence = l_cube_sequence
		WHERE code = p_code;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type onderdeel_deel not found');
		END IF;
	END;

	PROCEDURE insert_odd (
			p_cube_pos_action IN VARCHAR2,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_odd (l_cube_sequence, p_cube_pos_action, p_fk_prd_cube_tsg_type, p_fk_prd_code, p_fk_ond_code, x_code);
		INSERT INTO v_onderdeel_deel (
			cube_id,
			cube_sequence,
			fk_prd_cube_tsg_type,
			fk_prd_code,
			fk_ond_code,
			code,
			naam)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_prd_cube_tsg_type,
			p_fk_prd_code,
			p_fk_ond_code,
			p_code,
			p_naam);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type onderdeel_deel already exists');
	END;

	PROCEDURE update_odd (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		UPDATE v_onderdeel_deel SET
			fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type,
			fk_prd_code = p_fk_prd_code,
			fk_ond_code = p_fk_ond_code,
			naam = p_naam
		WHERE code = p_code;
	END;

	PROCEDURE delete_odd (
			p_code IN VARCHAR2) IS
	BEGIN
		DELETE v_onderdeel_deel
		WHERE code = p_code;
	END;

	PROCEDURE get_ddd (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_prd_cube_tsg_type,
			  fk_prd_code,
			  fk_ond_code,
			  fk_odd_code,
			  naam
			FROM v_onderdeel_deel_deel
			WHERE code = p_code;
	END;

	PROCEDURE determine_position_ddd (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
			p_fk_odd_code IN VARCHAR2,
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
				FROM v_onderdeel_deel_deel
				WHERE code = p_code;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_onderdeel_deel_deel
			WHERE fk_odd_code = p_fk_odd_code
			  AND 	    ( 	    ( l_cube_pos_action = 'B'
					  AND cube_sequence < l_cube_position_sequ )
				   OR 	    ( l_cube_pos_action = 'A'
					  AND cube_sequence > l_cube_position_sequ ) );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_ddd IN (
					SELECT
					  rowid row_id
					FROM v_onderdeel_deel_deel
					WHERE fk_odd_code = p_fk_odd_code
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_onderdeel_deel_deel SET
						cube_sequence = l_cube_count
					WHERE rowid = r_ddd.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_ddd (
			p_cube_pos_action IN VARCHAR2,
			p_code IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
		l_fk_odd_code v_onderdeel_deel_deel.fk_odd_code%TYPE;
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN ('B', 'A') THEN
			SELECT fk_odd_code
			INTO l_fk_odd_code
			FROM v_onderdeel_deel_deel
			WHERE code = x_code;
		ELSE
			SELECT fk_odd_code
			INTO l_fk_odd_code
			FROM v_onderdeel_deel_deel
			WHERE code = x_code;
		END IF;
		determine_position_ddd (l_cube_sequence, p_cube_pos_action, l_fk_odd_code, x_code);
		UPDATE v_onderdeel_deel_deel SET
			fk_odd_code = l_fk_odd_code,
			cube_sequence = l_cube_sequence
		WHERE code = p_code;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type onderdeel_deel_deel not found');
		END IF;
	END;

	PROCEDURE insert_ddd (
			p_cube_pos_action IN VARCHAR2,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_fk_odd_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_ddd (l_cube_sequence, p_cube_pos_action, p_fk_odd_code, x_code);
		INSERT INTO v_onderdeel_deel_deel (
			cube_id,
			cube_sequence,
			fk_prd_cube_tsg_type,
			fk_prd_code,
			fk_ond_code,
			fk_odd_code,
			code,
			naam)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_prd_cube_tsg_type,
			p_fk_prd_code,
			p_fk_ond_code,
			p_fk_odd_code,
			p_code,
			p_naam);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type onderdeel_deel_deel already exists');
	END;

	PROCEDURE update_ddd (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_fk_odd_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2) IS
	BEGIN
		UPDATE v_onderdeel_deel_deel SET
			fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type,
			fk_prd_code = p_fk_prd_code,
			fk_ond_code = p_fk_ond_code,
			fk_odd_code = p_fk_odd_code,
			naam = p_naam
		WHERE code = p_code;
	END;

	PROCEDURE delete_ddd (
			p_code IN VARCHAR2) IS
	BEGIN
		DELETE v_onderdeel_deel_deel
		WHERE code = p_code;
	END;

	PROCEDURE get_cst (
			p_cube_row IN OUT c_cube_row,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  omschrijving,
			  xk_odd_code,
			  xk_odd_code_1
			FROM v_constructie
			WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
			  AND fk_prd_code = p_fk_prd_code
			  AND fk_ond_code = p_fk_ond_code
			  AND code = p_code;
	END;

	PROCEDURE insert_cst (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_odd_code IN VARCHAR2,
			p_xk_odd_code_1 IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_constructie (
			cube_id,
			fk_prd_cube_tsg_type,
			fk_prd_code,
			fk_ond_code,
			code,
			omschrijving,
			xk_odd_code,
			xk_odd_code_1)
		VALUES (
			NULL,
			p_fk_prd_cube_tsg_type,
			p_fk_prd_code,
			p_fk_ond_code,
			p_code,
			p_omschrijving,
			p_xk_odd_code,
			p_xk_odd_code_1);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type constructie already exists');
	END;

	PROCEDURE update_cst (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_odd_code IN VARCHAR2,
			p_xk_odd_code_1 IN VARCHAR2) IS
	BEGIN
		UPDATE v_constructie SET
			omschrijving = p_omschrijving,
			xk_odd_code = p_xk_odd_code,
			xk_odd_code_1 = p_xk_odd_code_1
		WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
		  AND fk_prd_code = p_fk_prd_code
		  AND fk_ond_code = p_fk_ond_code
		  AND code = p_code;
	END;

	PROCEDURE delete_cst (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		DELETE v_constructie
		WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
		  AND fk_prd_code = p_fk_prd_code
		  AND fk_ond_code = p_fk_ond_code
		  AND code = p_code;
	END;
END;
/
SHOW ERRORS;

EXIT;