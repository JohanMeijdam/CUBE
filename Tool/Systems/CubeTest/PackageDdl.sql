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
	PROCEDURE get_aaa_list_encapsulated (
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
			x_naam IN VARCHAR2);
	PROCEDURE insert_aaa (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2);
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
	PROCEDURE insert_aad (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2);
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

	PROCEDURE get_aaa_list_encapsulated (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  naam
			FROM v_aaa
			WHERE fk_aaa_naam IS NULL
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
			  fk_aaa_naam,
			  naam
			FROM v_aaa_deel
			WHERE fk_aaa_naam = p_naam
			ORDER BY fk_aaa_naam, naam;
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

	PROCEDURE change_parent_aaa (
			p_cube_flag_root IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_naam IN VARCHAR2) IS
	BEGIN
		IF p_cube_flag_root = 'Y' THEN
			UPDATE v_aaa SET
				fk_aaa_naam = NULL
			WHERE naam = p_naam;
			IF SQL%NOTFOUND THEN
				RAISE_APPLICATION_ERROR (-20002, 'Type aaa not found');
			END IF;
		ELSE
			check_no_part_aaa (p_naam, x_naam);
			UPDATE v_aaa SET
				fk_aaa_naam = x_naam
			WHERE naam = p_naam;
			IF SQL%NOTFOUND THEN
				RAISE_APPLICATION_ERROR (-20002, 'Type aaa not found');
			END IF;
		END IF;
	END;

	PROCEDURE insert_aaa (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2) IS
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

	PROCEDURE insert_aad (
			p_fk_aaa_naam IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_xk_aaa_naam IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_aaa_deel (
			cube_id,
			fk_aaa_naam,
			naam,
			xk_aaa_naam)
		VALUES (
			NULL,
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
	PROCEDURE change_parent_ccc (
			p_cube_flag_root IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2);
	PROCEDURE insert_ccc (
			p_fk_ccc_code IN VARCHAR2,
			p_fk_ccc_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrjving IN VARCHAR2);
	PROCEDURE update_ccc (
			p_fk_ccc_code IN VARCHAR2,
			p_fk_ccc_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrjving IN VARCHAR2);
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
			  code,
			  naam
			FROM v_ccc
			WHERE fk_ccc_code IS NULL
			  AND fk_ccc_naam IS NULL
			ORDER BY code, naam;
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
			  omschrjving
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
			  code,
			  naam
			FROM v_ccc
			WHERE fk_ccc_code = p_code
			  AND fk_ccc_naam = p_naam
			ORDER BY code, naam;
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

	PROCEDURE change_parent_ccc (
			p_cube_flag_root IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			x_code IN VARCHAR2,
			x_naam IN VARCHAR2) IS
	BEGIN
		IF p_cube_flag_root = 'Y' THEN
			UPDATE v_ccc SET
				fk_ccc_code = NULL,
				fk_ccc_naam = NULL
			WHERE code = p_code
			  AND naam = p_naam;
			IF SQL%NOTFOUND THEN
				RAISE_APPLICATION_ERROR (-20002, 'Type ccc not found');
			END IF;
		ELSE
			check_no_part_ccc (p_code, p_naam, x_code, x_naam);
			UPDATE v_ccc SET
				fk_ccc_code = x_code,
				fk_ccc_naam = x_naam
			WHERE code = p_code
			  AND naam = p_naam;
			IF SQL%NOTFOUND THEN
				RAISE_APPLICATION_ERROR (-20002, 'Type ccc not found');
			END IF;
		END IF;
	END;

	PROCEDURE insert_ccc (
			p_fk_ccc_code IN VARCHAR2,
			p_fk_ccc_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrjving IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_ccc (
			cube_id,
			cube_level,
			fk_ccc_code,
			fk_ccc_naam,
			code,
			naam,
			omschrjving)
		VALUES (
			NULL,
			NULL,
			p_fk_ccc_code,
			p_fk_ccc_naam,
			p_code,
			p_naam,
			p_omschrjving);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type ccc already exists');
	END;

	PROCEDURE update_ccc (
			p_fk_ccc_code IN VARCHAR2,
			p_fk_ccc_naam IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_omschrjving IN VARCHAR2) IS
	BEGIN
		UPDATE v_ccc SET
			fk_ccc_code = p_fk_ccc_code,
			fk_ccc_naam = p_fk_ccc_naam,
			omschrjving = p_omschrjving
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

EXIT;