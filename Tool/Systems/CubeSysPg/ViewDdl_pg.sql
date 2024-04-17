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
			WHERE schemaname = 'cube_usr'
			  AND viewowner = '<<2>>'
			  AND SUBSTR(viewname,1,INSTR(viewname,'_',3)) = 'V_CUBE_'
		LOOP
			EXECUTE 'DROP VIEW cube_usr.' || rec_view.viewname || ' CASCADE';
		END LOOP;

		FOR rec_view IN 
			SELECT viewname 
			FROM pg_catalog.pg_views
			WHERE schemaname = 'cube_dsc'
			  AND viewowner = '<<2>>'
			  AND SUBSTR(viewname,1,INSTR(viewname,'_',3)) = 'V_CUBE_'
		LOOP
			EXECUTE 'DROP VIEW cube_dsc.' || rec_view.viewname || ' CASCADE';
		END LOOP;

		FOR rec_proc IN
			SELECT proname, prokind
			FROM pg_catalog.pg_proc, pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE pronamespace = pg_namespace.oid
			  AND nspowner = usesysid
			  AND usename = '<<2>>'
			  AND nspname = 'cube_usr'
			  AND proname LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE cube_usr.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION cube_usr.' || rec_proc.proname;
			END CASE;
		END LOOP;

		FOR rec_proc IN
			SELECT proname, prokind
			FROM pg_catalog.pg_proc, pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE pronamespace = pg_namespace.oid
			  AND nspowner = usesysid
			  AND usename = '<<2>>'
			  AND nspname = 'cube_dsc'
			  AND proname LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE cube_dsc.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION cube_dsc.' || rec_proc.proname;
			END CASE;
		END LOOP;
	END;
$BODY$;

CREATE VIEW cube_usr.v_cube_user AS 
	SELECT
		cube_id,
		userid,
		name,
		password
	FROM cube_usr.t_cube_user;


CREATE PROCEDURE cube_usr.trg_insert_cube_usr (p_cube_usr cube_usr.v_cube_user)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_cube_usr.cube_id := 'CUBE_USR-' || TO_CHAR(NEXTVAL('cube_usr.sq_cube_usr'),'FM0000000');
		p_cube_usr.userid := COALESCE(p_cube_usr.userid,' ');
		INSERT INTO cube_usr.t_cube_user (
			cube_id,
			userid,
			name,
			password)
		VALUES (
			p_cube_usr.cube_id,
			p_cube_usr.userid,
			p_cube_usr.name,
			p_cube_usr.password);
	END;
$BODY$;

