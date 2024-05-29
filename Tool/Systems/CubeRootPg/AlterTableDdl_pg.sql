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
			  AND schema_name NOT IN ('cube','itp','bot','sys')
		LOOP
			EXECUTE 'DROP SCHEMA ' || rec_schema.schema_name || ' CASCADE';
		END LOOP;
		
		FOR rec_schema IN 
			SELECT catalog_name, schema_name 
			FROM information_schema.schemata
			WHERE schema_owner = '<<1>>'
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
					  AND sequence_name NOT IN ('sq_bot','sq_typ','sq_tsg','sq_tsp','sq_atb','sq_der','sq_dca','sq_rta','sq_ref','sq_dcr','sq_rtr','sq_rts','sq_srv','sq_sst','sq_sva','sq_rtt','sq_jsn','sq_dct')
				LOOP
					EXECUTE 'DROP SEQUENCE ' || rec_schema.schema_name || '.' || rec_sequence.sequence_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name NOT IN ('t_business_object_type','t_type','t_type_specialisation_group','t_type_specialisation','t_attribute','t_derivation','t_description_attribute','t_restriction_type_spec_atb','t_reference','t_description_reference','t_restriction_type_spec_ref','t_restriction_target_type_spec','t_service','t_service_step','t_service_argument','t_restriction_type_spec_typ','t_json_path','t_description_type')
				LOOP
					EXECUTE 'DROP TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name;
				END LOOP;
				FOR rec_table IN
					SELECT table_name
					FROM information_schema.tables 
					WHERE table_type = 'BASE TABLE'
					  AND table_catalog = rec_schema.catalog_name
					  AND table_schema = rec_schema.schema_name
					  AND table_name IN ('t_business_object_type','t_type','t_type_specialisation_group','t_type_specialisation','t_attribute','t_derivation','t_description_attribute','t_restriction_type_spec_atb','t_reference','t_description_reference','t_restriction_type_spec_ref','t_restriction_target_type_spec','t_service','t_service_step','t_service_argument','t_restriction_type_spec_typ','t_json_path','t_description_type')
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
							  AND column_name NOT IN ('cube_id','cube_sequence','fk_bot_name','fk_typ_name','name','primary_key','code_display_key','sequence','scope','unchangeable','within_scope_extension','cube_tsg_int_ext','type_prefix','xk_bot_name','xk_typ_name','xk_typ_name_1')
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
					WHEN 't_service' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','fk_bot_name','fk_typ_name','name','cube_tsg_db_scr','class','accessibility')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_service_step' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','fk_bot_name','fk_typ_name','fk_srv_name','fk_srv_cube_tsg_db_scr','name','script_name')
						LOOP
							EXECUTE 'ALTER TABLE ' || rec_schema.schema_name || '.' || rec_table.table_name || ' DROP COLUMN ' || rec_column.column_name || ' CASCADE';
						END LOOP;
					WHEN 't_service_argument' THEN
						FOR rec_column IN
							SELECT column_name
							FROM information_schema.columns
							WHERE table_catalog = rec_schema.catalog_name
							  AND table_schema = rec_schema.schema_name
							  AND table_name = rec_table.table_name 
							  AND column_name NOT IN ('cube_id','cube_sequence','fk_bot_name','fk_typ_name','fk_srv_name','fk_srv_cube_tsg_db_scr','cube_tsg_sva_type','option_name','input_or_output','xk_itp_name','xf_atb_typ_name','xk_atb_name','xk_ref_bot_name','xk_ref_typ_name','xf_ref_typ_name','xk_ref_sequence')
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
			WHEN 'itp' THEN
				CASE rec_column.table_name			
				WHEN 't_information_type' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type ALTER COLUMN name DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_information_type_element' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'fk_itp_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN fk_itp_name TO _fk_itp_name' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN fk_itp_name DROP DEFAULT';
						END IF;			
					WHEN 'sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN sequence TO _sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN sequence SET DEFAULT ''0''';
						END IF;			
					WHEN 'suffix' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(12)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN suffix TO _suffix' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN suffix SET DEFAULT ''#''';
						END IF;			
					WHEN 'domain' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN domain TO _domain' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN domain SET DEFAULT ''TEXT''';
						END IF;			
					WHEN 'length' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN length TO _length' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN length SET DEFAULT ''0''';
						END IF;			
					WHEN 'decimals' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN decimals TO _decimals' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN decimals SET DEFAULT ''0''';
						END IF;			
					WHEN 'case_sensitive' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN case_sensitive TO _case_sensitive' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN case_sensitive SET DEFAULT ''N''';
						END IF;			
					WHEN 'default_value' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(32)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN default_value TO _default_value' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN default_value DROP DEFAULT';
						END IF;			
					WHEN 'spaces_allowed' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN spaces_allowed TO _spaces_allowed' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN spaces_allowed SET DEFAULT ''N''';
						END IF;			
					WHEN 'presentation' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE itp.t_information_type_element RENAME COLUMN presentation TO _presentation' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_information_type_element ALTER COLUMN presentation SET DEFAULT ''LIN''';
						END IF;
					END CASE;			
				WHEN 't_permitted_value' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE itp.t_permitted_value RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_permitted_value ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE itp.t_permitted_value RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_permitted_value ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'fk_itp_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE itp.t_permitted_value RENAME COLUMN fk_itp_name TO _fk_itp_name' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_permitted_value ALTER COLUMN fk_itp_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_ite_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE itp.t_permitted_value RENAME COLUMN fk_ite_sequence TO _fk_ite_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_permitted_value ALTER COLUMN fk_ite_sequence SET DEFAULT ''0''';
						END IF;			
					WHEN 'code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE itp.t_permitted_value RENAME COLUMN code TO _code' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_permitted_value ALTER COLUMN code DROP DEFAULT';
						END IF;			
					WHEN 'prompt' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(32)' THEN
							EXECUTE 'ALTER TABLE itp.t_permitted_value RENAME COLUMN prompt TO _prompt' ;
						ELSE
							EXECUTE 'ALTER TABLE itp.t_permitted_value ALTER COLUMN prompt DROP DEFAULT';
						END IF;
					END CASE;
				END CASE;			
			WHEN 'bot' THEN
				CASE rec_column.table_name			
				WHEN 't_business_object_type' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_business_object_type RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_business_object_type ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_business_object_type RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_business_object_type ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_business_object_type RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_business_object_type ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'cube_tsg_type' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_business_object_type RENAME COLUMN cube_tsg_type TO _cube_tsg_type' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_business_object_type ALTER COLUMN cube_tsg_type SET DEFAULT ''INT''';
						END IF;			
					WHEN 'directory' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(80)' THEN
							EXECUTE 'ALTER TABLE bot.t_business_object_type RENAME COLUMN directory TO _directory' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_business_object_type ALTER COLUMN directory DROP DEFAULT';
						END IF;			
					WHEN 'api_url' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(300)' THEN
							EXECUTE 'ALTER TABLE bot.t_business_object_type RENAME COLUMN api_url TO _api_url' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_business_object_type ALTER COLUMN api_url DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_type' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'cube_level' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN cube_level TO _cube_level' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN cube_level SET DEFAULT ''1''';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN code TO _code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN code DROP DEFAULT';
						END IF;			
					WHEN 'flag_partial_key' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN flag_partial_key TO _flag_partial_key' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN flag_partial_key SET DEFAULT ''Y''';
						END IF;			
					WHEN 'flag_recursive' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN flag_recursive TO _flag_recursive' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN flag_recursive SET DEFAULT ''N''';
						END IF;			
					WHEN 'recursive_cardinality' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN recursive_cardinality TO _recursive_cardinality' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN recursive_cardinality SET DEFAULT ''N''';
						END IF;			
					WHEN 'cardinality' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN cardinality TO _cardinality' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN cardinality SET DEFAULT ''N''';
						END IF;			
					WHEN 'sort_order' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN sort_order TO _sort_order' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN sort_order SET DEFAULT ''N''';
						END IF;			
					WHEN 'icon' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN icon TO _icon' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN icon DROP DEFAULT';
						END IF;			
					WHEN 'transferable' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_type RENAME COLUMN transferable TO _transferable' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type ALTER COLUMN transferable SET DEFAULT ''Y''';
						END IF;
					END CASE;			
				WHEN 't_type_specialisation_group' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'cube_level' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN cube_level TO _cube_level' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN cube_level SET DEFAULT ''1''';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_tsg_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN fk_tsg_code TO _fk_tsg_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN fk_tsg_code DROP DEFAULT';
						END IF;			
					WHEN 'code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN code TO _code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN code DROP DEFAULT';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'primary_key' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN primary_key TO _primary_key' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN primary_key SET DEFAULT ''N''';
						END IF;			
					WHEN 'xf_atb_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN xf_atb_typ_name TO _xf_atb_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN xf_atb_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_atb_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group RENAME COLUMN xk_atb_name TO _xk_atb_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ALTER COLUMN xk_atb_name DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_type_specialisation' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_tsg_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation RENAME COLUMN fk_tsg_code TO _fk_tsg_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation ALTER COLUMN fk_tsg_code DROP DEFAULT';
						END IF;			
					WHEN 'code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation RENAME COLUMN code TO _code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation ALTER COLUMN code DROP DEFAULT';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'xf_tsp_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation RENAME COLUMN xf_tsp_typ_name TO _xf_tsp_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation ALTER COLUMN xf_tsp_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xf_tsp_tsg_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation RENAME COLUMN xf_tsp_tsg_code TO _xf_tsp_tsg_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation ALTER COLUMN xf_tsp_tsg_code DROP DEFAULT';
						END IF;			
					WHEN 'xk_tsp_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_type_specialisation RENAME COLUMN xk_tsp_code TO _xk_tsp_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_type_specialisation ALTER COLUMN xk_tsp_code DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_attribute' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'primary_key' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN primary_key TO _primary_key' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN primary_key SET DEFAULT ''N''';
						END IF;			
					WHEN 'code_display_key' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN code_display_key TO _code_display_key' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN code_display_key SET DEFAULT ''N''';
						END IF;			
					WHEN 'code_foreign_key' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN code_foreign_key TO _code_foreign_key' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN code_foreign_key SET DEFAULT ''N''';
						END IF;			
					WHEN 'flag_hidden' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN flag_hidden TO _flag_hidden' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN flag_hidden SET DEFAULT ''N''';
						END IF;			
					WHEN 'default_value' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(40)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN default_value TO _default_value' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN default_value DROP DEFAULT';
						END IF;			
					WHEN 'unchangeable' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN unchangeable TO _unchangeable' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN unchangeable SET DEFAULT ''N''';
						END IF;			
					WHEN 'xk_itp_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_attribute RENAME COLUMN xk_itp_name TO _xk_itp_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_attribute ALTER COLUMN xk_itp_name DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_derivation' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_derivation RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_derivation ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_derivation RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_derivation ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_derivation RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_derivation ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_atb_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_derivation RENAME COLUMN fk_atb_name TO _fk_atb_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_derivation ALTER COLUMN fk_atb_name DROP DEFAULT';
						END IF;			
					WHEN 'cube_tsg_type' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_derivation RENAME COLUMN cube_tsg_type TO _cube_tsg_type' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_derivation ALTER COLUMN cube_tsg_type SET DEFAULT ''DN''';
						END IF;			
					WHEN 'aggregate_function' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE bot.t_derivation RENAME COLUMN aggregate_function TO _aggregate_function' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_derivation ALTER COLUMN aggregate_function SET DEFAULT ''SUM''';
						END IF;			
					WHEN 'xk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_derivation RENAME COLUMN xk_typ_name TO _xk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_derivation ALTER COLUMN xk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_typ_name_1' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_derivation RENAME COLUMN xk_typ_name_1 TO _xk_typ_name_1' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_derivation ALTER COLUMN xk_typ_name_1 DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_description_attribute' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_attribute RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_attribute ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_attribute RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_attribute ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_attribute RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_attribute ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_atb_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_attribute RENAME COLUMN fk_atb_name TO _fk_atb_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_attribute ALTER COLUMN fk_atb_name DROP DEFAULT';
						END IF;			
					WHEN 'text' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(3999)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_attribute RENAME COLUMN text TO _text' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_attribute ALTER COLUMN text DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_restriction_type_spec_atb' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_atb_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb RENAME COLUMN fk_atb_name TO _fk_atb_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ALTER COLUMN fk_atb_name DROP DEFAULT';
						END IF;			
					WHEN 'include_or_exclude' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(2)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb RENAME COLUMN include_or_exclude TO _include_or_exclude' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ALTER COLUMN include_or_exclude SET DEFAULT ''IN''';
						END IF;			
					WHEN 'xf_tsp_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb RENAME COLUMN xf_tsp_typ_name TO _xf_tsp_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ALTER COLUMN xf_tsp_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xf_tsp_tsg_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb RENAME COLUMN xf_tsp_tsg_code TO _xf_tsp_tsg_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ALTER COLUMN xf_tsp_tsg_code DROP DEFAULT';
						END IF;			
					WHEN 'xk_tsp_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb RENAME COLUMN xk_tsp_code TO _xk_tsp_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ALTER COLUMN xk_tsp_code DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_reference' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'primary_key' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN primary_key TO _primary_key' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN primary_key SET DEFAULT ''N''';
						END IF;			
					WHEN 'code_display_key' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN code_display_key TO _code_display_key' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN code_display_key SET DEFAULT ''N''';
						END IF;			
					WHEN 'sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN sequence TO _sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN sequence SET DEFAULT ''0''';
						END IF;			
					WHEN 'scope' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN scope TO _scope' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN scope SET DEFAULT ''ALL''';
						END IF;			
					WHEN 'unchangeable' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN unchangeable TO _unchangeable' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN unchangeable SET DEFAULT ''N''';
						END IF;			
					WHEN 'within_scope_extension' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN within_scope_extension TO _within_scope_extension' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN within_scope_extension DROP DEFAULT';
						END IF;			
					WHEN 'cube_tsg_int_ext' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN cube_tsg_int_ext TO _cube_tsg_int_ext' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN cube_tsg_int_ext SET DEFAULT ''INT''';
						END IF;			
					WHEN 'type_prefix' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN type_prefix TO _type_prefix' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN type_prefix SET DEFAULT ''N''';
						END IF;			
					WHEN 'xk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN xk_bot_name TO _xk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN xk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN xk_typ_name TO _xk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN xk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_typ_name_1' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_reference RENAME COLUMN xk_typ_name_1 TO _xk_typ_name_1' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_reference ALTER COLUMN xk_typ_name_1 DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_description_reference' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_reference RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_reference ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_reference RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_reference ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_reference RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_reference ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_ref_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_reference RENAME COLUMN fk_ref_sequence TO _fk_ref_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_reference ALTER COLUMN fk_ref_sequence SET DEFAULT ''0''';
						END IF;			
					WHEN 'fk_ref_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_reference RENAME COLUMN fk_ref_bot_name TO _fk_ref_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_reference ALTER COLUMN fk_ref_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_ref_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_reference RENAME COLUMN fk_ref_typ_name TO _fk_ref_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_reference ALTER COLUMN fk_ref_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'text' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(3999)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_reference RENAME COLUMN text TO _text' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_reference ALTER COLUMN text DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_restriction_type_spec_ref' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_ref_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref RENAME COLUMN fk_ref_sequence TO _fk_ref_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ALTER COLUMN fk_ref_sequence SET DEFAULT ''0''';
						END IF;			
					WHEN 'fk_ref_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref RENAME COLUMN fk_ref_bot_name TO _fk_ref_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ALTER COLUMN fk_ref_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_ref_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref RENAME COLUMN fk_ref_typ_name TO _fk_ref_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ALTER COLUMN fk_ref_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'include_or_exclude' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(2)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref RENAME COLUMN include_or_exclude TO _include_or_exclude' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ALTER COLUMN include_or_exclude SET DEFAULT ''IN''';
						END IF;			
					WHEN 'xf_tsp_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref RENAME COLUMN xf_tsp_typ_name TO _xf_tsp_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ALTER COLUMN xf_tsp_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xf_tsp_tsg_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref RENAME COLUMN xf_tsp_tsg_code TO _xf_tsp_tsg_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ALTER COLUMN xf_tsp_tsg_code DROP DEFAULT';
						END IF;			
					WHEN 'xk_tsp_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref RENAME COLUMN xk_tsp_code TO _xk_tsp_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ALTER COLUMN xk_tsp_code DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_restriction_target_type_spec' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_ref_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec RENAME COLUMN fk_ref_sequence TO _fk_ref_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ALTER COLUMN fk_ref_sequence SET DEFAULT ''0''';
						END IF;			
					WHEN 'fk_ref_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec RENAME COLUMN fk_ref_bot_name TO _fk_ref_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ALTER COLUMN fk_ref_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_ref_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec RENAME COLUMN fk_ref_typ_name TO _fk_ref_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ALTER COLUMN fk_ref_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'include_or_exclude' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(2)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec RENAME COLUMN include_or_exclude TO _include_or_exclude' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ALTER COLUMN include_or_exclude SET DEFAULT ''IN''';
						END IF;			
					WHEN 'xf_tsp_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec RENAME COLUMN xf_tsp_typ_name TO _xf_tsp_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ALTER COLUMN xf_tsp_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xf_tsp_tsg_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec RENAME COLUMN xf_tsp_tsg_code TO _xf_tsp_tsg_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ALTER COLUMN xf_tsp_tsg_code DROP DEFAULT';
						END IF;			
					WHEN 'xk_tsp_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec RENAME COLUMN xk_tsp_code TO _xk_tsp_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ALTER COLUMN xk_tsp_code DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_service' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_service RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_service RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'cube_tsg_db_scr' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_service RENAME COLUMN cube_tsg_db_scr TO _cube_tsg_db_scr' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service ALTER COLUMN cube_tsg_db_scr SET DEFAULT ''D''';
						END IF;			
					WHEN 'class' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(3)' THEN
							EXECUTE 'ALTER TABLE bot.t_service RENAME COLUMN class TO _class' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service ALTER COLUMN class DROP DEFAULT';
						END IF;			
					WHEN 'accessibility' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_service RENAME COLUMN accessibility TO _accessibility' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service ALTER COLUMN accessibility DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_service_step' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_step RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_step ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_step RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_step ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_step RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_step ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_step RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_step ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_srv_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_step RENAME COLUMN fk_srv_name TO _fk_srv_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_step ALTER COLUMN fk_srv_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_srv_cube_tsg_db_scr' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_step RENAME COLUMN fk_srv_cube_tsg_db_scr TO _fk_srv_cube_tsg_db_scr' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_step ALTER COLUMN fk_srv_cube_tsg_db_scr SET DEFAULT ''D''';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_step RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_step ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'script_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(60)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_step RENAME COLUMN script_name TO _script_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_step ALTER COLUMN script_name DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_service_argument' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_srv_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN fk_srv_name TO _fk_srv_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN fk_srv_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_srv_cube_tsg_db_scr' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN fk_srv_cube_tsg_db_scr TO _fk_srv_cube_tsg_db_scr' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN fk_srv_cube_tsg_db_scr SET DEFAULT ''D''';
						END IF;			
					WHEN 'cube_tsg_sva_type' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN cube_tsg_sva_type TO _cube_tsg_sva_type' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN cube_tsg_sva_type SET DEFAULT ''OPT''';
						END IF;			
					WHEN 'option_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN option_name TO _option_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN option_name DROP DEFAULT';
						END IF;			
					WHEN 'input_or_output' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN input_or_output TO _input_or_output' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN input_or_output SET DEFAULT ''I''';
						END IF;			
					WHEN 'xk_itp_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN xk_itp_name TO _xk_itp_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN xk_itp_name DROP DEFAULT';
						END IF;			
					WHEN 'xf_atb_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN xf_atb_typ_name TO _xf_atb_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN xf_atb_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_atb_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN xk_atb_name TO _xk_atb_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN xk_atb_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_ref_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN xk_ref_bot_name TO _xk_ref_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN xk_ref_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_ref_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN xk_ref_typ_name TO _xk_ref_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN xk_ref_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xf_ref_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN xf_ref_typ_name TO _xf_ref_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN xf_ref_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_ref_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(1)' THEN
							EXECUTE 'ALTER TABLE bot.t_service_argument RENAME COLUMN xk_ref_sequence TO _xk_ref_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_service_argument ALTER COLUMN xk_ref_sequence SET DEFAULT ''0''';
						END IF;
					END CASE;			
				WHEN 't_restriction_type_spec_typ' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'include_or_exclude' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(2)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ RENAME COLUMN include_or_exclude TO _include_or_exclude' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ALTER COLUMN include_or_exclude SET DEFAULT ''IN''';
						END IF;			
					WHEN 'xf_tsp_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ RENAME COLUMN xf_tsp_typ_name TO _xf_tsp_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ALTER COLUMN xf_tsp_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xf_tsp_tsg_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ RENAME COLUMN xf_tsp_tsg_code TO _xf_tsp_tsg_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ALTER COLUMN xf_tsp_tsg_code DROP DEFAULT';
						END IF;			
					WHEN 'xk_tsp_code' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ RENAME COLUMN xk_tsp_code TO _xk_tsp_code' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ALTER COLUMN xk_tsp_code DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_json_path' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'cube_level' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN cube_level TO _cube_level' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN cube_level SET DEFAULT ''1''';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_jsn_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(32)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN fk_jsn_name TO _fk_jsn_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN fk_jsn_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_jsn_location' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN fk_jsn_location TO _fk_jsn_location' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN fk_jsn_location SET DEFAULT ''0''';
						END IF;			
					WHEN 'fk_jsn_atb_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN fk_jsn_atb_typ_name TO _fk_jsn_atb_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN fk_jsn_atb_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_jsn_atb_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN fk_jsn_atb_name TO _fk_jsn_atb_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN fk_jsn_atb_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_jsn_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN fk_jsn_typ_name TO _fk_jsn_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN fk_jsn_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'cube_tsg_obj_arr' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN cube_tsg_obj_arr TO _cube_tsg_obj_arr' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN cube_tsg_obj_arr SET DEFAULT ''OBJ''';
						END IF;			
					WHEN 'cube_tsg_type' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN cube_tsg_type TO _cube_tsg_type' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN cube_tsg_type SET DEFAULT ''GRP''';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(32)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'location' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN location TO _location' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN location SET DEFAULT ''0''';
						END IF;			
					WHEN 'xf_atb_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN xf_atb_typ_name TO _xf_atb_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN xf_atb_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_atb_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN xk_atb_name TO _xk_atb_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN xk_atb_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_json_path RENAME COLUMN xk_typ_name TO _xk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_json_path ALTER COLUMN xk_typ_name DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_description_type' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_type RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_type ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'fk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_type RENAME COLUMN fk_bot_name TO _fk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_type ALTER COLUMN fk_bot_name DROP DEFAULT';
						END IF;			
					WHEN 'fk_typ_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_type RENAME COLUMN fk_typ_name TO _fk_typ_name' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_type ALTER COLUMN fk_typ_name DROP DEFAULT';
						END IF;			
					WHEN 'text' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(3999)' THEN
							EXECUTE 'ALTER TABLE bot.t_description_type RENAME COLUMN text TO _text' ;
						ELSE
							EXECUTE 'ALTER TABLE bot.t_description_type ALTER COLUMN text DROP DEFAULT';
						END IF;
					END CASE;
				END CASE;			
			WHEN 'sys' THEN
				CASE rec_column.table_name			
				WHEN 't_system' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE sys.t_system RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE sys.t_system RENAME COLUMN name TO _name' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system ALTER COLUMN name DROP DEFAULT';
						END IF;			
					WHEN 'cube_tsg_type' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(8)' THEN
							EXECUTE 'ALTER TABLE sys.t_system RENAME COLUMN cube_tsg_type TO _cube_tsg_type' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system ALTER COLUMN cube_tsg_type SET DEFAULT ''PRIMARY''';
						END IF;			
					WHEN 'database' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE sys.t_system RENAME COLUMN database TO _database' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system ALTER COLUMN database DROP DEFAULT';
						END IF;			
					WHEN 'schema' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE sys.t_system RENAME COLUMN schema TO _schema' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system ALTER COLUMN schema DROP DEFAULT';
						END IF;			
					WHEN 'password' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(20)' THEN
							EXECUTE 'ALTER TABLE sys.t_system RENAME COLUMN password TO _password' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system ALTER COLUMN password DROP DEFAULT';
						END IF;			
					WHEN 'table_prefix' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(4)' THEN
							EXECUTE 'ALTER TABLE sys.t_system RENAME COLUMN table_prefix TO _table_prefix' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system ALTER COLUMN table_prefix DROP DEFAULT';
						END IF;
					END CASE;			
				WHEN 't_system_bo_type' THEN
					CASE rec_column.column_name			
					WHEN 'cube_id' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(16)' THEN
							EXECUTE 'ALTER TABLE sys.t_system_bo_type RENAME COLUMN cube_id TO _cube_id' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system_bo_type ALTER COLUMN cube_id DROP DEFAULT';
						END IF;			
					WHEN 'cube_sequence' THEN
						IF rec_column.cube_data_type <> 'NUMERIC(8)' THEN
							EXECUTE 'ALTER TABLE sys.t_system_bo_type RENAME COLUMN cube_sequence TO _cube_sequence' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system_bo_type ALTER COLUMN cube_sequence DROP DEFAULT';
						END IF;			
					WHEN 'fk_sys_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE sys.t_system_bo_type RENAME COLUMN fk_sys_name TO _fk_sys_name' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system_bo_type ALTER COLUMN fk_sys_name DROP DEFAULT';
						END IF;			
					WHEN 'xk_bot_name' THEN
						IF rec_column.cube_data_type <> 'VARCHAR(30)' THEN
							EXECUTE 'ALTER TABLE sys.t_system_bo_type RENAME COLUMN xk_bot_name TO _xk_bot_name' ;
						ELSE
							EXECUTE 'ALTER TABLE sys.t_system_bo_type ALTER COLUMN xk_bot_name DROP DEFAULT';
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
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_srv START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_sst START WITH 100000';
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS bot.sq_sva START WITH 100000';
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
		EXECUTE 'ALTER TABLE bot.t_reference ADD COLUMN IF NOT EXISTS type_prefix VARCHAR(1) DEFAULT ''N''';
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

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_service ()';
		EXECUTE 'ALTER TABLE bot.t_service ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_service ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE bot.t_service ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service ADD COLUMN IF NOT EXISTS cube_tsg_db_scr VARCHAR(8) DEFAULT ''D''';
		EXECUTE 'ALTER TABLE bot.t_service ADD COLUMN IF NOT EXISTS class VARCHAR(3)';
		EXECUTE 'ALTER TABLE bot.t_service ADD COLUMN IF NOT EXISTS accessibility VARCHAR(1)';
		EXECUTE 'ALTER TABLE bot.t_service ADD CONSTRAINT srv_pk PRIMARY KEY (fk_typ_name, name, cube_tsg_db_scr)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_service_step ()';
		EXECUTE 'ALTER TABLE bot.t_service_step ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_service_step ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE bot.t_service_step ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_step ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_step ADD COLUMN IF NOT EXISTS fk_srv_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_step ADD COLUMN IF NOT EXISTS fk_srv_cube_tsg_db_scr VARCHAR(8) DEFAULT ''D''';
		EXECUTE 'ALTER TABLE bot.t_service_step ADD COLUMN IF NOT EXISTS name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_step ADD COLUMN IF NOT EXISTS script_name VARCHAR(60)';
		EXECUTE 'ALTER TABLE bot.t_service_step ADD CONSTRAINT sst_pk PRIMARY KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr, name)';

		EXECUTE 'CREATE TABLE IF NOT EXISTS bot.t_service_argument ()';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS cube_id VARCHAR(16)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS cube_sequence NUMERIC(8)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS fk_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS fk_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS fk_srv_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS fk_srv_cube_tsg_db_scr VARCHAR(8) DEFAULT ''D''';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS cube_tsg_sva_type VARCHAR(8) DEFAULT ''OPT''';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS option_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS input_or_output VARCHAR(1) DEFAULT ''I''';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS xk_itp_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS xf_atb_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS xk_atb_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS xk_ref_bot_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS xk_ref_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS xf_ref_typ_name VARCHAR(30)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD COLUMN IF NOT EXISTS xk_ref_sequence NUMERIC(1) DEFAULT ''0''';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD CONSTRAINT sva_pk PRIMARY KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr, option_name, xf_atb_typ_name, xk_atb_name)';

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

		EXECUTE 'ALTER TABLE itp.t_information_type_element ADD CONSTRAINT ite_itp_fk FOREIGN KEY (fk_itp_name) REFERENCES itp.t_information_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE itp.t_permitted_value ADD CONSTRAINT val_ite_fk FOREIGN KEY (fk_itp_name, fk_ite_sequence) REFERENCES itp.t_information_type_element (fk_itp_name, sequence) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type ADD CONSTRAINT typ_bot_fk FOREIGN KEY (fk_bot_name) REFERENCES bot.t_business_object_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type ADD CONSTRAINT typ_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD CONSTRAINT tsg_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD CONSTRAINT tsg_tsg_fk FOREIGN KEY (fk_typ_name, fk_tsg_code) REFERENCES bot.t_type_specialisation_group (fk_typ_name, code) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation_group ADD CONSTRAINT tsg_atb_0_xf FOREIGN KEY (xf_atb_typ_name, xk_atb_name) REFERENCES bot.t_attribute (fk_typ_name, name)';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD CONSTRAINT tsp_tsg_fk FOREIGN KEY (fk_typ_name, fk_tsg_code) REFERENCES bot.t_type_specialisation_group (fk_typ_name, code) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_type_specialisation ADD CONSTRAINT tsp_tsp_0_xf FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code) REFERENCES bot.t_type_specialisation (fk_typ_name, fk_tsg_code, code)';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD CONSTRAINT atb_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_attribute ADD CONSTRAINT atb_itp_0_xf FOREIGN KEY (xk_itp_name) REFERENCES bot.t_information_type (name)';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD CONSTRAINT der_atb_fk FOREIGN KEY (fk_typ_name, fk_atb_name) REFERENCES bot.t_attribute (fk_typ_name, name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD CONSTRAINT der_typ_0_xf FOREIGN KEY (xk_typ_name) REFERENCES bot.t_type (name)';
		EXECUTE 'ALTER TABLE bot.t_derivation ADD CONSTRAINT der_typ_1_xf FOREIGN KEY (xk_typ_name_1) REFERENCES bot.t_type (name)';
		EXECUTE 'ALTER TABLE bot.t_description_attribute ADD CONSTRAINT dca_atb_fk FOREIGN KEY (fk_typ_name, fk_atb_name) REFERENCES bot.t_attribute (fk_typ_name, name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD CONSTRAINT rta_atb_fk FOREIGN KEY (fk_typ_name, fk_atb_name) REFERENCES bot.t_attribute (fk_typ_name, name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_atb ADD CONSTRAINT rta_tsp_0_xf FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code) REFERENCES bot.t_type_specialisation (fk_typ_name, fk_tsg_code, code)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD CONSTRAINT ref_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_reference ADD CONSTRAINT ref_bot_0_xf FOREIGN KEY (xk_bot_name) REFERENCES bot.t_business_object_type (name)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD CONSTRAINT ref_typ_0_xf FOREIGN KEY (xk_typ_name) REFERENCES bot.t_type (name)';
		EXECUTE 'ALTER TABLE bot.t_reference ADD CONSTRAINT ref_typ_1_xf FOREIGN KEY (xk_typ_name_1) REFERENCES bot.t_type (name)';
		EXECUTE 'ALTER TABLE bot.t_description_reference ADD CONSTRAINT dcr_ref_fk FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name) REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD CONSTRAINT rtr_ref_fk FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name) REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_ref ADD CONSTRAINT rtr_tsp_0_xf FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code) REFERENCES bot.t_type_specialisation (fk_typ_name, fk_tsg_code, code)';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD CONSTRAINT rts_ref_fk FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name) REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_restriction_target_type_spec ADD CONSTRAINT rts_tsp_0_xf FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code) REFERENCES bot.t_type_specialisation (fk_typ_name, fk_tsg_code, code)';
		EXECUTE 'ALTER TABLE bot.t_service ADD CONSTRAINT srv_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_service_step ADD CONSTRAINT sst_srv_fk FOREIGN KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr) REFERENCES bot.t_service (fk_typ_name, name, cube_tsg_db_scr) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD CONSTRAINT sva_srv_fk FOREIGN KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr) REFERENCES bot.t_service (fk_typ_name, name, cube_tsg_db_scr) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD CONSTRAINT sva_itp_0_xf FOREIGN KEY (xk_itp_name) REFERENCES bot.t_information_type (name)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD CONSTRAINT sva_atb_0_xf FOREIGN KEY (xf_atb_typ_name, xk_atb_name) REFERENCES bot.t_attribute (fk_typ_name, name)';
		EXECUTE 'ALTER TABLE bot.t_service_argument ADD CONSTRAINT sva_ref_0_xf FOREIGN KEY (xf_ref_typ_name, xk_ref_sequence, xk_ref_bot_name, xk_ref_typ_name) REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name)';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD CONSTRAINT rtt_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_restriction_type_spec_typ ADD CONSTRAINT rtt_tsp_0_xf FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code) REFERENCES bot.t_type_specialisation (fk_typ_name, fk_tsg_code, code)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD CONSTRAINT jsn_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD CONSTRAINT jsn_jsn_fk FOREIGN KEY (fk_typ_name, fk_jsn_name, fk_jsn_location, fk_jsn_atb_typ_name, fk_jsn_atb_name, fk_jsn_typ_name) REFERENCES bot.t_json_path (fk_typ_name, name, location, xf_atb_typ_name, xk_atb_name, xk_typ_name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD CONSTRAINT jsn_atb_0_xf FOREIGN KEY (xf_atb_typ_name, xk_atb_name) REFERENCES bot.t_attribute (fk_typ_name, name)';
		EXECUTE 'ALTER TABLE bot.t_json_path ADD CONSTRAINT jsn_typ_0_xf FOREIGN KEY (xk_typ_name) REFERENCES bot.t_type (name)';
		EXECUTE 'ALTER TABLE bot.t_description_type ADD CONSTRAINT dct_typ_fk FOREIGN KEY (fk_typ_name) REFERENCES bot.t_type (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE sys.t_system_bo_type ADD CONSTRAINT sbt_sys_fk FOREIGN KEY (fk_sys_name) REFERENCES sys.t_system (name) ON DELETE CASCADE';
		EXECUTE 'ALTER TABLE sys.t_system_bo_type ADD CONSTRAINT sbt_bot_0_xf FOREIGN KEY (xk_bot_name) REFERENCES sys.t_business_object_type (name)';
	END;
$BODY$;

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
