
-- TABLE DDL
--
DROP SEQUENCE cube_dsc_seq
/
CREATE SEQUENCE cube_dsc_seq START WITH 100000
/
DROP TABLE t_cube_description
/
CREATE TABLE t_cube_description (
	cube_id VARCHAR2(16),
	type_name VARCHAR2(30),
	attribute_type_name VARCHAR2(30) DEFAULT '_',
	sequence NUMBER(1) DEFAULT '-1',
	value VARCHAR2(3999),
	CONSTRAINT cube_dsc_pk
		PRIMARY KEY (type_name, attribute_type_name, sequence) )
/
EXIT;
