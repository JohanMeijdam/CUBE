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
DROP SEQUENCE prd_seq
/
CREATE SEQUENCE prd_seq START WITH 100000
/
DROP SEQUENCE pr2_seq
/
CREATE SEQUENCE pr2_seq START WITH 100000
/
DROP SEQUENCE pa2_seq
/
CREATE SEQUENCE pa2_seq START WITH 100000
/
DROP SEQUENCE prt_seq
/
CREATE SEQUENCE prt_seq START WITH 100000
/
ALTER TABLE t_aaa DROP CONSTRAINT aaa_aaa_fk
/
ALTER TABLE t_aaa_deel DROP CONSTRAINT aad_aaa_fk
/
ALTER TABLE t_ccc DROP CONSTRAINT ccc_ccc_fk
/
ALTER TABLE t_prod2 DROP CONSTRAINT pr2_prd_fk
/
ALTER TABLE t_part2 DROP CONSTRAINT pa2_pr2_fk
/
ALTER TABLE t_part2 DROP CONSTRAINT pa2_pa2_fk
/
ALTER TABLE t_part DROP CONSTRAINT prt_prd_fk
/
ALTER TABLE t_part DROP CONSTRAINT prt_prt_fk
/
DROP TABLE t_aaa
/
DROP TABLE t_aaa_deel
/
DROP TABLE t_bbb
/
DROP TABLE t_ccc
/
DROP TABLE t_prod
/
DROP TABLE t_prod2
/
DROP TABLE t_part2
/
DROP TABLE t_part
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
	cube_sequence NUMBER(8),
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
	cube_sequence NUMBER(8),
	cube_level NUMBER(8) DEFAULT '1',
	fk_ccc_code VARCHAR2(8),
	fk_ccc_naam VARCHAR2(40),
	code VARCHAR2(8),
	naam VARCHAR2(40),
	omschrjving VARCHAR2(120),
	xk_ccc_code VARCHAR2(8),
	xk_ccc_naam VARCHAR2(40),
	CONSTRAINT ccc_pk
		PRIMARY KEY (code, naam),
	CONSTRAINT ccc_ccc_fk
		FOREIGN KEY (fk_ccc_code, fk_ccc_naam)
		REFERENCES t_ccc (code, naam)
		ON DELETE CASCADE )
/
CREATE TABLE t_prod (
	cube_id VARCHAR2(16),
	cube_tsg_zzz VARCHAR2(8) DEFAULT 'QQQ',
	cube_tsg_yyy VARCHAR2(8) DEFAULT 'RRR',
	code VARCHAR2(8),
	naam VARCHAR2(40),
	datum DATE,
	omschrijving VARCHAR2(120),
	xk_aaa_naam VARCHAR2(40),
	CONSTRAINT prd_pk
		PRIMARY KEY (code, naam) )
/
CREATE TABLE t_prod2 (
	cube_id VARCHAR2(16),
	fk_prd_code VARCHAR2(8),
	fk_prd_naam VARCHAR2(40),
	code VARCHAR2(8),
	naam VARCHAR2(40),
	omschrijving VARCHAR2(120),
	CONSTRAINT pr2_pk
		PRIMARY KEY (code, naam),
	CONSTRAINT pr2_prd_fk
		FOREIGN KEY (fk_prd_code, fk_prd_naam)
		REFERENCES t_prod (code, naam)
		ON DELETE CASCADE )
/
CREATE TABLE t_part2 (
	cube_id VARCHAR2(16),
	cube_level NUMBER(8) DEFAULT '1',
	fk_prd_code VARCHAR2(8),
	fk_prd_naam VARCHAR2(40),
	fk_pr2_code VARCHAR2(8),
	fk_pr2_naam VARCHAR2(40),
	fk_pa2_code VARCHAR2(8),
	fk_pa2_naam VARCHAR2(40),
	code VARCHAR2(8),
	naam VARCHAR2(40),
	omschrijving VARCHAR2(120),
	xk_pa2_code VARCHAR2(8),
	xk_pa2_naam VARCHAR2(40),
	CONSTRAINT pa2_pk
		PRIMARY KEY (code, naam),
	CONSTRAINT pa2_pr2_fk
		FOREIGN KEY (fk_pr2_code, fk_pr2_naam)
		REFERENCES t_prod2 (code, naam)
		ON DELETE CASCADE,
	CONSTRAINT pa2_pa2_fk
		FOREIGN KEY (fk_pa2_code, fk_pa2_naam)
		REFERENCES t_part2 (code, naam)
		ON DELETE CASCADE )
/
CREATE TABLE t_part (
	cube_id VARCHAR2(16),
	cube_level NUMBER(8) DEFAULT '1',
	fk_prd_code VARCHAR2(8),
	fk_prd_naam VARCHAR2(40),
	fk_prt_code VARCHAR2(8),
	fk_prt_naam VARCHAR2(40),
	code VARCHAR2(8),
	naam VARCHAR2(40),
	omschrijving VARCHAR2(120),
	xk_prt_code VARCHAR2(8),
	xk_prt_naam VARCHAR2(40),
	CONSTRAINT prt_pk
		PRIMARY KEY (code, naam),
	CONSTRAINT prt_prd_fk
		FOREIGN KEY (fk_prd_code, fk_prd_naam)
		REFERENCES t_prod (code, naam)
		ON DELETE CASCADE,
	CONSTRAINT prt_prt_fk
		FOREIGN KEY (fk_prt_code, fk_prt_naam)
		REFERENCES t_part (code, naam)
		ON DELETE CASCADE )
/
EXIT;