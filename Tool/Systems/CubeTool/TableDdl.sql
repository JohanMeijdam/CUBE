
-- TABLE DDL
--
BEGIN
	FOR r_s IN (
		SELECT sequence_name FROM user_sequences)
	LOOP
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||r_s.sequence_name;
	END LOOP;

	FOR r_c IN (
		SELECT table_name, constraint_name
		FROM user_constraints
		WHERE constraint_type = 'R'
		  AND TABLE_NAME IN (
			SELECT table_name 
			FROM user_tables))
	LOOP
		EXECUTE IMMEDIATE 'ALTER TABLE '||r_c.table_name||' DROP CONSTRAINT '||r_c.constraint_name;
	END LOOP;
	
	FOR r_t IN (
			SELECT table_name 
			FROM user_tables)
	LOOP
		EXECUTE IMMEDIATE 'DROP TABLE '||r_t.table_name;
	END LOOP;
END;
/
CREATE SEQUENCE sq_itp START WITH 100000
/
CREATE SEQUENCE sq_ite START WITH 100000
/
CREATE SEQUENCE sq_val START WITH 100000
/
CREATE SEQUENCE sq_bot START WITH 100000
/
CREATE SEQUENCE sq_typ START WITH 100000
/
CREATE SEQUENCE sq_atb START WITH 100000
/
CREATE SEQUENCE sq_der START WITH 100000
/
CREATE SEQUENCE sq_dca START WITH 100000
/
CREATE SEQUENCE sq_rta START WITH 100000
/
CREATE SEQUENCE sq_ref START WITH 100000
/
CREATE SEQUENCE sq_dcr START WITH 100000
/
CREATE SEQUENCE sq_rtr START WITH 100000
/
CREATE SEQUENCE sq_rts START WITH 100000
/
CREATE SEQUENCE sq_rtt START WITH 100000
/
CREATE SEQUENCE sq_jsn START WITH 100000
/
CREATE SEQUENCE sq_tsg START WITH 100000
/
CREATE SEQUENCE sq_tsp START WITH 100000
/
CREATE SEQUENCE sq_dct START WITH 100000
/
CREATE SEQUENCE sq_sys START WITH 100000
/
CREATE SEQUENCE sq_sbt START WITH 100000
/
CREATE SEQUENCE sq_fun START WITH 100000
/
CREATE SEQUENCE sq_arg START WITH 100000
/
CREATE TABLE t_information_type (
	cube_id VARCHAR2(16),
	name VARCHAR2(30),
	CONSTRAINT itp_pk
		PRIMARY KEY (name) )
