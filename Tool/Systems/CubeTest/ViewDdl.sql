-- DB VIEW DDL
--
CREATE OR REPLACE VIEW v_aaa AS 
	SELECT
		cube_id,
		cube_level,
		fk_aaa_naam,
		naam,
		omschrijving,
		xk_aaa_naam
	FROM t_aaa
/
CREATE OR REPLACE VIEW v_aaa_deel AS 
	SELECT
		cube_id,
		fk_aaa_naam,
		naam,
		xk_aaa_naam
	FROM t_aaa_deel
/

CREATE OR REPLACE PACKAGE pkg_aaa_trg IS
	PROCEDURE insert_aaa (p_aaa IN OUT NOCOPY v_aaa%ROWTYPE);
	PROCEDURE update_aaa (p_cube_rowid IN UROWID, p_aaa_old IN OUT NOCOPY v_aaa%ROWTYPE, p_aaa_new IN OUT NOCOPY v_aaa%ROWTYPE);
	PROCEDURE delete_aaa (p_cube_rowid IN UROWID, p_aaa IN OUT NOCOPY v_aaa%ROWTYPE);
	PROCEDURE denorm_aaa_aaa (p_aaa IN OUT NOCOPY v_aaa%ROWTYPE, p_aaa_in IN v_aaa%ROWTYPE);
	PROCEDURE get_denorm_aaa_aaa (p_aaa IN OUT NOCOPY v_aaa%ROWTYPE);
	PROCEDURE insert_aad (p_aad IN OUT NOCOPY v_aaa_deel%ROWTYPE);
	PROCEDURE update_aad (p_cube_rowid IN UROWID, p_aad_old IN OUT NOCOPY v_aaa_deel%ROWTYPE, p_aad_new IN OUT NOCOPY v_aaa_deel%ROWTYPE);
	PROCEDURE delete_aad (p_cube_rowid IN UROWID, p_aad IN OUT NOCOPY v_aaa_deel%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_aaa_trg IS

	PROCEDURE insert_aaa (p_aaa IN OUT NOCOPY v_aaa%ROWTYPE) IS
	BEGIN
		p_aaa.cube_id := 'AAA-' || TO_CHAR(aaa_seq.NEXTVAL,'FM000000000000');
		get_denorm_aaa_aaa (p_aaa);
		INSERT INTO t_aaa (
			cube_id,
			cube_level,
			fk_aaa_naam,
			naam,
			omschrijving,
			xk_aaa_naam)
		VALUES (
			p_aaa.cube_id,
			p_aaa.cube_level,
			p_aaa.fk_aaa_naam,
			p_aaa.naam,
			p_aaa.omschrijving,
			p_aaa.xk_aaa_naam);
	END;

	PROCEDURE update_aaa (p_cube_rowid UROWID, p_aaa_old IN OUT NOCOPY v_aaa%ROWTYPE, p_aaa_new IN OUT NOCOPY v_aaa%ROWTYPE) IS

		CURSOR c_aaa IS
			SELECT ROWID cube_row_id, aaa.* FROM v_aaa aaa
			WHERE fk_aaa_naam = p_aaa_old.naam;
		
		l_aaa_rowid UROWID;
		r_aaa_old v_aaa%ROWTYPE;
		r_aaa_new v_aaa%ROWTYPE;
	BEGIN
		IF NVL(p_aaa_old.fk_aaa_naam,' ') <> NVL(p_aaa_new.fk_aaa_naam,' ')  THEN
			get_denorm_aaa_aaa (p_aaa_new);
		END IF;
		UPDATE t_aaa SET 
			cube_level = p_aaa_new.cube_level,
			omschrijving = p_aaa_new.omschrijving
		WHERE rowid = p_cube_rowid;
		IF NVL(p_aaa_old.cube_level,0) <> NVL(p_aaa_new.cube_level,0) THEN
			OPEN c_aaa;
			LOOP
				FETCH c_aaa INTO
					l_aaa_rowid,
					r_aaa_old.cube_id,
					r_aaa_old.cube_level,
					r_aaa_old.fk_aaa_naam,
					r_aaa_old.naam,
					r_aaa_old.omschrijving,
					r_aaa_old.xk_aaa_naam;
				EXIT WHEN c_aaa%NOTFOUND;
				r_aaa_new := r_aaa_old;
				denorm_aaa_aaa (r_aaa_new, p_aaa_new);
				update_aaa (l_aaa_rowid, r_aaa_old, r_aaa_new);
			END LOOP;
			CLOSE c_aaa;
		END IF;
	END;

	PROCEDURE delete_aaa (p_cube_rowid UROWID, p_aaa IN OUT NOCOPY v_aaa%ROWTYPE) IS
	BEGIN
		DELETE t_aaa 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE denorm_aaa_aaa (p_aaa IN OUT NOCOPY v_aaa%ROWTYPE, p_aaa_in IN v_aaa%ROWTYPE) IS
	BEGIN
		p_aaa.cube_level := NVL (p_aaa_in.cube_level, 0) + 1;
	END;

	PROCEDURE get_denorm_aaa_aaa (p_aaa IN OUT NOCOPY v_aaa%ROWTYPE) IS

		CURSOR c_aaa IS 
			SELECT * FROM v_aaa
			WHERE naam = p_aaa.fk_aaa_naam;
		
		r_aaa v_aaa%ROWTYPE;
	BEGIN
		IF p_aaa.fk_aaa_naam IS NOT NULL THEN
			OPEN c_aaa;
			FETCH c_aaa INTO r_aaa;
			IF c_aaa%NOTFOUND THEN
				r_aaa := NULL;
			END IF;
			CLOSE c_aaa;
		ELSE
			r_aaa := NULL;
		END IF;
		denorm_aaa_aaa (p_aaa, r_aaa);
	END;

	PROCEDURE insert_aad (p_aad IN OUT NOCOPY v_aaa_deel%ROWTYPE) IS
	BEGIN
		p_aad.cube_id := 'AAD-' || TO_CHAR(aad_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_aaa_deel (
			cube_id,
			fk_aaa_naam,
			naam,
			xk_aaa_naam)
		VALUES (
			p_aad.cube_id,
			p_aad.fk_aaa_naam,
			p_aad.naam,
			p_aad.xk_aaa_naam);
	END;

	PROCEDURE update_aad (p_cube_rowid UROWID, p_aad_old IN OUT NOCOPY v_aaa_deel%ROWTYPE, p_aad_new IN OUT NOCOPY v_aaa_deel%ROWTYPE) IS
	BEGIN
		UPDATE t_aaa_deel SET 
			xk_aaa_naam = p_aad_new.xk_aaa_naam
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_aad (p_cube_rowid UROWID, p_aad IN OUT NOCOPY v_aaa_deel%ROWTYPE) IS
	BEGIN
		DELETE t_aaa_deel 
		WHERE rowid = p_cube_rowid;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_aaa
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_aaa
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_aaa_new v_aaa%ROWTYPE;
	r_aaa_old v_aaa%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_aaa_new.fk_aaa_naam := :NEW.fk_aaa_naam;
		r_aaa_new.naam := :NEW.naam;
		r_aaa_new.omschrijving := :NEW.omschrijving;
		r_aaa_new.xk_aaa_naam := :NEW.xk_aaa_naam;
	END IF;
	IF UPDATING THEN
		r_aaa_new.cube_id := :OLD.cube_id;
		r_aaa_new.cube_level := :OLD.cube_level;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_aaa
		WHERE naam = :OLD.naam;
		r_aaa_old.fk_aaa_naam := :OLD.fk_aaa_naam;
		r_aaa_old.naam := :OLD.naam;
		r_aaa_old.omschrijving := :OLD.omschrijving;
		r_aaa_old.xk_aaa_naam := :OLD.xk_aaa_naam;
	END IF;

	IF INSERTING THEN 
		pkg_aaa_trg.insert_aaa (r_aaa_new);
	ELSIF UPDATING THEN
		pkg_aaa_trg.update_aaa (l_cube_rowid, r_aaa_old, r_aaa_new);
	ELSIF DELETING THEN
		pkg_aaa_trg.delete_aaa (l_cube_rowid, r_aaa_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_aad
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_aaa_deel
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_aad_new v_aaa_deel%ROWTYPE;
	r_aad_old v_aaa_deel%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_aad_new.fk_aaa_naam := :NEW.fk_aaa_naam;
		r_aad_new.naam := :NEW.naam;
		r_aad_new.xk_aaa_naam := :NEW.xk_aaa_naam;
	END IF;
	IF UPDATING THEN
		r_aad_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_aaa_deel
		WHERE fk_aaa_naam = :OLD.fk_aaa_naam
		  AND naam = :OLD.naam;
		r_aad_old.fk_aaa_naam := :OLD.fk_aaa_naam;
		r_aad_old.naam := :OLD.naam;
		r_aad_old.xk_aaa_naam := :OLD.xk_aaa_naam;
	END IF;

	IF INSERTING THEN 
		pkg_aaa_trg.insert_aad (r_aad_new);
	ELSIF UPDATING THEN
		pkg_aaa_trg.update_aad (l_cube_rowid, r_aad_old, r_aad_new);
	ELSIF DELETING THEN
		pkg_aaa_trg.delete_aad (l_cube_rowid, r_aad_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE VIEW v_bbb AS 
	SELECT
		cube_id,
		naam,
		omschrijving,
		xk_aaa_naam,
		xk_bbb_naam_1
	FROM t_bbb
/

CREATE OR REPLACE PACKAGE pkg_bbb_trg IS
	PROCEDURE insert_bbb (p_bbb IN OUT NOCOPY v_bbb%ROWTYPE);
	PROCEDURE update_bbb (p_cube_rowid IN UROWID, p_bbb_old IN OUT NOCOPY v_bbb%ROWTYPE, p_bbb_new IN OUT NOCOPY v_bbb%ROWTYPE);
	PROCEDURE delete_bbb (p_cube_rowid IN UROWID, p_bbb IN OUT NOCOPY v_bbb%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_bbb_trg IS

	PROCEDURE insert_bbb (p_bbb IN OUT NOCOPY v_bbb%ROWTYPE) IS
	BEGIN
		p_bbb.cube_id := 'BBB-' || TO_CHAR(bbb_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_bbb (
			cube_id,
			naam,
			omschrijving,
			xk_aaa_naam,
			xk_bbb_naam_1)
		VALUES (
			p_bbb.cube_id,
			p_bbb.naam,
			p_bbb.omschrijving,
			p_bbb.xk_aaa_naam,
			p_bbb.xk_bbb_naam_1);
	END;

	PROCEDURE update_bbb (p_cube_rowid UROWID, p_bbb_old IN OUT NOCOPY v_bbb%ROWTYPE, p_bbb_new IN OUT NOCOPY v_bbb%ROWTYPE) IS
	BEGIN
		UPDATE t_bbb SET 
			omschrijving = p_bbb_new.omschrijving,
			xk_aaa_naam = p_bbb_new.xk_aaa_naam,
			xk_bbb_naam_1 = p_bbb_new.xk_bbb_naam_1
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_bbb (p_cube_rowid UROWID, p_bbb IN OUT NOCOPY v_bbb%ROWTYPE) IS
	BEGIN
		DELETE t_bbb 
		WHERE rowid = p_cube_rowid;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_bbb
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_bbb
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_bbb_new v_bbb%ROWTYPE;
	r_bbb_old v_bbb%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_bbb_new.naam := :NEW.naam;
		r_bbb_new.omschrijving := :NEW.omschrijving;
		r_bbb_new.xk_aaa_naam := :NEW.xk_aaa_naam;
		r_bbb_new.xk_bbb_naam_1 := :NEW.xk_bbb_naam_1;
	END IF;
	IF UPDATING THEN
		r_bbb_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_bbb
		WHERE naam = :OLD.naam;
		r_bbb_old.naam := :OLD.naam;
		r_bbb_old.omschrijving := :OLD.omschrijving;
		r_bbb_old.xk_aaa_naam := :OLD.xk_aaa_naam;
		r_bbb_old.xk_bbb_naam_1 := :OLD.xk_bbb_naam_1;
	END IF;

	IF INSERTING THEN 
		pkg_bbb_trg.insert_bbb (r_bbb_new);
	ELSIF UPDATING THEN
		pkg_bbb_trg.update_bbb (l_cube_rowid, r_bbb_old, r_bbb_new);
	ELSIF DELETING THEN
		pkg_bbb_trg.delete_bbb (l_cube_rowid, r_bbb_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE VIEW v_ccc AS 
	SELECT
		cube_id,
		cube_level,
		fk_ccc_code,
		fk_ccc_naam,
		code,
		naam,
		omschrjving
	FROM t_ccc
/

CREATE OR REPLACE PACKAGE pkg_ccc_trg IS
	PROCEDURE insert_ccc (p_ccc IN OUT NOCOPY v_ccc%ROWTYPE);
	PROCEDURE update_ccc (p_cube_rowid IN UROWID, p_ccc_old IN OUT NOCOPY v_ccc%ROWTYPE, p_ccc_new IN OUT NOCOPY v_ccc%ROWTYPE);
	PROCEDURE delete_ccc (p_cube_rowid IN UROWID, p_ccc IN OUT NOCOPY v_ccc%ROWTYPE);
	PROCEDURE denorm_ccc_ccc (p_ccc IN OUT NOCOPY v_ccc%ROWTYPE, p_ccc_in IN v_ccc%ROWTYPE);
	PROCEDURE get_denorm_ccc_ccc (p_ccc IN OUT NOCOPY v_ccc%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_ccc_trg IS

	PROCEDURE insert_ccc (p_ccc IN OUT NOCOPY v_ccc%ROWTYPE) IS
	BEGIN
		p_ccc.cube_id := 'CCC-' || TO_CHAR(ccc_seq.NEXTVAL,'FM000000000000');
		get_denorm_ccc_ccc (p_ccc);
		INSERT INTO t_ccc (
			cube_id,
			cube_level,
			fk_ccc_code,
			fk_ccc_naam,
			code,
			naam,
			omschrjving)
		VALUES (
			p_ccc.cube_id,
			p_ccc.cube_level,
			p_ccc.fk_ccc_code,
			p_ccc.fk_ccc_naam,
			p_ccc.code,
			p_ccc.naam,
			p_ccc.omschrjving);
	END;

	PROCEDURE update_ccc (p_cube_rowid UROWID, p_ccc_old IN OUT NOCOPY v_ccc%ROWTYPE, p_ccc_new IN OUT NOCOPY v_ccc%ROWTYPE) IS

		CURSOR c_ccc IS
			SELECT ROWID cube_row_id, ccc.* FROM v_ccc ccc
			WHERE fk_ccc_code = p_ccc_old.code
			  AND fk_ccc_naam = p_ccc_old.naam;
		
		l_ccc_rowid UROWID;
		r_ccc_old v_ccc%ROWTYPE;
		r_ccc_new v_ccc%ROWTYPE;
	BEGIN
		IF NVL(p_ccc_old.fk_ccc_code,' ') <> NVL(p_ccc_new.fk_ccc_code,' ') 
		OR NVL(p_ccc_old.fk_ccc_naam,' ') <> NVL(p_ccc_new.fk_ccc_naam,' ')  THEN
			get_denorm_ccc_ccc (p_ccc_new);
		END IF;
		UPDATE t_ccc SET 
			cube_level = p_ccc_new.cube_level,
			fk_ccc_code = p_ccc_new.fk_ccc_code,
			fk_ccc_naam = p_ccc_new.fk_ccc_naam,
			omschrjving = p_ccc_new.omschrjving
		WHERE rowid = p_cube_rowid;
		IF NVL(p_ccc_old.cube_level,0) <> NVL(p_ccc_new.cube_level,0) THEN
			OPEN c_ccc;
			LOOP
				FETCH c_ccc INTO
					l_ccc_rowid,
					r_ccc_old.cube_id,
					r_ccc_old.cube_level,
					r_ccc_old.fk_ccc_code,
					r_ccc_old.fk_ccc_naam,
					r_ccc_old.code,
					r_ccc_old.naam,
					r_ccc_old.omschrjving;
				EXIT WHEN c_ccc%NOTFOUND;
				r_ccc_new := r_ccc_old;
				denorm_ccc_ccc (r_ccc_new, p_ccc_new);
				update_ccc (l_ccc_rowid, r_ccc_old, r_ccc_new);
			END LOOP;
			CLOSE c_ccc;
		END IF;
	END;

	PROCEDURE delete_ccc (p_cube_rowid UROWID, p_ccc IN OUT NOCOPY v_ccc%ROWTYPE) IS
	BEGIN
		DELETE t_ccc 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE denorm_ccc_ccc (p_ccc IN OUT NOCOPY v_ccc%ROWTYPE, p_ccc_in IN v_ccc%ROWTYPE) IS
	BEGIN
		p_ccc.cube_level := NVL (p_ccc_in.cube_level, 0) + 1;
	END;

	PROCEDURE get_denorm_ccc_ccc (p_ccc IN OUT NOCOPY v_ccc%ROWTYPE) IS

		CURSOR c_ccc IS 
			SELECT * FROM v_ccc
			WHERE code = p_ccc.fk_ccc_code
			  AND naam = p_ccc.fk_ccc_naam;
		
		r_ccc v_ccc%ROWTYPE;
	BEGIN
		IF p_ccc.fk_ccc_code IS NOT NULL AND p_ccc.fk_ccc_naam IS NOT NULL THEN
			OPEN c_ccc;
			FETCH c_ccc INTO r_ccc;
			IF c_ccc%NOTFOUND THEN
				r_ccc := NULL;
			END IF;
			CLOSE c_ccc;
		ELSE
			r_ccc := NULL;
		END IF;
		denorm_ccc_ccc (p_ccc, r_ccc);
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_ccc
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ccc
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_ccc_new v_ccc%ROWTYPE;
	r_ccc_old v_ccc%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_ccc_new.fk_ccc_code := REPLACE(:NEW.fk_ccc_code,' ','_');
		r_ccc_new.fk_ccc_naam := :NEW.fk_ccc_naam;
		r_ccc_new.code := REPLACE(:NEW.code,' ','_');
		r_ccc_new.naam := :NEW.naam;
		r_ccc_new.omschrjving := :NEW.omschrjving;
	END IF;
	IF UPDATING THEN
		r_ccc_new.cube_id := :OLD.cube_id;
		r_ccc_new.cube_level := :OLD.cube_level;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_ccc
		WHERE code = :OLD.code
		  AND naam = :OLD.naam;
		r_ccc_old.fk_ccc_code := :OLD.fk_ccc_code;
		r_ccc_old.fk_ccc_naam := :OLD.fk_ccc_naam;
		r_ccc_old.code := :OLD.code;
		r_ccc_old.naam := :OLD.naam;
		r_ccc_old.omschrjving := :OLD.omschrjving;
	END IF;

	IF INSERTING THEN 
		pkg_ccc_trg.insert_ccc (r_ccc_new);
	ELSIF UPDATING THEN
		pkg_ccc_trg.update_ccc (l_cube_rowid, r_ccc_old, r_ccc_new);
	ELSIF DELETING THEN
		pkg_ccc_trg.delete_ccc (l_cube_rowid, r_ccc_old);
	END IF;
END;
/
SHOW ERRORS

EXIT;