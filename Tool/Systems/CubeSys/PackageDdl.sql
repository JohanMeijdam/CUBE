-- CUBESYS Packages
--
CREATE OR REPLACE PACKAGE pkg_cube_usr IS

	TYPE c_cube_row IS REF CURSOR;
	FUNCTION cube_pkg_cubesys RETURN VARCHAR2;
	PROCEDURE get_cube_usr_root_items (
			p_cube_row IN OUT c_cube_row);
	PROCEDURE get_cube_usr (
			p_cube_row IN OUT c_cube_row,
			p_userid IN VARCHAR2);
	PROCEDURE insert_cube_usr (
			p_userid IN VARCHAR2,
			p_name IN VARCHAR2,
			p_password IN VARCHAR2);
	PROCEDURE update_cube_usr (
			p_userid IN VARCHAR2,
			p_name IN VARCHAR2,
			p_password IN VARCHAR2);
	PROCEDURE delete_cube_usr (
			p_userid IN VARCHAR2);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_cube_usr IS
	FUNCTION cube_pkg_cubesys RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_pkg_cubesys';
	END;

	PROCEDURE get_cube_usr_root_items (
			p_cube_row IN OUT c_cube_row) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  userid,
			  name
			FROM v_cube_user
			ORDER BY userid, name;
	END;

	PROCEDURE get_cube_usr (
			p_cube_row IN OUT c_cube_row,
			p_userid IN VARCHAR2) IS
	BEGIN
		OPEN p_cube_row FOR
			SELECT
			  name,
			  password
			FROM v_cube_user
			WHERE userid = p_userid;
	END;

	PROCEDURE insert_cube_usr (
			p_userid IN VARCHAR2,
			p_name IN VARCHAR2,
			p_password IN VARCHAR2) IS
	BEGIN
		INSERT INTO v_cube_user (
			cube_id,
			userid,
			name,
			password)
		VALUES (
			NULL,
			p_userid,
			p_name,
			p_password);
	EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
			RAISE_APPLICATION_ERROR (-20000, pkg_cube.replace_placeholders('Type cube_user already exists'));
	END;

	PROCEDURE update_cube_usr (
			p_userid IN VARCHAR2,
			p_name IN VARCHAR2,
			p_password IN VARCHAR2) IS
	BEGIN
		UPDATE v_cube_user SET
			name = p_name,
			password = p_password
		WHERE userid = p_userid;
	END;

	PROCEDURE delete_cube_usr (
			p_userid IN VARCHAR2) IS
	BEGIN
		DELETE v_cube_user
		WHERE userid = p_userid;
	END;
END;
/
SHOW ERRORS;

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
			RAISE_APPLICATION_ERROR (-20000, pkg_cube.replace_placeholders('Type cube_description already exists'));
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