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
CREATE OR REPLACE PACKAGE pkg_kln IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_pkg_cubetest RETURN VARCHAR2;
	PROCEDURE get_kln_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_kln_list (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_kln (
			p_cube_row IN OUT c_cube_row,
			p_nummer IN VARCHAR2);
	PROCEDURE get_kln_adr_items (
			p_cube_row IN OUT c_cube_row,
			p_nummer IN VARCHAR2);
	PROCEDURE insert_kln (
			p_cube_tsg_intext IN VARCHAR2,
			p_nummer IN VARCHAR2,
			p_achternaam IN VARCHAR2,
			p_geboorte_datum IN DATE,
			p_leeftijd IN NUMBER,
			p_voornaam IN VARCHAR2,
			p_tussenvoegsel IN VARCHAR2);
	PROCEDURE update_kln (
			p_cube_tsg_intext IN VARCHAR2,
			p_nummer IN VARCHAR2,
			p_achternaam IN VARCHAR2,
			p_geboorte_datum IN DATE,
			p_leeftijd IN NUMBER,
			p_voornaam IN VARCHAR2,
			p_tussenvoegsel IN VARCHAR2);
	PROCEDURE delete_kln (
			p_nummer IN VARCHAR2);
	PROCEDURE insert_adr (
			p_fk_kln_nummer IN VARCHAR2,
			p_postcode_cijfers IN NUMBER,
			p_postcode_letters IN CHAR,
			p_cube_tsg_test IN VARCHAR2,
			p_huisnummer IN NUMBER);
	PROCEDURE delete_adr (
			p_fk_kln_nummer IN VARCHAR2,
			p_postcode_cijfers IN NUMBER,
			p_postcode_letters IN CHAR,
			p_cube_tsg_test IN VARCHAR2,
			p_huisnummer IN NUMBER);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_kln IS
	FUNCTION cube_pkg_cubetest RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubetest';
	END;

	PROCEDURE get_kln_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_intext,
			  nummer,
			  achternaam,
			  voornaam
			FROM v_klant
			ORDER BY cube_tsg_intext, nummer, achternaam, voornaam;
	END;

	PROCEDURE get_kln_list (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_intext,
			  nummer,
			  achternaam,
			  voornaam
			FROM v_klant
			ORDER BY cube_tsg_intext, nummer, achternaam, voornaam;
	END;

	PROCEDURE get_kln (
			p_cube_row IN OUT c_cube_row,
			p_nummer IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_intext,
			  achternaam,
			  geboorte_datum,
			  leeftijd,
			  voornaam,
			  tussenvoegsel
			FROM v_klant
			WHERE nummer = p_nummer;
	END;

	PROCEDURE get_kln_adr_items (
			p_cube_row IN OUT c_cube_row,
			p_nummer IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_kln_nummer,
			  postcode_cijfers,
			  postcode_letters,
			  cube_tsg_test,
			  huisnummer
			FROM v_adres
			WHERE fk_kln_nummer = p_nummer
			ORDER BY fk_kln_nummer, postcode_cijfers, postcode_letters, cube_tsg_test, huisnummer;
	END;

	PROCEDURE insert_kln (
			p_cube_tsg_intext IN VARCHAR2,
			p_nummer IN VARCHAR2,
			p_achternaam IN VARCHAR2,
			p_geboorte_datum IN DATE,
			p_leeftijd IN NUMBER,
			p_voornaam IN VARCHAR2,
			p_tussenvoegsel IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_klant (
			cube_id,
			cube_tsg_intext,
			nummer,
			achternaam,
			geboorte_datum,
			leeftijd,
			voornaam,
			tussenvoegsel)
		VALUES (
			NULL,
			p_cube_tsg_intext,
			p_nummer,
			p_achternaam,
			p_geboorte_datum,
			p_leeftijd,
			p_voornaam,
			p_tussenvoegsel);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type klant already exists');
	END;

	PROCEDURE update_kln (
			p_cube_tsg_intext IN VARCHAR2,
			p_nummer IN VARCHAR2,
			p_achternaam IN VARCHAR2,
			p_geboorte_datum IN DATE,
			p_leeftijd IN NUMBER,
			p_voornaam IN VARCHAR2,
			p_tussenvoegsel IN VARCHAR2) IS
	BEGIN
		UPDATE v_klant SET
			cube_tsg_intext = p_cube_tsg_intext,
			achternaam = p_achternaam,
			geboorte_datum = p_geboorte_datum,
			leeftijd = p_leeftijd,
			voornaam = p_voornaam,
			tussenvoegsel = p_tussenvoegsel
		WHERE nummer = p_nummer;
	END;

	PROCEDURE delete_kln (
			p_nummer IN VARCHAR2) IS
	BEGIN
		DELETE v_klant
		WHERE nummer = p_nummer;
	END;

	PROCEDURE insert_adr (
			p_fk_kln_nummer IN VARCHAR2,
			p_postcode_cijfers IN NUMBER,
			p_postcode_letters IN CHAR,
			p_cube_tsg_test IN VARCHAR2,
			p_huisnummer IN NUMBER) IS
	BEGIN
		INSERT INTO v_adres (
			cube_id,
			fk_kln_nummer,
			postcode_cijfers,
			postcode_letters,
			cube_tsg_test,
			huisnummer)
		VALUES (
			NULL,
			p_fk_kln_nummer,
			p_postcode_cijfers,
			p_postcode_letters,
			p_cube_tsg_test,
			p_huisnummer);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type adres already exists');
	END;

	PROCEDURE delete_adr (
			p_fk_kln_nummer IN VARCHAR2,
			p_postcode_cijfers IN NUMBER,
			p_postcode_letters IN CHAR,
			p_cube_tsg_test IN VARCHAR2,
			p_huisnummer IN NUMBER) IS
	BEGIN
		DELETE v_adres
		WHERE fk_kln_nummer = p_fk_kln_nummer
		  AND postcode_cijfers = p_postcode_cijfers
		  AND postcode_letters = p_postcode_letters
		  AND cube_tsg_test = p_cube_tsg_test
		  AND huisnummer = p_huisnummer;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE pkg_prd IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_pkg_cubetest RETURN VARCHAR2;
	PROCEDURE get_prd_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_prd_list (
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
			p_xk_kln_nummer IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_prd (
			p_cube_tsg_type IN VARCHAR2,
			p_cube_tsg_soort IN VARCHAR2,
			p_cube_tsg_soort1 IN VARCHAR2,
			p_code IN VARCHAR2,
			p_prijs IN NUMBER,
			p_makelaar_naam IN VARCHAR2,
			p_bedrag_btw IN NUMBER,
			p_xk_kln_nummer IN VARCHAR2);
	PROCEDURE delete_prd (
			p_cube_tsg_type IN VARCHAR2,
			p_code IN VARCHAR2);
	PROCEDURE get_ond_list_recursive (
			p_cube_row IN OUT c_cube_row,
			p_cube_up_or_down IN VARCHAR2,
			p_cube_x_level IN NUMBER,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
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
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2,
			x_fk_prd_cube_tsg_type IN VARCHAR2,
			x_fk_prd_code IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE update_ond (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_prijs IN NUMBER,
			p_omschrijving IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2);
	PROCEDURE delete_ond (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2);
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
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE update_odd (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2);
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
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_3 IN VARCHAR2,
			p_xf_ond_prd_code_3 IN VARCHAR2,
			p_xk_ond_code_3 IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_1 IN VARCHAR2,
			p_xf_ond_prd_code_1 IN VARCHAR2,
			p_xk_ond_code_1 IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_2 IN VARCHAR2,
			p_xf_ond_prd_code_2 IN VARCHAR2,
			p_xk_ond_code_2 IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE update_ddd (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_fk_odd_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_3 IN VARCHAR2,
			p_xf_ond_prd_code_3 IN VARCHAR2,
			p_xk_ond_code_3 IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_1 IN VARCHAR2,
			p_xf_ond_prd_code_1 IN VARCHAR2,
			p_xk_ond_code_1 IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_2 IN VARCHAR2,
			p_xf_ond_prd_code_2 IN VARCHAR2,
			p_xk_ond_code_2 IN VARCHAR2);
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
			p_xk_odd_code_1 IN VARCHAR2);
	PROCEDURE update_cst (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_omschrijving IN VARCHAR2,
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

	PROCEDURE get_prd_list (
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
			  bedrag_btw,
			  xk_kln_nummer
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
			p_xk_kln_nummer IN VARCHAR2,
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
			bedrag_btw,
			xk_kln_nummer)
		VALUES (
			NULL,
			p_cube_tsg_type,
			p_cube_tsg_soort,
			p_cube_tsg_soort1,
			p_code,
			p_prijs,
			p_makelaar_naam,
			p_bedrag_btw,
			p_xk_kln_nummer);

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
			p_bedrag_btw IN NUMBER,
			p_xk_kln_nummer IN VARCHAR2) IS
	BEGIN
		UPDATE v_produkt SET
			cube_tsg_soort = p_cube_tsg_soort,
			cube_tsg_soort1 = p_cube_tsg_soort1,
			prijs = p_prijs,
			makelaar_naam = p_makelaar_naam,
			bedrag_btw = p_bedrag_btw,
			xk_kln_nummer = p_xk_kln_nummer
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

	PROCEDURE get_ond_list_recursive (
			p_cube_row IN OUT c_cube_row,
			p_cube_up_or_down IN VARCHAR2,
			p_cube_x_level IN NUMBER,
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			WITH anchor (
				cube_sequence,
				fk_prd_cube_tsg_type,
				fk_prd_code,
				code,
				fk_ond_code,
				cube_x_level) AS (
				SELECT
					cube_sequence,
					fk_prd_cube_tsg_type,
					fk_prd_code,
					code,
					fk_ond_code,
					0 
				FROM v_onderdeel
				WHERE fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type
				  AND fk_prd_code = p_fk_prd_code
				  AND code = p_code
				UNION ALL
				SELECT
					recursive.cube_sequence,
					recursive.fk_prd_cube_tsg_type,
					recursive.fk_prd_code,
					recursive.code,
					recursive.fk_ond_code,
					anchor.cube_x_level+1
				FROM v_onderdeel recursive, anchor
				WHERE 	    ( 	    ( p_cube_up_or_down = 'D'
						  AND 	    ( anchor.fk_prd_cube_tsg_type = recursive.fk_prd_cube_tsg_type
							  AND anchor.fk_prd_code = recursive.fk_prd_code
							  AND anchor.code = recursive.fk_ond_code ) )
					   OR 	    ( p_cube_up_or_down = 'U'
						  AND 	    ( anchor.fk_prd_cube_tsg_type = recursive.fk_prd_cube_tsg_type
							  AND anchor.fk_prd_code = recursive.fk_prd_code
							  AND anchor.fk_ond_code = recursive.code ) ) )
				  AND anchor.cube_x_level < p_cube_x_level
				)
			SELECT DISTINCT cube_sequence, fk_prd_cube_tsg_type, fk_prd_code, code
			FROM anchor
			WHERE cube_x_level > 0
			ORDER BY fk_prd_cube_tsg_type, fk_prd_code, cube_sequence;
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
			  omschrijving,
			  xf_ond_prd_cube_tsg_type,
			  xf_ond_prd_code,
			  xk_ond_code
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
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2,
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
			omschrijving,
			xf_ond_prd_cube_tsg_type,
			xf_ond_prd_code,
			xk_ond_code)
		VALUES (
			NULL,
			l_cube_sequence,
			NULL,
			p_fk_prd_cube_tsg_type,
			p_fk_prd_code,
			p_fk_ond_code,
			p_code,
			p_prijs,
			p_omschrijving,
			p_xf_ond_prd_cube_tsg_type,
			p_xf_ond_prd_code,
			p_xk_ond_code);
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
			p_omschrijving IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2) IS
	BEGIN
		UPDATE v_onderdeel SET
			fk_ond_code = p_fk_ond_code,
			prijs = p_prijs,
			omschrijving = p_omschrijving,
			xf_ond_prd_cube_tsg_type = p_xf_ond_prd_cube_tsg_type,
			xf_ond_prd_code = p_xf_ond_prd_code,
			xk_ond_code = p_xk_ond_code
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
			  naam,
			  xf_ond_prd_cube_tsg_type,
			  xf_ond_prd_code,
			  xk_ond_code
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
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2,
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
			naam,
			xf_ond_prd_cube_tsg_type,
			xf_ond_prd_code,
			xk_ond_code)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_prd_cube_tsg_type,
			p_fk_prd_code,
			p_fk_ond_code,
			p_code,
			p_naam,
			p_xf_ond_prd_cube_tsg_type,
			p_xf_ond_prd_code,
			p_xk_ond_code);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type onderdeel_deel already exists');
	END;

	PROCEDURE update_odd (
			p_fk_prd_cube_tsg_type IN VARCHAR2,
			p_fk_prd_code IN VARCHAR2,
			p_fk_ond_code IN VARCHAR2,
			p_code IN VARCHAR2,
			p_naam IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2) IS
	BEGIN
		UPDATE v_onderdeel_deel SET
			fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type,
			fk_prd_code = p_fk_prd_code,
			fk_ond_code = p_fk_ond_code,
			naam = p_naam,
			xf_ond_prd_cube_tsg_type = p_xf_ond_prd_cube_tsg_type,
			xf_ond_prd_code = p_xf_ond_prd_code,
			xk_ond_code = p_xk_ond_code
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
			  naam,
			  xf_ond_prd_cube_tsg_type,
			  xf_ond_prd_code,
			  xk_ond_code,
			  xf_ond_prd_cube_tsg_type_3,
			  xf_ond_prd_code_3,
			  xk_ond_code_3,
			  xf_ond_prd_cube_tsg_type_1,
			  xf_ond_prd_code_1,
			  xk_ond_code_1,
			  xf_ond_prd_cube_tsg_type_2,
			  xf_ond_prd_code_2,
			  xk_ond_code_2
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
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_3 IN VARCHAR2,
			p_xf_ond_prd_code_3 IN VARCHAR2,
			p_xk_ond_code_3 IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_1 IN VARCHAR2,
			p_xf_ond_prd_code_1 IN VARCHAR2,
			p_xk_ond_code_1 IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_2 IN VARCHAR2,
			p_xf_ond_prd_code_2 IN VARCHAR2,
			p_xk_ond_code_2 IN VARCHAR2,
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
			naam,
			xf_ond_prd_cube_tsg_type,
			xf_ond_prd_code,
			xk_ond_code,
			xf_ond_prd_cube_tsg_type_3,
			xf_ond_prd_code_3,
			xk_ond_code_3,
			xf_ond_prd_cube_tsg_type_1,
			xf_ond_prd_code_1,
			xk_ond_code_1,
			xf_ond_prd_cube_tsg_type_2,
			xf_ond_prd_code_2,
			xk_ond_code_2)
		VALUES (
			NULL,
			l_cube_sequence,
			p_fk_prd_cube_tsg_type,
			p_fk_prd_code,
			p_fk_ond_code,
			p_fk_odd_code,
			p_code,
			p_naam,
			p_xf_ond_prd_cube_tsg_type,
			p_xf_ond_prd_code,
			p_xk_ond_code,
			p_xf_ond_prd_cube_tsg_type_3,
			p_xf_ond_prd_code_3,
			p_xk_ond_code_3,
			p_xf_ond_prd_cube_tsg_type_1,
			p_xf_ond_prd_code_1,
			p_xk_ond_code_1,
			p_xf_ond_prd_cube_tsg_type_2,
			p_xf_ond_prd_code_2,
			p_xk_ond_code_2);
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
			p_naam IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type IN VARCHAR2,
			p_xf_ond_prd_code IN VARCHAR2,
			p_xk_ond_code IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_3 IN VARCHAR2,
			p_xf_ond_prd_code_3 IN VARCHAR2,
			p_xk_ond_code_3 IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_1 IN VARCHAR2,
			p_xf_ond_prd_code_1 IN VARCHAR2,
			p_xk_ond_code_1 IN VARCHAR2,
			p_xf_ond_prd_cube_tsg_type_2 IN VARCHAR2,
			p_xf_ond_prd_code_2 IN VARCHAR2,
			p_xk_ond_code_2 IN VARCHAR2) IS
	BEGIN
		UPDATE v_onderdeel_deel_deel SET
			fk_prd_cube_tsg_type = p_fk_prd_cube_tsg_type,
			fk_prd_code = p_fk_prd_code,
			fk_ond_code = p_fk_ond_code,
			fk_odd_code = p_fk_odd_code,
			naam = p_naam,
			xf_ond_prd_cube_tsg_type = p_xf_ond_prd_cube_tsg_type,
			xf_ond_prd_code = p_xf_ond_prd_code,
			xk_ond_code = p_xk_ond_code,
			xf_ond_prd_cube_tsg_type_3 = p_xf_ond_prd_cube_tsg_type_3,
			xf_ond_prd_code_3 = p_xf_ond_prd_code_3,
			xk_ond_code_3 = p_xk_ond_code_3,
			xf_ond_prd_cube_tsg_type_1 = p_xf_ond_prd_cube_tsg_type_1,
			xf_ond_prd_code_1 = p_xf_ond_prd_code_1,
			xk_ond_code_1 = p_xk_ond_code_1,
			xf_ond_prd_cube_tsg_type_2 = p_xf_ond_prd_cube_tsg_type_2,
			xf_ond_prd_code_2 = p_xf_ond_prd_code_2,
			xk_ond_code_2 = p_xk_ond_code_2
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
			p_xk_odd_code_1 IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_constructie (
			cube_id,
			fk_prd_cube_tsg_type,
			fk_prd_code,
			fk_ond_code,
			code,
			omschrijving,
			xk_odd_code_1)
		VALUES (
			NULL,
			p_fk_prd_cube_tsg_type,
			p_fk_prd_code,
			p_fk_ond_code,
			p_code,
			p_omschrijving,
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
			p_xk_odd_code_1 IN VARCHAR2) IS
	BEGIN
		UPDATE v_constructie SET
			omschrijving = p_omschrijving,
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

CREATE OR REPLACE PACKAGE pkg_ord IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_pkg_cubetest RETURN VARCHAR2;
	PROCEDURE get_ord_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_ord (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2);
	PROCEDURE get_ord_orr_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2);
	PROCEDURE move_ord (
			p_cube_pos_action IN VARCHAR2,
			p_code IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE insert_ord (
			p_cube_pos_action IN VARCHAR2,
			p_cube_tsg_int_ext IN VARCHAR2,
			p_code IN VARCHAR2,
			p_xk_kln_nummer IN VARCHAR2,
			x_code IN VARCHAR2);
	PROCEDURE update_ord (
			p_cube_tsg_int_ext IN VARCHAR2,
			p_code IN VARCHAR2,
			p_xk_kln_nummer IN VARCHAR2);
	PROCEDURE delete_ord (
			p_code IN VARCHAR2);
	PROCEDURE get_orr (
			p_cube_row IN OUT c_cube_row,
			p_fk_ord_code IN VARCHAR2);
	PROCEDURE insert_orr (
			p_fk_ord_code IN VARCHAR2,
			p_produkt_prijs IN NUMBER,
			p_aantal IN NUMBER,
			p_totaal_prijs IN NUMBER,
			p_xk_prd_cube_tsg_type IN VARCHAR2,
			p_xk_prd_code IN VARCHAR2,
			p_xk_prd_cube_tsg_type_1 IN VARCHAR2,
			p_xk_prd_code_1 IN VARCHAR2,
			p_xk_kln_nummer IN VARCHAR2,
			p_cube_row IN OUT c_cube_row);
	PROCEDURE update_orr (
			p_fk_ord_code IN VARCHAR2,
			p_produkt_prijs IN NUMBER,
			p_aantal IN NUMBER,
			p_totaal_prijs IN NUMBER,
			p_xk_prd_cube_tsg_type IN VARCHAR2,
			p_xk_prd_code IN VARCHAR2,
			p_xk_prd_cube_tsg_type_1 IN VARCHAR2,
			p_xk_prd_code_1 IN VARCHAR2,
			p_xk_kln_nummer IN VARCHAR2);
	PROCEDURE delete_orr (
			p_fk_ord_code IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_ord IS
	FUNCTION cube_pkg_cubetest RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubetest';
	END;

	PROCEDURE get_ord_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_sequence,
			  cube_tsg_int_ext,
			  code
			FROM v_order
			ORDER BY cube_sequence;
	END;

	PROCEDURE get_ord (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  cube_tsg_int_ext,
			  xk_kln_nummer
			FROM v_order
			WHERE code = p_code;
	END;

	PROCEDURE get_ord_orr_items (
			p_cube_row IN OUT c_cube_row,
			p_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_ord_code,
			  totaal_prijs
			FROM v_order_regel
			WHERE fk_ord_code = p_code
			ORDER BY fk_ord_code, totaal_prijs;
	END;

	PROCEDURE determine_position_ord (
			p_cube_sequence OUT NUMBER,
			p_cube_pos_action IN VARCHAR2,
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
				FROM v_order
				WHERE code = p_code;
			END IF;
			-- read sequence number near the target.
			SELECT DECODE (l_cube_pos_action, 'B', NVL (MAX (cube_sequence), 0), NVL (MIN (cube_sequence), 99999999))
			INTO l_cube_near_sequ
			FROM v_order
			WHERE 	    ( l_cube_pos_action = 'B'
				  AND cube_sequence < l_cube_position_sequ )
			   OR 	    ( l_cube_pos_action = 'A'
				  AND cube_sequence > l_cube_position_sequ );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_ord IN (
					SELECT
					  rowid row_id
					FROM v_order
					ORDER BY cube_sequence)
				LOOP
					UPDATE v_order SET
						cube_sequence = l_cube_count
					WHERE rowid = r_ord.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;

	PROCEDURE move_ord (
			p_cube_pos_action IN VARCHAR2,
			p_code IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_ord (l_cube_sequence, p_cube_pos_action, x_code);
		UPDATE v_order SET
			cube_sequence = l_cube_sequence
		WHERE code = p_code;
		IF SQL%NOTFOUND THEN
			RAISE_APPLICATION_ERROR (-20002, 'Type order not found');
		END IF;
	END;

	PROCEDURE insert_ord (
			p_cube_pos_action IN VARCHAR2,
			p_cube_tsg_int_ext IN VARCHAR2,
			p_code IN VARCHAR2,
			p_xk_kln_nummer IN VARCHAR2,
			x_code IN VARCHAR2) IS
		l_cube_sequence NUMBER(8);
	BEGIN
		-- A=After B=Before F=First L=Last
		IF NVL (p_cube_pos_action, ' ') NOT IN ('A', 'B', 'F', 'L') THEN
			RAISE_APPLICATION_ERROR (-20005, 'Invalid position action: ' || p_cube_pos_action);
		END IF;
		determine_position_ord (l_cube_sequence, p_cube_pos_action, x_code);
		INSERT INTO v_order (
			cube_id,
			cube_sequence,
			cube_tsg_int_ext,
			code,
			xk_kln_nummer)
		VALUES (
			NULL,
			l_cube_sequence,
			p_cube_tsg_int_ext,
			p_code,
			p_xk_kln_nummer);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type order already exists');
	END;

	PROCEDURE update_ord (
			p_cube_tsg_int_ext IN VARCHAR2,
			p_code IN VARCHAR2,
			p_xk_kln_nummer IN VARCHAR2) IS
	BEGIN
		UPDATE v_order SET
			cube_tsg_int_ext = p_cube_tsg_int_ext,
			xk_kln_nummer = p_xk_kln_nummer
		WHERE code = p_code;
	END;

	PROCEDURE delete_ord (
			p_code IN VARCHAR2) IS
	BEGIN
		DELETE v_order
		WHERE code = p_code;
	END;

	PROCEDURE get_orr (
			p_cube_row IN OUT c_cube_row,
			p_fk_ord_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  produkt_prijs,
			  aantal,
			  totaal_prijs,
			  xk_prd_cube_tsg_type,
			  xk_prd_code,
			  xk_prd_cube_tsg_type_1,
			  xk_prd_code_1,
			  xk_kln_nummer
			FROM v_order_regel
			WHERE fk_ord_code = p_fk_ord_code;
	END;

	PROCEDURE get_next_orr (
			p_cube_row IN OUT c_cube_row,
			p_fk_ord_code IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  fk_ord_code
			FROM v_order_regel
			WHERE fk_ord_code > p_fk_ord_code
			ORDER BY fk_ord_code;
	END;

	PROCEDURE insert_orr (
			p_fk_ord_code IN VARCHAR2,
			p_produkt_prijs IN NUMBER,
			p_aantal IN NUMBER,
			p_totaal_prijs IN NUMBER,
			p_xk_prd_cube_tsg_type IN VARCHAR2,
			p_xk_prd_code IN VARCHAR2,
			p_xk_prd_cube_tsg_type_1 IN VARCHAR2,
			p_xk_prd_code_1 IN VARCHAR2,
			p_xk_kln_nummer IN VARCHAR2,
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		INSERT INTO v_order_regel (
			cube_id,
			fk_ord_code,
			produkt_prijs,
			aantal,
			totaal_prijs,
			xk_prd_cube_tsg_type,
			xk_prd_code,
			xk_prd_cube_tsg_type_1,
			xk_prd_code_1,
			xk_kln_nummer)
		VALUES (
			NULL,
			p_fk_ord_code,
			p_produkt_prijs,
			p_aantal,
			p_totaal_prijs,
			p_xk_prd_cube_tsg_type,
			p_xk_prd_code,
			p_xk_prd_cube_tsg_type_1,
			p_xk_prd_code_1,
			p_xk_kln_nummer);

		get_next_orr (p_cube_row, p_fk_ord_code);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type order_regel already exists');
	END;

	PROCEDURE update_orr (
			p_fk_ord_code IN VARCHAR2,
			p_produkt_prijs IN NUMBER,
			p_aantal IN NUMBER,
			p_totaal_prijs IN NUMBER,
			p_xk_prd_cube_tsg_type IN VARCHAR2,
			p_xk_prd_code IN VARCHAR2,
			p_xk_prd_cube_tsg_type_1 IN VARCHAR2,
			p_xk_prd_code_1 IN VARCHAR2,
			p_xk_kln_nummer IN VARCHAR2) IS
	BEGIN
		UPDATE v_order_regel SET
			produkt_prijs = p_produkt_prijs,
			aantal = p_aantal,
			totaal_prijs = p_totaal_prijs,
			xk_prd_cube_tsg_type = p_xk_prd_cube_tsg_type,
			xk_prd_code = p_xk_prd_code,
			xk_prd_cube_tsg_type_1 = p_xk_prd_cube_tsg_type_1,
			xk_prd_code_1 = p_xk_prd_code_1,
			xk_kln_nummer = p_xk_kln_nummer
		WHERE fk_ord_code = p_fk_ord_code;
	END;

	PROCEDURE delete_orr (
			p_fk_ord_code IN VARCHAR2) IS
	BEGIN
		DELETE v_order_regel
		WHERE fk_ord_code = p_fk_ord_code;
	END;
END;
/
SHOW ERRORS;

EXIT;