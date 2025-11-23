
-- TABLE DDL
DO $$
	DECLARE
		rec_nspname RECORD;
	BEGIN
		FOR rec_nspname IN 
			SELECT nspname 
			FROM pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE nspowner = usesysid
			  AND usename = '<<1>>'
		LOOP
			EXECUTE 'DROP SCHEMA ' || rec_nspname.nspname || ' CASCADE';
		END LOOP;
	END;
$$;

DROP SCHEMA IF EXISTS cube_usr CASCADE;
CREATE SCHEMA cube_usr;

CREATE SEQUENCE cube_usr.sq_cube_usr START WITH 100000;

CREATE TABLE cube_usr.t_cube_user (
	cube_id VARCHAR(16),
	userid VARCHAR(8),
	name VARCHAR(120),
	password VARCHAR(20),
	CONSTRAINT cube_usr_pk
		PRIMARY KEY (userid) );

DROP SCHEMA IF EXISTS cube_dsc CASCADE;
CREATE SCHEMA cube_dsc;

CREATE SEQUENCE cube_dsc.sq_cube_dsc START WITH 100000;

CREATE TABLE cube_dsc.t_cube_description (
	cube_id VARCHAR(16),
	type_name VARCHAR(30),
	attribute_type_name VARCHAR(30) DEFAULT '_',
	sequence NUMERIC(1) DEFAULT '-1',
	value VARCHAR(3999),
	CONSTRAINT cube_dsc_pk
		PRIMARY KEY (type_name, attribute_type_name, sequence) );


-- Insert CUBE-NULL records.
DO $BODY$
	DECLARE
	BEGIN
		RAISE INFO 'Inserting CUBE-NULL rows';
		INSERT INTO cube_usr.t_cube_user (cube_id, userid) VALUES ('CUBE-NULL', ' ');
		INSERT INTO cube_dsc.t_cube_description (cube_id, type_name, attribute_type_name, sequence) VALUES ('CUBE-NULL', ' ', ' ', 0);
	END;
$BODY$;

-- Add constraints.
DO $BODY$
	DECLARE
	BEGIN
		SET client_min_messages TO WARNING;
		RAISE INFO 'Add foreign key constraints';
	END;
$BODY$;

\q
