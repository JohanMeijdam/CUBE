-- ALTER TABLE DDL
--
-- First remove all te constraints.
DO $BODY$
	DECLARE
		rec_constraint RECORD;
	BEGIN
		RAISE INFO 'Removing constraints';
		FOR rec_constraint IN
			SELECT table_schema, table_name, constraint_name
			FROM information_schema.table_constraints, information_schema.schemata
			WHERE constraint_catalog = catalog_name
			  AND constraint_schema = schema_name
			  AND constraint_type IN ('FOREIGN KEY','PRIMARY KEY')
			  AND schema_owner = '<<1>>'
			ORDER BY constraint_type
		LOOP
			EXECUTE 'ALTER TABLE ' || rec_constraint.table_schema || '.' || rec_constraint.table_name || ' DROP CONSTRAINT ' || rec_constraint.constraint_name;
		END LOOP;
	END;
$BODY$;

-- Delete CUBE-NULL records.
DO $BODY$
	DECLARE
	BEGIN
		RAISE INFO 'Deleting CUBE-NULL rows';
		DELETE FROM t_cube_user WHERE cube_id = 'CUBE-NULL';
		DELETE FROM t_cube_description WHERE cube_id = 'CUBE-NULL';
	END;
$BODY$;

-- Drop all the sequences, tables and columns that are no longer applicable.
DO $BODY$
	DECLARE
		rec_schema RECORD;
		rec_sequence RECORD;
		rec_table RECORD;
		rec_column RECORD;
	BEGIN
		RAISE INFO 'Dropping objects that are no longer applicable';
		FOR rec_schema IN 
			SELECT schema_name 
			FROM information_schema.schemata
			WHERE schema_owner = '<<1>>'
			  AND schema_name NOT IN ('cube','cube_usr','cube_dsc')
		LOOP
			EXECUTE 'DROP SCHEMA ' || rec_schema.schema_name || ' CASCADE';
		END LOOP;
		
		FOR rec_schema IN 
			SELECT catalog_name, schema_name 
			FROM information_schema.schemata
			WHERE schema_owner = '<<1>>'
		LOOP
			CASE rec_schema.schema_name
			WHEN 'cube_usr' THEN
				FOR rec_sequence IN
					SELECT sequence_name
					FROM information_schema.sequences
					WHERE sequence_catalog = rec_schema.catalog_name
					  AND sequence_schema = rec_schema.schema_name
					  AND sequence_name NOT IN ('sq_cube_usr')
				LOOP
					EXECUTE 'DROP SEQUENCE ' || rec_schema.schema_name || '.' || rec_sequence.sequence_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name NOT IN ('t_cube_user')
				LOOP
					EXECUTE 'DROP TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables 
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name IN ('t_cube_user')
				LOOP
					CASE rec_table.table_name
					WHEN 't_cube_user' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','userid','name','password')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					END CASE;
										
				END LOOP;
			WHEN 'cube_dsc' THEN
				FOR rec_sequence IN
					SELECT sequence_name
					FROM information_schema.sequences
					WHERE sequence_catalog = rec_schema.catalog_name
					  AND sequence_schema = rec_schema.schema_name
					  AND sequence_name NOT IN ('sq_cube_dsc')
				LOOP
					EXECUTE 'DROP SEQUENCE ' || rec_schema.schema_name || '.' || rec_sequence.sequence_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name NOT IN ('t_cube_description')
				LOOP
					EXECUTE 'DROP TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables 
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name IN ('t_cube_description')
				LOOP
					CASE rec_table.table_name
					WHEN 't_cube_description' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','type_name','attribute_type_name','sequence','value')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					END CASE;
										
				END LOOP;
			WHEN 'cube' THEN
				-- nop
			END CASE;
		END LOOP;
	END;
$BODY$;

