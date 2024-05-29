
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

CREATE SCHEMA itp;

CREATE SEQUENCE itp.sq_itp START WITH 100000;

CREATE SEQUENCE itp.sq_ite START WITH 100000;

CREATE SEQUENCE itp.sq_val START WITH 100000;

CREATE TABLE itp.t_information_type (
	cube_id VARCHAR(16),
	name VARCHAR(30),
	CONSTRAINT itp_pk
		PRIMARY KEY (name) );

CREATE TABLE itp.t_information_type_element (
	cube_id VARCHAR(16),
	fk_itp_name VARCHAR(30),
	sequence NUMERIC(8) DEFAULT '0',
	suffix VARCHAR(12) DEFAULT '#',
	domain VARCHAR(16) DEFAULT 'TEXT',
	length NUMERIC(8) DEFAULT '0',
	decimals NUMERIC(8) DEFAULT '0',
	case_sensitive VARCHAR(1) DEFAULT 'N',
	default_value VARCHAR(32),
	spaces_allowed VARCHAR(1) DEFAULT 'N',
	presentation VARCHAR(3) DEFAULT 'LIN',
	CONSTRAINT ite_pk
		PRIMARY KEY (fk_itp_name, sequence),
	CONSTRAINT ite_itp_fk
		FOREIGN KEY (fk_itp_name)
		REFERENCES itp.t_information_type (name)
		ON DELETE CASCADE );

CREATE TABLE itp.t_permitted_value (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	fk_itp_name VARCHAR(30),
	fk_ite_sequence NUMERIC(8) DEFAULT '0',
	code VARCHAR(16),
	prompt VARCHAR(32),
	CONSTRAINT val_pk
		PRIMARY KEY (fk_itp_name, fk_ite_sequence, code),
	CONSTRAINT val_ite_fk
		FOREIGN KEY (fk_itp_name, fk_ite_sequence)
		REFERENCES itp.t_information_type_element (fk_itp_name, sequence)
		ON DELETE CASCADE );

CREATE SCHEMA bot;

CREATE SEQUENCE bot.sq_bot START WITH 100000;

CREATE SEQUENCE bot.sq_typ START WITH 100000;

CREATE SEQUENCE bot.sq_tsg START WITH 100000;

CREATE SEQUENCE bot.sq_tsp START WITH 100000;

CREATE SEQUENCE bot.sq_atb START WITH 100000;

CREATE SEQUENCE bot.sq_der START WITH 100000;

CREATE SEQUENCE bot.sq_dca START WITH 100000;

CREATE SEQUENCE bot.sq_rta START WITH 100000;

CREATE SEQUENCE bot.sq_ref START WITH 100000;

CREATE SEQUENCE bot.sq_dcr START WITH 100000;

CREATE SEQUENCE bot.sq_rtr START WITH 100000;

CREATE SEQUENCE bot.sq_rts START WITH 100000;

CREATE SEQUENCE bot.sq_srv START WITH 100000;

CREATE SEQUENCE bot.sq_sst START WITH 100000;

CREATE SEQUENCE bot.sq_sva START WITH 100000;

CREATE SEQUENCE bot.sq_rtt START WITH 100000;

CREATE SEQUENCE bot.sq_jsn START WITH 100000;

CREATE SEQUENCE bot.sq_dct START WITH 100000;

CREATE TABLE bot.t_business_object_type (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	name VARCHAR(30),
	cube_tsg_type VARCHAR(8) DEFAULT 'INT',
	directory VARCHAR(80),
	api_url VARCHAR(300),
	CONSTRAINT bot_pk
		PRIMARY KEY (name) );

