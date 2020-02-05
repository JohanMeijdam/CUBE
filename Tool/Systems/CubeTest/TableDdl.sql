
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
CREATE SEQUENCE sq_kln START WITH 100000
/
CREATE SEQUENCE sq_adr START WITH 100000
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
CREATE SEQUENCE sq_ord START WITH 100000
/
CREATE SEQUENCE sq_orr START WITH 100000
/
CREATE SEQUENCE sq_aaa START WITH 100000
/
CREATE SEQUENCE sq_bbb START WITH 100000
/
CREATE SEQUENCE sq_ccc START WITH 100000
/
CREATE TABLE t_klant (
	cube_id VARCHAR2(16),
	cube_tsg_intext VARCHAR2(8) DEFAULT 'INT',
	nummer VARCHAR2(8),
	achternaam VARCHAR2(40),
	geboorte_datum DATE,
	leeftijd NUMBER(8),
	voornaam VARCHAR2(40),
	tussenvoegsel VARCHAR2(40),
	CONSTRAINT kln_pk
		PRIMARY KEY (nummer) )
/
CREATE TABLE t_adres (
	cube_id VARCHAR2(16),
	fk_kln_nummer VARCHAR2(8),
	postcode_cijfers NUMBER(4),
	postcode_letters CHAR(2),
	cube_tsg_test VARCHAR2(8),
	huisnummer NUMBER(8),
	CONSTRAINT adr_pk
		PRIMARY KEY (fk_kln_nummer, postcode_cijfers, postcode_letters, cube_tsg_test, huisnummer),
	CONSTRAINT adr_kln_fk
		FOREIGN KEY (fk_kln_nummer)
		REFERENCES t_klant (nummer)
		ON DELETE CASCADE )
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
	fk_prd_cube_tsg_type VARCHAR2(8),
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
	fk_prd_cube_tsg_type VARCHAR2(8),
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
	fk_prd_cube_tsg_type VARCHAR2(8),
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
	fk_prd_cube_tsg_type VARCHAR2(8),
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
CREATE TABLE t_order (
	cube_id VARCHAR2(16),
	cube_sequence NUMBER(8),
	cube_tsg_int_ext VARCHAR2(8) DEFAULT 'INT',
	code VARCHAR2(8),
	xk_kln_nummer VARCHAR2(8),
	CONSTRAINT ord_pk
		PRIMARY KEY (code) )
/
CREATE TABLE t_order_regel (
	cube_id VARCHAR2(16),
	fk_ord_code VARCHAR2(8),
	produkt_prijs NUMBER(8,2),
	aantal NUMBER(8,2),
	totaal_prijs NUMBER(8,2),
	xk_prd_cube_tsg_type VARCHAR2(8),
	xk_prd_code VARCHAR2(8),
	CONSTRAINT orr_pk
		PRIMARY KEY (fk_ord_code),
	CONSTRAINT orr_ord_fk
		FOREIGN KEY (fk_ord_code)
		REFERENCES t_order (code)
		ON DELETE CASCADE )
/
CREATE TABLE t_aaa (
	cube_id VARCHAR2(16),
	id NUMBER(8) DEFAULT '0',
	naam VARCHAR2(40),
	CONSTRAINT aaa_pk
		PRIMARY KEY (id) )
/
CREATE TABLE t_bbb (
	cube_id VARCHAR2(16),
	fk_aaa_id NUMBER(8) DEFAULT '0',
	id NUMBER(8) DEFAULT '0',
	naam VARCHAR2(40),
	CONSTRAINT bbb_pk
		PRIMARY KEY (id),
	CONSTRAINT bbb_aaa_fk
		FOREIGN KEY (fk_aaa_id)
		REFERENCES t_aaa (id)
		ON DELETE CASCADE )
/
CREATE TABLE t_ccc (
	cube_id VARCHAR2(16),
	fk_aaa_id NUMBER(8) DEFAULT '0',
	fk_bbb_id NUMBER(8) DEFAULT '0',
	id NUMBER(8) DEFAULT '0',
	naam VARCHAR2(40),
	CONSTRAINT ccc_pk
		PRIMARY KEY (id),
	CONSTRAINT ccc_bbb_fk
		FOREIGN KEY (fk_bbb_id)
		REFERENCES t_bbb (id)
		ON DELETE CASCADE )
/
EXIT;
