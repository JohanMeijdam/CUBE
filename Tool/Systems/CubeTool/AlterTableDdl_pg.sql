-- ALTER TABLE DDL
--
-- First remove all te constraints.
DO $BODY$
	DECLARE
		rec_constraint RECORD;
	BEGIN
		FOR rec_constraint IN
			SELECT table_schema, table_name, constraint_name
			FROM information_schema.table_constraints, information_schema.schemata
			WHERE constraint_catalog = catalog_name
			  AND constraint_schema = schema_name
			  AND constraint_type IN ('FOREIGN KEY','PRIMARY KEY')
			  AND schema_owner = 'JohanM'
			ORDER BY constraint_type
		LOOP
			EXECUTE 'ALTER TABLE ' || rec_constraint.table_schema || '.' || rec_constraint.table_name || ' DROP CONSTRAINT ' || rec_constraint.constraint_name;
		END LOOP;
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
		FOR rec_schema IN 
			SELECT schema_name 
			FROM information_schema.schemata
			WHERE schema_owner = 'JohanM'
			  AND schema_name NOT IN ('cube','itp','bot','sys','fun')
		LOOP
			EXECUTE 'DROP SCHEMA ' || rec_schema.schema_name || ' CASCADE';
		END LOOP;
		
		FOR rec_schema IN 
			SELECT catalog_name, schema_name 
			FROM information_schema.schemata
			WHERE schema_owner = 'JohanM'
		LOOP
			CASE rec_schema.schema_name
			WHEN 'itp' THEN
				FOR rec_sequence IN
					SELECT sequence_name
					FROM information_schema.sequences
					WHERE sequence_catalog = rec_schema.catalog_name
					  AND sequence_schema = rec_schema.schema_name
					  AND sequence_name NOT IN ('sq_itp','sq_ite','sq_val')
				LOOP
					EXECUTE 'DROP SEQUENCE ' || rec_schema.schema_name || '.' || rec_sequence.sequence_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name NOT IN ('t_information_type','t_information_type_element','t_permitted_value')
				LOOP
					EXECUTE 'DROP TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables 
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name IN ('t_information_type','t_information_type_element','t_permitted_value')
				LOOP
					CASE rec_table.table_name
					WHEN 't_information_type' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','name')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_information_type_element' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','fk_itp_name','sequence','suffix','domain','length','decimals','case_sensitive','default_value','spaces_allowed','presentation')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_permitted_value' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','fk_itp_name','fk_ite_sequence','code','prompt')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					END CASE;
										
				END LOOP;
			WHEN 'bot' THEN
				FOR rec_sequence IN
					SELECT sequence_name
					FROM information_schema.sequences
					WHERE sequence_catalog = rec_schema.catalog_name
					  AND sequence_schema = rec_schema.schema_name
					  AND sequence_name NOT IN ('sq_bot','sq_typ','sq_tsg','sq_tsp','sq_atb','sq_der','sq_dca','sq_rta','sq_ref','sq_dcr','sq_rtr','sq_rts','sq_rtt','sq_jsn','sq_dct')
				LOOP
					EXECUTE 'DROP SEQUENCE ' || rec_schema.schema_name || '.' || rec_sequence.sequence_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name NOT IN ('t_business_object_type','t_type','t_type_specialisation_group','t_type_specialisation','t_attribute','t_derivation','t_description_attribute','t_restriction_type_spec_atb','t_reference','t_description_reference','t_restriction_type_spec_ref','t_restriction_target_type_spec','t_restriction_type_spec_typ','t_json_path','t_description_type')
				LOOP
					EXECUTE 'DROP TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables 
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name IN ('t_business_object_type','t_type','t_type_specialisation_group','t_type_specialisation','t_attribute','t_derivation','t_description_attribute','t_restriction_type_spec_atb','t_reference','t_description_reference','t_restriction_type_spec_ref','t_restriction_target_type_spec','t_restriction_type_spec_typ','t_json_path','t_description_type')
				LOOP
					CASE rec_table.table_name
					WHEN 't_business_object_type' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','name','cube_tsg_type','directory','api_url')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_type' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','cube_level','fk_bot_name','fk_typ_name','name','code','flag_partial_key','flag_recursive','recursive_cardinality','cardinality','sort_order','icon','transferable')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_type_specialisation_group' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','cube_level','fk_bot_name','fk_typ_name','fk_tsg_code','code','name','primary_key','xf_atb_typ_name','xk_atb_name')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_type_specialisation' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','fk_bot_name','fk_typ_name','fk_tsg_code','code','name','xf_tsp_typ_name','xf_tsp_tsg_code','xk_tsp_code')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_attribute' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','fk_bot_name','fk_typ_name','name','primary_key','code_display_key','code_foreign_key','flag_hidden','default_value','unchangeable','xk_itp_name')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_derivation' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','fk_bot_name','fk_typ_name','fk_atb_name','cube_tsg_type','aggregate_function','xk_typ_name','xk_typ_name_1')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_description_attribute' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','fk_bot_name','fk_typ_name','fk_atb_name','text')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_restriction_type_spec_atb' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','fk_bot_name','fk_typ_name','fk_atb_name','include_or_exclude','xf_tsp_typ_name','xf_tsp_tsg_code','xk_tsp_code')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_reference' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','fk_bot_name','fk_typ_name','name','primary_key','code_display_key','sequence','scope','unchangeable','within_scope_extension','cube_tsg_int_ext','xk_bot_name','xk_typ_name','xk_typ_name_1')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_description_reference' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','fk_bot_name','fk_typ_name','fk_ref_sequence','fk_ref_bot_name','fk_ref_typ_name','text')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_restriction_type_spec_ref' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','fk_bot_name','fk_typ_name','fk_ref_sequence','fk_ref_bot_name','fk_ref_typ_name','include_or_exclude','xf_tsp_typ_name','xf_tsp_tsg_code','xk_tsp_code')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_restriction_target_type_spec' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','fk_bot_name','fk_typ_name','fk_ref_sequence','fk_ref_bot_name','fk_ref_typ_name','include_or_exclude','xf_tsp_typ_name','xf_tsp_tsg_code','xk_tsp_code')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_restriction_type_spec_typ' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','fk_bot_name','fk_typ_name','include_or_exclude','xf_tsp_typ_name','xf_tsp_tsg_code','xk_tsp_code')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_json_path' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','cube_level','fk_bot_name','fk_typ_name','fk_jsn_name','fk_jsn_location','fk_jsn_atb_typ_name','fk_jsn_atb_name','fk_jsn_typ_name','cube_tsg_obj_arr','cube_tsg_type','name','location','xf_atb_typ_name','xk_atb_name','xk_typ_name')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_description_type' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','fk_bot_name','fk_typ_name','text')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					END CASE;
										
				END LOOP;
			WHEN 'sys' THEN
				FOR rec_sequence IN
					SELECT sequence_name
					FROM information_schema.sequences
					WHERE sequence_catalog = rec_schema.catalog_name
					  AND sequence_schema = rec_schema.schema_name
					  AND sequence_name NOT IN ('sq_sys','sq_sbt')
				LOOP
					EXECUTE 'DROP SEQUENCE ' || rec_schema.schema_name || '.' || rec_sequence.sequence_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name NOT IN ('t_system','t_system_bo_type')
				LOOP
					EXECUTE 'DROP TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables 
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name IN ('t_system','t_system_bo_type')
				LOOP
					CASE rec_table.table_name
					WHEN 't_system' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','name','cube_tsg_type','database','schema','password','table_prefix')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_system_bo_type' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','fk_sys_name','xk_bot_name')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					END CASE;
										
				END LOOP;
			WHEN 'fun' THEN
				FOR rec_sequence IN
					SELECT sequence_name
					FROM information_schema.sequences
					WHERE sequence_catalog = rec_schema.catalog_name
					  AND sequence_schema = rec_schema.schema_name
					  AND sequence_name NOT IN ('sq_fun','sq_arg')
				LOOP
					EXECUTE 'DROP SEQUENCE ' || rec_schema.schema_name || '.' || rec_sequence.sequence_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name NOT IN ('t_function','t_argument')
				LOOP
					EXECUTE 'DROP TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables 
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name IN ('t_function','t_argument')
				LOOP
					CASE rec_table.table_name
					WHEN 't_function' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','name')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_argument' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','fk_fun_name','name','struct_d','struct_t','struct_dt')
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
		FOR rec_column IN 
			SELECT schema_name, table_name, column_name, data_type,
			(	CASE data_type 
				WHEN 'character varying' THEN COALESCE('TEXT('||character_maximum_length||')','TEXT') 
				WHEN 'numeric' THEN 'NUMBER('||numeric_precision||(CASE WHEN numeric_scale > 0 THEN ','||numeric_scale||')' ELSE ')' END)
				WHEN 'date' THEN 'DATE' 
				WHEN 'time without time zone' THEN 'TIME' 
				WHEN 'timestamp without time zone' THEN 'TIMESTAMP' 
				ELSE 'ERROR' END ) dat_type
			FROM information_schema.schemata, information_schema.columns 
			WHERE table_schema = schema_name
			  AND schema_owner = 'JohanM'
			ORDER BY schema_name, table_name, column_name
		LOOP
			CASE rec_column.schema_name			
			WHEN 'itp' THEN
				CASE rec_column.table_name			
				WHEN 't_information_type' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_information_type_element' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_itp_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'suffix' THEN
						IF rec_column.data_type <> 'VARCHAR(12)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'domain' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'length' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'decimals' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'case_sensitive' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'default_value' THEN
						IF rec_column.data_type <> 'VARCHAR(32)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'spaces_allowed' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'presentation' THEN
						IF rec_column.data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_permitted_value' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_itp_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_ite_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'prompt' THEN
						IF rec_column.data_type <> 'VARCHAR(32)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;
				END CASE;			
			WHEN 'bot' THEN
				CASE rec_column.table_name			
				WHEN 't_business_object_type' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_tsg_type' THEN
						IF rec_column.data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'directory' THEN
						IF rec_column.data_type <> 'VARCHAR(80)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'api_url' THEN
						IF rec_column.data_type <> 'VARCHAR(300)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_type' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_level' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'code' THEN
						IF rec_column.data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'flag_partial_key' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'flag_recursive' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'recursive_cardinality' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cardinality' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'sort_order' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'icon' THEN
						IF rec_column.data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'transferable' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_type_specialisation_group' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_level' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_tsg_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'primary_key' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_atb_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_atb_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_type_specialisation' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_tsg_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_tsp_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_tsp_tsg_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_tsp_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_attribute' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'primary_key' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'code_display_key' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'code_foreign_key' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'flag_hidden' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'default_value' THEN
						IF rec_column.data_type <> 'VARCHAR(40)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'unchangeable' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_itp_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_derivation' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_atb_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_tsg_type' THEN
						IF rec_column.data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'aggregate_function' THEN
						IF rec_column.data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_typ_name_1' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_description_attribute' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_atb_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'text' THEN
						IF rec_column.data_type <> 'VARCHAR(3999)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_restriction_type_spec_atb' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_atb_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'include_or_exclude' THEN
						IF rec_column.data_type <> 'VARCHAR(2)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_tsp_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_tsp_tsg_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_tsp_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_reference' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'primary_key' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'code_display_key' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'scope' THEN
						IF rec_column.data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'unchangeable' THEN
						IF rec_column.data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'within_scope_extension' THEN
						IF rec_column.data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_tsg_int_ext' THEN
						IF rec_column.data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_typ_name_1' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_description_reference' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_ref_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_ref_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_ref_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'text' THEN
						IF rec_column.data_type <> 'VARCHAR(3999)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_restriction_type_spec_ref' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_ref_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_ref_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_ref_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'include_or_exclude' THEN
						IF rec_column.data_type <> 'VARCHAR(2)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_tsp_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_tsp_tsg_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_tsp_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_restriction_target_type_spec' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_ref_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(1)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_ref_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_ref_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'include_or_exclude' THEN
						IF rec_column.data_type <> 'VARCHAR(2)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_tsp_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_tsp_tsg_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_tsp_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_restriction_type_spec_typ' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'include_or_exclude' THEN
						IF rec_column.data_type <> 'VARCHAR(2)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_tsp_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_tsp_tsg_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_tsp_code' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_json_path' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_level' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_jsn_name' THEN
						IF rec_column.data_type <> 'VARCHAR(32)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_jsn_location' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_jsn_atb_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_jsn_atb_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_jsn_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_tsg_obj_arr' THEN
						IF rec_column.data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_tsg_type' THEN
						IF rec_column.data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(32)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'location' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xf_atb_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_atb_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_description_type' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'text' THEN
						IF rec_column.data_type <> 'VARCHAR(3999)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;
				END CASE;			
			WHEN 'sys' THEN
				CASE rec_column.table_name			
				WHEN 't_system' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_tsg_type' THEN
						IF rec_column.data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'database' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'schema' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'password' THEN
						IF rec_column.data_type <> 'VARCHAR(20)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'table_prefix' THEN
						IF rec_column.data_type <> 'VARCHAR(4)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_system_bo_type' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_sys_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'xk_bot_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;
				END CASE;			
			WHEN 'fun' THEN
				CASE rec_column.table_name			
				WHEN 't_function' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;
					END CASE;			
				WHEN 't_argument' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'fk_fun_name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'name' THEN
						IF rec_column.data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'struct_d' THEN
						IF rec_column.data_type <> 'DATE' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'struct_t' THEN
						IF rec_column.data_type <> 'TIME' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
						END IF;			
					WHEN 'struct_dt' THEN
						IF rec_column.data_type <> 'TIMESTAMP' THEN
							EXECUTE 'ALTER TABLE ' || rec_column.schema_name || '.' || rec_column.table_name || ' RENAME COLUMN ' || rec_column.column_name || ' TO _' || rec_column.column_name ;
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
		EXECUTE 'CREATE SCHEMA IF NOT EXISTS itp';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS itp.sq_itp START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS itp.sq_ite START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS itp.sq_val START WITH 100000';

		EXECUTE 'CREATE TABLE IF NOT EXISTS itp.t_information_type ()';
		EXECUTE 'ALTER TABLE itp.t_information_type ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE itp.t_information_type ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE itp.t_information_type ADD CONSTRAINT itp_pk PRIMARY KEY (name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS itp.t_information_type_element ()';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS fk_itp_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS sequence NUMERIC(8) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS suffix VARCHAR(12) DEFAULT ''#''';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS domain VARCHAR(16) DEFAULT ''TEXT''';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS length NUMERIC(8) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS decimals NUMERIC(8) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS case_sensitive VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS default_value VARCHAR(32)';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS spaces_allowed VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD COLUMN IF NOT EXISTS presentation VARCHAR(3) DEFAULT ''LIN''';
		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD CONSTRAINT ite_pk PRIMARY KEY (fk_itp_name, sequence)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS itp.t_permitted_value ()';
		EXECUTE 'ALTER TABLE itp.t_permitted_value ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE itp.t_permitted_value ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE itp.t_permitted_value ADD COLUMN IF NOT EXISTS fk_itp_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE itp.t_permitted_value ADD COLUMN IF NOT EXISTS fk_ite_sequence NUMERIC(8) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE itp.t_permitted_value ADD COLUMN IF NOT EXISTS code VARCHAR(16)';
		EXECUTE 'ALTER TABLE itp.t_permitted_value ADD COLUMN IF NOT EXISTS prompt VARCHAR(32)';
		EXECUTE 'ALTER TABLE itp.t_permitted_value ADD CONSTRAINT val_pk PRIMARY KEY (fk_itp_name, fk_ite_sequence, code)';
		EXECUTE 'CREATE SCHEMA IF NOT EXISTS bot';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_bot START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_typ START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_tsg START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_tsp START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_atb START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_der START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_dca START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_rta START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_ref START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_dcr START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_rtr START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_rts START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_rtt START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_jsn START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_dct START WITH 100000';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_business_object_type ()';
		EXECUTE 'ALTER TABLE bot.t_business_object_type ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_business_object_type ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE bot.t_business_object_type ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_business_object_type ADD COLUMN IF NOT EXISTS cube_tsg_type VARCHAR(8) DEFAULT ''INT''';
		EXECUTE 'ALTER TABLE bot.t_business_object_type ADD COLUMN IF NOT EXISTS directory VARCHAR(80)';
		EXECUTE 'ALTER TABLE bot.t_business_object_type ADD COLUMN IF NOT EXISTS api_url VARCHAR(300)';
		EXECUTE 'ALTER TABLE bot.t_business_object_type ADD CONSTRAINT bot_pk PRIMARY KEY (name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_type ()';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS cube_level NUMERIC(8) DEFAULT ''1''';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS code VARCHAR(3)';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS flag_partial_key VARCHAR(1) DEFAULT ''Y''';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS flag_recursive VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS recursive_cardinality VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS cardinality VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS sort_order VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS icon VARCHAR(8)';
		EXECUTE 'ALTER TABLE bot.t_type ADD COLUMN IF NOT EXISTS transferable VARCHAR(1) DEFAULT ''Y''';
		EXECUTE 'ALTER TABLE bot.t_type ADD CONSTRAINT typ_pk PRIMARY KEY (name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_type_specialisation_group ()';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS cube_level NUMERIC(8) DEFAULT ''1''';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS fk_tsg_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS primary_key VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS xf_atb_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD COLUMN IF NOT EXISTS xk_atb_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD CONSTRAINT tsg_pk PRIMARY KEY (fk_typ_name, code)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_type_specialisation ()';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD COLUMN IF NOT EXISTS fk_tsg_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD COLUMN IF NOT EXISTS code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD COLUMN IF NOT EXISTS xf_tsp_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD COLUMN IF NOT EXISTS xf_tsp_tsg_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD COLUMN IF NOT EXISTS xk_tsp_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD CONSTRAINT tsp_pk PRIMARY KEY (fk_typ_name, fk_tsg_code, code)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_attribute ()';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS primary_key VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS code_display_key VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS code_foreign_key VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS flag_hidden VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS default_value VARCHAR(40)';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS unchangeable VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD COLUMN IF NOT EXISTS xk_itp_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD CONSTRAINT atb_pk PRIMARY KEY (fk_typ_name, name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_derivation ()';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD COLUMN IF NOT EXISTS fk_atb_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD COLUMN IF NOT EXISTS cube_tsg_type VARCHAR(8) DEFAULT ''DN''';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD COLUMN IF NOT EXISTS aggregate_function VARCHAR(3) DEFAULT ''SUM''';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD COLUMN IF NOT EXISTS xk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD COLUMN IF NOT EXISTS xk_typ_name_1 VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD CONSTRAINT der_pk PRIMARY KEY (fk_typ_name, fk_atb_name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_description_attribute ()';
		EXECUTE 'ALTER TABLE bot.t_description_attribute ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_description_attribute ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_description_attribute ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_description_attribute ADD COLUMN IF NOT EXISTS fk_atb_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_description_attribute ADD COLUMN IF NOT EXISTS text VARCHAR(3999)';
		EXECUTE 'ALTER TABLE bot.t_description_attribute ADD CONSTRAINT dca_pk PRIMARY KEY (fk_typ_name, fk_atb_name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_restriction_type_spec_atb ()';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD COLUMN IF NOT EXISTS fk_atb_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD COLUMN IF NOT EXISTS include_or_exclude VARCHAR(2) DEFAULT ''IN''';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD COLUMN IF NOT EXISTS xf_tsp_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD COLUMN IF NOT EXISTS xf_tsp_tsg_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD COLUMN IF NOT EXISTS xk_tsp_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD CONSTRAINT rta_pk PRIMARY KEY (fk_typ_name, fk_atb_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_reference ()';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS primary_key VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS code_display_key VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS sequence NUMERIC(1) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS scope VARCHAR(3) DEFAULT ''ALL''';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS unchangeable VARCHAR(1) DEFAULT ''N''';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS within_scope_extension VARCHAR(3)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS cube_tsg_int_ext VARCHAR(8) DEFAULT ''INT''';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS xk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS xk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS xk_typ_name_1 VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD CONSTRAINT ref_pk PRIMARY KEY (fk_typ_name, sequence, xk_bot_name, xk_typ_name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_description_reference ()';
		EXECUTE 'ALTER TABLE bot.t_description_reference ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_description_reference ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_description_reference ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_description_reference ADD COLUMN IF NOT EXISTS fk_ref_sequence NUMERIC(1) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE bot.t_description_reference ADD COLUMN IF NOT EXISTS fk_ref_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_description_reference ADD COLUMN IF NOT EXISTS fk_ref_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_description_reference ADD COLUMN IF NOT EXISTS text VARCHAR(3999)';
		EXECUTE 'ALTER TABLE bot.t_description_reference ADD CONSTRAINT dcr_pk PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_restriction_type_spec_ref ()';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD COLUMN IF NOT EXISTS fk_ref_sequence NUMERIC(1) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD COLUMN IF NOT EXISTS fk_ref_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD COLUMN IF NOT EXISTS fk_ref_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD COLUMN IF NOT EXISTS include_or_exclude VARCHAR(2) DEFAULT ''IN''';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD COLUMN IF NOT EXISTS xf_tsp_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD COLUMN IF NOT EXISTS xf_tsp_tsg_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD COLUMN IF NOT EXISTS xk_tsp_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD CONSTRAINT rtr_pk PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_restriction_target_type_spec ()';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD COLUMN IF NOT EXISTS fk_ref_sequence NUMERIC(1) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD COLUMN IF NOT EXISTS fk_ref_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD COLUMN IF NOT EXISTS fk_ref_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD COLUMN IF NOT EXISTS include_or_exclude VARCHAR(2) DEFAULT ''IN''';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD COLUMN IF NOT EXISTS xf_tsp_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD COLUMN IF NOT EXISTS xf_tsp_tsg_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD COLUMN IF NOT EXISTS xk_tsp_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD CONSTRAINT rts_pk PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_restriction_type_spec_typ ()';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD COLUMN IF NOT EXISTS include_or_exclude VARCHAR(2) DEFAULT ''IN''';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD COLUMN IF NOT EXISTS xf_tsp_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD COLUMN IF NOT EXISTS xf_tsp_tsg_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD COLUMN IF NOT EXISTS xk_tsp_code VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD CONSTRAINT rtt_pk PRIMARY KEY (fk_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_json_path ()';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS cube_level NUMERIC(8) DEFAULT ''1''';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS fk_jsn_name VARCHAR(32)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS fk_jsn_location NUMERIC(8) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS fk_jsn_atb_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS fk_jsn_atb_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS fk_jsn_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS cube_tsg_obj_arr VARCHAR(8) DEFAULT ''OBJ''';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS cube_tsg_type VARCHAR(8) DEFAULT ''GRP''';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS name VARCHAR(32)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS location NUMERIC(8) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS xf_atb_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS xk_atb_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD COLUMN IF NOT EXISTS xk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD CONSTRAINT jsn_pk PRIMARY KEY (fk_typ_name, name, location, xf_atb_typ_name, xk_atb_name, xk_typ_name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_description_type ()';
		EXECUTE 'ALTER TABLE bot.t_description_type ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_description_type ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_description_type ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_description_type ADD COLUMN IF NOT EXISTS text VARCHAR(3999)';
		EXECUTE 'ALTER TABLE bot.t_description_type ADD CONSTRAINT dct_pk PRIMARY KEY (fk_typ_name)';
		EXECUTE 'CREATE SCHEMA IF NOT EXISTS sys';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS sys.sq_sys START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS sys.sq_sbt START WITH 100000';

		EXECUTE 'CREATE TABLE IF NOT EXISTS sys.t_system ()';
		EXECUTE 'ALTER TABLE sys.t_system ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE sys.t_system ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE sys.t_system ADD COLUMN IF NOT EXISTS cube_tsg_type VARCHAR(8) DEFAULT ''PRIMARY''';
		EXECUTE 'ALTER TABLE sys.t_system ADD COLUMN IF NOT EXISTS database VARCHAR(30)';
		EXECUTE 'ALTER TABLE sys.t_system ADD COLUMN IF NOT EXISTS schema VARCHAR(30)';
		EXECUTE 'ALTER TABLE sys.t_system ADD COLUMN IF NOT EXISTS password VARCHAR(20)';
		EXECUTE 'ALTER TABLE sys.t_system ADD COLUMN IF NOT EXISTS table_prefix VARCHAR(4)';
		EXECUTE 'ALTER TABLE sys.t_system ADD CONSTRAINT sys_pk PRIMARY KEY (name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS sys.t_system_bo_type ()';
		EXECUTE 'ALTER TABLE sys.t_system_bo_type ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE sys.t_system_bo_type ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE sys.t_system_bo_type ADD COLUMN IF NOT EXISTS fk_sys_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE sys.t_system_bo_type ADD COLUMN IF NOT EXISTS xk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE sys.t_system_bo_type ADD CONSTRAINT sbt_pk PRIMARY KEY (fk_sys_name, xk_bot_name)';
		EXECUTE 'CREATE SCHEMA IF NOT EXISTS fun';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS fun.sq_fun START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS fun.sq_arg START WITH 100000';

		EXECUTE 'CREATE TABLE IF NOT EXISTS fun.t_function ()';
		EXECUTE 'ALTER TABLE fun.t_function ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE fun.t_function ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE fun.t_function ADD CONSTRAINT fun_pk PRIMARY KEY (name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS fun.t_argument ()';
		EXECUTE 'ALTER TABLE fun.t_argument ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE fun.t_argument ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE fun.t_argument ADD COLUMN IF NOT EXISTS fk_fun_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE fun.t_argument ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE fun.t_argument ADD COLUMN IF NOT EXISTS struct_d DATE DEFAULT ''1900-01-01''';
		EXECUTE 'ALTER TABLE fun.t_argument ADD COLUMN IF NOT EXISTS struct_t TIME DEFAULT ''12:00:00''';
		EXECUTE 'ALTER TABLE fun.t_argument ADD COLUMN IF NOT EXISTS struct_dt TIMESTAMP DEFAULT ''1900-01-01 12:00:00''';
		EXECUTE 'ALTER TABLE fun.t_argument ADD CONSTRAINT arg_pk PRIMARY KEY (fk_fun_name, name)';

		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD CONSTRAINT ite_itp_fk FOREIGN KEY (fk_itp_name) REFERENCES itp.t_information_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE itp.t_permitted_value ADD CONSTRAINT val_ite_fk FOREIGN KEY (fk_itp_name, fk_ite_sequence) REFERENCES itp.t_information_type_element (fk_itp_name, sequence) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type ADD CONSTRAINT typ_bot_fk FOREIGN KEY (fk_bot_name) REFERENCES bot.t_business_object_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type ADD CONSTRAINT typ_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD CONSTRAINT tsg_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD CONSTRAINT tsg_tsg_fk FOREIGN KEY (fk_typ_name, fk_tsg_code) REFERENCES bot.t_type_specialisation_group (fk_typ_name, code) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD CONSTRAINT tsp_tsg_fk FOREIGN KEY (fk_typ_name, fk_tsg_code) REFERENCES bot.t_type_specialisation_group (fk_typ_name, code) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD CONSTRAINT atb_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD CONSTRAINT der_atb_fk FOREIGN KEY (fk_typ_name, fk_atb_name) REFERENCES bot.t_attribute (fk_typ_name, name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_description_attribute ADD CONSTRAINT dca_atb_fk FOREIGN KEY (fk_typ_name, fk_atb_name) REFERENCES bot.t_attribute (fk_typ_name, name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD CONSTRAINT rta_atb_fk FOREIGN KEY (fk_typ_name, fk_atb_name) REFERENCES bot.t_attribute (fk_typ_name, name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_reference ADD CONSTRAINT ref_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_description_reference ADD CONSTRAINT dcr_ref_fk FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name) REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD CONSTRAINT rtr_ref_fk FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name) REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD CONSTRAINT rts_ref_fk FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name) REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD CONSTRAINT rtt_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD CONSTRAINT jsn_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD CONSTRAINT jsn_jsn_fk FOREIGN KEY (fk_typ_name, fk_jsn_name, fk_jsn_location, fk_jsn_atb_typ_name, fk_jsn_atb_name, fk_jsn_typ_name) REFERENCES bot.t_json_path (fk_typ_name, name, location, xf_atb_typ_name, xk_atb_name, xk_typ_name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_description_type ADD CONSTRAINT dct_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE sys.t_system_bo_type ADD CONSTRAINT sbt_sys_fk FOREIGN KEY (fk_sys_name) REFERENCES sys.t_system (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE fun.t_argument ADD CONSTRAINT arg_fun_fk FOREIGN KEY (fk_fun_name) REFERENCES fun.t_function (name) ON DELETE CASCADE';
	END;
$BODY$;


\q
