-- TABLE DDL
--
DROP SEQUENCE itp_seq
/
CREATE SEQUENCE itp_seq START WITH 100000
/
DROP SEQUENCE ite_seq
/
CREATE SEQUENCE ite_seq START WITH 100000
/
DROP SEQUENCE val_seq
/
CREATE SEQUENCE val_seq START WITH 100000
/
DROP SEQUENCE bot_seq
/
CREATE SEQUENCE bot_seq START WITH 100000
/
DROP SEQUENCE typ_seq
/
CREATE SEQUENCE typ_seq START WITH 100000
/
DROP SEQUENCE atb_seq
/
CREATE SEQUENCE atb_seq START WITH 100000
/
DROP SEQUENCE der_seq
/
CREATE SEQUENCE der_seq START WITH 100000
/
DROP SEQUENCE dca_seq
/
CREATE SEQUENCE dca_seq START WITH 100000
/
DROP SEQUENCE rta_seq
/
CREATE SEQUENCE rta_seq START WITH 100000
/
DROP SEQUENCE ref_seq
/
CREATE SEQUENCE ref_seq START WITH 100000
/
DROP SEQUENCE dcr_seq
/
CREATE SEQUENCE dcr_seq START WITH 100000
/
DROP SEQUENCE rtr_seq
/
CREATE SEQUENCE rtr_seq START WITH 100000
/
DROP SEQUENCE tyr_seq
/
CREATE SEQUENCE tyr_seq START WITH 100000
/
DROP SEQUENCE par_seq
/
CREATE SEQUENCE par_seq START WITH 100000
/
DROP SEQUENCE stp_seq
/
CREATE SEQUENCE stp_seq START WITH 100000
/
DROP SEQUENCE tsg_seq
/
CREATE SEQUENCE tsg_seq START WITH 100000
/
DROP SEQUENCE tsp_seq
/
CREATE SEQUENCE tsp_seq START WITH 100000
/
DROP SEQUENCE dct_seq
/
CREATE SEQUENCE dct_seq START WITH 100000
/
DROP SEQUENCE sys_seq
/
CREATE SEQUENCE sys_seq START WITH 100000
/
DROP SEQUENCE sbt_seq
/
CREATE SEQUENCE sbt_seq START WITH 100000
/
DROP SEQUENCE cub_seq
/
CREATE SEQUENCE cub_seq START WITH 100000
/
DROP SEQUENCE cgp_seq
/
CREATE SEQUENCE cgp_seq START WITH 100000
/
DROP SEQUENCE cgm_seq
/
CREATE SEQUENCE cgm_seq START WITH 100000
/
DROP SEQUENCE cgo_seq
/
CREATE SEQUENCE cgo_seq START WITH 100000
/
DROP SEQUENCE cgf_seq
/
CREATE SEQUENCE cgf_seq START WITH 100000
/
DROP SEQUENCE ctf_seq
/
CREATE SEQUENCE ctf_seq START WITH 100000
/
ALTER TABLE t_information_type_element DROP CONSTRAINT ite_itp_fk
/
ALTER TABLE t_permitted_value DROP CONSTRAINT val_ite_fk
/
ALTER TABLE t_type DROP CONSTRAINT typ_bot_fk
/
ALTER TABLE t_type DROP CONSTRAINT typ_typ_fk
/
ALTER TABLE t_attribute DROP CONSTRAINT atb_typ_fk
/
ALTER TABLE t_derivation DROP CONSTRAINT der_atb_fk
/
ALTER TABLE t_description_attribute DROP CONSTRAINT dca_atb_fk
/
ALTER TABLE t_restriction_type_spec_atb DROP CONSTRAINT rta_atb_fk
/
ALTER TABLE t_reference DROP CONSTRAINT ref_typ_fk
/
ALTER TABLE t_description_reference DROP CONSTRAINT dcr_ref_fk
/
ALTER TABLE t_restriction_type_spec_ref DROP CONSTRAINT rtr_ref_fk
/
ALTER TABLE t_type_reuse DROP CONSTRAINT tyr_typ_fk
/
ALTER TABLE t_partition DROP CONSTRAINT par_typ_fk
/
ALTER TABLE t_subtype DROP CONSTRAINT stp_par_fk
/
ALTER TABLE t_type_specialisation_group DROP CONSTRAINT tsg_typ_fk
/
ALTER TABLE t_type_specialisation_group DROP CONSTRAINT tsg_tsg_fk
/
ALTER TABLE t_type_specialisation DROP CONSTRAINT tsp_tsg_fk
/
ALTER TABLE t_description_type DROP CONSTRAINT dct_typ_fk
/
ALTER TABLE t_system_bo_type DROP CONSTRAINT sbt_sys_fk
/
ALTER TABLE t_cube_gen_paragraph DROP CONSTRAINT cgp_cub_fk
/
ALTER TABLE t_cube_gen_example_model DROP CONSTRAINT cgm_cub_fk
/
ALTER TABLE t_cube_gen_example_object DROP CONSTRAINT cgo_cgm_fk
/
ALTER TABLE t_cube_gen_function DROP CONSTRAINT cgf_cgm_fk
/
ALTER TABLE t_cube_gen_template_function DROP CONSTRAINT ctf_cub_fk
/
DROP TABLE t_information_type
/
DROP TABLE t_information_type_element
/
DROP TABLE t_permitted_value
/
DROP TABLE t_business_object_type
/
DROP TABLE t_type
/
DROP TABLE t_attribute
/
DROP TABLE t_derivation
/
DROP TABLE t_description_attribute
/
DROP TABLE t_restriction_type_spec_atb
/
DROP TABLE t_reference
/
DROP TABLE t_description_reference
/
DROP TABLE t_restriction_type_spec_ref
/
DROP TABLE t_type_reuse
/
DROP TABLE t_partition
/
DROP TABLE t_subtype
/
DROP TABLE t_type_specialisation_group
/
DROP TABLE t_type_specialisation
/
DROP TABLE t_description_type
/
DROP TABLE t_system
/
DROP TABLE t_system_bo_type
/
DROP TABLE t_cube_gen_documentation
/
DROP TABLE t_cube_gen_paragraph
/
DROP TABLE t_cube_gen_example_model
/
DROP TABLE t_cube_gen_example_object
/
DROP TABLE t_cube_gen_function
/
DROP TABLE t_cube_gen_template_function
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
	domain CHAR(2) DEFAULT 'CH',
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
	code VARCHAR2(8),
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
	directory VARCHAR2(80),
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
	flag_partial_key CHAR(1) DEFAULT 'N',
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
	cube_tsg_type VARCHAR2(8),
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
	xf_tsp_tsg_code VARCHAR2(8),
	xk_tsp_code VARCHAR2(8),
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
	within_scope_level NUMBER(1) DEFAULT '0',
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
	xf_tsp_tsg_code VARCHAR2(8),
	xk_tsp_code VARCHAR2(8),
	CONSTRAINT rtr_pk
		PRIMARY KEY (fk_typ_name, fk_ref_sequence, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code),
	CONSTRAINT rtr_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_typ_name)
		REFERENCES t_reference (fk_typ_name, sequence, xk_typ_name)
		ON DELETE CASCADE )
