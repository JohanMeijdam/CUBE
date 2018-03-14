-- ALTER TABLE DDL
--
SET SERVEROUTPUT ON;
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_sequences WHERE sequence_owner = '' AND sequence_name = 'CUBE_DSC_SEQ';
	IF l_count = 0 THEN

		EXECUTE IMMEDIATE 
		'CREATE SEQUENCE cube_dsc_seq START WITH 100000';
		DBMS_OUTPUT.PUT_LINE('Sequence CUBE_DSC_SEQ created');

	END IF;
END;
/
DECLARE
	l_count NUMBER(4);
BEGIN
	SELECT COUNT(1) INTO l_count FROM all_tables WHERE owner = '' AND table_name = 'T_CUBE_DESCRIPTION';
	IF l_count = 0 THEN
		EXECUTE IMMEDIATE
		'CREATE TABLE t_cube_description (
			cube_id VARCHAR2(16),
			type_name VARCHAR2(30),
			attribute_type_name VARCHAR2(30) DEFAULT ''_'',
			sequence NUMBER(1) DEFAULT ''-1'',
			value VARCHAR2(3999))';
		DBMS_OUTPUT.PUT_LINE('Table T_CUBE_DESCRIPTION created');
	ELSE

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = '' AND table_name = 'T_CUBE_DESCRIPTION' AND column_name = 'CUBE_ID';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_cube_description ADD cube_id VARCHAR2(16)';
			DBMS_OUTPUT.PUT_LINE('Column T_CUBE_DESCRIPTION.CUBE_ID created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = '' AND table_name = 'T_CUBE_DESCRIPTION' AND column_name = 'TYPE_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_cube_description ADD type_name VARCHAR2(30)';
			DBMS_OUTPUT.PUT_LINE('Column T_CUBE_DESCRIPTION.TYPE_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = '' AND table_name = 'T_CUBE_DESCRIPTION' AND column_name = 'ATTRIBUTE_TYPE_NAME';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_cube_description ADD attribute_type_name VARCHAR2(30) DEFAULT ''_''';
			DBMS_OUTPUT.PUT_LINE('Column T_CUBE_DESCRIPTION.ATTRIBUTE_TYPE_NAME created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = '' AND table_name = 'T_CUBE_DESCRIPTION' AND column_name = 'SEQUENCE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_cube_description ADD sequence NUMBER(1) DEFAULT ''-1''';
			DBMS_OUTPUT.PUT_LINE('Column T_CUBE_DESCRIPTION.SEQUENCE created');
		END IF;

		SELECT COUNT(1) INTO l_count FROM all_tab_columns WHERE owner = '' AND table_name = 'T_CUBE_DESCRIPTION' AND column_name = 'VALUE';
		IF l_count = 0 THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_cube_description ADD value VARCHAR2(3999)';
			DBMS_OUTPUT.PUT_LINE('Column T_CUBE_DESCRIPTION.VALUE created');
		END IF;

		FOR r_key IN (SELECT constraint_name FROM all_constraints WHERE owner = '' AND table_name = 'T_CUBE_DESCRIPTION' AND constraint_type IN ('P','U','R') ORDER BY constraint_type DESC)
		LOOP
			EXECUTE IMMEDIATE
			'ALTER TABLE t_cube_description DROP CONSTRAINT ' || r_key.constraint_name || ' CASCADE';
			DBMS_OUTPUT.PUT_LINE('Primary Key T_CUBE_DESCRIPTION.' || UPPER(r_key.constraint_name) || ' dropped');
		END LOOP;

		FOR r_index IN (SELECT index_name FROM all_indexes WHERE owner = '' AND table_name = 'T_CUBE_DESCRIPTION')
		LOOP
			EXECUTE IMMEDIATE
			'DROP INDEX ' || r_index.index_name;
			DBMS_OUTPUT.PUT_LINE('Index T_CUBE_DESCRIPTION.' || UPPER(r_index.index_name) || ' dropped');
		END LOOP;
	END IF;
END;
/
BEGIN
	FOR r_table IN (SELECT t.table_name FROM all_tables t, all_tab_comments c
				WHERE t.table_name = c.table_name
				  AND t.owner = ''
				  AND t.table_name NOT IN (
							'T_CUBE_DESCRIPTION')
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
			'TYPE_NAME','VARCHAR2(30)',
			'ATTRIBUTE_TYPE_NAME','VARCHAR2(30)',
			'SEQUENCE','NUMBER(1)',
			'VALUE','VARCHAR2(3999)',NULL) new_domain,
		DECODE(column_name,
			'CUBE_ID',NULL,
			'TYPE_NAME',NULL,
			'ATTRIBUTE_TYPE_NAME','''_''',
			'SEQUENCE','''-1''',
			'VALUE',NULL,NULL) new_default_value
  		FROM all_tab_columns WHERE owner = '' AND table_name = 'T_CUBE_DESCRIPTION')
	LOOP
		IF r_field.old_domain <> r_field.new_domain THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_cube_description RENAME COLUMN ' || r_field.column_name || ' TO old#domain#field';
			EXECUTE IMMEDIATE
			'ALTER TABLE t_cube_description ADD ' || r_field.column_name || ' ' || r_field.new_domain;
 			IF r_field.new_domain = 'VARCHAR2' THEN  
				EXECUTE IMMEDIATE
				'UPDATE t_cube_description SET ' || r_field.column_name || '= TRIM(old#domain#field)';
			ELSE
				EXECUTE IMMEDIATE
				'UPDATE t_cube_description SET ' || r_field.column_name || '= old#domain#field';
			END IF;
			EXECUTE IMMEDIATE
			'ALTER TABLE t_cube_description DROP COLUMN old#domain#field';
			DBMS_OUTPUT.PUT_LINE('Field T_CUBE_DESCRIPTION.' || UPPER(r_field.column_name) || ' converted from ' || r_field.old_domain || ' to ' || r_field.new_domain);
		END IF;
		IF NOT((r_field.old_default_value IS NULL AND r_field.new_default_value IS NULL) OR r_field.old_default_value = r_field.new_default_value) THEN
			EXECUTE IMMEDIATE
			'ALTER TABLE t_cube_description MODIFY (' || r_field.column_name || ' DEFAULT ' || NVL(r_field.new_default_value,'NULL') || ')';
			DBMS_OUTPUT.PUT_LINE('Field T_CUBE_DESCRIPTION.' || UPPER(r_field.column_name) || ' default value set to ' || NVL(r_field.new_default_value,'NULL'));
		END IF;
	END LOOP;
	EXECUTE IMMEDIATE
	'ALTER TABLE t_cube_description ADD CONSTRAINT cube_dsc_pk
		PRIMARY KEY (
			type_name,
			attribute_type_name,
			sequence )';
	DBMS_OUTPUT.PUT_LINE('Primary Key T_CUBE_DESCRIPTION.CUBE_DSC_PK created');
	FOR r_field IN (SELECT column_name FROM all_tab_columns WHERE owner = '' AND table_name = 'T_CUBE_DESCRIPTION' AND column_name NOT IN (
							'CUBE_ID',
							'TYPE_NAME',
							'ATTRIBUTE_TYPE_NAME',
							'SEQUENCE',
							'VALUE'))
	LOOP
		EXECUTE IMMEDIATE
		'ALTER TABLE t_cube_description DROP COLUMN ' || r_field.column_name;
		DBMS_OUTPUT.PUT_LINE('Field T_CUBE_DESCRIPTION.' || UPPER(r_field.column_name) || ' dropped');
	END LOOP;
END;
/
EXIT;
