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
CREATE OR REPLACE VIEW v_produkt AS 
	SELECT
		cube_id,
		cube_tsg_type,
		cube_tsg_soort,
		cube_tsg_soort1,
		code,
		prijs,
		makelaar_naam,
		bedrag_btw
	FROM t_produkt
/
CREATE OR REPLACE VIEW v_onderdeel AS 
	SELECT
		cube_id,
		cube_sequence,
		cube_level,
		fk_prd_cube_tsg_type,
		fk_prd_code,
		fk_ond_code,
		code,
		prijs,
		omschrijving
	FROM t_onderdeel
/
CREATE OR REPLACE VIEW v_onderdeel_deel AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_prd_cube_tsg_type,
		fk_prd_code,
		fk_ond_code,
		code,
		naam
	FROM t_onderdeel_deel
/
CREATE OR REPLACE VIEW v_onderdeel_deel_deel AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_prd_cube_tsg_type,
		fk_prd_code,
		fk_ond_code,
		fk_odd_code,
		code,
		naam
	FROM t_onderdeel_deel_deel
/
CREATE OR REPLACE VIEW v_constructie AS 
	SELECT
		cube_id,
		fk_prd_cube_tsg_type,
		fk_prd_code,
		fk_ond_code,
		code,
		omschrijving,
		xk_odd_code,
		xk_odd_code_1
	FROM t_constructie
/

