
-- TABLE DDL
--
BEGIN
	FOR r_s IN (
		SELECT sequence_name FROM user_sequences
		WHERE NVL(SUBSTR(sequence_name,1,INSTR(sequence_name,'_',4)),' ') NOT IN ('SC_CUBE_'))
	LOOP
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||r_s.sequence_name;
	END LOOP;

	FOR r_c IN (
		SELECT table_name, constraint_name
		FROM user_constraints
		WHERE constraint_type = 'R'
		  AND TABLE_NAME IN (
			SELECT table_name 
			FROM user_tables
			WHERE NVL(SUBSTR(table_name,1,INSTR(table_name,'_',3)),' ') NOT IN ('T_CUBE_')))
	LOOP
		EXECUTE IMMEDIATE 'ALTER TABLE '||r_c.table_name||' DROP CONSTRAINT '||r_c.constraint_name;
	END LOOP;
	
	FOR r_t IN (
			SELECT table_name 
			FROM user_tables
		WHERE NVL(SUBSTR(table_name,1,INSTR(table_name,'_',3)),' ') NOT IN ('T_CUBE_'))
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
CREATE SEQUENCE sq_tsg START WITH 100000
/
CREATE SEQUENCE sq_tsp START WITH 100000
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
CREATE SEQUENCE sq_srv START WITH 100000
/
CREATE SEQUENCE sq_sst START WITH 100000
/
CREATE SEQUENCE sq_svd START WITH 100000
/
CREATE SEQUENCE sq_rtt START WITH 100000
/
CREATE SEQUENCE sq_jsn START WITH 100000
/
CREATE SEQUENCE sq_dct START WITH 100000
/
CREATE SEQUENCE sq_sys START WITH 100000
/
CREATE SEQUENCE sq_sbt START WITH 100000
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
	suffix VARCHAR2(12) DEFAULT '#',
	domain VARCHAR2(16) DEFAULT 'TEXT',
	length NUMBER(8) DEFAULT '0',
	decimals NUMBER(8) DEFAULT '0',
	case_sensitive CHAR(1) DEFAULT 'N',
	default_value VARCHAR2(32),
	spaces_allowed CHAR(1) DEFAULT 'N',
	presentation VARCHAR2(3) DEFAULT 'LIN',
	CONSTRAINT ite_pk
		PRIMARY KEY (fk_itp_name, sequence) )
/
CREATE TABLE t_permitted_value (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_itp_name VARCHAR2(30),
	fk_ite_sequence NUMBER(8) DEFAULT '0',
	code VARCHAR2(16),
	prompt VARCHAR2(32),
	CONSTRAINT val_pk
		PRIMARY KEY (fk_itp_name, fk_ite_sequence, code) )
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
		PRIMARY KEY (name) )
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
		PRIMARY KEY (fk_typ_name, code) )
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
		PRIMARY KEY (fk_typ_name, fk_tsg_code, code) )
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
		PRIMARY KEY (fk_typ_name, name) )
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
		PRIMARY KEY (fk_typ_name, fk_atb_name) )
/
CREATE TABLE t_description_attribute (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_atb_name VARCHAR2(30),
	text VARCHAR2(3999),
	CONSTRAINT dca_pk
		PRIMARY KEY (fk_typ_name, fk_atb_name) )
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
		PRIMARY KEY (fk_typ_name, fk_atb_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code) )
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
	cube_tsg_int_ext VARCHAR2(8) DEFAULT 'INT',
	type_prefix CHAR(1) DEFAULT 'N',
	xk_bot_name VARCHAR2(30),
	xk_typ_name VARCHAR2(30),
	xk_typ_name_1 VARCHAR2(30),
	CONSTRAINT ref_pk
		PRIMARY KEY (fk_typ_name, sequence, xk_bot_name, xk_typ_name) )
/
CREATE TABLE t_description_reference (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_ref_sequence NUMBER(1) DEFAULT '0',
	fk_ref_bot_name VARCHAR2(30),
	fk_ref_typ_name VARCHAR2(30),
	text VARCHAR2(3999),
	CONSTRAINT dcr_pk
		PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name) )
/
CREATE TABLE t_restriction_type_spec_ref (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_ref_sequence NUMBER(1) DEFAULT '0',
	fk_ref_bot_name VARCHAR2(30),
	fk_ref_typ_name VARCHAR2(30),
	include_or_exclude CHAR(2) DEFAULT 'IN',
	xf_tsp_typ_name VARCHAR2(30),
	xf_tsp_tsg_code VARCHAR2(16),
	xk_tsp_code VARCHAR2(16),
	CONSTRAINT rtr_pk
		PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code) )
