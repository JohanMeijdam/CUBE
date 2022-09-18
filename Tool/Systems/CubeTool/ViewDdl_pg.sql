-- DB VIEW DDL
--
DO $BODY$
	DECLARE
		rec_view RECORD;
		rec_proc RECORD;
	BEGIN

		FOR rec_view IN 
			SELECT viewname 
			FROM pg_catalog.pg_views
			WHERE schemaname = 'itp'
			  AND viewowner = 'JohanM'
		LOOP
			EXECUTE 'DROP VIEW itp.' || rec_view.viewname || ' CASCADE';
		END LOOP;

		FOR rec_view IN 
			SELECT viewname 
			FROM pg_catalog.pg_views
			WHERE schemaname = 'bot'
			  AND viewowner = 'JohanM'
		LOOP
			EXECUTE 'DROP VIEW bot.' || rec_view.viewname || ' CASCADE';
		END LOOP;

		FOR rec_view IN 
			SELECT viewname 
			FROM pg_catalog.pg_views
			WHERE schemaname = 'sys'
			  AND viewowner = 'JohanM'
		LOOP
			EXECUTE 'DROP VIEW sys.' || rec_view.viewname || ' CASCADE';
		END LOOP;

		FOR rec_view IN 
			SELECT viewname 
			FROM pg_catalog.pg_views
			WHERE schemaname = 'fun'
			  AND viewowner = 'JohanM'
		LOOP
			EXECUTE 'DROP VIEW fun.' || rec_view.viewname || ' CASCADE';
		END LOOP;

		FOR rec_proc IN
			SELECT proname, prokind
			FROM pg_catalog.pg_proc, pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE pronamespace = pg_namespace.oid
			  AND nspowner = usesysid
			  AND usename = 'JohanM'
			  AND nspname = 'itp'
			  AND proname LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE itp.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION itp.' || rec_proc.proname;
			END CASE;
		END LOOP;

		FOR rec_proc IN
			SELECT proname, prokind
			FROM pg_catalog.pg_proc, pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE pronamespace = pg_namespace.oid
			  AND nspowner = usesysid
			  AND usename = 'JohanM'
			  AND nspname = 'bot'
			  AND proname LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE bot.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION bot.' || rec_proc.proname;
			END CASE;
		END LOOP;

		FOR rec_proc IN
			SELECT proname, prokind
			FROM pg_catalog.pg_proc, pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE pronamespace = pg_namespace.oid
			  AND nspowner = usesysid
			  AND usename = 'JohanM'
			  AND nspname = 'sys'
			  AND proname LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE sys.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION sys.' || rec_proc.proname;
			END CASE;
		END LOOP;

		FOR rec_proc IN
			SELECT proname, prokind
			FROM pg_catalog.pg_proc, pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE pronamespace = pg_namespace.oid
			  AND nspowner = usesysid
			  AND usename = 'JohanM'
			  AND nspname = 'fun'
			  AND proname LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE fun.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION fun.' || rec_proc.proname;
			END CASE;
		END LOOP;
	END;
$BODY$;

CREATE VIEW itp.v_information_type AS 
	SELECT
		cube_id,
		name
	FROM itp.t_information_type;


CREATE VIEW itp.v_information_type_element AS 
	SELECT
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
		presentation
	FROM itp.t_information_type_element;


CREATE VIEW itp.v_permitted_value AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_itp_name,
		fk_ite_sequence,
		code,
		prompt
	FROM itp.t_permitted_value;


