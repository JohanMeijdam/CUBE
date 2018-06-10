-- TABLE DDL
--
DROP SEQUENCE aaa_seq
/
CREATE SEQUENCE aaa_seq START WITH 100000
/
DROP SEQUENCE bbb_seq
/
CREATE SEQUENCE bbb_seq START WITH 100000
/
ALTER TABLE t_aaa DROP CONSTRAINT aaa_aaa_fk
/
DROP TABLE t_aaa
/
DROP TABLE t_bbb
/
CREATE TABLE t_aaa (
	cube_id VARCHAR2(16),
	cube_level NUMBER(8) DEFAULT '1',
	fk_aaa_naam VARCHAR2(40),
	naam VARCHAR2(40),
	omschrijving VARCHAR2(120),
	xk_aaa_naam VARCHAR2(40),
	CONSTRAINT aaa_pk
		PRIMARY KEY (naam),
	CONSTRAINT aaa_aaa_fk
		FOREIGN KEY (fk_aaa_naam)
		REFERENCES t_aaa (naam)
		ON DELETE CASCADE )
/
CREATE TABLE t_bbb (
	cube_id VARCHAR2(16),
	naam VARCHAR2(40),
	omschrijving VARCHAR2(120),
	xk_aaa_naam VARCHAR2(40),
	xk_bbb_naam_1 VARCHAR2(40),
	CONSTRAINT bbb_pk
		PRIMARY KEY (naam) )
/
EXIT;