/
CREATE TABLE t_type_reuse (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	cardinality CHAR(1) DEFAULT 'N',
	xk_typ_name VARCHAR2(30),
	CONSTRAINT tyr_pk
		PRIMARY KEY (fk_typ_name, xk_typ_name),
	CONSTRAINT tyr_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_partition (
	cube_id VARCHAR2(16),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	name VARCHAR2(30),
	CONSTRAINT par_pk
		PRIMARY KEY (fk_typ_name, name),
	CONSTRAINT par_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_subtype (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_par_name VARCHAR2(30),
	name VARCHAR2(30),
	CONSTRAINT stp_pk
		PRIMARY KEY (fk_typ_name, fk_par_name, name),
	CONSTRAINT stp_par_fk
		FOREIGN KEY (fk_typ_name, fk_par_name)
		REFERENCES t_partition (fk_typ_name, name)
		ON DELETE CASCADE )
/
CREATE TABLE t_type_specialisation_group (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	cube_level NUMBER(8) DEFAULT '1',
	fk_bot_name VARCHAR2(30),
	fk_typ_name VARCHAR2(30),
	fk_tsg_code VARCHAR2(8),
	code VARCHAR2(8),
	name VARCHAR2(30),
	primary_key CHAR(1) DEFAULT 'N',
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
	fk_tsg_code VARCHAR2(8),
	code VARCHAR2(8),
	name VARCHAR2(30),
	xf_tsp_typ_name VARCHAR2(30),
	xf_tsp_tsg_code VARCHAR2(8),
	xk_tsp_code VARCHAR2(8),
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
	database VARCHAR2(30),
	schema VARCHAR2(30),
	password VARCHAR2(20),
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
CREATE TABLE t_cube_gen_documentation (
	cube_id VARCHAR2(16),
	name VARCHAR2(30),
	description VARCHAR2(3999),
	description_functions VARCHAR2(3999),
	CONSTRAINT cub_pk
		PRIMARY KEY (name) )
/
CREATE TABLE t_cube_gen_paragraph (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_cub_name VARCHAR2(30),
	id VARCHAR2(8),
	header VARCHAR2(40),
	description VARCHAR2(3999),
	example VARCHAR2(3999) DEFAULT '#',
	CONSTRAINT cgp_pk
		PRIMARY KEY (fk_cub_name, id),
	CONSTRAINT cgp_cub_fk
		FOREIGN KEY (fk_cub_name)
		REFERENCES t_cube_gen_documentation (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_cube_gen_example_model (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_cub_name VARCHAR2(30),
	id VARCHAR2(8),
	header VARCHAR2(40),
	included_object_names VARCHAR2(120),
	description VARCHAR2(3999),
	CONSTRAINT cgm_pk
		PRIMARY KEY (fk_cub_name, id),
	CONSTRAINT cgm_cub_fk
		FOREIGN KEY (fk_cub_name)
		REFERENCES t_cube_gen_documentation (name)
		ON DELETE CASCADE )
/
CREATE TABLE t_cube_gen_example_object (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_cub_name VARCHAR2(30),
	fk_cgm_id VARCHAR2(8),
	xk_bot_name VARCHAR2(30),
	CONSTRAINT cgo_pk
		PRIMARY KEY (fk_cub_name, fk_cgm_id, xk_bot_name),
	CONSTRAINT cgo_cgm_fk
		FOREIGN KEY (fk_cub_name, fk_cgm_id)
		REFERENCES t_cube_gen_example_model (fk_cub_name, id)
		ON DELETE CASCADE )
/
CREATE TABLE t_cube_gen_function (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_cub_name VARCHAR2(30),
	fk_cgm_id VARCHAR2(8),
	id VARCHAR2(8),
	header VARCHAR2(40),
	description VARCHAR2(3999),
	template VARCHAR2(3999),
	CONSTRAINT cgf_pk
		PRIMARY KEY (id),
	CONSTRAINT cgf_cgm_fk
		FOREIGN KEY (fk_cub_name, fk_cgm_id)
		REFERENCES t_cube_gen_example_model (fk_cub_name, id)
		ON DELETE CASCADE )
/
CREATE TABLE t_cube_gen_template_function (
	cube_id VARCHAR2(16),
	fk_cub_name VARCHAR2(30),
	name VARCHAR2(30),
	indication_logical CHAR(1) DEFAULT 'N',
	description VARCHAR2(3999),
	syntax VARCHAR2(3999),
	CONSTRAINT ctf_pk
		PRIMARY KEY (fk_cub_name, name, indication_logical),
	CONSTRAINT ctf_cub_fk
		FOREIGN KEY (fk_cub_name)
		REFERENCES t_cube_gen_documentation (name)
		ON DELETE CASCADE )
/
EXIT;