
-- TABLE DDL
--
BEGIN
	FOR r_s IN (
		SELECT sequence_name FROM user_sequences
		WHERE SUBSTR(sequence_name,1,INSTR(sequence_name,'_',4)) = 'SQ_CUBE_')
	LOOP
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||r_s.sequence_name;
	END LOOP;

	FOR r_c IN (
		SELECT table_name, constraint_name
		FROM user_constraints
		WHERE constraint_type = 'R'
		  AND TABLE_NAME IN (
			SELECT table_name 
			FROM user_tables
			WHERE SUBSTR(table_name,1,INSTR(table_name,'_',3)) = 'T_CUBE_'))
	LOOP
		EXECUTE IMMEDIATE 'ALTER TABLE '||r_c.table_name||' DROP CONSTRAINT '||r_c.constraint_name;
	END LOOP;
	
	FOR r_t IN (
			SELECT table_name 
			FROM user_tables
		WHERE SUBSTR(table_name,1,INSTR(table_name,'_',3)) = 'T_CUBE_')
	LOOP
		EXECUTE IMMEDIATE 'DROP TABLE '||r_t.table_name;
	END LOOP;
END;
/
CREATE SEQUENCE sq_cube_dsc START WITH 100000
/
CREATE TABLE t_cube_description (
	cube_id VARCHAR2(16),
	type_name VARCHAR2(30),
	attribute_type_name VARCHAR2(30) DEFAULT '_',
	sequence NUMBER(1) DEFAULT '-1',
	value VARCHAR2(3999),
	CONSTRAINT cube_dsc_pk
		PRIMARY KEY (type_name, attribute_type_name, sequence) )
/
EXIT;