/
CREATE TABLE t_restriction_target_type_spec (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_ref_sequence NUMBER(1) DEFAULT '0',
	fk_ref_bot_name VARCHAR2(30),
	fk_ref_typ_name VARCHAR2(30),
	include_or_exclude CHAR(2) DEFAULT 'IN',
	xf_tsp_typ_name VARCHAR2(30),
	xf_tsp_tsg_code VARCHAR2(16),
	xk_tsp_code VARCHAR2(16),
	CONSTRAINT rts_pk
		PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code) )
/
CREATE TABLE t_service (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	name VARCHAR2(30),
	cube_tsg_db_scr VARCHAR2(8) DEFAULT 'D',
	class VARCHAR2(3),
	accessibility CHAR(1),
	CONSTRAINT srv_pk
		PRIMARY KEY (fk_typ_name, name, cube_tsg_db_scr) )
/
CREATE TABLE t_service_step (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_srv_name VARCHAR2(30),
	fk_srv_cube_tsg_db_scr VARCHAR2(8) DEFAULT 'D',
	name VARCHAR2(30),
	script_name VARCHAR2(60),
	CONSTRAINT sst_pk
		PRIMARY KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr, name) )
/
CREATE TABLE t_service_detail (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_srv_name VARCHAR2(30),
	fk_srv_cube_tsg_db_scr VARCHAR2(8) DEFAULT 'D',
	cube_tsg_atb_ref VARCHAR2(8) DEFAULT 'ATB',
	xf_atb_typ_name VARCHAR2(30),
	xk_atb_name VARCHAR2(30),
	xk_ref_bot_name VARCHAR2(30),
	xk_ref_typ_name VARCHAR2(30),
	xf_ref_typ_name VARCHAR2(30),
	xk_ref_sequence NUMBER(1) DEFAULT '0',
	CONSTRAINT svd_pk
		PRIMARY KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr, xf_atb_typ_name, xk_atb_name, xk_ref_bot_name, xk_ref_typ_name, xf_ref_typ_name, xk_ref_sequence) )
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
		PRIMARY KEY (fk_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code) )
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
		PRIMARY KEY (fk_typ_name, name, location, xf_atb_typ_name, xk_atb_name, xk_typ_name) )
