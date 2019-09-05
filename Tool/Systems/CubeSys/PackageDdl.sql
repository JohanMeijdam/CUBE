-- CUBESYS Packages
--
BEGIN
	FOR r_p IN (
		SELECT object_name
		FROM user_procedures
		WHERE procedure_name = 'CUBE_PKG_CUBESYS' )
	LOOP
		EXECUTE IMMEDIATE 'DROP PACKAGE '||r_p.object_name;
	END LOOP;
END;
/
CREATE OR REPLACE PACKAGE pkg_cube IS
	FUNCTION cube_pkg_cubesys RETURN VARCHAR2;
	FUNCTION years(p_date DATE) RETURN NUMBER;
	FUNCTION multiply(p_num_1 NUMBER, p_num_2 NUMBER) RETURN NUMBER;
	FUNCTION add(p_num_1 NUMBER, p_num_2 NUMBER) RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY pkg_cube IS
	FUNCTION cube_pkg_cubesys RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubesys';
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
CREATE OR REPLACE PACKAGE pkg_cube_dsc IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_pkg_cubesys RETURN VARCHAR2;
	PROCEDURE get_cube_dsc_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_cube_dsc (
			p_cube_row IN OUT c_cube_row,
			p_type_name IN VARCHAR2,
			p_attribute_type_name IN VARCHAR2,
			p_sequence IN NUMBER);
	PROCEDURE insert_cube_dsc (
			p_type_name IN VARCHAR2,
			p_attribute_type_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_value IN VARCHAR2);
	PROCEDURE update_cube_dsc (
			p_type_name IN VARCHAR2,
			p_attribute_type_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_value IN VARCHAR2);
	PROCEDURE delete_cube_dsc (
			p_type_name IN VARCHAR2,
			p_attribute_type_name IN VARCHAR2,
			p_sequence IN NUMBER);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_cube_dsc IS
	FUNCTION cube_pkg_cubesys RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubesys';
	END;

	PROCEDURE get_cube_dsc_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  type_name,
			  attribute_type_name,
			  sequence
			FROM v_cube_description
			ORDER BY type_name, attribute_type_name, sequence;
	END;

	PROCEDURE get_cube_dsc (
			p_cube_row IN OUT c_cube_row,
			p_type_name IN VARCHAR2,
			p_attribute_type_name IN VARCHAR2,
			p_sequence IN NUMBER) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  value
			FROM v_cube_description
			WHERE type_name = p_type_name
			  AND attribute_type_name = p_attribute_type_name
			  AND sequence = p_sequence;
	END;

	PROCEDURE insert_cube_dsc (
			p_type_name IN VARCHAR2,
			p_attribute_type_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_value IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_cube_description (
			cube_id,
			type_name,
			attribute_type_name,
			sequence,
			value)
		VALUES (
			NULL,
			p_type_name,
			p_attribute_type_name,
			p_sequence,
			p_value);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20001, 'Type cube_description already exists');
	END;

	PROCEDURE update_cube_dsc (
			p_type_name IN VARCHAR2,
			p_attribute_type_name IN VARCHAR2,
			p_sequence IN NUMBER,
			p_value IN VARCHAR2) IS
	BEGIN
		UPDATE v_cube_description SET
			value = p_value
		WHERE type_name = p_type_name
		  AND attribute_type_name = p_attribute_type_name
		  AND sequence = p_sequence;
	END;

	PROCEDURE delete_cube_dsc (
			p_type_name IN VARCHAR2,
			p_attribute_type_name IN VARCHAR2,
			p_sequence IN NUMBER) IS
	BEGIN
		DELETE v_cube_description
		WHERE type_name = p_type_name
		  AND attribute_type_name = p_attribute_type_name
		  AND sequence = p_sequence;
	END;
END;
/
SHOW ERRORS;

EXIT;