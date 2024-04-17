-- CUBESYS Stored procedures
--

DO $BODY$
	DECLARE
		rec_proc RECORD;
	BEGIN
		FOR rec_proc IN
			SELECT proname, prokind
			FROM pg_catalog.pg_proc, pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE pronamespace = pg_namespace.oid
			  AND nspowner = usesysid
			  AND usename = '<<2>>'
			  AND nspname = 'cube_usr'
			  AND proname NOT LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE cube_usr.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION cube_usr.' || rec_proc.proname;
			END CASE;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE cube_usr.get_cube_usr_root_items ()
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		OPEN l_cube_cursor FOR
			SELECT
			  userid,
			  name
			FROM cube_usr.v_cube_user
			ORDER BY userid, name;
	END;
$BODY$;

CREATE PROCEDURE cube_usr.get_cube_usr (
			p_userid IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_userid := NULLIF(p_userid,'');
		OPEN l_cube_cursor FOR
			SELECT
			  name,
			  password
			FROM cube_usr.v_cube_user
			WHERE userid = p_userid;
	END;
$BODY$;

CREATE PROCEDURE cube_usr.insert_cube_usr (
			p_userid IN VARCHAR,
			p_name IN VARCHAR,
			p_password IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_userid := NULLIF(p_userid,'');
		p_name := NULLIF(p_name,'');
		p_password := NULLIF(p_password,'');
		INSERT INTO cube_usr.v_cube_user (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type cube_user already exists';
	END;
$BODY$;

CREATE PROCEDURE cube_usr.update_cube_usr (
			p_userid IN VARCHAR,
			p_name IN VARCHAR,
			p_password IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_userid := NULLIF(p_userid,'');
		p_name := NULLIF(p_name,'');
		p_password := NULLIF(p_password,'');
		UPDATE cube_usr.v_cube_user SET
			name = p_name,
			password = p_password
		WHERE userid = p_userid;
	END;
$BODY$;

CREATE PROCEDURE cube_usr.delete_cube_usr (
			p_userid IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_userid := NULLIF(p_userid,'');
		DELETE FROM cube_usr.v_cube_user
		WHERE userid = p_userid;
	END;
$BODY$;

DO $BODY$
	DECLARE
		rec_proc RECORD;
	BEGIN
		FOR rec_proc IN
			SELECT proname, prokind
			FROM pg_catalog.pg_proc, pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE pronamespace = pg_namespace.oid
			  AND nspowner = usesysid
			  AND usename = '<<2>>'
			  AND nspname = 'cube_dsc'
			  AND proname NOT LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE cube_dsc.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION cube_dsc.' || rec_proc.proname;
			END CASE;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE cube_dsc.get_cube_dsc_root_items ()
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		OPEN l_cube_cursor FOR
			SELECT
			  type_name,
			  attribute_type_name,
			  sequence
			FROM cube_dsc.v_cube_description
			ORDER BY type_name, attribute_type_name, sequence;
	END;
$BODY$;

CREATE PROCEDURE cube_dsc.get_cube_dsc (
			p_type_name IN VARCHAR,
			p_attribute_type_name IN VARCHAR,
			p_sequence IN NUMERIC)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_type_name := NULLIF(p_type_name,'');
		p_attribute_type_name := NULLIF(p_attribute_type_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  value
			FROM cube_dsc.v_cube_description
			WHERE type_name = p_type_name
			  AND attribute_type_name = p_attribute_type_name
			  AND sequence = p_sequence;
	END;
$BODY$;

CREATE PROCEDURE cube_dsc.insert_cube_dsc (
			p_type_name IN VARCHAR,
			p_attribute_type_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_value IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_type_name := NULLIF(p_type_name,'');
		p_attribute_type_name := NULLIF(p_attribute_type_name,'');
		p_value := NULLIF(p_value,'');
		INSERT INTO cube_dsc.v_cube_description (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type cube_description already exists';
	END;
$BODY$;

CREATE PROCEDURE cube_dsc.update_cube_dsc (
			p_type_name IN VARCHAR,
			p_attribute_type_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_value IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_type_name := NULLIF(p_type_name,'');
		p_attribute_type_name := NULLIF(p_attribute_type_name,'');
		p_value := NULLIF(p_value,'');
		UPDATE cube_dsc.v_cube_description SET
			value = p_value
		WHERE type_name = p_type_name
		  AND attribute_type_name = p_attribute_type_name
		  AND sequence = p_sequence;
	END;
$BODY$;

CREATE PROCEDURE cube_dsc.delete_cube_dsc (
			p_type_name IN VARCHAR,
			p_attribute_type_name IN VARCHAR,
			p_sequence IN NUMERIC)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_type_name := NULLIF(p_type_name,'');
		p_attribute_type_name := NULLIF(p_attribute_type_name,'');
		DELETE FROM cube_dsc.v_cube_description
		WHERE type_name = p_type_name
		  AND attribute_type_name = p_attribute_type_name
		  AND sequence = p_sequence;
	END;
$BODY$;
\q