CREATE TABLE bot.t_type (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	cube_level NUMERIC(8) DEFAULT '1',
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	name VARCHAR(30),
	code VARCHAR(3),
	flag_partial_key VARCHAR(1) DEFAULT 'Y',
	flag_recursive VARCHAR(1) DEFAULT 'N',
	recursive_cardinality VARCHAR(1) DEFAULT 'N',
	cardinality VARCHAR(1) DEFAULT 'N',
	sort_order VARCHAR(1) DEFAULT 'N',
	icon VARCHAR(8),
	transferable VARCHAR(1) DEFAULT 'Y',
	CONSTRAINT typ_pk
		PRIMARY KEY (name),
	CONSTRAINT typ_bot_fk
		FOREIGN KEY (fk_bot_name)
		REFERENCES bot.t_business_object_type (name)
		ON DELETE CASCADE,
	CONSTRAINT typ_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES bot.t_type (name)
		ON DELETE CASCADE );

CREATE TABLE bot.t_type_specialisation_group (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	cube_level NUMERIC(8) DEFAULT '1',
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_tsg_code VARCHAR(16),
	code VARCHAR(16),
	name VARCHAR(30),
	primary_key VARCHAR(1) DEFAULT 'N',
	xf_atb_typ_name VARCHAR(30),
	xk_atb_name VARCHAR(30),
	CONSTRAINT tsg_pk
		PRIMARY KEY (fk_typ_name, code),
	CONSTRAINT tsg_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES bot.t_type (name)
		ON DELETE CASCADE,
	CONSTRAINT tsg_tsg_fk
		FOREIGN KEY (fk_typ_name, fk_tsg_code)
		REFERENCES bot.t_type_specialisation_group (fk_typ_name, code)
		ON DELETE CASCADE,
	CONSTRAINT tsg_atb_0_xf
		FOREIGN KEY (xf_atb_typ_name, xk_atb_name)
		REFERENCES bot.t_attribute (fk_typ_name, name) );

CREATE TABLE bot.t_type_specialisation (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_tsg_code VARCHAR(16),
	code VARCHAR(16),
	name VARCHAR(30),
	xf_tsp_typ_name VARCHAR(30),
	xf_tsp_tsg_code VARCHAR(16),
	xk_tsp_code VARCHAR(16),
	CONSTRAINT tsp_pk
		PRIMARY KEY (fk_typ_name, fk_tsg_code, code),
	CONSTRAINT tsp_tsg_fk
		FOREIGN KEY (fk_typ_name, fk_tsg_code)
		REFERENCES bot.t_type_specialisation_group (fk_typ_name, code)
		ON DELETE CASCADE,
	CONSTRAINT tsp_tsp_0_xf
		FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)
		REFERENCES bot.t_type_specialisation (fk_typ_name, fk_tsg_code, code) );

CREATE TABLE bot.t_attribute (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	name VARCHAR(30),
	primary_key VARCHAR(1) DEFAULT 'N',
	code_display_key VARCHAR(1) DEFAULT 'N',
	code_foreign_key VARCHAR(1) DEFAULT 'N',
	flag_hidden VARCHAR(1) DEFAULT 'N',
	default_value VARCHAR(40),
	unchangeable VARCHAR(1) DEFAULT 'N',
	xk_itp_name VARCHAR(30),
	CONSTRAINT atb_pk
		PRIMARY KEY (fk_typ_name, name),
	CONSTRAINT atb_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES bot.t_type (name)
		ON DELETE CASCADE,
	CONSTRAINT atb_itp_0_xf
		FOREIGN KEY (xk_itp_name)
		REFERENCES bot.t_information_type (name) );

CREATE TABLE bot.t_derivation (
	cube_id VARCHAR(16),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_atb_name VARCHAR(30),
	cube_tsg_type VARCHAR(8) DEFAULT 'DN',
	aggregate_function VARCHAR(3) DEFAULT 'SUM',
	xk_typ_name VARCHAR(30),
	xk_typ_name_1 VARCHAR(30),
	CONSTRAINT der_pk
		PRIMARY KEY (fk_typ_name, fk_atb_name),
	CONSTRAINT der_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES bot.t_attribute (fk_typ_name, name)
		ON DELETE CASCADE,
	CONSTRAINT der_typ_0_xf
		FOREIGN KEY (xk_typ_name)
		REFERENCES bot.t_type (name),
	CONSTRAINT der_typ_1_xf
		FOREIGN KEY (xk_typ_name_1)
		REFERENCES bot.t_type (name) );

