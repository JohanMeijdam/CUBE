-- DB VIEW DDL
--
BEGIN
	FOR r_v IN (
		SELECT view_name 
		FROM user_views)
	LOOP
		EXECUTE IMMEDIATE 'DROP VIEW '||r_v.view_name;
	END LOOP;
	
	FOR r_p IN (
		SELECT object_name
		FROM user_procedures
		WHERE procedure_name = 'CUBE_TRG_CUBETEST' )
	LOOP
		EXECUTE IMMEDIATE 'DROP PACKAGE '||r_p.object_name;
	END LOOP;
END;
/
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
		cube_sequence,
		fk_aaa_naam,
		naam,
		xk_aaa_naam
	FROM t_aaa_deel
/

CREATE OR REPLACE PACKAGE pkg_aaa_trg IS
	FUNCTION cube_trg_cubetest RETURN VARCHAR2;
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

	FUNCTION cube_trg_cubetest RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubetest';
	END;

	PROCEDURE insert_aaa (p_aaa IN OUT NOCOPY v_aaa%ROWTYPE) IS
	BEGIN
		p_aaa.cube_id := 'AAA-' || TO_CHAR(sq_aaa.NEXTVAL,'FM000000000000');
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
			fk_aaa_naam = p_aaa_new.fk_aaa_naam,
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
		p_aad.cube_id := 'AAD-' || TO_CHAR(sq_aad.NEXTVAL,'FM000000000000');
		INSERT INTO t_aaa_deel (
			cube_id,
			cube_sequence,
			fk_aaa_naam,
			naam,
			xk_aaa_naam)
		VALUES (
			p_aad.cube_id,
			p_aad.cube_sequence,
			p_aad.fk_aaa_naam,
			p_aad.naam,
			p_aad.xk_aaa_naam);
	END;

	PROCEDURE update_aad (p_cube_rowid UROWID, p_aad_old IN OUT NOCOPY v_aaa_deel%ROWTYPE, p_aad_new IN OUT NOCOPY v_aaa_deel%ROWTYPE) IS
	BEGIN
		UPDATE t_aaa_deel SET 
			cube_sequence = p_aad_new.cube_sequence,
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
		r_aad_new.cube_sequence := :NEW.cube_sequence;
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
		r_aad_old.cube_sequence := :OLD.cube_sequence;
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
	FUNCTION cube_trg_cubetest RETURN VARCHAR2;
	PROCEDURE insert_bbb (p_bbb IN OUT NOCOPY v_bbb%ROWTYPE);
	PROCEDURE update_bbb (p_cube_rowid IN UROWID, p_bbb_old IN OUT NOCOPY v_bbb%ROWTYPE, p_bbb_new IN OUT NOCOPY v_bbb%ROWTYPE);
	PROCEDURE delete_bbb (p_cube_rowid IN UROWID, p_bbb IN OUT NOCOPY v_bbb%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_bbb_trg IS

	FUNCTION cube_trg_cubetest RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubetest';
	END;

	PROCEDURE insert_bbb (p_bbb IN OUT NOCOPY v_bbb%ROWTYPE) IS
	BEGIN
		p_bbb.cube_id := 'BBB-' || TO_CHAR(sq_bbb.NEXTVAL,'FM000000000000');
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
		cube_sequence,
		cube_level,
		fk_ccc_code,
		fk_ccc_naam,
		code,
		naam,
		omschrjving,
		xk_ccc_code,
		xk_ccc_naam
	FROM t_ccc
/

CREATE OR REPLACE PACKAGE pkg_ccc_trg IS
	FUNCTION cube_trg_cubetest RETURN VARCHAR2;
	PROCEDURE insert_ccc (p_ccc IN OUT NOCOPY v_ccc%ROWTYPE);
	PROCEDURE update_ccc (p_cube_rowid IN UROWID, p_ccc_old IN OUT NOCOPY v_ccc%ROWTYPE, p_ccc_new IN OUT NOCOPY v_ccc%ROWTYPE);
	PROCEDURE delete_ccc (p_cube_rowid IN UROWID, p_ccc IN OUT NOCOPY v_ccc%ROWTYPE);
	PROCEDURE denorm_ccc_ccc (p_ccc IN OUT NOCOPY v_ccc%ROWTYPE, p_ccc_in IN v_ccc%ROWTYPE);
	PROCEDURE get_denorm_ccc_ccc (p_ccc IN OUT NOCOPY v_ccc%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_ccc_trg IS

	FUNCTION cube_trg_cubetest RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubetest';
	END;

	PROCEDURE insert_ccc (p_ccc IN OUT NOCOPY v_ccc%ROWTYPE) IS
	BEGIN
		p_ccc.cube_id := 'CCC-' || TO_CHAR(sq_ccc.NEXTVAL,'FM000000000000');
		get_denorm_ccc_ccc (p_ccc);
		INSERT INTO t_ccc (
			cube_id,
			cube_sequence,
			cube_level,
			fk_ccc_code,
			fk_ccc_naam,
			code,
			naam,
			omschrjving,
			xk_ccc_code,
			xk_ccc_naam)
		VALUES (
			p_ccc.cube_id,
			p_ccc.cube_sequence,
			p_ccc.cube_level,
			p_ccc.fk_ccc_code,
			p_ccc.fk_ccc_naam,
			p_ccc.code,
			p_ccc.naam,
			p_ccc.omschrjving,
			p_ccc.xk_ccc_code,
			p_ccc.xk_ccc_naam);
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
			cube_sequence = p_ccc_new.cube_sequence,
			cube_level = p_ccc_new.cube_level,
			fk_ccc_code = p_ccc_new.fk_ccc_code,
			fk_ccc_naam = p_ccc_new.fk_ccc_naam,
			omschrjving = p_ccc_new.omschrjving,
			xk_ccc_code = p_ccc_new.xk_ccc_code,
			xk_ccc_naam = p_ccc_new.xk_ccc_naam
		WHERE rowid = p_cube_rowid;
		IF NVL(p_ccc_old.cube_level,0) <> NVL(p_ccc_new.cube_level,0) THEN
			OPEN c_ccc;
			LOOP
				FETCH c_ccc INTO
					l_ccc_rowid,
					r_ccc_old.cube_id,
					r_ccc_old.cube_sequence,
					r_ccc_old.cube_level,
					r_ccc_old.fk_ccc_code,
					r_ccc_old.fk_ccc_naam,
					r_ccc_old.code,
					r_ccc_old.naam,
					r_ccc_old.omschrjving,
					r_ccc_old.xk_ccc_code,
					r_ccc_old.xk_ccc_naam;
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
		r_ccc_new.cube_sequence := :NEW.cube_sequence;
		IF :NEW.fk_ccc_code = ' ' THEN
			r_ccc_new.fk_ccc_code := ' ';
		ELSE
			r_ccc_new.fk_ccc_code := REPLACE(:NEW.fk_ccc_code,' ','_');
		END IF;
		r_ccc_new.fk_ccc_naam := :NEW.fk_ccc_naam;
		IF :NEW.code = ' ' THEN
			r_ccc_new.code := ' ';
		ELSE
			r_ccc_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_ccc_new.naam := :NEW.naam;
		r_ccc_new.omschrjving := :NEW.omschrjving;
		IF :NEW.xk_ccc_code = ' ' THEN
			r_ccc_new.xk_ccc_code := ' ';
		ELSE
			r_ccc_new.xk_ccc_code := REPLACE(:NEW.xk_ccc_code,' ','_');
		END IF;
		r_ccc_new.xk_ccc_naam := :NEW.xk_ccc_naam;
	END IF;
	IF UPDATING THEN
		r_ccc_new.cube_id := :OLD.cube_id;
		r_ccc_new.cube_level := :OLD.cube_level;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_ccc
		WHERE code = :OLD.code
		  AND naam = :OLD.naam;
		r_ccc_old.cube_sequence := :OLD.cube_sequence;
		r_ccc_old.fk_ccc_code := :OLD.fk_ccc_code;
		r_ccc_old.fk_ccc_naam := :OLD.fk_ccc_naam;
		r_ccc_old.code := :OLD.code;
		r_ccc_old.naam := :OLD.naam;
		r_ccc_old.omschrjving := :OLD.omschrjving;
		r_ccc_old.xk_ccc_code := :OLD.xk_ccc_code;
		r_ccc_old.xk_ccc_naam := :OLD.xk_ccc_naam;
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

CREATE OR REPLACE VIEW v_prod AS 
	SELECT
		cube_id,
		cube_tsg_zzz,
		cube_tsg_yyy,
		code,
		naam,
		nummer,
		datum,
		omschrijving,
		xk_aaa_naam
	FROM t_prod
/
CREATE OR REPLACE VIEW v_prod2 AS 
	SELECT
		cube_id,
		fk_prd_code,
		fk_prd_naam,
		fk_prd_nummer,
		fk_prd_aaa_naam,
		code,
		naam,
		omschrijving
	FROM t_prod2
/
CREATE OR REPLACE VIEW v_part2 AS 
	SELECT
		cube_id,
		cube_level,
		fk_prd_code,
		fk_prd_naam,
		fk_prd_nummer,
		fk_prd_aaa_naam,
		fk_pr2_code,
		fk_pr2_naam,
		fk_pa2_code,
		fk_pa2_naam,
		code,
		naam,
		omschrijving,
		xk_pa2_code,
		xk_pa2_naam
	FROM t_part2
/
CREATE OR REPLACE VIEW v_part AS 
	SELECT
		cube_id,
		cube_level,
		fk_prd_code,
		fk_prd_naam,
		fk_prd_nummer,
		fk_prd_aaa_naam,
		fk_prt_code,
		fk_prt_naam,
		code,
		naam,
		omschrijving,
		xk_prt_code,
		xk_prt_naam
	FROM t_part
/

CREATE OR REPLACE PACKAGE pkg_prd_trg IS
	FUNCTION cube_trg_cubetest RETURN VARCHAR2;
	PROCEDURE insert_prd (p_prd IN OUT NOCOPY v_prod%ROWTYPE);
	PROCEDURE update_prd (p_cube_rowid IN UROWID, p_prd_old IN OUT NOCOPY v_prod%ROWTYPE, p_prd_new IN OUT NOCOPY v_prod%ROWTYPE);
	PROCEDURE delete_prd (p_cube_rowid IN UROWID, p_prd IN OUT NOCOPY v_prod%ROWTYPE);
	PROCEDURE insert_pr2 (p_pr2 IN OUT NOCOPY v_prod2%ROWTYPE);
	PROCEDURE update_pr2 (p_cube_rowid IN UROWID, p_pr2_old IN OUT NOCOPY v_prod2%ROWTYPE, p_pr2_new IN OUT NOCOPY v_prod2%ROWTYPE);
	PROCEDURE delete_pr2 (p_cube_rowid IN UROWID, p_pr2 IN OUT NOCOPY v_prod2%ROWTYPE);
	PROCEDURE insert_pa2 (p_pa2 IN OUT NOCOPY v_part2%ROWTYPE);
	PROCEDURE update_pa2 (p_cube_rowid IN UROWID, p_pa2_old IN OUT NOCOPY v_part2%ROWTYPE, p_pa2_new IN OUT NOCOPY v_part2%ROWTYPE);
	PROCEDURE delete_pa2 (p_cube_rowid IN UROWID, p_pa2 IN OUT NOCOPY v_part2%ROWTYPE);
	PROCEDURE denorm_pa2_pa2 (p_pa2 IN OUT NOCOPY v_part2%ROWTYPE, p_pa2_in IN v_part2%ROWTYPE);
	PROCEDURE get_denorm_pa2_pa2 (p_pa2 IN OUT NOCOPY v_part2%ROWTYPE);
	PROCEDURE insert_prt (p_prt IN OUT NOCOPY v_part%ROWTYPE);
	PROCEDURE update_prt (p_cube_rowid IN UROWID, p_prt_old IN OUT NOCOPY v_part%ROWTYPE, p_prt_new IN OUT NOCOPY v_part%ROWTYPE);
	PROCEDURE delete_prt (p_cube_rowid IN UROWID, p_prt IN OUT NOCOPY v_part%ROWTYPE);
	PROCEDURE denorm_prt_prt (p_prt IN OUT NOCOPY v_part%ROWTYPE, p_prt_in IN v_part%ROWTYPE);
	PROCEDURE get_denorm_prt_prt (p_prt IN OUT NOCOPY v_part%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_prd_trg IS

	FUNCTION cube_trg_cubetest RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubetest';
	END;

	PROCEDURE insert_prd (p_prd IN OUT NOCOPY v_prod%ROWTYPE) IS
	BEGIN
		p_prd.cube_id := 'PRD-' || TO_CHAR(sq_prd.NEXTVAL,'FM000000000000');
		INSERT INTO t_prod (
			cube_id,
			cube_tsg_zzz,
			cube_tsg_yyy,
			code,
			naam,
			nummer,
			datum,
			omschrijving,
			xk_aaa_naam)
		VALUES (
			p_prd.cube_id,
			p_prd.cube_tsg_zzz,
			p_prd.cube_tsg_yyy,
			p_prd.code,
			NVL(p_prd.naam,' '),
			NVL(p_prd.nummer,0),
			p_prd.datum,
			p_prd.omschrijving,
			NVL(p_prd.xk_aaa_naam,' '));
	END;

	PROCEDURE update_prd (p_cube_rowid UROWID, p_prd_old IN OUT NOCOPY v_prod%ROWTYPE, p_prd_new IN OUT NOCOPY v_prod%ROWTYPE) IS
	BEGIN
		UPDATE t_prod SET 
			datum = p_prd_new.datum,
			omschrijving = p_prd_new.omschrijving
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_prd (p_cube_rowid UROWID, p_prd IN OUT NOCOPY v_prod%ROWTYPE) IS
	BEGIN
		DELETE t_prod 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_pr2 (p_pr2 IN OUT NOCOPY v_prod2%ROWTYPE) IS
	BEGIN
		p_pr2.cube_id := 'PR2-' || TO_CHAR(sq_pr2.NEXTVAL,'FM000000000000');
		INSERT INTO t_prod2 (
			cube_id,
			fk_prd_code,
			fk_prd_naam,
			fk_prd_nummer,
			fk_prd_aaa_naam,
			code,
			naam,
			omschrijving)
		VALUES (
			p_pr2.cube_id,
			p_pr2.fk_prd_code,
			p_pr2.fk_prd_naam,
			p_pr2.fk_prd_nummer,
			p_pr2.fk_prd_aaa_naam,
			p_pr2.code,
			p_pr2.naam,
			p_pr2.omschrijving);
	END;

	PROCEDURE update_pr2 (p_cube_rowid UROWID, p_pr2_old IN OUT NOCOPY v_prod2%ROWTYPE, p_pr2_new IN OUT NOCOPY v_prod2%ROWTYPE) IS
	BEGIN
		UPDATE t_prod2 SET 
			omschrijving = p_pr2_new.omschrijving
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_pr2 (p_cube_rowid UROWID, p_pr2 IN OUT NOCOPY v_prod2%ROWTYPE) IS
	BEGIN
		DELETE t_prod2 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_pa2 (p_pa2 IN OUT NOCOPY v_part2%ROWTYPE) IS
	BEGIN
		p_pa2.cube_id := 'PA2-' || TO_CHAR(sq_pa2.NEXTVAL,'FM000000000000');
		IF p_pa2.fk_pa2_code IS NOT NULL OR p_pa2.fk_pa2_naam IS NOT NULL  THEN
			-- Recursive
			SELECT fk_prd_code, fk_prd_naam, fk_prd_nummer, fk_prd_aaa_naam, fk_pr2_code, fk_pr2_naam
			  INTO p_pa2.fk_prd_code, p_pa2.fk_prd_naam, p_pa2.fk_prd_nummer, p_pa2.fk_prd_aaa_naam, p_pa2.fk_pr2_code, p_pa2.fk_pr2_naam
			FROM t_part2
			WHERE fk_pr2_code = p_pa2.fk_pr2_code
			  AND fk_pr2_naam = p_pa2.fk_pr2_naam
			  AND code = p_pa2.fk_pa2_code
			  AND naam = p_pa2.fk_pa2_naam;
		ELSE
			-- Parent
			SELECT fk_prd_code, fk_prd_naam, fk_prd_nummer, fk_prd_aaa_naam
			  INTO p_pa2.fk_prd_code, p_pa2.fk_prd_naam, p_pa2.fk_prd_nummer, p_pa2.fk_prd_aaa_naam
			FROM t_prod2
			WHERE code = p_pa2.fk_pr2_code
			  AND naam = p_pa2.fk_pr2_naam;
			
		END IF;
		get_denorm_pa2_pa2 (p_pa2);
		INSERT INTO t_part2 (
			cube_id,
			cube_level,
			fk_prd_code,
			fk_prd_naam,
			fk_prd_nummer,
			fk_prd_aaa_naam,
			fk_pr2_code,
			fk_pr2_naam,
			fk_pa2_code,
			fk_pa2_naam,
			code,
			naam,
			omschrijving,
			xk_pa2_code,
			xk_pa2_naam)
		VALUES (
			p_pa2.cube_id,
			p_pa2.cube_level,
			p_pa2.fk_prd_code,
			p_pa2.fk_prd_naam,
			p_pa2.fk_prd_nummer,
			p_pa2.fk_prd_aaa_naam,
			p_pa2.fk_pr2_code,
			p_pa2.fk_pr2_naam,
			p_pa2.fk_pa2_code,
			p_pa2.fk_pa2_naam,
			p_pa2.code,
			p_pa2.naam,
			p_pa2.omschrijving,
			p_pa2.xk_pa2_code,
			p_pa2.xk_pa2_naam);
	END;

	PROCEDURE update_pa2 (p_cube_rowid UROWID, p_pa2_old IN OUT NOCOPY v_part2%ROWTYPE, p_pa2_new IN OUT NOCOPY v_part2%ROWTYPE) IS

		CURSOR c_pa2 IS
			SELECT ROWID cube_row_id, pa2.* FROM v_part2 pa2
			WHERE fk_pa2_code = p_pa2_old.code
			  AND fk_pa2_naam = p_pa2_old.naam;
		
		l_pa2_rowid UROWID;
		r_pa2_old v_part2%ROWTYPE;
		r_pa2_new v_part2%ROWTYPE;
	BEGIN
		IF NVL(p_pa2_old.fk_pa2_code,' ') <> NVL(p_pa2_new.fk_pa2_code,' ') 
		OR NVL(p_pa2_old.fk_pa2_naam,' ') <> NVL(p_pa2_new.fk_pa2_naam,' ')  THEN
			get_denorm_pa2_pa2 (p_pa2_new);
		END IF;
		UPDATE t_part2 SET 
			cube_level = p_pa2_new.cube_level,
			omschrijving = p_pa2_new.omschrijving,
			xk_pa2_code = p_pa2_new.xk_pa2_code,
			xk_pa2_naam = p_pa2_new.xk_pa2_naam
		WHERE rowid = p_cube_rowid;
		IF NVL(p_pa2_old.cube_level,0) <> NVL(p_pa2_new.cube_level,0) THEN
			OPEN c_pa2;
			LOOP
				FETCH c_pa2 INTO
					l_pa2_rowid,
					r_pa2_old.cube_id,
					r_pa2_old.cube_level,
					r_pa2_old.fk_prd_code,
					r_pa2_old.fk_prd_naam,
					r_pa2_old.fk_prd_nummer,
					r_pa2_old.fk_prd_aaa_naam,
					r_pa2_old.fk_pr2_code,
					r_pa2_old.fk_pr2_naam,
					r_pa2_old.fk_pa2_code,
					r_pa2_old.fk_pa2_naam,
					r_pa2_old.code,
					r_pa2_old.naam,
					r_pa2_old.omschrijving,
					r_pa2_old.xk_pa2_code,
					r_pa2_old.xk_pa2_naam;
				EXIT WHEN c_pa2%NOTFOUND;
				r_pa2_new := r_pa2_old;
				denorm_pa2_pa2 (r_pa2_new, p_pa2_new);
				update_pa2 (l_pa2_rowid, r_pa2_old, r_pa2_new);
			END LOOP;
			CLOSE c_pa2;
		END IF;
	END;

	PROCEDURE delete_pa2 (p_cube_rowid UROWID, p_pa2 IN OUT NOCOPY v_part2%ROWTYPE) IS
	BEGIN
		DELETE t_part2 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE denorm_pa2_pa2 (p_pa2 IN OUT NOCOPY v_part2%ROWTYPE, p_pa2_in IN v_part2%ROWTYPE) IS
	BEGIN
		p_pa2.cube_level := NVL (p_pa2_in.cube_level, 0) + 1;
	END;

	PROCEDURE get_denorm_pa2_pa2 (p_pa2 IN OUT NOCOPY v_part2%ROWTYPE) IS

		CURSOR c_pa2 IS 
			SELECT * FROM v_part2
			WHERE code = p_pa2.fk_pa2_code
			  AND naam = p_pa2.fk_pa2_naam;
		
		r_pa2 v_part2%ROWTYPE;
	BEGIN
		IF p_pa2.fk_pa2_code IS NOT NULL AND p_pa2.fk_pa2_naam IS NOT NULL THEN
			OPEN c_pa2;
			FETCH c_pa2 INTO r_pa2;
			IF c_pa2%NOTFOUND THEN
				r_pa2 := NULL;
			END IF;
			CLOSE c_pa2;
		ELSE
			r_pa2 := NULL;
		END IF;
		denorm_pa2_pa2 (p_pa2, r_pa2);
	END;

	PROCEDURE insert_prt (p_prt IN OUT NOCOPY v_part%ROWTYPE) IS
	BEGIN
		p_prt.cube_id := 'PRT-' || TO_CHAR(sq_prt.NEXTVAL,'FM000000000000');
		IF p_prt.fk_prt_code IS NOT NULL OR p_prt.fk_prt_naam IS NOT NULL  THEN
			-- Recursive
			SELECT fk_prd_code, fk_prd_naam, fk_prd_nummer, fk_prd_aaa_naam
			  INTO p_prt.fk_prd_code, p_prt.fk_prd_naam, p_prt.fk_prd_nummer, p_prt.fk_prd_aaa_naam
			FROM t_part
			WHERE fk_prd_code = p_prt.fk_prd_code
			  AND fk_prd_naam = p_prt.fk_prd_naam
			  AND fk_prd_nummer = p_prt.fk_prd_nummer
			  AND fk_prd_aaa_naam = p_prt.fk_prd_aaa_naam
			  AND code = p_prt.fk_prt_code
			  AND naam = p_prt.fk_prt_naam;
		END IF;
		get_denorm_prt_prt (p_prt);
		INSERT INTO t_part (
			cube_id,
			cube_level,
			fk_prd_code,
			fk_prd_naam,
			fk_prd_nummer,
			fk_prd_aaa_naam,
			fk_prt_code,
			fk_prt_naam,
			code,
			naam,
			omschrijving,
			xk_prt_code,
			xk_prt_naam)
		VALUES (
			p_prt.cube_id,
			p_prt.cube_level,
			p_prt.fk_prd_code,
			p_prt.fk_prd_naam,
			p_prt.fk_prd_nummer,
			p_prt.fk_prd_aaa_naam,
			p_prt.fk_prt_code,
			p_prt.fk_prt_naam,
			p_prt.code,
			p_prt.naam,
			p_prt.omschrijving,
			p_prt.xk_prt_code,
			p_prt.xk_prt_naam);
	END;

	PROCEDURE update_prt (p_cube_rowid UROWID, p_prt_old IN OUT NOCOPY v_part%ROWTYPE, p_prt_new IN OUT NOCOPY v_part%ROWTYPE) IS

		CURSOR c_prt IS
			SELECT ROWID cube_row_id, prt.* FROM v_part prt
			WHERE fk_prt_code = p_prt_old.code
			  AND fk_prt_naam = p_prt_old.naam;
		
		l_prt_rowid UROWID;
		r_prt_old v_part%ROWTYPE;
		r_prt_new v_part%ROWTYPE;
	BEGIN
		IF NVL(p_prt_old.fk_prt_code,' ') <> NVL(p_prt_new.fk_prt_code,' ') 
		OR NVL(p_prt_old.fk_prt_naam,' ') <> NVL(p_prt_new.fk_prt_naam,' ')  THEN
			get_denorm_prt_prt (p_prt_new);
		END IF;
		UPDATE t_part SET 
			cube_level = p_prt_new.cube_level,
			omschrijving = p_prt_new.omschrijving,
			xk_prt_code = p_prt_new.xk_prt_code,
			xk_prt_naam = p_prt_new.xk_prt_naam
		WHERE rowid = p_cube_rowid;
		IF NVL(p_prt_old.cube_level,0) <> NVL(p_prt_new.cube_level,0) THEN
			OPEN c_prt;
			LOOP
				FETCH c_prt INTO
					l_prt_rowid,
					r_prt_old.cube_id,
					r_prt_old.cube_level,
					r_prt_old.fk_prd_code,
					r_prt_old.fk_prd_naam,
					r_prt_old.fk_prd_nummer,
					r_prt_old.fk_prd_aaa_naam,
					r_prt_old.fk_prt_code,
					r_prt_old.fk_prt_naam,
					r_prt_old.code,
					r_prt_old.naam,
					r_prt_old.omschrijving,
					r_prt_old.xk_prt_code,
					r_prt_old.xk_prt_naam;
				EXIT WHEN c_prt%NOTFOUND;
				r_prt_new := r_prt_old;
				denorm_prt_prt (r_prt_new, p_prt_new);
				update_prt (l_prt_rowid, r_prt_old, r_prt_new);
			END LOOP;
			CLOSE c_prt;
		END IF;
	END;

	PROCEDURE delete_prt (p_cube_rowid UROWID, p_prt IN OUT NOCOPY v_part%ROWTYPE) IS
	BEGIN
		DELETE t_part 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE denorm_prt_prt (p_prt IN OUT NOCOPY v_part%ROWTYPE, p_prt_in IN v_part%ROWTYPE) IS
	BEGIN
		p_prt.cube_level := NVL (p_prt_in.cube_level, 0) + 1;
	END;

	PROCEDURE get_denorm_prt_prt (p_prt IN OUT NOCOPY v_part%ROWTYPE) IS

		CURSOR c_prt IS 
			SELECT * FROM v_part
			WHERE code = p_prt.fk_prt_code
			  AND naam = p_prt.fk_prt_naam;
		
		r_prt v_part%ROWTYPE;
	BEGIN
		IF p_prt.fk_prt_code IS NOT NULL AND p_prt.fk_prt_naam IS NOT NULL THEN
			OPEN c_prt;
			FETCH c_prt INTO r_prt;
			IF c_prt%NOTFOUND THEN
				r_prt := NULL;
			END IF;
			CLOSE c_prt;
		ELSE
			r_prt := NULL;
		END IF;
		denorm_prt_prt (p_prt, r_prt);
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_prd
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_prod
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_prd_new v_prod%ROWTYPE;
	r_prd_old v_prod%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_prd_new.cube_tsg_zzz := :NEW.cube_tsg_zzz;
		r_prd_new.cube_tsg_yyy := :NEW.cube_tsg_yyy;
		IF :NEW.code = ' ' THEN
			r_prd_new.code := ' ';
		ELSE
			r_prd_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_prd_new.naam := :NEW.naam;
		r_prd_new.nummer := :NEW.nummer;
		r_prd_new.datum := :NEW.datum;
		r_prd_new.omschrijving := :NEW.omschrijving;
		r_prd_new.xk_aaa_naam := :NEW.xk_aaa_naam;
	END IF;
	IF UPDATING THEN
		r_prd_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_prod
		WHERE code = :OLD.code
		  AND naam = :OLD.naam
		  AND nummer = :OLD.nummer
		  AND xk_aaa_naam = :OLD.xk_aaa_naam;
		r_prd_old.cube_tsg_zzz := :OLD.cube_tsg_zzz;
		r_prd_old.cube_tsg_yyy := :OLD.cube_tsg_yyy;
		r_prd_old.code := :OLD.code;
		r_prd_old.naam := :OLD.naam;
		r_prd_old.nummer := :OLD.nummer;
		r_prd_old.datum := :OLD.datum;
		r_prd_old.omschrijving := :OLD.omschrijving;
		r_prd_old.xk_aaa_naam := :OLD.xk_aaa_naam;
	END IF;

	IF INSERTING THEN 
		pkg_prd_trg.insert_prd (r_prd_new);
	ELSIF UPDATING THEN
		pkg_prd_trg.update_prd (l_cube_rowid, r_prd_old, r_prd_new);
	ELSIF DELETING THEN
		pkg_prd_trg.delete_prd (l_cube_rowid, r_prd_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_pr2
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_prod2
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_pr2_new v_prod2%ROWTYPE;
	r_pr2_old v_prod2%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		IF :NEW.fk_prd_code = ' ' THEN
			r_pr2_new.fk_prd_code := ' ';
		ELSE
			r_pr2_new.fk_prd_code := REPLACE(:NEW.fk_prd_code,' ','_');
		END IF;
		r_pr2_new.fk_prd_naam := :NEW.fk_prd_naam;
		r_pr2_new.fk_prd_nummer := :NEW.fk_prd_nummer;
		r_pr2_new.fk_prd_aaa_naam := :NEW.fk_prd_aaa_naam;
		IF :NEW.code = ' ' THEN
			r_pr2_new.code := ' ';
		ELSE
			r_pr2_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_pr2_new.naam := :NEW.naam;
		r_pr2_new.omschrijving := :NEW.omschrijving;
	END IF;
	IF UPDATING THEN
		r_pr2_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_prod2
		WHERE code = :OLD.code
		  AND naam = :OLD.naam;
		r_pr2_old.fk_prd_code := :OLD.fk_prd_code;
		r_pr2_old.fk_prd_naam := :OLD.fk_prd_naam;
		r_pr2_old.fk_prd_nummer := :OLD.fk_prd_nummer;
		r_pr2_old.fk_prd_aaa_naam := :OLD.fk_prd_aaa_naam;
		r_pr2_old.code := :OLD.code;
		r_pr2_old.naam := :OLD.naam;
		r_pr2_old.omschrijving := :OLD.omschrijving;
	END IF;

	IF INSERTING THEN 
		pkg_prd_trg.insert_pr2 (r_pr2_new);
	ELSIF UPDATING THEN
		pkg_prd_trg.update_pr2 (l_cube_rowid, r_pr2_old, r_pr2_new);
	ELSIF DELETING THEN
		pkg_prd_trg.delete_pr2 (l_cube_rowid, r_pr2_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_pa2
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_part2
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_pa2_new v_part2%ROWTYPE;
	r_pa2_old v_part2%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		IF :NEW.fk_prd_code = ' ' THEN
			r_pa2_new.fk_prd_code := ' ';
		ELSE
			r_pa2_new.fk_prd_code := REPLACE(:NEW.fk_prd_code,' ','_');
		END IF;
		r_pa2_new.fk_prd_naam := :NEW.fk_prd_naam;
		r_pa2_new.fk_prd_nummer := :NEW.fk_prd_nummer;
		r_pa2_new.fk_prd_aaa_naam := :NEW.fk_prd_aaa_naam;
		IF :NEW.fk_pr2_code = ' ' THEN
			r_pa2_new.fk_pr2_code := ' ';
		ELSE
			r_pa2_new.fk_pr2_code := REPLACE(:NEW.fk_pr2_code,' ','_');
		END IF;
		r_pa2_new.fk_pr2_naam := :NEW.fk_pr2_naam;
		IF :NEW.fk_pa2_code = ' ' THEN
			r_pa2_new.fk_pa2_code := ' ';
		ELSE
			r_pa2_new.fk_pa2_code := REPLACE(:NEW.fk_pa2_code,' ','_');
		END IF;
		r_pa2_new.fk_pa2_naam := :NEW.fk_pa2_naam;
		IF :NEW.code = ' ' THEN
			r_pa2_new.code := ' ';
		ELSE
			r_pa2_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_pa2_new.naam := :NEW.naam;
		r_pa2_new.omschrijving := :NEW.omschrijving;
		IF :NEW.xk_pa2_code = ' ' THEN
			r_pa2_new.xk_pa2_code := ' ';
		ELSE
			r_pa2_new.xk_pa2_code := REPLACE(:NEW.xk_pa2_code,' ','_');
		END IF;
		r_pa2_new.xk_pa2_naam := :NEW.xk_pa2_naam;
	END IF;
	IF UPDATING THEN
		r_pa2_new.cube_id := :OLD.cube_id;
		r_pa2_new.cube_level := :OLD.cube_level;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_part2
		WHERE code = :OLD.code
		  AND naam = :OLD.naam;
		r_pa2_old.fk_prd_code := :OLD.fk_prd_code;
		r_pa2_old.fk_prd_naam := :OLD.fk_prd_naam;
		r_pa2_old.fk_prd_nummer := :OLD.fk_prd_nummer;
		r_pa2_old.fk_prd_aaa_naam := :OLD.fk_prd_aaa_naam;
		r_pa2_old.fk_pr2_code := :OLD.fk_pr2_code;
		r_pa2_old.fk_pr2_naam := :OLD.fk_pr2_naam;
		r_pa2_old.fk_pa2_code := :OLD.fk_pa2_code;
		r_pa2_old.fk_pa2_naam := :OLD.fk_pa2_naam;
		r_pa2_old.code := :OLD.code;
		r_pa2_old.naam := :OLD.naam;
		r_pa2_old.omschrijving := :OLD.omschrijving;
		r_pa2_old.xk_pa2_code := :OLD.xk_pa2_code;
		r_pa2_old.xk_pa2_naam := :OLD.xk_pa2_naam;
	END IF;

	IF INSERTING THEN 
		pkg_prd_trg.insert_pa2 (r_pa2_new);
	ELSIF UPDATING THEN
		pkg_prd_trg.update_pa2 (l_cube_rowid, r_pa2_old, r_pa2_new);
	ELSIF DELETING THEN
		pkg_prd_trg.delete_pa2 (l_cube_rowid, r_pa2_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_prt
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_part
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_prt_new v_part%ROWTYPE;
	r_prt_old v_part%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		IF :NEW.fk_prd_code = ' ' THEN
			r_prt_new.fk_prd_code := ' ';
		ELSE
			r_prt_new.fk_prd_code := REPLACE(:NEW.fk_prd_code,' ','_');
		END IF;
		r_prt_new.fk_prd_naam := :NEW.fk_prd_naam;
		r_prt_new.fk_prd_nummer := :NEW.fk_prd_nummer;
		r_prt_new.fk_prd_aaa_naam := :NEW.fk_prd_aaa_naam;
		IF :NEW.fk_prt_code = ' ' THEN
			r_prt_new.fk_prt_code := ' ';
		ELSE
			r_prt_new.fk_prt_code := REPLACE(:NEW.fk_prt_code,' ','_');
		END IF;
		r_prt_new.fk_prt_naam := :NEW.fk_prt_naam;
		IF :NEW.code = ' ' THEN
			r_prt_new.code := ' ';
		ELSE
			r_prt_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_prt_new.naam := :NEW.naam;
		r_prt_new.omschrijving := :NEW.omschrijving;
		IF :NEW.xk_prt_code = ' ' THEN
			r_prt_new.xk_prt_code := ' ';
		ELSE
			r_prt_new.xk_prt_code := REPLACE(:NEW.xk_prt_code,' ','_');
		END IF;
		r_prt_new.xk_prt_naam := :NEW.xk_prt_naam;
	END IF;
	IF UPDATING THEN
		r_prt_new.cube_id := :OLD.cube_id;
		r_prt_new.cube_level := :OLD.cube_level;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_part
		WHERE code = :OLD.code
		  AND naam = :OLD.naam;
		r_prt_old.fk_prd_code := :OLD.fk_prd_code;
		r_prt_old.fk_prd_naam := :OLD.fk_prd_naam;
		r_prt_old.fk_prd_nummer := :OLD.fk_prd_nummer;
		r_prt_old.fk_prd_aaa_naam := :OLD.fk_prd_aaa_naam;
		r_prt_old.fk_prt_code := :OLD.fk_prt_code;
		r_prt_old.fk_prt_naam := :OLD.fk_prt_naam;
		r_prt_old.code := :OLD.code;
		r_prt_old.naam := :OLD.naam;
		r_prt_old.omschrijving := :OLD.omschrijving;
		r_prt_old.xk_prt_code := :OLD.xk_prt_code;
		r_prt_old.xk_prt_naam := :OLD.xk_prt_naam;
	END IF;

	IF INSERTING THEN 
		pkg_prd_trg.insert_prt (r_prt_new);
	ELSIF UPDATING THEN
		pkg_prd_trg.update_prt (l_cube_rowid, r_prt_old, r_prt_new);
	ELSIF DELETING THEN
		pkg_prd_trg.delete_prt (l_cube_rowid, r_prt_old);
	END IF;
END;
/
SHOW ERRORS

EXIT;