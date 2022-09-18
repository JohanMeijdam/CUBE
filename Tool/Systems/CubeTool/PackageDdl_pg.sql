-- CUBETOOL Stored procedures
--
DO $BODY$
	DECLARE
		rec_nspname RECORD;
	BEGIN
		FOR rec_nspname IN 
			SELECT nspname 
			FROM pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE nspowner = usesysid
			  AND usename = 'JohanM'
			  AND nspname = 'cube'
		LOOP
			EXECUTE 'DROP SCHEMA ' || rec_nspname.nspname || ' CASCADE';
		END LOOP;
	END;
$BODY$;

CREATE SCHEMA cube;

CREATE FUNCTION cube.years(p_date DATE) RETURNS NUMERIC
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		RETURN DATE_PART('YEAR',AGE(CURRENT_TIMESTAMP, p_date));
	END;
$BODY$;

CREATE FUNCTION cube.multiply(p_num_1 NUMERIC, p_num_2 NUMERIC) RETURNS NUMERIC
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		RETURN p_num_1 * p_num_2;
	END;
$BODY$;

CREATE FUNCTION cube.add(p_num_1 NUMERIC, p_num_2 NUMERIC) RETURNS NUMERIC
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		RETURN p_num_1 + p_num_2;
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
			  AND usename = 'JohanM'
			  AND nspname = 'itp'
			  AND proname NOT LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE itp.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION itp.' || rec_proc.proname;
			END CASE;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE itp.get_itp_root_items ()
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		OPEN l_cube_cursor FOR
			SELECT
			  name
			FROM itp.v_information_type
			ORDER BY name;
	END;
$BODY$;

CREATE PROCEDURE itp.get_itp_list ()
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		OPEN l_cube_cursor FOR
			SELECT
			  name
			FROM itp.v_information_type
			ORDER BY name;
	END;
$BODY$;

CREATE PROCEDURE itp.get_itp_ite_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_itp_name,
			  sequence,
			  suffix,
			  domain
			FROM itp.v_information_type_element
			WHERE fk_itp_name = p_name
			ORDER BY fk_itp_name, sequence, suffix, domain;
	END;
$BODY$;

