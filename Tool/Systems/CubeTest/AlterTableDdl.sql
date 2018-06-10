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
BEGIN
	FOR r_table IN (SELECT t.table_name FROM all_tables t, all_tab_comments c
				WHERE t.table_name = c.table_name
				  AND t.owner = 'CUBETEST'
				  AND t.table_name NOT IN (
							'T_AAA',
							'T_BBB')
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
EXIT;
