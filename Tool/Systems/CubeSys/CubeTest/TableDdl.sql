
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
CREATE SEQUENCE sq_prd START WITH 100000
/
CREATE SEQUENCE sq_ond START WITH 100000
/
CREATE SEQUENCE sq_odd START WITH 100000
/
CREATE SEQUENCE sq_ddd START WITH 100000
/
CREATE SEQUENCE sq_cst START WITH 100000
/
CREATE TABLE t_produkt (
	cube_id VARCHAR2(16),
	cube_tsg_type VARCHAR2(8) DEFAULT 'P',
	cube_tsg_soort VARCHAR2(8) DEFAULT 'R',
	cube_tsg_soort1 VARCHAR2(8) DEFAULT 'GARAGE',
	code VARCHAR2(8),
	prijs NUMBER(8,2),
	makelaar_naam VARCHAR2(40),
	bedrag_btw NUMBER(8,2),
	CONSTRAINT prd_pk
		PRIMARY KEY (cube_tsg_type, code) )
/
CREATE TABLE t_onderdeel (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	cube_level NUMBER(8) DEFAULT '1',
	fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT 'P',
	fk_prd_code VARCHAR2(8),
	fk_ond_code VARCHAR2(8),
	code VARCHAR2(8),
	prijs NUMBER(8,2),
	omschrijving VARCHAR2(120),
	CONSTRAINT ond_pk
		PRIMARY KEY (fk_prd_cube_tsg_type, fk_prd_code, code),
	CONSTRAINT ond_prd_fk
		FOREIGN KEY (fk_prd_cube_tsg_type, fk_prd_code)
		REFERENCES t_produkt (cube_tsg_type, code)
		ON DELETE CASCADE,
	CONSTRAINT ond_ond_fk
		FOREIGN KEY (fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code)
		REFERENCES t_onderdeel (fk_prd_cube_tsg_type, fk_prd_code, code)
		ON DELETE CASCADE )
/
CREATE TABLE t_onderdeel_deel (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT 'P',
	fk_prd_code VARCHAR2(8),
	fk_ond_code VARCHAR2(8),
	code VARCHAR2(8),
	naam VARCHAR2(40),
	CONSTRAINT odd_pk
		PRIMARY KEY (code),
	CONSTRAINT odd_ond_fk
		FOREIGN KEY (fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code)
		REFERENCES t_onderdeel (fk_prd_cube_tsg_type, fk_prd_code, code)
		ON DELETE CASCADE )
/
CREATE TABLE t_onderdeel_deel_deel (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT 'P',
	fk_prd_code VARCHAR2(8),
	fk_ond_code VARCHAR2(8),
	fk_odd_code VARCHAR2(8),
	code VARCHAR2(8),
	naam VARCHAR2(40),
	CONSTRAINT ddd_pk
		PRIMARY KEY (code),
	CONSTRAINT ddd_odd_fk
		FOREIGN KEY (fk_odd_code)
		REFERENCES t_onderdeel_deel (code)
		ON DELETE CASCADE )
/
CREATE TABLE t_constructie (
	cube_id VARCHAR2(16),
	fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT 'P',
	fk_prd_code VARCHAR2(8),
	fk_ond_code VARCHAR2(8),
	code VARCHAR2(8),
	omschrijving VARCHAR2(120),
	xk_odd_code VARCHAR2(8),
	xk_odd_code_1 VARCHAR2(8),
	CONSTRAINT cst_pk
		PRIMARY KEY (fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code, code),
	CONSTRAINT cst_ond_fk
		FOREIGN KEY (fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code)
		REFERENCES t_onderdeel (fk_prd_cube_tsg_type, fk_prd_code, code)
		ON DELETE CASCADE )
/
EXIT;