CREATE PROCEDURE itp.get_next_itp (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  name
			FROM itp.v_information_type
			WHERE name > p_name
			ORDER BY name;
	END;
$BODY$;

CREATE PROCEDURE itp.insert_itp (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		INSERT INTO itp.v_information_type (
			cube_id,
			name)
		VALUES (
			NULL,
			p_name);

		CALL itp.get_next_itp (p_name);
	EXCEPTION
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type information_type already exists';
	END;
$BODY$;

CREATE PROCEDURE itp.delete_itp (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_name := NULLIF(p_name,'');
		DELETE FROM itp.v_information_type
		WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE itp.get_ite (
			p_fk_itp_name IN VARCHAR,
			p_sequence IN NUMERIC)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_sequence := NULLIF(p_sequence,'');
		OPEN l_cube_cursor FOR
			SELECT
			  suffix,
			  domain,
			  length,
			  decimals,
			  case_sensitive,
			  default_value,
			  spaces_allowed,
			  presentation
			FROM itp.v_information_type_element
			WHERE fk_itp_name = p_fk_itp_name
			  AND sequence = p_sequence;
	END;
$BODY$;

CREATE PROCEDURE itp.get_ite_val_items (
			p_fk_itp_name IN VARCHAR,
			p_sequence IN NUMERIC)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_sequence := NULLIF(p_sequence,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_itp_name,
			  fk_ite_sequence,
			  code,
			  prompt
			FROM itp.v_permitted_value
			WHERE fk_itp_name = p_fk_itp_name
			  AND fk_ite_sequence = p_sequence
			ORDER BY fk_itp_name, fk_ite_sequence, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE itp.get_next_ite (
			p_fk_itp_name IN VARCHAR,
			p_sequence IN NUMERIC)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_sequence := NULLIF(p_sequence,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_itp_name,
			  sequence
			FROM itp.v_information_type_element
			WHERE fk_itp_name > p_fk_itp_name
			   OR 	    ( fk_itp_name = p_fk_itp_name
				  AND sequence > p_sequence )
			ORDER BY fk_itp_name, sequence;
	END;
$BODY$;

CREATE PROCEDURE itp.insert_ite (
			p_fk_itp_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_suffix IN VARCHAR,
			p_domain IN VARCHAR,
			p_length IN NUMERIC,
			p_decimals IN NUMERIC,
			p_case_sensitive IN VARCHAR,
			p_default_value IN VARCHAR,
			p_spaces_allowed IN VARCHAR,
			p_presentation IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_suffix := NULLIF(p_suffix,'');
		p_domain := NULLIF(p_domain,'');
		p_length := NULLIF(p_length,'');
		p_decimals := NULLIF(p_decimals,'');
		p_case_sensitive := NULLIF(p_case_sensitive,'');
		p_default_value := NULLIF(p_default_value,'');
		p_spaces_allowed := NULLIF(p_spaces_allowed,'');
		p_presentation := NULLIF(p_presentation,'');
		INSERT INTO itp.v_information_type_element (
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

		CALL itp.get_next_ite (p_fk_itp_name, p_sequence);
	EXCEPTION
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type information_type_element already exists';
	END;
$BODY$;

CREATE PROCEDURE itp.update_ite (
			p_fk_itp_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_suffix IN VARCHAR,
			p_domain IN VARCHAR,
			p_length IN NUMERIC,
			p_decimals IN NUMERIC,
			p_case_sensitive IN VARCHAR,
			p_default_value IN VARCHAR,
			p_spaces_allowed IN VARCHAR,
			p_presentation IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_suffix := NULLIF(p_suffix,'');
		p_domain := NULLIF(p_domain,'');
		p_length := NULLIF(p_length,'');
		p_decimals := NULLIF(p_decimals,'');
		p_case_sensitive := NULLIF(p_case_sensitive,'');
		p_default_value := NULLIF(p_default_value,'');
		p_spaces_allowed := NULLIF(p_spaces_allowed,'');
		p_presentation := NULLIF(p_presentation,'');
		UPDATE itp.v_information_type_element SET
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
$BODY$;

CREATE PROCEDURE itp.delete_ite (
			p_fk_itp_name IN VARCHAR,
			p_sequence IN NUMERIC)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_sequence := NULLIF(p_sequence,'');
		DELETE FROM itp.v_information_type_element
		WHERE fk_itp_name = p_fk_itp_name
		  AND sequence = p_sequence;
	END;
$BODY$;

CREATE PROCEDURE itp.get_val (
			p_fk_itp_name IN VARCHAR,
			p_fk_ite_sequence IN NUMERIC,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_fk_ite_sequence := NULLIF(p_fk_ite_sequence,'');
		p_code := NULLIF(p_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  prompt
			FROM itp.v_permitted_value
			WHERE fk_itp_name = p_fk_itp_name
			  AND fk_ite_sequence = p_fk_ite_sequence
			  AND code = p_code;
	END;
$BODY$;

CREATE PROCEDURE itp.determine_position_val (
			p_cube_sequence INOUT NUMERIC,
			p_cube_pos_action IN VARCHAR,
			p_fk_itp_name IN VARCHAR,
			p_fk_ite_sequence IN NUMERIC,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_pos_action VARCHAR(1);
		l_cube_position_sequ NUMERIC(8);
		l_cube_near_sequ NUMERIC(8);
		l_cube_count NUMERIC(8) := 1024;
		r_val RECORD;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_fk_ite_sequence := NULLIF(p_fk_ite_sequence,'');
		p_code := NULLIF(p_code,'');
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
			IF p_cube_pos_action IN  ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT COALESCE (MAX (cube_sequence), CASE p_cube_pos_action WHEN 'B' THEN 99999999 ELSE 0 END)
				INTO l_cube_position_sequ
				FROM itp.v_permitted_value
				WHERE fk_itp_name = p_fk_itp_name
				  AND fk_ite_sequence = p_fk_ite_sequence
				  AND code = p_code;
			END IF;
			-- read sequence number near the target.
			SELECT CASE l_cube_pos_action WHEN 'B' THEN COALESCE (MAX (cube_sequence), 0) ELSE COALESCE (MIN (cube_sequence), 99999999) END
			INTO l_cube_near_sequ
			FROM itp.v_permitted_value
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
				FOR r_val IN 
					SELECT
					  rowid row_id
					FROM itp.v_permitted_value
					WHERE fk_itp_name = p_fk_itp_name
					  AND fk_ite_sequence = p_fk_ite_sequence
					ORDER BY cube_sequence
				LOOP
					UPDATE itp.v_permitted_value SET
						cube_sequence = l_cube_count
					WHERE rowid = r_val.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE itp.move_val (
			p_cube_pos_action IN VARCHAR,
			p_fk_itp_name IN VARCHAR,
			p_fk_ite_sequence IN NUMERIC,
			p_code IN VARCHAR,
			x_fk_itp_name IN VARCHAR,
			x_fk_ite_sequence IN NUMERIC,
			x_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_fk_ite_sequence := NULLIF(p_fk_ite_sequence,'');
		p_code := NULLIF(p_code,'');
		x_fk_itp_name := NULLIF(x_fk_itp_name,'');
		x_fk_ite_sequence := NULLIF(x_fk_ite_sequence,'');
		x_code := NULLIF(x_code,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL itp.determine_position_val  (l_cube_sequence, p_cube_pos_action, x_fk_itp_name, x_fk_ite_sequence, x_code);
		UPDATE itp.v_permitted_value SET
			cube_sequence = l_cube_sequence
		WHERE fk_itp_name = p_fk_itp_name
		  AND fk_ite_sequence = p_fk_ite_sequence
		  AND code = p_code;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type permitted_value not found';
		END IF;
	END;
$BODY$;

CREATE PROCEDURE itp.insert_val (
			p_cube_pos_action IN VARCHAR,
			p_fk_itp_name IN VARCHAR,
			p_fk_ite_sequence IN NUMERIC,
			p_code IN VARCHAR,
			p_prompt IN VARCHAR,
			x_fk_itp_name IN VARCHAR,
			x_fk_ite_sequence IN NUMERIC,
			x_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_fk_ite_sequence := NULLIF(p_fk_ite_sequence,'');
		p_code := NULLIF(p_code,'');
		p_prompt := NULLIF(p_prompt,'');
		x_fk_itp_name := NULLIF(x_fk_itp_name,'');
		x_fk_ite_sequence := NULLIF(x_fk_ite_sequence,'');
		x_code := NULLIF(x_code,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL itp.determine_position_val  (l_cube_sequence, p_cube_pos_action, x_fk_itp_name, x_fk_ite_sequence, x_code);
		INSERT INTO itp.v_permitted_value (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type permitted_value already exists';
	END;
$BODY$;

CREATE PROCEDURE itp.update_val (
			p_fk_itp_name IN VARCHAR,
			p_fk_ite_sequence IN NUMERIC,
			p_code IN VARCHAR,
			p_prompt IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_fk_ite_sequence := NULLIF(p_fk_ite_sequence,'');
		p_code := NULLIF(p_code,'');
		p_prompt := NULLIF(p_prompt,'');
		UPDATE itp.v_permitted_value SET
			prompt = p_prompt
		WHERE fk_itp_name = p_fk_itp_name
		  AND fk_ite_sequence = p_fk_ite_sequence
		  AND code = p_code;
	END;
$BODY$;

CREATE PROCEDURE itp.delete_val (
			p_fk_itp_name IN VARCHAR,
			p_fk_ite_sequence IN NUMERIC,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_itp_name := NULLIF(p_fk_itp_name,'');
		p_fk_ite_sequence := NULLIF(p_fk_ite_sequence,'');
		p_code := NULLIF(p_code,'');
		DELETE FROM itp.v_permitted_value
		WHERE fk_itp_name = p_fk_itp_name
		  AND fk_ite_sequence = p_fk_ite_sequence
		  AND code = p_code;
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
			  AND usename = 'JohanM'
			  AND nspname = 'bot'
			  AND proname NOT LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE bot.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION bot.' || rec_proc.proname;
			END CASE;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.get_bot_root_items ()
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  name,
			  cube_tsg_type
			FROM bot.v_business_object_type
			ORDER BY cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_bot_list ()
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  name,
			  cube_tsg_type
			FROM bot.v_business_object_type
			ORDER BY cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_bot (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_tsg_type,
			  directory,
			  api_url
			FROM bot.v_business_object_type
			WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_bot_typ_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  name,
			  code
			FROM bot.v_type
			WHERE fk_bot_name = p_name
			  AND fk_typ_name IS NULL
			ORDER BY cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.count_bot_typ (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  COUNT(1) type_count
			FROM bot.v_type
			WHERE fk_bot_name = p_name
			  AND fk_typ_name IS NULL;
	END;
$BODY$;

CREATE PROCEDURE bot.determine_position_bot (
			p_cube_sequence INOUT NUMERIC,
			p_cube_pos_action IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_pos_action VARCHAR(1);
		l_cube_position_sequ NUMERIC(8);
		l_cube_near_sequ NUMERIC(8);
		l_cube_count NUMERIC(8) := 1024;
		r_bot RECORD;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_name := NULLIF(p_name,'');
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
			IF p_cube_pos_action IN  ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT COALESCE (MAX (cube_sequence), CASE p_cube_pos_action WHEN 'B' THEN 99999999 ELSE 0 END)
				INTO l_cube_position_sequ
				FROM bot.v_business_object_type
				WHERE name = p_name;
			END IF;
			-- read sequence number near the target.
			SELECT CASE l_cube_pos_action WHEN 'B' THEN COALESCE (MAX (cube_sequence), 0) ELSE COALESCE (MIN (cube_sequence), 99999999) END
			INTO l_cube_near_sequ
			FROM bot.v_business_object_type
			WHERE 	    ( l_cube_pos_action = 'B'
				  AND cube_sequence < l_cube_position_sequ )
			   OR 	    ( l_cube_pos_action = 'A'
				  AND cube_sequence > l_cube_position_sequ );
			IF ABS (l_cube_position_sequ - l_cube_near_sequ) > 1 THEN
				p_cube_sequence := l_cube_position_sequ - (l_cube_position_sequ - l_cube_near_sequ) / 2; -- Formula both directions OK.
				EXIT;
			ELSE
				-- renumber.
				FOR r_bot IN 
					SELECT
					  rowid row_id
					FROM bot.v_business_object_type
					ORDER BY cube_sequence
				LOOP
					UPDATE bot.v_business_object_type SET
						cube_sequence = l_cube_count
					WHERE rowid = r_bot.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.move_bot (
			p_cube_pos_action IN VARCHAR,
			p_name IN VARCHAR,
			x_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_name := NULLIF(p_name,'');
		x_name := NULLIF(x_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_bot  (l_cube_sequence, p_cube_pos_action, x_name);
		UPDATE bot.v_business_object_type SET
			cube_sequence = l_cube_sequence
		WHERE name = p_name;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type business_object_type not found';
		END IF;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_bot (
			p_cube_pos_action IN VARCHAR,
			p_name IN VARCHAR,
			p_cube_tsg_type IN VARCHAR,
			p_directory IN VARCHAR,
			p_api_url IN VARCHAR,
			x_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_name := NULLIF(p_name,'');
		p_cube_tsg_type := NULLIF(p_cube_tsg_type,'');
		p_directory := NULLIF(p_directory,'');
		p_api_url := NULLIF(p_api_url,'');
		x_name := NULLIF(x_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_bot  (l_cube_sequence, p_cube_pos_action, x_name);
		INSERT INTO bot.v_business_object_type (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type business_object_type already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_bot (
			p_name IN VARCHAR,
			p_cube_tsg_type IN VARCHAR,
			p_directory IN VARCHAR,
			p_api_url IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_name := NULLIF(p_name,'');
		p_cube_tsg_type := NULLIF(p_cube_tsg_type,'');
		p_directory := NULLIF(p_directory,'');
		p_api_url := NULLIF(p_api_url,'');
		UPDATE bot.v_business_object_type SET
			cube_tsg_type = p_cube_tsg_type,
			directory = p_directory,
			api_url = p_api_url
		WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.delete_bot (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_name := NULLIF(p_name,'');
		DELETE FROM bot.v_business_object_type
		WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_list_all ()
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  name,
			  code
			FROM bot.v_type
			ORDER BY cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_for_bot_list_all (
			x_fk_bot_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		x_fk_bot_name := NULLIF(x_fk_bot_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  name,
			  code
			FROM bot.v_type
			WHERE fk_bot_name = x_fk_bot_name
			ORDER BY cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_for_typ_list_all (
			p_cube_scope_level IN NUMERIC,
			x_fk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
		l_cube_scope_level NUMERIC(1) := 0;
		l_name bot.v_type.name%TYPE;
	BEGIN
		p_cube_scope_level := NULLIF(p_cube_scope_level,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		l_name := x_fk_typ_name;
		IF p_cube_scope_level > 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level + 1;
				SELECT fk_typ_name
				INTO l_name
				FROM bot.v_type
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
				FROM bot.v_type
				WHERE fk_typ_name = l_name;
			END LOOP;
		END IF;
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  name,
			  code
			FROM bot.v_type
			WHERE fk_typ_name = l_name
			ORDER BY cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
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
			FROM bot.v_type
			WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_fkey (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name
			FROM bot.v_type
			WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_tsg_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  code,
			  name
			FROM bot.v_type_specialisation_group
			WHERE fk_typ_name = p_name
			  AND fk_tsg_code IS NULL
			ORDER BY fk_typ_name, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_atb_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  name
			FROM bot.v_attribute
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_ref_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  name,
			  sequence,
			  cube_tsg_int_ext,
			  xk_bot_name,
			  xk_typ_name
			FROM bot.v_reference
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_rtt_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM bot.v_restriction_type_spec_typ
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_jsn_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
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
			FROM bot.v_json_path
			WHERE fk_typ_name = p_name
			  AND fk_jsn_name IS NULL
			  AND fk_jsn_location IS NULL
			  AND fk_jsn_atb_typ_name IS NULL
			  AND fk_jsn_atb_name IS NULL
			  AND fk_jsn_typ_name IS NULL
			ORDER BY fk_typ_name, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_dct_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name
			FROM bot.v_description_type
			WHERE fk_typ_name = p_name
			ORDER BY fk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_typ_typ_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  name,
			  code
			FROM bot.v_type
			WHERE fk_typ_name = p_name
			ORDER BY cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.count_typ_jsn (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  COUNT(1) type_count
			FROM bot.v_json_path
			WHERE fk_typ_name = p_name
			  AND fk_jsn_name IS NULL
			  AND fk_jsn_location IS NULL
			  AND fk_jsn_atb_typ_name IS NULL
			  AND fk_jsn_atb_name IS NULL
			  AND fk_jsn_typ_name IS NULL;
	END;
$BODY$;

CREATE PROCEDURE bot.count_typ_dct (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  COUNT(1) type_count
			FROM bot.v_description_type
			WHERE fk_typ_name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.check_no_part_typ (
			p_name IN VARCHAR,
			x_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_name bot.v_type.name%TYPE;
	BEGIN
		p_name := NULLIF(p_name,'');
		x_name := NULLIF(x_name,'');
		l_name := x_name;
		LOOP
			IF l_name IS NULL THEN
				EXIT; -- OK
			END IF;
			IF l_name = p_name THEN
				RAISE EXCEPTION 'Target Type type in hierarchy of moving object';
			END IF;
			SELECT fk_typ_name
			INTO l_name
			FROM bot.v_type
			WHERE name = l_name;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.determine_position_typ (
			p_cube_sequence INOUT NUMERIC,
			p_cube_pos_action IN VARCHAR,
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_pos_action VARCHAR(1);
		l_cube_position_sequ NUMERIC(8);
		l_cube_near_sequ NUMERIC(8);
		l_cube_count NUMERIC(8) := 1024;
		r_typ RECORD;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
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
			IF p_cube_pos_action IN  ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT COALESCE (MAX (cube_sequence), CASE p_cube_pos_action WHEN 'B' THEN 99999999 ELSE 0 END)
				INTO l_cube_position_sequ
				FROM bot.v_type
				WHERE name = p_name;
			END IF;
			-- read sequence number near the target.
			SELECT CASE l_cube_pos_action WHEN 'B' THEN COALESCE (MAX (cube_sequence), 0) ELSE COALESCE (MIN (cube_sequence), 99999999) END
			INTO l_cube_near_sequ
			FROM bot.v_type
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
				FOR r_typ IN 
					SELECT
					  rowid row_id
					FROM bot.v_type
					WHERE fk_bot_name = p_fk_bot_name
					  AND 	    ( 	    ( fk_typ_name IS NULL
							  AND p_fk_typ_name IS NULL )
						   OR fk_typ_name = p_fk_typ_name )
					ORDER BY cube_sequence
				LOOP
					UPDATE bot.v_type SET
						cube_sequence = l_cube_count
					WHERE rowid = r_typ.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.move_typ (
			p_cube_pos_action IN VARCHAR,
			p_name IN VARCHAR,
			x_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
		l_fk_bot_name bot.v_type.fk_bot_name%TYPE;
		l_fk_typ_name bot.v_type.fk_typ_name%TYPE;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_name := NULLIF(p_name,'');
		x_name := NULLIF(x_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN  ('B', 'A') THEN
			SELECT fk_bot_name, fk_typ_name
			INTO l_fk_bot_name, l_fk_typ_name
			FROM bot.v_type
			WHERE name = x_name;
		ELSE
			SELECT fk_bot_name
			INTO l_fk_bot_name
			FROM bot.v_type
			WHERE name = x_name;
			l_fk_typ_name := x_name;
		END IF;
		CALL bot.check_no_part_typ  (p_name, l_fk_typ_name);
		CALL bot.determine_position_typ  (l_cube_sequence, p_cube_pos_action, l_fk_bot_name, l_fk_typ_name, x_name);
		UPDATE bot.v_type SET
			fk_bot_name = l_fk_bot_name,
			fk_typ_name = l_fk_typ_name,
			cube_sequence = l_cube_sequence
		WHERE name = p_name;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type type not found';
		END IF;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_typ (
			p_cube_pos_action IN VARCHAR,
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_code IN VARCHAR,
			p_flag_partial_key IN VARCHAR,
			p_flag_recursive IN VARCHAR,
			p_recursive_cardinality IN VARCHAR,
			p_cardinality IN VARCHAR,
			p_sort_order IN VARCHAR,
			p_icon IN VARCHAR,
			p_transferable IN VARCHAR,
			x_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_code := NULLIF(p_code,'');
		p_flag_partial_key := NULLIF(p_flag_partial_key,'');
		p_flag_recursive := NULLIF(p_flag_recursive,'');
		p_recursive_cardinality := NULLIF(p_recursive_cardinality,'');
		p_cardinality := NULLIF(p_cardinality,'');
		p_sort_order := NULLIF(p_sort_order,'');
		p_icon := NULLIF(p_icon,'');
		p_transferable := NULLIF(p_transferable,'');
		x_name := NULLIF(x_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_typ  (l_cube_sequence, p_cube_pos_action, p_fk_bot_name, p_fk_typ_name, x_name);
		INSERT INTO bot.v_type (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type type already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_typ (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_code IN VARCHAR,
			p_flag_partial_key IN VARCHAR,
			p_flag_recursive IN VARCHAR,
			p_recursive_cardinality IN VARCHAR,
			p_cardinality IN VARCHAR,
			p_sort_order IN VARCHAR,
			p_icon IN VARCHAR,
			p_transferable IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_code := NULLIF(p_code,'');
		p_flag_partial_key := NULLIF(p_flag_partial_key,'');
		p_flag_recursive := NULLIF(p_flag_recursive,'');
		p_recursive_cardinality := NULLIF(p_recursive_cardinality,'');
		p_cardinality := NULLIF(p_cardinality,'');
		p_sort_order := NULLIF(p_sort_order,'');
		p_icon := NULLIF(p_icon,'');
		p_transferable := NULLIF(p_transferable,'');
		UPDATE bot.v_type SET
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
$BODY$;

CREATE PROCEDURE bot.delete_typ (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_name := NULLIF(p_name,'');
		DELETE FROM bot.v_type
		WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_tsg (
			p_fk_typ_name IN VARCHAR,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_code := NULLIF(p_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  fk_tsg_code,
			  name,
			  primary_key,
			  xf_atb_typ_name,
			  xk_atb_name
			FROM bot.v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND code = p_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_tsg_fkey (
			p_fk_typ_name IN VARCHAR,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_code := NULLIF(p_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name
			FROM bot.v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND code = p_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_tsg_tsp_items (
			p_fk_typ_name IN VARCHAR,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_code := NULLIF(p_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  fk_tsg_code,
			  code,
			  name
			FROM bot.v_type_specialisation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_tsg_code = p_code
			ORDER BY fk_typ_name, fk_tsg_code, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_tsg_tsg_items (
			p_fk_typ_name IN VARCHAR,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_code := NULLIF(p_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  code,
			  name
			FROM bot.v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_tsg_code = p_code
			ORDER BY fk_typ_name, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.count_tsg_tsg (
			p_fk_typ_name IN VARCHAR,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_code := NULLIF(p_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  COUNT(1) type_count
			FROM bot.v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_tsg_code = p_code
			  AND fk_tsg_code IS NOT NULL;
	END;
$BODY$;

CREATE PROCEDURE bot.check_no_part_tsg (
			p_fk_typ_name IN VARCHAR,
			p_code IN VARCHAR,
			x_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_code bot.v_type_specialisation_group.code%TYPE;
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_code := NULLIF(p_code,'');
		x_code := NULLIF(x_code,'');
		l_code := x_code;
		LOOP
			IF l_code IS NULL THEN
				EXIT; -- OK
			END IF;
			IF l_code = p_code THEN
				RAISE EXCEPTION 'Target Type type_specialisation_group in hierarchy of moving object';
			END IF;
			SELECT fk_tsg_code
			INTO l_code
			FROM bot.v_type_specialisation_group
			WHERE fk_typ_name = p_fk_typ_name
			  AND code = l_code;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.determine_position_tsg (
			p_cube_sequence INOUT NUMERIC,
			p_cube_pos_action IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_tsg_code IN VARCHAR,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_pos_action VARCHAR(1);
		l_cube_position_sequ NUMERIC(8);
		l_cube_near_sequ NUMERIC(8);
		l_cube_count NUMERIC(8) := 1024;
		r_tsg RECORD;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_tsg_code := NULLIF(p_fk_tsg_code,'');
		p_code := NULLIF(p_code,'');
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
			IF p_cube_pos_action IN  ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT COALESCE (MAX (cube_sequence), CASE p_cube_pos_action WHEN 'B' THEN 99999999 ELSE 0 END)
				INTO l_cube_position_sequ
				FROM bot.v_type_specialisation_group
				WHERE fk_typ_name = p_fk_typ_name
				  AND code = p_code;
			END IF;
			-- read sequence number near the target.
			SELECT CASE l_cube_pos_action WHEN 'B' THEN COALESCE (MAX (cube_sequence), 0) ELSE COALESCE (MIN (cube_sequence), 99999999) END
			INTO l_cube_near_sequ
			FROM bot.v_type_specialisation_group
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
				FOR r_tsg IN 
					SELECT
					  rowid row_id
					FROM bot.v_type_specialisation_group
					WHERE fk_typ_name = p_fk_typ_name
					  AND 	    ( 	    ( fk_tsg_code IS NULL
							  AND p_fk_tsg_code IS NULL )
						   OR fk_tsg_code = p_fk_tsg_code )
					ORDER BY cube_sequence
				LOOP
					UPDATE bot.v_type_specialisation_group SET
						cube_sequence = l_cube_count
					WHERE rowid = r_tsg.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.move_tsg (
			p_cube_pos_action IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_code IN VARCHAR,
			x_fk_typ_name IN VARCHAR,
			x_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
		l_fk_tsg_code bot.v_type_specialisation_group.fk_tsg_code%TYPE;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_code := NULLIF(p_code,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_code := NULLIF(x_code,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN  ('B', 'A') THEN
			SELECT fk_tsg_code
			INTO l_fk_tsg_code
			FROM bot.v_type_specialisation_group
			WHERE fk_typ_name = x_fk_typ_name
			  AND code = x_code;
		ELSE
			l_fk_tsg_code := x_code;
		END IF;
		CALL bot.check_no_part_tsg  (p_fk_typ_name, p_code, l_fk_tsg_code);
		CALL bot.determine_position_tsg  (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, l_fk_tsg_code, x_code);
		UPDATE bot.v_type_specialisation_group SET
			fk_tsg_code = l_fk_tsg_code,
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND code = p_code;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type type_specialisation_group not found';
		END IF;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_tsg (
			p_cube_pos_action IN VARCHAR,
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_tsg_code IN VARCHAR,
			p_code IN VARCHAR,
			p_name IN VARCHAR,
			p_primary_key IN VARCHAR,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR,
			x_fk_typ_name IN VARCHAR,
			x_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_tsg_code := NULLIF(p_fk_tsg_code,'');
		p_code := NULLIF(p_code,'');
		p_name := NULLIF(p_name,'');
		p_primary_key := NULLIF(p_primary_key,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_code := NULLIF(x_code,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_tsg  (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, p_fk_tsg_code, x_code);
		INSERT INTO bot.v_type_specialisation_group (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type type_specialisation_group already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_tsg (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_tsg_code IN VARCHAR,
			p_code IN VARCHAR,
			p_name IN VARCHAR,
			p_primary_key IN VARCHAR,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_tsg_code := NULLIF(p_fk_tsg_code,'');
		p_code := NULLIF(p_code,'');
		p_name := NULLIF(p_name,'');
		p_primary_key := NULLIF(p_primary_key,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		UPDATE bot.v_type_specialisation_group SET
			fk_bot_name = p_fk_bot_name,
			fk_tsg_code = p_fk_tsg_code,
			name = p_name,
			primary_key = p_primary_key,
			xf_atb_typ_name = p_xf_atb_typ_name,
			xk_atb_name = p_xk_atb_name
		WHERE fk_typ_name = p_fk_typ_name
		  AND code = p_code;
	END;
$BODY$;

CREATE PROCEDURE bot.delete_tsg (
			p_fk_typ_name IN VARCHAR,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_code := NULLIF(p_code,'');
		DELETE FROM bot.v_type_specialisation_group
		WHERE fk_typ_name = p_fk_typ_name
		  AND code = p_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_tsp_for_typ_list (
			p_cube_scope_level IN NUMERIC,
			x_fk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
		l_cube_scope_level NUMERIC(1) := 0;
		l_name bot.v_type.name%TYPE;
	BEGIN
		p_cube_scope_level := NULLIF(p_cube_scope_level,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		l_name := x_fk_typ_name;
		IF p_cube_scope_level > 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level + 1;
				SELECT fk_typ_name
				INTO l_name
				FROM bot.v_type
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
				FROM bot.v_type
				WHERE fk_typ_name = l_name;
			END LOOP;
		END IF;
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  fk_tsg_code,
			  code,
			  name
			FROM bot.v_type_specialisation
			WHERE fk_typ_name = l_name
			ORDER BY fk_typ_name, fk_tsg_code, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_tsp_for_tsg_list (
			p_cube_scope_level IN NUMERIC,
			x_fk_typ_name IN VARCHAR,
			x_fk_tsg_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
		l_cube_scope_level NUMERIC(1) := 0;
		l_code bot.v_type_specialisation_group.code%TYPE;
	BEGIN
		p_cube_scope_level := NULLIF(p_cube_scope_level,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_fk_tsg_code := NULLIF(x_fk_tsg_code,'');
		l_code := x_fk_tsg_code;
		IF p_cube_scope_level > 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level + 1;
				SELECT fk_tsg_code
				INTO l_code
				FROM bot.v_type_specialisation_group
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
				FROM bot.v_type_specialisation_group
				WHERE fk_tsg_code = l_code
				  AND fk_typ_name = x_fk_typ_name;
			END LOOP;
		END IF;
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  fk_tsg_code,
			  code,
			  name
			FROM bot.v_type_specialisation
			WHERE fk_typ_name = x_fk_typ_name
			  AND fk_tsg_code = l_code
			ORDER BY fk_typ_name, fk_tsg_code, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_tsp (
			p_fk_typ_name IN VARCHAR,
			p_fk_tsg_code IN VARCHAR,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_tsg_code := NULLIF(p_fk_tsg_code,'');
		p_code := NULLIF(p_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM bot.v_type_specialisation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_tsg_code = p_fk_tsg_code
			  AND code = p_code;
	END;
$BODY$;

CREATE PROCEDURE bot.determine_position_tsp (
			p_cube_sequence INOUT NUMERIC,
			p_cube_pos_action IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_tsg_code IN VARCHAR,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_pos_action VARCHAR(1);
		l_cube_position_sequ NUMERIC(8);
		l_cube_near_sequ NUMERIC(8);
		l_cube_count NUMERIC(8) := 1024;
		r_tsp RECORD;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_tsg_code := NULLIF(p_fk_tsg_code,'');
		p_code := NULLIF(p_code,'');
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
			IF p_cube_pos_action IN  ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT COALESCE (MAX (cube_sequence), CASE p_cube_pos_action WHEN 'B' THEN 99999999 ELSE 0 END)
				INTO l_cube_position_sequ
				FROM bot.v_type_specialisation
				WHERE fk_typ_name = p_fk_typ_name
				  AND fk_tsg_code = p_fk_tsg_code
				  AND code = p_code;
			END IF;
			-- read sequence number near the target.
			SELECT CASE l_cube_pos_action WHEN 'B' THEN COALESCE (MAX (cube_sequence), 0) ELSE COALESCE (MIN (cube_sequence), 99999999) END
			INTO l_cube_near_sequ
			FROM bot.v_type_specialisation
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
				FOR r_tsp IN 
					SELECT
					  rowid row_id
					FROM bot.v_type_specialisation
					WHERE fk_typ_name = p_fk_typ_name
					  AND fk_tsg_code = p_fk_tsg_code
					ORDER BY cube_sequence
				LOOP
					UPDATE bot.v_type_specialisation SET
						cube_sequence = l_cube_count
					WHERE rowid = r_tsp.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.move_tsp (
			p_cube_pos_action IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_tsg_code IN VARCHAR,
			p_code IN VARCHAR,
			x_fk_typ_name IN VARCHAR,
			x_fk_tsg_code IN VARCHAR,
			x_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_tsg_code := NULLIF(p_fk_tsg_code,'');
		p_code := NULLIF(p_code,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_fk_tsg_code := NULLIF(x_fk_tsg_code,'');
		x_code := NULLIF(x_code,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_tsp  (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_fk_tsg_code, x_code);
		UPDATE bot.v_type_specialisation SET
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_tsg_code = p_fk_tsg_code
		  AND code = p_code;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type type_specialisation not found';
		END IF;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_tsp (
			p_cube_pos_action IN VARCHAR,
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_tsg_code IN VARCHAR,
			p_code IN VARCHAR,
			p_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR,
			x_fk_typ_name IN VARCHAR,
			x_fk_tsg_code IN VARCHAR,
			x_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_tsg_code := NULLIF(p_fk_tsg_code,'');
		p_code := NULLIF(p_code,'');
		p_name := NULLIF(p_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_fk_tsg_code := NULLIF(x_fk_tsg_code,'');
		x_code := NULLIF(x_code,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_tsp  (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_fk_tsg_code, x_code);
		INSERT INTO bot.v_type_specialisation (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type type_specialisation already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_tsp (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_tsg_code IN VARCHAR,
			p_code IN VARCHAR,
			p_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_tsg_code := NULLIF(p_fk_tsg_code,'');
		p_code := NULLIF(p_code,'');
		p_name := NULLIF(p_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		UPDATE bot.v_type_specialisation SET
			fk_bot_name = p_fk_bot_name,
			name = p_name,
			xf_tsp_typ_name = p_xf_tsp_typ_name,
			xf_tsp_tsg_code = p_xf_tsp_tsg_code,
			xk_tsp_code = p_xk_tsp_code
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_tsg_code = p_fk_tsg_code
		  AND code = p_code;
	END;
$BODY$;

CREATE PROCEDURE bot.delete_tsp (
			p_fk_typ_name IN VARCHAR,
			p_fk_tsg_code IN VARCHAR,
			p_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_tsg_code := NULLIF(p_fk_tsg_code,'');
		p_code := NULLIF(p_code,'');
		DELETE FROM bot.v_type_specialisation
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_tsg_code = p_fk_tsg_code
		  AND code = p_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_atb_for_typ_list (
			p_cube_scope_level IN NUMERIC,
			x_fk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
		l_cube_scope_level NUMERIC(1) := 0;
		l_name bot.v_type.name%TYPE;
	BEGIN
		p_cube_scope_level := NULLIF(p_cube_scope_level,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		l_name := x_fk_typ_name;
		IF p_cube_scope_level > 0 THEN
			LOOP
				IF p_cube_scope_level = l_cube_scope_level THEN
					EXIT;
				END IF;
				l_cube_scope_level := l_cube_scope_level + 1;
				SELECT fk_typ_name
				INTO l_name
				FROM bot.v_type
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
				FROM bot.v_type
				WHERE fk_typ_name = l_name;
			END LOOP;
		END IF;
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_typ_name,
			  name
			FROM bot.v_attribute
			WHERE fk_typ_name = l_name
			ORDER BY fk_typ_name, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.get_atb (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  primary_key,
			  code_display_key,
			  code_foreign_key,
			  flag_hidden,
			  default_value,
			  unchangeable,
			  xk_itp_name
			FROM bot.v_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_atb_fkey (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name
			FROM bot.v_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_atb_der_items (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name,
			  fk_atb_name,
			  cube_tsg_type
			FROM bot.v_derivation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name
			ORDER BY fk_typ_name, fk_atb_name, cube_tsg_type;
	END;
$BODY$;

CREATE PROCEDURE bot.get_atb_dca_items (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name,
			  fk_atb_name
			FROM bot.v_description_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name
			ORDER BY fk_typ_name, fk_atb_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_atb_rta_items (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name,
			  fk_atb_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM bot.v_restriction_type_spec_atb
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name
			ORDER BY fk_typ_name, fk_atb_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.count_atb_der (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  COUNT(1) type_count
			FROM bot.v_derivation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.count_atb_dca (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  COUNT(1) type_count
			FROM bot.v_description_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.determine_position_atb (
			p_cube_sequence INOUT NUMERIC,
			p_cube_pos_action IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_pos_action VARCHAR(1);
		l_cube_position_sequ NUMERIC(8);
		l_cube_near_sequ NUMERIC(8);
		l_cube_count NUMERIC(8) := 1024;
		r_atb RECORD;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
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
			IF p_cube_pos_action IN  ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT COALESCE (MAX (cube_sequence), CASE p_cube_pos_action WHEN 'B' THEN 99999999 ELSE 0 END)
				INTO l_cube_position_sequ
				FROM bot.v_attribute
				WHERE fk_typ_name = p_fk_typ_name
				  AND name = p_name;
			END IF;
			-- read sequence number near the target.
			SELECT CASE l_cube_pos_action WHEN 'B' THEN COALESCE (MAX (cube_sequence), 0) ELSE COALESCE (MIN (cube_sequence), 99999999) END
			INTO l_cube_near_sequ
			FROM bot.v_attribute
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
				FOR r_atb IN 
					SELECT
					  rowid row_id
					FROM bot.v_attribute
					WHERE fk_typ_name = p_fk_typ_name
					ORDER BY cube_sequence
				LOOP
					UPDATE bot.v_attribute SET
						cube_sequence = l_cube_count
					WHERE rowid = r_atb.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.move_atb (
			p_cube_pos_action IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			x_fk_typ_name IN VARCHAR,
			x_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_name := NULLIF(x_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_atb  (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_name);
		UPDATE bot.v_attribute SET
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type attribute not found';
		END IF;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_atb (
			p_cube_pos_action IN VARCHAR,
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_primary_key IN VARCHAR,
			p_code_display_key IN VARCHAR,
			p_code_foreign_key IN VARCHAR,
			p_flag_hidden IN VARCHAR,
			p_default_value IN VARCHAR,
			p_unchangeable IN VARCHAR,
			p_xk_itp_name IN VARCHAR,
			x_fk_typ_name IN VARCHAR,
			x_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_primary_key := NULLIF(p_primary_key,'');
		p_code_display_key := NULLIF(p_code_display_key,'');
		p_code_foreign_key := NULLIF(p_code_foreign_key,'');
		p_flag_hidden := NULLIF(p_flag_hidden,'');
		p_default_value := NULLIF(p_default_value,'');
		p_unchangeable := NULLIF(p_unchangeable,'');
		p_xk_itp_name := NULLIF(p_xk_itp_name,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_name := NULLIF(x_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_atb  (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_name);
		INSERT INTO bot.v_attribute (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type attribute already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_atb (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_primary_key IN VARCHAR,
			p_code_display_key IN VARCHAR,
			p_code_foreign_key IN VARCHAR,
			p_flag_hidden IN VARCHAR,
			p_default_value IN VARCHAR,
			p_unchangeable IN VARCHAR,
			p_xk_itp_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_primary_key := NULLIF(p_primary_key,'');
		p_code_display_key := NULLIF(p_code_display_key,'');
		p_code_foreign_key := NULLIF(p_code_foreign_key,'');
		p_flag_hidden := NULLIF(p_flag_hidden,'');
		p_default_value := NULLIF(p_default_value,'');
		p_unchangeable := NULLIF(p_unchangeable,'');
		p_xk_itp_name := NULLIF(p_xk_itp_name,'');
		UPDATE bot.v_attribute SET
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
$BODY$;

CREATE PROCEDURE bot.delete_atb (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		DELETE FROM bot.v_attribute
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_der (
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  cube_tsg_type,
			  aggregate_function,
			  xk_typ_name,
			  xk_typ_name_1
			FROM bot.v_derivation
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_fk_atb_name;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_der (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR,
			p_cube_tsg_type IN VARCHAR,
			p_aggregate_function IN VARCHAR,
			p_xk_typ_name IN VARCHAR,
			p_xk_typ_name_1 IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		p_cube_tsg_type := NULLIF(p_cube_tsg_type,'');
		p_aggregate_function := NULLIF(p_aggregate_function,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		p_xk_typ_name_1 := NULLIF(p_xk_typ_name_1,'');
		INSERT INTO bot.v_derivation (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type derivation already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_der (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR,
			p_cube_tsg_type IN VARCHAR,
			p_aggregate_function IN VARCHAR,
			p_xk_typ_name IN VARCHAR,
			p_xk_typ_name_1 IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		p_cube_tsg_type := NULLIF(p_cube_tsg_type,'');
		p_aggregate_function := NULLIF(p_aggregate_function,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		p_xk_typ_name_1 := NULLIF(p_xk_typ_name_1,'');
		UPDATE bot.v_derivation SET
			fk_bot_name = p_fk_bot_name,
			cube_tsg_type = p_cube_tsg_type,
			aggregate_function = p_aggregate_function,
			xk_typ_name = p_xk_typ_name,
			xk_typ_name_1 = p_xk_typ_name_1
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name;
	END;
$BODY$;

CREATE PROCEDURE bot.delete_der (
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		DELETE FROM bot.v_derivation
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_dca (
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  text
			FROM bot.v_description_attribute
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_fk_atb_name;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_dca (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR,
			p_text IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		p_text := NULLIF(p_text,'');
		INSERT INTO bot.v_description_attribute (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type description_attribute already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_dca (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR,
			p_text IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		p_text := NULLIF(p_text,'');
		UPDATE bot.v_description_attribute SET
			fk_bot_name = p_fk_bot_name,
			text = p_text
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name;
	END;
$BODY$;

CREATE PROCEDURE bot.delete_dca (
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		DELETE FROM bot.v_description_attribute
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_rta (
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  include_or_exclude
			FROM bot.v_restriction_type_spec_atb
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_atb_name = p_fk_atb_name
			  AND xf_tsp_typ_name = p_xf_tsp_typ_name
			  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
			  AND xk_tsp_code = p_xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_next_rta (
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name,
			  fk_atb_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM bot.v_restriction_type_spec_atb
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
$BODY$;

CREATE PROCEDURE bot.insert_rta (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR,
			p_include_or_exclude IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		p_include_or_exclude := NULLIF(p_include_or_exclude,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		INSERT INTO bot.v_restriction_type_spec_atb (
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

		CALL bot.get_next_rta (p_fk_typ_name, p_fk_atb_name, p_xf_tsp_typ_name, p_xf_tsp_tsg_code, p_xk_tsp_code);
	EXCEPTION
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type restriction_type_spec_atb already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_rta (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR,
			p_include_or_exclude IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		p_include_or_exclude := NULLIF(p_include_or_exclude,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		UPDATE bot.v_restriction_type_spec_atb SET
			fk_bot_name = p_fk_bot_name,
			include_or_exclude = p_include_or_exclude
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.delete_rta (
			p_fk_typ_name IN VARCHAR,
			p_fk_atb_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_atb_name := NULLIF(p_fk_atb_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		DELETE FROM bot.v_restriction_type_spec_atb
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_atb_name = p_fk_atb_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_ref (
			p_fk_typ_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		OPEN l_cube_cursor FOR
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
			FROM bot.v_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND sequence = p_sequence
			  AND xk_bot_name = p_xk_bot_name
			  AND xk_typ_name = p_xk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_ref_fkey (
			p_fk_typ_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name
			FROM bot.v_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND sequence = p_sequence
			  AND xk_bot_name = p_xk_bot_name
			  AND xk_typ_name = p_xk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_ref_dcr_items (
			p_fk_typ_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
			  fk_ref_bot_name,
			  fk_ref_typ_name
			FROM bot.v_description_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_bot_name = p_xk_bot_name
			  AND fk_ref_typ_name = p_xk_typ_name
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_ref_rtr_items (
			p_fk_typ_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
			  fk_ref_bot_name,
			  fk_ref_typ_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM bot.v_restriction_type_spec_ref
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_bot_name = p_xk_bot_name
			  AND fk_ref_typ_name = p_xk_typ_name
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_ref_rts_items (
			p_fk_typ_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
			  fk_ref_bot_name,
			  fk_ref_typ_name,
			  include_or_exclude,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM bot.v_restriction_target_type_spec
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_bot_name = p_xk_bot_name
			  AND fk_ref_typ_name = p_xk_typ_name
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, include_or_exclude, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.count_ref_dcr (
			p_fk_typ_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  COUNT(1) type_count
			FROM bot.v_description_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_bot_name = p_xk_bot_name
			  AND fk_ref_typ_name = p_xk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.count_ref_rts (
			p_fk_typ_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  COUNT(1) type_count
			FROM bot.v_restriction_target_type_spec
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_sequence
			  AND fk_ref_bot_name = p_xk_bot_name
			  AND fk_ref_typ_name = p_xk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.determine_position_ref (
			p_cube_sequence INOUT NUMERIC,
			p_cube_pos_action IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_pos_action VARCHAR(1);
		l_cube_position_sequ NUMERIC(8);
		l_cube_near_sequ NUMERIC(8);
		l_cube_count NUMERIC(8) := 1024;
		r_ref RECORD;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
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
			IF p_cube_pos_action IN  ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT COALESCE (MAX (cube_sequence), CASE p_cube_pos_action WHEN 'B' THEN 99999999 ELSE 0 END)
				INTO l_cube_position_sequ
				FROM bot.v_reference
				WHERE fk_typ_name = p_fk_typ_name
				  AND sequence = p_sequence
				  AND xk_bot_name = p_xk_bot_name
				  AND xk_typ_name = p_xk_typ_name;
			END IF;
			-- read sequence number near the target.
			SELECT CASE l_cube_pos_action WHEN 'B' THEN COALESCE (MAX (cube_sequence), 0) ELSE COALESCE (MIN (cube_sequence), 99999999) END
			INTO l_cube_near_sequ
			FROM bot.v_reference
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
				FOR r_ref IN 
					SELECT
					  rowid row_id
					FROM bot.v_reference
					WHERE fk_typ_name = p_fk_typ_name
					ORDER BY cube_sequence
				LOOP
					UPDATE bot.v_reference SET
						cube_sequence = l_cube_count
					WHERE rowid = r_ref.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.move_ref (
			p_cube_pos_action IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR,
			x_fk_typ_name IN VARCHAR,
			x_sequence IN NUMERIC,
			x_xk_bot_name IN VARCHAR,
			x_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_sequence := NULLIF(x_sequence,'');
		x_xk_bot_name := NULLIF(x_xk_bot_name,'');
		x_xk_typ_name := NULLIF(x_xk_typ_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_ref  (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_sequence, x_xk_bot_name, x_xk_typ_name);
		UPDATE bot.v_reference SET
			cube_sequence = l_cube_sequence
		WHERE fk_typ_name = p_fk_typ_name
		  AND sequence = p_sequence
		  AND xk_bot_name = p_xk_bot_name
		  AND xk_typ_name = p_xk_typ_name;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type reference not found';
		END IF;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_ref (
			p_cube_pos_action IN VARCHAR,
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_primary_key IN VARCHAR,
			p_code_display_key IN VARCHAR,
			p_sequence IN NUMERIC,
			p_scope IN VARCHAR,
			p_unchangeable IN VARCHAR,
			p_within_scope_extension IN VARCHAR,
			p_cube_tsg_int_ext IN VARCHAR,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR,
			p_xk_typ_name_1 IN VARCHAR,
			x_fk_typ_name IN VARCHAR,
			x_sequence IN NUMERIC,
			x_xk_bot_name IN VARCHAR,
			x_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_primary_key := NULLIF(p_primary_key,'');
		p_code_display_key := NULLIF(p_code_display_key,'');
		p_sequence := NULLIF(p_sequence,'');
		p_scope := NULLIF(p_scope,'');
		p_unchangeable := NULLIF(p_unchangeable,'');
		p_within_scope_extension := NULLIF(p_within_scope_extension,'');
		p_cube_tsg_int_ext := NULLIF(p_cube_tsg_int_ext,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		p_xk_typ_name_1 := NULLIF(p_xk_typ_name_1,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_sequence := NULLIF(x_sequence,'');
		x_xk_bot_name := NULLIF(x_xk_bot_name,'');
		x_xk_typ_name := NULLIF(x_xk_typ_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_ref  (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, x_sequence, x_xk_bot_name, x_xk_typ_name);
		INSERT INTO bot.v_reference (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type reference already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_ref (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_primary_key IN VARCHAR,
			p_code_display_key IN VARCHAR,
			p_sequence IN NUMERIC,
			p_scope IN VARCHAR,
			p_unchangeable IN VARCHAR,
			p_within_scope_extension IN VARCHAR,
			p_cube_tsg_int_ext IN VARCHAR,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR,
			p_xk_typ_name_1 IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_primary_key := NULLIF(p_primary_key,'');
		p_code_display_key := NULLIF(p_code_display_key,'');
		p_sequence := NULLIF(p_sequence,'');
		p_scope := NULLIF(p_scope,'');
		p_unchangeable := NULLIF(p_unchangeable,'');
		p_within_scope_extension := NULLIF(p_within_scope_extension,'');
		p_cube_tsg_int_ext := NULLIF(p_cube_tsg_int_ext,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		p_xk_typ_name_1 := NULLIF(p_xk_typ_name_1,'');
		UPDATE bot.v_reference SET
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
$BODY$;

CREATE PROCEDURE bot.delete_ref (
			p_fk_typ_name IN VARCHAR,
			p_sequence IN NUMERIC,
			p_xk_bot_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_sequence := NULLIF(p_sequence,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		DELETE FROM bot.v_reference
		WHERE fk_typ_name = p_fk_typ_name
		  AND sequence = p_sequence
		  AND xk_bot_name = p_xk_bot_name
		  AND xk_typ_name = p_xk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_dcr (
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  text
			FROM bot.v_description_reference
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_fk_ref_sequence
			  AND fk_ref_bot_name = p_fk_ref_bot_name
			  AND fk_ref_typ_name = p_fk_ref_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_dcr (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_text IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_text := NULLIF(p_text,'');
		INSERT INTO bot.v_description_reference (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type description_reference already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_dcr (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_text IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_text := NULLIF(p_text,'');
		UPDATE bot.v_description_reference SET
			fk_bot_name = p_fk_bot_name,
			text = p_text
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_bot_name = p_fk_ref_bot_name
		  AND fk_ref_typ_name = p_fk_ref_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.delete_dcr (
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		DELETE FROM bot.v_description_reference
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_bot_name = p_fk_ref_bot_name
		  AND fk_ref_typ_name = p_fk_ref_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_rtr (
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  include_or_exclude
			FROM bot.v_restriction_type_spec_ref
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_fk_ref_sequence
			  AND fk_ref_bot_name = p_fk_ref_bot_name
			  AND fk_ref_typ_name = p_fk_ref_typ_name
			  AND xf_tsp_typ_name = p_xf_tsp_typ_name
			  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
			  AND xk_tsp_code = p_xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_next_rtr (
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name,
			  fk_ref_sequence,
			  fk_ref_bot_name,
			  fk_ref_typ_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM bot.v_restriction_type_spec_ref
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
$BODY$;

CREATE PROCEDURE bot.insert_rtr (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_include_or_exclude IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_include_or_exclude := NULLIF(p_include_or_exclude,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		INSERT INTO bot.v_restriction_type_spec_ref (
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

		CALL bot.get_next_rtr (p_fk_typ_name, p_fk_ref_sequence, p_fk_ref_bot_name, p_fk_ref_typ_name, p_xf_tsp_typ_name, p_xf_tsp_tsg_code, p_xk_tsp_code);
	EXCEPTION
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type restriction_type_spec_ref already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_rtr (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_include_or_exclude IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_include_or_exclude := NULLIF(p_include_or_exclude,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		UPDATE bot.v_restriction_type_spec_ref SET
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
$BODY$;

CREATE PROCEDURE bot.delete_rtr (
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		DELETE FROM bot.v_restriction_type_spec_ref
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_bot_name = p_fk_ref_bot_name
		  AND fk_ref_typ_name = p_fk_ref_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_rts (
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  include_or_exclude
			FROM bot.v_restriction_target_type_spec
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_ref_sequence = p_fk_ref_sequence
			  AND fk_ref_bot_name = p_fk_ref_bot_name
			  AND fk_ref_typ_name = p_fk_ref_typ_name
			  AND xf_tsp_typ_name = p_xf_tsp_typ_name
			  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
			  AND xk_tsp_code = p_xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_rts (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_include_or_exclude IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_include_or_exclude := NULLIF(p_include_or_exclude,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		INSERT INTO bot.v_restriction_target_type_spec (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type restriction_target_type_spec already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_rts (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_include_or_exclude IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_include_or_exclude := NULLIF(p_include_or_exclude,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		UPDATE bot.v_restriction_target_type_spec SET
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
$BODY$;

CREATE PROCEDURE bot.delete_rts (
			p_fk_typ_name IN VARCHAR,
			p_fk_ref_sequence IN NUMERIC,
			p_fk_ref_bot_name IN VARCHAR,
			p_fk_ref_typ_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_ref_sequence := NULLIF(p_fk_ref_sequence,'');
		p_fk_ref_bot_name := NULLIF(p_fk_ref_bot_name,'');
		p_fk_ref_typ_name := NULLIF(p_fk_ref_typ_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		DELETE FROM bot.v_restriction_target_type_spec
		WHERE fk_typ_name = p_fk_typ_name
		  AND fk_ref_sequence = p_fk_ref_sequence
		  AND fk_ref_bot_name = p_fk_ref_bot_name
		  AND fk_ref_typ_name = p_fk_ref_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_rtt (
			p_fk_typ_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  include_or_exclude
			FROM bot.v_restriction_type_spec_typ
			WHERE fk_typ_name = p_fk_typ_name
			  AND xf_tsp_typ_name = p_xf_tsp_typ_name
			  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
			  AND xk_tsp_code = p_xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_next_rtt (
			p_fk_typ_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_typ_name,
			  xf_tsp_typ_name,
			  xf_tsp_tsg_code,
			  xk_tsp_code
			FROM bot.v_restriction_type_spec_typ
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
$BODY$;

CREATE PROCEDURE bot.insert_rtt (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_include_or_exclude IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_include_or_exclude := NULLIF(p_include_or_exclude,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		INSERT INTO bot.v_restriction_type_spec_typ (
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

		CALL bot.get_next_rtt (p_fk_typ_name, p_xf_tsp_typ_name, p_xf_tsp_tsg_code, p_xk_tsp_code);
	EXCEPTION
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type restriction_type_spec_typ already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_rtt (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_include_or_exclude IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_include_or_exclude := NULLIF(p_include_or_exclude,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		UPDATE bot.v_restriction_type_spec_typ SET
			fk_bot_name = p_fk_bot_name,
			include_or_exclude = p_include_or_exclude
		WHERE fk_typ_name = p_fk_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.delete_rtt (
			p_fk_typ_name IN VARCHAR,
			p_xf_tsp_typ_name IN VARCHAR,
			p_xf_tsp_tsg_code IN VARCHAR,
			p_xk_tsp_code IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_xf_tsp_typ_name := NULLIF(p_xf_tsp_typ_name,'');
		p_xf_tsp_tsg_code := NULLIF(p_xf_tsp_tsg_code,'');
		p_xk_tsp_code := NULLIF(p_xk_tsp_code,'');
		DELETE FROM bot.v_restriction_type_spec_typ
		WHERE fk_typ_name = p_fk_typ_name
		  AND xf_tsp_typ_name = p_xf_tsp_typ_name
		  AND xf_tsp_tsg_code = p_xf_tsp_tsg_code
		  AND xk_tsp_code = p_xk_tsp_code;
	END;
$BODY$;

CREATE PROCEDURE bot.get_jsn (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_location IN NUMERIC,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_location := NULLIF(p_location,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  fk_jsn_name,
			  fk_jsn_location,
			  fk_jsn_atb_typ_name,
			  fk_jsn_atb_name,
			  fk_jsn_typ_name,
			  cube_tsg_obj_arr,
			  cube_tsg_type
			FROM bot.v_json_path
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = p_name
			  AND location = p_location
			  AND xf_atb_typ_name = p_xf_atb_typ_name
			  AND xk_atb_name = p_xk_atb_name
			  AND xk_typ_name = p_xk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_jsn_fkey (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_location IN NUMERIC,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_location := NULLIF(p_location,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name
			FROM bot.v_json_path
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = p_name
			  AND location = p_location
			  AND xf_atb_typ_name = p_xf_atb_typ_name
			  AND xk_atb_name = p_xk_atb_name
			  AND xk_typ_name = p_xk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_jsn_jsn_items (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_location IN NUMERIC,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_location := NULLIF(p_location,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		OPEN l_cube_cursor FOR
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
			FROM bot.v_json_path
			WHERE fk_typ_name = p_fk_typ_name
			  AND fk_jsn_name = p_name
			  AND fk_jsn_location = p_location
			  AND fk_jsn_atb_typ_name = p_xf_atb_typ_name
			  AND fk_jsn_atb_name = p_xk_atb_name
			  AND fk_jsn_typ_name = p_xk_typ_name
			ORDER BY fk_typ_name, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE bot.check_no_part_jsn (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_location IN NUMERIC,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR,
			x_name IN VARCHAR,
			x_location IN NUMERIC,
			x_xf_atb_typ_name IN VARCHAR,
			x_xk_atb_name IN VARCHAR,
			x_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_name bot.v_json_path.name%TYPE;
		l_location bot.v_json_path.location%TYPE;
		l_xf_atb_typ_name bot.v_json_path.xf_atb_typ_name%TYPE;
		l_xk_atb_name bot.v_json_path.xk_atb_name%TYPE;
		l_xk_typ_name bot.v_json_path.xk_typ_name%TYPE;
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_location := NULLIF(p_location,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		x_name := NULLIF(x_name,'');
		x_location := NULLIF(x_location,'');
		x_xf_atb_typ_name := NULLIF(x_xf_atb_typ_name,'');
		x_xk_atb_name := NULLIF(x_xk_atb_name,'');
		x_xk_typ_name := NULLIF(x_xk_typ_name,'');
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
				RAISE EXCEPTION 'Target Type json_path in hierarchy of moving object';
			END IF;
			SELECT fk_jsn_name, fk_jsn_location, fk_jsn_atb_typ_name, fk_jsn_atb_name, fk_jsn_typ_name
			INTO l_name, l_location, l_xf_atb_typ_name, l_xk_atb_name, l_xk_typ_name
			FROM bot.v_json_path
			WHERE fk_typ_name = p_fk_typ_name
			  AND name = l_name
			  AND location = l_location
			  AND xf_atb_typ_name = l_xf_atb_typ_name
			  AND xk_atb_name = l_xk_atb_name
			  AND xk_typ_name = l_xk_typ_name;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.determine_position_jsn (
			p_cube_sequence INOUT NUMERIC,
			p_cube_pos_action IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_jsn_name IN VARCHAR,
			p_fk_jsn_location IN NUMERIC,
			p_fk_jsn_atb_typ_name IN VARCHAR,
			p_fk_jsn_atb_name IN VARCHAR,
			p_fk_jsn_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_location IN NUMERIC,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_pos_action VARCHAR(1);
		l_cube_position_sequ NUMERIC(8);
		l_cube_near_sequ NUMERIC(8);
		l_cube_count NUMERIC(8) := 1024;
		r_jsn RECORD;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_jsn_name := NULLIF(p_fk_jsn_name,'');
		p_fk_jsn_location := NULLIF(p_fk_jsn_location,'');
		p_fk_jsn_atb_typ_name := NULLIF(p_fk_jsn_atb_typ_name,'');
		p_fk_jsn_atb_name := NULLIF(p_fk_jsn_atb_name,'');
		p_fk_jsn_typ_name := NULLIF(p_fk_jsn_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_location := NULLIF(p_location,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
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
			IF p_cube_pos_action IN  ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT COALESCE (MAX (cube_sequence), CASE p_cube_pos_action WHEN 'B' THEN 99999999 ELSE 0 END)
				INTO l_cube_position_sequ
				FROM bot.v_json_path
				WHERE fk_typ_name = p_fk_typ_name
				  AND name = p_name
				  AND location = p_location
				  AND xf_atb_typ_name = p_xf_atb_typ_name
				  AND xk_atb_name = p_xk_atb_name
				  AND xk_typ_name = p_xk_typ_name;
			END IF;
			-- read sequence number near the target.
			SELECT CASE l_cube_pos_action WHEN 'B' THEN COALESCE (MAX (cube_sequence), 0) ELSE COALESCE (MIN (cube_sequence), 99999999) END
			INTO l_cube_near_sequ
			FROM bot.v_json_path
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
				FOR r_jsn IN 
					SELECT
					  rowid row_id
					FROM bot.v_json_path
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
					ORDER BY cube_sequence
				LOOP
					UPDATE bot.v_json_path SET
						cube_sequence = l_cube_count
					WHERE rowid = r_jsn.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE bot.move_jsn (
			p_cube_pos_action IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_location IN NUMERIC,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR,
			x_fk_typ_name IN VARCHAR,
			x_name IN VARCHAR,
			x_location IN NUMERIC,
			x_xf_atb_typ_name IN VARCHAR,
			x_xk_atb_name IN VARCHAR,
			x_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
		l_fk_jsn_name bot.v_json_path.fk_jsn_name%TYPE;
		l_fk_jsn_location bot.v_json_path.fk_jsn_location%TYPE;
		l_fk_jsn_atb_typ_name bot.v_json_path.fk_jsn_atb_typ_name%TYPE;
		l_fk_jsn_atb_name bot.v_json_path.fk_jsn_atb_name%TYPE;
		l_fk_jsn_typ_name bot.v_json_path.fk_jsn_typ_name%TYPE;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_location := NULLIF(p_location,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_name := NULLIF(x_name,'');
		x_location := NULLIF(x_location,'');
		x_xf_atb_typ_name := NULLIF(x_xf_atb_typ_name,'');
		x_xk_atb_name := NULLIF(x_xk_atb_name,'');
		x_xk_typ_name := NULLIF(x_xk_typ_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		-- Get parent id of the target.
		IF p_cube_pos_action IN  ('B', 'A') THEN
			SELECT fk_jsn_name, fk_jsn_location, fk_jsn_atb_typ_name, fk_jsn_atb_name, fk_jsn_typ_name
			INTO l_fk_jsn_name, l_fk_jsn_location, l_fk_jsn_atb_typ_name, l_fk_jsn_atb_name, l_fk_jsn_typ_name
			FROM bot.v_json_path
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
		CALL bot.check_no_part_jsn  (p_fk_typ_name, p_name, p_location, p_xf_atb_typ_name, p_xk_atb_name, p_xk_typ_name, l_fk_jsn_name, l_fk_jsn_location, l_fk_jsn_atb_typ_name, l_fk_jsn_atb_name, l_fk_jsn_typ_name);
		CALL bot.determine_position_jsn  (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, l_fk_jsn_name, l_fk_jsn_location, l_fk_jsn_atb_typ_name, l_fk_jsn_atb_name, l_fk_jsn_typ_name, x_name, x_location, x_xf_atb_typ_name, x_xk_atb_name, x_xk_typ_name);
		UPDATE bot.v_json_path SET
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
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type json_path not found';
		END IF;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_jsn (
			p_cube_pos_action IN VARCHAR,
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_jsn_name IN VARCHAR,
			p_fk_jsn_location IN NUMERIC,
			p_fk_jsn_atb_typ_name IN VARCHAR,
			p_fk_jsn_atb_name IN VARCHAR,
			p_fk_jsn_typ_name IN VARCHAR,
			p_cube_tsg_obj_arr IN VARCHAR,
			p_cube_tsg_type IN VARCHAR,
			p_name IN VARCHAR,
			p_location IN NUMERIC,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR,
			x_fk_typ_name IN VARCHAR,
			x_name IN VARCHAR,
			x_location IN NUMERIC,
			x_xf_atb_typ_name IN VARCHAR,
			x_xk_atb_name IN VARCHAR,
			x_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_jsn_name := NULLIF(p_fk_jsn_name,'');
		p_fk_jsn_location := NULLIF(p_fk_jsn_location,'');
		p_fk_jsn_atb_typ_name := NULLIF(p_fk_jsn_atb_typ_name,'');
		p_fk_jsn_atb_name := NULLIF(p_fk_jsn_atb_name,'');
		p_fk_jsn_typ_name := NULLIF(p_fk_jsn_typ_name,'');
		p_cube_tsg_obj_arr := NULLIF(p_cube_tsg_obj_arr,'');
		p_cube_tsg_type := NULLIF(p_cube_tsg_type,'');
		p_name := NULLIF(p_name,'');
		p_location := NULLIF(p_location,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		x_fk_typ_name := NULLIF(x_fk_typ_name,'');
		x_name := NULLIF(x_name,'');
		x_location := NULLIF(x_location,'');
		x_xf_atb_typ_name := NULLIF(x_xf_atb_typ_name,'');
		x_xk_atb_name := NULLIF(x_xk_atb_name,'');
		x_xk_typ_name := NULLIF(x_xk_typ_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL bot.determine_position_jsn  (l_cube_sequence, p_cube_pos_action, x_fk_typ_name, p_fk_jsn_name, p_fk_jsn_location, p_fk_jsn_atb_typ_name, p_fk_jsn_atb_name, p_fk_jsn_typ_name, x_name, x_location, x_xf_atb_typ_name, x_xk_atb_name, x_xk_typ_name);
		INSERT INTO bot.v_json_path (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type json_path already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_jsn (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_fk_jsn_name IN VARCHAR,
			p_fk_jsn_location IN NUMERIC,
			p_fk_jsn_atb_typ_name IN VARCHAR,
			p_fk_jsn_atb_name IN VARCHAR,
			p_fk_jsn_typ_name IN VARCHAR,
			p_cube_tsg_obj_arr IN VARCHAR,
			p_cube_tsg_type IN VARCHAR,
			p_name IN VARCHAR,
			p_location IN NUMERIC,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_fk_jsn_name := NULLIF(p_fk_jsn_name,'');
		p_fk_jsn_location := NULLIF(p_fk_jsn_location,'');
		p_fk_jsn_atb_typ_name := NULLIF(p_fk_jsn_atb_typ_name,'');
		p_fk_jsn_atb_name := NULLIF(p_fk_jsn_atb_name,'');
		p_fk_jsn_typ_name := NULLIF(p_fk_jsn_typ_name,'');
		p_cube_tsg_obj_arr := NULLIF(p_cube_tsg_obj_arr,'');
		p_cube_tsg_type := NULLIF(p_cube_tsg_type,'');
		p_name := NULLIF(p_name,'');
		p_location := NULLIF(p_location,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		UPDATE bot.v_json_path SET
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
$BODY$;

CREATE PROCEDURE bot.delete_jsn (
			p_fk_typ_name IN VARCHAR,
			p_name IN VARCHAR,
			p_location IN NUMERIC,
			p_xf_atb_typ_name IN VARCHAR,
			p_xk_atb_name IN VARCHAR,
			p_xk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_name := NULLIF(p_name,'');
		p_location := NULLIF(p_location,'');
		p_xf_atb_typ_name := NULLIF(p_xf_atb_typ_name,'');
		p_xk_atb_name := NULLIF(p_xk_atb_name,'');
		p_xk_typ_name := NULLIF(p_xk_typ_name,'');
		DELETE FROM bot.v_json_path
		WHERE fk_typ_name = p_fk_typ_name
		  AND name = p_name
		  AND location = p_location
		  AND xf_atb_typ_name = p_xf_atb_typ_name
		  AND xk_atb_name = p_xk_atb_name
		  AND xk_typ_name = p_xk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.get_dct (
			p_fk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  fk_bot_name,
			  text
			FROM bot.v_description_type
			WHERE fk_typ_name = p_fk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.insert_dct (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_text IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_text := NULLIF(p_text,'');
		INSERT INTO bot.v_description_type (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type description_type already exists';
	END;
$BODY$;

CREATE PROCEDURE bot.update_dct (
			p_fk_bot_name IN VARCHAR,
			p_fk_typ_name IN VARCHAR,
			p_text IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_bot_name := NULLIF(p_fk_bot_name,'');
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		p_text := NULLIF(p_text,'');
		UPDATE bot.v_description_type SET
			fk_bot_name = p_fk_bot_name,
			text = p_text
		WHERE fk_typ_name = p_fk_typ_name;
	END;
$BODY$;

CREATE PROCEDURE bot.delete_dct (
			p_fk_typ_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_typ_name := NULLIF(p_fk_typ_name,'');
		DELETE FROM bot.v_description_type
		WHERE fk_typ_name = p_fk_typ_name;
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
			  AND usename = 'JohanM'
			  AND nspname = 'sys'
			  AND proname NOT LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE sys.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION sys.' || rec_proc.proname;
			END CASE;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE sys.get_sys_root_items ()
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		OPEN l_cube_cursor FOR
			SELECT
			  name,
			  cube_tsg_type
			FROM sys.v_system
			ORDER BY name, cube_tsg_type;
	END;
$BODY$;

CREATE PROCEDURE sys.get_sys (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_tsg_type,
			  database,
			  schema,
			  password,
			  table_prefix
			FROM sys.v_system
			WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE sys.get_sys_sbt_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_sys_name,
			  xk_bot_name
			FROM sys.v_system_bo_type
			WHERE fk_sys_name = p_name
			ORDER BY fk_sys_name, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE sys.get_next_sys (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  name
			FROM sys.v_system
			WHERE name > p_name
			ORDER BY name;
	END;
$BODY$;

CREATE PROCEDURE sys.insert_sys (
			p_name IN VARCHAR,
			p_cube_tsg_type IN VARCHAR,
			p_database IN VARCHAR,
			p_schema IN VARCHAR,
			p_password IN VARCHAR,
			p_table_prefix IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		p_cube_tsg_type := NULLIF(p_cube_tsg_type,'');
		p_database := NULLIF(p_database,'');
		p_schema := NULLIF(p_schema,'');
		p_password := NULLIF(p_password,'');
		p_table_prefix := NULLIF(p_table_prefix,'');
		INSERT INTO sys.v_system (
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

		CALL sys.get_next_sys (p_name);
	EXCEPTION
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type system already exists';
	END;
$BODY$;

CREATE PROCEDURE sys.update_sys (
			p_name IN VARCHAR,
			p_cube_tsg_type IN VARCHAR,
			p_database IN VARCHAR,
			p_schema IN VARCHAR,
			p_password IN VARCHAR,
			p_table_prefix IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_name := NULLIF(p_name,'');
		p_cube_tsg_type := NULLIF(p_cube_tsg_type,'');
		p_database := NULLIF(p_database,'');
		p_schema := NULLIF(p_schema,'');
		p_password := NULLIF(p_password,'');
		p_table_prefix := NULLIF(p_table_prefix,'');
		UPDATE sys.v_system SET
			cube_tsg_type = p_cube_tsg_type,
			database = p_database,
			schema = p_schema,
			password = p_password,
			table_prefix = p_table_prefix
		WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE sys.delete_sys (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_name := NULLIF(p_name,'');
		DELETE FROM sys.v_system
		WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE sys.determine_position_sbt (
			p_cube_sequence INOUT NUMERIC,
			p_cube_pos_action IN VARCHAR,
			p_fk_sys_name IN VARCHAR,
			p_xk_bot_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_pos_action VARCHAR(1);
		l_cube_position_sequ NUMERIC(8);
		l_cube_near_sequ NUMERIC(8);
		l_cube_count NUMERIC(8) := 1024;
		r_sbt RECORD;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_sys_name := NULLIF(p_fk_sys_name,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
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
			IF p_cube_pos_action IN  ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT COALESCE (MAX (cube_sequence), CASE p_cube_pos_action WHEN 'B' THEN 99999999 ELSE 0 END)
				INTO l_cube_position_sequ
				FROM sys.v_system_bo_type
				WHERE fk_sys_name = p_fk_sys_name
				  AND xk_bot_name = p_xk_bot_name;
			END IF;
			-- read sequence number near the target.
			SELECT CASE l_cube_pos_action WHEN 'B' THEN COALESCE (MAX (cube_sequence), 0) ELSE COALESCE (MIN (cube_sequence), 99999999) END
			INTO l_cube_near_sequ
			FROM sys.v_system_bo_type
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
				FOR r_sbt IN 
					SELECT
					  rowid row_id
					FROM sys.v_system_bo_type
					WHERE fk_sys_name = p_fk_sys_name
					ORDER BY cube_sequence
				LOOP
					UPDATE sys.v_system_bo_type SET
						cube_sequence = l_cube_count
					WHERE rowid = r_sbt.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE sys.move_sbt (
			p_cube_pos_action IN VARCHAR,
			p_fk_sys_name IN VARCHAR,
			p_xk_bot_name IN VARCHAR,
			x_fk_sys_name IN VARCHAR,
			x_xk_bot_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_sys_name := NULLIF(p_fk_sys_name,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		x_fk_sys_name := NULLIF(x_fk_sys_name,'');
		x_xk_bot_name := NULLIF(x_xk_bot_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL sys.determine_position_sbt  (l_cube_sequence, p_cube_pos_action, x_fk_sys_name, x_xk_bot_name);
		UPDATE sys.v_system_bo_type SET
			cube_sequence = l_cube_sequence
		WHERE fk_sys_name = p_fk_sys_name
		  AND xk_bot_name = p_xk_bot_name;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type system_bo_type not found';
		END IF;
	END;
$BODY$;

CREATE PROCEDURE sys.insert_sbt (
			p_cube_pos_action IN VARCHAR,
			p_fk_sys_name IN VARCHAR,
			p_xk_bot_name IN VARCHAR,
			x_fk_sys_name IN VARCHAR,
			x_xk_bot_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_sys_name := NULLIF(p_fk_sys_name,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		x_fk_sys_name := NULLIF(x_fk_sys_name,'');
		x_xk_bot_name := NULLIF(x_xk_bot_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL sys.determine_position_sbt  (l_cube_sequence, p_cube_pos_action, x_fk_sys_name, x_xk_bot_name);
		INSERT INTO sys.v_system_bo_type (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type system_bo_type already exists';
	END;
$BODY$;

CREATE PROCEDURE sys.delete_sbt (
			p_fk_sys_name IN VARCHAR,
			p_xk_bot_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_sys_name := NULLIF(p_fk_sys_name,'');
		p_xk_bot_name := NULLIF(p_xk_bot_name,'');
		DELETE FROM sys.v_system_bo_type
		WHERE fk_sys_name = p_fk_sys_name
		  AND xk_bot_name = p_xk_bot_name;
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
			  AND usename = 'JohanM'
			  AND nspname = 'fun'
			  AND proname NOT LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE fun.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION fun.' || rec_proc.proname;
			END CASE;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE fun.get_fun_root_items ()
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		OPEN l_cube_cursor FOR
			SELECT
			  name
			FROM fun.v_function
			ORDER BY name;
	END;
$BODY$;

CREATE PROCEDURE fun.count_fun ()
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		OPEN l_cube_cursor FOR
			SELECT
			  COUNT(1) type_count
			FROM fun.v_function;
	END;
$BODY$;

CREATE PROCEDURE fun.get_fun_arg_items (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_cursor REFCURSOR := 'cube_cursor';
	BEGIN
		p_name := NULLIF(p_name,'');
		OPEN l_cube_cursor FOR
			SELECT
			  cube_sequence,
			  fk_fun_name,
			  name
			FROM fun.v_argument
			WHERE fk_fun_name = p_name
			ORDER BY fk_fun_name, cube_sequence;
	END;
$BODY$;

CREATE PROCEDURE fun.insert_fun (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_name := NULLIF(p_name,'');
		INSERT INTO fun.v_function (
			cube_id,
			name)
		VALUES (
			NULL,
			p_name);
	EXCEPTION
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type function already exists';
	END;
$BODY$;

CREATE PROCEDURE fun.delete_fun (
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_name := NULLIF(p_name,'');
		DELETE FROM fun.v_function
		WHERE name = p_name;
	END;
$BODY$;

CREATE PROCEDURE fun.determine_position_arg (
			p_cube_sequence INOUT NUMERIC,
			p_cube_pos_action IN VARCHAR,
			p_fk_fun_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_pos_action VARCHAR(1);
		l_cube_position_sequ NUMERIC(8);
		l_cube_near_sequ NUMERIC(8);
		l_cube_count NUMERIC(8) := 1024;
		r_arg RECORD;
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_fun_name := NULLIF(p_fk_fun_name,'');
		p_name := NULLIF(p_name,'');
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
			IF p_cube_pos_action IN  ('B', 'A') THEN
				-- Read sequence number of the target.
				SELECT COALESCE (MAX (cube_sequence), CASE p_cube_pos_action WHEN 'B' THEN 99999999 ELSE 0 END)
				INTO l_cube_position_sequ
				FROM fun.v_argument
				WHERE fk_fun_name = p_fk_fun_name
				  AND name = p_name;
			END IF;
			-- read sequence number near the target.
			SELECT CASE l_cube_pos_action WHEN 'B' THEN COALESCE (MAX (cube_sequence), 0) ELSE COALESCE (MIN (cube_sequence), 99999999) END
			INTO l_cube_near_sequ
			FROM fun.v_argument
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
				FOR r_arg IN 
					SELECT
					  rowid row_id
					FROM fun.v_argument
					WHERE fk_fun_name = p_fk_fun_name
					ORDER BY cube_sequence
				LOOP
					UPDATE fun.v_argument SET
						cube_sequence = l_cube_count
					WHERE rowid = r_arg.row_id;
					l_cube_count := l_cube_count + 1024;
				END LOOP;
			END IF;
		END LOOP;
	END;
$BODY$;

CREATE PROCEDURE fun.move_arg (
			p_cube_pos_action IN VARCHAR,
			p_fk_fun_name IN VARCHAR,
			p_name IN VARCHAR,
			x_fk_fun_name IN VARCHAR,
			x_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_fun_name := NULLIF(p_fk_fun_name,'');
		p_name := NULLIF(p_name,'');
		x_fk_fun_name := NULLIF(x_fk_fun_name,'');
		x_name := NULLIF(x_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL fun.determine_position_arg  (l_cube_sequence, p_cube_pos_action, x_fk_fun_name, x_name);
		UPDATE fun.v_argument SET
			cube_sequence = l_cube_sequence
		WHERE fk_fun_name = p_fk_fun_name
		  AND name = p_name;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type argument not found';
		END IF;
	END;
$BODY$;

CREATE PROCEDURE fun.insert_arg (
			p_cube_pos_action IN VARCHAR,
			p_fk_fun_name IN VARCHAR,
			p_name IN VARCHAR,
			x_fk_fun_name IN VARCHAR,
			x_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
		l_cube_sequence NUMERIC(8);
	BEGIN
		p_cube_pos_action := NULLIF(p_cube_pos_action,'');
		p_fk_fun_name := NULLIF(p_fk_fun_name,'');
		p_name := NULLIF(p_name,'');
		x_fk_fun_name := NULLIF(x_fk_fun_name,'');
		x_name := NULLIF(x_name,'');
		-- A=After B=Before F=First L=Last
		IF COALESCE (p_cube_pos_action, ' ') NOT IN  ('A', 'B', 'F', 'L') THEN
			RAISE EXCEPTION 'Invalid position action: %', p_cube_pos_action;
		END IF;
		CALL fun.determine_position_arg  (l_cube_sequence, p_cube_pos_action, x_fk_fun_name, x_name);
		INSERT INTO fun.v_argument (
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
	WHEN unique_violation THEN
			RAISE EXCEPTION 'Type argument already exists';
	END;
$BODY$;

CREATE PROCEDURE fun.delete_arg (
			p_fk_fun_name IN VARCHAR,
			p_name IN VARCHAR)
LANGUAGE 'plpgsql'
AS $BODY$
	DECLARE
	BEGIN
		p_fk_fun_name := NULLIF(p_fk_fun_name,'');
		p_name := NULLIF(p_name,'');
		DELETE FROM fun.v_argument
		WHERE fk_fun_name = p_fk_fun_name
		  AND name = p_name;
	END;
$BODY$;
\q