/
CREATE TABLE t_information_type_element (
	cube_id VARCHAR2(16),
	fk_itp_name VARCHAR2(30),
	sequence NUMBER(8) DEFAULT '0',
	suffix VARCHAR2(12),
	domain VARCHAR2(16) DEFAULT 'TEXT',
	length NUMBER(8) DEFAULT '0',
	decimals NUMBER(8) DEFAULT '0',
	case_sensitive CHAR(1) DEFAULT 'N',
	default_value VARCHAR2(32),
	spaces_allowed CHAR(1) DEFAULT 'N',
	presentation VARCHAR2(3) DEFAULT 'LIN',
	CONSTRAINT ite_pk
		PRIMARY KEY (fk_itp_name, sequence),
	CONSTRAINT ite_itp_fk
		FOREIGN KEY (fk_itp_name)
		REFERENCES t_information_type (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_permitted_value (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_itp_name VARCHAR2(30),
	fk_ite_sequence NUMBER(8) DEFAULT '0',
	code VARCHAR2(16),
	prompt VARCHAR2(32),
	CONSTRAINT val_pk
		PRIMARY KEY (fk_itp_name, fk_ite_sequence, code),
	CONSTRAINT val_ite_fk
		FOREIGN KEY (fk_itp_name, fk_ite_sequence)
		REFERENCES t_information_type_element (fk_itp_name, sequence)
		ON DELETE CASCADE )
/
CREATE TABLE t_business_object_type (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	name VARCHAR2(30),
	cube_tsg_type VARCHAR2(8) DEFAULT 'INT',
	directory VARCHAR2(80),
	api_url VARCHAR2(300),
	CONSTRAINT bot_pk
		PRIMARY KEY (name) )
/
CREATE TABLE t_type (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	cube_level NUMBER(8) DEFAULT '1',
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	name VARCHAR2(30),
	code VARCHAR2(3),
	flag_partial_key CHAR(1) DEFAULT 'Y',
	flag_recursive CHAR(1) DEFAULT 'N',
	recursive_cardinality CHAR(1) DEFAULT 'N',
	cardinality CHAR(1) DEFAULT 'N',
	sort_order CHAR(1) DEFAULT 'N',
	icon VARCHAR2(8),
	transferable CHAR(1) DEFAULT 'Y',
	CONSTRAINT typ_pk
		PRIMARY KEY (name),
	CONSTRAINT typ_bot_fk
		FOREIGN KEY (fk_bot_name)
		REFERENCES t_business_object_type (name)
		ON DELETE CASCADE,
	CONSTRAINT typ_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_attribute (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	name VARCHAR2(30),
	primary_key CHAR(1) DEFAULT 'N',
	code_display_key CHAR(1) DEFAULT 'N',
	code_foreign_key CHAR(1) DEFAULT 'N',
	flag_hidden CHAR(1) DEFAULT 'N',
	default_value VARCHAR2(40),
	unchangeable CHAR(1) DEFAULT 'N',
	xk_itp_name VARCHAR2(30),
	CONSTRAINT atb_pk
		PRIMARY KEY (fk_typ_name, name),
	CONSTRAINT atb_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_derivation (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_atb_name VARCHAR2(30),
	cube_tsg_type VARCHAR2(8) DEFAULT 'DN',
	aggregate_function VARCHAR2(3) DEFAULT 'SUM',
	xk_typ_name VARCHAR2(30),
	xk_typ_name_1 VARCHAR2(30),
	CONSTRAINT der_pk
		PRIMARY KEY (fk_typ_name, fk_atb_name),
	CONSTRAINT der_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)
		ON DELETE CASCADE )
/
CREATE TABLE t_description_attribute (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_atb_name VARCHAR2(30),
	text VARCHAR2(3999),
	CONSTRAINT dca_pk
		PRIMARY KEY (fk_typ_name, fk_atb_name),
	CONSTRAINT dca_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)
		ON DELETE CASCADE )
/
CREATE TABLE t_restriction_type_spec_atb (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_atb_name VARCHAR2(30),
	include_or_exclude CHAR(2) DEFAULT 'IN',
	xf_tsp_typ_name VARCHAR2(30),
	xf_tsp_tsg_code VARCHAR2(16),
	xk_tsp_code VARCHAR2(16),
	CONSTRAINT rta_pk
		PRIMARY KEY (fk_typ_name, fk_atb_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code),
	CONSTRAINT rta_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)
		ON DELETE CASCADE )
/
CREATE TABLE t_reference (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	name VARCHAR2(30),
	primary_key CHAR(1) DEFAULT 'N',
	code_display_key CHAR(1) DEFAULT 'N',
	sequence NUMBER(1) DEFAULT '0',
	scope VARCHAR2(3) DEFAULT 'ALL',
	unchangeable CHAR(1) DEFAULT 'N',
	within_scope_extension VARCHAR2(3),
	xk_typ_name VARCHAR2(30),
	xk_typ_name_1 VARCHAR2(30),
	CONSTRAINT ref_pk
		PRIMARY KEY (fk_typ_name, sequence, xk_typ_name),
	CONSTRAINT ref_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_description_reference (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_ref_sequence NUMBER(1) DEFAULT '0',
	fk_ref_typ_name VARCHAR2(30),
	text VARCHAR2(3999),
	CONSTRAINT dcr_pk
		PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_typ_name),
	CONSTRAINT dcr_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_typ_name)
		REFERENCES t_reference (fk_typ_name, sequence, xk_typ_name)
		ON DELETE CASCADE )
/
CREATE TABLE t_restriction_type_spec_ref (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_ref_sequence NUMBER(1) DEFAULT '0',
	fk_ref_typ_name VARCHAR2(30),
	include_or_exclude CHAR(2) DEFAULT 'IN',
	xf_tsp_typ_name VARCHAR2(30),
	xf_tsp_tsg_code VARCHAR2(16),
	xk_tsp_code VARCHAR2(16),
	CONSTRAINT rtr_pk
		PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code),
	CONSTRAINT rtr_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_typ_name)
		REFERENCES t_reference (fk_typ_name, sequence, xk_typ_name)
		ON DELETE CASCADE )
/
CREATE TABLE t_restriction_target_type_spec (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_ref_sequence NUMBER(1) DEFAULT '0',
	fk_ref_typ_name VARCHAR2(30),
	include_or_exclude CHAR(2) DEFAULT 'IN',
	xf_tsp_typ_name VARCHAR2(30),
	xf_tsp_tsg_code VARCHAR2(16),
	xk_tsp_code VARCHAR2(16),
	CONSTRAINT rts_pk
		PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code),
	CONSTRAINT rts_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_typ_name)
		REFERENCES t_reference (fk_typ_name, sequence, xk_typ_name)
		ON DELETE CASCADE )
