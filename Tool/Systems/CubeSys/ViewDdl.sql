-- DB VIEW DDL
--
BEGIN
	FOR r_v IN (
		SELECT view_name 
		FROM user_views
		WHERE SUBSTR(view_name,1,INSTR(view_name,'_',3)) = 'V_CUBE_')
	LOOP
		EXECUTE IMMEDIATE 'DROP VIEW '||r_v.view_name;
	END LOOP;
	
	FOR r_p IN (
		SELECT object_name
		FROM user_procedures
		WHERE procedure_name = 'CUBE_TRG_CUBESYS' )
	LOOP
		EXECUTE IMMEDIATE 'DROP PACKAGE '||r_p.object_name;
	END LOOP;
END;
/
CREATE OR REPLACE VIEW v_cube_user AS 
	SELECT
		cube_id,
		userid,
		name,
		password
	FROM t_cube_user
/

CREATE OR REPLACE PACKAGE pkg_cube_usr_trg IS
	FUNCTION cube_trg_cubesys RETURN VARCHAR2;
	PROCEDURE insert_cube_usr (p_cube_usr IN OUT NOCOPY v_cube_user%ROWTYPE);
	PROCEDURE update_cube_usr (p_cube_rowid IN UROWID, p_cube_usr_old IN OUT NOCOPY v_cube_user%ROWTYPE, p_cube_usr_new IN OUT NOCOPY v_cube_user%ROWTYPE);
	PROCEDURE delete_cube_usr (p_cube_rowid IN UROWID, p_cube_usr IN OUT NOCOPY v_cube_user%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_cube_usr_trg IS

	FUNCTION cube_trg_cubesys RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubesys';
	END;

	PROCEDURE insert_cube_usr (p_cube_usr IN OUT NOCOPY v_cube_user%ROWTYPE) IS
	BEGIN
		p_cube_usr.cube_id := 'CUBE_USR-' || TO_CHAR(sq_cube_usr.NEXTVAL,'FM0000000');
		p_cube_usr.userid := NVL(p_cube_usr.userid,' ');
		INSERT INTO t_cube_user (
			cube_id,
			userid,
			name,
			password)
		VALUES (
			p_cube_usr.cube_id,
			p_cube_usr.userid,
			p_cube_usr.name,
			p_cube_usr.password);
	END;

	PROCEDURE update_cube_usr (p_cube_rowid UROWID, p_cube_usr_old IN OUT NOCOPY v_cube_user%ROWTYPE, p_cube_usr_new IN OUT NOCOPY v_cube_user%ROWTYPE) IS
	BEGIN
		UPDATE t_cube_user SET 
			name = p_cube_usr_new.name,
			password = p_cube_usr_new.password
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_cube_usr (p_cube_rowid UROWID, p_cube_usr IN OUT NOCOPY v_cube_user%ROWTYPE) IS
	BEGIN
		DELETE t_cube_user 
		WHERE rowid = p_cube_rowid;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_cube_usr
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_cube_user
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_cube_usr_new v_cube_user%ROWTYPE;
	r_cube_usr_old v_cube_user%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		IF :NEW.userid = ' ' THEN
			r_cube_usr_new.userid := ' ';
		ELSE
			r_cube_usr_new.userid := REPLACE(:NEW.userid,' ','_');
		END IF;
		r_cube_usr_new.name := :NEW.name;
		IF :NEW.password = ' ' THEN
			r_cube_usr_new.password := ' ';
		ELSE
			r_cube_usr_new.password := REPLACE(:NEW.password,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_cube_usr_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_cube_user
		WHERE userid = :OLD.userid;
		r_cube_usr_old.userid := :OLD.userid;
		r_cube_usr_old.name := :OLD.name;
		r_cube_usr_old.password := :OLD.password;
	END IF;

	IF INSERTING THEN 
		pkg_cube_usr_trg.insert_cube_usr (r_cube_usr_new);
	ELSIF UPDATING THEN
		pkg_cube_usr_trg.update_cube_usr (l_cube_rowid, r_cube_usr_old, r_cube_usr_new);
	ELSIF DELETING THEN
		pkg_cube_usr_trg.delete_cube_usr (l_cube_rowid, r_cube_usr_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE VIEW v_cube_description AS 
	SELECT
		cube_id,
		type_name,
		attribute_type_name,
		sequence,
		value
	FROM t_cube_description
/

CREATE OR REPLACE PACKAGE pkg_cube_dsc_trg IS
	FUNCTION cube_trg_cubesys RETURN VARCHAR2;
	PROCEDURE insert_cube_dsc (p_cube_dsc IN OUT NOCOPY v_cube_description%ROWTYPE);
	PROCEDURE update_cube_dsc (p_cube_rowid IN UROWID, p_cube_dsc_old IN OUT NOCOPY v_cube_description%ROWTYPE, p_cube_dsc_new IN OUT NOCOPY v_cube_description%ROWTYPE);
	PROCEDURE delete_cube_dsc (p_cube_rowid IN UROWID, p_cube_dsc IN OUT NOCOPY v_cube_description%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_cube_dsc_trg IS

	FUNCTION cube_trg_cubesys RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubesys';
	END;

	PROCEDURE insert_cube_dsc (p_cube_dsc IN OUT NOCOPY v_cube_description%ROWTYPE) IS
	BEGIN
		p_cube_dsc.cube_id := 'CUBE_DSC-' || TO_CHAR(sq_cube_dsc.NEXTVAL,'FM0000000');
		p_cube_dsc.type_name := NVL(p_cube_dsc.type_name,' ');
		p_cube_dsc.attribute_type_name := NVL(p_cube_dsc.attribute_type_name,' ');
		p_cube_dsc.sequence := NVL(p_cube_dsc.sequence,0);
		INSERT INTO t_cube_description (
			cube_id,
			type_name,
			attribute_type_name,
			sequence,
			value)
		VALUES (
			p_cube_dsc.cube_id,
			p_cube_dsc.type_name,
			p_cube_dsc.attribute_type_name,
			p_cube_dsc.sequence,
			p_cube_dsc.value);
	END;

	PROCEDURE update_cube_dsc (p_cube_rowid UROWID, p_cube_dsc_old IN OUT NOCOPY v_cube_description%ROWTYPE, p_cube_dsc_new IN OUT NOCOPY v_cube_description%ROWTYPE) IS
	BEGIN
		UPDATE t_cube_description SET 
			value = p_cube_dsc_new.value
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_cube_dsc (p_cube_rowid UROWID, p_cube_dsc IN OUT NOCOPY v_cube_description%ROWTYPE) IS
	BEGIN
		DELETE t_cube_description 
		WHERE rowid = p_cube_rowid;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_cube_dsc
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_cube_description
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_cube_dsc_new v_cube_description%ROWTYPE;
	r_cube_dsc_old v_cube_description%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		IF :NEW.type_name = ' ' THEN
			r_cube_dsc_new.type_name := ' ';
		ELSE
			r_cube_dsc_new.type_name := REPLACE(:NEW.type_name,' ','_');
		END IF;
		IF :NEW.attribute_type_name = ' ' THEN
			r_cube_dsc_new.attribute_type_name := ' ';
		ELSE
			r_cube_dsc_new.attribute_type_name := REPLACE(:NEW.attribute_type_name,' ','_');
		END IF;
		r_cube_dsc_new.sequence := :NEW.sequence;
		r_cube_dsc_new.value := :NEW.value;
	END IF;
	IF UPDATING THEN
		r_cube_dsc_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_cube_description
		WHERE type_name = :OLD.type_name
		  AND attribute_type_name = :OLD.attribute_type_name
		  AND sequence = :OLD.sequence;
		r_cube_dsc_old.type_name := :OLD.type_name;
		r_cube_dsc_old.attribute_type_name := :OLD.attribute_type_name;
		r_cube_dsc_old.sequence := :OLD.sequence;
		r_cube_dsc_old.value := :OLD.value;
	END IF;

	IF INSERTING THEN 
		pkg_cube_dsc_trg.insert_cube_dsc (r_cube_dsc_new);
	ELSIF UPDATING THEN
		pkg_cube_dsc_trg.update_cube_dsc (l_cube_rowid, r_cube_dsc_old, r_cube_dsc_new);
	ELSIF DELETING THEN
		pkg_cube_dsc_trg.delete_cube_dsc (l_cube_rowid, r_cube_dsc_old);
	END IF;
END;
/
SHOW ERRORS

EXIT;