CREATE TABLE bot.t_description_attribute (
	cube_id VARCHAR(16),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_atb_name VARCHAR(30),
	text VARCHAR(3999),
	CONSTRAINT dca_pk
		PRIMARY KEY (fk_typ_name, fk_atb_name),
	CONSTRAINT dca_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES bot.t_attribute (fk_typ_name, name)
		ON DELETE CASCADE );

CREATE TABLE bot.t_restriction_type_spec_atb (
	cube_id VARCHAR(16),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_atb_name VARCHAR(30),
	include_or_exclude VARCHAR(2) DEFAULT 'IN',
	xf_tsp_typ_name VARCHAR(30),
	xf_tsp_tsg_code VARCHAR(16),
	xk_tsp_code VARCHAR(16),
	CONSTRAINT rta_pk
		PRIMARY KEY (fk_typ_name, fk_atb_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code),
	CONSTRAINT rta_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES bot.t_attribute (fk_typ_name, name)
		ON DELETE CASCADE,
	CONSTRAINT rta_tsp_0_xf
		FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)
		REFERENCES bot.t_type_specialisation (fk_typ_name, fk_tsg_code, code) );

CREATE TABLE bot.t_reference (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	name VARCHAR(30),
	primary_key VARCHAR(1) DEFAULT 'N',
	code_display_key VARCHAR(1) DEFAULT 'N',
	sequence NUMERIC(1) DEFAULT '0',
	scope VARCHAR(3) DEFAULT 'ALL',
	unchangeable VARCHAR(1) DEFAULT 'N',
	within_scope_extension VARCHAR(3),
	cube_tsg_int_ext VARCHAR(8) DEFAULT 'INT',
	type_prefix VARCHAR(1) DEFAULT 'N',
	xk_bot_name VARCHAR(30),
	xk_typ_name VARCHAR(30),
	xk_typ_name_1 VARCHAR(30),
	CONSTRAINT ref_pk
		PRIMARY KEY (fk_typ_name, sequence, xk_bot_name, xk_typ_name),
	CONSTRAINT ref_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES bot.t_type (name)
		ON DELETE CASCADE,
	CONSTRAINT ref_bot_0_xf
		FOREIGN KEY (xk_bot_name)
		REFERENCES bot.t_business_object_type (name),
	CONSTRAINT ref_typ_0_xf
		FOREIGN KEY (xk_typ_name)
		REFERENCES bot.t_type (name),
	CONSTRAINT ref_typ_1_xf
		FOREIGN KEY (xk_typ_name_1)
		REFERENCES bot.t_type (name) );

CREATE TABLE bot.t_description_reference (
	cube_id VARCHAR(16),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_ref_sequence NUMERIC(1) DEFAULT '0',
	fk_ref_bot_name VARCHAR(30),
	fk_ref_typ_name VARCHAR(30),
	text VARCHAR(3999),
	CONSTRAINT dcr_pk
		PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name),
	CONSTRAINT dcr_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name)
		REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name)
		ON DELETE CASCADE );

CREATE TABLE bot.t_restriction_type_spec_ref (
	cube_id VARCHAR(16),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_ref_sequence NUMERIC(1) DEFAULT '0',
	fk_ref_bot_name VARCHAR(30),
	fk_ref_typ_name VARCHAR(30),
	include_or_exclude VARCHAR(2) DEFAULT 'IN',
	xf_tsp_typ_name VARCHAR(30),
	xf_tsp_tsg_code VARCHAR(16),
	xk_tsp_code VARCHAR(16),
	CONSTRAINT rtr_pk
		PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code),
	CONSTRAINT rtr_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name)
		REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name)
		ON DELETE CASCADE,
	CONSTRAINT rtr_tsp_0_xf
		FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)
		REFERENCES bot.t_type_specialisation (fk_typ_name, fk_tsg_code, code) );

