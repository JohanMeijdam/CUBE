-- ALTER TABLE DDL
--
SET SERVEROUTPUT ON;
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
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'SQ_CST';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sq_cst START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SQ_CST created');
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'SQ_AAA';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sq_aaa START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SQ_AAA created');
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
			bedrag_btw NUMBER(8,2))';
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
			fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT ''P'',
			fk_prd_code VARCHAR2(8),
			fk_ond_code VARCHAR2(8),
			code VARCHAR2(8),
			prijs NUMBER(8,2),
			omschrijving VARCHAR2(120))';
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
			'ALTER TABLE t_onderdeel ADD fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT ''P''';
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
			fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT ''P'',
			fk_prd_code VARCHAR2(8),
			fk_ond_code VARCHAR2(8),
			code VARCHAR2(8),
			naam VARCHAR2(40))';
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
			'ALTER TABLE t_onderdeel_deel ADD fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT ''P''';
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
			fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT ''P'',
			fk_prd_code VARCHAR2(8),
			fk_ond_code VARCHAR2(8),
			fk_odd_code VARCHAR2(8),
			code VARCHAR2(8),
			naam VARCHAR2(40))';
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
			'ALTER TABLE t_onderdeel_deel_deel ADD fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT ''P''';
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
	DBMS_OUTPUT.PUT_LINE('Prepare table T_CONSTRUCTIE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_constructie (
			cube_id VARCHAR2(16),
			fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT ''P'',
			fk_prd_code VARCHAR2(8),
			fk_ond_code VARCHAR2(8),
			code VARCHAR2(8),
			omschrijving VARCHAR2(120),
			xk_odd_code VARCHAR2(8),
			xk_odd_code_1 VARCHAR2(8))';
		DBMS_OUTPUT.PUT_LINE('Table T_CONSTRUCTIE created');
	ELSE
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_CONSTRUCTIE.CUBE_ID created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE' AND column_name = 'FK_PRD_CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie ADD fk_prd_cube_tsg_type VARCHAR2(8) DEFAULT ''P''';
			DBMS_OUTPUT.PUT_LINE('Column T_CONSTRUCTIE.FK_PRD_CUBE_TSG_TYPE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE' AND column_name = 'FK_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie ADD fk_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_CONSTRUCTIE.FK_PRD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE' AND column_name = 'FK_OND_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie ADD fk_ond_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_CONSTRUCTIE.FK_OND_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_CONSTRUCTIE.CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE' AND column_name = 'OMSCHRIJVING';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie ADD omschrijving VARCHAR2(120)';
			DBMS_OUTPUT.PUT_LINE('Column T_CONSTRUCTIE.OMSCHRIJVING created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE' AND column_name = 'XK_ODD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie ADD xk_odd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_CONSTRUCTIE.XK_ODD_CODE created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE' AND column_name = 'XK_ODD_CODE_1';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie ADD xk_odd_code_1 VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_CONSTRUCTIE.XK_ODD_CODE_1 created');
		END IF;
		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_CONSTRUCTIE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;
		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_CONSTRUCTIE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_AAA');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_AAA';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_aaa (
			cube_id VARCHAR2(16),
			nummer NUMBER(8) DEFAULT ''0'',
			struct_d DATE DEFAULT ''1900-01-01'',
			struct_t DATE DEFAULT ''12:00:00'',
			struct_dt TIMESTAMP DEFAULT ''1900-01-01 12:00:00'')';
		DBMS_OUTPUT.PUT_LINE('Table T_AAA created');
	ELSE
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.CUBE_ID created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'NUMMER';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD nummer NUMBER(8) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.NUMMER created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'STRUCT_D';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD struct_d DATE DEFAULT ''1900-01-01''';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.STRUCT_D created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'STRUCT_T';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD struct_t DATE DEFAULT ''12:00:00''';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.STRUCT_T created');
		END IF;
		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'STRUCT_DT';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD struct_dt TIMESTAMP DEFAULT ''1900-01-01 12:00:00''';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.STRUCT_DT created');
		END IF;
		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_AAA.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;
		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_AAA')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_AAA.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
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
			'BEDRAG_BTW','NUMBER(8,2)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_TSG_TYPE','''P''',
			'CUBE_TSG_SOORT','''R''',
			'CUBE_TSG_SOORT1','''GARAGE''',
			'CODE',NULL,
			'PRIJS',NULL,
			'MAKELAAR_NAAM',NULL,
			'BEDRAG_BTW',NULL,NULL) new_default_value
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
							'BEDRAG_BTW'))
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
			'OMSCHRIJVING','VARCHAR2(120)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'CUBE_LEVEL','''1''',
			'FK_PRD_CUBE_TSG_TYPE','''P''',
			'FK_PRD_CODE',NULL,
			'FK_OND_CODE',NULL,
			'CODE',NULL,
			'PRIJS',NULL,
			'OMSCHRIJVING',NULL,NULL) new_default_value
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
							'OMSCHRIJVING'))
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
			'NAAM','VARCHAR2(40)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'FK_PRD_CUBE_TSG_TYPE','''P''',
			'FK_PRD_CODE',NULL,
			'FK_OND_CODE',NULL,
			'CODE',NULL,
			'NAAM',NULL,NULL) new_default_value
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
							'NAAM'))
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
			'NAAM','VARCHAR2(40)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'FK_PRD_CUBE_TSG_TYPE','''P''',
			'FK_PRD_CODE',NULL,
			'FK_OND_CODE',NULL,
			'FK_ODD_CODE',NULL,
			'CODE',NULL,
			'NAAM',NULL,NULL) new_default_value
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
							'NAAM'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_onderdeel_deel_deel DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_ONDERDEEL_DEEL_DEEL.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_CONSTRUCTIE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_PRD_CUBE_TSG_TYPE','VARCHAR2(8)',
			'FK_PRD_CODE','VARCHAR2(8)',
			'FK_OND_CODE','VARCHAR2(8)',
			'CODE','VARCHAR2(8)',
			'OMSCHRIJVING','VARCHAR2(120)',
			'XK_ODD_CODE','VARCHAR2(8)',
			'XK_ODD_CODE_1','VARCHAR2(8)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_PRD_CUBE_TSG_TYPE','''P''',
			'FK_PRD_CODE',NULL,
			'FK_OND_CODE',NULL,
			'CODE',NULL,
			'OMSCHRIJVING',NULL,
			'XK_ODD_CODE',NULL,
			'XK_ODD_CODE_1',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_constructie SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_constructie SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_CONSTRUCTIE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_constructie MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_CONSTRUCTIE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_constructie ADD CONSTRAINT cst_pk
		PRIMARY KEY (
			fk_prd_cube_tsg_type,
			fk_prd_code,
			fk_ond_code,
			code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_CONSTRUCTIE.CST_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_constructie ADD CONSTRAINT cst_ond_fk
		FOREIGN KEY (fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code)
		REFERENCES t_onderdeel (fk_prd_cube_tsg_type, fk_prd_code, code)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CONSTRUCTIE' AND column_name NOT IN (
							'CUBE_ID',
							'FK_PRD_CUBE_TSG_TYPE',
							'FK_PRD_CODE',
							'FK_OND_CODE',
							'CODE',
							'OMSCHRIJVING',
							'XK_ODD_CODE',
							'XK_ODD_CODE_1'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_constructie DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_CONSTRUCTIE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_AAA');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'NUMMER','NUMBER(8)',
			'STRUCT_D','DATE',
			'STRUCT_T','DATE',
			'STRUCT_DT','TIMESTAMP',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'NUMMER','''0''',
			'STRUCT_D','''1900-01-01''',
			'STRUCT_T','''12:00:00''',
			'STRUCT_DT','''1900-01-01 12:00:00''',NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_aaa SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_aaa SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_AAA.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_AAA.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_aaa ADD CONSTRAINT aaa_pk
		PRIMARY KEY ( )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_AAA.AAA_PK created');
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name NOT IN (
							'CUBE_ID',
							'NUMMER',
							'STRUCT_D',
							'STRUCT_T',
							'STRUCT_DT'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_aaa DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_AAA.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
EXIT;
