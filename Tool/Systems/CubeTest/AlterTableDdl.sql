-- ALTER TABLE DDL
--
SET SERVEROUTPUT ON;
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'SQ_KLN';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sq_kln START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SQ_KLN created');
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'SQ_ADR';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sq_adr START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SQ_ADR created');
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'SQ_PRD';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sq_prd START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SQ_PRD created');
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'SQ_OND';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sq_ond START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SQ_OND created');
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'SQ_ODD';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sq_odd START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SQ_ODD created');
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'SQ_DDD';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sq_ddd START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SQ_DDD created');
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'SQ_ORD';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sq_ord START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SQ_ORD created');
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'SQ_ORR';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sq_orr START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SQ_ORR created');
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_KLANT');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_klant (
			cube_id VARCHAR2(16),
			cube_tsg_intext VARCHAR2(8) DEFAULT ''INT'',
			cube_tsg_vip VARCHAR2(8) DEFAULT ''VIP'',
			cube_tsg_test VARCHAR2(8),
			nummer VARCHAR2(8),
			achternaam VARCHAR2(40),
			geboorte_datum DATE,
			leeftijd NUMBER(8),
			voornaam VARCHAR2(40),
			tussenvoegsel VARCHAR2(40))';
		DBMS_OUTPUT.PUT_LINE('Table T_KLANT created');
	ELSE
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_KLANT.CUBE_ID created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name = 'CUBE_TSG_INTEXT';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD cube_tsg_intext VARCHAR2(8) DEFAULT ''INT''';
			DBMS_OUTPUT.PUT_LINE('Column T_KLANT.CUBE_TSG_INTEXT created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name = 'CUBE_TSG_VIP';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD cube_tsg_vip VARCHAR2(8) DEFAULT ''VIP''';
			DBMS_OUTPUT.PUT_LINE('Column T_KLANT.CUBE_TSG_VIP created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name = 'CUBE_TSG_TEST';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD cube_tsg_test VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_KLANT.CUBE_TSG_TEST created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name = 'NUMMER';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD nummer VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_KLANT.NUMMER created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name = 'ACHTERNAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD achternaam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_KLANT.ACHTERNAAM created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name = 'GEBOORTE_DATUM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD geboorte_datum DATE';
			DBMS_OUTPUT.PUT_LINE('Column T_KLANT.GEBOORTE_DATUM created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name = 'LEEFTIJD';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD leeftijd NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_KLANT.LEEFTIJD created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name = 'VOORNAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD voornaam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_KLANT.VOORNAAM created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name = 'TUSSENVOEGSEL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD tussenvoegsel VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_KLANT.TUSSENVOEGSEL created');
		END IF;
		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_KLANT.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;
		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_KLANT.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_ADRES');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_adres (
			cube_id VARCHAR2(16),
			fk_kln_nummer VARCHAR2(8),
			postcode_cijfers NUMBER(4),
			postcode_letters CHAR(2),
			cube_tsg_test VARCHAR2(8),
			huisnummer NUMBER(8))';
		DBMS_OUTPUT.PUT_LINE('Table T_ADRES created');
	ELSE
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_ADRES.CUBE_ID created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES' AND column_name = 'FK_KLN_NUMMER';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres ADD fk_kln_nummer VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ADRES.FK_KLN_NUMMER created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES' AND column_name = 'POSTCODE_CIJFERS';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres ADD postcode_cijfers NUMBER(4)';
			DBMS_OUTPUT.PUT_LINE('Column T_ADRES.POSTCODE_CIJFERS created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES' AND column_name = 'POSTCODE_LETTERS';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres ADD postcode_letters CHAR(2)';
			DBMS_OUTPUT.PUT_LINE('Column T_ADRES.POSTCODE_LETTERS created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES' AND column_name = 'CUBE_TSG_TEST';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres ADD cube_tsg_test VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ADRES.CUBE_TSG_TEST created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES' AND column_name = 'HUISNUMMER';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres ADD huisnummer NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ADRES.HUISNUMMER created');
		END IF;
		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_ADRES.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;
		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_ADRES.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_PRODUKT');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_produkt (
			cube_id VARCHAR2(16),
			cube_tsg_type VARCHAR2(8) DEFAULT ''P'',
			cube_tsg_soort VARCHAR2(8) DEFAULT ''R'',
			cube_tsg_soort1 VARCHAR2(8) DEFAULT ''GARAGE'',
			code VARCHAR2(8),
			prijs NUMBER(8,2),
			makelaar_naam VARCHAR2(40),
			bedrag_btw NUMBER(8,2),
			xk_kln_nummer VARCHAR2(8))';
		DBMS_OUTPUT.PUT_LINE('Table T_PRODUKT created');
	ELSE
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_PRODUKT.CUBE_ID created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND column_name = 'CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt ADD cube_tsg_type VARCHAR2(8) DEFAULT ''P''';
			DBMS_OUTPUT.PUT_LINE('Column T_PRODUKT.CUBE_TSG_TYPE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND column_name = 'CUBE_TSG_SOORT';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt ADD cube_tsg_soort VARCHAR2(8) DEFAULT ''R''';
			DBMS_OUTPUT.PUT_LINE('Column T_PRODUKT.CUBE_TSG_SOORT created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND column_name = 'CUBE_TSG_SOORT1';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt ADD cube_tsg_soort1 VARCHAR2(8) DEFAULT ''GARAGE''';
			DBMS_OUTPUT.PUT_LINE('Column T_PRODUKT.CUBE_TSG_SOORT1 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PRODUKT.CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND column_name = 'PRIJS';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt ADD prijs NUMBER(8,2)';
			DBMS_OUTPUT.PUT_LINE('Column T_PRODUKT.PRIJS created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND column_name = 'MAKELAAR_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt ADD makelaar_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PRODUKT.MAKELAAR_NAAM created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND column_name = 'BEDRAG_BTW';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt ADD bedrag_btw NUMBER(8,2)';
			DBMS_OUTPUT.PUT_LINE('Column T_PRODUKT.BEDRAG_BTW created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND column_name = 'XK_KLN_NUMMER';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt ADD xk_kln_nummer VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PRODUKT.XK_KLN_NUMMER created');
		END IF;
		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_PRODUKT.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;
		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_PRODUKT.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_ONDERDEEL');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_onderdeel (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			cube_level NUMBER(8) DEFAULT ''1'',
			fk_prd_cube_tsg_type VARCHAR2(8),
			fk_prd_code VARCHAR2(8),
			fk_ond_code VARCHAR2(8),
			code VARCHAR2(8),
			prijs NUMBER(8,2),
			omschrijving VARCHAR2(120),
			xf_ond_prd_cube_tsg_type VARCHAR2(8),
			xf_ond_prd_code VARCHAR2(8),
			xk_ond_code VARCHAR2(8))';
		DBMS_OUTPUT.PUT_LINE('Table T_ONDERDEEL created');
	ELSE
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.CUBE_ID created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.CUBE_SEQUENCE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'CUBE_LEVEL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD cube_level NUMBER(8) DEFAULT ''1''';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.CUBE_LEVEL created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'FK_PRD_CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD fk_prd_cube_tsg_type VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.FK_PRD_CUBE_TSG_TYPE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'FK_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD fk_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.FK_PRD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'FK_OND_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD fk_ond_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.FK_OND_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'PRIJS';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD prijs NUMBER(8,2)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.PRIJS created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'OMSCHRIJVING';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD omschrijving VARCHAR2(120)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.OMSCHRIJVING created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'XF_OND_PRD_CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD xf_ond_prd_cube_tsg_type VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.XF_OND_PRD_CUBE_TSG_TYPE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'XF_OND_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD xf_ond_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.XF_OND_PRD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name = 'XK_OND_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD xk_ond_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL.XK_OND_CODE created');
		END IF;
		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_ONDERDEEL.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;
		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_ONDERDEEL.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_ONDERDEEL_DEEL');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_onderdeel_deel (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			fk_prd_cube_tsg_type VARCHAR2(8),
			fk_prd_code VARCHAR2(8),
			fk_ond_code VARCHAR2(8),
			code VARCHAR2(8),
			naam VARCHAR2(40),
			xf_ond_prd_cube_tsg_type VARCHAR2(8),
			xf_ond_prd_code VARCHAR2(8),
			xk_ond_code VARCHAR2(8))';
		DBMS_OUTPUT.PUT_LINE('Table T_ONDERDEEL_DEEL created');
	ELSE
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL.CUBE_ID created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL.CUBE_SEQUENCE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name = 'FK_PRD_CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD fk_prd_cube_tsg_type VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL.FK_PRD_CUBE_TSG_TYPE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name = 'FK_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD fk_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL.FK_PRD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name = 'FK_OND_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD fk_ond_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL.FK_OND_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL.CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name = 'NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL.NAAM created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name = 'XF_OND_PRD_CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD xf_ond_prd_cube_tsg_type VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL.XF_OND_PRD_CUBE_TSG_TYPE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name = 'XF_OND_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD xf_ond_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL.XF_OND_PRD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name = 'XK_OND_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD xk_ond_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL.XK_OND_CODE created');
		END IF;
		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_ONDERDEEL_DEEL.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;
		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_ONDERDEEL_DEEL.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_ONDERDEEL_DEEL_DEEL');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_onderdeel_deel_deel (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			fk_prd_cube_tsg_type VARCHAR2(8),
			fk_prd_code VARCHAR2(8),
			fk_ond_code VARCHAR2(8),
			fk_odd_code VARCHAR2(8),
			code VARCHAR2(8),
			naam VARCHAR2(40),
			xf_ond_prd_cube_tsg_type VARCHAR2(8),
			xf_ond_prd_code VARCHAR2(8),
			xk_ond_code VARCHAR2(8),
			xf_ond_prd_cube_tsg_type_3 VARCHAR2(8),
			xf_ond_prd_code_3 VARCHAR2(8),
			xk_ond_code_3 VARCHAR2(8),
			xf_ond_prd_cube_tsg_type_1 VARCHAR2(8),
			xf_ond_prd_code_1 VARCHAR2(8),
			xk_ond_code_1 VARCHAR2(8),
			xf_ond_prd_cube_tsg_type_2 VARCHAR2(8),
			xf_ond_prd_code_2 VARCHAR2(8),
			xk_ond_code_2 VARCHAR2(8))';
		DBMS_OUTPUT.PUT_LINE('Table T_ONDERDEEL_DEEL_DEEL created');
	ELSE
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.CUBE_ID created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.CUBE_SEQUENCE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'FK_PRD_CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD fk_prd_cube_tsg_type VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.FK_PRD_CUBE_TSG_TYPE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'FK_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD fk_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.FK_PRD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'FK_OND_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD fk_ond_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.FK_OND_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'FK_ODD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD fk_odd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.FK_ODD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.NAAM created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XF_OND_PRD_CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xf_ond_prd_cube_tsg_type VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XF_OND_PRD_CUBE_TSG_TYPE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XF_OND_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xf_ond_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XF_OND_PRD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XK_OND_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xk_ond_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XK_OND_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XF_OND_PRD_CUBE_TSG_TYPE_3';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xf_ond_prd_cube_tsg_type_3 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XF_OND_PRD_CUBE_TSG_TYPE_3 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XF_OND_PRD_CODE_3';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xf_ond_prd_code_3 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XF_OND_PRD_CODE_3 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XK_OND_CODE_3';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xk_ond_code_3 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XK_OND_CODE_3 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XF_OND_PRD_CUBE_TSG_TYPE_1';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xf_ond_prd_cube_tsg_type_1 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XF_OND_PRD_CUBE_TSG_TYPE_1 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XF_OND_PRD_CODE_1';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xf_ond_prd_code_1 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XF_OND_PRD_CODE_1 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XK_OND_CODE_1';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xk_ond_code_1 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XK_OND_CODE_1 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XF_OND_PRD_CUBE_TSG_TYPE_2';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xf_ond_prd_cube_tsg_type_2 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XF_OND_PRD_CUBE_TSG_TYPE_2 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XF_OND_PRD_CODE_2';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xf_ond_prd_code_2 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XF_OND_PRD_CODE_2 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name = 'XK_OND_CODE_2';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD xk_ond_code_2 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ONDERDEEL_DEEL_DEEL.XK_OND_CODE_2 created');
		END IF;
		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_ONDERDEEL_DEEL_DEEL.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;
		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_ONDERDEEL_DEEL_DEEL.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_ORDER');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_order (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			cube_tsg_int_ext VARCHAR2(8) DEFAULT ''INT'',
			code VARCHAR2(8),
			xk_kln_nummer VARCHAR2(8))';
		DBMS_OUTPUT.PUT_LINE('Table T_ORDER created');
	ELSE
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER.CUBE_ID created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER.CUBE_SEQUENCE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER' AND column_name = 'CUBE_TSG_INT_EXT';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order ADD cube_tsg_int_ext VARCHAR2(8) DEFAULT ''INT''';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER.CUBE_TSG_INT_EXT created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER.CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER' AND column_name = 'XK_KLN_NUMMER';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order ADD xk_kln_nummer VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER.XK_KLN_NUMMER created');
		END IF;
		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_ORDER.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;
		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_ORDER.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_ORDER_REGEL');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_order_regel (
			cube_id VARCHAR2(16),
			fk_ord_code VARCHAR2(8),
			produkt_prijs NUMBER(8,2),
			aantal NUMBER(8,2),
			totaal_prijs NUMBER(8,2),
			xk_prd_cube_tsg_type VARCHAR2(8),
			xk_prd_code VARCHAR2(8),
			xk_prd_cube_tsg_type_1 VARCHAR2(8),
			xk_prd_code_1 VARCHAR2(8),
			xk_kln_nummer VARCHAR2(8))';
		DBMS_OUTPUT.PUT_LINE('Table T_ORDER_REGEL created');
	ELSE
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER_REGEL.CUBE_ID created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name = 'FK_ORD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD fk_ord_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER_REGEL.FK_ORD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name = 'PRODUKT_PRIJS';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD produkt_prijs NUMBER(8,2)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER_REGEL.PRODUKT_PRIJS created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name = 'AANTAL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD aantal NUMBER(8,2)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER_REGEL.AANTAL created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name = 'TOTAAL_PRIJS';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD totaal_prijs NUMBER(8,2)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER_REGEL.TOTAAL_PRIJS created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name = 'XK_PRD_CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD xk_prd_cube_tsg_type VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER_REGEL.XK_PRD_CUBE_TSG_TYPE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name = 'XK_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD xk_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER_REGEL.XK_PRD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name = 'XK_PRD_CUBE_TSG_TYPE_1';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD xk_prd_cube_tsg_type_1 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER_REGEL.XK_PRD_CUBE_TSG_TYPE_1 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name = 'XK_PRD_CODE_1';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD xk_prd_code_1 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER_REGEL.XK_PRD_CODE_1 created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name = 'XK_KLN_NUMMER';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD xk_kln_nummer VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ORDER_REGEL.XK_KLN_NUMMER created');
		END IF;
		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_ORDER_REGEL.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;
		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_ORDER_REGEL.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_KLANT');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_TSG_INTEXT','VARCHAR2(8)',
			'CUBE_TSG_VIP','VARCHAR2(8)',
			'CUBE_TSG_TEST','VARCHAR2(8)',
			'NUMMER','VARCHAR2(8)',
			'ACHTERNAAM','VARCHAR2(40)',
			'GEBOORTE_DATUM','DATE',
			'LEEFTIJD','NUMBER(8)',
			'VOORNAAM','VARCHAR2(40)',
			'TUSSENVOEGSEL','VARCHAR2(40)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_TSG_INTEXT','''INT''',
			'CUBE_TSG_VIP','''VIP''',
			'CUBE_TSG_TEST',NULL,
			'NUMMER',NULL,
			'ACHTERNAAM',NULL,
			'GEBOORTE_DATUM',NULL,
			'LEEFTIJD',NULL,
			'VOORNAAM',NULL,
			'TUSSENVOEGSEL',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_klant SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_klant SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_KLANT.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_klant MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_KLANT.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_klant ADD CONSTRAINT kln_pk
		PRIMARY KEY (
			nummer )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_KLANT.KLN_PK created');
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_KLANT' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_TSG_INTEXT',
							'CUBE_TSG_VIP',
							'CUBE_TSG_TEST',
							'NUMMER',
							'ACHTERNAAM',
							'GEBOORTE_DATUM',
							'LEEFTIJD',
							'VOORNAAM',
							'TUSSENVOEGSEL'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_klant DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_KLANT.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_ADRES');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_KLN_NUMMER','VARCHAR2(8)',
			'POSTCODE_CIJFERS','NUMBER(4)',
			'POSTCODE_LETTERS','CHAR(2)',
			'CUBE_TSG_TEST','VARCHAR2(8)',
			'HUISNUMMER','NUMBER(8)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_KLN_NUMMER',NULL,
			'POSTCODE_CIJFERS',NULL,
			'POSTCODE_LETTERS',NULL,
			'CUBE_TSG_TEST',NULL,
			'HUISNUMMER',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_adres SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_adres SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_ADRES.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_adres MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_ADRES.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_adres ADD CONSTRAINT adr_pk
		PRIMARY KEY (
			fk_kln_nummer,
			postcode_cijfers,
			postcode_letters,
			cube_tsg_test,
			huisnummer )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_ADRES.ADR_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_adres ADD CONSTRAINT adr_kln_fk
		FOREIGN KEY (fk_kln_nummer)
		REFERENCES t_klant (nummer)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ADRES' AND column_name NOT IN (
							'CUBE_ID',
							'FK_KLN_NUMMER',
							'POSTCODE_CIJFERS',
							'POSTCODE_LETTERS',
							'CUBE_TSG_TEST',
							'HUISNUMMER'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_adres DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_ADRES.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_PRODUKT');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_TSG_TYPE','VARCHAR2(8)',
			'CUBE_TSG_SOORT','VARCHAR2(8)',
			'CUBE_TSG_SOORT1','VARCHAR2(8)',
			'CODE','VARCHAR2(8)',
			'PRIJS','NUMBER(8,2)',
			'MAKELAAR_NAAM','VARCHAR2(40)',
			'BEDRAG_BTW','NUMBER(8,2)',
			'XK_KLN_NUMMER','VARCHAR2(8)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_TSG_TYPE','''P''',
			'CUBE_TSG_SOORT','''R''',
			'CUBE_TSG_SOORT1','''GARAGE''',
			'CODE',NULL,
			'PRIJS',NULL,
			'MAKELAAR_NAAM',NULL,
			'BEDRAG_BTW',NULL,
			'XK_KLN_NUMMER',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_produkt SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_produkt SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_PRODUKT.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_produkt MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_PRODUKT.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_produkt ADD CONSTRAINT prd_pk
		PRIMARY KEY (
			cube_tsg_type,
			code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_PRODUKT.PRD_PK created');
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PRODUKT' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_TSG_TYPE',
							'CUBE_TSG_SOORT',
							'CUBE_TSG_SOORT1',
							'CODE',
							'PRIJS',
							'MAKELAAR_NAAM',
							'BEDRAG_BTW',
							'XK_KLN_NUMMER'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_produkt DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_PRODUKT.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_ONDERDEEL');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'CUBE_LEVEL','NUMBER(8)',
			'FK_PRD_CUBE_TSG_TYPE','VARCHAR2(8)',
			'FK_PRD_CODE','VARCHAR2(8)',
			'FK_OND_CODE','VARCHAR2(8)',
			'CODE','VARCHAR2(8)',
			'PRIJS','NUMBER(8,2)',
			'OMSCHRIJVING','VARCHAR2(120)',
			'XF_OND_PRD_CUBE_TSG_TYPE','VARCHAR2(8)',
			'XF_OND_PRD_CODE','VARCHAR2(8)',
			'XK_OND_CODE','VARCHAR2(8)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'CUBE_LEVEL','''1''',
			'FK_PRD_CUBE_TSG_TYPE',NULL,
			'FK_PRD_CODE',NULL,
			'FK_OND_CODE',NULL,
			'CODE',NULL,
			'PRIJS',NULL,
			'OMSCHRIJVING',NULL,
			'XF_OND_PRD_CUBE_TSG_TYPE',NULL,
			'XF_OND_PRD_CODE',NULL,
			'XK_OND_CODE',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_onderdeel SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_onderdeel SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_ONDERDEEL.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_ONDERDEEL.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_onderdeel ADD CONSTRAINT ond_pk
		PRIMARY KEY (
			fk_prd_cube_tsg_type,
			fk_prd_code,
			code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_ONDERDEEL.OND_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_onderdeel ADD CONSTRAINT ond_prd_fk
		FOREIGN KEY (fk_prd_cube_tsg_type, fk_prd_code)
		REFERENCES t_produkt (cube_tsg_type, code)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_onderdeel ADD CONSTRAINT ond_ond_fk
		FOREIGN KEY (fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code)
		REFERENCES t_onderdeel (fk_prd_cube_tsg_type, fk_prd_code, code)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'CUBE_LEVEL',
							'FK_PRD_CUBE_TSG_TYPE',
							'FK_PRD_CODE',
							'FK_OND_CODE',
							'CODE',
							'PRIJS',
							'OMSCHRIJVING',
							'XF_OND_PRD_CUBE_TSG_TYPE',
							'XF_OND_PRD_CODE',
							'XK_OND_CODE'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_onderdeel DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_ONDERDEEL.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_ONDERDEEL_DEEL');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'FK_PRD_CUBE_TSG_TYPE','VARCHAR2(8)',
			'FK_PRD_CODE','VARCHAR2(8)',
			'FK_OND_CODE','VARCHAR2(8)',
			'CODE','VARCHAR2(8)',
			'NAAM','VARCHAR2(40)',
			'XF_OND_PRD_CUBE_TSG_TYPE','VARCHAR2(8)',
			'XF_OND_PRD_CODE','VARCHAR2(8)',
			'XK_OND_CODE','VARCHAR2(8)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'FK_PRD_CUBE_TSG_TYPE',NULL,
			'FK_PRD_CODE',NULL,
			'FK_OND_CODE',NULL,
			'CODE',NULL,
			'NAAM',NULL,
			'XF_OND_PRD_CUBE_TSG_TYPE',NULL,
			'XF_OND_PRD_CODE',NULL,
			'XK_OND_CODE',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_onderdeel_deel SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_onderdeel_deel SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_ONDERDEEL_DEEL.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_ONDERDEEL_DEEL.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_onderdeel_deel ADD CONSTRAINT odd_pk
		PRIMARY KEY (
			code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_ONDERDEEL_DEEL.ODD_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_onderdeel_deel ADD CONSTRAINT odd_ond_fk
		FOREIGN KEY (fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code)
		REFERENCES t_onderdeel (fk_prd_cube_tsg_type, fk_prd_code, code)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'FK_PRD_CUBE_TSG_TYPE',
							'FK_PRD_CODE',
							'FK_OND_CODE',
							'CODE',
							'NAAM',
							'XF_OND_PRD_CUBE_TSG_TYPE',
							'XF_OND_PRD_CODE',
							'XK_OND_CODE'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_onderdeel_deel DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_ONDERDEEL_DEEL.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_ONDERDEEL_DEEL_DEEL');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'FK_PRD_CUBE_TSG_TYPE','VARCHAR2(8)',
			'FK_PRD_CODE','VARCHAR2(8)',
			'FK_OND_CODE','VARCHAR2(8)',
			'FK_ODD_CODE','VARCHAR2(8)',
			'CODE','VARCHAR2(8)',
			'NAAM','VARCHAR2(40)',
			'XF_OND_PRD_CUBE_TSG_TYPE','VARCHAR2(8)',
			'XF_OND_PRD_CODE','VARCHAR2(8)',
			'XK_OND_CODE','VARCHAR2(8)',
			'XF_OND_PRD_CUBE_TSG_TYPE_3','VARCHAR2(8)',
			'XF_OND_PRD_CODE_3','VARCHAR2(8)',
			'XK_OND_CODE_3','VARCHAR2(8)',
			'XF_OND_PRD_CUBE_TSG_TYPE_1','VARCHAR2(8)',
			'XF_OND_PRD_CODE_1','VARCHAR2(8)',
			'XK_OND_CODE_1','VARCHAR2(8)',
			'XF_OND_PRD_CUBE_TSG_TYPE_2','VARCHAR2(8)',
			'XF_OND_PRD_CODE_2','VARCHAR2(8)',
			'XK_OND_CODE_2','VARCHAR2(8)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'FK_PRD_CUBE_TSG_TYPE',NULL,
			'FK_PRD_CODE',NULL,
			'FK_OND_CODE',NULL,
			'FK_ODD_CODE',NULL,
			'CODE',NULL,
			'NAAM',NULL,
			'XF_OND_PRD_CUBE_TSG_TYPE',NULL,
			'XF_OND_PRD_CODE',NULL,
			'XK_OND_CODE',NULL,
			'XF_OND_PRD_CUBE_TSG_TYPE_3',NULL,
			'XF_OND_PRD_CODE_3',NULL,
			'XK_OND_CODE_3',NULL,
			'XF_OND_PRD_CUBE_TSG_TYPE_1',NULL,
			'XF_OND_PRD_CODE_1',NULL,
			'XK_OND_CODE_1',NULL,
			'XF_OND_PRD_CUBE_TSG_TYPE_2',NULL,
			'XF_OND_PRD_CODE_2',NULL,
			'XK_OND_CODE_2',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_onderdeel_deel_deel SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_onderdeel_deel_deel SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_ONDERDEEL_DEEL_DEEL.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_onderdeel_deel_deel MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_ONDERDEEL_DEEL_DEEL.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_onderdeel_deel_deel ADD CONSTRAINT ddd_pk
		PRIMARY KEY (
			code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_ONDERDEEL_DEEL_DEEL.DDD_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_onderdeel_deel_deel ADD CONSTRAINT ddd_odd_fk
		FOREIGN KEY (fk_odd_code)
		REFERENCES t_onderdeel_deel (code)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ONDERDEEL_DEEL_DEEL' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'FK_PRD_CUBE_TSG_TYPE',
							'FK_PRD_CODE',
							'FK_OND_CODE',
							'FK_ODD_CODE',
							'CODE',
							'NAAM',
							'XF_OND_PRD_CUBE_TSG_TYPE',
							'XF_OND_PRD_CODE',
							'XK_OND_CODE',
							'XF_OND_PRD_CUBE_TSG_TYPE_3',
							'XF_OND_PRD_CODE_3',
							'XK_OND_CODE_3',
							'XF_OND_PRD_CUBE_TSG_TYPE_1',
							'XF_OND_PRD_CODE_1',
							'XK_OND_CODE_1',
							'XF_OND_PRD_CUBE_TSG_TYPE_2',
							'XF_OND_PRD_CODE_2',
							'XK_OND_CODE_2'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_onderdeel_deel_deel DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_ONDERDEEL_DEEL_DEEL.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_ORDER');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'CUBE_TSG_INT_EXT','VARCHAR2(8)',
			'CODE','VARCHAR2(8)',
			'XK_KLN_NUMMER','VARCHAR2(8)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'CUBE_TSG_INT_EXT','''INT''',
			'CODE',NULL,
			'XK_KLN_NUMMER',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_order SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_order SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_ORDER.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_ORDER.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_order ADD CONSTRAINT ord_pk
		PRIMARY KEY (
			code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_ORDER.ORD_PK created');
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'CUBE_TSG_INT_EXT',
							'CODE',
							'XK_KLN_NUMMER'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_order DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_ORDER.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_ORDER_REGEL');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_ORD_CODE','VARCHAR2(8)',
			'PRODUKT_PRIJS','NUMBER(8,2)',
			'AANTAL','NUMBER(8,2)',
			'TOTAAL_PRIJS','NUMBER(8,2)',
			'XK_PRD_CUBE_TSG_TYPE','VARCHAR2(8)',
			'XK_PRD_CODE','VARCHAR2(8)',
			'XK_PRD_CUBE_TSG_TYPE_1','VARCHAR2(8)',
			'XK_PRD_CODE_1','VARCHAR2(8)',
			'XK_KLN_NUMMER','VARCHAR2(8)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_ORD_CODE',NULL,
			'PRODUKT_PRIJS',NULL,
			'AANTAL',NULL,
			'TOTAAL_PRIJS',NULL,
			'XK_PRD_CUBE_TSG_TYPE',NULL,
			'XK_PRD_CODE',NULL,
			'XK_PRD_CUBE_TSG_TYPE_1',NULL,
			'XK_PRD_CODE_1',NULL,
			'XK_KLN_NUMMER',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_order_regel SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_order_regel SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_ORDER_REGEL.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_order_regel MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_ORDER_REGEL.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_order_regel ADD CONSTRAINT orr_pk
		PRIMARY KEY (
			fk_ord_code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_ORDER_REGEL.ORR_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_order_regel ADD CONSTRAINT orr_ord_fk
		FOREIGN KEY (fk_ord_code)
		REFERENCES t_order (code)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_ORDER_REGEL' AND column_name NOT IN (
							'CUBE_ID',
							'FK_ORD_CODE',
							'PRODUKT_PRIJS',
							'AANTAL',
							'TOTAAL_PRIJS',
							'XK_PRD_CUBE_TSG_TYPE',
							'XK_PRD_CODE',
							'XK_PRD_CUBE_TSG_TYPE_1',
							'XK_PRD_CODE_1',
							'XK_KLN_NUMMER'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_order_regel DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_ORDER_REGEL.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
EXIT;