CREATE TABLE bot.t_restriction_target_type_spec (
	cube_id VARCHAR(16),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_ref_sequence NUMERIC(1) DEFAULT '0',
	fk_ref_bot_name VARCHAR(30),
	fk_ref_typ_name VARCHAR(30),
	include_or_exclude VARCHAR(2) DEFAULT 'IN',
	xf_tsp_typ_name VARCHAR(30),
	xf_tsp_tsg_code VARCHAR(16),
	xk_tsp_code VARCHAR(16),
	CONSTRAINT rts_pk
		PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code),
	CONSTRAINT rts_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name)
		REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name)
		ON DELETE CASCADE,
	CONSTRAINT rts_tsp_0_xf
		FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)
		REFERENCES bot.t_type_specialisation (fk_typ_name, fk_tsg_code, code) );

CREATE TABLE bot.t_service (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	name VARCHAR(30),
	cube_tsg_db_scr VARCHAR(8) DEFAULT 'D',
	class VARCHAR(3),
	accessibility VARCHAR(1),
	CONSTRAINT srv_pk
		PRIMARY KEY (fk_typ_name, name, cube_tsg_db_scr),
	CONSTRAINT srv_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES bot.t_type (name)
		ON DELETE CASCADE );

CREATE TABLE bot.t_service_step (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_srv_name VARCHAR(30),
	fk_srv_cube_tsg_db_scr VARCHAR(8) DEFAULT 'D',
	name VARCHAR(30),
	script_name VARCHAR(60),
	CONSTRAINT sst_pk
		PRIMARY KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr, name),
	CONSTRAINT sst_srv_fk
		FOREIGN KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr)
		REFERENCES bot.t_service (fk_typ_name, name, cube_tsg_db_scr)
		ON DELETE CASCADE );

CREATE TABLE bot.t_service_argument (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_srv_name VARCHAR(30),
	fk_srv_cube_tsg_db_scr VARCHAR(8) DEFAULT 'D',
	cube_tsg_sva_type VARCHAR(8) DEFAULT 'OPT',
	option_name VARCHAR(30),
	input_or_output VARCHAR(1) DEFAULT 'I',
	xk_itp_name VARCHAR(30),
	xf_atb_typ_name VARCHAR(30),
	xk_atb_name VARCHAR(30),
	xk_ref_bot_name VARCHAR(30),
	xk_ref_typ_name VARCHAR(30),
	xf_ref_typ_name VARCHAR(30),
	xk_ref_sequence NUMERIC(1) DEFAULT '0',
	CONSTRAINT sva_pk
		PRIMARY KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr, option_name, xf_atb_typ_name, xk_atb_name),
	CONSTRAINT sva_srv_fk
		FOREIGN KEY (fk_typ_name, fk_srv_name, fk_srv_cube_tsg_db_scr)
		REFERENCES bot.t_service (fk_typ_name, name, cube_tsg_db_scr)
		ON DELETE CASCADE,
	CONSTRAINT sva_itp_0_xf
		FOREIGN KEY (xk_itp_name)
		REFERENCES bot.t_information_type (name),
	CONSTRAINT sva_atb_0_xf
		FOREIGN KEY (xf_atb_typ_name, xk_atb_name)
		REFERENCES bot.t_attribute (fk_typ_name, name),
	CONSTRAINT sva_ref_0_xf
		FOREIGN KEY (xf_ref_typ_name, xk_ref_sequence, xk_ref_bot_name, xk_ref_typ_name)
		REFERENCES bot.t_reference (fk_typ_name, sequence, xk_bot_name, xk_typ_name) );