/
CREATE TABLE t_restriction_type_spec_typ (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	include_or_exclude CHAR(2) DEFAULT 'IN',
	xf_tsp_typ_name VARCHAR2(30),
	xf_tsp_tsg_code VARCHAR2(16),
	xk_tsp_code VARCHAR2(16),
	CONSTRAINT rtt_pk
		PRIMARY KEY (fk_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code),
	CONSTRAINT rtt_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_json_path (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	cube_level NUMBER(8) DEFAULT '1',
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_jsn_name VARCHAR2(32),
	fk_jsn_location NUMBER(8) DEFAULT '0',
	fk_jsn_atb_typ_name VARCHAR2(30),
	fk_jsn_atb_name VARCHAR2(30),
	fk_jsn_typ_name VARCHAR2(30),
	cube_tsg_obj_arr VARCHAR2(8) DEFAULT 'OBJ',
	cube_tsg_type VARCHAR2(8) DEFAULT 'GRP',
	name VARCHAR2(32),
	location NUMBER(8) DEFAULT '0',
	xf_atb_typ_name VARCHAR2(30),
	xk_atb_name VARCHAR2(30),
	xk_typ_name VARCHAR2(30),
	CONSTRAINT jsn_pk
		PRIMARY KEY (fk_typ_name, name, location, xf_atb_typ_name, xk_atb_name, xk_typ_name),
	CONSTRAINT jsn_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE,
	CONSTRAINT jsn_jsn_fk
		FOREIGN KEY (fk_typ_name, fk_jsn_name, fk_jsn_location, fk_jsn_atb_typ_name, fk_jsn_atb_name, fk_jsn_typ_name)
		REFERENCES t_json_path (fk_typ_name, name, location, xf_atb_typ_name, xk_atb_name, xk_typ_name)
		ON DELETE CASCADE )
/
CREATE TABLE t_type_specialisation_group (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	cube_level NUMBER(8) DEFAULT '1',
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_tsg_code VARCHAR2(16),
	code VARCHAR2(16),
	name VARCHAR2(30),
	primary_key CHAR(1) DEFAULT 'N',
	xf_atb_typ_name VARCHAR2(30),
	xk_atb_name VARCHAR2(30),
	CONSTRAINT tsg_pk
		PRIMARY KEY (fk_typ_name, code),
	CONSTRAINT tsg_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE,
	CONSTRAINT tsg_tsg_fk
		FOREIGN KEY (fk_typ_name, fk_tsg_code)
		REFERENCES t_type_specialisation_group (fk_typ_name, code)
		ON DELETE CASCADE )
/
CREATE TABLE t_type_specialisation (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_tsg_code VARCHAR2(16),
	code VARCHAR2(16),
	name VARCHAR2(30),
	xf_tsp_typ_name VARCHAR2(30),
	xf_tsp_tsg_code VARCHAR2(16),
	xk_tsp_code VARCHAR2(16),
	CONSTRAINT tsp_pk
		PRIMARY KEY (fk_typ_name, fk_tsg_code, code),
	CONSTRAINT tsp_tsg_fk
		FOREIGN KEY (fk_typ_name, fk_tsg_code)
		REFERENCES t_type_specialisation_group (fk_typ_name, code)
		ON DELETE CASCADE )
/
CREATE TABLE t_description_type (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	text VARCHAR2(3999),
	CONSTRAINT dct_pk
		PRIMARY KEY (fk_typ_name),
	CONSTRAINT dct_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_system (
	cube_id VARCHAR2(16),
	name VARCHAR2(30),
	cube_tsg_type VARCHAR2(8) DEFAULT 'PRIMARY',
	database VARCHAR2(30),
	schema VARCHAR2(30),
	password VARCHAR2(20),
	table_prefix VARCHAR2(4),
	CONSTRAINT sys_pk
		PRIMARY KEY (name) )
/
CREATE TABLE t_system_bo_type (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_sys_name VARCHAR2(30),
	xk_bot_name VARCHAR2(30),
	CONSTRAINT sbt_pk
		PRIMARY KEY (fk_sys_name, xk_bot_name),
	CONSTRAINT sbt_sys_fk
		FOREIGN KEY (fk_sys_name)
		REFERENCES t_system (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_function (
	cube_id VARCHAR2(16),
	name VARCHAR2(30),
	CONSTRAINT fun_pk
		PRIMARY KEY (name) )
/
CREATE TABLE t_argument (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_fun_name VARCHAR2(30),
	name VARCHAR2(30),
	CONSTRAINT arg_pk
		PRIMARY KEY (fk_fun_name, name),
	CONSTRAINT arg_fun_fk
		FOREIGN KEY (fk_fun_name)
		REFERENCES t_function (name)
		ON DELETE CASCADE )
/
EXIT;
