
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

CREATE SCHEMA cube_usr;

CREATE SEQUENCE cube_usr.sq_cube_usr START WITH 100000;

CREATE TABLE cube_usr.t_cube_user (
	cube_id VARCHAR(16),
	userid VARCHAR(8),
	name VARCHAR(120),
	password VARCHAR(20),
	CONSTRAINT cube_usr_pk
		PRIMARY KEY (userid) );

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

\q
