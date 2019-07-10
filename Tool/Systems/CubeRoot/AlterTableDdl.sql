-- ALTER TABLE DDL
--
SET SERVEROUTPUT ON;
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'ITP_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE itp_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence ITP_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'ITE_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE ite_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence ITE_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'VAL_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE val_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence VAL_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'BOT_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE bot_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence BOT_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'TYP_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE typ_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence TYP_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'ATB_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE atb_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence ATB_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'DER_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE der_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence DER_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'DCA_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE dca_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence DCA_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'RTA_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE rta_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence RTA_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'REF_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE ref_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence REF_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'DCR_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE dcr_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence DCR_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'RTR_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE rtr_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence RTR_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'RTT_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE rtt_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence RTT_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'JSN_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE jsn_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence JSN_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'JPA_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE jpa_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence JPA_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'TYR_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE tyr_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence TYR_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'PAR_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE par_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence PAR_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'STP_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE stp_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence STP_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'TSG_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE tsg_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence TSG_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'TSP_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE tsp_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence TSP_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'DCT_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE dct_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence DCT_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'SYS_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sys_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SYS_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = 'CUBEROOT' AND sequence_name = 'SBT_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE sbt_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence SBT_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_INFORMATION_TYPE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_information_type (
			cube_id VARCHAR2(16),
			name VARCHAR2(30))';
		DBMS_OUTPUT.PUT_LINE('Table T_INFORMATION_TYPE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type ADD name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE.NAME created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_INFORMATION_TYPE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_INFORMATION_TYPE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_INFORMATION_TYPE_ELEMENT');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_information_type_element (
			cube_id VARCHAR2(16),
			fk_itp_name VARCHAR2(30),
			sequence NUMBER(8) DEFAULT ''0'',
			suffix VARCHAR2(12),
			domain VARCHAR2(16) DEFAULT ''TEXT'',
			length NUMBER(8) DEFAULT ''0'',
			decimals NUMBER(8) DEFAULT ''0'',
			case_sensitive CHAR(1) DEFAULT ''N'',
			default_value VARCHAR2(32),
			spaces_allowed CHAR(1) DEFAULT ''N'',
			presentation VARCHAR2(3) DEFAULT ''LIN'')';
		DBMS_OUTPUT.PUT_LINE('Table T_INFORMATION_TYPE_ELEMENT created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'FK_ITP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD fk_itp_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.FK_ITP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD sequence NUMBER(8) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'SUFFIX';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD suffix VARCHAR2(12)';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.SUFFIX created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'DOMAIN';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD domain VARCHAR2(16) DEFAULT ''TEXT''';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.DOMAIN created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'LENGTH';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD length NUMBER(8) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.LENGTH created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'DECIMALS';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD decimals NUMBER(8) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.DECIMALS created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'CASE_SENSITIVE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD case_sensitive CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.CASE_SENSITIVE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'DEFAULT_VALUE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD default_value VARCHAR2(32)';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.DEFAULT_VALUE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'SPACES_ALLOWED';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD spaces_allowed CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.SPACES_ALLOWED created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name = 'PRESENTATION';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD presentation VARCHAR2(3) DEFAULT ''LIN''';
			DBMS_OUTPUT.PUT_LINE('Column T_INFORMATION_TYPE_ELEMENT.PRESENTATION created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_INFORMATION_TYPE_ELEMENT.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_INFORMATION_TYPE_ELEMENT.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_PERMITTED_VALUE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_permitted_value (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			fk_itp_name VARCHAR2(30),
			fk_ite_sequence NUMBER(8) DEFAULT ''0'',
			code VARCHAR2(16),
			prompt VARCHAR2(32))';
		DBMS_OUTPUT.PUT_LINE('Table T_PERMITTED_VALUE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_PERMITTED_VALUE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_PERMITTED_VALUE.CUBE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE' AND column_name = 'FK_ITP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value ADD fk_itp_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_PERMITTED_VALUE.FK_ITP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE' AND column_name = 'FK_ITE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value ADD fk_ite_sequence NUMBER(8) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_PERMITTED_VALUE.FK_ITE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value ADD code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_PERMITTED_VALUE.CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE' AND column_name = 'PROMPT';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value ADD prompt VARCHAR2(32)';
			DBMS_OUTPUT.PUT_LINE('Column T_PERMITTED_VALUE.PROMPT created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_PERMITTED_VALUE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_PERMITTED_VALUE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_BUSINESS_OBJECT_TYPE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_business_object_type (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			name VARCHAR2(30),
			cube_tsg_type VARCHAR2(8) DEFAULT ''INT'',
			directory VARCHAR2(80),
			api_url VARCHAR2(300))';
		DBMS_OUTPUT.PUT_LINE('Table T_BUSINESS_OBJECT_TYPE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_BUSINESS_OBJECT_TYPE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_BUSINESS_OBJECT_TYPE.CUBE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type ADD name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_BUSINESS_OBJECT_TYPE.NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE' AND column_name = 'CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type ADD cube_tsg_type VARCHAR2(8) DEFAULT ''INT''';
			DBMS_OUTPUT.PUT_LINE('Column T_BUSINESS_OBJECT_TYPE.CUBE_TSG_TYPE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE' AND column_name = 'DIRECTORY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type ADD directory VARCHAR2(80)';
			DBMS_OUTPUT.PUT_LINE('Column T_BUSINESS_OBJECT_TYPE.DIRECTORY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE' AND column_name = 'API_URL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type ADD api_url VARCHAR2(300)';
			DBMS_OUTPUT.PUT_LINE('Column T_BUSINESS_OBJECT_TYPE.API_URL created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_BUSINESS_OBJECT_TYPE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_BUSINESS_OBJECT_TYPE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_TYPE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_type (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			cube_level NUMBER(8) DEFAULT ''1'',
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			name VARCHAR2(30),
			code VARCHAR2(3),
			flag_partial_key CHAR(1) DEFAULT ''Y'',
			flag_recursive CHAR(1) DEFAULT ''N'',
			recursive_cardinality CHAR(1) DEFAULT ''N'',
			cardinality CHAR(1) DEFAULT ''N'',
			sort_order CHAR(1) DEFAULT ''N'',
			icon VARCHAR2(8),
			transferable CHAR(1) DEFAULT ''Y'')';
		DBMS_OUTPUT.PUT_LINE('Table T_TYPE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.CUBE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'CUBE_LEVEL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD cube_level NUMBER(8) DEFAULT ''1''';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.CUBE_LEVEL created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD code VARCHAR2(3)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'FLAG_PARTIAL_KEY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD flag_partial_key CHAR(1) DEFAULT ''Y''';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.FLAG_PARTIAL_KEY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'FLAG_RECURSIVE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD flag_recursive CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.FLAG_RECURSIVE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'RECURSIVE_CARDINALITY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD recursive_cardinality CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.RECURSIVE_CARDINALITY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'CARDINALITY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD cardinality CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.CARDINALITY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'SORT_ORDER';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD sort_order CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.SORT_ORDER created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'ICON';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD icon VARCHAR2(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.ICON created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name = 'TRANSFERABLE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD transferable CHAR(1) DEFAULT ''Y''';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE.TRANSFERABLE created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_TYPE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_TYPE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_ATTRIBUTE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_attribute (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			name VARCHAR2(30),
			primary_key CHAR(1) DEFAULT ''N'',
			code_display_key CHAR(1) DEFAULT ''N'',
			code_foreign_key CHAR(1) DEFAULT ''N'',
			flag_hidden CHAR(1) DEFAULT ''N'',
			default_value VARCHAR2(40),
			unchangeable CHAR(1) DEFAULT ''N'',
			xk_itp_name VARCHAR2(30))';
		DBMS_OUTPUT.PUT_LINE('Table T_ATTRIBUTE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.CUBE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'PRIMARY_KEY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD primary_key CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.PRIMARY_KEY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'CODE_DISPLAY_KEY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD code_display_key CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.CODE_DISPLAY_KEY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'CODE_FOREIGN_KEY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD code_foreign_key CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.CODE_FOREIGN_KEY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'FLAG_HIDDEN';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD flag_hidden CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.FLAG_HIDDEN created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'DEFAULT_VALUE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD default_value VARCHAR2(40)';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.DEFAULT_VALUE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'UNCHANGEABLE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD unchangeable CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.UNCHANGEABLE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name = 'XK_ITP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD xk_itp_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_ATTRIBUTE.XK_ITP_NAME created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_ATTRIBUTE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_ATTRIBUTE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_DERIVATION');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_derivation (
			cube_id VARCHAR2(16),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			fk_atb_name VARCHAR2(30),
			cube_tsg_type VARCHAR2(8) DEFAULT ''DN'',
			aggregate_function VARCHAR2(3) DEFAULT ''SUM'',
			xk_typ_name VARCHAR2(30),
			xk_typ_name_1 VARCHAR2(30))';
		DBMS_OUTPUT.PUT_LINE('Table T_DERIVATION created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_DERIVATION.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DERIVATION.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DERIVATION.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION' AND column_name = 'FK_ATB_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation ADD fk_atb_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DERIVATION.FK_ATB_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION' AND column_name = 'CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation ADD cube_tsg_type VARCHAR2(8) DEFAULT ''DN''';
			DBMS_OUTPUT.PUT_LINE('Column T_DERIVATION.CUBE_TSG_TYPE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION' AND column_name = 'AGGREGATE_FUNCTION';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation ADD aggregate_function VARCHAR2(3) DEFAULT ''SUM''';
			DBMS_OUTPUT.PUT_LINE('Column T_DERIVATION.AGGREGATE_FUNCTION created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION' AND column_name = 'XK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation ADD xk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DERIVATION.XK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION' AND column_name = 'XK_TYP_NAME_1';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation ADD xk_typ_name_1 VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DERIVATION.XK_TYP_NAME_1 created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_DERIVATION.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_DERIVATION.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_DESCRIPTION_ATTRIBUTE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_ATTRIBUTE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_description_attribute (
			cube_id VARCHAR2(16),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			fk_atb_name VARCHAR2(30),
			text VARCHAR2(3999))';
		DBMS_OUTPUT.PUT_LINE('Table T_DESCRIPTION_ATTRIBUTE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_ATTRIBUTE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_attribute ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_ATTRIBUTE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_ATTRIBUTE' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_attribute ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_ATTRIBUTE.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_ATTRIBUTE' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_attribute ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_ATTRIBUTE.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_ATTRIBUTE' AND column_name = 'FK_ATB_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_attribute ADD fk_atb_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_ATTRIBUTE.FK_ATB_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_ATTRIBUTE' AND column_name = 'TEXT';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_attribute ADD text VARCHAR2(3999)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_ATTRIBUTE.TEXT created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_ATTRIBUTE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_attribute DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_DESCRIPTION_ATTRIBUTE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_ATTRIBUTE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_DESCRIPTION_ATTRIBUTE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_RESTRICTION_TYPE_SPEC_ATB');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_restriction_type_spec_atb (
			cube_id VARCHAR2(16),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			fk_atb_name VARCHAR2(30),
			include_or_exclude CHAR(2) DEFAULT ''IN'',
			xf_tsp_typ_name VARCHAR2(30),
			xf_tsp_tsg_code VARCHAR2(16),
			xk_tsp_code VARCHAR2(16))';
		DBMS_OUTPUT.PUT_LINE('Table T_RESTRICTION_TYPE_SPEC_ATB created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_ATB.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_ATB.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_ATB.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB' AND column_name = 'FK_ATB_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb ADD fk_atb_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_ATB.FK_ATB_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB' AND column_name = 'INCLUDE_OR_EXCLUDE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb ADD include_or_exclude CHAR(2) DEFAULT ''IN''';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_ATB.INCLUDE_OR_EXCLUDE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB' AND column_name = 'XF_TSP_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb ADD xf_tsp_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_ATB.XF_TSP_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB' AND column_name = 'XF_TSP_TSG_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb ADD xf_tsp_tsg_code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_ATB.XF_TSP_TSG_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB' AND column_name = 'XK_TSP_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb ADD xk_tsp_code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_ATB.XK_TSP_CODE created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_RESTRICTION_TYPE_SPEC_ATB.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_RESTRICTION_TYPE_SPEC_ATB.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_REFERENCE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_reference (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			name VARCHAR2(30),
			primary_key CHAR(1) DEFAULT ''N'',
			code_display_key CHAR(1) DEFAULT ''N'',
			sequence NUMBER(1) DEFAULT ''0'',
			scope VARCHAR2(3) DEFAULT ''ALL'',
			unchangeable CHAR(1) DEFAULT ''N'',
			within_scope_level NUMBER(1) DEFAULT ''0'',
			xk_typ_name VARCHAR2(30),
			xk_typ_name_1 VARCHAR2(30))';
		DBMS_OUTPUT.PUT_LINE('Table T_REFERENCE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.CUBE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'PRIMARY_KEY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD primary_key CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.PRIMARY_KEY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'CODE_DISPLAY_KEY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD code_display_key CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.CODE_DISPLAY_KEY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD sequence NUMBER(1) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'SCOPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD scope VARCHAR2(3) DEFAULT ''ALL''';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.SCOPE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'UNCHANGEABLE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD unchangeable CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.UNCHANGEABLE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'WITHIN_SCOPE_LEVEL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD within_scope_level NUMBER(1) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.WITHIN_SCOPE_LEVEL created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'XK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD xk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.XK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name = 'XK_TYP_NAME_1';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD xk_typ_name_1 VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_REFERENCE.XK_TYP_NAME_1 created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_REFERENCE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_REFERENCE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_DESCRIPTION_REFERENCE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_description_reference (
			cube_id VARCHAR2(16),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			fk_ref_sequence NUMBER(1) DEFAULT ''0'',
			fk_ref_typ_name VARCHAR2(30),
			text VARCHAR2(3999))';
		DBMS_OUTPUT.PUT_LINE('Table T_DESCRIPTION_REFERENCE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_REFERENCE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_REFERENCE.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_REFERENCE.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE' AND column_name = 'FK_REF_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference ADD fk_ref_sequence NUMBER(1) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_REFERENCE.FK_REF_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE' AND column_name = 'FK_REF_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference ADD fk_ref_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_REFERENCE.FK_REF_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE' AND column_name = 'TEXT';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference ADD text VARCHAR2(3999)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_REFERENCE.TEXT created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_DESCRIPTION_REFERENCE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_DESCRIPTION_REFERENCE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_RESTRICTION_TYPE_SPEC_REF');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_restriction_type_spec_ref (
			cube_id VARCHAR2(16),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			fk_ref_sequence NUMBER(1) DEFAULT ''0'',
			fk_ref_typ_name VARCHAR2(30),
			include_or_exclude CHAR(2) DEFAULT ''IN'',
			xf_tsp_typ_name VARCHAR2(30),
			xf_tsp_tsg_code VARCHAR2(16),
			xk_tsp_code VARCHAR2(16))';
		DBMS_OUTPUT.PUT_LINE('Table T_RESTRICTION_TYPE_SPEC_REF created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_REF.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_REF.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_REF.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND column_name = 'FK_REF_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref ADD fk_ref_sequence NUMBER(1) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_REF.FK_REF_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND column_name = 'FK_REF_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref ADD fk_ref_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_REF.FK_REF_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND column_name = 'INCLUDE_OR_EXCLUDE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref ADD include_or_exclude CHAR(2) DEFAULT ''IN''';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_REF.INCLUDE_OR_EXCLUDE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND column_name = 'XF_TSP_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref ADD xf_tsp_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_REF.XF_TSP_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND column_name = 'XF_TSP_TSG_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref ADD xf_tsp_tsg_code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_REF.XF_TSP_TSG_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND column_name = 'XK_TSP_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref ADD xk_tsp_code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_REF.XK_TSP_CODE created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_RESTRICTION_TYPE_SPEC_REF.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_RESTRICTION_TYPE_SPEC_REF.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_RESTRICTION_TYPE_SPEC_TYP');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_restriction_type_spec_typ (
			cube_id VARCHAR2(16),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			include_or_exclude CHAR(2) DEFAULT ''IN'',
			xf_tsp_typ_name VARCHAR2(30),
			xf_tsp_tsg_code VARCHAR2(16),
			xk_tsp_code VARCHAR2(16))';
		DBMS_OUTPUT.PUT_LINE('Table T_RESTRICTION_TYPE_SPEC_TYP created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_TYP.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_TYP.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_TYP.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP' AND column_name = 'INCLUDE_OR_EXCLUDE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ ADD include_or_exclude CHAR(2) DEFAULT ''IN''';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_TYP.INCLUDE_OR_EXCLUDE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP' AND column_name = 'XF_TSP_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ ADD xf_tsp_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_TYP.XF_TSP_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP' AND column_name = 'XF_TSP_TSG_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ ADD xf_tsp_tsg_code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_TYP.XF_TSP_TSG_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP' AND column_name = 'XK_TSP_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ ADD xk_tsp_code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_RESTRICTION_TYPE_SPEC_TYP.XK_TSP_CODE created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_RESTRICTION_TYPE_SPEC_TYP.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_RESTRICTION_TYPE_SPEC_TYP.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_JSON_PATH');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_json_path (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			cube_level NUMBER(8) DEFAULT ''1'',
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			fk_jsn_name VARCHAR2(32),
			fk_jsn_location NUMBER(8) DEFAULT ''0'',
			cube_tsg_type VARCHAR2(8) DEFAULT ''OBJECT'',
			name VARCHAR2(32),
			location NUMBER(8) DEFAULT ''0'')';
		DBMS_OUTPUT.PUT_LINE('Table T_JSON_PATH created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH.CUBE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name = 'CUBE_LEVEL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD cube_level NUMBER(8) DEFAULT ''1''';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH.CUBE_LEVEL created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name = 'FK_JSN_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD fk_jsn_name VARCHAR2(32)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH.FK_JSN_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name = 'FK_JSN_LOCATION';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD fk_jsn_location NUMBER(8) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH.FK_JSN_LOCATION created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name = 'CUBE_TSG_TYPE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD cube_tsg_type VARCHAR2(8) DEFAULT ''OBJECT''';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH.CUBE_TSG_TYPE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD name VARCHAR2(32)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH.NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name = 'LOCATION';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD location NUMBER(8) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH.LOCATION created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_JSON_PATH.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_JSON_PATH.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_JSON_PATH_ATTRIBUTE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_json_path_attribute (
			cube_id VARCHAR2(16),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			fk_jsn_name VARCHAR2(32),
			fk_jsn_location NUMBER(8) DEFAULT ''0'',
			xf_atb_typ_name VARCHAR2(30),
			xk_atb_name VARCHAR2(30))';
		DBMS_OUTPUT.PUT_LINE('Table T_JSON_PATH_ATTRIBUTE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH_ATTRIBUTE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH_ATTRIBUTE.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH_ATTRIBUTE.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE' AND column_name = 'FK_JSN_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute ADD fk_jsn_name VARCHAR2(32)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH_ATTRIBUTE.FK_JSN_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE' AND column_name = 'FK_JSN_LOCATION';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute ADD fk_jsn_location NUMBER(8) DEFAULT ''0''';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH_ATTRIBUTE.FK_JSN_LOCATION created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE' AND column_name = 'XF_ATB_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute ADD xf_atb_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH_ATTRIBUTE.XF_ATB_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE' AND column_name = 'XK_ATB_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute ADD xk_atb_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_JSON_PATH_ATTRIBUTE.XK_ATB_NAME created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_JSON_PATH_ATTRIBUTE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_JSON_PATH_ATTRIBUTE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_TYPE_REUSE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_REUSE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_type_reuse (
			cube_id VARCHAR2(16),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			cardinality CHAR(1) DEFAULT ''N'',
			xk_typ_name VARCHAR2(30))';
		DBMS_OUTPUT.PUT_LINE('Table T_TYPE_REUSE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_REUSE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_reuse ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_REUSE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_REUSE' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_reuse ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_REUSE.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_REUSE' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_reuse ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_REUSE.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_REUSE' AND column_name = 'CARDINALITY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_reuse ADD cardinality CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_REUSE.CARDINALITY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_REUSE' AND column_name = 'XK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_reuse ADD xk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_REUSE.XK_TYP_NAME created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_REUSE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_reuse DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_TYPE_REUSE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_REUSE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_TYPE_REUSE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_PARTITION');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_PARTITION';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_partition (
			cube_id VARCHAR2(16),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			name VARCHAR2(30))';
		DBMS_OUTPUT.PUT_LINE('Table T_PARTITION created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PARTITION' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_partition ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_PARTITION.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PARTITION' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_partition ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_PARTITION.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PARTITION' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_partition ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_PARTITION.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PARTITION' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_partition ADD name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_PARTITION.NAME created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_PARTITION' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_partition DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_PARTITION.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_PARTITION')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_PARTITION.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_SUBTYPE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_subtype (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			fk_par_name VARCHAR2(30),
			name VARCHAR2(30))';
		DBMS_OUTPUT.PUT_LINE('Table T_SUBTYPE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_SUBTYPE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_SUBTYPE.CUBE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_SUBTYPE.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_SUBTYPE.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE' AND column_name = 'FK_PAR_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype ADD fk_par_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_SUBTYPE.FK_PAR_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype ADD name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_SUBTYPE.NAME created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_SUBTYPE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_SUBTYPE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_TYPE_SPECIALISATION_GROUP');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_type_specialisation_group (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			cube_level NUMBER(8) DEFAULT ''1'',
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			fk_tsg_code VARCHAR2(16),
			code VARCHAR2(16),
			name VARCHAR2(30),
			primary_key CHAR(1) DEFAULT ''N'',
			xf_atb_typ_name VARCHAR2(30),
			xk_atb_name VARCHAR2(30))';
		DBMS_OUTPUT.PUT_LINE('Table T_TYPE_SPECIALISATION_GROUP created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.CUBE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'CUBE_LEVEL';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD cube_level NUMBER(8) DEFAULT ''1''';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.CUBE_LEVEL created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'FK_TSG_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD fk_tsg_code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.FK_TSG_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'PRIMARY_KEY';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD primary_key CHAR(1) DEFAULT ''N''';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.PRIMARY_KEY created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'XF_ATB_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD xf_atb_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.XF_ATB_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name = 'XK_ATB_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD xk_atb_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION_GROUP.XK_ATB_NAME created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_TYPE_SPECIALISATION_GROUP.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_TYPE_SPECIALISATION_GROUP.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_TYPE_SPECIALISATION');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_type_specialisation (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			fk_tsg_code VARCHAR2(16),
			code VARCHAR2(16),
			name VARCHAR2(30),
			xf_tsp_typ_name VARCHAR2(30),
			xf_tsp_tsg_code VARCHAR2(16),
			xk_tsp_code VARCHAR2(16))';
		DBMS_OUTPUT.PUT_LINE('Table T_TYPE_SPECIALISATION created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION.CUBE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name = 'FK_TSG_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD fk_tsg_code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION.FK_TSG_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name = 'CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION.CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION.NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name = 'XF_TSP_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD xf_tsp_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION.XF_TSP_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name = 'XF_TSP_TSG_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD xf_tsp_tsg_code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION.XF_TSP_TSG_CODE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name = 'XK_TSP_CODE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD xk_tsp_code VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_TYPE_SPECIALISATION.XK_TSP_CODE created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_TYPE_SPECIALISATION.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_TYPE_SPECIALISATION.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_DESCRIPTION_TYPE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_TYPE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_description_type (
			cube_id VARCHAR2(16),
			fk_bot_name VARCHAR2(30),
			fk_typ_name VARCHAR2(30),
			text VARCHAR2(3999))';
		DBMS_OUTPUT.PUT_LINE('Table T_DESCRIPTION_TYPE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_TYPE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_type ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_TYPE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_TYPE' AND column_name = 'FK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_type ADD fk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_TYPE.FK_BOT_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_TYPE' AND column_name = 'FK_TYP_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_type ADD fk_typ_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_TYPE.FK_TYP_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_TYPE' AND column_name = 'TEXT';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_type ADD text VARCHAR2(3999)';
			DBMS_OUTPUT.PUT_LINE('Column T_DESCRIPTION_TYPE.TEXT created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_TYPE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_type DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_DESCRIPTION_TYPE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_TYPE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_DESCRIPTION_TYPE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_SYSTEM');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_system (
			cube_id VARCHAR2(16),
			name VARCHAR2(30),
			database VARCHAR2(30),
			schema VARCHAR2(30),
			password VARCHAR2(20))';
		DBMS_OUTPUT.PUT_LINE('Table T_SYSTEM created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_SYSTEM.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM' AND column_name = 'NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system ADD name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_SYSTEM.NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM' AND column_name = 'DATABASE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system ADD database VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_SYSTEM.DATABASE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM' AND column_name = 'SCHEMA';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system ADD schema VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_SYSTEM.SCHEMA created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM' AND column_name = 'PASSWORD';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system ADD password VARCHAR2(20)';
			DBMS_OUTPUT.PUT_LINE('Column T_SYSTEM.PASSWORD created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_SYSTEM.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_SYSTEM.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Prepare table T_SYSTEM_BO_TYPE');
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM_BO_TYPE';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_system_bo_type (
			cube_id VARCHAR2(16),
			cube_sequence NUMBER(8),
			fk_sys_name VARCHAR2(30),
			xk_bot_name VARCHAR2(30))';
		DBMS_OUTPUT.PUT_LINE('Table T_SYSTEM_BO_TYPE created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM_BO_TYPE' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system_bo_type ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_SYSTEM_BO_TYPE.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM_BO_TYPE' AND column_name = 'CUBE_SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system_bo_type ADD cube_sequence NUMBER(8)';
			DBMS_OUTPUT.PUT_LINE('Column T_SYSTEM_BO_TYPE.CUBE_SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM_BO_TYPE' AND column_name = 'FK_SYS_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system_bo_type ADD fk_sys_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_SYSTEM_BO_TYPE.FK_SYS_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM_BO_TYPE' AND column_name = 'XK_BOT_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system_bo_type ADD xk_bot_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_SYSTEM_BO_TYPE.XK_BOT_NAME created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM_BO_TYPE' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system_bo_type DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_SYSTEM_BO_TYPE.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM_BO_TYPE')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_SYSTEM_BO_TYPE.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
BEGIN
	FOR r_table IN (SELECT t.table_name FROM all_tables t, all_tab_comments c
				WHERE t.table_name = c.table_name
				  AND t.owner = 'CUBEROOT'
				  AND t.table_name NOT IN (
							'T_INFORMATION_TYPE',
							'T_INFORMATION_TYPE_ELEMENT',
							'T_PERMITTED_VALUE',
							'T_BUSINESS_OBJECT_TYPE',
							'T_TYPE',
							'T_ATTRIBUTE',
							'T_DERIVATION',
							'T_DESCRIPTION_ATTRIBUTE',
							'T_RESTRICTION_TYPE_SPEC_ATB',
							'T_REFERENCE',
							'T_DESCRIPTION_REFERENCE',
							'T_RESTRICTION_TYPE_SPEC_REF',
							'T_RESTRICTION_TYPE_SPEC_TYP',
							'T_JSON_PATH',
							'T_JSON_PATH_ATTRIBUTE',
							'T_TYPE_REUSE',
							'T_PARTITION',
							'T_SUBTYPE',
							'T_TYPE_SPECIALISATION_GROUP',
							'T_TYPE_SPECIALISATION',
							'T_DESCRIPTION_TYPE',
							'T_SYSTEM',
							'T_SYSTEM_BO_TYPE')
				  AND SUBSTR(t.table_name,1,7) <> 'T_CUBE_')
	LOOP
		EXECUTE IMMEDIATE
		'DROP TABLE ' || r_table.table_name || ' CASCADE CONSTRAINTS';
		DBMS_OUTPUT.PUT_LINE('Table ' || UPPER(r_table.table_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_INFORMATION_TYPE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'NAME','VARCHAR2(30)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'NAME',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_information_type SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_information_type SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_INFORMATION_TYPE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_INFORMATION_TYPE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_information_type ADD CONSTRAINT itp_pk
		PRIMARY KEY (
			name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_INFORMATION_TYPE.ITP_PK created');
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE' AND column_name NOT IN (
							'CUBE_ID',
							'NAME'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_information_type DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_INFORMATION_TYPE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_INFORMATION_TYPE_ELEMENT');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_ITP_NAME','VARCHAR2(30)',
			'SEQUENCE','NUMBER(8)',
			'SUFFIX','VARCHAR2(12)',
			'DOMAIN','VARCHAR2(16)',
			'LENGTH','NUMBER(8)',
			'DECIMALS','NUMBER(8)',
			'CASE_SENSITIVE','CHAR(1)',
			'DEFAULT_VALUE','VARCHAR2(32)',
			'SPACES_ALLOWED','CHAR(1)',
			'PRESENTATION','VARCHAR2(3)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_ITP_NAME',NULL,
			'SEQUENCE','''0''',
			'SUFFIX',NULL,
			'DOMAIN','''TEXT''',
			'LENGTH','''0''',
			'DECIMALS','''0''',
			'CASE_SENSITIVE','''N''',
			'DEFAULT_VALUE',NULL,
			'SPACES_ALLOWED','''N''',
			'PRESENTATION','''LIN''',NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_information_type_element SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_information_type_element SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_INFORMATION_TYPE_ELEMENT.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_information_type_element MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_INFORMATION_TYPE_ELEMENT.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_information_type_element ADD CONSTRAINT ite_pk
		PRIMARY KEY (
			fk_itp_name,
			sequence )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_INFORMATION_TYPE_ELEMENT.ITE_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_information_type_element ADD CONSTRAINT ite_itp_fk
		FOREIGN KEY (fk_itp_name)
		REFERENCES t_information_type (name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_INFORMATION_TYPE_ELEMENT' AND column_name NOT IN (
							'CUBE_ID',
							'FK_ITP_NAME',
							'SEQUENCE',
							'SUFFIX',
							'DOMAIN',
							'LENGTH',
							'DECIMALS',
							'CASE_SENSITIVE',
							'DEFAULT_VALUE',
							'SPACES_ALLOWED',
							'PRESENTATION'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_information_type_element DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_INFORMATION_TYPE_ELEMENT.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_PERMITTED_VALUE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'FK_ITP_NAME','VARCHAR2(30)',
			'FK_ITE_SEQUENCE','NUMBER(8)',
			'CODE','VARCHAR2(16)',
			'PROMPT','VARCHAR2(32)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'FK_ITP_NAME',NULL,
			'FK_ITE_SEQUENCE','''0''',
			'CODE',NULL,
			'PROMPT',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_permitted_value SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_permitted_value SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_PERMITTED_VALUE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_permitted_value MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_PERMITTED_VALUE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_permitted_value ADD CONSTRAINT val_pk
		PRIMARY KEY (
			fk_itp_name,
			fk_ite_sequence,
			code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_PERMITTED_VALUE.VAL_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_permitted_value ADD CONSTRAINT val_ite_fk
		FOREIGN KEY (fk_itp_name, fk_ite_sequence)
		REFERENCES t_information_type_element (fk_itp_name, sequence)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PERMITTED_VALUE' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'FK_ITP_NAME',
							'FK_ITE_SEQUENCE',
							'CODE',
							'PROMPT'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_permitted_value DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_PERMITTED_VALUE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_BUSINESS_OBJECT_TYPE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'NAME','VARCHAR2(30)',
			'CUBE_TSG_TYPE','VARCHAR2(8)',
			'DIRECTORY','VARCHAR2(80)',
			'API_URL','VARCHAR2(300)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'NAME',NULL,
			'CUBE_TSG_TYPE','''INT''',
			'DIRECTORY',NULL,
			'API_URL',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_business_object_type SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_business_object_type SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_BUSINESS_OBJECT_TYPE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_business_object_type MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_BUSINESS_OBJECT_TYPE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_business_object_type ADD CONSTRAINT bot_pk
		PRIMARY KEY (
			name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_BUSINESS_OBJECT_TYPE.BOT_PK created');
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_BUSINESS_OBJECT_TYPE' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'NAME',
							'CUBE_TSG_TYPE',
							'DIRECTORY',
							'API_URL'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_business_object_type DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_BUSINESS_OBJECT_TYPE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_TYPE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'CUBE_LEVEL','NUMBER(8)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'NAME','VARCHAR2(30)',
			'CODE','VARCHAR2(3)',
			'FLAG_PARTIAL_KEY','CHAR(1)',
			'FLAG_RECURSIVE','CHAR(1)',
			'RECURSIVE_CARDINALITY','CHAR(1)',
			'CARDINALITY','CHAR(1)',
			'SORT_ORDER','CHAR(1)',
			'ICON','VARCHAR2(8)',
			'TRANSFERABLE','CHAR(1)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'CUBE_LEVEL','''1''',
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'NAME',NULL,
			'CODE',NULL,
			'FLAG_PARTIAL_KEY','''Y''',
			'FLAG_RECURSIVE','''N''',
			'RECURSIVE_CARDINALITY','''N''',
			'CARDINALITY','''N''',
			'SORT_ORDER','''N''',
			'ICON',NULL,
			'TRANSFERABLE','''Y''',NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_type SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_type SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_TYPE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_TYPE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type ADD CONSTRAINT typ_pk
		PRIMARY KEY (
			name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_TYPE.TYP_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type ADD CONSTRAINT typ_bot_fk
		FOREIGN KEY (fk_bot_name)
		REFERENCES t_business_object_type (name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type ADD CONSTRAINT typ_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'CUBE_LEVEL',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'NAME',
							'CODE',
							'FLAG_PARTIAL_KEY',
							'FLAG_RECURSIVE',
							'RECURSIVE_CARDINALITY',
							'CARDINALITY',
							'SORT_ORDER',
							'ICON',
							'TRANSFERABLE'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_type DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_TYPE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_ATTRIBUTE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'NAME','VARCHAR2(30)',
			'PRIMARY_KEY','CHAR(1)',
			'CODE_DISPLAY_KEY','CHAR(1)',
			'CODE_FOREIGN_KEY','CHAR(1)',
			'FLAG_HIDDEN','CHAR(1)',
			'DEFAULT_VALUE','VARCHAR2(40)',
			'UNCHANGEABLE','CHAR(1)',
			'XK_ITP_NAME','VARCHAR2(30)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'NAME',NULL,
			'PRIMARY_KEY','''N''',
			'CODE_DISPLAY_KEY','''N''',
			'CODE_FOREIGN_KEY','''N''',
			'FLAG_HIDDEN','''N''',
			'DEFAULT_VALUE',NULL,
			'UNCHANGEABLE','''N''',
			'XK_ITP_NAME',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_attribute SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_attribute SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_ATTRIBUTE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_attribute MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_ATTRIBUTE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_attribute ADD CONSTRAINT atb_pk
		PRIMARY KEY (
			fk_typ_name,
			name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_ATTRIBUTE.ATB_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_attribute ADD CONSTRAINT atb_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_ATTRIBUTE' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'NAME',
							'PRIMARY_KEY',
							'CODE_DISPLAY_KEY',
							'CODE_FOREIGN_KEY',
							'FLAG_HIDDEN',
							'DEFAULT_VALUE',
							'UNCHANGEABLE',
							'XK_ITP_NAME'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_attribute DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_ATTRIBUTE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_DERIVATION');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'FK_ATB_NAME','VARCHAR2(30)',
			'CUBE_TSG_TYPE','VARCHAR2(8)',
			'AGGREGATE_FUNCTION','VARCHAR2(3)',
			'XK_TYP_NAME','VARCHAR2(30)',
			'XK_TYP_NAME_1','VARCHAR2(30)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'FK_ATB_NAME',NULL,
			'CUBE_TSG_TYPE','''DN''',
			'AGGREGATE_FUNCTION','''SUM''',
			'XK_TYP_NAME',NULL,
			'XK_TYP_NAME_1',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_derivation SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_derivation SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_DERIVATION.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_derivation MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_DERIVATION.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_derivation ADD CONSTRAINT der_pk
		PRIMARY KEY (
			fk_typ_name,
			fk_atb_name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_DERIVATION.DER_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_derivation ADD CONSTRAINT der_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DERIVATION' AND column_name NOT IN (
							'CUBE_ID',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'FK_ATB_NAME',
							'CUBE_TSG_TYPE',
							'AGGREGATE_FUNCTION',
							'XK_TYP_NAME',
							'XK_TYP_NAME_1'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_derivation DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_DERIVATION.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_DESCRIPTION_ATTRIBUTE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'FK_ATB_NAME','VARCHAR2(30)',
			'TEXT','VARCHAR2(3999)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'FK_ATB_NAME',NULL,
			'TEXT',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_ATTRIBUTE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_attribute RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_attribute ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_description_attribute SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_description_attribute SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_attribute DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_DESCRIPTION_ATTRIBUTE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_attribute MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_DESCRIPTION_ATTRIBUTE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_description_attribute ADD CONSTRAINT dca_pk
		PRIMARY KEY (
			fk_typ_name,
			fk_atb_name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_DESCRIPTION_ATTRIBUTE.DCA_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_description_attribute ADD CONSTRAINT dca_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_ATTRIBUTE' AND column_name NOT IN (
							'CUBE_ID',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'FK_ATB_NAME',
							'TEXT'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_description_attribute DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_DESCRIPTION_ATTRIBUTE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_RESTRICTION_TYPE_SPEC_ATB');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'FK_ATB_NAME','VARCHAR2(30)',
			'INCLUDE_OR_EXCLUDE','CHAR(2)',
			'XF_TSP_TYP_NAME','VARCHAR2(30)',
			'XF_TSP_TSG_CODE','VARCHAR2(16)',
			'XK_TSP_CODE','VARCHAR2(16)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'FK_ATB_NAME',NULL,
			'INCLUDE_OR_EXCLUDE','''IN''',
			'XF_TSP_TYP_NAME',NULL,
			'XF_TSP_TSG_CODE',NULL,
			'XK_TSP_CODE',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_restriction_type_spec_atb SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_restriction_type_spec_atb SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_RESTRICTION_TYPE_SPEC_ATB.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_atb MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_RESTRICTION_TYPE_SPEC_ATB.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_atb ADD CONSTRAINT rta_pk
		PRIMARY KEY (
			fk_typ_name,
			fk_atb_name,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_RESTRICTION_TYPE_SPEC_ATB.RTA_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_atb ADD CONSTRAINT rta_atb_fk
		FOREIGN KEY (fk_typ_name, fk_atb_name)
		REFERENCES t_attribute (fk_typ_name, name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_ATB' AND column_name NOT IN (
							'CUBE_ID',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'FK_ATB_NAME',
							'INCLUDE_OR_EXCLUDE',
							'XF_TSP_TYP_NAME',
							'XF_TSP_TSG_CODE',
							'XK_TSP_CODE'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_restriction_type_spec_atb DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_RESTRICTION_TYPE_SPEC_ATB.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_REFERENCE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'NAME','VARCHAR2(30)',
			'PRIMARY_KEY','CHAR(1)',
			'CODE_DISPLAY_KEY','CHAR(1)',
			'SEQUENCE','NUMBER(1)',
			'SCOPE','VARCHAR2(3)',
			'UNCHANGEABLE','CHAR(1)',
			'WITHIN_SCOPE_LEVEL','NUMBER(1)',
			'XK_TYP_NAME','VARCHAR2(30)',
			'XK_TYP_NAME_1','VARCHAR2(30)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'NAME',NULL,
			'PRIMARY_KEY','''N''',
			'CODE_DISPLAY_KEY','''N''',
			'SEQUENCE','''0''',
			'SCOPE','''ALL''',
			'UNCHANGEABLE','''N''',
			'WITHIN_SCOPE_LEVEL','''0''',
			'XK_TYP_NAME',NULL,
			'XK_TYP_NAME_1',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_reference SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_reference SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_REFERENCE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_reference MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_REFERENCE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_reference ADD CONSTRAINT ref_pk
		PRIMARY KEY (
			fk_typ_name,
			sequence,
			xk_typ_name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_REFERENCE.REF_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_reference ADD CONSTRAINT ref_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_REFERENCE' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'NAME',
							'PRIMARY_KEY',
							'CODE_DISPLAY_KEY',
							'SEQUENCE',
							'SCOPE',
							'UNCHANGEABLE',
							'WITHIN_SCOPE_LEVEL',
							'XK_TYP_NAME',
							'XK_TYP_NAME_1'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_reference DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_REFERENCE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_DESCRIPTION_REFERENCE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'FK_REF_SEQUENCE','NUMBER(1)',
			'FK_REF_TYP_NAME','VARCHAR2(30)',
			'TEXT','VARCHAR2(3999)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'FK_REF_SEQUENCE','''0''',
			'FK_REF_TYP_NAME',NULL,
			'TEXT',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_description_reference SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_description_reference SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_DESCRIPTION_REFERENCE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_reference MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_DESCRIPTION_REFERENCE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_description_reference ADD CONSTRAINT dcr_pk
		PRIMARY KEY (
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_typ_name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_DESCRIPTION_REFERENCE.DCR_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_description_reference ADD CONSTRAINT dcr_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_typ_name)
		REFERENCES t_reference (fk_typ_name, sequence, xk_typ_name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_REFERENCE' AND column_name NOT IN (
							'CUBE_ID',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'FK_REF_SEQUENCE',
							'FK_REF_TYP_NAME',
							'TEXT'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_description_reference DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_DESCRIPTION_REFERENCE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_RESTRICTION_TYPE_SPEC_REF');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'FK_REF_SEQUENCE','NUMBER(1)',
			'FK_REF_TYP_NAME','VARCHAR2(30)',
			'INCLUDE_OR_EXCLUDE','CHAR(2)',
			'XF_TSP_TYP_NAME','VARCHAR2(30)',
			'XF_TSP_TSG_CODE','VARCHAR2(16)',
			'XK_TSP_CODE','VARCHAR2(16)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'FK_REF_SEQUENCE','''0''',
			'FK_REF_TYP_NAME',NULL,
			'INCLUDE_OR_EXCLUDE','''IN''',
			'XF_TSP_TYP_NAME',NULL,
			'XF_TSP_TSG_CODE',NULL,
			'XK_TSP_CODE',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_restriction_type_spec_ref SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_restriction_type_spec_ref SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_RESTRICTION_TYPE_SPEC_REF.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_ref MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_RESTRICTION_TYPE_SPEC_REF.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_ref ADD CONSTRAINT rtr_pk
		PRIMARY KEY (
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_typ_name,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_RESTRICTION_TYPE_SPEC_REF.RTR_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_ref ADD CONSTRAINT rtr_ref_fk
		FOREIGN KEY (fk_typ_name, fk_ref_sequence, fk_ref_typ_name)
		REFERENCES t_reference (fk_typ_name, sequence, xk_typ_name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_REF' AND column_name NOT IN (
							'CUBE_ID',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'FK_REF_SEQUENCE',
							'FK_REF_TYP_NAME',
							'INCLUDE_OR_EXCLUDE',
							'XF_TSP_TYP_NAME',
							'XF_TSP_TSG_CODE',
							'XK_TSP_CODE'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_restriction_type_spec_ref DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_RESTRICTION_TYPE_SPEC_REF.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_RESTRICTION_TYPE_SPEC_TYP');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'INCLUDE_OR_EXCLUDE','CHAR(2)',
			'XF_TSP_TYP_NAME','VARCHAR2(30)',
			'XF_TSP_TSG_CODE','VARCHAR2(16)',
			'XK_TSP_CODE','VARCHAR2(16)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'INCLUDE_OR_EXCLUDE','''IN''',
			'XF_TSP_TYP_NAME',NULL,
			'XF_TSP_TSG_CODE',NULL,
			'XK_TSP_CODE',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_restriction_type_spec_typ SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_restriction_type_spec_typ SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_RESTRICTION_TYPE_SPEC_TYP.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_restriction_type_spec_typ MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_RESTRICTION_TYPE_SPEC_TYP.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_typ ADD CONSTRAINT rtt_pk
		PRIMARY KEY (
			fk_typ_name,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_RESTRICTION_TYPE_SPEC_TYP.RTT_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_restriction_type_spec_typ ADD CONSTRAINT rtt_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_RESTRICTION_TYPE_SPEC_TYP' AND column_name NOT IN (
							'CUBE_ID',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'INCLUDE_OR_EXCLUDE',
							'XF_TSP_TYP_NAME',
							'XF_TSP_TSG_CODE',
							'XK_TSP_CODE'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_restriction_type_spec_typ DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_RESTRICTION_TYPE_SPEC_TYP.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_JSON_PATH');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'CUBE_LEVEL','NUMBER(8)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'FK_JSN_NAME','VARCHAR2(32)',
			'FK_JSN_LOCATION','NUMBER(8)',
			'CUBE_TSG_TYPE','VARCHAR2(8)',
			'NAME','VARCHAR2(32)',
			'LOCATION','NUMBER(8)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'CUBE_LEVEL','''1''',
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'FK_JSN_NAME',NULL,
			'FK_JSN_LOCATION','''0''',
			'CUBE_TSG_TYPE','''OBJECT''',
			'NAME',NULL,
			'LOCATION','''0''',NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_json_path SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_json_path SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_JSON_PATH.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_JSON_PATH.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_json_path ADD CONSTRAINT jsn_pk
		PRIMARY KEY (
			fk_typ_name,
			name,
			location )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_JSON_PATH.JSN_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_json_path ADD CONSTRAINT jsn_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_json_path ADD CONSTRAINT jsn_jsn_fk
		FOREIGN KEY (fk_typ_name, fk_jsn_name, fk_jsn_location)
		REFERENCES t_json_path (fk_typ_name, name, location)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'CUBE_LEVEL',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'FK_JSN_NAME',
							'FK_JSN_LOCATION',
							'CUBE_TSG_TYPE',
							'NAME',
							'LOCATION'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_json_path DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_JSON_PATH.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_JSON_PATH_ATTRIBUTE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'FK_JSN_NAME','VARCHAR2(32)',
			'FK_JSN_LOCATION','NUMBER(8)',
			'XF_ATB_TYP_NAME','VARCHAR2(30)',
			'XK_ATB_NAME','VARCHAR2(30)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'FK_JSN_NAME',NULL,
			'FK_JSN_LOCATION','''0''',
			'XF_ATB_TYP_NAME',NULL,
			'XK_ATB_NAME',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_json_path_attribute SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_json_path_attribute SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_JSON_PATH_ATTRIBUTE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_json_path_attribute MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_JSON_PATH_ATTRIBUTE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_json_path_attribute ADD CONSTRAINT jpa_pk
		PRIMARY KEY (
			fk_typ_name,
			fk_jsn_name,
			fk_jsn_location,
			xf_atb_typ_name,
			xk_atb_name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_JSON_PATH_ATTRIBUTE.JPA_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_json_path_attribute ADD CONSTRAINT jpa_jsn_fk
		FOREIGN KEY (fk_typ_name, fk_jsn_name, fk_jsn_location)
		REFERENCES t_json_path (fk_typ_name, name, location)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_JSON_PATH_ATTRIBUTE' AND column_name NOT IN (
							'CUBE_ID',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'FK_JSN_NAME',
							'FK_JSN_LOCATION',
							'XF_ATB_TYP_NAME',
							'XK_ATB_NAME'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_json_path_attribute DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_JSON_PATH_ATTRIBUTE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_TYPE_REUSE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'CARDINALITY','CHAR(1)',
			'XK_TYP_NAME','VARCHAR2(30)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'CARDINALITY','''N''',
			'XK_TYP_NAME',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_REUSE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_reuse RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_reuse ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_type_reuse SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_type_reuse SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_reuse DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_TYPE_REUSE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_reuse MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_TYPE_REUSE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_reuse ADD CONSTRAINT tyr_pk
		PRIMARY KEY (
			fk_typ_name,
			xk_typ_name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_TYPE_REUSE.TYR_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_reuse ADD CONSTRAINT tyr_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_REUSE' AND column_name NOT IN (
							'CUBE_ID',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'CARDINALITY',
							'XK_TYP_NAME'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_type_reuse DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_TYPE_REUSE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_PARTITION');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'NAME','VARCHAR2(30)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'NAME',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PARTITION')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_partition RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_partition ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_partition SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_partition SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_partition DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_PARTITION.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_partition MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_PARTITION.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_partition ADD CONSTRAINT par_pk
		PRIMARY KEY (
			fk_typ_name,
			name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_PARTITION.PAR_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_partition ADD CONSTRAINT par_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_PARTITION' AND column_name NOT IN (
							'CUBE_ID',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'NAME'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_partition DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_PARTITION.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_SUBTYPE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'FK_PAR_NAME','VARCHAR2(30)',
			'NAME','VARCHAR2(30)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'FK_PAR_NAME',NULL,
			'NAME',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_subtype SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_subtype SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_SUBTYPE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_subtype MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_SUBTYPE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_subtype ADD CONSTRAINT stp_pk
		PRIMARY KEY (
			fk_typ_name,
			fk_par_name,
			name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_SUBTYPE.STP_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_subtype ADD CONSTRAINT stp_par_fk
		FOREIGN KEY (fk_typ_name, fk_par_name)
		REFERENCES t_partition (fk_typ_name, name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SUBTYPE' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'FK_PAR_NAME',
							'NAME'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_subtype DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_SUBTYPE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_TYPE_SPECIALISATION_GROUP');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'CUBE_LEVEL','NUMBER(8)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'FK_TSG_CODE','VARCHAR2(16)',
			'CODE','VARCHAR2(16)',
			'NAME','VARCHAR2(30)',
			'PRIMARY_KEY','CHAR(1)',
			'XF_ATB_TYP_NAME','VARCHAR2(30)',
			'XK_ATB_NAME','VARCHAR2(30)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'CUBE_LEVEL','''1''',
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'FK_TSG_CODE',NULL,
			'CODE',NULL,
			'NAME',NULL,
			'PRIMARY_KEY','''N''',
			'XF_ATB_TYP_NAME',NULL,
			'XK_ATB_NAME',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_type_specialisation_group SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_type_specialisation_group SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_TYPE_SPECIALISATION_GROUP.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation_group MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_TYPE_SPECIALISATION_GROUP.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_specialisation_group ADD CONSTRAINT tsg_pk
		PRIMARY KEY (
			fk_typ_name,
			code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_TYPE_SPECIALISATION_GROUP.TSG_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_specialisation_group ADD CONSTRAINT tsg_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_specialisation_group ADD CONSTRAINT tsg_tsg_fk
		FOREIGN KEY (fk_typ_name, fk_tsg_code)
		REFERENCES t_type_specialisation_group (fk_typ_name, code)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION_GROUP' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'CUBE_LEVEL',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'FK_TSG_CODE',
							'CODE',
							'NAME',
							'PRIMARY_KEY',
							'XF_ATB_TYP_NAME',
							'XK_ATB_NAME'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_type_specialisation_group DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_TYPE_SPECIALISATION_GROUP.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_TYPE_SPECIALISATION');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'FK_TSG_CODE','VARCHAR2(16)',
			'CODE','VARCHAR2(16)',
			'NAME','VARCHAR2(30)',
			'XF_TSP_TYP_NAME','VARCHAR2(30)',
			'XF_TSP_TSG_CODE','VARCHAR2(16)',
			'XK_TSP_CODE','VARCHAR2(16)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'FK_TSG_CODE',NULL,
			'CODE',NULL,
			'NAME',NULL,
			'XF_TSP_TYP_NAME',NULL,
			'XF_TSP_TSG_CODE',NULL,
			'XK_TSP_CODE',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_type_specialisation SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_type_specialisation SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_TYPE_SPECIALISATION.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_type_specialisation MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_TYPE_SPECIALISATION.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_specialisation ADD CONSTRAINT tsp_pk
		PRIMARY KEY (
			fk_typ_name,
			fk_tsg_code,
			code )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_TYPE_SPECIALISATION.TSP_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_type_specialisation ADD CONSTRAINT tsp_tsg_fk
		FOREIGN KEY (fk_typ_name, fk_tsg_code)
		REFERENCES t_type_specialisation_group (fk_typ_name, code)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_TYPE_SPECIALISATION' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'FK_TSG_CODE',
							'CODE',
							'NAME',
							'XF_TSP_TYP_NAME',
							'XF_TSP_TSG_CODE',
							'XK_TSP_CODE'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_type_specialisation DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_TYPE_SPECIALISATION.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_DESCRIPTION_TYPE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'FK_BOT_NAME','VARCHAR2(30)',
			'FK_TYP_NAME','VARCHAR2(30)',
			'TEXT','VARCHAR2(3999)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'FK_BOT_NAME',NULL,
			'FK_TYP_NAME',NULL,
			'TEXT',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_TYPE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_type RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_type ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_description_type SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_description_type SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_type DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_DESCRIPTION_TYPE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_description_type MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_DESCRIPTION_TYPE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_description_type ADD CONSTRAINT dct_pk
		PRIMARY KEY (
			fk_typ_name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_DESCRIPTION_TYPE.DCT_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_description_type ADD CONSTRAINT dct_typ_fk
		FOREIGN KEY (fk_typ_name)
		REFERENCES t_type (name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_DESCRIPTION_TYPE' AND column_name NOT IN (
							'CUBE_ID',
							'FK_BOT_NAME',
							'FK_TYP_NAME',
							'TEXT'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_description_type DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_DESCRIPTION_TYPE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_SYSTEM');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'NAME','VARCHAR2(30)',
			'DATABASE','VARCHAR2(30)',
			'SCHEMA','VARCHAR2(30)',
			'PASSWORD','VARCHAR2(20)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'NAME',NULL,
			'DATABASE',NULL,
			'SCHEMA',NULL,
			'PASSWORD',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_system SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_system SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_SYSTEM.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_SYSTEM.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_system ADD CONSTRAINT sys_pk
		PRIMARY KEY (
			name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_SYSTEM.SYS_PK created');
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM' AND column_name NOT IN (
							'CUBE_ID',
							'NAME',
							'DATABASE',
							'SCHEMA',
							'PASSWORD'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_system DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_SYSTEM.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Maintain table T_SYSTEM_BO_TYPE');
	FOR r_field IN (SELECT column_name,
		data_type || DECODE (data_type,'VARCHAR2','('||char_length||')','NUMBER','('||data_precision||DECODE(data_scale,0,'',','||data_scale)||')','CHAR','('||char_length||')','') old_domain,
		data_default old_default_value,
  		DECODE(column_name,
			'CUBE_ID','VARCHAR2(16)',
			'CUBE_SEQUENCE','NUMBER(8)',
			'FK_SYS_NAME','VARCHAR2(30)',
			'XK_BOT_NAME','VARCHAR2(30)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'CUBE_SEQUENCE',NULL,
			'FK_SYS_NAME',NULL,
			'XK_BOT_NAME',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM_BO_TYPE')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system_bo_type RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system_bo_type ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_system_bo_type SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_system_bo_type SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system_bo_type DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_SYSTEM_BO_TYPE.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_system_bo_type MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_SYSTEM_BO_TYPE.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_system_bo_type ADD CONSTRAINT sbt_pk
		PRIMARY KEY (
			fk_sys_name,
			xk_bot_name )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_SYSTEM_BO_TYPE.SBT_PK created');
	EXECUTE IMMEDIATE
	'ALTER TABLE t_system_bo_type ADD CONSTRAINT sbt_sys_fk
		FOREIGN KEY (fk_sys_name)
		REFERENCES t_system (name)
		ON DELETE CASCADE';
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = 'CUBEROOT' AND table_name = 'T_SYSTEM_BO_TYPE' AND column_name NOT IN (
							'CUBE_ID',
							'CUBE_SEQUENCE',
							'FK_SYS_NAME',
							'XK_BOT_NAME'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_system_bo_type DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_SYSTEM_BO_TYPE.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
EXIT;
