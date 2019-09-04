
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
CREATE SEQUENCE sq_aaa START WITH 100000
/
CREATE SEQUENCE sq_aad START WITH 100000
/
CREATE SEQUENCE sq_bbb START WITH 100000
/
CREATE SEQUENCE sq_ccc START WITH 100000
/
CREATE SEQUENCE sq_prd START WITH 100000
/
CREATE SEQUENCE sq_pr2 START WITH 100000
/
CREATE SEQUENCE sq_pa2 START WITH 100000
/
CREATE SEQUENCE sq_prt START WITH 100000
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
	nummer NUMBER(8) DEFAULT '0',
	datum DATE,
	omschrijving VARCHAR2(120),
	xk_aaa_naam VARCHAR2(40),
	CONSTRAINT prd_pk
		PRIMARY KEY (code, naam, nummer, xk_aaa_naam) )
/
CREATE TABLE t_prod2 (
	cube_id VARCHAR2(16),
	fk_prd_code VARCHAR2(8),
	fk_prd_naam VARCHAR2(40),
	fk_prd_nummer NUMBER(8) DEFAULT '0',
	fk_prd_aaa_naam VARCHAR2(40),
	code VARCHAR2(8),
	naam VARCHAR2(40),
	omschrijving VARCHAR2(120),
	CONSTRAINT pr2_pk
		PRIMARY KEY (code, naam),
	CONSTRAINT pr2_prd_fk
		FOREIGN KEY (fk_prd_code, fk_prd_naam, fk_prd_nummer, fk_prd_aaa_naam)
		REFERENCES t_prod (code, naam, nummer, xk_aaa_naam)
		ON DELETE CASCADE )
/
CREATE TABLE t_part2 (
	cube_id VARCHAR2(16),
	cube_level NUMBER(8) DEFAULT '1',
	fk_prd_code VARCHAR2(8),
	fk_prd_naam VARCHAR2(40),
	fk_prd_nummer NUMBER(8) DEFAULT '0',
	fk_prd_aaa_naam VARCHAR2(40),
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
	fk_prd_nummer NUMBER(8) DEFAULT '0',
	fk_prd_aaa_naam VARCHAR2(40),
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
		FOREIGN KEY (fk_prd_code, fk_prd_naam, fk_prd_nummer, fk_prd_aaa_naam)
		REFERENCES t_prod (code, naam, nummer, xk_aaa_naam)
		ON DELETE CASCADE,
	CONSTRAINT prt_prt_fk
		FOREIGN KEY (fk_prt_code, fk_prt_naam)
		REFERENCES t_part (code, naam)
		ON DELETE CASCADE )
/
EXIT;