CREATE TABLE bot.t_restriction_type_spec_typ (
	cube_id VARCHAR(16),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	include_or_exclude VARCHAR(2) DEFAULT 'IN',
	xf_tsp_typ_name VARCHAR(30),
	xf_tsp_tsg_code VARCHAR(16),
	xk_tsp_code VARCHAR(16),
	CONSTRAINT rtt_pk
		PRIMARY KEY (fk_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code),
	CONSTRAINT rtt_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES bot.t_type (name)
		ON DELETE CASCADE,
	CONSTRAINT rtt_tsp_0_xf
		FOREIGN KEY (xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code)
		REFERENCES bot.t_type_specialisation (fk_typ_name, fk_tsg_code, code) );

CREATE TABLE bot.t_json_path (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	cube_level NUMERIC(8) DEFAULT '1',
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	fk_jsn_name VARCHAR(32),
	fk_jsn_location NUMERIC(8) DEFAULT '0',
	fk_jsn_atb_typ_name VARCHAR(30),
	fk_jsn_atb_name VARCHAR(30),
	fk_jsn_typ_name VARCHAR(30),
	cube_tsg_obj_arr VARCHAR(8) DEFAULT 'OBJ',
	cube_tsg_type VARCHAR(8) DEFAULT 'GRP',
	name VARCHAR(32),
	location NUMERIC(8) DEFAULT '0',
	xf_atb_typ_name VARCHAR(30),
	xk_atb_name VARCHAR(30),
	xk_typ_name VARCHAR(30),
	CONSTRAINT jsn_pk
		PRIMARY KEY (fk_typ_name, name, location, xf_atb_typ_name, xk_atb_name, xk_typ_name),
	CONSTRAINT jsn_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES bot.t_type (name)
		ON DELETE CASCADE,
	CONSTRAINT jsn_jsn_fk
		FOREIGN KEY (fk_typ_name, fk_jsn_name, fk_jsn_location, fk_jsn_atb_typ_name, fk_jsn_atb_name, fk_jsn_typ_name)
		REFERENCES bot.t_json_path (fk_typ_name, name, location, xf_atb_typ_name, xk_atb_name, xk_typ_name)
		ON DELETE CASCADE,
	CONSTRAINT jsn_atb_0_xf
		FOREIGN KEY (xf_atb_typ_name, xk_atb_name)
		REFERENCES bot.t_attribute (fk_typ_name, name),
	CONSTRAINT jsn_typ_0_xf
		FOREIGN KEY (xk_typ_name)
		REFERENCES bot.t_type (name) );

CREATE TABLE bot.t_description_type (
	cube_id VARCHAR(16),
	fk_bot_name VARCHAR(30),
	fk_typ_name VARCHAR(30),
	text VARCHAR(3999),
	CONSTRAINT dct_pk
		PRIMARY KEY (fk_typ_name),
	CONSTRAINT dct_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES bot.t_type (name)
		ON DELETE CASCADE );

CREATE SCHEMA sys;

CREATE SEQUENCE sys.sq_sys START WITH 100000;

CREATE SEQUENCE sys.sq_sbt START WITH 100000;

CREATE TABLE sys.t_system (
	cube_id VARCHAR(16),
	name VARCHAR(30),
	cube_tsg_type VARCHAR(8) DEFAULT 'PRIMARY',
	database VARCHAR(30),
	schema VARCHAR(30),
	password VARCHAR(20),
	table_prefix VARCHAR(4),
	CONSTRAINT sys_pk
		PRIMARY KEY (name) );

CREATE TABLE sys.t_system_bo_type (
	cube_id VARCHAR(16),
	cube_sequence NUMERIC(8),
	fk_sys_name VARCHAR(30),
	xk_bot_name VARCHAR(30),
	CONSTRAINT sbt_pk
		PRIMARY KEY (fk_sys_name, xk_bot_name),
	CONSTRAINT sbt_sys_fk
		FOREIGN KEY (fk_sys_name)
		REFERENCES sys.t_system (name)
		ON DELETE CASCADE,
	CONSTRAINT sbt_bot_0_xf
		FOREIGN KEY (xk_bot_name)
		REFERENCES sys.t_business_object_type (name) );

\q
