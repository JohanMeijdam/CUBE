-- TABLE DDL
--
DROP SEQUENCE aaa_seq
/
CREATE SEQUENCE aaa_seq START WITH 100000
/
DROP SEQUENCE aad_seq
/
CREATE SEQUENCE aad_seq START WITH 100000
/
DROP SEQUENCE bbb_seq
/
CREATE SEQUENCE bbb_seq START WITH 100000
/
DROP SEQUENCE ccc_seq
/
CREATE SEQUENCE ccc_seq START WITH 100000
/
ALTER TABLE t_aaa DROP CONSTRAINT aaa_aaa_fk
/
ALTER TABLE t_aaa_deel DROP CONSTRAINT aad_aaa_fk
/
ALTER TABLE t_ccc DROP CONSTRAINT ccc_ccc_fk
/
DROP TABLE t_aaa
/
DROP TABLE t_aaa_deel
/
DROP TABLE t_bbb
/
DROP TABLE t_ccc
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
CREATE TABLE t_aaa_deel (
	cube_id VARCHAR2(16),
	fk_aaa_naam VARCHAR2(40),
	naam VARCHAR2(40),
	xk_aaa_naam VARCHAR2(40),
	CONSTRAINT aad_pk
		PRIMARY KEY (fk_aaa_naam, naam),
	CONSTRAINT aad_aaa_fk
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
CREATE TABLE t_ccc (
	cube_id VARCHAR2(16),
	cube_level NUMBER(8) DEFAULT '1',
	fk_ccc_code VARCHAR2(8),
	fk_ccc_naam VARCHAR2(40),
	code VARCHAR2(8),
	naam VARCHAR2(40),
	omschrjving VARCHAR2(120),
	CONSTRAINT ccc_pk
		PRIMARY KEY (code, naam),
	CONSTRAINT ccc_ccc_fk
		FOREIGN KEY (fk_ccc_code, fk_ccc_naam)
		REFERENCES t_ccc (code, naam)
		ON DELETE CASCADE )
/
EXIT;