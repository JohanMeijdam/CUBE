-- ALTER TABLE DDL
--
SET SERVEROUTPUT ON;
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'AAA_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE aaa_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence AAA_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'AAD_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE aad_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence AAD_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'BBB_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE bbb_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence BBB_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'CCC_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE ccc_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence CCC_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'PRD_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE prd_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence PRD_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'PR2_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE pr2_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence PR2_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'PA2_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE pa2_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence PA2_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBETEST' AND sequence_name = 'PRT_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE prt_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence PRT_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_AAA';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_aaa (
			cube_id VARCHAR2(16),
			cube_level NUMBER(8) DEFAULT ''1'',
			fk_aaa_naam VARCHAR2(40),
			naam VARCHAR2(40),
			omschrijving VARCHAR2(120),
			xk_aaa_naam VARCHAR2(40))';
		DBMS_OUTPUT.PUT_LINE('Table T_AAA created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'CUBE_LEVEL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD cube_level NUMBER(8) DEFAULT ''1''';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.CUBE_LEVEL created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'FK_AAA_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD fk_aaa_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.FK_AAA_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'OMSCHRIJVING';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD omschrijving VARCHAR2(120)';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.OMSCHRIJVING created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name = 'XK_AAA_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa ADD xk_aaa_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA.XK_AAA_NAAM created');
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
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_AAA_DEEL';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_aaa_deel (
			cube_id VARCHAR2(16),
			fk_aaa_naam VARCHAR2(40),
			naam VARCHAR2(40),
			xk_aaa_naam VARCHAR2(40))';
		DBMS_OUTPUT.PUT_LINE('Table T_AAA_DEEL created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA_DEEL' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa_deel ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA_DEEL.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA_DEEL' AND column_name = 'FK_AAA_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa_deel ADD fk_aaa_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA_DEEL.FK_AAA_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA_DEEL' AND column_name = 'NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa_deel ADD naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA_DEEL.NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA_DEEL' AND column_name = 'XK_AAA_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa_deel ADD xk_aaa_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_AAA_DEEL.XK_AAA_NAAM created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_AAA_DEEL' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa_deel DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_AAA_DEEL.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_AAA_DEEL')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_AAA_DEEL.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_BBB';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_bbb (
			cube_id VARCHAR2(16),
			naam VARCHAR2(40),
			omschrijving VARCHAR2(120),
			xk_aaa_naam VARCHAR2(40),
			xk_bbb_naam_1 VARCHAR2(40))';
		DBMS_OUTPUT.PUT_LINE('Table T_BBB created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_BBB' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_bbb ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_BBB.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_BBB' AND column_name = 'NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_bbb ADD naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_BBB.NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_BBB' AND column_name = 'OMSCHRIJVING';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_bbb ADD omschrijving VARCHAR2(120)';
			DBMS_OUTPUT.PUT_LINE('Column T_BBB.OMSCHRIJVING created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_BBB' AND column_name = 'XK_AAA_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_bbb ADD xk_aaa_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_BBB.XK_AAA_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_BBB' AND column_name = 'XK_BBB_NAAM_1';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_bbb ADD xk_bbb_naam_1 VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_BBB.XK_BBB_NAAM_1 created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_BBB' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_bbb DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_BBB.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_BBB')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_BBB.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_CCC';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_ccc (
			cube_id VARCHAR2(16),
			cube_level NUMBER(8) DEFAULT ''1'',
			fk_ccc_code VARCHAR2(8),
			fk_ccc_naam VARCHAR2(40),
			code VARCHAR2(8),
			naam VARCHAR2(40),
			omschrjving VARCHAR2(120),
			xk_ccc_code VARCHAR2(8),
			xk_ccc_naam VARCHAR2(40))';
		DBMS_OUTPUT.PUT_LINE('Table T_CCC created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_CCC.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND column_name = 'CUBE_LEVEL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc ADD cube_level NUMBER(8) DEFAULT ''1''';
			DBMS_OUTPUT.PUT_LINE('Column T_CCC.CUBE_LEVEL created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND column_name = 'FK_CCC_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc ADD fk_ccc_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_CCC.FK_CCC_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND column_name = 'FK_CCC_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc ADD fk_ccc_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_CCC.FK_CCC_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_CCC.CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND column_name = 'NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc ADD naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_CCC.NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND column_name = 'OMSCHRJVING';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc ADD omschrjving VARCHAR2(120)';
			DBMS_OUTPUT.PUT_LINE('Column T_CCC.OMSCHRJVING created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND column_name = 'XK_CCC_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc ADD xk_ccc_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_CCC.XK_CCC_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND column_name = 'XK_CCC_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc ADD xk_ccc_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_CCC.XK_CCC_NAAM created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_CCC.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_CCC')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_CCC.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_PROD';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_prod (
			cube_id VARCHAR2(16),
			code VARCHAR2(8),
			naam VARCHAR2(40),
			omschrijving VARCHAR2(120))';
		DBMS_OUTPUT.PUT_LINE('Table T_PROD created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_PROD.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PROD.CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD' AND column_name = 'NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod ADD naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PROD.NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD' AND column_name = 'OMSCHRIJVING';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod ADD omschrijving VARCHAR2(120)';
			DBMS_OUTPUT.PUT_LINE('Column T_PROD.OMSCHRIJVING created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_PROD' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_PROD.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_PROD')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_PROD.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_prod2 (
			cube_id VARCHAR2(16),
			fk_prd_code VARCHAR2(8),
			fk_prd_naam VARCHAR2(40),
			code VARCHAR2(8),
			naam VARCHAR2(40),
			omschrijving VARCHAR2(120))';
		DBMS_OUTPUT.PUT_LINE('Table T_PROD2 created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_PROD2.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2' AND column_name = 'FK_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 ADD fk_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PROD2.FK_PRD_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2' AND column_name = 'FK_PRD_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 ADD fk_prd_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PROD2.FK_PRD_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PROD2.CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2' AND column_name = 'NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 ADD naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PROD2.NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2' AND column_name = 'OMSCHRIJVING';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 ADD omschrijving VARCHAR2(120)';
			DBMS_OUTPUT.PUT_LINE('Column T_PROD2.OMSCHRIJVING created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_PROD2.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_PROD2.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_PART2';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_part2 (
			cube_id VARCHAR2(16),
			cube_level NUMBER(8) DEFAULT ''1'',
			fk_prd_code VARCHAR2(8),
			fk_prd_naam VARCHAR2(40),
			fk_pr2_code VARCHAR2(8),
			fk_pr2_naam VARCHAR2(40),
			fk_pa2_code VARCHAR2(8),
			fk_pa2_naam VARCHAR2(40),
			code VARCHAR2(8),
			naam VARCHAR2(40),
			omschrijving VARCHAR2(120),
			xf_pa2_prd_code VARCHAR2(8),
			xf_pa2_prd_naam VARCHAR2(40),
			xf_pa2_pr2_code VARCHAR2(8),
			xf_pa2_pr2_naam VARCHAR2(40),
			xk_pa2_code VARCHAR2(8),
			xk_pa2_naam VARCHAR2(40))';
		DBMS_OUTPUT.PUT_LINE('Table T_PART2 created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'CUBE_LEVEL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD cube_level NUMBER(8) DEFAULT ''1''';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.CUBE_LEVEL created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'FK_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD fk_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.FK_PRD_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'FK_PRD_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD fk_prd_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.FK_PRD_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'FK_PR2_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD fk_pr2_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.FK_PR2_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'FK_PR2_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD fk_pr2_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.FK_PR2_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'FK_PA2_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD fk_pa2_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.FK_PA2_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'FK_PA2_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD fk_pa2_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.FK_PA2_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'OMSCHRIJVING';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD omschrijving VARCHAR2(120)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.OMSCHRIJVING created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'XF_PA2_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD xf_pa2_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.XF_PA2_PRD_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'XF_PA2_PRD_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD xf_pa2_prd_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.XF_PA2_PRD_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'XF_PA2_PR2_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD xf_pa2_pr2_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.XF_PA2_PR2_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'XF_PA2_PR2_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD xf_pa2_pr2_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.XF_PA2_PR2_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'XK_PA2_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD xk_pa2_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.XK_PA2_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name = 'XK_PA2_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD xk_pa2_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART2.XK_PA2_NAAM created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_PART2.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_PART2')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_PART2.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBETEST' AND table_name = 'T_PART';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_part (
			cube_id VARCHAR2(16),
			cube_level NUMBER(8) DEFAULT ''1'',
			fk_prd_code VARCHAR2(8),
			fk_prd_naam VARCHAR2(40),
			fk_prt_code VARCHAR2(8),
			fk_prt_naam VARCHAR2(40),
			code VARCHAR2(8),
			naam VARCHAR2(40),
			omschrijving VARCHAR2(120),
			xf_prt_prd_code VARCHAR2(8),
			xf_prt_prd_naam VARCHAR2(40),
			xk_prt_code VARCHAR2(8),
			xk_prt_naam VARCHAR2(40))';
		DBMS_OUTPUT.PUT_LINE('Table T_PART created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'CUBE_LEVEL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD cube_level NUMBER(8) DEFAULT ''1''';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.CUBE_LEVEL created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'FK_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD fk_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.FK_PRD_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'FK_PRD_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD fk_prd_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.FK_PRD_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'FK_PRT_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD fk_prt_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.FK_PRT_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'FK_PRT_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD fk_prt_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.FK_PRT_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'OMSCHRIJVING';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD omschrijving VARCHAR2(120)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.OMSCHRIJVING created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'XF_PRT_PRD_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD xf_prt_prd_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.XF_PRT_PRD_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'XF_PRT_PRD_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD xf_prt_prd_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.XF_PRT_PRD_NAAM created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'XK_PRT_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD xk_prt_code VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.XK_PRT_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name = 'XK_PRT_NAAM';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD xk_prt_naam VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_PART.XK_PRT_NAAM created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_PART.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBETEST' AND table_name = 'T_PART')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_PART.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
BEGIN
	FOR r_table IN (SELECT t.table_name FROM all_tables t, all_tab_comments c
				WHERE t.table_name = c.table_name
				  AND t.owner = 'CUBETEST'
				  AND t.table_name NOT IN (
							'T_AAA',
							'T_AAA_DEEL',
							'T_BBB',
							'T_CCC',
							'T_PROD',
							'T_PROD2',
							'T_PART2',
							'T_PART')
				  AND SUBSTR(t.table_name,1,7) <> 'T_CUBE_')
	LOOP
		EXECUTE IMMEDIATE
		'DROP TABLE ' || r_table.table_name || ' CASCADE CONSTRAINTS';
		DBMS_OUTPUT.PUT_LINE('Table ' || UPPER(r_table.table_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_LEVEL','NUMBER(8)',
			'FK_AAA_NAAM','VARCHAR2(40)',
			'NAAM','VARCHAR2(40)',
			'OMSCHRIJVING','VARCHAR2(120)',
			'XK_AAA_NAAM','VARCHAR2(40)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_LEVEL','''1''',
			'FK_AAA_NAAM',NULL,
			'NAAM',NULL,
			'OMSCHRIJVING',NULL,
			'XK_AAA_NAAM',NULL,NULL) new_default_value
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
		PRIMARY KEY (
			naam )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_AAA.AAA_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_aaa ADD CONSTRAINT aaa_aaa_fk
		FOREIGN KEY (fk_aaa_naam)
		REFERENCES t_aaa (naam)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_LEVEL',
							'FK_AAA_NAAM',
							'NAAM',
							'OMSCHRIJVING',
							'XK_AAA_NAAM'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_aaa DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_AAA.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_AAA_NAAM','VARCHAR2(40)',
			'NAAM','VARCHAR2(40)',
			'XK_AAA_NAAM','VARCHAR2(40)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_AAA_NAAM',NULL,
			'NAAM',NULL,
			'XK_AAA_NAAM',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA_DEEL')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa_deel RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa_deel ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_aaa_deel SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_aaa_deel SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa_deel DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_AAA_DEEL.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_aaa_deel MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_AAA_DEEL.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_aaa_deel ADD CONSTRAINT aad_pk
		PRIMARY KEY (
			fk_aaa_naam,
			naam )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_AAA_DEEL.AAD_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_aaa_deel ADD CONSTRAINT aad_aaa_fk
		FOREIGN KEY (fk_aaa_naam)
		REFERENCES t_aaa (naam)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_AAA_DEEL' AND column_name NOT IN (
							'CUBE_ID',
							'FK_AAA_NAAM',
							'NAAM',
							'XK_AAA_NAAM'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_aaa_deel DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_AAA_DEEL.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'NAAM','VARCHAR2(40)',
			'OMSCHRIJVING','VARCHAR2(120)',
			'XK_AAA_NAAM','VARCHAR2(40)',
			'XK_BBB_NAAM_1','VARCHAR2(40)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'NAAM',NULL,
			'OMSCHRIJVING',NULL,
			'XK_AAA_NAAM',NULL,
			'XK_BBB_NAAM_1',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_BBB')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_bbb RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_bbb ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_bbb SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_bbb SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_bbb DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_BBB.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_bbb MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_BBB.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_bbb ADD CONSTRAINT bbb_pk
		PRIMARY KEY (
			naam )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_BBB.BBB_PK created');
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_BBB' AND column_name NOT IN (
							'CUBE_ID',
							'NAAM',
							'OMSCHRIJVING',
							'XK_AAA_NAAM',
							'XK_BBB_NAAM_1'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_bbb DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_BBB.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_LEVEL','NUMBER(8)',
			'FK_CCC_CODE','VARCHAR2(8)',
			'FK_CCC_NAAM','VARCHAR2(40)',
			'CODE','VARCHAR2(8)',
			'NAAM','VARCHAR2(40)',
			'OMSCHRJVING','VARCHAR2(120)',
			'XK_CCC_CODE','VARCHAR2(8)',
			'XK_CCC_NAAM','VARCHAR2(40)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_LEVEL','''1''',
			'FK_CCC_CODE',NULL,
			'FK_CCC_NAAM',NULL,
			'CODE',NULL,
			'NAAM',NULL,
			'OMSCHRJVING',NULL,
			'XK_CCC_CODE',NULL,
			'XK_CCC_NAAM',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_ccc SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_ccc SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_CCC.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_ccc MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_CCC.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_ccc ADD CONSTRAINT ccc_pk
		PRIMARY KEY (
			code,
			naam )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_CCC.CCC_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_ccc ADD CONSTRAINT ccc_ccc_fk
		FOREIGN KEY (fk_ccc_code, fk_ccc_naam)
		REFERENCES t_ccc (code, naam)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_CCC' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_LEVEL',
							'FK_CCC_CODE',
							'FK_CCC_NAAM',
							'CODE',
							'NAAM',
							'OMSCHRJVING',
							'XK_CCC_CODE',
							'XK_CCC_NAAM'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_ccc DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_CCC.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CODE','VARCHAR2(8)',
			'NAAM','VARCHAR2(40)',
			'OMSCHRIJVING','VARCHAR2(120)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CODE',NULL,
			'NAAM',NULL,
			'OMSCHRIJVING',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_prod SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_prod SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_PROD.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_PROD.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_prod ADD CONSTRAINT prd_pk
		PRIMARY KEY (
			code,
			naam )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_PROD.PRD_PK created');
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD' AND column_name NOT IN (
							'CUBE_ID',
							'CODE',
							'NAAM',
							'OMSCHRIJVING'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_prod DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_PROD.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_PRD_CODE','VARCHAR2(8)',
			'FK_PRD_NAAM','VARCHAR2(40)',
			'CODE','VARCHAR2(8)',
			'NAAM','VARCHAR2(40)',
			'OMSCHRIJVING','VARCHAR2(120)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_PRD_CODE',NULL,
			'FK_PRD_NAAM',NULL,
			'CODE',NULL,
			'NAAM',NULL,
			'OMSCHRIJVING',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_prod2 SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_prod2 SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_PROD2.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_prod2 MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_PROD2.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_prod2 ADD CONSTRAINT pr2_pk
		PRIMARY KEY (
			fk_prd_code,
			fk_prd_naam,
			code,
			naam )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_PROD2.PR2_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_prod2 ADD CONSTRAINT pr2_prd_fk
		FOREIGN KEY (fk_prd_code, fk_prd_naam)
		REFERENCES t_prod (code, naam)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PROD2' AND column_name NOT IN (
							'CUBE_ID',
							'FK_PRD_CODE',
							'FK_PRD_NAAM',
							'CODE',
							'NAAM',
							'OMSCHRIJVING'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_prod2 DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_PROD2.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_LEVEL','NUMBER(8)',
			'FK_PRD_CODE','VARCHAR2(8)',
			'FK_PRD_NAAM','VARCHAR2(40)',
			'FK_PR2_CODE','VARCHAR2(8)',
			'FK_PR2_NAAM','VARCHAR2(40)',
			'FK_PA2_CODE','VARCHAR2(8)',
			'FK_PA2_NAAM','VARCHAR2(40)',
			'CODE','VARCHAR2(8)',
			'NAAM','VARCHAR2(40)',
			'OMSCHRIJVING','VARCHAR2(120)',
			'XF_PA2_PRD_CODE','VARCHAR2(8)',
			'XF_PA2_PRD_NAAM','VARCHAR2(40)',
			'XF_PA2_PR2_CODE','VARCHAR2(8)',
			'XF_PA2_PR2_NAAM','VARCHAR2(40)',
			'XK_PA2_CODE','VARCHAR2(8)',
			'XK_PA2_NAAM','VARCHAR2(40)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_LEVEL','''1''',
			'FK_PRD_CODE',NULL,
			'FK_PRD_NAAM',NULL,
			'FK_PR2_CODE',NULL,
			'FK_PR2_NAAM',NULL,
			'FK_PA2_CODE',NULL,
			'FK_PA2_NAAM',NULL,
			'CODE',NULL,
			'NAAM',NULL,
			'OMSCHRIJVING',NULL,
			'XF_PA2_PRD_CODE',NULL,
			'XF_PA2_PRD_NAAM',NULL,
			'XF_PA2_PR2_CODE',NULL,
			'XF_PA2_PR2_NAAM',NULL,
			'XK_PA2_CODE',NULL,
			'XK_PA2_NAAM',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_part2 SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_part2 SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_PART2.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part2 MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_PART2.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_part2 ADD CONSTRAINT pa2_pk
		PRIMARY KEY (
			fk_prd_code,
			fk_prd_naam,
			fk_pr2_code,
			fk_pr2_naam,
			code,
			naam )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_PART2.PA2_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_part2 ADD CONSTRAINT pa2_pr2_fk
		FOREIGN KEY (fk_prd_code, fk_prd_naam, fk_pr2_code, fk_pr2_naam)
		REFERENCES t_prod2 (fk_prd_code, fk_prd_naam, code, naam)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_part2 ADD CONSTRAINT pa2_pa2_fk
		FOREIGN KEY (fk_prd_code, fk_prd_naam, fk_pr2_code, fk_pr2_naam, fk_pa2_code, fk_pa2_naam)
		REFERENCES t_part2 (fk_prd_code, fk_prd_naam, fk_pr2_code, fk_pr2_naam, code, naam)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART2' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_LEVEL',
							'FK_PRD_CODE',
							'FK_PRD_NAAM',
							'FK_PR2_CODE',
							'FK_PR2_NAAM',
							'FK_PA2_CODE',
							'FK_PA2_NAAM',
							'CODE',
							'NAAM',
							'OMSCHRIJVING',
							'XF_PA2_PRD_CODE',
							'XF_PA2_PRD_NAAM',
							'XF_PA2_PR2_CODE',
							'XF_PA2_PR2_NAAM',
							'XK_PA2_CODE',
							'XK_PA2_NAAM'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_part2 DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_PART2.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_LEVEL','NUMBER(8)',
			'FK_PRD_CODE','VARCHAR2(8)',
			'FK_PRD_NAAM','VARCHAR2(40)',
			'FK_PRT_CODE','VARCHAR2(8)',
			'FK_PRT_NAAM','VARCHAR2(40)',
			'CODE','VARCHAR2(8)',
			'NAAM','VARCHAR2(40)',
			'OMSCHRIJVING','VARCHAR2(120)',
			'XF_PRT_PRD_CODE','VARCHAR2(8)',
			'XF_PRT_PRD_NAAM','VARCHAR2(40)',
			'XK_PRT_CODE','VARCHAR2(8)',
			'XK_PRT_NAAM','VARCHAR2(40)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_LEVEL','''1''',
			'FK_PRD_CODE',NULL,
			'FK_PRD_NAAM',NULL,
			'FK_PRT_CODE',NULL,
			'FK_PRT_NAAM',NULL,
			'CODE',NULL,
			'NAAM',NULL,
			'OMSCHRIJVING',NULL,
			'XF_PRT_PRD_CODE',NULL,
			'XF_PRT_PRD_NAAM',NULL,
			'XK_PRT_CODE',NULL,
			'XK_PRT_NAAM',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_part SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_part SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_PART.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_part MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_PART.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_part ADD CONSTRAINT prt_pk
		PRIMARY KEY (
			fk_prd_code,
			fk_prd_naam,
			code,
			naam )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_PART.PRT_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_part ADD CONSTRAINT prt_prd_fk
		FOREIGN KEY (fk_prd_code, fk_prd_naam)
		REFERENCES t_prod (code, naam)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_part ADD CONSTRAINT prt_prt_fk
		FOREIGN KEY (fk_prd_code, fk_prd_naam, fk_prt_code, fk_prt_naam)
		REFERENCES t_part (fk_prd_code, fk_prd_naam, code, naam)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBETEST' AND table_name = 'T_PART' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_LEVEL',
							'FK_PRD_CODE',
							'FK_PRD_NAAM',
							'FK_PRT_CODE',
							'FK_PRT_NAAM',
							'CODE',
							'NAAM',
							'OMSCHRIJVING',
							'XF_PRT_PRD_CODE',
							'XF_PRT_PRD_NAAM',
							'XK_PRT_CODE',
							'XK_PRT_NAAM'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_part DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_PART.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
EXIT;