CREATE PROCEDURE cube_usr.trg_update_cube_usr (p_cube_ctid TID, p_cube_usr_old cube_usr.v_cube_user, p_cube_usr_new cube_usr.v_cube_user)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE cube_usr.t_cube_user SET 
			name = p_cube_usr_new.name,
			password = p_cube_usr_new.password
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE cube_usr.trg_delete_cube_usr (p_cube_ctid TID, p_cube_usr cube_usr.v_cube_user)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM cube_usr.t_cube_user 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE FUNCTION cube_usr.trg_cube_usr() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_cube_usr_new cube_usr.v_cube_user%ROWTYPE;
		r_cube_usr_old cube_usr.v_cube_user%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.userid = ' ' THEN
				r_cube_usr_new.userid := ' ';
			ELSE
				r_cube_usr_new.userid := REPLACE(NEW.userid,' ','_');
			END IF;
			r_cube_usr_new.userid := UPPER(r_cube_usr_new.userid);
			r_cube_usr_new.name := NEW.name;
			IF NEW.password = ' ' THEN
				r_cube_usr_new.password := ' ';
			ELSE
				r_cube_usr_new.password := REPLACE(NEW.password,' ','_');
			END IF;
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_cube_usr_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM cube_usr.t_cube_user
			WHERE userid = OLD.userid;
			r_cube_usr_old.userid := OLD.userid;
			r_cube_usr_old.name := OLD.name;
			r_cube_usr_old.password := OLD.password;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL cube_usr.trg_insert_cube_usr (r_cube_usr_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL cube_usr.trg_update_cube_usr (l_cube_ctid, r_cube_usr_old, r_cube_usr_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL cube_usr.trg_delete_cube_usr (l_cube_ctid, r_cube_usr_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_cube_usr
INSTEAD OF INSERT OR DELETE OR UPDATE ON cube_usr.v_cube_user
FOR EACH ROW
EXECUTE PROCEDURE cube_usr.trg_cube_usr();

CREATE VIEW cube_dsc.v_cube_description AS 
	SELECT
		cube_id,
		type_name,
		attribute_type_name,
		sequence,
		value
	FROM cube_dsc.t_cube_description;


CREATE PROCEDURE cube_dsc.trg_insert_cube_dsc (p_cube_dsc cube_dsc.v_cube_description)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		p_cube_dsc.cube_id := 'CUBE_DSC-' || TO_CHAR(NEXTVAL('cube_dsc.sq_cube_dsc'),'FM0000000');
		p_cube_dsc.type_name := COALESCE(p_cube_dsc.type_name,' ');
		p_cube_dsc.attribute_type_name := COALESCE(p_cube_dsc.attribute_type_name,' ');
		p_cube_dsc.sequence := COALESCE(p_cube_dsc.sequence,0);
		INSERT INTO cube_dsc.t_cube_description (
			cube_id,
			type_name,
			attribute_type_name,
			sequence,
			value)
		VALUES (
			p_cube_dsc.cube_id,
			p_cube_dsc.type_name,
			p_cube_dsc.attribute_type_name,
			p_cube_dsc.sequence,
			p_cube_dsc.value);
	END;
$BODY$;

CREATE PROCEDURE cube_dsc.trg_update_cube_dsc (p_cube_ctid TID, p_cube_dsc_old cube_dsc.v_cube_description, p_cube_dsc_new cube_dsc.v_cube_description)
LANGUAGE plpgsql
AS $BODY$
	BEGIN
		UPDATE cube_dsc.t_cube_description SET 
			value = p_cube_dsc_new.value
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE PROCEDURE cube_dsc.trg_delete_cube_dsc (p_cube_ctid TID, p_cube_dsc cube_dsc.v_cube_description)
LANGUAGE plpgsql 
AS $BODY$
	BEGIN
		DELETE FROM cube_dsc.t_cube_description 
		WHERE ctid = p_cube_ctid;
	END;
$BODY$;

CREATE FUNCTION cube_dsc.trg_cube_dsc() RETURNS trigger
LANGUAGE plpgsql 
AS $BODY$
	DECLARE
		l_cube_ctid TID;
		r_cube_dsc_new cube_dsc.v_cube_description%ROWTYPE;
		r_cube_dsc_old cube_dsc.v_cube_description%ROWTYPE;
	BEGIN
		IF TG_OP IN ('INSERT','UPDATE') THEN
			IF NEW.type_name = ' ' THEN
				r_cube_dsc_new.type_name := ' ';
			ELSE
				r_cube_dsc_new.type_name := REPLACE(NEW.type_name,' ','_');
			END IF;
			r_cube_dsc_new.type_name := UPPER(r_cube_dsc_new.type_name);
			IF NEW.attribute_type_name = ' ' THEN
				r_cube_dsc_new.attribute_type_name := ' ';
			ELSE
				r_cube_dsc_new.attribute_type_name := REPLACE(NEW.attribute_type_name,' ','_');
			END IF;
			r_cube_dsc_new.attribute_type_name := UPPER(r_cube_dsc_new.attribute_type_name);
			r_cube_dsc_new.sequence := NEW.sequence;
			r_cube_dsc_new.value := NEW.value;
		END IF;
		IF TG_OP IN ('UPDATE') THEN
			r_cube_dsc_new.cube_id := OLD.cube_id;
		END IF;
		IF TG_OP IN ('UPDATE','DELETE') THEN
			SELECT ctid INTO l_cube_ctid FROM cube_dsc.t_cube_description
			WHERE type_name = OLD.type_name
			AND attribute_type_name = OLD.attribute_type_name
			AND sequence = OLD.sequence;
			r_cube_dsc_old.type_name := OLD.type_name;
			r_cube_dsc_old.attribute_type_name := OLD.attribute_type_name;
			r_cube_dsc_old.sequence := OLD.sequence;
			r_cube_dsc_old.value := OLD.value;
		END IF;

		IF TG_OP = 'INSERT' THEN 
			CALL cube_dsc.trg_insert_cube_dsc (r_cube_dsc_new);
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			CALL cube_dsc.trg_update_cube_dsc (l_cube_ctid, r_cube_dsc_old, r_cube_dsc_new);
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			CALL cube_dsc.trg_delete_cube_dsc (l_cube_ctid, r_cube_dsc_old);
			RETURN OLD;
		END IF;
		RETURN NULL;
	END;
$BODY$;

CREATE TRIGGER trg_cube_dsc
INSTEAD OF INSERT OR DELETE OR UPDATE ON cube_dsc.v_cube_description
FOR EACH ROW
EXECUTE PROCEDURE cube_dsc.trg_cube_dsc();

\q