/
CREATE TABLE t_description_type (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	text VARCHAR2(3999),
	CONSTRAINT dct_pk
		PRIMARY KEY (fk_typ_name) )
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
		PRIMARY KEY (fk_sys_name, xk_bot_name) )
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Insert CUBE-NULL rows');
	INSERT INTO t_information_type (cube_id,name) VALUES ('CUBE-NULL',' ');
	INSERT INTO t_information_type_element (cube_id,fk_itp_name,sequence) VALUES ('CUBE-NULL',' ',0);
	INSERT INTO t_permitted_value (cube_id,fk_itp_name,fk_ite_sequence,code) VALUES ('CUBE-NULL',' ',0,' ');
	INSERT INTO t_business_object_type (cube_id,name) VALUES ('CUBE-NULL',' ');
	INSERT INTO t_type (cube_id,name) VALUES ('CUBE-NULL',' ');
	INSERT INTO t_type_specialisation_group (cube_id,fk_typ_name,code) VALUES ('CUBE-NULL',' ',' ');
	INSERT INTO t_type_specialisation (cube_id,fk_typ_name,fk_tsg_code,code) VALUES ('CUBE-NULL',' ',' ',' ');
	INSERT INTO t_attribute (cube_id,fk_typ_name,name) VALUES ('CUBE-NULL',' ',' ');
	INSERT INTO t_derivation (cube_id,fk_typ_name,fk_atb_name) VALUES ('CUBE-NULL',' ',' ');
	INSERT INTO t_description_attribute (cube_id,fk_typ_name,fk_atb_name) VALUES ('CUBE-NULL',' ',' ');
	INSERT INTO t_restriction_type_spec_atb (cube_id,fk_typ_name,fk_atb_name,xf_tsp_typ_name,xf_tsp_tsg_code,xk_tsp_code) VALUES ('CUBE-NULL',' ',' ',' ',' ',' ');
	INSERT INTO t_reference (cube_id,fk_typ_name,sequence,xk_bot_name,xk_typ_name) VALUES ('CUBE-NULL',' ',0,' ',' ');
	INSERT INTO t_description_reference (cube_id,fk_typ_name,fk_ref_sequence,fk_ref_bot_name,fk_ref_typ_name) VALUES ('CUBE-NULL',' ',0,' ',' ');
	INSERT INTO t_restriction_type_spec_ref (cube_id,fk_typ_name,fk_ref_sequence,fk_ref_bot_name,fk_ref_typ_name,xf_tsp_typ_name,xf_tsp_tsg_code,xk_tsp_code) VALUES ('CUBE-NULL',' ',0,' ',' ',' ',' ',' ');
	INSERT INTO t_restriction_target_type_spec (cube_id,fk_typ_name,fk_ref_sequence,fk_ref_bot_name,fk_ref_typ_name,xf_tsp_typ_name,xf_tsp_tsg_code,xk_tsp_code) VALUES ('CUBE-NULL',' ',0,' ',' ',' ',' ',' ');
	INSERT INTO t_service (cube_id,fk_typ_name,name,cube_tsg_db_scr) VALUES ('CUBE-NULL',' ',' ',' ');
	INSERT INTO t_service_step (cube_id,fk_typ_name,fk_srv_name,fk_srv_cube_tsg_db_scr,name) VALUES ('CUBE-NULL',' ',' ',' ',' ');
	INSERT INTO t_service_detail (cube_id,fk_typ_name,fk_srv_name,fk_srv_cube_tsg_db_scr,xf_atb_typ_name,xk_atb_name,xk_ref_bot_name,xk_ref_typ_name,xf_ref_typ_name,xk_ref_sequence) VALUES ('CUBE-NULL',' ',' ',' ',' ',' ',' ',' ',' ',0);
	INSERT INTO t_restriction_type_spec_typ (cube_id,fk_typ_name,xf_tsp_typ_name,xf_tsp_tsg_code,xk_tsp_code) VALUES ('CUBE-NULL',' ',' ',' ',' ');
	INSERT INTO t_json_path (cube_id,fk_typ_name,name,location,xf_atb_typ_name,xk_atb_name,xk_typ_name) VALUES ('CUBE-NULL',' ',' ',0,' ',' ',' ');
	INSERT INTO t_description_type (cube_id,fk_typ_name) VALUES ('CUBE-NULL',' ');
	INSERT INTO t_system (cube_id,name) VALUES ('CUBE-NULL',' ');
	INSERT INTO t_system_bo_type (cube_id,fk_sys_name,xk_bot_name) VALUES ('CUBE-NULL',' ',' ');
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_INFORMATION_TYPE');
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_INFORMATION_TYPE_ELEMENT');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_information_type_element ADD CONSTRAINT ite_itp_fk
		FOREIGN KEY (fk_itp_name)
		REFERENCES t_information_type (name)
		ON DELETE CASCADE';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_PERMITTED_VALUE');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_permitted_value ADD CONSTRAINT val_ite_fk
		FOREIGN KEY (fk_itp_name, fk_ite_sequence)
		REFERENCES t_information_type_element (fk_itp_name, sequence)
		ON DELETE CASCADE';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_BUSINESS_OBJECT_TYPE');
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_TYPE');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type ADD CONSTRAINT typ_bot_fk
		FOREIGN KEY (fk_bot_name)
		REFERENCES t_business_object_type (name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type ADD CONSTRAINT typ_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_TYPE_SPECIALISATION_GROUP');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_specialisation_group ADD CONSTRAINT tsg_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_specialisation_group ADD CONSTRAINT tsg_tsg_fk
		FOREIGN KEY (fk_typ_name, fk_tsg_code)
		REFERENCES t_type_specialisation_group (fk_typ_name, code)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_specialisation_group ADD CONSTRAINT tsg_atb_0_xf
		FOREIGN KEY (xf_atb_typ_name, xk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_TYPE_SPECIALISATION');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_specialisation ADD CONSTRAINT tsp_tsg_fk
		FOREIGN KEY (fk_typ_name, fk_tsg_code)
		REFERENCES t_type_specialisation_group (fk_typ_name, code)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_specialisation ADD CONSTRAINT tsp_tsp_0_xf
		FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)
		REFERENCES t_type_specialisation (fk_typ_name, fk_tsg_code, code)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_ATTRIBUTE');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_attribute ADD CONSTRAINT atb_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_attribute ADD CONSTRAINT atb_itp_0_xf
		FOREIGN KEY (xk_itp_name)
		REFERENCES t_information_type (name)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_DERIVATION');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_derivation ADD CONSTRAINT der_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_derivation ADD CONSTRAINT der_typ_0_xf
		FOREIGN KEY (xk_typ_name)
		REFERENCES t_type (name)';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_derivation ADD CONSTRAINT der_typ_1_xf
		FOREIGN KEY (xk_typ_name_1)
		REFERENCES t_type (name)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_DESCRIPTION_ATTRIBUTE');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_description_attribute ADD CONSTRAINT dca_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)
		ON DELETE CASCADE';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_RESTRICTION_TYPE_SPEC_ATB');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_atb ADD CONSTRAINT rta_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_atb ADD CONSTRAINT rta_tsp_0_xf
		FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)
		REFERENCES t_type_specialisation (fk_typ_name, fk_tsg_code, code)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_REFERENCE');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_reference ADD CONSTRAINT ref_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_reference ADD CONSTRAINT ref_bot_0_xf
		FOREIGN KEY (xk_bot_name)
		REFERENCES t_business_object_type (name)';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_reference ADD CONSTRAINT ref_typ_0_xf
		FOREIGN KEY (xk_typ_name)
		REFERENCES t_type (name)';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_reference ADD CONSTRAINT ref_typ_1_xf
		FOREIGN KEY (xk_typ_name_1)
		REFERENCES t_type (name)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_DESCRIPTION_REFERENCE');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_description_reference ADD CONSTRAINT dcr_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name)
		REFERENCES t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name)
		ON DELETE CASCADE';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_RESTRICTION_TYPE_SPEC_REF');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_ref ADD CONSTRAINT rtr_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name)
		REFERENCES t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_ref ADD CONSTRAINT rtr_tsp_0_xf
		FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)
		REFERENCES t_type_specialisation (fk_typ_name, fk_tsg_code, code)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_RESTRICTION_TARGET_TYPE_SPEC');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_target_type_spec ADD CONSTRAINT rts_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name)
		REFERENCES t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_target_type_spec ADD CONSTRAINT rts_tsp_0_xf
		FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)
		REFERENCES t_type_specialisation (fk_typ_name, fk_tsg_code, code)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_SERVICE');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_service ADD CONSTRAINT srv_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_SERVICE_STEP');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_service_step ADD CONSTRAINT sst_srv_fk
		FOREIGN KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr)
		REFERENCES t_service (fk_typ_name, name, cube_tsg_db_scr)
		ON DELETE CASCADE';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_SERVICE_DETAIL');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_service_detail ADD CONSTRAINT svd_srv_fk
		FOREIGN KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr)
		REFERENCES t_service (fk_typ_name, name, cube_tsg_db_scr)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_service_detail ADD CONSTRAINT svd_atb_0_xf
		FOREIGN KEY (xf_atb_typ_name, xk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_service_detail ADD CONSTRAINT svd_ref_0_xf
		FOREIGN KEY (xf_ref_typ_name, xk_ref_sequence, xk_ref_bot_name, xk_ref_typ_name)
		REFERENCES t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_RESTRICTION_TYPE_SPEC_TYP');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_typ ADD CONSTRAINT rtt_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_typ ADD CONSTRAINT rtt_tsp_0_xf
		FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)
		REFERENCES t_type_specialisation (fk_typ_name, fk_tsg_code, code)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_JSON_PATH');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_json_path ADD CONSTRAINT jsn_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_json_path ADD CONSTRAINT jsn_jsn_fk
		FOREIGN KEY (fk_typ_name, fk_jsn_name, fk_jsn_location, fk_jsn_atb_typ_name, fk_jsn_atb_name, fk_jsn_typ_name)
		REFERENCES t_json_path (fk_typ_name, name, location, xf_atb_typ_name, xk_atb_name, xk_typ_name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_json_path ADD CONSTRAINT jsn_atb_0_xf
		FOREIGN KEY (xf_atb_typ_name, xk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_json_path ADD CONSTRAINT jsn_typ_0_xf
		FOREIGN KEY (xk_typ_name)
		REFERENCES t_type (name)';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_DESCRIPTION_TYPE');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_description_type ADD CONSTRAINT dct_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_SYSTEM');
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Add foreign key constraints T_SYSTEM_BO_TYPE');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_system_bo_type ADD CONSTRAINT sbt_sys_fk
		FOREIGN KEY (fk_sys_name)
		REFERENCES t_system (name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_system_bo_type ADD CONSTRAINT sbt_bot_0_xf
		FOREIGN KEY (xk_bot_name)
		REFERENCES t_business_object_type (name)';
END;
/
EXIT;
