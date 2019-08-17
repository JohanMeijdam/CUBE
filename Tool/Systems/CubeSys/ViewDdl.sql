-- DB VIEW DDL
--
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
	PROCEDURE insert_cube_dsc (p_cube_dsc IN OUT NOCOPY v_cube_description%ROWTYPE);
	PROCEDURE update_cube_dsc (p_cube_rowid IN UROWID, p_cube_dsc_old IN OUT NOCOPY v_cube_description%ROWTYPE, p_cube_dsc_new IN OUT NOCOPY v_cube_description%ROWTYPE);
	PROCEDURE delete_cube_dsc (p_cube_rowid IN UROWID, p_cube_dsc IN OUT NOCOPY v_cube_description%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_cube_dsc_trg IS

	PROCEDURE insert_cube_dsc (p_cube_dsc IN OUT NOCOPY v_cube_description%ROWTYPE) IS
	BEGIN
		p_cube_dsc.cube_id := 'CUBE_DSC-' || TO_CHAR(cube_dsc_seq.NEXTVAL,'FM0000000');
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