CREATE OR REPLACE PACKAGE pkg_prd_trg IS
	FUNCTION cube_trg_cubetest RETURN VARCHAR2;
	PROCEDURE insert_prd (p_prd IN OUT NOCOPY v_produkt%ROWTYPE);
	PROCEDURE update_prd (p_cube_rowid IN UROWID, p_prd_old IN OUT NOCOPY v_produkt%ROWTYPE, p_prd_new IN OUT NOCOPY v_produkt%ROWTYPE);
	PROCEDURE delete_prd (p_cube_rowid IN UROWID, p_prd IN OUT NOCOPY v_produkt%ROWTYPE);
	PROCEDURE insert_ond (p_ond IN OUT NOCOPY v_onderdeel%ROWTYPE);
	PROCEDURE update_ond (p_cube_rowid IN UROWID, p_ond_old IN OUT NOCOPY v_onderdeel%ROWTYPE, p_ond_new IN OUT NOCOPY v_onderdeel%ROWTYPE);
	PROCEDURE delete_ond (p_cube_rowid IN UROWID, p_ond IN OUT NOCOPY v_onderdeel%ROWTYPE);
	PROCEDURE denorm_ond_ond (p_ond IN OUT NOCOPY v_onderdeel%ROWTYPE, p_ond_in IN v_onderdeel%ROWTYPE);
	PROCEDURE get_denorm_ond_ond (p_ond IN OUT NOCOPY v_onderdeel%ROWTYPE);
	PROCEDURE insert_odd (p_odd IN OUT NOCOPY v_onderdeel_deel%ROWTYPE);
	PROCEDURE update_odd (p_cube_rowid IN UROWID, p_odd_old IN OUT NOCOPY v_onderdeel_deel%ROWTYPE, p_odd_new IN OUT NOCOPY v_onderdeel_deel%ROWTYPE);
	PROCEDURE delete_odd (p_cube_rowid IN UROWID, p_odd IN OUT NOCOPY v_onderdeel_deel%ROWTYPE);
	PROCEDURE insert_ddd (p_ddd IN OUT NOCOPY v_onderdeel_deel_deel%ROWTYPE);
	PROCEDURE update_ddd (p_cube_rowid IN UROWID, p_ddd_old IN OUT NOCOPY v_onderdeel_deel_deel%ROWTYPE, p_ddd_new IN OUT NOCOPY v_onderdeel_deel_deel%ROWTYPE);
	PROCEDURE delete_ddd (p_cube_rowid IN UROWID, p_ddd IN OUT NOCOPY v_onderdeel_deel_deel%ROWTYPE);
	PROCEDURE insert_cst (p_cst IN OUT NOCOPY v_constructie%ROWTYPE);
	PROCEDURE update_cst (p_cube_rowid IN UROWID, p_cst_old IN OUT NOCOPY v_constructie%ROWTYPE, p_cst_new IN OUT NOCOPY v_constructie%ROWTYPE);
	PROCEDURE delete_cst (p_cube_rowid IN UROWID, p_cst IN OUT NOCOPY v_constructie%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_prd_trg IS

	FUNCTION cube_trg_cubetest RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubetest';
	END;

	PROCEDURE insert_prd (p_prd IN OUT NOCOPY v_produkt%ROWTYPE) IS
	BEGIN
		p_prd.cube_id := 'PRD-' || TO_CHAR(sq_prd.NEXTVAL,'FM000000000000');
		p_prd.cube_tsg_type := NVL(p_prd.cube_tsg_type,' ');
		p_prd.code := NVL(p_prd.code,' ');
		INSERT INTO t_produkt (
			cube_id,
			cube_tsg_type,
			cube_tsg_soort,
			cube_tsg_soort1,
			code,
			prijs,
			makelaar_naam,
			bedrag_btw)
		VALUES (
			p_prd.cube_id,
			p_prd.cube_tsg_type,
			p_prd.cube_tsg_soort,
			p_prd.cube_tsg_soort1,
			p_prd.code,
			p_prd.prijs,
			p_prd.makelaar_naam,
			p_prd.bedrag_btw);
	END;

	PROCEDURE update_prd (p_cube_rowid UROWID, p_prd_old IN OUT NOCOPY v_produkt%ROWTYPE, p_prd_new IN OUT NOCOPY v_produkt%ROWTYPE) IS
	BEGIN
		UPDATE t_produkt SET 
			prijs = p_prd_new.prijs,
			makelaar_naam = p_prd_new.makelaar_naam,
			bedrag_btw = p_prd_new.bedrag_btw
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_prd (p_cube_rowid UROWID, p_prd IN OUT NOCOPY v_produkt%ROWTYPE) IS
	BEGIN
		DELETE t_produkt 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_ond (p_ond IN OUT NOCOPY v_onderdeel%ROWTYPE) IS
	BEGIN
		p_ond.cube_id := 'OND-' || TO_CHAR(sq_ond.NEXTVAL,'FM000000000000');
		p_ond.fk_prd_cube_tsg_type := NVL(p_ond.fk_prd_cube_tsg_type,' ');
		p_ond.fk_prd_code := NVL(p_ond.fk_prd_code,' ');
		p_ond.code := NVL(p_ond.code,' ');
		get_denorm_ond_ond (p_ond);
		INSERT INTO t_onderdeel (
			cube_id,
			cube_sequence,
			cube_level,
			fk_prd_cube_tsg_type,
			fk_prd_code,
			fk_ond_code,
			code,
			prijs,
			omschrijving)
		VALUES (
			p_ond.cube_id,
			p_ond.cube_sequence,
			p_ond.cube_level,
			p_ond.fk_prd_cube_tsg_type,
			p_ond.fk_prd_code,
			p_ond.fk_ond_code,
			p_ond.code,
			p_ond.prijs,
			p_ond.omschrijving);
	END;

	PROCEDURE update_ond (p_cube_rowid UROWID, p_ond_old IN OUT NOCOPY v_onderdeel%ROWTYPE, p_ond_new IN OUT NOCOPY v_onderdeel%ROWTYPE) IS

		CURSOR c_ond IS
			SELECT ROWID cube_row_id, ond.* FROM v_onderdeel ond
			WHERE fk_prd_cube_tsg_type = p_ond_old.fk_prd_cube_tsg_type
			  AND fk_prd_code = p_ond_old.fk_prd_code
			  AND fk_ond_code = p_ond_old.code;
		
		l_ond_rowid UROWID;
		r_ond_old v_onderdeel%ROWTYPE;
		r_ond_new v_onderdeel%ROWTYPE;
	BEGIN
		IF NVL(p_ond_old.fk_ond_code,' ') <> NVL(p_ond_new.fk_ond_code,' ')  THEN
			get_denorm_ond_ond (p_ond_new);
		END IF;
		UPDATE t_onderdeel SET 
			cube_sequence = p_ond_new.cube_sequence,
			cube_level = p_ond_new.cube_level,
			prijs = p_ond_new.prijs,
			omschrijving = p_ond_new.omschrijving
		WHERE rowid = p_cube_rowid;
		IF NVL(p_ond_old.cube_level,0) <> NVL(p_ond_new.cube_level,0) THEN
			OPEN c_ond;
			LOOP
				FETCH c_ond INTO
					l_ond_rowid,
					r_ond_old.cube_id,
					r_ond_old.cube_sequence,
					r_ond_old.cube_level,
					r_ond_old.fk_prd_cube_tsg_type,
					r_ond_old.fk_prd_code,
					r_ond_old.fk_ond_code,
					r_ond_old.code,
					r_ond_old.prijs,
					r_ond_old.omschrijving;
				EXIT WHEN c_ond%NOTFOUND;
				r_ond_new := r_ond_old;
				denorm_ond_ond (r_ond_new, p_ond_new);
				update_ond (l_ond_rowid, r_ond_old, r_ond_new);
			END LOOP;
			CLOSE c_ond;
		END IF;
	END;

	PROCEDURE delete_ond (p_cube_rowid UROWID, p_ond IN OUT NOCOPY v_onderdeel%ROWTYPE) IS
	BEGIN
		DELETE t_onderdeel 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE denorm_ond_ond (p_ond IN OUT NOCOPY v_onderdeel%ROWTYPE, p_ond_in IN v_onderdeel%ROWTYPE) IS
	BEGIN
		p_ond.cube_level := NVL (p_ond_in.cube_level, 0) + 1;
	END;

	PROCEDURE get_denorm_ond_ond (p_ond IN OUT NOCOPY v_onderdeel%ROWTYPE) IS

		CURSOR c_ond IS 
			SELECT * FROM v_onderdeel
			WHERE fk_prd_cube_tsg_type = p_ond.fk_prd_cube_tsg_type
			  AND fk_prd_code = p_ond.fk_prd_code
			  AND code = p_ond.fk_ond_code;
		
		r_ond v_onderdeel%ROWTYPE;
	BEGIN
		IF p_ond.fk_ond_code IS NOT NULL THEN
			OPEN c_ond;
			FETCH c_ond INTO r_ond;
			IF c_ond%NOTFOUND THEN
				r_ond := NULL;
			END IF;
			CLOSE c_ond;
		ELSE
			r_ond := NULL;
		END IF;
		denorm_ond_ond (p_ond, r_ond);
	END;

	PROCEDURE insert_odd (p_odd IN OUT NOCOPY v_onderdeel_deel%ROWTYPE) IS
	BEGIN
		p_odd.cube_id := 'ODD-' || TO_CHAR(sq_odd.NEXTVAL,'FM000000000000');
		p_odd.fk_prd_cube_tsg_type := NVL(p_odd.fk_prd_cube_tsg_type,' ');
		p_odd.fk_prd_code := NVL(p_odd.fk_prd_code,' ');
		p_odd.fk_ond_code := NVL(p_odd.fk_ond_code,' ');
		p_odd.code := NVL(p_odd.code,' ');
		INSERT INTO t_onderdeel_deel (
			cube_id,
			cube_sequence,
			fk_prd_cube_tsg_type,
			fk_prd_code,
			fk_ond_code,
			code,
			naam)
		VALUES (
			p_odd.cube_id,
			p_odd.cube_sequence,
			p_odd.fk_prd_cube_tsg_type,
			p_odd.fk_prd_code,
			p_odd.fk_ond_code,
			p_odd.code,
			p_odd.naam);
	END;

	PROCEDURE update_odd (p_cube_rowid UROWID, p_odd_old IN OUT NOCOPY v_onderdeel_deel%ROWTYPE, p_odd_new IN OUT NOCOPY v_onderdeel_deel%ROWTYPE) IS
	BEGIN
		UPDATE t_onderdeel_deel SET 
			cube_sequence = p_odd_new.cube_sequence,
			naam = p_odd_new.naam
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_odd (p_cube_rowid UROWID, p_odd IN OUT NOCOPY v_onderdeel_deel%ROWTYPE) IS
	BEGIN
		DELETE t_onderdeel_deel 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_ddd (p_ddd IN OUT NOCOPY v_onderdeel_deel_deel%ROWTYPE) IS
	BEGIN
		p_ddd.cube_id := 'DDD-' || TO_CHAR(sq_ddd.NEXTVAL,'FM000000000000');
		p_ddd.fk_prd_cube_tsg_type := NVL(p_ddd.fk_prd_cube_tsg_type,' ');
		p_ddd.fk_prd_code := NVL(p_ddd.fk_prd_code,' ');
		p_ddd.fk_ond_code := NVL(p_ddd.fk_ond_code,' ');
		p_ddd.fk_odd_code := NVL(p_ddd.fk_odd_code,' ');
		p_ddd.code := NVL(p_ddd.code,' ');
		SELECT fk_prd_cube_tsg_type, fk_prd_code, fk_ond_code
		  INTO p_ddd.fk_prd_cube_tsg_type, p_ddd.fk_prd_code, p_ddd.fk_ond_code
		FROM t_onderdeel_deel
		WHERE code = p_ddd.fk_odd_code;
		INSERT INTO t_onderdeel_deel_deel (
			cube_id,
			cube_sequence,
			fk_prd_cube_tsg_type,
			fk_prd_code,
			fk_ond_code,
			fk_odd_code,
			code,
			naam)
		VALUES (
			p_ddd.cube_id,
			p_ddd.cube_sequence,
			p_ddd.fk_prd_cube_tsg_type,
			p_ddd.fk_prd_code,
			p_ddd.fk_ond_code,
			p_ddd.fk_odd_code,
			p_ddd.code,
			p_ddd.naam);
	END;

	PROCEDURE update_ddd (p_cube_rowid UROWID, p_ddd_old IN OUT NOCOPY v_onderdeel_deel_deel%ROWTYPE, p_ddd_new IN OUT NOCOPY v_onderdeel_deel_deel%ROWTYPE) IS
	BEGIN
		UPDATE t_onderdeel_deel_deel SET 
			cube_sequence = p_ddd_new.cube_sequence,
			naam = p_ddd_new.naam
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_ddd (p_cube_rowid UROWID, p_ddd IN OUT NOCOPY v_onderdeel_deel_deel%ROWTYPE) IS
	BEGIN
		DELETE t_onderdeel_deel_deel 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_cst (p_cst IN OUT NOCOPY v_constructie%ROWTYPE) IS
	BEGIN
		p_cst.cube_id := 'CST-' || TO_CHAR(sq_cst.NEXTVAL,'FM000000000000');
		p_cst.fk_prd_cube_tsg_type := NVL(p_cst.fk_prd_cube_tsg_type,' ');
		p_cst.fk_prd_code := NVL(p_cst.fk_prd_code,' ');
		p_cst.fk_ond_code := NVL(p_cst.fk_ond_code,' ');
		p_cst.code := NVL(p_cst.code,' ');
		p_cst.xk_odd_code := NVL(p_cst.xk_odd_code,' ');
		p_cst.xk_odd_code_1 := NVL(p_cst.xk_odd_code_1,' ');
		INSERT INTO t_constructie (
			cube_id,
			fk_prd_cube_tsg_type,
			fk_prd_code,
			fk_ond_code,
			code,
			omschrijving,
			xk_odd_code,
			xk_odd_code_1)
		VALUES (
			p_cst.cube_id,
			p_cst.fk_prd_cube_tsg_type,
			p_cst.fk_prd_code,
			p_cst.fk_ond_code,
			p_cst.code,
			p_cst.omschrijving,
			p_cst.xk_odd_code,
			p_cst.xk_odd_code_1);
	END;

	PROCEDURE update_cst (p_cube_rowid UROWID, p_cst_old IN OUT NOCOPY v_constructie%ROWTYPE, p_cst_new IN OUT NOCOPY v_constructie%ROWTYPE) IS
	BEGIN
		UPDATE t_constructie SET 
			omschrijving = p_cst_new.omschrijving,
			xk_odd_code = p_cst_new.xk_odd_code,
			xk_odd_code_1 = p_cst_new.xk_odd_code_1
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_cst (p_cube_rowid UROWID, p_cst IN OUT NOCOPY v_constructie%ROWTYPE) IS
	BEGIN
		DELETE t_constructie 
		WHERE rowid = p_cube_rowid;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_prd
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_produkt
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_prd_new v_produkt%ROWTYPE;
	r_prd_old v_produkt%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		IF :NEW.cube_tsg_type = ' ' THEN
			r_prd_new.cube_tsg_type := ' ';
		ELSE
			r_prd_new.cube_tsg_type := REPLACE(:NEW.cube_tsg_type,' ','_');
		END IF;
		IF :NEW.cube_tsg_soort = ' ' THEN
			r_prd_new.cube_tsg_soort := ' ';
		ELSE
			r_prd_new.cube_tsg_soort := REPLACE(:NEW.cube_tsg_soort,' ','_');
		END IF;
		IF :NEW.cube_tsg_soort1 = ' ' THEN
			r_prd_new.cube_tsg_soort1 := ' ';
		ELSE
			r_prd_new.cube_tsg_soort1 := REPLACE(:NEW.cube_tsg_soort1,' ','_');
		END IF;
		IF :NEW.code = ' ' THEN
			r_prd_new.code := ' ';
		ELSE
			r_prd_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_prd_new.prijs := :NEW.prijs;
		r_prd_new.makelaar_naam := :NEW.makelaar_naam;
		r_prd_new.bedrag_btw := :NEW.bedrag_btw;
	END IF;
	IF UPDATING THEN
		r_prd_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_produkt
		WHERE cube_tsg_type = :OLD.cube_tsg_type
		  AND code = :OLD.code;
		r_prd_old.cube_tsg_type := :OLD.cube_tsg_type;
		r_prd_old.cube_tsg_soort := :OLD.cube_tsg_soort;
		r_prd_old.cube_tsg_soort1 := :OLD.cube_tsg_soort1;
		r_prd_old.code := :OLD.code;
		r_prd_old.prijs := :OLD.prijs;
		r_prd_old.makelaar_naam := :OLD.makelaar_naam;
		r_prd_old.bedrag_btw := :OLD.bedrag_btw;
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

CREATE OR REPLACE TRIGGER trg_ond
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_onderdeel
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_ond_new v_onderdeel%ROWTYPE;
	r_ond_old v_onderdeel%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_ond_new.cube_sequence := :NEW.cube_sequence;
		IF :NEW.fk_prd_cube_tsg_type = ' ' THEN
			r_ond_new.fk_prd_cube_tsg_type := ' ';
		ELSE
			r_ond_new.fk_prd_cube_tsg_type := REPLACE(:NEW.fk_prd_cube_tsg_type,' ','_');
		END IF;
		IF :NEW.fk_prd_code = ' ' THEN
			r_ond_new.fk_prd_code := ' ';
		ELSE
			r_ond_new.fk_prd_code := REPLACE(:NEW.fk_prd_code,' ','_');
		END IF;
		IF :NEW.fk_ond_code = ' ' THEN
			r_ond_new.fk_ond_code := ' ';
		ELSE
			r_ond_new.fk_ond_code := REPLACE(:NEW.fk_ond_code,' ','_');
		END IF;
		IF :NEW.code = ' ' THEN
			r_ond_new.code := ' ';
		ELSE
			r_ond_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_ond_new.prijs := :NEW.prijs;
		r_ond_new.omschrijving := :NEW.omschrijving;
	END IF;
	IF UPDATING THEN
		r_ond_new.cube_id := :OLD.cube_id;
		r_ond_new.cube_level := :OLD.cube_level;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_onderdeel
		WHERE fk_prd_cube_tsg_type = :OLD.fk_prd_cube_tsg_type
		  AND fk_prd_code = :OLD.fk_prd_code
		  AND code = :OLD.code;
		r_ond_old.cube_sequence := :OLD.cube_sequence;
		r_ond_old.fk_prd_cube_tsg_type := :OLD.fk_prd_cube_tsg_type;
		r_ond_old.fk_prd_code := :OLD.fk_prd_code;
		r_ond_old.fk_ond_code := :OLD.fk_ond_code;
		r_ond_old.code := :OLD.code;
		r_ond_old.prijs := :OLD.prijs;
		r_ond_old.omschrijving := :OLD.omschrijving;
	END IF;

	IF INSERTING THEN 
		pkg_prd_trg.insert_ond (r_ond_new);
	ELSIF UPDATING THEN
		pkg_prd_trg.update_ond (l_cube_rowid, r_ond_old, r_ond_new);
	ELSIF DELETING THEN
		pkg_prd_trg.delete_ond (l_cube_rowid, r_ond_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_odd
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_onderdeel_deel
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_odd_new v_onderdeel_deel%ROWTYPE;
	r_odd_old v_onderdeel_deel%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_odd_new.cube_sequence := :NEW.cube_sequence;
		IF :NEW.fk_prd_cube_tsg_type = ' ' THEN
			r_odd_new.fk_prd_cube_tsg_type := ' ';
		ELSE
			r_odd_new.fk_prd_cube_tsg_type := REPLACE(:NEW.fk_prd_cube_tsg_type,' ','_');
		END IF;
		IF :NEW.fk_prd_code = ' ' THEN
			r_odd_new.fk_prd_code := ' ';
		ELSE
			r_odd_new.fk_prd_code := REPLACE(:NEW.fk_prd_code,' ','_');
		END IF;
		IF :NEW.fk_ond_code = ' ' THEN
			r_odd_new.fk_ond_code := ' ';
		ELSE
			r_odd_new.fk_ond_code := REPLACE(:NEW.fk_ond_code,' ','_');
		END IF;
		IF :NEW.code = ' ' THEN
			r_odd_new.code := ' ';
		ELSE
			r_odd_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_odd_new.naam := :NEW.naam;
	END IF;
	IF UPDATING THEN
		r_odd_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_onderdeel_deel
		WHERE code = :OLD.code;
		r_odd_old.cube_sequence := :OLD.cube_sequence;
		r_odd_old.fk_prd_cube_tsg_type := :OLD.fk_prd_cube_tsg_type;
		r_odd_old.fk_prd_code := :OLD.fk_prd_code;
		r_odd_old.fk_ond_code := :OLD.fk_ond_code;
		r_odd_old.code := :OLD.code;
		r_odd_old.naam := :OLD.naam;
	END IF;

	IF INSERTING THEN 
		pkg_prd_trg.insert_odd (r_odd_new);
	ELSIF UPDATING THEN
		pkg_prd_trg.update_odd (l_cube_rowid, r_odd_old, r_odd_new);
	ELSIF DELETING THEN
		pkg_prd_trg.delete_odd (l_cube_rowid, r_odd_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_ddd
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_onderdeel_deel_deel
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_ddd_new v_onderdeel_deel_deel%ROWTYPE;
	r_ddd_old v_onderdeel_deel_deel%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_ddd_new.cube_sequence := :NEW.cube_sequence;
		IF :NEW.fk_prd_cube_tsg_type = ' ' THEN
			r_ddd_new.fk_prd_cube_tsg_type := ' ';
		ELSE
			r_ddd_new.fk_prd_cube_tsg_type := REPLACE(:NEW.fk_prd_cube_tsg_type,' ','_');
		END IF;
		IF :NEW.fk_prd_code = ' ' THEN
			r_ddd_new.fk_prd_code := ' ';
		ELSE
			r_ddd_new.fk_prd_code := REPLACE(:NEW.fk_prd_code,' ','_');
		END IF;
		IF :NEW.fk_ond_code = ' ' THEN
			r_ddd_new.fk_ond_code := ' ';
		ELSE
			r_ddd_new.fk_ond_code := REPLACE(:NEW.fk_ond_code,' ','_');
		END IF;
		IF :NEW.fk_odd_code = ' ' THEN
			r_ddd_new.fk_odd_code := ' ';
		ELSE
			r_ddd_new.fk_odd_code := REPLACE(:NEW.fk_odd_code,' ','_');
		END IF;
		IF :NEW.code = ' ' THEN
			r_ddd_new.code := ' ';
		ELSE
			r_ddd_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_ddd_new.naam := :NEW.naam;
	END IF;
	IF UPDATING THEN
		r_ddd_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_onderdeel_deel_deel
		WHERE code = :OLD.code;
		r_ddd_old.cube_sequence := :OLD.cube_sequence;
		r_ddd_old.fk_prd_cube_tsg_type := :OLD.fk_prd_cube_tsg_type;
		r_ddd_old.fk_prd_code := :OLD.fk_prd_code;
		r_ddd_old.fk_ond_code := :OLD.fk_ond_code;
		r_ddd_old.fk_odd_code := :OLD.fk_odd_code;
		r_ddd_old.code := :OLD.code;
		r_ddd_old.naam := :OLD.naam;
	END IF;

	IF INSERTING THEN 
		pkg_prd_trg.insert_ddd (r_ddd_new);
	ELSIF UPDATING THEN
		pkg_prd_trg.update_ddd (l_cube_rowid, r_ddd_old, r_ddd_new);
	ELSIF DELETING THEN
		pkg_prd_trg.delete_ddd (l_cube_rowid, r_ddd_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_cst
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_constructie
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_cst_new v_constructie%ROWTYPE;
	r_cst_old v_constructie%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		IF :NEW.fk_prd_cube_tsg_type = ' ' THEN
			r_cst_new.fk_prd_cube_tsg_type := ' ';
		ELSE
			r_cst_new.fk_prd_cube_tsg_type := REPLACE(:NEW.fk_prd_cube_tsg_type,' ','_');
		END IF;
		IF :NEW.fk_prd_code = ' ' THEN
			r_cst_new.fk_prd_code := ' ';
		ELSE
			r_cst_new.fk_prd_code := REPLACE(:NEW.fk_prd_code,' ','_');
		END IF;
		IF :NEW.fk_ond_code = ' ' THEN
			r_cst_new.fk_ond_code := ' ';
		ELSE
			r_cst_new.fk_ond_code := REPLACE(:NEW.fk_ond_code,' ','_');
		END IF;
		IF :NEW.code = ' ' THEN
			r_cst_new.code := ' ';
		ELSE
			r_cst_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_cst_new.omschrijving := :NEW.omschrijving;
		IF :NEW.xk_odd_code = ' ' THEN
			r_cst_new.xk_odd_code := ' ';
		ELSE
			r_cst_new.xk_odd_code := REPLACE(:NEW.xk_odd_code,' ','_');
		END IF;
		IF :NEW.xk_odd_code_1 = ' ' THEN
			r_cst_new.xk_odd_code_1 := ' ';
		ELSE
			r_cst_new.xk_odd_code_1 := REPLACE(:NEW.xk_odd_code_1,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_cst_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_constructie
		WHERE fk_prd_cube_tsg_type = :OLD.fk_prd_cube_tsg_type
		  AND fk_prd_code = :OLD.fk_prd_code
		  AND fk_ond_code = :OLD.fk_ond_code
		  AND code = :OLD.code;
		r_cst_old.fk_prd_cube_tsg_type := :OLD.fk_prd_cube_tsg_type;
		r_cst_old.fk_prd_code := :OLD.fk_prd_code;
		r_cst_old.fk_ond_code := :OLD.fk_ond_code;
		r_cst_old.code := :OLD.code;
		r_cst_old.omschrijving := :OLD.omschrijving;
		r_cst_old.xk_odd_code := :OLD.xk_odd_code;
		r_cst_old.xk_odd_code_1 := :OLD.xk_odd_code_1;
	END IF;

	IF INSERTING THEN 
		pkg_prd_trg.insert_cst (r_cst_new);
	ELSIF UPDATING THEN
		pkg_prd_trg.update_cst (l_cube_rowid, r_cst_old, r_cst_new);
	ELSIF DELETING THEN
		pkg_prd_trg.delete_cst (l_cube_rowid, r_cst_old);
	END IF;
END;
/
SHOW ERRORS

EXIT;