CREATE PROCEDURE itp.trg_insert_itp (p_itp itp.v_information_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_itp.cube_id := 'ITP-' || TO_CHAR(NEXTVAL('itp.sq_itp'),'FM000000000000');
		p_itp.name := COALESCE(p_itp.name,' ');
		INSERT INTO itp.t_information_type (
			cube_id,
			name)
		VALUES (
			p_itp.cube_id,
			p_itp.name);
	END;
$BODY$;

CREATE PROCEDURE itp.trg_update_itp (p_cube_ctid TID, p_itp_old itp.v_information_type, p_itp_new itp.v_information_type)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		NULL;
	END;
$BODY$;

CREATE PROCEDURE itp.trg_delete_itp (p_cube_ctid TID, p_itp itp.v_information_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM itp.t_information_type 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE itp.trg_insert_ite (p_ite itp.v_information_type_element)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_ite.cube_id := 'ITE-' || TO_CHAR(NEXTVAL('itp.sq_ite'),'FM000000000000');
		p_ite.fk_itp_name := COALESCE(p_ite.fk_itp_name,' ');
		p_ite.sequence := COALESCE(p_ite.sequence,0);
		INSERT INTO itp.t_information_type_element (
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
			p_ite.cube_id,
			p_ite.fk_itp_name,
			p_ite.sequence,
			p_ite.suffix,
			p_ite.domain,
			p_ite.length,
			p_ite.decimals,
			p_ite.case_sensitive,
			p_ite.default_value,
			p_ite.spaces_allowed,
			p_ite.presentation);
	END;
$BODY$;

CREATE PROCEDURE itp.trg_update_ite (p_cube_ctid TID, p_ite_old itp.v_information_type_element, p_ite_new itp.v_information_type_element)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE itp.t_information_type_element SET 
			suffix = p_ite_new.suffix,
			domain = p_ite_new.domain,
			length = p_ite_new.length,
			decimals = p_ite_new.decimals,
			case_sensitive = p_ite_new.case_sensitive,
			default_value = p_ite_new.default_value,
			spaces_allowed = p_ite_new.spaces_allowed,
			presentation = p_ite_new.presentation
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE itp.trg_delete_ite (p_cube_ctid TID, p_ite itp.v_information_type_element)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM itp.t_information_type_element 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE itp.trg_insert_val (p_val itp.v_permitted_value)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_val.cube_id := 'VAL-' || TO_CHAR(NEXTVAL('itp.sq_val'),'FM000000000000');
		p_val.fk_itp_name := COALESCE(p_val.fk_itp_name,' ');
		p_val.fk_ite_sequence := COALESCE(p_val.fk_ite_sequence,0);
		p_val.code := COALESCE(p_val.code,' ');
		INSERT INTO itp.t_permitted_value (
			cube_id,
			cube_sequence,
			fk_itp_name,
			fk_ite_sequence,
			code,
			prompt)
		VALUES (
			p_val.cube_id,
			p_val.cube_sequence,
			p_val.fk_itp_name,
			p_val.fk_ite_sequence,
			p_val.code,
			p_val.prompt);
	END;
$BODY$;

CREATE PROCEDURE itp.trg_update_val (p_cube_ctid TID, p_val_old itp.v_permitted_value, p_val_new itp.v_permitted_value)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE itp.t_permitted_value SET 
			cube_sequence = p_val_new.cube_sequence,
			prompt = p_val_new.prompt
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE itp.trg_delete_val (p_cube_ctid TID, p_val itp.v_permitted_value)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM itp.t_permitted_value 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE FUNCTION itp.trg_itp() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_itp_new itp.v_information_type%ROWTYPE;
		r_itp_old itp.v_information_type%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.name = ' ' THEN
				r_itp_new.name := ' ';
			ELSE
				r_itp_new.name := REPLACE(NEW.name,' ','_');
			END IF;
			r_itp_new.name := UPPER(r_itp_new.name);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_itp_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM itp.t_information_type
			WHERE name = OLD.name;
			r_itp_old.name := OLD.name;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL itp.trg_insert_itp (r_itp_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL itp.trg_update_itp (l_cube_ctid, r_itp_old, r_itp_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL itp.trg_delete_itp (l_cube_ctid, r_itp_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_itp
INSTEAD OF INSERT OR DELETE OR UPDATE ON itp.v_information_type
FOR EACH ROW
EXECUTE PROCEDURE itp.trg_itp();

CREATE FUNCTION itp.trg_ite() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_ite_new itp.v_information_type_element%ROWTYPE;
		r_ite_old itp.v_information_type_element%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.fk_itp_name = ' ' THEN
				r_ite_new.fk_itp_name := ' ';
			ELSE
				r_ite_new.fk_itp_name := REPLACE(NEW.fk_itp_name,' ','_');
			END IF;
			r_ite_new.fk_itp_name := UPPER(r_ite_new.fk_itp_name);
			r_ite_new.sequence := NEW.sequence;
			IF NEW.suffix = ' ' THEN
				r_ite_new.suffix := ' ';
			ELSE
				r_ite_new.suffix := REPLACE(NEW.suffix,' ','_');
			END IF;
			IF NEW.domain = ' ' THEN
				r_ite_new.domain := ' ';
			ELSE
				r_ite_new.domain := REPLACE(NEW.domain,' ','_');
			END IF;
			r_ite_new.length := NEW.length;
			r_ite_new.decimals := NEW.decimals;
			r_ite_new.case_sensitive := NEW.case_sensitive;
			r_ite_new.default_value := NEW.default_value;
			r_ite_new.spaces_allowed := NEW.spaces_allowed;
			IF NEW.presentation = ' ' THEN
				r_ite_new.presentation := ' ';
			ELSE
				r_ite_new.presentation := REPLACE(NEW.presentation,' ','_');
			END IF;
			r_ite_new.presentation := UPPER(r_ite_new.presentation);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_ite_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM itp.t_information_type_element
			WHERE fk_itp_name = OLD.fk_itp_name
			AND sequence = OLD.sequence;
			r_ite_old.fk_itp_name := OLD.fk_itp_name;
			r_ite_old.sequence := OLD.sequence;
			r_ite_old.suffix := OLD.suffix;
			r_ite_old.domain := OLD.domain;
			r_ite_old.length := OLD.length;
			r_ite_old.decimals := OLD.decimals;
			r_ite_old.case_sensitive := OLD.case_sensitive;
			r_ite_old.default_value := OLD.default_value;
			r_ite_old.spaces_allowed := OLD.spaces_allowed;
			r_ite_old.presentation := OLD.presentation;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL itp.trg_insert_ite (r_ite_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL itp.trg_update_ite (l_cube_ctid, r_ite_old, r_ite_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL itp.trg_delete_ite (l_cube_ctid, r_ite_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_ite
INSTEAD OF INSERT OR DELETE OR UPDATE ON itp.v_information_type_element
FOR EACH ROW
EXECUTE PROCEDURE itp.trg_ite();

CREATE FUNCTION itp.trg_val() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_val_new itp.v_permitted_value%ROWTYPE;
		r_val_old itp.v_permitted_value%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			r_val_new.cube_sequence := NEW.cube_sequence;
			IF NEW.fk_itp_name = ' ' THEN
				r_val_new.fk_itp_name := ' ';
			ELSE
				r_val_new.fk_itp_name := REPLACE(NEW.fk_itp_name,' ','_');
			END IF;
			r_val_new.fk_itp_name := UPPER(r_val_new.fk_itp_name);
			r_val_new.fk_ite_sequence := NEW.fk_ite_sequence;
			IF NEW.code = ' ' THEN
				r_val_new.code := ' ';
			ELSE
				r_val_new.code := REPLACE(NEW.code,' ','_');
			END IF;
			r_val_new.code := UPPER(r_val_new.code);
			r_val_new.prompt := NEW.prompt;
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_val_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM itp.t_permitted_value
			WHERE fk_itp_name = OLD.fk_itp_name
			AND fk_ite_sequence = OLD.fk_ite_sequence
			AND code = OLD.code;
			r_val_old.cube_sequence := OLD.cube_sequence;
			r_val_old.fk_itp_name := OLD.fk_itp_name;
			r_val_old.fk_ite_sequence := OLD.fk_ite_sequence;
			r_val_old.code := OLD.code;
			r_val_old.prompt := OLD.prompt;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL itp.trg_insert_val (r_val_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL itp.trg_update_val (l_cube_ctid, r_val_old, r_val_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL itp.trg_delete_val (l_cube_ctid, r_val_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_val
INSTEAD OF INSERT OR DELETE OR UPDATE ON itp.v_permitted_value
FOR EACH ROW
EXECUTE PROCEDURE itp.trg_val();

CREATE VIEW bot.v_business_object_type AS 
	SELECT
		cube_id,
		cube_sequence,
		name,
		cube_tsg_type,
		directory,
		api_url
	FROM bot.t_business_object_type;


CREATE VIEW bot.v_type AS 
	SELECT
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
		transferable
	FROM bot.t_type;


CREATE VIEW bot.v_type_specialisation_group AS 
	SELECT
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
		xk_atb_name
	FROM bot.t_type_specialisation_group;


CREATE VIEW bot.v_type_specialisation AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_bot_name,
		fk_typ_name,
		fk_tsg_code,
		code,
		name,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM bot.t_type_specialisation;


CREATE VIEW bot.v_attribute AS 
	SELECT
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
		xk_itp_name
	FROM bot.t_attribute;


CREATE VIEW bot.v_derivation AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_atb_name,
		cube_tsg_type,
		aggregate_function,
		xk_typ_name,
		xk_typ_name_1
	FROM bot.t_derivation;


CREATE VIEW bot.v_description_attribute AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_atb_name,
		text
	FROM bot.t_description_attribute;


CREATE VIEW bot.v_restriction_type_spec_atb AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_atb_name,
		include_or_exclude,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM bot.t_restriction_type_spec_atb;


CREATE VIEW bot.v_reference AS 
	SELECT
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
		xk_typ_name_1
	FROM bot.t_reference;


CREATE VIEW bot.v_description_reference AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_ref_sequence,
		fk_ref_bot_name,
		fk_ref_typ_name,
		text
	FROM bot.t_description_reference;


CREATE VIEW bot.v_restriction_type_spec_ref AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_ref_sequence,
		fk_ref_bot_name,
		fk_ref_typ_name,
		include_or_exclude,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM bot.t_restriction_type_spec_ref;


CREATE VIEW bot.v_restriction_target_type_spec AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_ref_sequence,
		fk_ref_bot_name,
		fk_ref_typ_name,
		include_or_exclude,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM bot.t_restriction_target_type_spec;


CREATE VIEW bot.v_restriction_type_spec_typ AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		include_or_exclude,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM bot.t_restriction_type_spec_typ;


CREATE VIEW bot.v_json_path AS 
	SELECT
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
		xk_typ_name
	FROM bot.t_json_path;


CREATE VIEW bot.v_description_type AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		text
	FROM bot.t_description_type;


CREATE PROCEDURE bot.trg_insert_bot (p_bot bot.v_business_object_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_bot.cube_id := 'BOT-' || TO_CHAR(NEXTVAL('bot.sq_bot'),'FM000000000000');
		p_bot.name := COALESCE(p_bot.name,' ');
		INSERT INTO bot.t_business_object_type (
			cube_id,
			cube_sequence,
			name,
			cube_tsg_type,
			directory,
			api_url)
		VALUES (
			p_bot.cube_id,
			p_bot.cube_sequence,
			p_bot.name,
			p_bot.cube_tsg_type,
			p_bot.directory,
			p_bot.api_url);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_bot (p_cube_ctid TID, p_bot_old bot.v_business_object_type, p_bot_new bot.v_business_object_type)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_business_object_type SET 
			cube_sequence = p_bot_new.cube_sequence,
			directory = p_bot_new.directory,
			api_url = p_bot_new.api_url
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_bot (p_cube_ctid TID, p_bot bot.v_business_object_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_business_object_type 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_typ (p_typ bot.v_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_typ.cube_id := 'TYP-' || TO_CHAR(NEXTVAL('bot.sq_typ'),'FM000000000000');
		p_typ.fk_bot_name := COALESCE(p_typ.fk_bot_name,' ');
		p_typ.name := COALESCE(p_typ.name,' ');
		IF p_typ.fk_typ_name IS NOT NULL THEN
			-- Recursive
			SELECT fk_bot_name
			  INTO p_typ.fk_bot_name
			FROM bot.t_type
			WHERE fk_bot_name = p_typ.fk_bot_name
			  AND name = p_typ.fk_typ_name;
		END IF;
		CALL bot.trg_get_denorm_typ_typ (p_typ);
		INSERT INTO bot.t_type (
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
			p_typ.cube_id,
			p_typ.cube_sequence,
			p_typ.cube_level,
			p_typ.fk_bot_name,
			p_typ.fk_typ_name,
			p_typ.name,
			p_typ.code,
			p_typ.flag_partial_key,
			p_typ.flag_recursive,
			p_typ.recursive_cardinality,
			p_typ.cardinality,
			p_typ.sort_order,
			p_typ.icon,
			p_typ.transferable);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_typ (p_cube_ctid TID, p_typ_old bot.v_type, p_typ_new bot.v_type)
LANGUAGE plpgsql
AS $BODY$
	DECLARE
		c_typ CURSOR FOR
			SELECT CTID cube_ctid, typ.* FROM bot.v_type typ
			WHERE fk_typ_name = p_typ_old.name;
		
		l_typ_ctid TID;
		r_typ_old bot.v_type%ROWTYPE;
		r_typ_new bot.v_type%ROWTYPE;
	BEGIN
		IF COALESCE(p_typ_old.fk_typ_name,' ') <> COALESCE(p_typ_new.fk_typ_name,' ')  THEN
			CALL bot.trg_get_denorm_typ_typ (p_typ_new);
		END IF;
		UPDATE bot.t_type SET 
			cube_sequence = p_typ_new.cube_sequence,
			cube_level = p_typ_new.cube_level,
			fk_typ_name = p_typ_new.fk_typ_name,
			code = p_typ_new.code,
			flag_partial_key = p_typ_new.flag_partial_key,
			flag_recursive = p_typ_new.flag_recursive,
			recursive_cardinality = p_typ_new.recursive_cardinality,
			cardinality = p_typ_new.cardinality,
			sort_order = p_typ_new.sort_order,
			icon = p_typ_new.icon,
			transferable = p_typ_new.transferable
		WHERE ctid = p_cube_ctid;
		IF COALESCE(p_typ_old.cube_level,0) <> COALESCE(p_typ_new.cube_level,0) THEN
			OPEN c_typ;
			LOOP
				FETCH c_typ INTO
					l_typ_ctid,
					r_typ_old.cube_id,
					r_typ_old.cube_sequence,
					r_typ_old.cube_level,
					r_typ_old.fk_bot_name,
					r_typ_old.fk_typ_name,
					r_typ_old.name,
					r_typ_old.code,
					r_typ_old.flag_partial_key,
					r_typ_old.flag_recursive,
					r_typ_old.recursive_cardinality,
					r_typ_old.cardinality,
					r_typ_old.sort_order,
					r_typ_old.icon,
					r_typ_old.transferable;
				EXIT WHEN NOT FOUND;
				r_typ_new := r_typ_old;
				CALL bot.trg_denorm_typ_typ (r_typ_new, p_typ_new);
				CALL bot.trg_update_typ (l_typ_ctid, r_typ_old, r_typ_new);
			END LOOP;
			CLOSE c_typ;
		END IF;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_typ (p_cube_ctid TID, p_typ bot.v_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_type 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_denorm_typ_typ (p_typ bot.v_type, p_typ_in bot.v_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_typ.cube_level := COALESCE (p_typ_in.cube_level, 0) + 1;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_get_denorm_typ_typ (p_typ bot.v_type)
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		c_typ CURSOR FOR 
			SELECT * FROM bot.v_type
			WHERE name = p_typ.fk_typ_name;
		
		r_typ bot.v_type%ROWTYPE;
	BEGIN
		IF p_typ.fk_typ_name IS NOT NULL THEN
			OPEN c_typ;
			FETCH c_typ INTO r_typ;
			IF NOT FOUND THEN
				r_typ := NULL;
			END IF;
			CLOSE c_typ;
		ELSE
			r_typ := NULL;
		END IF;
		CALL bot.trg_denorm_typ_typ (p_typ, r_typ);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_tsg (p_tsg bot.v_type_specialisation_group)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_tsg.cube_id := 'TSG-' || TO_CHAR(NEXTVAL('bot.sq_tsg'),'FM000000000000');
		p_tsg.fk_bot_name := COALESCE(p_tsg.fk_bot_name,' ');
		p_tsg.fk_typ_name := COALESCE(p_tsg.fk_typ_name,' ');
		p_tsg.code := COALESCE(p_tsg.code,' ');
		p_tsg.xf_atb_typ_name := COALESCE(p_tsg.xf_atb_typ_name,' ');
		p_tsg.xk_atb_name := COALESCE(p_tsg.xk_atb_name,' ');
		IF p_tsg.fk_tsg_code IS NOT NULL THEN
			-- Recursive
			SELECT fk_bot_name
			  INTO p_tsg.fk_bot_name
			FROM bot.t_type_specialisation_group
			WHERE fk_typ_name = p_tsg.fk_typ_name
			  AND code = p_tsg.fk_tsg_code;
			ELSE
			-- Parent
			SELECT fk_bot_name
			  INTO p_tsg.fk_bot_name
			FROM bot.t_type
			WHERE name = p_tsg.fk_typ_name;
			
		END IF;
		CALL bot.trg_get_denorm_tsg_tsg (p_tsg);
		INSERT INTO bot.t_type_specialisation_group (
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
			p_tsg.cube_id,
			p_tsg.cube_sequence,
			p_tsg.cube_level,
			p_tsg.fk_bot_name,
			p_tsg.fk_typ_name,
			p_tsg.fk_tsg_code,
			p_tsg.code,
			p_tsg.name,
			p_tsg.primary_key,
			p_tsg.xf_atb_typ_name,
			p_tsg.xk_atb_name);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_tsg (p_cube_ctid TID, p_tsg_old bot.v_type_specialisation_group, p_tsg_new bot.v_type_specialisation_group)
LANGUAGE plpgsql
AS $BODY$
	DECLARE
		c_tsg CURSOR FOR
			SELECT CTID cube_ctid, tsg.* FROM bot.v_type_specialisation_group tsg
			WHERE fk_typ_name = p_tsg_old.fk_typ_name
			  AND fk_tsg_code = p_tsg_old.code;
		
		l_tsg_ctid TID;
		r_tsg_old bot.v_type_specialisation_group%ROWTYPE;
		r_tsg_new bot.v_type_specialisation_group%ROWTYPE;
	BEGIN
		IF COALESCE(p_tsg_old.fk_tsg_code,' ') <> COALESCE(p_tsg_new.fk_tsg_code,' ')  THEN
			CALL bot.trg_get_denorm_tsg_tsg (p_tsg_new);
		END IF;
		UPDATE bot.t_type_specialisation_group SET 
			cube_sequence = p_tsg_new.cube_sequence,
			cube_level = p_tsg_new.cube_level,
			fk_tsg_code = p_tsg_new.fk_tsg_code,
			name = p_tsg_new.name,
			primary_key = p_tsg_new.primary_key,
			xf_atb_typ_name = p_tsg_new.xf_atb_typ_name,
			xk_atb_name = p_tsg_new.xk_atb_name
		WHERE ctid = p_cube_ctid;
		IF COALESCE(p_tsg_old.cube_level,0) <> COALESCE(p_tsg_new.cube_level,0) THEN
			OPEN c_tsg;
			LOOP
				FETCH c_tsg INTO
					l_tsg_ctid,
					r_tsg_old.cube_id,
					r_tsg_old.cube_sequence,
					r_tsg_old.cube_level,
					r_tsg_old.fk_bot_name,
					r_tsg_old.fk_typ_name,
					r_tsg_old.fk_tsg_code,
					r_tsg_old.code,
					r_tsg_old.name,
					r_tsg_old.primary_key,
					r_tsg_old.xf_atb_typ_name,
					r_tsg_old.xk_atb_name;
				EXIT WHEN NOT FOUND;
				r_tsg_new := r_tsg_old;
				CALL bot.trg_denorm_tsg_tsg (r_tsg_new, p_tsg_new);
				CALL bot.trg_update_tsg (l_tsg_ctid, r_tsg_old, r_tsg_new);
			END LOOP;
			CLOSE c_tsg;
		END IF;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_tsg (p_cube_ctid TID, p_tsg bot.v_type_specialisation_group)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_type_specialisation_group 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_denorm_tsg_tsg (p_tsg bot.v_type_specialisation_group, p_tsg_in bot.v_type_specialisation_group)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_tsg.cube_level := COALESCE (p_tsg_in.cube_level, 0) + 1;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_get_denorm_tsg_tsg (p_tsg bot.v_type_specialisation_group)
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		c_tsg CURSOR FOR 
			SELECT * FROM bot.v_type_specialisation_group
			WHERE fk_typ_name = p_tsg.fk_typ_name
			  AND code = p_tsg.fk_tsg_code;
		
		r_tsg bot.v_type_specialisation_group%ROWTYPE;
	BEGIN
		IF p_tsg.fk_tsg_code IS NOT NULL THEN
			OPEN c_tsg;
			FETCH c_tsg INTO r_tsg;
			IF NOT FOUND THEN
				r_tsg := NULL;
			END IF;
			CLOSE c_tsg;
		ELSE
			r_tsg := NULL;
		END IF;
		CALL bot.trg_denorm_tsg_tsg (p_tsg, r_tsg);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_tsp (p_tsp bot.v_type_specialisation)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_tsp.cube_id := 'TSP-' || TO_CHAR(NEXTVAL('bot.sq_tsp'),'FM000000000000');
		p_tsp.fk_bot_name := COALESCE(p_tsp.fk_bot_name,' ');
		p_tsp.fk_typ_name := COALESCE(p_tsp.fk_typ_name,' ');
		p_tsp.fk_tsg_code := COALESCE(p_tsp.fk_tsg_code,' ');
		p_tsp.code := COALESCE(p_tsp.code,' ');
		p_tsp.xf_tsp_typ_name := COALESCE(p_tsp.xf_tsp_typ_name,' ');
		p_tsp.xf_tsp_tsg_code := COALESCE(p_tsp.xf_tsp_tsg_code,' ');
		p_tsp.xk_tsp_code := COALESCE(p_tsp.xk_tsp_code,' ');
		SELECT fk_bot_name
		  INTO p_tsp.fk_bot_name
		FROM bot.t_type_specialisation_group
		WHERE fk_typ_name = p_tsp.fk_typ_name
		  AND code = p_tsp.fk_tsg_code;
		INSERT INTO bot.t_type_specialisation (
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
			p_tsp.cube_id,
			p_tsp.cube_sequence,
			p_tsp.fk_bot_name,
			p_tsp.fk_typ_name,
			p_tsp.fk_tsg_code,
			p_tsp.code,
			p_tsp.name,
			p_tsp.xf_tsp_typ_name,
			p_tsp.xf_tsp_tsg_code,
			p_tsp.xk_tsp_code);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_tsp (p_cube_ctid TID, p_tsp_old bot.v_type_specialisation, p_tsp_new bot.v_type_specialisation)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_type_specialisation SET 
			cube_sequence = p_tsp_new.cube_sequence,
			name = p_tsp_new.name,
			xf_tsp_typ_name = p_tsp_new.xf_tsp_typ_name,
			xf_tsp_tsg_code = p_tsp_new.xf_tsp_tsg_code,
			xk_tsp_code = p_tsp_new.xk_tsp_code
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_tsp (p_cube_ctid TID, p_tsp bot.v_type_specialisation)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_type_specialisation 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_atb (p_atb bot.v_attribute)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_atb.cube_id := 'ATB-' || TO_CHAR(NEXTVAL('bot.sq_atb'),'FM000000000000');
		p_atb.fk_bot_name := COALESCE(p_atb.fk_bot_name,' ');
		p_atb.fk_typ_name := COALESCE(p_atb.fk_typ_name,' ');
		p_atb.name := COALESCE(p_atb.name,' ');
		p_atb.xk_itp_name := COALESCE(p_atb.xk_itp_name,' ');
		SELECT fk_bot_name
		  INTO p_atb.fk_bot_name
		FROM bot.t_type
		WHERE name = p_atb.fk_typ_name;
		INSERT INTO bot.t_attribute (
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
			p_atb.cube_id,
			p_atb.cube_sequence,
			p_atb.fk_bot_name,
			p_atb.fk_typ_name,
			p_atb.name,
			p_atb.primary_key,
			p_atb.code_display_key,
			p_atb.code_foreign_key,
			p_atb.flag_hidden,
			p_atb.default_value,
			p_atb.unchangeable,
			p_atb.xk_itp_name);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_atb (p_cube_ctid TID, p_atb_old bot.v_attribute, p_atb_new bot.v_attribute)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_attribute SET 
			cube_sequence = p_atb_new.cube_sequence,
			primary_key = p_atb_new.primary_key,
			code_display_key = p_atb_new.code_display_key,
			code_foreign_key = p_atb_new.code_foreign_key,
			flag_hidden = p_atb_new.flag_hidden,
			default_value = p_atb_new.default_value,
			unchangeable = p_atb_new.unchangeable,
			xk_itp_name = p_atb_new.xk_itp_name
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_atb (p_cube_ctid TID, p_atb bot.v_attribute)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_attribute 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_der (p_der bot.v_derivation)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_der.cube_id := 'DER-' || TO_CHAR(NEXTVAL('bot.sq_der'),'FM000000000000');
		p_der.fk_bot_name := COALESCE(p_der.fk_bot_name,' ');
		p_der.fk_typ_name := COALESCE(p_der.fk_typ_name,' ');
		p_der.fk_atb_name := COALESCE(p_der.fk_atb_name,' ');
		p_der.xk_typ_name := COALESCE(p_der.xk_typ_name,' ');
		p_der.xk_typ_name_1 := COALESCE(p_der.xk_typ_name_1,' ');
		SELECT fk_bot_name
		  INTO p_der.fk_bot_name
		FROM bot.t_attribute
		WHERE fk_typ_name = p_der.fk_typ_name
		  AND name = p_der.fk_atb_name;
		INSERT INTO bot.t_derivation (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_atb_name,
			cube_tsg_type,
			aggregate_function,
			xk_typ_name,
			xk_typ_name_1)
		VALUES (
			p_der.cube_id,
			p_der.fk_bot_name,
			p_der.fk_typ_name,
			p_der.fk_atb_name,
			p_der.cube_tsg_type,
			p_der.aggregate_function,
			p_der.xk_typ_name,
			p_der.xk_typ_name_1);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_der (p_cube_ctid TID, p_der_old bot.v_derivation, p_der_new bot.v_derivation)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_derivation SET 
			aggregate_function = p_der_new.aggregate_function,
			xk_typ_name = p_der_new.xk_typ_name,
			xk_typ_name_1 = p_der_new.xk_typ_name_1
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_der (p_cube_ctid TID, p_der bot.v_derivation)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_derivation 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_dca (p_dca bot.v_description_attribute)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_dca.cube_id := 'DCA-' || TO_CHAR(NEXTVAL('bot.sq_dca'),'FM000000000000');
		p_dca.fk_bot_name := COALESCE(p_dca.fk_bot_name,' ');
		p_dca.fk_typ_name := COALESCE(p_dca.fk_typ_name,' ');
		p_dca.fk_atb_name := COALESCE(p_dca.fk_atb_name,' ');
		SELECT fk_bot_name
		  INTO p_dca.fk_bot_name
		FROM bot.t_attribute
		WHERE fk_typ_name = p_dca.fk_typ_name
		  AND name = p_dca.fk_atb_name;
		INSERT INTO bot.t_description_attribute (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_atb_name,
			text)
		VALUES (
			p_dca.cube_id,
			p_dca.fk_bot_name,
			p_dca.fk_typ_name,
			p_dca.fk_atb_name,
			p_dca.text);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_dca (p_cube_ctid TID, p_dca_old bot.v_description_attribute, p_dca_new bot.v_description_attribute)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_description_attribute SET 
			text = p_dca_new.text
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_dca (p_cube_ctid TID, p_dca bot.v_description_attribute)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_description_attribute 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_rta (p_rta bot.v_restriction_type_spec_atb)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_rta.cube_id := 'RTA-' || TO_CHAR(NEXTVAL('bot.sq_rta'),'FM000000000000');
		p_rta.fk_bot_name := COALESCE(p_rta.fk_bot_name,' ');
		p_rta.fk_typ_name := COALESCE(p_rta.fk_typ_name,' ');
		p_rta.fk_atb_name := COALESCE(p_rta.fk_atb_name,' ');
		p_rta.xf_tsp_typ_name := COALESCE(p_rta.xf_tsp_typ_name,' ');
		p_rta.xf_tsp_tsg_code := COALESCE(p_rta.xf_tsp_tsg_code,' ');
		p_rta.xk_tsp_code := COALESCE(p_rta.xk_tsp_code,' ');
		SELECT fk_bot_name
		  INTO p_rta.fk_bot_name
		FROM bot.t_attribute
		WHERE fk_typ_name = p_rta.fk_typ_name
		  AND name = p_rta.fk_atb_name;
		INSERT INTO bot.t_restriction_type_spec_atb (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_atb_name,
			include_or_exclude,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			p_rta.cube_id,
			p_rta.fk_bot_name,
			p_rta.fk_typ_name,
			p_rta.fk_atb_name,
			p_rta.include_or_exclude,
			p_rta.xf_tsp_typ_name,
			p_rta.xf_tsp_tsg_code,
			p_rta.xk_tsp_code);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_rta (p_cube_ctid TID, p_rta_old bot.v_restriction_type_spec_atb, p_rta_new bot.v_restriction_type_spec_atb)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_restriction_type_spec_atb SET 
			include_or_exclude = p_rta_new.include_or_exclude
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_rta (p_cube_ctid TID, p_rta bot.v_restriction_type_spec_atb)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_restriction_type_spec_atb 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_ref (p_ref bot.v_reference)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_ref.cube_id := 'REF-' || TO_CHAR(NEXTVAL('bot.sq_ref'),'FM000000000000');
		p_ref.fk_bot_name := COALESCE(p_ref.fk_bot_name,' ');
		p_ref.fk_typ_name := COALESCE(p_ref.fk_typ_name,' ');
		p_ref.sequence := COALESCE(p_ref.sequence,0);
		p_ref.xk_bot_name := COALESCE(p_ref.xk_bot_name,' ');
		p_ref.xk_typ_name := COALESCE(p_ref.xk_typ_name,' ');
		p_ref.xk_typ_name_1 := COALESCE(p_ref.xk_typ_name_1,' ');
		SELECT fk_bot_name
		  INTO p_ref.fk_bot_name
		FROM bot.t_type
		WHERE name = p_ref.fk_typ_name;
		INSERT INTO bot.t_reference (
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
			p_ref.cube_id,
			p_ref.cube_sequence,
			p_ref.fk_bot_name,
			p_ref.fk_typ_name,
			p_ref.name,
			p_ref.primary_key,
			p_ref.code_display_key,
			p_ref.sequence,
			p_ref.scope,
			p_ref.unchangeable,
			p_ref.within_scope_extension,
			p_ref.cube_tsg_int_ext,
			p_ref.xk_bot_name,
			p_ref.xk_typ_name,
			p_ref.xk_typ_name_1);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_ref (p_cube_ctid TID, p_ref_old bot.v_reference, p_ref_new bot.v_reference)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_reference SET 
			cube_sequence = p_ref_new.cube_sequence,
			name = p_ref_new.name,
			primary_key = p_ref_new.primary_key,
			code_display_key = p_ref_new.code_display_key,
			scope = p_ref_new.scope,
			unchangeable = p_ref_new.unchangeable,
			within_scope_extension = p_ref_new.within_scope_extension,
			xk_typ_name_1 = p_ref_new.xk_typ_name_1
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_ref (p_cube_ctid TID, p_ref bot.v_reference)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_reference 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_dcr (p_dcr bot.v_description_reference)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_dcr.cube_id := 'DCR-' || TO_CHAR(NEXTVAL('bot.sq_dcr'),'FM000000000000');
		p_dcr.fk_bot_name := COALESCE(p_dcr.fk_bot_name,' ');
		p_dcr.fk_typ_name := COALESCE(p_dcr.fk_typ_name,' ');
		p_dcr.fk_ref_sequence := COALESCE(p_dcr.fk_ref_sequence,0);
		p_dcr.fk_ref_bot_name := COALESCE(p_dcr.fk_ref_bot_name,' ');
		p_dcr.fk_ref_typ_name := COALESCE(p_dcr.fk_ref_typ_name,' ');
		SELECT fk_bot_name
		  INTO p_dcr.fk_bot_name
		FROM bot.t_reference
		WHERE fk_typ_name = p_dcr.fk_typ_name
		  AND sequence = p_dcr.fk_ref_sequence
		  AND xk_bot_name = p_dcr.fk_ref_bot_name
		  AND xk_typ_name = p_dcr.fk_ref_typ_name;
		INSERT INTO bot.t_description_reference (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_bot_name,
			fk_ref_typ_name,
			text)
		VALUES (
			p_dcr.cube_id,
			p_dcr.fk_bot_name,
			p_dcr.fk_typ_name,
			p_dcr.fk_ref_sequence,
			p_dcr.fk_ref_bot_name,
			p_dcr.fk_ref_typ_name,
			p_dcr.text);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_dcr (p_cube_ctid TID, p_dcr_old bot.v_description_reference, p_dcr_new bot.v_description_reference)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_description_reference SET 
			text = p_dcr_new.text
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_dcr (p_cube_ctid TID, p_dcr bot.v_description_reference)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_description_reference 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_rtr (p_rtr bot.v_restriction_type_spec_ref)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_rtr.cube_id := 'RTR-' || TO_CHAR(NEXTVAL('bot.sq_rtr'),'FM000000000000');
		p_rtr.fk_bot_name := COALESCE(p_rtr.fk_bot_name,' ');
		p_rtr.fk_typ_name := COALESCE(p_rtr.fk_typ_name,' ');
		p_rtr.fk_ref_sequence := COALESCE(p_rtr.fk_ref_sequence,0);
		p_rtr.fk_ref_bot_name := COALESCE(p_rtr.fk_ref_bot_name,' ');
		p_rtr.fk_ref_typ_name := COALESCE(p_rtr.fk_ref_typ_name,' ');
		p_rtr.xf_tsp_typ_name := COALESCE(p_rtr.xf_tsp_typ_name,' ');
		p_rtr.xf_tsp_tsg_code := COALESCE(p_rtr.xf_tsp_tsg_code,' ');
		p_rtr.xk_tsp_code := COALESCE(p_rtr.xk_tsp_code,' ');
		SELECT fk_bot_name
		  INTO p_rtr.fk_bot_name
		FROM bot.t_reference
		WHERE fk_typ_name = p_rtr.fk_typ_name
		  AND sequence = p_rtr.fk_ref_sequence
		  AND xk_bot_name = p_rtr.fk_ref_bot_name
		  AND xk_typ_name = p_rtr.fk_ref_typ_name;
		INSERT INTO bot.t_restriction_type_spec_ref (
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
			p_rtr.cube_id,
			p_rtr.fk_bot_name,
			p_rtr.fk_typ_name,
			p_rtr.fk_ref_sequence,
			p_rtr.fk_ref_bot_name,
			p_rtr.fk_ref_typ_name,
			p_rtr.include_or_exclude,
			p_rtr.xf_tsp_typ_name,
			p_rtr.xf_tsp_tsg_code,
			p_rtr.xk_tsp_code);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_rtr (p_cube_ctid TID, p_rtr_old bot.v_restriction_type_spec_ref, p_rtr_new bot.v_restriction_type_spec_ref)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_restriction_type_spec_ref SET 
			include_or_exclude = p_rtr_new.include_or_exclude
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_rtr (p_cube_ctid TID, p_rtr bot.v_restriction_type_spec_ref)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_restriction_type_spec_ref 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_rts (p_rts bot.v_restriction_target_type_spec)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_rts.cube_id := 'RTS-' || TO_CHAR(NEXTVAL('bot.sq_rts'),'FM000000000000');
		p_rts.fk_bot_name := COALESCE(p_rts.fk_bot_name,' ');
		p_rts.fk_typ_name := COALESCE(p_rts.fk_typ_name,' ');
		p_rts.fk_ref_sequence := COALESCE(p_rts.fk_ref_sequence,0);
		p_rts.fk_ref_bot_name := COALESCE(p_rts.fk_ref_bot_name,' ');
		p_rts.fk_ref_typ_name := COALESCE(p_rts.fk_ref_typ_name,' ');
		p_rts.xf_tsp_typ_name := COALESCE(p_rts.xf_tsp_typ_name,' ');
		p_rts.xf_tsp_tsg_code := COALESCE(p_rts.xf_tsp_tsg_code,' ');
		p_rts.xk_tsp_code := COALESCE(p_rts.xk_tsp_code,' ');
		SELECT fk_bot_name
		  INTO p_rts.fk_bot_name
		FROM bot.t_reference
		WHERE fk_typ_name = p_rts.fk_typ_name
		  AND sequence = p_rts.fk_ref_sequence
		  AND xk_bot_name = p_rts.fk_ref_bot_name
		  AND xk_typ_name = p_rts.fk_ref_typ_name;
		INSERT INTO bot.t_restriction_target_type_spec (
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
			p_rts.cube_id,
			p_rts.fk_bot_name,
			p_rts.fk_typ_name,
			p_rts.fk_ref_sequence,
			p_rts.fk_ref_bot_name,
			p_rts.fk_ref_typ_name,
			p_rts.include_or_exclude,
			p_rts.xf_tsp_typ_name,
			p_rts.xf_tsp_tsg_code,
			p_rts.xk_tsp_code);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_rts (p_cube_ctid TID, p_rts_old bot.v_restriction_target_type_spec, p_rts_new bot.v_restriction_target_type_spec)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_restriction_target_type_spec SET 
			include_or_exclude = p_rts_new.include_or_exclude
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_rts (p_cube_ctid TID, p_rts bot.v_restriction_target_type_spec)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_restriction_target_type_spec 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_rtt (p_rtt bot.v_restriction_type_spec_typ)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_rtt.cube_id := 'RTT-' || TO_CHAR(NEXTVAL('bot.sq_rtt'),'FM000000000000');
		p_rtt.fk_bot_name := COALESCE(p_rtt.fk_bot_name,' ');
		p_rtt.fk_typ_name := COALESCE(p_rtt.fk_typ_name,' ');
		p_rtt.xf_tsp_typ_name := COALESCE(p_rtt.xf_tsp_typ_name,' ');
		p_rtt.xf_tsp_tsg_code := COALESCE(p_rtt.xf_tsp_tsg_code,' ');
		p_rtt.xk_tsp_code := COALESCE(p_rtt.xk_tsp_code,' ');
		SELECT fk_bot_name
		  INTO p_rtt.fk_bot_name
		FROM bot.t_type
		WHERE name = p_rtt.fk_typ_name;
		INSERT INTO bot.t_restriction_type_spec_typ (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			include_or_exclude,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			p_rtt.cube_id,
			p_rtt.fk_bot_name,
			p_rtt.fk_typ_name,
			p_rtt.include_or_exclude,
			p_rtt.xf_tsp_typ_name,
			p_rtt.xf_tsp_tsg_code,
			p_rtt.xk_tsp_code);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_rtt (p_cube_ctid TID, p_rtt_old bot.v_restriction_type_spec_typ, p_rtt_new bot.v_restriction_type_spec_typ)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_restriction_type_spec_typ SET 
			include_or_exclude = p_rtt_new.include_or_exclude
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_rtt (p_cube_ctid TID, p_rtt bot.v_restriction_type_spec_typ)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_restriction_type_spec_typ 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_jsn (p_jsn bot.v_json_path)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_jsn.cube_id := 'JSN-' || TO_CHAR(NEXTVAL('bot.sq_jsn'),'FM000000000000');
		p_jsn.fk_bot_name := COALESCE(p_jsn.fk_bot_name,' ');
		p_jsn.fk_typ_name := COALESCE(p_jsn.fk_typ_name,' ');
		p_jsn.name := COALESCE(p_jsn.name,' ');
		p_jsn.location := COALESCE(p_jsn.location,0);
		p_jsn.xf_atb_typ_name := COALESCE(p_jsn.xf_atb_typ_name,' ');
		p_jsn.xk_atb_name := COALESCE(p_jsn.xk_atb_name,' ');
		p_jsn.xk_typ_name := COALESCE(p_jsn.xk_typ_name,' ');
		IF p_jsn.fk_jsn_name IS NOT NULL OR p_jsn.fk_jsn_location IS NOT NULL OR p_jsn.fk_jsn_atb_typ_name IS NOT NULL OR p_jsn.fk_jsn_atb_name IS NOT NULL OR p_jsn.fk_jsn_typ_name IS NOT NULL THEN
			-- Recursive
			SELECT fk_bot_name
			  INTO p_jsn.fk_bot_name
			FROM bot.t_json_path
			WHERE fk_typ_name = p_jsn.fk_typ_name
			  AND name = p_jsn.fk_jsn_name
			  AND location = p_jsn.fk_jsn_location
			  AND xf_atb_typ_name = p_jsn.fk_jsn_atb_typ_name
			  AND xk_atb_name = p_jsn.fk_jsn_atb_name
			  AND xk_typ_name = p_jsn.fk_jsn_typ_name;
			ELSE
			-- Parent
			SELECT fk_bot_name
			  INTO p_jsn.fk_bot_name
			FROM bot.t_type
			WHERE name = p_jsn.fk_typ_name;
			
		END IF;
		CALL bot.trg_get_denorm_jsn_jsn (p_jsn);
		INSERT INTO bot.t_json_path (
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
			p_jsn.cube_id,
			p_jsn.cube_sequence,
			p_jsn.cube_level,
			p_jsn.fk_bot_name,
			p_jsn.fk_typ_name,
			p_jsn.fk_jsn_name,
			p_jsn.fk_jsn_location,
			p_jsn.fk_jsn_atb_typ_name,
			p_jsn.fk_jsn_atb_name,
			p_jsn.fk_jsn_typ_name,
			p_jsn.cube_tsg_obj_arr,
			p_jsn.cube_tsg_type,
			p_jsn.name,
			p_jsn.location,
			p_jsn.xf_atb_typ_name,
			p_jsn.xk_atb_name,
			p_jsn.xk_typ_name);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_jsn (p_cube_ctid TID, p_jsn_old bot.v_json_path, p_jsn_new bot.v_json_path)
LANGUAGE plpgsql
AS $BODY$
	DECLARE
		c_jsn CURSOR FOR
			SELECT CTID cube_ctid, jsn.* FROM bot.v_json_path jsn
			WHERE fk_typ_name = p_jsn_old.fk_typ_name
			  AND fk_jsn_name = p_jsn_old.name
			  AND fk_jsn_location = p_jsn_old.location
			  AND fk_jsn_atb_typ_name = p_jsn_old.xf_atb_typ_name
			  AND fk_jsn_atb_name = p_jsn_old.xk_atb_name
			  AND fk_jsn_typ_name = p_jsn_old.xk_typ_name;
		
		l_jsn_ctid TID;
		r_jsn_old bot.v_json_path%ROWTYPE;
		r_jsn_new bot.v_json_path%ROWTYPE;
	BEGIN
		IF COALESCE(p_jsn_old.fk_jsn_name,' ') <> COALESCE(p_jsn_new.fk_jsn_name,' ') 
		OR COALESCE(p_jsn_old.fk_jsn_location,0) <> COALESCE(p_jsn_new.fk_jsn_location,0) 
		OR COALESCE(p_jsn_old.fk_jsn_atb_typ_name,' ') <> COALESCE(p_jsn_new.fk_jsn_atb_typ_name,' ') 
		OR COALESCE(p_jsn_old.fk_jsn_atb_name,' ') <> COALESCE(p_jsn_new.fk_jsn_atb_name,' ') 
		OR COALESCE(p_jsn_old.fk_jsn_typ_name,' ') <> COALESCE(p_jsn_new.fk_jsn_typ_name,' ')  THEN
			CALL bot.trg_get_denorm_jsn_jsn (p_jsn_new);
		END IF;
		UPDATE bot.t_json_path SET 
			cube_sequence = p_jsn_new.cube_sequence,
			cube_level = p_jsn_new.cube_level,
			fk_jsn_name = p_jsn_new.fk_jsn_name,
			fk_jsn_location = p_jsn_new.fk_jsn_location,
			fk_jsn_atb_typ_name = p_jsn_new.fk_jsn_atb_typ_name,
			fk_jsn_atb_name = p_jsn_new.fk_jsn_atb_name,
			fk_jsn_typ_name = p_jsn_new.fk_jsn_typ_name
		WHERE ctid = p_cube_ctid;
		IF COALESCE(p_jsn_old.cube_level,0) <> COALESCE(p_jsn_new.cube_level,0) THEN
			OPEN c_jsn;
			LOOP
				FETCH c_jsn INTO
					l_jsn_ctid,
					r_jsn_old.cube_id,
					r_jsn_old.cube_sequence,
					r_jsn_old.cube_level,
					r_jsn_old.fk_bot_name,
					r_jsn_old.fk_typ_name,
					r_jsn_old.fk_jsn_name,
					r_jsn_old.fk_jsn_location,
					r_jsn_old.fk_jsn_atb_typ_name,
					r_jsn_old.fk_jsn_atb_name,
					r_jsn_old.fk_jsn_typ_name,
					r_jsn_old.cube_tsg_obj_arr,
					r_jsn_old.cube_tsg_type,
					r_jsn_old.name,
					r_jsn_old.location,
					r_jsn_old.xf_atb_typ_name,
					r_jsn_old.xk_atb_name,
					r_jsn_old.xk_typ_name;
				EXIT WHEN NOT FOUND;
				r_jsn_new := r_jsn_old;
				CALL bot.trg_denorm_jsn_jsn (r_jsn_new, p_jsn_new);
				CALL bot.trg_update_jsn (l_jsn_ctid, r_jsn_old, r_jsn_new);
			END LOOP;
			CLOSE c_jsn;
		END IF;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_jsn (p_cube_ctid TID, p_jsn bot.v_json_path)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_json_path 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_denorm_jsn_jsn (p_jsn bot.v_json_path, p_jsn_in bot.v_json_path)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_jsn.cube_level := COALESCE (p_jsn_in.cube_level, 0) + 1;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_get_denorm_jsn_jsn (p_jsn bot.v_json_path)
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		c_jsn CURSOR FOR 
			SELECT * FROM bot.v_json_path
			WHERE fk_typ_name = p_jsn.fk_typ_name
			  AND name = p_jsn.fk_jsn_name
			  AND location = p_jsn.fk_jsn_location
			  AND xf_atb_typ_name = p_jsn.fk_jsn_atb_typ_name
			  AND xk_atb_name = p_jsn.fk_jsn_atb_name
			  AND xk_typ_name = p_jsn.fk_jsn_typ_name;
		
		r_jsn bot.v_json_path%ROWTYPE;
	BEGIN
		IF p_jsn.fk_jsn_name IS NOT NULL AND p_jsn.fk_jsn_location IS NOT NULL AND p_jsn.fk_jsn_atb_typ_name IS NOT NULL AND p_jsn.fk_jsn_atb_name IS NOT NULL AND p_jsn.fk_jsn_typ_name IS NOT NULL THEN
			OPEN c_jsn;
			FETCH c_jsn INTO r_jsn;
			IF NOT FOUND THEN
				r_jsn := NULL;
			END IF;
			CLOSE c_jsn;
		ELSE
			r_jsn := NULL;
		END IF;
		CALL bot.trg_denorm_jsn_jsn (p_jsn, r_jsn);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_insert_dct (p_dct bot.v_description_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_dct.cube_id := 'DCT-' || TO_CHAR(NEXTVAL('bot.sq_dct'),'FM000000000000');
		p_dct.fk_bot_name := COALESCE(p_dct.fk_bot_name,' ');
		p_dct.fk_typ_name := COALESCE(p_dct.fk_typ_name,' ');
		SELECT fk_bot_name
		  INTO p_dct.fk_bot_name
		FROM bot.t_type
		WHERE name = p_dct.fk_typ_name;
		INSERT INTO bot.t_description_type (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			text)
		VALUES (
			p_dct.cube_id,
			p_dct.fk_bot_name,
			p_dct.fk_typ_name,
			p_dct.text);
	END;
$BODY$;

CREATE PROCEDURE bot.trg_update_dct (p_cube_ctid TID, p_dct_old bot.v_description_type, p_dct_new bot.v_description_type)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE bot.t_description_type SET 
			text = p_dct_new.text
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE bot.trg_delete_dct (p_cube_ctid TID, p_dct bot.v_description_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM bot.t_description_type 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE FUNCTION bot.trg_bot() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_bot_new bot.v_business_object_type%ROWTYPE;
		r_bot_old bot.v_business_object_type%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			r_bot_new.cube_sequence := NEW.cube_sequence;
			IF NEW.name = ' ' THEN
				r_bot_new.name := ' ';
			ELSE
				r_bot_new.name := REPLACE(NEW.name,' ','_');
			END IF;
			r_bot_new.name := UPPER(r_bot_new.name);
			IF NEW.cube_tsg_type = ' ' THEN
				r_bot_new.cube_tsg_type := ' ';
			ELSE
				r_bot_new.cube_tsg_type := REPLACE(NEW.cube_tsg_type,' ','_');
			END IF;
			IF NEW.directory = ' ' THEN
				r_bot_new.directory := ' ';
			ELSE
				r_bot_new.directory := REPLACE(NEW.directory,' ','_');
			END IF;
			IF NEW.api_url = ' ' THEN
				r_bot_new.api_url := ' ';
			ELSE
				r_bot_new.api_url := REPLACE(NEW.api_url,' ','_');
			END IF;
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_bot_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_business_object_type
			WHERE name = OLD.name;
			r_bot_old.cube_sequence := OLD.cube_sequence;
			r_bot_old.name := OLD.name;
			r_bot_old.cube_tsg_type := OLD.cube_tsg_type;
			r_bot_old.directory := OLD.directory;
			r_bot_old.api_url := OLD.api_url;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_bot (r_bot_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_bot (l_cube_ctid, r_bot_old, r_bot_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_bot (l_cube_ctid, r_bot_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_bot
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_business_object_type
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_bot();

CREATE FUNCTION bot.trg_typ() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_typ_new bot.v_type%ROWTYPE;
		r_typ_old bot.v_type%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			r_typ_new.cube_sequence := NEW.cube_sequence;
			IF NEW.fk_bot_name = ' ' THEN
				r_typ_new.fk_bot_name := ' ';
			ELSE
				r_typ_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_typ_new.fk_bot_name := UPPER(r_typ_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_typ_new.fk_typ_name := ' ';
			ELSE
				r_typ_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_typ_new.fk_typ_name := UPPER(r_typ_new.fk_typ_name);
			IF NEW.name = ' ' THEN
				r_typ_new.name := ' ';
			ELSE
				r_typ_new.name := REPLACE(NEW.name,' ','_');
			END IF;
			r_typ_new.name := UPPER(r_typ_new.name);
			IF NEW.code = ' ' THEN
				r_typ_new.code := ' ';
			ELSE
				r_typ_new.code := REPLACE(NEW.code,' ','_');
			END IF;
			r_typ_new.code := UPPER(r_typ_new.code);
			r_typ_new.flag_partial_key := NEW.flag_partial_key;
			r_typ_new.flag_recursive := NEW.flag_recursive;
			r_typ_new.recursive_cardinality := UPPER(NEW.recursive_cardinality);
			r_typ_new.cardinality := UPPER(NEW.cardinality);
			r_typ_new.sort_order := NEW.sort_order;
			IF NEW.icon = ' ' THEN
				r_typ_new.icon := ' ';
			ELSE
				r_typ_new.icon := REPLACE(NEW.icon,' ','_');
			END IF;
			r_typ_new.icon := UPPER(r_typ_new.icon);
			r_typ_new.transferable := NEW.transferable;
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_typ_new.cube_id := OLD.cube_id;
			r_typ_new.cube_level := OLD.cube_level;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_type
			WHERE name = OLD.name;
			r_typ_old.cube_sequence := OLD.cube_sequence;
			r_typ_old.fk_bot_name := OLD.fk_bot_name;
			r_typ_old.fk_typ_name := OLD.fk_typ_name;
			r_typ_old.name := OLD.name;
			r_typ_old.code := OLD.code;
			r_typ_old.flag_partial_key := OLD.flag_partial_key;
			r_typ_old.flag_recursive := OLD.flag_recursive;
			r_typ_old.recursive_cardinality := OLD.recursive_cardinality;
			r_typ_old.cardinality := OLD.cardinality;
			r_typ_old.sort_order := OLD.sort_order;
			r_typ_old.icon := OLD.icon;
			r_typ_old.transferable := OLD.transferable;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_typ (r_typ_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_typ (l_cube_ctid, r_typ_old, r_typ_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_typ (l_cube_ctid, r_typ_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_typ
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_type
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_typ();

CREATE FUNCTION bot.trg_tsg() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_tsg_new bot.v_type_specialisation_group%ROWTYPE;
		r_tsg_old bot.v_type_specialisation_group%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			r_tsg_new.cube_sequence := NEW.cube_sequence;
			IF NEW.fk_bot_name = ' ' THEN
				r_tsg_new.fk_bot_name := ' ';
			ELSE
				r_tsg_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_tsg_new.fk_bot_name := UPPER(r_tsg_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_tsg_new.fk_typ_name := ' ';
			ELSE
				r_tsg_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_tsg_new.fk_typ_name := UPPER(r_tsg_new.fk_typ_name);
			IF NEW.fk_tsg_code = ' ' THEN
				r_tsg_new.fk_tsg_code := ' ';
			ELSE
				r_tsg_new.fk_tsg_code := REPLACE(NEW.fk_tsg_code,' ','_');
			END IF;
			r_tsg_new.fk_tsg_code := UPPER(r_tsg_new.fk_tsg_code);
			IF NEW.code = ' ' THEN
				r_tsg_new.code := ' ';
			ELSE
				r_tsg_new.code := REPLACE(NEW.code,' ','_');
			END IF;
			r_tsg_new.code := UPPER(r_tsg_new.code);
			IF NEW.name = ' ' THEN
				r_tsg_new.name := ' ';
			ELSE
				r_tsg_new.name := REPLACE(NEW.name,' ','_');
			END IF;
			r_tsg_new.name := UPPER(r_tsg_new.name);
			r_tsg_new.primary_key := NEW.primary_key;
			IF NEW.xf_atb_typ_name = ' ' THEN
				r_tsg_new.xf_atb_typ_name := ' ';
			ELSE
				r_tsg_new.xf_atb_typ_name := REPLACE(NEW.xf_atb_typ_name,' ','_');
			END IF;
			r_tsg_new.xf_atb_typ_name := UPPER(r_tsg_new.xf_atb_typ_name);
			IF NEW.xk_atb_name = ' ' THEN
				r_tsg_new.xk_atb_name := ' ';
			ELSE
				r_tsg_new.xk_atb_name := REPLACE(NEW.xk_atb_name,' ','_');
			END IF;
			r_tsg_new.xk_atb_name := UPPER(r_tsg_new.xk_atb_name);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_tsg_new.cube_id := OLD.cube_id;
			r_tsg_new.cube_level := OLD.cube_level;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_type_specialisation_group
			WHERE fk_typ_name = OLD.fk_typ_name
			AND code = OLD.code;
			r_tsg_old.cube_sequence := OLD.cube_sequence;
			r_tsg_old.fk_bot_name := OLD.fk_bot_name;
			r_tsg_old.fk_typ_name := OLD.fk_typ_name;
			r_tsg_old.fk_tsg_code := OLD.fk_tsg_code;
			r_tsg_old.code := OLD.code;
			r_tsg_old.name := OLD.name;
			r_tsg_old.primary_key := OLD.primary_key;
			r_tsg_old.xf_atb_typ_name := OLD.xf_atb_typ_name;
			r_tsg_old.xk_atb_name := OLD.xk_atb_name;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_tsg (r_tsg_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_tsg (l_cube_ctid, r_tsg_old, r_tsg_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_tsg (l_cube_ctid, r_tsg_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_tsg
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_type_specialisation_group
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_tsg();

CREATE FUNCTION bot.trg_tsp() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_tsp_new bot.v_type_specialisation%ROWTYPE;
		r_tsp_old bot.v_type_specialisation%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			r_tsp_new.cube_sequence := NEW.cube_sequence;
			IF NEW.fk_bot_name = ' ' THEN
				r_tsp_new.fk_bot_name := ' ';
			ELSE
				r_tsp_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_tsp_new.fk_bot_name := UPPER(r_tsp_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_tsp_new.fk_typ_name := ' ';
			ELSE
				r_tsp_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_tsp_new.fk_typ_name := UPPER(r_tsp_new.fk_typ_name);
			IF NEW.fk_tsg_code = ' ' THEN
				r_tsp_new.fk_tsg_code := ' ';
			ELSE
				r_tsp_new.fk_tsg_code := REPLACE(NEW.fk_tsg_code,' ','_');
			END IF;
			r_tsp_new.fk_tsg_code := UPPER(r_tsp_new.fk_tsg_code);
			IF NEW.code = ' ' THEN
				r_tsp_new.code := ' ';
			ELSE
				r_tsp_new.code := REPLACE(NEW.code,' ','_');
			END IF;
			r_tsp_new.code := UPPER(r_tsp_new.code);
			IF NEW.name = ' ' THEN
				r_tsp_new.name := ' ';
			ELSE
				r_tsp_new.name := REPLACE(NEW.name,' ','_');
			END IF;
			r_tsp_new.name := UPPER(r_tsp_new.name);
			IF NEW.xf_tsp_typ_name = ' ' THEN
				r_tsp_new.xf_tsp_typ_name := ' ';
			ELSE
				r_tsp_new.xf_tsp_typ_name := REPLACE(NEW.xf_tsp_typ_name,' ','_');
			END IF;
			r_tsp_new.xf_tsp_typ_name := UPPER(r_tsp_new.xf_tsp_typ_name);
			IF NEW.xf_tsp_tsg_code = ' ' THEN
				r_tsp_new.xf_tsp_tsg_code := ' ';
			ELSE
				r_tsp_new.xf_tsp_tsg_code := REPLACE(NEW.xf_tsp_tsg_code,' ','_');
			END IF;
			r_tsp_new.xf_tsp_tsg_code := UPPER(r_tsp_new.xf_tsp_tsg_code);
			IF NEW.xk_tsp_code = ' ' THEN
				r_tsp_new.xk_tsp_code := ' ';
			ELSE
				r_tsp_new.xk_tsp_code := REPLACE(NEW.xk_tsp_code,' ','_');
			END IF;
			r_tsp_new.xk_tsp_code := UPPER(r_tsp_new.xk_tsp_code);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_tsp_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_type_specialisation
			WHERE fk_typ_name = OLD.fk_typ_name
			AND fk_tsg_code = OLD.fk_tsg_code
			AND code = OLD.code;
			r_tsp_old.cube_sequence := OLD.cube_sequence;
			r_tsp_old.fk_bot_name := OLD.fk_bot_name;
			r_tsp_old.fk_typ_name := OLD.fk_typ_name;
			r_tsp_old.fk_tsg_code := OLD.fk_tsg_code;
			r_tsp_old.code := OLD.code;
			r_tsp_old.name := OLD.name;
			r_tsp_old.xf_tsp_typ_name := OLD.xf_tsp_typ_name;
			r_tsp_old.xf_tsp_tsg_code := OLD.xf_tsp_tsg_code;
			r_tsp_old.xk_tsp_code := OLD.xk_tsp_code;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_tsp (r_tsp_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_tsp (l_cube_ctid, r_tsp_old, r_tsp_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_tsp (l_cube_ctid, r_tsp_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_tsp
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_type_specialisation
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_tsp();

CREATE FUNCTION bot.trg_atb() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_atb_new bot.v_attribute%ROWTYPE;
		r_atb_old bot.v_attribute%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			r_atb_new.cube_sequence := NEW.cube_sequence;
			IF NEW.fk_bot_name = ' ' THEN
				r_atb_new.fk_bot_name := ' ';
			ELSE
				r_atb_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_atb_new.fk_bot_name := UPPER(r_atb_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_atb_new.fk_typ_name := ' ';
			ELSE
				r_atb_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_atb_new.fk_typ_name := UPPER(r_atb_new.fk_typ_name);
			IF NEW.name = ' ' THEN
				r_atb_new.name := ' ';
			ELSE
				r_atb_new.name := REPLACE(NEW.name,' ','_');
			END IF;
			r_atb_new.name := UPPER(r_atb_new.name);
			r_atb_new.primary_key := NEW.primary_key;
			IF NEW.code_display_key = ' ' THEN
				r_atb_new.code_display_key := ' ';
			ELSE
				r_atb_new.code_display_key := REPLACE(NEW.code_display_key,' ','_');
			END IF;
			r_atb_new.code_display_key := UPPER(r_atb_new.code_display_key);
			r_atb_new.code_foreign_key := NEW.code_foreign_key;
			r_atb_new.flag_hidden := NEW.flag_hidden;
			r_atb_new.default_value := NEW.default_value;
			r_atb_new.unchangeable := NEW.unchangeable;
			IF NEW.xk_itp_name = ' ' THEN
				r_atb_new.xk_itp_name := ' ';
			ELSE
				r_atb_new.xk_itp_name := REPLACE(NEW.xk_itp_name,' ','_');
			END IF;
			r_atb_new.xk_itp_name := UPPER(r_atb_new.xk_itp_name);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_atb_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_attribute
			WHERE fk_typ_name = OLD.fk_typ_name
			AND name = OLD.name;
			r_atb_old.cube_sequence := OLD.cube_sequence;
			r_atb_old.fk_bot_name := OLD.fk_bot_name;
			r_atb_old.fk_typ_name := OLD.fk_typ_name;
			r_atb_old.name := OLD.name;
			r_atb_old.primary_key := OLD.primary_key;
			r_atb_old.code_display_key := OLD.code_display_key;
			r_atb_old.code_foreign_key := OLD.code_foreign_key;
			r_atb_old.flag_hidden := OLD.flag_hidden;
			r_atb_old.default_value := OLD.default_value;
			r_atb_old.unchangeable := OLD.unchangeable;
			r_atb_old.xk_itp_name := OLD.xk_itp_name;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_atb (r_atb_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_atb (l_cube_ctid, r_atb_old, r_atb_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_atb (l_cube_ctid, r_atb_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_atb
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_attribute
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_atb();

CREATE FUNCTION bot.trg_der() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_der_new bot.v_derivation%ROWTYPE;
		r_der_old bot.v_derivation%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.fk_bot_name = ' ' THEN
				r_der_new.fk_bot_name := ' ';
			ELSE
				r_der_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_der_new.fk_bot_name := UPPER(r_der_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_der_new.fk_typ_name := ' ';
			ELSE
				r_der_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_der_new.fk_typ_name := UPPER(r_der_new.fk_typ_name);
			IF NEW.fk_atb_name = ' ' THEN
				r_der_new.fk_atb_name := ' ';
			ELSE
				r_der_new.fk_atb_name := REPLACE(NEW.fk_atb_name,' ','_');
			END IF;
			r_der_new.fk_atb_name := UPPER(r_der_new.fk_atb_name);
			IF NEW.cube_tsg_type = ' ' THEN
				r_der_new.cube_tsg_type := ' ';
			ELSE
				r_der_new.cube_tsg_type := REPLACE(NEW.cube_tsg_type,' ','_');
			END IF;
			IF NEW.aggregate_function = ' ' THEN
				r_der_new.aggregate_function := ' ';
			ELSE
				r_der_new.aggregate_function := REPLACE(NEW.aggregate_function,' ','_');
			END IF;
			r_der_new.aggregate_function := UPPER(r_der_new.aggregate_function);
			IF NEW.xk_typ_name = ' ' THEN
				r_der_new.xk_typ_name := ' ';
			ELSE
				r_der_new.xk_typ_name := REPLACE(NEW.xk_typ_name,' ','_');
			END IF;
			r_der_new.xk_typ_name := UPPER(r_der_new.xk_typ_name);
			IF NEW.xk_typ_name_1 = ' ' THEN
				r_der_new.xk_typ_name_1 := ' ';
			ELSE
				r_der_new.xk_typ_name_1 := REPLACE(NEW.xk_typ_name_1,' ','_');
			END IF;
			r_der_new.xk_typ_name_1 := UPPER(r_der_new.xk_typ_name_1);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_der_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_derivation
			WHERE fk_typ_name = OLD.fk_typ_name
			AND fk_atb_name = OLD.fk_atb_name;
			r_der_old.fk_bot_name := OLD.fk_bot_name;
			r_der_old.fk_typ_name := OLD.fk_typ_name;
			r_der_old.fk_atb_name := OLD.fk_atb_name;
			r_der_old.cube_tsg_type := OLD.cube_tsg_type;
			r_der_old.aggregate_function := OLD.aggregate_function;
			r_der_old.xk_typ_name := OLD.xk_typ_name;
			r_der_old.xk_typ_name_1 := OLD.xk_typ_name_1;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_der (r_der_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_der (l_cube_ctid, r_der_old, r_der_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_der (l_cube_ctid, r_der_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_der
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_derivation
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_der();

CREATE FUNCTION bot.trg_dca() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_dca_new bot.v_description_attribute%ROWTYPE;
		r_dca_old bot.v_description_attribute%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.fk_bot_name = ' ' THEN
				r_dca_new.fk_bot_name := ' ';
			ELSE
				r_dca_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_dca_new.fk_bot_name := UPPER(r_dca_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_dca_new.fk_typ_name := ' ';
			ELSE
				r_dca_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_dca_new.fk_typ_name := UPPER(r_dca_new.fk_typ_name);
			IF NEW.fk_atb_name = ' ' THEN
				r_dca_new.fk_atb_name := ' ';
			ELSE
				r_dca_new.fk_atb_name := REPLACE(NEW.fk_atb_name,' ','_');
			END IF;
			r_dca_new.fk_atb_name := UPPER(r_dca_new.fk_atb_name);
			r_dca_new.text := NEW.text;
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_dca_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_description_attribute
			WHERE fk_typ_name = OLD.fk_typ_name
			AND fk_atb_name = OLD.fk_atb_name;
			r_dca_old.fk_bot_name := OLD.fk_bot_name;
			r_dca_old.fk_typ_name := OLD.fk_typ_name;
			r_dca_old.fk_atb_name := OLD.fk_atb_name;
			r_dca_old.text := OLD.text;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_dca (r_dca_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_dca (l_cube_ctid, r_dca_old, r_dca_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_dca (l_cube_ctid, r_dca_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_dca
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_description_attribute
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_dca();

CREATE FUNCTION bot.trg_rta() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_rta_new bot.v_restriction_type_spec_atb%ROWTYPE;
		r_rta_old bot.v_restriction_type_spec_atb%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.fk_bot_name = ' ' THEN
				r_rta_new.fk_bot_name := ' ';
			ELSE
				r_rta_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_rta_new.fk_bot_name := UPPER(r_rta_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_rta_new.fk_typ_name := ' ';
			ELSE
				r_rta_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_rta_new.fk_typ_name := UPPER(r_rta_new.fk_typ_name);
			IF NEW.fk_atb_name = ' ' THEN
				r_rta_new.fk_atb_name := ' ';
			ELSE
				r_rta_new.fk_atb_name := REPLACE(NEW.fk_atb_name,' ','_');
			END IF;
			r_rta_new.fk_atb_name := UPPER(r_rta_new.fk_atb_name);
			IF NEW.include_or_exclude = ' ' THEN
				r_rta_new.include_or_exclude := ' ';
			ELSE
				r_rta_new.include_or_exclude := REPLACE(NEW.include_or_exclude,' ','_');
			END IF;
			r_rta_new.include_or_exclude := UPPER(r_rta_new.include_or_exclude);
			IF NEW.xf_tsp_typ_name = ' ' THEN
				r_rta_new.xf_tsp_typ_name := ' ';
			ELSE
				r_rta_new.xf_tsp_typ_name := REPLACE(NEW.xf_tsp_typ_name,' ','_');
			END IF;
			r_rta_new.xf_tsp_typ_name := UPPER(r_rta_new.xf_tsp_typ_name);
			IF NEW.xf_tsp_tsg_code = ' ' THEN
				r_rta_new.xf_tsp_tsg_code := ' ';
			ELSE
				r_rta_new.xf_tsp_tsg_code := REPLACE(NEW.xf_tsp_tsg_code,' ','_');
			END IF;
			r_rta_new.xf_tsp_tsg_code := UPPER(r_rta_new.xf_tsp_tsg_code);
			IF NEW.xk_tsp_code = ' ' THEN
				r_rta_new.xk_tsp_code := ' ';
			ELSE
				r_rta_new.xk_tsp_code := REPLACE(NEW.xk_tsp_code,' ','_');
			END IF;
			r_rta_new.xk_tsp_code := UPPER(r_rta_new.xk_tsp_code);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_rta_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_restriction_type_spec_atb
			WHERE fk_typ_name = OLD.fk_typ_name
			AND fk_atb_name = OLD.fk_atb_name
			AND xf_tsp_typ_name = OLD.xf_tsp_typ_name
			AND xf_tsp_tsg_code = OLD.xf_tsp_tsg_code
			AND xk_tsp_code = OLD.xk_tsp_code;
			r_rta_old.fk_bot_name := OLD.fk_bot_name;
			r_rta_old.fk_typ_name := OLD.fk_typ_name;
			r_rta_old.fk_atb_name := OLD.fk_atb_name;
			r_rta_old.include_or_exclude := OLD.include_or_exclude;
			r_rta_old.xf_tsp_typ_name := OLD.xf_tsp_typ_name;
			r_rta_old.xf_tsp_tsg_code := OLD.xf_tsp_tsg_code;
			r_rta_old.xk_tsp_code := OLD.xk_tsp_code;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_rta (r_rta_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_rta (l_cube_ctid, r_rta_old, r_rta_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_rta (l_cube_ctid, r_rta_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_rta
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_restriction_type_spec_atb
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_rta();

CREATE FUNCTION bot.trg_ref() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_ref_new bot.v_reference%ROWTYPE;
		r_ref_old bot.v_reference%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			r_ref_new.cube_sequence := NEW.cube_sequence;
			IF NEW.fk_bot_name = ' ' THEN
				r_ref_new.fk_bot_name := ' ';
			ELSE
				r_ref_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_ref_new.fk_bot_name := UPPER(r_ref_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_ref_new.fk_typ_name := ' ';
			ELSE
				r_ref_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_ref_new.fk_typ_name := UPPER(r_ref_new.fk_typ_name);
			IF NEW.name = ' ' THEN
				r_ref_new.name := ' ';
			ELSE
				r_ref_new.name := REPLACE(NEW.name,' ','_');
			END IF;
			r_ref_new.name := UPPER(r_ref_new.name);
			r_ref_new.primary_key := NEW.primary_key;
			IF NEW.code_display_key = ' ' THEN
				r_ref_new.code_display_key := ' ';
			ELSE
				r_ref_new.code_display_key := REPLACE(NEW.code_display_key,' ','_');
			END IF;
			r_ref_new.code_display_key := UPPER(r_ref_new.code_display_key);
			r_ref_new.sequence := NEW.sequence;
			IF NEW.scope = ' ' THEN
				r_ref_new.scope := ' ';
			ELSE
				r_ref_new.scope := REPLACE(NEW.scope,' ','_');
			END IF;
			r_ref_new.scope := UPPER(r_ref_new.scope);
			r_ref_new.unchangeable := NEW.unchangeable;
			IF NEW.within_scope_extension = ' ' THEN
				r_ref_new.within_scope_extension := ' ';
			ELSE
				r_ref_new.within_scope_extension := REPLACE(NEW.within_scope_extension,' ','_');
			END IF;
			r_ref_new.within_scope_extension := UPPER(r_ref_new.within_scope_extension);
			IF NEW.cube_tsg_int_ext = ' ' THEN
				r_ref_new.cube_tsg_int_ext := ' ';
			ELSE
				r_ref_new.cube_tsg_int_ext := REPLACE(NEW.cube_tsg_int_ext,' ','_');
			END IF;
			IF NEW.xk_bot_name = ' ' THEN
				r_ref_new.xk_bot_name := ' ';
			ELSE
				r_ref_new.xk_bot_name := REPLACE(NEW.xk_bot_name,' ','_');
			END IF;
			r_ref_new.xk_bot_name := UPPER(r_ref_new.xk_bot_name);
			IF NEW.xk_typ_name = ' ' THEN
				r_ref_new.xk_typ_name := ' ';
			ELSE
				r_ref_new.xk_typ_name := REPLACE(NEW.xk_typ_name,' ','_');
			END IF;
			r_ref_new.xk_typ_name := UPPER(r_ref_new.xk_typ_name);
			IF NEW.xk_typ_name_1 = ' ' THEN
				r_ref_new.xk_typ_name_1 := ' ';
			ELSE
				r_ref_new.xk_typ_name_1 := REPLACE(NEW.xk_typ_name_1,' ','_');
			END IF;
			r_ref_new.xk_typ_name_1 := UPPER(r_ref_new.xk_typ_name_1);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_ref_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_reference
			WHERE fk_typ_name = OLD.fk_typ_name
			AND sequence = OLD.sequence
			AND xk_bot_name = OLD.xk_bot_name
			AND xk_typ_name = OLD.xk_typ_name;
			r_ref_old.cube_sequence := OLD.cube_sequence;
			r_ref_old.fk_bot_name := OLD.fk_bot_name;
			r_ref_old.fk_typ_name := OLD.fk_typ_name;
			r_ref_old.name := OLD.name;
			r_ref_old.primary_key := OLD.primary_key;
			r_ref_old.code_display_key := OLD.code_display_key;
			r_ref_old.sequence := OLD.sequence;
			r_ref_old.scope := OLD.scope;
			r_ref_old.unchangeable := OLD.unchangeable;
			r_ref_old.within_scope_extension := OLD.within_scope_extension;
			r_ref_old.cube_tsg_int_ext := OLD.cube_tsg_int_ext;
			r_ref_old.xk_bot_name := OLD.xk_bot_name;
			r_ref_old.xk_typ_name := OLD.xk_typ_name;
			r_ref_old.xk_typ_name_1 := OLD.xk_typ_name_1;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_ref (r_ref_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_ref (l_cube_ctid, r_ref_old, r_ref_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_ref (l_cube_ctid, r_ref_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_ref
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_reference
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_ref();

CREATE FUNCTION bot.trg_dcr() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_dcr_new bot.v_description_reference%ROWTYPE;
		r_dcr_old bot.v_description_reference%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.fk_bot_name = ' ' THEN
				r_dcr_new.fk_bot_name := ' ';
			ELSE
				r_dcr_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_dcr_new.fk_bot_name := UPPER(r_dcr_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_dcr_new.fk_typ_name := ' ';
			ELSE
				r_dcr_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_dcr_new.fk_typ_name := UPPER(r_dcr_new.fk_typ_name);
			r_dcr_new.fk_ref_sequence := NEW.fk_ref_sequence;
			IF NEW.fk_ref_bot_name = ' ' THEN
				r_dcr_new.fk_ref_bot_name := ' ';
			ELSE
				r_dcr_new.fk_ref_bot_name := REPLACE(NEW.fk_ref_bot_name,' ','_');
			END IF;
			r_dcr_new.fk_ref_bot_name := UPPER(r_dcr_new.fk_ref_bot_name);
			IF NEW.fk_ref_typ_name = ' ' THEN
				r_dcr_new.fk_ref_typ_name := ' ';
			ELSE
				r_dcr_new.fk_ref_typ_name := REPLACE(NEW.fk_ref_typ_name,' ','_');
			END IF;
			r_dcr_new.fk_ref_typ_name := UPPER(r_dcr_new.fk_ref_typ_name);
			r_dcr_new.text := NEW.text;
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_dcr_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_description_reference
			WHERE fk_typ_name = OLD.fk_typ_name
			AND fk_ref_sequence = OLD.fk_ref_sequence
			AND fk_ref_bot_name = OLD.fk_ref_bot_name
			AND fk_ref_typ_name = OLD.fk_ref_typ_name;
			r_dcr_old.fk_bot_name := OLD.fk_bot_name;
			r_dcr_old.fk_typ_name := OLD.fk_typ_name;
			r_dcr_old.fk_ref_sequence := OLD.fk_ref_sequence;
			r_dcr_old.fk_ref_bot_name := OLD.fk_ref_bot_name;
			r_dcr_old.fk_ref_typ_name := OLD.fk_ref_typ_name;
			r_dcr_old.text := OLD.text;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_dcr (r_dcr_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_dcr (l_cube_ctid, r_dcr_old, r_dcr_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_dcr (l_cube_ctid, r_dcr_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_dcr
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_description_reference
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_dcr();

CREATE FUNCTION bot.trg_rtr() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_rtr_new bot.v_restriction_type_spec_ref%ROWTYPE;
		r_rtr_old bot.v_restriction_type_spec_ref%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.fk_bot_name = ' ' THEN
				r_rtr_new.fk_bot_name := ' ';
			ELSE
				r_rtr_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_rtr_new.fk_bot_name := UPPER(r_rtr_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_rtr_new.fk_typ_name := ' ';
			ELSE
				r_rtr_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_rtr_new.fk_typ_name := UPPER(r_rtr_new.fk_typ_name);
			r_rtr_new.fk_ref_sequence := NEW.fk_ref_sequence;
			IF NEW.fk_ref_bot_name = ' ' THEN
				r_rtr_new.fk_ref_bot_name := ' ';
			ELSE
				r_rtr_new.fk_ref_bot_name := REPLACE(NEW.fk_ref_bot_name,' ','_');
			END IF;
			r_rtr_new.fk_ref_bot_name := UPPER(r_rtr_new.fk_ref_bot_name);
			IF NEW.fk_ref_typ_name = ' ' THEN
				r_rtr_new.fk_ref_typ_name := ' ';
			ELSE
				r_rtr_new.fk_ref_typ_name := REPLACE(NEW.fk_ref_typ_name,' ','_');
			END IF;
			r_rtr_new.fk_ref_typ_name := UPPER(r_rtr_new.fk_ref_typ_name);
			IF NEW.include_or_exclude = ' ' THEN
				r_rtr_new.include_or_exclude := ' ';
			ELSE
				r_rtr_new.include_or_exclude := REPLACE(NEW.include_or_exclude,' ','_');
			END IF;
			r_rtr_new.include_or_exclude := UPPER(r_rtr_new.include_or_exclude);
			IF NEW.xf_tsp_typ_name = ' ' THEN
				r_rtr_new.xf_tsp_typ_name := ' ';
			ELSE
				r_rtr_new.xf_tsp_typ_name := REPLACE(NEW.xf_tsp_typ_name,' ','_');
			END IF;
			r_rtr_new.xf_tsp_typ_name := UPPER(r_rtr_new.xf_tsp_typ_name);
			IF NEW.xf_tsp_tsg_code = ' ' THEN
				r_rtr_new.xf_tsp_tsg_code := ' ';
			ELSE
				r_rtr_new.xf_tsp_tsg_code := REPLACE(NEW.xf_tsp_tsg_code,' ','_');
			END IF;
			r_rtr_new.xf_tsp_tsg_code := UPPER(r_rtr_new.xf_tsp_tsg_code);
			IF NEW.xk_tsp_code = ' ' THEN
				r_rtr_new.xk_tsp_code := ' ';
			ELSE
				r_rtr_new.xk_tsp_code := REPLACE(NEW.xk_tsp_code,' ','_');
			END IF;
			r_rtr_new.xk_tsp_code := UPPER(r_rtr_new.xk_tsp_code);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_rtr_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_restriction_type_spec_ref
			WHERE fk_typ_name = OLD.fk_typ_name
			AND fk_ref_sequence = OLD.fk_ref_sequence
			AND fk_ref_bot_name = OLD.fk_ref_bot_name
			AND fk_ref_typ_name = OLD.fk_ref_typ_name
			AND xf_tsp_typ_name = OLD.xf_tsp_typ_name
			AND xf_tsp_tsg_code = OLD.xf_tsp_tsg_code
			AND xk_tsp_code = OLD.xk_tsp_code;
			r_rtr_old.fk_bot_name := OLD.fk_bot_name;
			r_rtr_old.fk_typ_name := OLD.fk_typ_name;
			r_rtr_old.fk_ref_sequence := OLD.fk_ref_sequence;
			r_rtr_old.fk_ref_bot_name := OLD.fk_ref_bot_name;
			r_rtr_old.fk_ref_typ_name := OLD.fk_ref_typ_name;
			r_rtr_old.include_or_exclude := OLD.include_or_exclude;
			r_rtr_old.xf_tsp_typ_name := OLD.xf_tsp_typ_name;
			r_rtr_old.xf_tsp_tsg_code := OLD.xf_tsp_tsg_code;
			r_rtr_old.xk_tsp_code := OLD.xk_tsp_code;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_rtr (r_rtr_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_rtr (l_cube_ctid, r_rtr_old, r_rtr_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_rtr (l_cube_ctid, r_rtr_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_rtr
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_restriction_type_spec_ref
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_rtr();

CREATE FUNCTION bot.trg_rts() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_rts_new bot.v_restriction_target_type_spec%ROWTYPE;
		r_rts_old bot.v_restriction_target_type_spec%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.fk_bot_name = ' ' THEN
				r_rts_new.fk_bot_name := ' ';
			ELSE
				r_rts_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_rts_new.fk_bot_name := UPPER(r_rts_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_rts_new.fk_typ_name := ' ';
			ELSE
				r_rts_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_rts_new.fk_typ_name := UPPER(r_rts_new.fk_typ_name);
			r_rts_new.fk_ref_sequence := NEW.fk_ref_sequence;
			IF NEW.fk_ref_bot_name = ' ' THEN
				r_rts_new.fk_ref_bot_name := ' ';
			ELSE
				r_rts_new.fk_ref_bot_name := REPLACE(NEW.fk_ref_bot_name,' ','_');
			END IF;
			r_rts_new.fk_ref_bot_name := UPPER(r_rts_new.fk_ref_bot_name);
			IF NEW.fk_ref_typ_name = ' ' THEN
				r_rts_new.fk_ref_typ_name := ' ';
			ELSE
				r_rts_new.fk_ref_typ_name := REPLACE(NEW.fk_ref_typ_name,' ','_');
			END IF;
			r_rts_new.fk_ref_typ_name := UPPER(r_rts_new.fk_ref_typ_name);
			IF NEW.include_or_exclude = ' ' THEN
				r_rts_new.include_or_exclude := ' ';
			ELSE
				r_rts_new.include_or_exclude := REPLACE(NEW.include_or_exclude,' ','_');
			END IF;
			r_rts_new.include_or_exclude := UPPER(r_rts_new.include_or_exclude);
			IF NEW.xf_tsp_typ_name = ' ' THEN
				r_rts_new.xf_tsp_typ_name := ' ';
			ELSE
				r_rts_new.xf_tsp_typ_name := REPLACE(NEW.xf_tsp_typ_name,' ','_');
			END IF;
			r_rts_new.xf_tsp_typ_name := UPPER(r_rts_new.xf_tsp_typ_name);
			IF NEW.xf_tsp_tsg_code = ' ' THEN
				r_rts_new.xf_tsp_tsg_code := ' ';
			ELSE
				r_rts_new.xf_tsp_tsg_code := REPLACE(NEW.xf_tsp_tsg_code,' ','_');
			END IF;
			r_rts_new.xf_tsp_tsg_code := UPPER(r_rts_new.xf_tsp_tsg_code);
			IF NEW.xk_tsp_code = ' ' THEN
				r_rts_new.xk_tsp_code := ' ';
			ELSE
				r_rts_new.xk_tsp_code := REPLACE(NEW.xk_tsp_code,' ','_');
			END IF;
			r_rts_new.xk_tsp_code := UPPER(r_rts_new.xk_tsp_code);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_rts_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_restriction_target_type_spec
			WHERE fk_typ_name = OLD.fk_typ_name
			AND fk_ref_sequence = OLD.fk_ref_sequence
			AND fk_ref_bot_name = OLD.fk_ref_bot_name
			AND fk_ref_typ_name = OLD.fk_ref_typ_name
			AND xf_tsp_typ_name = OLD.xf_tsp_typ_name
			AND xf_tsp_tsg_code = OLD.xf_tsp_tsg_code
			AND xk_tsp_code = OLD.xk_tsp_code;
			r_rts_old.fk_bot_name := OLD.fk_bot_name;
			r_rts_old.fk_typ_name := OLD.fk_typ_name;
			r_rts_old.fk_ref_sequence := OLD.fk_ref_sequence;
			r_rts_old.fk_ref_bot_name := OLD.fk_ref_bot_name;
			r_rts_old.fk_ref_typ_name := OLD.fk_ref_typ_name;
			r_rts_old.include_or_exclude := OLD.include_or_exclude;
			r_rts_old.xf_tsp_typ_name := OLD.xf_tsp_typ_name;
			r_rts_old.xf_tsp_tsg_code := OLD.xf_tsp_tsg_code;
			r_rts_old.xk_tsp_code := OLD.xk_tsp_code;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_rts (r_rts_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_rts (l_cube_ctid, r_rts_old, r_rts_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_rts (l_cube_ctid, r_rts_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_rts
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_restriction_target_type_spec
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_rts();

CREATE FUNCTION bot.trg_rtt() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_rtt_new bot.v_restriction_type_spec_typ%ROWTYPE;
		r_rtt_old bot.v_restriction_type_spec_typ%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.fk_bot_name = ' ' THEN
				r_rtt_new.fk_bot_name := ' ';
			ELSE
				r_rtt_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_rtt_new.fk_bot_name := UPPER(r_rtt_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_rtt_new.fk_typ_name := ' ';
			ELSE
				r_rtt_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_rtt_new.fk_typ_name := UPPER(r_rtt_new.fk_typ_name);
			IF NEW.include_or_exclude = ' ' THEN
				r_rtt_new.include_or_exclude := ' ';
			ELSE
				r_rtt_new.include_or_exclude := REPLACE(NEW.include_or_exclude,' ','_');
			END IF;
			r_rtt_new.include_or_exclude := UPPER(r_rtt_new.include_or_exclude);
			IF NEW.xf_tsp_typ_name = ' ' THEN
				r_rtt_new.xf_tsp_typ_name := ' ';
			ELSE
				r_rtt_new.xf_tsp_typ_name := REPLACE(NEW.xf_tsp_typ_name,' ','_');
			END IF;
			r_rtt_new.xf_tsp_typ_name := UPPER(r_rtt_new.xf_tsp_typ_name);
			IF NEW.xf_tsp_tsg_code = ' ' THEN
				r_rtt_new.xf_tsp_tsg_code := ' ';
			ELSE
				r_rtt_new.xf_tsp_tsg_code := REPLACE(NEW.xf_tsp_tsg_code,' ','_');
			END IF;
			r_rtt_new.xf_tsp_tsg_code := UPPER(r_rtt_new.xf_tsp_tsg_code);
			IF NEW.xk_tsp_code = ' ' THEN
				r_rtt_new.xk_tsp_code := ' ';
			ELSE
				r_rtt_new.xk_tsp_code := REPLACE(NEW.xk_tsp_code,' ','_');
			END IF;
			r_rtt_new.xk_tsp_code := UPPER(r_rtt_new.xk_tsp_code);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_rtt_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_restriction_type_spec_typ
			WHERE fk_typ_name = OLD.fk_typ_name
			AND xf_tsp_typ_name = OLD.xf_tsp_typ_name
			AND xf_tsp_tsg_code = OLD.xf_tsp_tsg_code
			AND xk_tsp_code = OLD.xk_tsp_code;
			r_rtt_old.fk_bot_name := OLD.fk_bot_name;
			r_rtt_old.fk_typ_name := OLD.fk_typ_name;
			r_rtt_old.include_or_exclude := OLD.include_or_exclude;
			r_rtt_old.xf_tsp_typ_name := OLD.xf_tsp_typ_name;
			r_rtt_old.xf_tsp_tsg_code := OLD.xf_tsp_tsg_code;
			r_rtt_old.xk_tsp_code := OLD.xk_tsp_code;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_rtt (r_rtt_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_rtt (l_cube_ctid, r_rtt_old, r_rtt_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_rtt (l_cube_ctid, r_rtt_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_rtt
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_restriction_type_spec_typ
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_rtt();

CREATE FUNCTION bot.trg_jsn() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_jsn_new bot.v_json_path%ROWTYPE;
		r_jsn_old bot.v_json_path%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			r_jsn_new.cube_sequence := NEW.cube_sequence;
			IF NEW.fk_bot_name = ' ' THEN
				r_jsn_new.fk_bot_name := ' ';
			ELSE
				r_jsn_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_jsn_new.fk_bot_name := UPPER(r_jsn_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_jsn_new.fk_typ_name := ' ';
			ELSE
				r_jsn_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_jsn_new.fk_typ_name := UPPER(r_jsn_new.fk_typ_name);
			r_jsn_new.fk_jsn_name := NEW.fk_jsn_name;
			r_jsn_new.fk_jsn_location := NEW.fk_jsn_location;
			IF NEW.fk_jsn_atb_typ_name = ' ' THEN
				r_jsn_new.fk_jsn_atb_typ_name := ' ';
			ELSE
				r_jsn_new.fk_jsn_atb_typ_name := REPLACE(NEW.fk_jsn_atb_typ_name,' ','_');
			END IF;
			r_jsn_new.fk_jsn_atb_typ_name := UPPER(r_jsn_new.fk_jsn_atb_typ_name);
			IF NEW.fk_jsn_atb_name = ' ' THEN
				r_jsn_new.fk_jsn_atb_name := ' ';
			ELSE
				r_jsn_new.fk_jsn_atb_name := REPLACE(NEW.fk_jsn_atb_name,' ','_');
			END IF;
			r_jsn_new.fk_jsn_atb_name := UPPER(r_jsn_new.fk_jsn_atb_name);
			IF NEW.fk_jsn_typ_name = ' ' THEN
				r_jsn_new.fk_jsn_typ_name := ' ';
			ELSE
				r_jsn_new.fk_jsn_typ_name := REPLACE(NEW.fk_jsn_typ_name,' ','_');
			END IF;
			r_jsn_new.fk_jsn_typ_name := UPPER(r_jsn_new.fk_jsn_typ_name);
			IF NEW.cube_tsg_obj_arr = ' ' THEN
				r_jsn_new.cube_tsg_obj_arr := ' ';
			ELSE
				r_jsn_new.cube_tsg_obj_arr := REPLACE(NEW.cube_tsg_obj_arr,' ','_');
			END IF;
			IF NEW.cube_tsg_type = ' ' THEN
				r_jsn_new.cube_tsg_type := ' ';
			ELSE
				r_jsn_new.cube_tsg_type := REPLACE(NEW.cube_tsg_type,' ','_');
			END IF;
			r_jsn_new.name := NEW.name;
			r_jsn_new.location := NEW.location;
			IF NEW.xf_atb_typ_name = ' ' THEN
				r_jsn_new.xf_atb_typ_name := ' ';
			ELSE
				r_jsn_new.xf_atb_typ_name := REPLACE(NEW.xf_atb_typ_name,' ','_');
			END IF;
			r_jsn_new.xf_atb_typ_name := UPPER(r_jsn_new.xf_atb_typ_name);
			IF NEW.xk_atb_name = ' ' THEN
				r_jsn_new.xk_atb_name := ' ';
			ELSE
				r_jsn_new.xk_atb_name := REPLACE(NEW.xk_atb_name,' ','_');
			END IF;
			r_jsn_new.xk_atb_name := UPPER(r_jsn_new.xk_atb_name);
			IF NEW.xk_typ_name = ' ' THEN
				r_jsn_new.xk_typ_name := ' ';
			ELSE
				r_jsn_new.xk_typ_name := REPLACE(NEW.xk_typ_name,' ','_');
			END IF;
			r_jsn_new.xk_typ_name := UPPER(r_jsn_new.xk_typ_name);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_jsn_new.cube_id := OLD.cube_id;
			r_jsn_new.cube_level := OLD.cube_level;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_json_path
			WHERE fk_typ_name = OLD.fk_typ_name
			AND name = OLD.name
			AND location = OLD.location
			AND xf_atb_typ_name = OLD.xf_atb_typ_name
			AND xk_atb_name = OLD.xk_atb_name
			AND xk_typ_name = OLD.xk_typ_name;
			r_jsn_old.cube_sequence := OLD.cube_sequence;
			r_jsn_old.fk_bot_name := OLD.fk_bot_name;
			r_jsn_old.fk_typ_name := OLD.fk_typ_name;
			r_jsn_old.fk_jsn_name := OLD.fk_jsn_name;
			r_jsn_old.fk_jsn_location := OLD.fk_jsn_location;
			r_jsn_old.fk_jsn_atb_typ_name := OLD.fk_jsn_atb_typ_name;
			r_jsn_old.fk_jsn_atb_name := OLD.fk_jsn_atb_name;
			r_jsn_old.fk_jsn_typ_name := OLD.fk_jsn_typ_name;
			r_jsn_old.cube_tsg_obj_arr := OLD.cube_tsg_obj_arr;
			r_jsn_old.cube_tsg_type := OLD.cube_tsg_type;
			r_jsn_old.name := OLD.name;
			r_jsn_old.location := OLD.location;
			r_jsn_old.xf_atb_typ_name := OLD.xf_atb_typ_name;
			r_jsn_old.xk_atb_name := OLD.xk_atb_name;
			r_jsn_old.xk_typ_name := OLD.xk_typ_name;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_jsn (r_jsn_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_jsn (l_cube_ctid, r_jsn_old, r_jsn_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_jsn (l_cube_ctid, r_jsn_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_jsn
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_json_path
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_jsn();

CREATE FUNCTION bot.trg_dct() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_dct_new bot.v_description_type%ROWTYPE;
		r_dct_old bot.v_description_type%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.fk_bot_name = ' ' THEN
				r_dct_new.fk_bot_name := ' ';
			ELSE
				r_dct_new.fk_bot_name := REPLACE(NEW.fk_bot_name,' ','_');
			END IF;
			r_dct_new.fk_bot_name := UPPER(r_dct_new.fk_bot_name);
			IF NEW.fk_typ_name = ' ' THEN
				r_dct_new.fk_typ_name := ' ';
			ELSE
				r_dct_new.fk_typ_name := REPLACE(NEW.fk_typ_name,' ','_');
			END IF;
			r_dct_new.fk_typ_name := UPPER(r_dct_new.fk_typ_name);
			r_dct_new.text := NEW.text;
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_dct_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM bot.t_description_type
			WHERE fk_typ_name = OLD.fk_typ_name;
			r_dct_old.fk_bot_name := OLD.fk_bot_name;
			r_dct_old.fk_typ_name := OLD.fk_typ_name;
			r_dct_old.text := OLD.text;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL bot.trg_insert_dct (r_dct_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL bot.trg_update_dct (l_cube_ctid, r_dct_old, r_dct_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL bot.trg_delete_dct (l_cube_ctid, r_dct_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_dct
INSTEAD OF INSERT OR DELETE OR UPDATE ON bot.v_description_type
FOR EACH ROW
EXECUTE PROCEDURE bot.trg_dct();

CREATE VIEW sys.v_system AS 
	SELECT
		cube_id,
		name,
		cube_tsg_type,
		database,
		schema,
		password,
		table_prefix
	FROM sys.t_system;


CREATE VIEW sys.v_system_bo_type AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_sys_name,
		xk_bot_name
	FROM sys.t_system_bo_type;


CREATE PROCEDURE sys.trg_insert_sys (p_sys sys.v_system)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_sys.cube_id := 'SYS-' || TO_CHAR(NEXTVAL('sys.sq_sys'),'FM000000000000');
		p_sys.name := COALESCE(p_sys.name,' ');
		INSERT INTO sys.t_system (
			cube_id,
			name,
			cube_tsg_type,
			database,
			schema,
			password,
			table_prefix)
		VALUES (
			p_sys.cube_id,
			p_sys.name,
			p_sys.cube_tsg_type,
			p_sys.database,
			p_sys.schema,
			p_sys.password,
			p_sys.table_prefix);
	END;
$BODY$;

CREATE PROCEDURE sys.trg_update_sys (p_cube_ctid TID, p_sys_old sys.v_system, p_sys_new sys.v_system)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE sys.t_system SET 
			database = p_sys_new.database,
			schema = p_sys_new.schema,
			password = p_sys_new.password,
			table_prefix = p_sys_new.table_prefix
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE sys.trg_delete_sys (p_cube_ctid TID, p_sys sys.v_system)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM sys.t_system 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE sys.trg_insert_sbt (p_sbt sys.v_system_bo_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_sbt.cube_id := 'SBT-' || TO_CHAR(NEXTVAL('sys.sq_sbt'),'FM000000000000');
		p_sbt.fk_sys_name := COALESCE(p_sbt.fk_sys_name,' ');
		p_sbt.xk_bot_name := COALESCE(p_sbt.xk_bot_name,' ');
		INSERT INTO sys.t_system_bo_type (
			cube_id,
			cube_sequence,
			fk_sys_name,
			xk_bot_name)
		VALUES (
			p_sbt.cube_id,
			p_sbt.cube_sequence,
			p_sbt.fk_sys_name,
			p_sbt.xk_bot_name);
	END;
$BODY$;

CREATE PROCEDURE sys.trg_update_sbt (p_cube_ctid TID, p_sbt_old sys.v_system_bo_type, p_sbt_new sys.v_system_bo_type)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE sys.t_system_bo_type SET 
			cube_sequence = p_sbt_new.cube_sequence
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE sys.trg_delete_sbt (p_cube_ctid TID, p_sbt sys.v_system_bo_type)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM sys.t_system_bo_type 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE FUNCTION sys.trg_sys() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_sys_new sys.v_system%ROWTYPE;
		r_sys_old sys.v_system%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.name = ' ' THEN
				r_sys_new.name := ' ';
			ELSE
				r_sys_new.name := REPLACE(NEW.name,' ','_');
			END IF;
			IF NEW.cube_tsg_type = ' ' THEN
				r_sys_new.cube_tsg_type := ' ';
			ELSE
				r_sys_new.cube_tsg_type := REPLACE(NEW.cube_tsg_type,' ','_');
			END IF;
			IF NEW.database = ' ' THEN
				r_sys_new.database := ' ';
			ELSE
				r_sys_new.database := REPLACE(NEW.database,' ','_');
			END IF;
			IF NEW.schema = ' ' THEN
				r_sys_new.schema := ' ';
			ELSE
				r_sys_new.schema := REPLACE(NEW.schema,' ','_');
			END IF;
			IF NEW.password = ' ' THEN
				r_sys_new.password := ' ';
			ELSE
				r_sys_new.password := REPLACE(NEW.password,' ','_');
			END IF;
			IF NEW.table_prefix = ' ' THEN
				r_sys_new.table_prefix := ' ';
			ELSE
				r_sys_new.table_prefix := REPLACE(NEW.table_prefix,' ','_');
			END IF;
			r_sys_new.table_prefix := UPPER(r_sys_new.table_prefix);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_sys_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM sys.t_system
			WHERE name = OLD.name;
			r_sys_old.name := OLD.name;
			r_sys_old.cube_tsg_type := OLD.cube_tsg_type;
			r_sys_old.database := OLD.database;
			r_sys_old.schema := OLD.schema;
			r_sys_old.password := OLD.password;
			r_sys_old.table_prefix := OLD.table_prefix;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL sys.trg_insert_sys (r_sys_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL sys.trg_update_sys (l_cube_ctid, r_sys_old, r_sys_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL sys.trg_delete_sys (l_cube_ctid, r_sys_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_sys
INSTEAD OF INSERT OR DELETE OR UPDATE ON sys.v_system
FOR EACH ROW
EXECUTE PROCEDURE sys.trg_sys();

CREATE FUNCTION sys.trg_sbt() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_sbt_new sys.v_system_bo_type%ROWTYPE;
		r_sbt_old sys.v_system_bo_type%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			r_sbt_new.cube_sequence := NEW.cube_sequence;
			IF NEW.fk_sys_name = ' ' THEN
				r_sbt_new.fk_sys_name := ' ';
			ELSE
				r_sbt_new.fk_sys_name := REPLACE(NEW.fk_sys_name,' ','_');
			END IF;
			IF NEW.xk_bot_name = ' ' THEN
				r_sbt_new.xk_bot_name := ' ';
			ELSE
				r_sbt_new.xk_bot_name := REPLACE(NEW.xk_bot_name,' ','_');
			END IF;
			r_sbt_new.xk_bot_name := UPPER(r_sbt_new.xk_bot_name);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_sbt_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM sys.t_system_bo_type
			WHERE fk_sys_name = OLD.fk_sys_name
			AND xk_bot_name = OLD.xk_bot_name;
			r_sbt_old.cube_sequence := OLD.cube_sequence;
			r_sbt_old.fk_sys_name := OLD.fk_sys_name;
			r_sbt_old.xk_bot_name := OLD.xk_bot_name;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL sys.trg_insert_sbt (r_sbt_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL sys.trg_update_sbt (l_cube_ctid, r_sbt_old, r_sbt_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL sys.trg_delete_sbt (l_cube_ctid, r_sbt_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_sbt
INSTEAD OF INSERT OR DELETE OR UPDATE ON sys.v_system_bo_type
FOR EACH ROW
EXECUTE PROCEDURE sys.trg_sbt();

CREATE VIEW fun.v_function AS 
	SELECT
		cube_id,
		name
	FROM fun.t_function;


CREATE VIEW fun.v_argument AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_fun_name,
		name
	FROM fun.t_argument;


CREATE PROCEDURE fun.trg_insert_fun (p_fun fun.v_function)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_fun.cube_id := 'FUN-' || TO_CHAR(NEXTVAL('fun.sq_fun'),'FM000000000000');
		p_fun.name := COALESCE(p_fun.name,' ');
		INSERT INTO fun.t_function (
			cube_id,
			name)
		VALUES (
			p_fun.cube_id,
			p_fun.name);
	END;
$BODY$;

CREATE PROCEDURE fun.trg_update_fun (p_cube_ctid TID, p_fun_old fun.v_function, p_fun_new fun.v_function)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		NULL;
	END;
$BODY$;

CREATE PROCEDURE fun.trg_delete_fun (p_cube_ctid TID, p_fun fun.v_function)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM fun.t_function 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE fun.trg_insert_arg (p_arg fun.v_argument)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_arg.cube_id := 'ARG-' || TO_CHAR(NEXTVAL('fun.sq_arg'),'FM000000000000');
		p_arg.fk_fun_name := COALESCE(p_arg.fk_fun_name,' ');
		p_arg.name := COALESCE(p_arg.name,' ');
		INSERT INTO fun.t_argument (
			cube_id,
			cube_sequence,
			fk_fun_name,
			name)
		VALUES (
			p_arg.cube_id,
			p_arg.cube_sequence,
			p_arg.fk_fun_name,
			p_arg.name);
	END;
$BODY$;

CREATE PROCEDURE fun.trg_update_arg (p_cube_ctid TID, p_arg_old fun.v_argument, p_arg_new fun.v_argument)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE fun.t_argument SET 
			cube_sequence = p_arg_new.cube_sequence
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE fun.trg_delete_arg (p_cube_ctid TID, p_arg fun.v_argument)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM fun.t_argument 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE FUNCTION fun.trg_fun() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_fun_new fun.v_function%ROWTYPE;
		r_fun_old fun.v_function%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.name = ' ' THEN
				r_fun_new.name := ' ';
			ELSE
				r_fun_new.name := REPLACE(NEW.name,' ','_');
			END IF;
			r_fun_new.name := UPPER(r_fun_new.name);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_fun_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM fun.t_function
			WHERE name = OLD.name;
			r_fun_old.name := OLD.name;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL fun.trg_insert_fun (r_fun_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL fun.trg_update_fun (l_cube_ctid, r_fun_old, r_fun_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL fun.trg_delete_fun (l_cube_ctid, r_fun_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_fun
INSTEAD OF INSERT OR DELETE OR UPDATE ON fun.v_function
FOR EACH ROW
EXECUTE PROCEDURE fun.trg_fun();

CREATE FUNCTION fun.trg_arg() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_arg_new fun.v_argument%ROWTYPE;
		r_arg_old fun.v_argument%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			r_arg_new.cube_sequence := NEW.cube_sequence;
			IF NEW.fk_fun_name = ' ' THEN
				r_arg_new.fk_fun_name := ' ';
			ELSE
				r_arg_new.fk_fun_name := REPLACE(NEW.fk_fun_name,' ','_');
			END IF;
			r_arg_new.fk_fun_name := UPPER(r_arg_new.fk_fun_name);
			IF NEW.name = ' ' THEN
				r_arg_new.name := ' ';
			ELSE
				r_arg_new.name := REPLACE(NEW.name,' ','_');
			END IF;
			r_arg_new.name := UPPER(r_arg_new.name);
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_arg_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM fun.t_argument
			WHERE fk_fun_name = OLD.fk_fun_name
			AND name = OLD.name;
			r_arg_old.cube_sequence := OLD.cube_sequence;
			r_arg_old.fk_fun_name := OLD.fk_fun_name;
			r_arg_old.name := OLD.name;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL fun.trg_insert_arg (r_arg_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL fun.trg_update_arg (l_cube_ctid, r_arg_old, r_arg_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL fun.trg_delete_arg (l_cube_ctid, r_arg_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_arg
INSTEAD OF INSERT OR DELETE OR UPDATE ON fun.v_argument
FOR EACH ROW
EXECUTE PROCEDURE fun.trg_arg();

\q
