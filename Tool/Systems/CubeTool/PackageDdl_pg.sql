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
			  AND usename = 'cubetool'
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
			  AND usename = 'cubetool'
			  AND nspname = '<<TYPE1:L>>'
			  AND proname NOT LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE <<TYPE1:L>>.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION <<TYPE1:L>>.' || rec_proc.proname;
			END CASE;
		END LOOP;
	END;
$BODY$;

CREATE OR REPLACE PROCEDURE itp.get_itp_root_items()
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


DO $BODY$
	DECLARE
		rec_proc RECORD;
	BEGIN
		FOR rec_proc IN
			SELECT proname, prokind
			FROM pg_catalog.pg_proc, pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE pronamespace = pg_namespace.oid
			  AND nspowner = usesysid
			  AND usename = 'cubetool'
			  AND nspname = '<<TYPE1:L>>'
			  AND proname NOT LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE <<TYPE1:L>>.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION <<TYPE1:L>>.' || rec_proc.proname;
			END CASE;
		END LOOP;
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
			  AND usename = 'cubetool'
			  AND nspname = '<<TYPE1:L>>'
			  AND proname NOT LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE <<TYPE1:L>>.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION <<TYPE1:L>>.' || rec_proc.proname;
			END CASE;
		END LOOP;
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
			  AND usename = 'cubetool'
			  AND nspname = '<<TYPE1:L>>'
			  AND proname NOT LIKE 'trg_%'
		LOOP
			CASE rec_proc.prokind
			WHEN 'p' THEN EXECUTE 'DROP PROCEDURE <<TYPE1:L>>.' || rec_proc.proname;
			WHEN 'f' THEN EXECUTE 'DROP FUNCTION <<TYPE1:L>>.' || rec_proc.proname;
			END CASE;
		END LOOP;
	END;
$BODY$;

\q