-- Process column updates.
DO $BODY$
	DECLARE
		rec_column RECORD;
	BEGIN
		RAISE INFO 'Processing column updates';
		FOR rec_column IN 
			SELECT schema_name, table_name, column_name,
			(	CASE data_type 
				WHEN 'character varying' THEN COALESCE('VARCHAR('||character_maximum_length||')','VARCHAR') 
				WHEN 'numeric' THEN 'NUMERIC('||numeric_precision||(CASE WHEN numeric_scale > 0 THEN ','||numeric_scale||')' ELSE ')' END)
				WHEN 'date' THEN 'DATE' 
				WHEN 'time without time zone' THEN 'TIME' 
				WHEN 'timestamp without time zone' THEN 'TIMESTAMP' 
				ELSE 'ERROR' END ) cube_data_type
			FROM information_schema.schemata, information_schema.columns 
			WHERE table_schema = schema_name
			  AND schema_owner = '<<1>>'
			ORDER BY schema_name, table_name, column_name
		LOOP
			CASE rec_column.schema_name			
			WHEN 'cube_usr' THEN
				CASE rec_column.table_name			
				WHEN 't_cube_user' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE cube_usr.t_cube_user RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE cube_usr.t_cube_user ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'userid' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE cube_usr.t_cube_user RENAME COLUMN userid TO _userid' ;
						ELSE
							EXECUTE 'ALTER TABLE cube_usr.t_cube_user ALTER COLUMN userid DROP DEFAULT';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(120)' THEN
							EXECUTE 'ALTER TABLE cube_usr.t_cube_user RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE cube_usr.t_cube_user ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'password' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(20)' THEN
							EXECUTE 'ALTER TABLE cube_usr.t_cube_user RENAME COLUMN password TO _password' ;
						ELSE
							EXECUTE 'ALTER TABLE cube_usr.t_cube_user ALTER COLUMN password DROP DEFAULT';
						END IF;
					END CASE;
				END CASE;			
			WHEN 'cube_dsc' THEN
				CASE rec_column.table_name			
				WHEN 't_cube_description' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE cube_dsc.t_cube_description RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'type_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE cube_dsc.t_cube_description RENAME COLUMN type_name TO _type_name' ;
						ELSE
							EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ALTER COLUMN type_name DROP DEFAULT';
						END IF;			
					WHEN 'attribute_type_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE cube_dsc.t_cube_description RENAME COLUMN attribute_type_name TO _attribute_type_name' ;
						ELSE
							EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ALTER COLUMN attribute_type_name SET DEFAULT ''_''';
						END IF;			
					WHEN 'sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(1)' THEN
							EXECUTE 'ALTER TABLE cube_dsc.t_cube_description RENAME COLUMN sequence TO _sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ALTER COLUMN sequence SET DEFAULT ''-1''';
						END IF;			
					WHEN 'value' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(3999)' THEN
							EXECUTE 'ALTER TABLE cube_dsc.t_cube_description RENAME COLUMN value TO _value' ;
						ELSE
							EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ALTER COLUMN value DROP DEFAULT';
						END IF;
					END CASE;
				END CASE;
			WHEN 'cube' THEN
				-- nop
			END CASE;
		END LOOP;	
	END;
$BODY$;

-- Add all the new sequences, tables and columns and restore the constraints.
DO $BODY$
	DECLARE
	BEGIN
		SET client_min_messages TO WARNING;
		RAISE INFO 'Adding new objects';

		EXECUTE 'CREATE SCHEMA IF NOT EXISTS cube_usr';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS cube_usr.sq_cube_usr START WITH 100000';

		EXECUTE 'CREATE TABLE IF NOT EXISTS cube_usr.t_cube_user ()';
		EXECUTE 'ALTER TABLE cube_usr.t_cube_user ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE cube_usr.t_cube_user ADD COLUMN IF NOT EXISTS userid VARCHAR(8)';
		EXECUTE 'ALTER TABLE cube_usr.t_cube_user ADD COLUMN IF NOT EXISTS name VARCHAR(120)';
		EXECUTE 'ALTER TABLE cube_usr.t_cube_user ADD COLUMN IF NOT EXISTS password VARCHAR(20)';
		EXECUTE 'ALTER TABLE cube_usr.t_cube_user ADD CONSTRAINT cube_usr_pk PRIMARY KEY (userid)';

		EXECUTE 'CREATE SCHEMA IF NOT EXISTS cube_dsc';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS cube_dsc.sq_cube_dsc START WITH 100000';

		EXECUTE 'CREATE TABLE IF NOT EXISTS cube_dsc.t_cube_description ()';
		EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ADD COLUMN IF NOT EXISTS type_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ADD COLUMN IF NOT EXISTS attribute_type_name VARCHAR(30) DEFAULT ''_''';
		EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ADD COLUMN IF NOT EXISTS sequence NUMERIC(1) DEFAULT ''-1''';
		EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ADD COLUMN IF NOT EXISTS value VARCHAR(3999)';
		EXECUTE 'ALTER TABLE cube_dsc.t_cube_description ADD CONSTRAINT cube_dsc_pk PRIMARY KEY (type_name, attribute_type_name, sequence)';
	END;
$BODY$;


-- Insert CUBE-NULL records.
DO $BODY$
	DECLARE
	BEGIN
		RAISE INFO 'Inserting CUBE-NULL rows';
	END;
$BODY$;

-- Restore the constraints.
DO $BODY$
	DECLARE
	BEGIN
		SET client_min_messages TO WARNING;
		RAISE INFO 'Restore foreign key constraints';
	END;
$BODY$;[[ENDLOOP,DATABASE]]

-- update changed column values
DO $BODY$
	DECLARE
		stmnt VARCHAR;
		rec_column RECORD;
	BEGIN
		RAISE INFO 'Processing values for updated columns';
		FOR rec_column IN 
			SELECT schema_name, old.table_name, old.column_name old_column_name, new.column_name new_column_name, new.data_type 
			FROM information_schema.schemata, information_schema.columns old, information_schema.columns new
			WHERE old.table_schema = schema_name
			  AND new.table_schema = schema_name
			  AND schema_owner = '<<1>>'
			  AND substr(old.column_name,1,1) = '_'
			  AND substr(old.column_name,2) = new.column_name
			ORDER BY schema_name, old.table_name, old.column_name
		LOOP
			BEGIN
				stmnt := 
					'UPDATE '||rec_column.schema_name||'.'||rec_column.table_name||
					' SET '||rec_column.new_column_name||'='||rec_column.old_column_name||'::VARCHAR::'||rec_column.data_type; 
				RAISE INFO '%',stmnt;
				EXECUTE stmnt;
			EXCEPTION
				WHEN OTHERS THEN RAISE INFO 'Update Failed';
			END;
		END LOOP;	
	END;
$BODY$;

\q
