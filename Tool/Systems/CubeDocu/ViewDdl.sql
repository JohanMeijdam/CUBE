-- DB VIEW DDL
--
CREATE OR REPLACE VIEW v_information_type AS 
	SELECT
		cube_id,
		name
	FROM t_information_type
/
CREATE OR REPLACE VIEW v_information_type_element AS 
	SELECT
		cube_id,
		fk_itp_name,
		sequence,
		suffix,
		domain,
		length,
		decimals,
		case_sensitive,
		default_value,
		spaces_allowed,
		presentation
	FROM t_information_type_element
/
CREATE OR REPLACE VIEW v_permitted_value AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_itp_name,
		fk_ite_sequence,
		code,
		prompt
	FROM t_permitted_value
/

CREATE OR REPLACE PACKAGE pkg_itp_trg IS
	PROCEDURE insert_itp (p_itp IN OUT NOCOPY v_information_type%ROWTYPE);
	PROCEDURE update_itp (p_cube_rowid IN UROWID, p_itp_old IN OUT NOCOPY v_information_type%ROWTYPE, p_itp_new IN OUT NOCOPY v_information_type%ROWTYPE);
	PROCEDURE delete_itp (p_cube_rowid IN UROWID, p_itp IN OUT NOCOPY v_information_type%ROWTYPE);
	PROCEDURE insert_ite (p_ite IN OUT NOCOPY v_information_type_element%ROWTYPE);
	PROCEDURE update_ite (p_cube_rowid IN UROWID, p_ite_old IN OUT NOCOPY v_information_type_element%ROWTYPE, p_ite_new IN OUT NOCOPY v_information_type_element%ROWTYPE);
	PROCEDURE delete_ite (p_cube_rowid IN UROWID, p_ite IN OUT NOCOPY v_information_type_element%ROWTYPE);
	PROCEDURE insert_val (p_val IN OUT NOCOPY v_permitted_value%ROWTYPE);
	PROCEDURE update_val (p_cube_rowid IN UROWID, p_val_old IN OUT NOCOPY v_permitted_value%ROWTYPE, p_val_new IN OUT NOCOPY v_permitted_value%ROWTYPE);
	PROCEDURE delete_val (p_cube_rowid IN UROWID, p_val IN OUT NOCOPY v_permitted_value%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_itp_trg IS

	PROCEDURE insert_itp (p_itp IN OUT NOCOPY v_information_type%ROWTYPE) IS
	BEGIN
		p_itp.cube_id := 'ITP-' || TO_CHAR(itp_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_information_type (
			cube_id,
			name)
		VALUES (
			p_itp.cube_id,
			p_itp.name);
	END;

	PROCEDURE update_itp (p_cube_rowid UROWID, p_itp_old IN OUT NOCOPY v_information_type%ROWTYPE, p_itp_new IN OUT NOCOPY v_information_type%ROWTYPE) IS
	BEGIN
		NULL;
	END;

	PROCEDURE delete_itp (p_cube_rowid UROWID, p_itp IN OUT NOCOPY v_information_type%ROWTYPE) IS
	BEGIN
		DELETE t_information_type 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_ite (p_ite IN OUT NOCOPY v_information_type_element%ROWTYPE) IS
	BEGIN
		p_ite.cube_id := 'ITE-' || TO_CHAR(ite_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_information_type_element (
			cube_id,
			fk_itp_name,
			sequence,
			suffix,
			domain,
			length,
			decimals,
			case_sensitive,
			default_value,
			spaces_allowed,
			presentation)
		VALUES (
			p_ite.cube_id,
			p_ite.fk_itp_name,
			p_ite.sequence,
			p_ite.suffix,
			p_ite.domain,
			p_ite.length,
			p_ite.decimals,
			p_ite.case_sensitive,
			p_ite.default_value,
			p_ite.spaces_allowed,
			p_ite.presentation);
	END;

	PROCEDURE update_ite (p_cube_rowid UROWID, p_ite_old IN OUT NOCOPY v_information_type_element%ROWTYPE, p_ite_new IN OUT NOCOPY v_information_type_element%ROWTYPE) IS
	BEGIN
		UPDATE t_information_type_element SET 
			suffix = p_ite_new.suffix,
			domain = p_ite_new.domain,
			length = p_ite_new.length,
			decimals = p_ite_new.decimals,
			case_sensitive = p_ite_new.case_sensitive,
			default_value = p_ite_new.default_value,
			spaces_allowed = p_ite_new.spaces_allowed,
			presentation = p_ite_new.presentation
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_ite (p_cube_rowid UROWID, p_ite IN OUT NOCOPY v_information_type_element%ROWTYPE) IS
	BEGIN
		DELETE t_information_type_element 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_val (p_val IN OUT NOCOPY v_permitted_value%ROWTYPE) IS
	BEGIN
		p_val.cube_id := 'VAL-' || TO_CHAR(val_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_permitted_value (
			cube_id,
			cube_sequence,
			fk_itp_name,
			fk_ite_sequence,
			code,
			prompt)
		VALUES (
			p_val.cube_id,
			p_val.cube_sequence,
			p_val.fk_itp_name,
			p_val.fk_ite_sequence,
			p_val.code,
			p_val.prompt);
	END;

	PROCEDURE update_val (p_cube_rowid UROWID, p_val_old IN OUT NOCOPY v_permitted_value%ROWTYPE, p_val_new IN OUT NOCOPY v_permitted_value%ROWTYPE) IS
	BEGIN
		UPDATE t_permitted_value SET 
			cube_sequence = p_val_new.cube_sequence,
			prompt = p_val_new.prompt
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_val (p_cube_rowid UROWID, p_val IN OUT NOCOPY v_permitted_value%ROWTYPE) IS
	BEGIN
		DELETE t_permitted_value 
		WHERE rowid = p_cube_rowid;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_itp
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_information_type
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_itp_new v_information_type%ROWTYPE;
	r_itp_old v_information_type%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_itp_new.name := REPLACE(:NEW.name,' ','_');
	END IF;
	IF UPDATING THEN
		r_itp_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_information_type
		WHERE name = :OLD.name;
		r_itp_old.name := :OLD.name;
	END IF;

	IF INSERTING THEN 
		pkg_itp_trg.insert_itp (r_itp_new);
	ELSIF UPDATING THEN
		pkg_itp_trg.update_itp (l_cube_rowid, r_itp_old, r_itp_new);
	ELSIF DELETING THEN
		pkg_itp_trg.delete_itp (l_cube_rowid, r_itp_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_ite
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_information_type_element
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_ite_new v_information_type_element%ROWTYPE;
	r_ite_old v_information_type_element%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_ite_new.fk_itp_name := REPLACE(:NEW.fk_itp_name,' ','_');
		r_ite_new.sequence := :NEW.sequence;
		r_ite_new.suffix := REPLACE(:NEW.suffix,' ','_');
		r_ite_new.domain := REPLACE(:NEW.domain,' ','_');
		r_ite_new.length := :NEW.length;
		r_ite_new.decimals := :NEW.decimals;
		r_ite_new.case_sensitive := :NEW.case_sensitive;
		r_ite_new.default_value := :NEW.default_value;
		r_ite_new.spaces_allowed := :NEW.spaces_allowed;
		r_ite_new.presentation := REPLACE(:NEW.presentation,' ','_');
	END IF;
	IF UPDATING THEN
		r_ite_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_information_type_element
		WHERE fk_itp_name = :OLD.fk_itp_name
		  AND sequence = :OLD.sequence;
		r_ite_old.fk_itp_name := :OLD.fk_itp_name;
		r_ite_old.sequence := :OLD.sequence;
		r_ite_old.suffix := :OLD.suffix;
		r_ite_old.domain := :OLD.domain;
		r_ite_old.length := :OLD.length;
		r_ite_old.decimals := :OLD.decimals;
		r_ite_old.case_sensitive := :OLD.case_sensitive;
		r_ite_old.default_value := :OLD.default_value;
		r_ite_old.spaces_allowed := :OLD.spaces_allowed;
		r_ite_old.presentation := :OLD.presentation;
	END IF;

	IF INSERTING THEN 
		pkg_itp_trg.insert_ite (r_ite_new);
	ELSIF UPDATING THEN
		pkg_itp_trg.update_ite (l_cube_rowid, r_ite_old, r_ite_new);
	ELSIF DELETING THEN
		pkg_itp_trg.delete_ite (l_cube_rowid, r_ite_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_val
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_permitted_value
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_val_new v_permitted_value%ROWTYPE;
	r_val_old v_permitted_value%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_val_new.cube_sequence := :NEW.cube_sequence;
		r_val_new.fk_itp_name := REPLACE(:NEW.fk_itp_name,' ','_');
		r_val_new.fk_ite_sequence := :NEW.fk_ite_sequence;
		r_val_new.code := REPLACE(:NEW.code,' ','_');
		r_val_new.prompt := :NEW.prompt;
	END IF;
	IF UPDATING THEN
		r_val_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_permitted_value
		WHERE fk_itp_name = :OLD.fk_itp_name
		  AND fk_ite_sequence = :OLD.fk_ite_sequence
		  AND code = :OLD.code;
		r_val_old.cube_sequence := :OLD.cube_sequence;
		r_val_old.fk_itp_name := :OLD.fk_itp_name;
		r_val_old.fk_ite_sequence := :OLD.fk_ite_sequence;
		r_val_old.code := :OLD.code;
		r_val_old.prompt := :OLD.prompt;
	END IF;

	IF INSERTING THEN 
		pkg_itp_trg.insert_val (r_val_new);
	ELSIF UPDATING THEN
		pkg_itp_trg.update_val (l_cube_rowid, r_val_old, r_val_new);
	ELSIF DELETING THEN
		pkg_itp_trg.delete_val (l_cube_rowid, r_val_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE VIEW v_business_object_type AS 
	SELECT
		cube_id,
		cube_sequence,
		name,
		directory
	FROM t_business_object_type
/
CREATE OR REPLACE VIEW v_type AS 
	SELECT
		cube_id,
		cube_sequence,
		cube_level,
		fk_bot_name,
		fk_typ_name,
		name,
		code,
		flag_partial_key,
		flag_recursive,
		recursive_cardinality,
		cardinality,
		sort_order,
		icon,
		transferable
	FROM t_type
/
CREATE OR REPLACE VIEW v_attribute AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_bot_name,
		fk_typ_name,
		name,
		primary_key,
		code_display_key,
		code_foreign_key,
		flag_hidden,
		default_value,
		unchangeable,
		xk_itp_name
	FROM t_attribute
/
CREATE OR REPLACE VIEW v_derivation AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_atb_name,
		cube_tsg_type,
		aggregate_function,
		xk_typ_name,
		xk_typ_name_1
	FROM t_derivation
/
CREATE OR REPLACE VIEW v_description_attribute AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_atb_name,
		text
	FROM t_description_attribute
/
CREATE OR REPLACE VIEW v_restriction_type_spec_atb AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_atb_name,
		include_or_exclude,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM t_restriction_type_spec_atb
/
CREATE OR REPLACE VIEW v_reference AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_bot_name,
		fk_typ_name,
		name,
		primary_key,
		code_display_key,
		sequence,
		scope,
		unchangeable,
		within_scope_level,
		xk_typ_name,
		xk_typ_name_1
	FROM t_reference
/
CREATE OR REPLACE VIEW v_description_reference AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_ref_sequence,
		fk_ref_typ_name,
		text
	FROM t_description_reference
/
CREATE OR REPLACE VIEW v_restriction_type_spec_ref AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_ref_sequence,
		fk_ref_typ_name,
		include_or_exclude,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM t_restriction_type_spec_ref
/
CREATE OR REPLACE VIEW v_type_reuse AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		cardinality,
		xk_typ_name
	FROM t_type_reuse
/
CREATE OR REPLACE VIEW v_partition AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		name
	FROM t_partition
/
CREATE OR REPLACE VIEW v_subtype AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_bot_name,
		fk_typ_name,
		fk_par_name,
		name
	FROM t_subtype
/
CREATE OR REPLACE VIEW v_type_specialisation_group AS 
	SELECT
		cube_id,
		cube_sequence,
		cube_level,
		fk_bot_name,
		fk_typ_name,
		fk_tsg_code,
		code,
		name,
		primary_key
	FROM t_type_specialisation_group
/
CREATE OR REPLACE VIEW v_type_specialisation AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_bot_name,
		fk_typ_name,
		fk_tsg_code,
		code,
		name,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM t_type_specialisation
/
CREATE OR REPLACE VIEW v_description_type AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		text
	FROM t_description_type
/

CREATE OR REPLACE PACKAGE pkg_bot_trg IS
	PROCEDURE insert_bot (p_bot IN OUT NOCOPY v_business_object_type%ROWTYPE);
	PROCEDURE update_bot (p_cube_rowid IN UROWID, p_bot_old IN OUT NOCOPY v_business_object_type%ROWTYPE, p_bot_new IN OUT NOCOPY v_business_object_type%ROWTYPE);
	PROCEDURE delete_bot (p_cube_rowid IN UROWID, p_bot IN OUT NOCOPY v_business_object_type%ROWTYPE);
	PROCEDURE insert_typ (p_typ IN OUT NOCOPY v_type%ROWTYPE);
	PROCEDURE update_typ (p_cube_rowid IN UROWID, p_typ_old IN OUT NOCOPY v_type%ROWTYPE, p_typ_new IN OUT NOCOPY v_type%ROWTYPE);
	PROCEDURE delete_typ (p_cube_rowid IN UROWID, p_typ IN OUT NOCOPY v_type%ROWTYPE);
	PROCEDURE denorm_typ_typ (p_typ IN OUT NOCOPY v_type%ROWTYPE, p_typ_in IN v_type%ROWTYPE);
	PROCEDURE get_denorm_typ_typ (p_typ IN OUT NOCOPY v_type%ROWTYPE);
	PROCEDURE insert_atb (p_atb IN OUT NOCOPY v_attribute%ROWTYPE);
	PROCEDURE update_atb (p_cube_rowid IN UROWID, p_atb_old IN OUT NOCOPY v_attribute%ROWTYPE, p_atb_new IN OUT NOCOPY v_attribute%ROWTYPE);
	PROCEDURE delete_atb (p_cube_rowid IN UROWID, p_atb IN OUT NOCOPY v_attribute%ROWTYPE);
	PROCEDURE insert_der (p_der IN OUT NOCOPY v_derivation%ROWTYPE);
	PROCEDURE update_der (p_cube_rowid IN UROWID, p_der_old IN OUT NOCOPY v_derivation%ROWTYPE, p_der_new IN OUT NOCOPY v_derivation%ROWTYPE);
	PROCEDURE delete_der (p_cube_rowid IN UROWID, p_der IN OUT NOCOPY v_derivation%ROWTYPE);
	PROCEDURE insert_dca (p_dca IN OUT NOCOPY v_description_attribute%ROWTYPE);
	PROCEDURE update_dca (p_cube_rowid IN UROWID, p_dca_old IN OUT NOCOPY v_description_attribute%ROWTYPE, p_dca_new IN OUT NOCOPY v_description_attribute%ROWTYPE);
	PROCEDURE delete_dca (p_cube_rowid IN UROWID, p_dca IN OUT NOCOPY v_description_attribute%ROWTYPE);
	PROCEDURE insert_rta (p_rta IN OUT NOCOPY v_restriction_type_spec_atb%ROWTYPE);
	PROCEDURE update_rta (p_cube_rowid IN UROWID, p_rta_old IN OUT NOCOPY v_restriction_type_spec_atb%ROWTYPE, p_rta_new IN OUT NOCOPY v_restriction_type_spec_atb%ROWTYPE);
	PROCEDURE delete_rta (p_cube_rowid IN UROWID, p_rta IN OUT NOCOPY v_restriction_type_spec_atb%ROWTYPE);
	PROCEDURE insert_ref (p_ref IN OUT NOCOPY v_reference%ROWTYPE);
	PROCEDURE update_ref (p_cube_rowid IN UROWID, p_ref_old IN OUT NOCOPY v_reference%ROWTYPE, p_ref_new IN OUT NOCOPY v_reference%ROWTYPE);
	PROCEDURE delete_ref (p_cube_rowid IN UROWID, p_ref IN OUT NOCOPY v_reference%ROWTYPE);
	PROCEDURE insert_dcr (p_dcr IN OUT NOCOPY v_description_reference%ROWTYPE);
	PROCEDURE update_dcr (p_cube_rowid IN UROWID, p_dcr_old IN OUT NOCOPY v_description_reference%ROWTYPE, p_dcr_new IN OUT NOCOPY v_description_reference%ROWTYPE);
	PROCEDURE delete_dcr (p_cube_rowid IN UROWID, p_dcr IN OUT NOCOPY v_description_reference%ROWTYPE);
	PROCEDURE insert_rtr (p_rtr IN OUT NOCOPY v_restriction_type_spec_ref%ROWTYPE);
	PROCEDURE update_rtr (p_cube_rowid IN UROWID, p_rtr_old IN OUT NOCOPY v_restriction_type_spec_ref%ROWTYPE, p_rtr_new IN OUT NOCOPY v_restriction_type_spec_ref%ROWTYPE);
	PROCEDURE delete_rtr (p_cube_rowid IN UROWID, p_rtr IN OUT NOCOPY v_restriction_type_spec_ref%ROWTYPE);
	PROCEDURE insert_tyr (p_tyr IN OUT NOCOPY v_type_reuse%ROWTYPE);
	PROCEDURE update_tyr (p_cube_rowid IN UROWID, p_tyr_old IN OUT NOCOPY v_type_reuse%ROWTYPE, p_tyr_new IN OUT NOCOPY v_type_reuse%ROWTYPE);
	PROCEDURE delete_tyr (p_cube_rowid IN UROWID, p_tyr IN OUT NOCOPY v_type_reuse%ROWTYPE);
	PROCEDURE insert_par (p_par IN OUT NOCOPY v_partition%ROWTYPE);
	PROCEDURE update_par (p_cube_rowid IN UROWID, p_par_old IN OUT NOCOPY v_partition%ROWTYPE, p_par_new IN OUT NOCOPY v_partition%ROWTYPE);
	PROCEDURE delete_par (p_cube_rowid IN UROWID, p_par IN OUT NOCOPY v_partition%ROWTYPE);
	PROCEDURE insert_stp (p_stp IN OUT NOCOPY v_subtype%ROWTYPE);
	PROCEDURE update_stp (p_cube_rowid IN UROWID, p_stp_old IN OUT NOCOPY v_subtype%ROWTYPE, p_stp_new IN OUT NOCOPY v_subtype%ROWTYPE);
	PROCEDURE delete_stp (p_cube_rowid IN UROWID, p_stp IN OUT NOCOPY v_subtype%ROWTYPE);
	PROCEDURE insert_tsg (p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE);
	PROCEDURE update_tsg (p_cube_rowid IN UROWID, p_tsg_old IN OUT NOCOPY v_type_specialisation_group%ROWTYPE, p_tsg_new IN OUT NOCOPY v_type_specialisation_group%ROWTYPE);
	PROCEDURE delete_tsg (p_cube_rowid IN UROWID, p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE);
	PROCEDURE denorm_tsg_tsg (p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE, p_tsg_in IN v_type_specialisation_group%ROWTYPE);
	PROCEDURE get_denorm_tsg_tsg (p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE);
	PROCEDURE insert_tsp (p_tsp IN OUT NOCOPY v_type_specialisation%ROWTYPE);
	PROCEDURE update_tsp (p_cube_rowid IN UROWID, p_tsp_old IN OUT NOCOPY v_type_specialisation%ROWTYPE, p_tsp_new IN OUT NOCOPY v_type_specialisation%ROWTYPE);
	PROCEDURE delete_tsp (p_cube_rowid IN UROWID, p_tsp IN OUT NOCOPY v_type_specialisation%ROWTYPE);
	PROCEDURE insert_dct (p_dct IN OUT NOCOPY v_description_type%ROWTYPE);
	PROCEDURE update_dct (p_cube_rowid IN UROWID, p_dct_old IN OUT NOCOPY v_description_type%ROWTYPE, p_dct_new IN OUT NOCOPY v_description_type%ROWTYPE);
	PROCEDURE delete_dct (p_cube_rowid IN UROWID, p_dct IN OUT NOCOPY v_description_type%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_bot_trg IS

	PROCEDURE insert_bot (p_bot IN OUT NOCOPY v_business_object_type%ROWTYPE) IS
	BEGIN
		p_bot.cube_id := 'BOT-' || TO_CHAR(bot_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_business_object_type (
			cube_id,
			cube_sequence,
			name,
			directory)
		VALUES (
			p_bot.cube_id,
			p_bot.cube_sequence,
			p_bot.name,
			p_bot.directory);
	END;

	PROCEDURE update_bot (p_cube_rowid UROWID, p_bot_old IN OUT NOCOPY v_business_object_type%ROWTYPE, p_bot_new IN OUT NOCOPY v_business_object_type%ROWTYPE) IS
	BEGIN
		UPDATE t_business_object_type SET 
			cube_sequence = p_bot_new.cube_sequence,
			directory = p_bot_new.directory
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_bot (p_cube_rowid UROWID, p_bot IN OUT NOCOPY v_business_object_type%ROWTYPE) IS
	BEGIN
		DELETE t_business_object_type 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_typ (p_typ IN OUT NOCOPY v_type%ROWTYPE) IS
	BEGIN
		p_typ.cube_id := 'TYP-' || TO_CHAR(typ_seq.NEXTVAL,'FM000000000000');
		IF p_typ.fk_typ_name IS NOT NULL  THEN
			-- Recursive
			SELECT fk_bot_name
			  INTO p_typ.fk_bot_name
			FROM t_type
			WHERE name = p_typ.fk_typ_name;
		END IF;
		get_denorm_typ_typ (p_typ);
		INSERT INTO t_type (
			cube_id,
			cube_sequence,
			cube_level,
			fk_bot_name,
			fk_typ_name,
			name,
			code,
			flag_partial_key,
			flag_recursive,
			recursive_cardinality,
			cardinality,
			sort_order,
			icon,
			transferable)
		VALUES (
			p_typ.cube_id,
			p_typ.cube_sequence,
			p_typ.cube_level,
			p_typ.fk_bot_name,
			p_typ.fk_typ_name,
			p_typ.name,
			p_typ.code,
			p_typ.flag_partial_key,
			p_typ.flag_recursive,
			p_typ.recursive_cardinality,
			p_typ.cardinality,
			p_typ.sort_order,
			p_typ.icon,
			p_typ.transferable);
	END;

	PROCEDURE update_typ (p_cube_rowid UROWID, p_typ_old IN OUT NOCOPY v_type%ROWTYPE, p_typ_new IN OUT NOCOPY v_type%ROWTYPE) IS
	BEGIN
		IF NVL(p_typ_old.fk_typ_name,' ') <> NVL(p_typ_new.fk_typ_name,' ')  THEN
			get_denorm_typ_typ (p_typ_new);
		END IF;
		UPDATE t_type SET 
			cube_sequence = p_typ_new.cube_sequence,
			cube_level = p_typ_new.cube_level,
			fk_typ_name = p_typ_new.fk_typ_name,
			code = p_typ_new.code,
			flag_partial_key = p_typ_new.flag_partial_key,
			flag_recursive = p_typ_new.flag_recursive,
			recursive_cardinality = p_typ_new.recursive_cardinality,
			cardinality = p_typ_new.cardinality,
			sort_order = p_typ_new.sort_order,
			icon = p_typ_new.icon,
			transferable = p_typ_new.transferable
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_typ (p_cube_rowid UROWID, p_typ IN OUT NOCOPY v_type%ROWTYPE) IS
	BEGIN
		DELETE t_type 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE denorm_typ_typ (p_typ IN OUT NOCOPY v_type%ROWTYPE, p_typ_in IN v_type%ROWTYPE) IS
	BEGIN
		p_typ.cube_level := NVL (p_typ_in.cube_level, 0) + 1;
	END;

	PROCEDURE get_denorm_typ_typ (p_typ IN OUT NOCOPY v_type%ROWTYPE) IS

		CURSOR c_typ IS 
			SELECT * FROM v_type
			WHERE name = p_typ.fk_typ_name;
		
		r_typ v_type%ROWTYPE;
	BEGIN
		IF p_typ.fk_typ_name IS NOT NULL THEN
			OPEN c_typ;
			FETCH c_typ INTO r_typ;
			IF c_typ%NOTFOUND THEN
				r_typ := NULL;
			END IF;
			CLOSE c_typ;
		ELSE
			r_typ := NULL;
		END IF;
		denorm_typ_typ (p_typ, r_typ);
	END;

	PROCEDURE insert_atb (p_atb IN OUT NOCOPY v_attribute%ROWTYPE) IS
	BEGIN
		p_atb.cube_id := 'ATB-' || TO_CHAR(atb_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_atb.fk_bot_name
		FROM t_type
		WHERE name = p_atb.fk_typ_name;
		INSERT INTO t_attribute (
			cube_id,
			cube_sequence,
			fk_bot_name,
			fk_typ_name,
			name,
			primary_key,
			code_display_key,
			code_foreign_key,
			flag_hidden,
			default_value,
			unchangeable,
			xk_itp_name)
		VALUES (
			p_atb.cube_id,
			p_atb.cube_sequence,
			p_atb.fk_bot_name,
			p_atb.fk_typ_name,
			p_atb.name,
			p_atb.primary_key,
			p_atb.code_display_key,
			p_atb.code_foreign_key,
			p_atb.flag_hidden,
			p_atb.default_value,
			p_atb.unchangeable,
			p_atb.xk_itp_name);
	END;

	PROCEDURE update_atb (p_cube_rowid UROWID, p_atb_old IN OUT NOCOPY v_attribute%ROWTYPE, p_atb_new IN OUT NOCOPY v_attribute%ROWTYPE) IS
	BEGIN
		UPDATE t_attribute SET 
			cube_sequence = p_atb_new.cube_sequence,
			primary_key = p_atb_new.primary_key,
			code_display_key = p_atb_new.code_display_key,
			code_foreign_key = p_atb_new.code_foreign_key,
			flag_hidden = p_atb_new.flag_hidden,
			default_value = p_atb_new.default_value,
			unchangeable = p_atb_new.unchangeable,
			xk_itp_name = p_atb_new.xk_itp_name
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_atb (p_cube_rowid UROWID, p_atb IN OUT NOCOPY v_attribute%ROWTYPE) IS
	BEGIN
		DELETE t_attribute 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_der (p_der IN OUT NOCOPY v_derivation%ROWTYPE) IS
	BEGIN
		p_der.cube_id := 'DER-' || TO_CHAR(der_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_der.fk_bot_name
		FROM t_attribute
		WHERE fk_typ_name = p_der.fk_typ_name
		  AND name = p_der.fk_atb_name;
		INSERT INTO t_derivation (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_atb_name,
			cube_tsg_type,
			aggregate_function,
			xk_typ_name,
			xk_typ_name_1)
		VALUES (
			p_der.cube_id,
			p_der.fk_bot_name,
			p_der.fk_typ_name,
			p_der.fk_atb_name,
			p_der.cube_tsg_type,
			p_der.aggregate_function,
			p_der.xk_typ_name,
			p_der.xk_typ_name_1);
	END;

	PROCEDURE update_der (p_cube_rowid UROWID, p_der_old IN OUT NOCOPY v_derivation%ROWTYPE, p_der_new IN OUT NOCOPY v_derivation%ROWTYPE) IS
	BEGIN
		UPDATE t_derivation SET 
			aggregate_function = p_der_new.aggregate_function,
			xk_typ_name = p_der_new.xk_typ_name,
			xk_typ_name_1 = p_der_new.xk_typ_name_1
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_der (p_cube_rowid UROWID, p_der IN OUT NOCOPY v_derivation%ROWTYPE) IS
	BEGIN
		DELETE t_derivation 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_dca (p_dca IN OUT NOCOPY v_description_attribute%ROWTYPE) IS
	BEGIN
		p_dca.cube_id := 'DCA-' || TO_CHAR(dca_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_dca.fk_bot_name
		FROM t_attribute
		WHERE fk_typ_name = p_dca.fk_typ_name
		  AND name = p_dca.fk_atb_name;
		INSERT INTO t_description_attribute (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_atb_name,
			text)
		VALUES (
			p_dca.cube_id,
			p_dca.fk_bot_name,
			p_dca.fk_typ_name,
			p_dca.fk_atb_name,
			p_dca.text);
	END;

	PROCEDURE update_dca (p_cube_rowid UROWID, p_dca_old IN OUT NOCOPY v_description_attribute%ROWTYPE, p_dca_new IN OUT NOCOPY v_description_attribute%ROWTYPE) IS
	BEGIN
		UPDATE t_description_attribute SET 
			text = p_dca_new.text
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_dca (p_cube_rowid UROWID, p_dca IN OUT NOCOPY v_description_attribute%ROWTYPE) IS
	BEGIN
		DELETE t_description_attribute 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_rta (p_rta IN OUT NOCOPY v_restriction_type_spec_atb%ROWTYPE) IS
	BEGIN
		p_rta.cube_id := 'RTA-' || TO_CHAR(rta_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_rta.fk_bot_name
		FROM t_attribute
		WHERE fk_typ_name = p_rta.fk_typ_name
		  AND name = p_rta.fk_atb_name;
		INSERT INTO t_restriction_type_spec_atb (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_atb_name,
			include_or_exclude,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			p_rta.cube_id,
			p_rta.fk_bot_name,
			p_rta.fk_typ_name,
			p_rta.fk_atb_name,
			p_rta.include_or_exclude,
			p_rta.xf_tsp_typ_name,
			p_rta.xf_tsp_tsg_code,
			p_rta.xk_tsp_code);
	END;

	PROCEDURE update_rta (p_cube_rowid UROWID, p_rta_old IN OUT NOCOPY v_restriction_type_spec_atb%ROWTYPE, p_rta_new IN OUT NOCOPY v_restriction_type_spec_atb%ROWTYPE) IS
	BEGIN
		UPDATE t_restriction_type_spec_atb SET 
			include_or_exclude = p_rta_new.include_or_exclude
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_rta (p_cube_rowid UROWID, p_rta IN OUT NOCOPY v_restriction_type_spec_atb%ROWTYPE) IS
	BEGIN
		DELETE t_restriction_type_spec_atb 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_ref (p_ref IN OUT NOCOPY v_reference%ROWTYPE) IS
	BEGIN
		p_ref.cube_id := 'REF-' || TO_CHAR(ref_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_ref.fk_bot_name
		FROM t_type
		WHERE name = p_ref.fk_typ_name;
		INSERT INTO t_reference (
			cube_id,
			cube_sequence,
			fk_bot_name,
			fk_typ_name,
			name,
			primary_key,
			code_display_key,
			sequence,
			scope,
			unchangeable,
			within_scope_level,
			xk_typ_name,
			xk_typ_name_1)
		VALUES (
			p_ref.cube_id,
			p_ref.cube_sequence,
			p_ref.fk_bot_name,
			p_ref.fk_typ_name,
			p_ref.name,
			p_ref.primary_key,
			p_ref.code_display_key,
			p_ref.sequence,
			p_ref.scope,
			p_ref.unchangeable,
			p_ref.within_scope_level,
			p_ref.xk_typ_name,
			p_ref.xk_typ_name_1);
	END;

	PROCEDURE update_ref (p_cube_rowid UROWID, p_ref_old IN OUT NOCOPY v_reference%ROWTYPE, p_ref_new IN OUT NOCOPY v_reference%ROWTYPE) IS
	BEGIN
		UPDATE t_reference SET 
			cube_sequence = p_ref_new.cube_sequence,
			name = p_ref_new.name,
			primary_key = p_ref_new.primary_key,
			code_display_key = p_ref_new.code_display_key,
			scope = p_ref_new.scope,
			unchangeable = p_ref_new.unchangeable,
			within_scope_level = p_ref_new.within_scope_level,
			xk_typ_name_1 = p_ref_new.xk_typ_name_1
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_ref (p_cube_rowid UROWID, p_ref IN OUT NOCOPY v_reference%ROWTYPE) IS
	BEGIN
		DELETE t_reference 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_dcr (p_dcr IN OUT NOCOPY v_description_reference%ROWTYPE) IS
	BEGIN
		p_dcr.cube_id := 'DCR-' || TO_CHAR(dcr_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_dcr.fk_bot_name
		FROM t_reference
		WHERE fk_typ_name = p_dcr.fk_typ_name
		  AND sequence = p_dcr.fk_ref_sequence
		  AND xk_typ_name = p_dcr.fk_ref_typ_name;
		INSERT INTO t_description_reference (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_typ_name,
			text)
		VALUES (
			p_dcr.cube_id,
			p_dcr.fk_bot_name,
			p_dcr.fk_typ_name,
			p_dcr.fk_ref_sequence,
			p_dcr.fk_ref_typ_name,
			p_dcr.text);
	END;

	PROCEDURE update_dcr (p_cube_rowid UROWID, p_dcr_old IN OUT NOCOPY v_description_reference%ROWTYPE, p_dcr_new IN OUT NOCOPY v_description_reference%ROWTYPE) IS
	BEGIN
		UPDATE t_description_reference SET 
			text = p_dcr_new.text
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_dcr (p_cube_rowid UROWID, p_dcr IN OUT NOCOPY v_description_reference%ROWTYPE) IS
	BEGIN
		DELETE t_description_reference 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_rtr (p_rtr IN OUT NOCOPY v_restriction_type_spec_ref%ROWTYPE) IS
	BEGIN
		p_rtr.cube_id := 'RTR-' || TO_CHAR(rtr_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_rtr.fk_bot_name
		FROM t_reference
		WHERE fk_typ_name = p_rtr.fk_typ_name
		  AND sequence = p_rtr.fk_ref_sequence
		  AND xk_typ_name = p_rtr.fk_ref_typ_name;
		INSERT INTO t_restriction_type_spec_ref (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_typ_name,
			include_or_exclude,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			p_rtr.cube_id,
			p_rtr.fk_bot_name,
			p_rtr.fk_typ_name,
			p_rtr.fk_ref_sequence,
			p_rtr.fk_ref_typ_name,
			p_rtr.include_or_exclude,
			p_rtr.xf_tsp_typ_name,
			p_rtr.xf_tsp_tsg_code,
			p_rtr.xk_tsp_code);
	END;

	PROCEDURE update_rtr (p_cube_rowid UROWID, p_rtr_old IN OUT NOCOPY v_restriction_type_spec_ref%ROWTYPE, p_rtr_new IN OUT NOCOPY v_restriction_type_spec_ref%ROWTYPE) IS
	BEGIN
		UPDATE t_restriction_type_spec_ref SET 
			include_or_exclude = p_rtr_new.include_or_exclude
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_rtr (p_cube_rowid UROWID, p_rtr IN OUT NOCOPY v_restriction_type_spec_ref%ROWTYPE) IS
	BEGIN
		DELETE t_restriction_type_spec_ref 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_tyr (p_tyr IN OUT NOCOPY v_type_reuse%ROWTYPE) IS
	BEGIN
		p_tyr.cube_id := 'TYR-' || TO_CHAR(tyr_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_tyr.fk_bot_name
		FROM t_type
		WHERE name = p_tyr.fk_typ_name;
		INSERT INTO t_type_reuse (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			cardinality,
			xk_typ_name)
		VALUES (
			p_tyr.cube_id,
			p_tyr.fk_bot_name,
			p_tyr.fk_typ_name,
			p_tyr.cardinality,
			p_tyr.xk_typ_name);
	END;

	PROCEDURE update_tyr (p_cube_rowid UROWID, p_tyr_old IN OUT NOCOPY v_type_reuse%ROWTYPE, p_tyr_new IN OUT NOCOPY v_type_reuse%ROWTYPE) IS
	BEGIN
		UPDATE t_type_reuse SET 
			cardinality = p_tyr_new.cardinality
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_tyr (p_cube_rowid UROWID, p_tyr IN OUT NOCOPY v_type_reuse%ROWTYPE) IS
	BEGIN
		DELETE t_type_reuse 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_par (p_par IN OUT NOCOPY v_partition%ROWTYPE) IS
	BEGIN
		p_par.cube_id := 'PAR-' || TO_CHAR(par_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_par.fk_bot_name
		FROM t_type
		WHERE name = p_par.fk_typ_name;
		INSERT INTO t_partition (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			name)
		VALUES (
			p_par.cube_id,
			p_par.fk_bot_name,
			p_par.fk_typ_name,
			p_par.name);
	END;

	PROCEDURE update_par (p_cube_rowid UROWID, p_par_old IN OUT NOCOPY v_partition%ROWTYPE, p_par_new IN OUT NOCOPY v_partition%ROWTYPE) IS
	BEGIN
		NULL;
	END;

	PROCEDURE delete_par (p_cube_rowid UROWID, p_par IN OUT NOCOPY v_partition%ROWTYPE) IS
	BEGIN
		DELETE t_partition 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_stp (p_stp IN OUT NOCOPY v_subtype%ROWTYPE) IS
	BEGIN
		p_stp.cube_id := 'STP-' || TO_CHAR(stp_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_stp.fk_bot_name
		FROM t_partition
		WHERE fk_typ_name = p_stp.fk_typ_name
		  AND name = p_stp.fk_par_name;
		INSERT INTO t_subtype (
			cube_id,
			cube_sequence,
			fk_bot_name,
			fk_typ_name,
			fk_par_name,
			name)
		VALUES (
			p_stp.cube_id,
			p_stp.cube_sequence,
			p_stp.fk_bot_name,
			p_stp.fk_typ_name,
			p_stp.fk_par_name,
			p_stp.name);
	END;

	PROCEDURE update_stp (p_cube_rowid UROWID, p_stp_old IN OUT NOCOPY v_subtype%ROWTYPE, p_stp_new IN OUT NOCOPY v_subtype%ROWTYPE) IS
	BEGIN
		UPDATE t_subtype SET 
			cube_sequence = p_stp_new.cube_sequence
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_stp (p_cube_rowid UROWID, p_stp IN OUT NOCOPY v_subtype%ROWTYPE) IS
	BEGIN
		DELETE t_subtype 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_tsg (p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE) IS
	BEGIN
		p_tsg.cube_id := 'TSG-' || TO_CHAR(tsg_seq.NEXTVAL,'FM000000000000');
		IF p_tsg.fk_tsg_code IS NOT NULL  THEN
			-- Recursive
			SELECT fk_bot_name
			  INTO p_tsg.fk_bot_name
			FROM t_type_specialisation_group
			WHERE code = p_tsg.fk_tsg_code;
			ELSE
				-- Parent
			SELECT fk_bot_name
			  INTO p_tsg.fk_bot_name
			FROM t_type
			WHERE name = p_tsg.fk_typ_name;
			
		END IF;
		get_denorm_tsg_tsg (p_tsg);
		INSERT INTO t_type_specialisation_group (
			cube_id,
			cube_sequence,
			cube_level,
			fk_bot_name,
			fk_typ_name,
			fk_tsg_code,
			code,
			name,
			primary_key)
		VALUES (
			p_tsg.cube_id,
			p_tsg.cube_sequence,
			p_tsg.cube_level,
			p_tsg.fk_bot_name,
			p_tsg.fk_typ_name,
			p_tsg.fk_tsg_code,
			p_tsg.code,
			p_tsg.name,
			p_tsg.primary_key);
	END;

	PROCEDURE update_tsg (p_cube_rowid UROWID, p_tsg_old IN OUT NOCOPY v_type_specialisation_group%ROWTYPE, p_tsg_new IN OUT NOCOPY v_type_specialisation_group%ROWTYPE) IS
	BEGIN
		IF NVL(p_tsg_old.fk_tsg_code,' ') <> NVL(p_tsg_new.fk_tsg_code,' ')  THEN
			get_denorm_tsg_tsg (p_tsg_new);
		END IF;
		UPDATE t_type_specialisation_group SET 
			cube_sequence = p_tsg_new.cube_sequence,
			cube_level = p_tsg_new.cube_level,
			fk_tsg_code = p_tsg_new.fk_tsg_code,
			name = p_tsg_new.name,
			primary_key = p_tsg_new.primary_key
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_tsg (p_cube_rowid UROWID, p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE) IS
	BEGIN
		DELETE t_type_specialisation_group 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE denorm_tsg_tsg (p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE, p_tsg_in IN v_type_specialisation_group%ROWTYPE) IS
	BEGIN
		p_tsg.cube_level := NVL (p_tsg_in.cube_level, 0) + 1;
	END;

	PROCEDURE get_denorm_tsg_tsg (p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE) IS

		CURSOR c_tsg IS 
			SELECT * FROM v_type_specialisation_group
			WHERE fk_typ_name = p_tsg.fk_typ_name
			  AND code = p_tsg.fk_tsg_code;
		
		r_tsg v_type_specialisation_group%ROWTYPE;
	BEGIN
		IF p_tsg.fk_tsg_code IS NOT NULL THEN
			OPEN c_tsg;
			FETCH c_tsg INTO r_tsg;
			IF c_tsg%NOTFOUND THEN
				r_tsg := NULL;
			END IF;
			CLOSE c_tsg;
		ELSE
			r_tsg := NULL;
		END IF;
		denorm_tsg_tsg (p_tsg, r_tsg);
	END;

	PROCEDURE insert_tsp (p_tsp IN OUT NOCOPY v_type_specialisation%ROWTYPE) IS
	BEGIN
		p_tsp.cube_id := 'TSP-' || TO_CHAR(tsp_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_tsp.fk_bot_name
		FROM t_type_specialisation_group
		WHERE fk_typ_name = p_tsp.fk_typ_name
		  AND code = p_tsp.fk_tsg_code;
		INSERT INTO t_type_specialisation (
			cube_id,
			cube_sequence,
			fk_bot_name,
			fk_typ_name,
			fk_tsg_code,
			code,
			name,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			p_tsp.cube_id,
			p_tsp.cube_sequence,
			p_tsp.fk_bot_name,
			p_tsp.fk_typ_name,
			p_tsp.fk_tsg_code,
			p_tsp.code,
			p_tsp.name,
			p_tsp.xf_tsp_typ_name,
			p_tsp.xf_tsp_tsg_code,
			p_tsp.xk_tsp_code);
	END;

	PROCEDURE update_tsp (p_cube_rowid UROWID, p_tsp_old IN OUT NOCOPY v_type_specialisation%ROWTYPE, p_tsp_new IN OUT NOCOPY v_type_specialisation%ROWTYPE) IS
	BEGIN
		UPDATE t_type_specialisation SET 
			cube_sequence = p_tsp_new.cube_sequence,
			name = p_tsp_new.name,
			xf_tsp_typ_name = p_tsp_new.xf_tsp_typ_name,
			xf_tsp_tsg_code = p_tsp_new.xf_tsp_tsg_code,
			xk_tsp_code = p_tsp_new.xk_tsp_code
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_tsp (p_cube_rowid UROWID, p_tsp IN OUT NOCOPY v_type_specialisation%ROWTYPE) IS
	BEGIN
		DELETE t_type_specialisation 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_dct (p_dct IN OUT NOCOPY v_description_type%ROWTYPE) IS
	BEGIN
		p_dct.cube_id := 'DCT-' || TO_CHAR(dct_seq.NEXTVAL,'FM000000000000');
		SELECT fk_bot_name
		  INTO p_dct.fk_bot_name
		FROM t_type
		WHERE name = p_dct.fk_typ_name;
		INSERT INTO t_description_type (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			text)
		VALUES (
			p_dct.cube_id,
			p_dct.fk_bot_name,
			p_dct.fk_typ_name,
			p_dct.text);
	END;

	PROCEDURE update_dct (p_cube_rowid UROWID, p_dct_old IN OUT NOCOPY v_description_type%ROWTYPE, p_dct_new IN OUT NOCOPY v_description_type%ROWTYPE) IS
	BEGIN
		UPDATE t_description_type SET 
			text = p_dct_new.text
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_dct (p_cube_rowid UROWID, p_dct IN OUT NOCOPY v_description_type%ROWTYPE) IS
	BEGIN
		DELETE t_description_type 
		WHERE rowid = p_cube_rowid;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_bot
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_business_object_type
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_bot_new v_business_object_type%ROWTYPE;
	r_bot_old v_business_object_type%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_bot_new.cube_sequence := :NEW.cube_sequence;
		r_bot_new.name := REPLACE(:NEW.name,' ','_');
		r_bot_new.directory := REPLACE(:NEW.directory,' ','_');
	END IF;
	IF UPDATING THEN
		r_bot_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_business_object_type
		WHERE name = :OLD.name;
		r_bot_old.cube_sequence := :OLD.cube_sequence;
		r_bot_old.name := :OLD.name;
		r_bot_old.directory := :OLD.directory;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_bot (r_bot_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_bot (l_cube_rowid, r_bot_old, r_bot_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_bot (l_cube_rowid, r_bot_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_typ
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_type
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_typ_new v_type%ROWTYPE;
	r_typ_old v_type%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_typ_new.cube_sequence := :NEW.cube_sequence;
		r_typ_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_typ_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_typ_new.name := REPLACE(:NEW.name,' ','_');
		r_typ_new.code := REPLACE(:NEW.code,' ','_');
		r_typ_new.flag_partial_key := :NEW.flag_partial_key;
		r_typ_new.flag_recursive := :NEW.flag_recursive;
		r_typ_new.recursive_cardinality := :NEW.recursive_cardinality;
		r_typ_new.cardinality := :NEW.cardinality;
		r_typ_new.sort_order := :NEW.sort_order;
		r_typ_new.icon := REPLACE(:NEW.icon,' ','_');
		r_typ_new.transferable := :NEW.transferable;
	END IF;
	IF UPDATING THEN
		r_typ_new.cube_id := :OLD.cube_id;
		r_typ_new.cube_level := :OLD.cube_level;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_type
		WHERE name = :OLD.name;
		r_typ_old.cube_sequence := :OLD.cube_sequence;
		r_typ_old.fk_bot_name := :OLD.fk_bot_name;
		r_typ_old.fk_typ_name := :OLD.fk_typ_name;
		r_typ_old.name := :OLD.name;
		r_typ_old.code := :OLD.code;
		r_typ_old.flag_partial_key := :OLD.flag_partial_key;
		r_typ_old.flag_recursive := :OLD.flag_recursive;
		r_typ_old.recursive_cardinality := :OLD.recursive_cardinality;
		r_typ_old.cardinality := :OLD.cardinality;
		r_typ_old.sort_order := :OLD.sort_order;
		r_typ_old.icon := :OLD.icon;
		r_typ_old.transferable := :OLD.transferable;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_typ (r_typ_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_typ (l_cube_rowid, r_typ_old, r_typ_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_typ (l_cube_rowid, r_typ_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_atb
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_attribute
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_atb_new v_attribute%ROWTYPE;
	r_atb_old v_attribute%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_atb_new.cube_sequence := :NEW.cube_sequence;
		r_atb_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_atb_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_atb_new.name := REPLACE(:NEW.name,' ','_');
		r_atb_new.primary_key := :NEW.primary_key;
		r_atb_new.code_display_key := REPLACE(:NEW.code_display_key,' ','_');
		r_atb_new.code_foreign_key := :NEW.code_foreign_key;
		r_atb_new.flag_hidden := :NEW.flag_hidden;
		r_atb_new.default_value := :NEW.default_value;
		r_atb_new.unchangeable := :NEW.unchangeable;
		r_atb_new.xk_itp_name := REPLACE(:NEW.xk_itp_name,' ','_');
	END IF;
	IF UPDATING THEN
		r_atb_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_attribute
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND name = :OLD.name;
		r_atb_old.cube_sequence := :OLD.cube_sequence;
		r_atb_old.fk_bot_name := :OLD.fk_bot_name;
		r_atb_old.fk_typ_name := :OLD.fk_typ_name;
		r_atb_old.name := :OLD.name;
		r_atb_old.primary_key := :OLD.primary_key;
		r_atb_old.code_display_key := :OLD.code_display_key;
		r_atb_old.code_foreign_key := :OLD.code_foreign_key;
		r_atb_old.flag_hidden := :OLD.flag_hidden;
		r_atb_old.default_value := :OLD.default_value;
		r_atb_old.unchangeable := :OLD.unchangeable;
		r_atb_old.xk_itp_name := :OLD.xk_itp_name;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_atb (r_atb_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_atb (l_cube_rowid, r_atb_old, r_atb_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_atb (l_cube_rowid, r_atb_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_der
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_derivation
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_der_new v_derivation%ROWTYPE;
	r_der_old v_derivation%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_der_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_der_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_der_new.fk_atb_name := REPLACE(:NEW.fk_atb_name,' ','_');
		r_der_new.cube_tsg_type := :NEW.cube_tsg_type;
		r_der_new.aggregate_function := REPLACE(:NEW.aggregate_function,' ','_');
		r_der_new.xk_typ_name := REPLACE(:NEW.xk_typ_name,' ','_');
		r_der_new.xk_typ_name_1 := REPLACE(:NEW.xk_typ_name_1,' ','_');
	END IF;
	IF UPDATING THEN
		r_der_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_derivation
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND fk_atb_name = :OLD.fk_atb_name;
		r_der_old.fk_bot_name := :OLD.fk_bot_name;
		r_der_old.fk_typ_name := :OLD.fk_typ_name;
		r_der_old.fk_atb_name := :OLD.fk_atb_name;
		r_der_old.cube_tsg_type := :OLD.cube_tsg_type;
		r_der_old.aggregate_function := :OLD.aggregate_function;
		r_der_old.xk_typ_name := :OLD.xk_typ_name;
		r_der_old.xk_typ_name_1 := :OLD.xk_typ_name_1;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_der (r_der_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_der (l_cube_rowid, r_der_old, r_der_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_der (l_cube_rowid, r_der_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_dca
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_description_attribute
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_dca_new v_description_attribute%ROWTYPE;
	r_dca_old v_description_attribute%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_dca_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_dca_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_dca_new.fk_atb_name := REPLACE(:NEW.fk_atb_name,' ','_');
		r_dca_new.text := :NEW.text;
	END IF;
	IF UPDATING THEN
		r_dca_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_description_attribute
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND fk_atb_name = :OLD.fk_atb_name;
		r_dca_old.fk_bot_name := :OLD.fk_bot_name;
		r_dca_old.fk_typ_name := :OLD.fk_typ_name;
		r_dca_old.fk_atb_name := :OLD.fk_atb_name;
		r_dca_old.text := :OLD.text;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_dca (r_dca_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_dca (l_cube_rowid, r_dca_old, r_dca_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_dca (l_cube_rowid, r_dca_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_rta
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_restriction_type_spec_atb
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_rta_new v_restriction_type_spec_atb%ROWTYPE;
	r_rta_old v_restriction_type_spec_atb%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_rta_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_rta_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_rta_new.fk_atb_name := REPLACE(:NEW.fk_atb_name,' ','_');
		r_rta_new.include_or_exclude := REPLACE(:NEW.include_or_exclude,' ','_');
		r_rta_new.xf_tsp_typ_name := REPLACE(:NEW.xf_tsp_typ_name,' ','_');
		r_rta_new.xf_tsp_tsg_code := REPLACE(:NEW.xf_tsp_tsg_code,' ','_');
		r_rta_new.xk_tsp_code := REPLACE(:NEW.xk_tsp_code,' ','_');
	END IF;
	IF UPDATING THEN
		r_rta_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_restriction_type_spec_atb
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND fk_atb_name = :OLD.fk_atb_name
		  AND xf_tsp_typ_name = :OLD.xf_tsp_typ_name
		  AND xf_tsp_tsg_code = :OLD.xf_tsp_tsg_code
		  AND xk_tsp_code = :OLD.xk_tsp_code;
		r_rta_old.fk_bot_name := :OLD.fk_bot_name;
		r_rta_old.fk_typ_name := :OLD.fk_typ_name;
		r_rta_old.fk_atb_name := :OLD.fk_atb_name;
		r_rta_old.include_or_exclude := :OLD.include_or_exclude;
		r_rta_old.xf_tsp_typ_name := :OLD.xf_tsp_typ_name;
		r_rta_old.xf_tsp_tsg_code := :OLD.xf_tsp_tsg_code;
		r_rta_old.xk_tsp_code := :OLD.xk_tsp_code;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_rta (r_rta_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_rta (l_cube_rowid, r_rta_old, r_rta_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_rta (l_cube_rowid, r_rta_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_ref
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_reference
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_ref_new v_reference%ROWTYPE;
	r_ref_old v_reference%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_ref_new.cube_sequence := :NEW.cube_sequence;
		r_ref_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_ref_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_ref_new.name := REPLACE(:NEW.name,' ','_');
		r_ref_new.primary_key := :NEW.primary_key;
		r_ref_new.code_display_key := REPLACE(:NEW.code_display_key,' ','_');
		r_ref_new.sequence := :NEW.sequence;
		r_ref_new.scope := REPLACE(:NEW.scope,' ','_');
		r_ref_new.unchangeable := :NEW.unchangeable;
		r_ref_new.within_scope_level := :NEW.within_scope_level;
		r_ref_new.xk_typ_name := REPLACE(:NEW.xk_typ_name,' ','_');
		r_ref_new.xk_typ_name_1 := REPLACE(:NEW.xk_typ_name_1,' ','_');
	END IF;
	IF UPDATING THEN
		r_ref_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_reference
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND sequence = :OLD.sequence
		  AND xk_typ_name = :OLD.xk_typ_name;
		r_ref_old.cube_sequence := :OLD.cube_sequence;
		r_ref_old.fk_bot_name := :OLD.fk_bot_name;
		r_ref_old.fk_typ_name := :OLD.fk_typ_name;
		r_ref_old.name := :OLD.name;
		r_ref_old.primary_key := :OLD.primary_key;
		r_ref_old.code_display_key := :OLD.code_display_key;
		r_ref_old.sequence := :OLD.sequence;
		r_ref_old.scope := :OLD.scope;
		r_ref_old.unchangeable := :OLD.unchangeable;
		r_ref_old.within_scope_level := :OLD.within_scope_level;
		r_ref_old.xk_typ_name := :OLD.xk_typ_name;
		r_ref_old.xk_typ_name_1 := :OLD.xk_typ_name_1;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_ref (r_ref_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_ref (l_cube_rowid, r_ref_old, r_ref_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_ref (l_cube_rowid, r_ref_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_dcr
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_description_reference
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_dcr_new v_description_reference%ROWTYPE;
	r_dcr_old v_description_reference%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_dcr_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_dcr_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_dcr_new.fk_ref_sequence := :NEW.fk_ref_sequence;
		r_dcr_new.fk_ref_typ_name := REPLACE(:NEW.fk_ref_typ_name,' ','_');
		r_dcr_new.text := :NEW.text;
	END IF;
	IF UPDATING THEN
		r_dcr_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_description_reference
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND fk_ref_sequence = :OLD.fk_ref_sequence
		  AND fk_ref_typ_name = :OLD.fk_ref_typ_name;
		r_dcr_old.fk_bot_name := :OLD.fk_bot_name;
		r_dcr_old.fk_typ_name := :OLD.fk_typ_name;
		r_dcr_old.fk_ref_sequence := :OLD.fk_ref_sequence;
		r_dcr_old.fk_ref_typ_name := :OLD.fk_ref_typ_name;
		r_dcr_old.text := :OLD.text;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_dcr (r_dcr_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_dcr (l_cube_rowid, r_dcr_old, r_dcr_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_dcr (l_cube_rowid, r_dcr_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_rtr
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_restriction_type_spec_ref
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_rtr_new v_restriction_type_spec_ref%ROWTYPE;
	r_rtr_old v_restriction_type_spec_ref%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_rtr_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_rtr_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_rtr_new.fk_ref_sequence := :NEW.fk_ref_sequence;
		r_rtr_new.fk_ref_typ_name := REPLACE(:NEW.fk_ref_typ_name,' ','_');
		r_rtr_new.include_or_exclude := REPLACE(:NEW.include_or_exclude,' ','_');
		r_rtr_new.xf_tsp_typ_name := REPLACE(:NEW.xf_tsp_typ_name,' ','_');
		r_rtr_new.xf_tsp_tsg_code := REPLACE(:NEW.xf_tsp_tsg_code,' ','_');
		r_rtr_new.xk_tsp_code := REPLACE(:NEW.xk_tsp_code,' ','_');
	END IF;
	IF UPDATING THEN
		r_rtr_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_restriction_type_spec_ref
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND fk_ref_sequence = :OLD.fk_ref_sequence
		  AND fk_ref_typ_name = :OLD.fk_ref_typ_name
		  AND xf_tsp_typ_name = :OLD.xf_tsp_typ_name
		  AND xf_tsp_tsg_code = :OLD.xf_tsp_tsg_code
		  AND xk_tsp_code = :OLD.xk_tsp_code;
		r_rtr_old.fk_bot_name := :OLD.fk_bot_name;
		r_rtr_old.fk_typ_name := :OLD.fk_typ_name;
		r_rtr_old.fk_ref_sequence := :OLD.fk_ref_sequence;
		r_rtr_old.fk_ref_typ_name := :OLD.fk_ref_typ_name;
		r_rtr_old.include_or_exclude := :OLD.include_or_exclude;
		r_rtr_old.xf_tsp_typ_name := :OLD.xf_tsp_typ_name;
		r_rtr_old.xf_tsp_tsg_code := :OLD.xf_tsp_tsg_code;
		r_rtr_old.xk_tsp_code := :OLD.xk_tsp_code;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_rtr (r_rtr_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_rtr (l_cube_rowid, r_rtr_old, r_rtr_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_rtr (l_cube_rowid, r_rtr_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_tyr
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_type_reuse
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_tyr_new v_type_reuse%ROWTYPE;
	r_tyr_old v_type_reuse%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_tyr_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_tyr_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_tyr_new.cardinality := :NEW.cardinality;
		r_tyr_new.xk_typ_name := REPLACE(:NEW.xk_typ_name,' ','_');
	END IF;
	IF UPDATING THEN
		r_tyr_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_type_reuse
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND xk_typ_name = :OLD.xk_typ_name;
		r_tyr_old.fk_bot_name := :OLD.fk_bot_name;
		r_tyr_old.fk_typ_name := :OLD.fk_typ_name;
		r_tyr_old.cardinality := :OLD.cardinality;
		r_tyr_old.xk_typ_name := :OLD.xk_typ_name;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_tyr (r_tyr_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_tyr (l_cube_rowid, r_tyr_old, r_tyr_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_tyr (l_cube_rowid, r_tyr_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_par
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_partition
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_par_new v_partition%ROWTYPE;
	r_par_old v_partition%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_par_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_par_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_par_new.name := REPLACE(:NEW.name,' ','_');
	END IF;
	IF UPDATING THEN
		r_par_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_partition
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND name = :OLD.name;
		r_par_old.fk_bot_name := :OLD.fk_bot_name;
		r_par_old.fk_typ_name := :OLD.fk_typ_name;
		r_par_old.name := :OLD.name;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_par (r_par_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_par (l_cube_rowid, r_par_old, r_par_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_par (l_cube_rowid, r_par_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_stp
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_subtype
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_stp_new v_subtype%ROWTYPE;
	r_stp_old v_subtype%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_stp_new.cube_sequence := :NEW.cube_sequence;
		r_stp_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_stp_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_stp_new.fk_par_name := REPLACE(:NEW.fk_par_name,' ','_');
		r_stp_new.name := REPLACE(:NEW.name,' ','_');
	END IF;
	IF UPDATING THEN
		r_stp_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_subtype
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND fk_par_name = :OLD.fk_par_name
		  AND name = :OLD.name;
		r_stp_old.cube_sequence := :OLD.cube_sequence;
		r_stp_old.fk_bot_name := :OLD.fk_bot_name;
		r_stp_old.fk_typ_name := :OLD.fk_typ_name;
		r_stp_old.fk_par_name := :OLD.fk_par_name;
		r_stp_old.name := :OLD.name;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_stp (r_stp_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_stp (l_cube_rowid, r_stp_old, r_stp_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_stp (l_cube_rowid, r_stp_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_tsg
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_type_specialisation_group
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_tsg_new v_type_specialisation_group%ROWTYPE;
	r_tsg_old v_type_specialisation_group%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_tsg_new.cube_sequence := :NEW.cube_sequence;
		r_tsg_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_tsg_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_tsg_new.fk_tsg_code := REPLACE(:NEW.fk_tsg_code,' ','_');
		r_tsg_new.code := REPLACE(:NEW.code,' ','_');
		r_tsg_new.name := REPLACE(:NEW.name,' ','_');
		r_tsg_new.primary_key := :NEW.primary_key;
	END IF;
	IF UPDATING THEN
		r_tsg_new.cube_id := :OLD.cube_id;
		r_tsg_new.cube_level := :OLD.cube_level;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_type_specialisation_group
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND code = :OLD.code;
		r_tsg_old.cube_sequence := :OLD.cube_sequence;
		r_tsg_old.fk_bot_name := :OLD.fk_bot_name;
		r_tsg_old.fk_typ_name := :OLD.fk_typ_name;
		r_tsg_old.fk_tsg_code := :OLD.fk_tsg_code;
		r_tsg_old.code := :OLD.code;
		r_tsg_old.name := :OLD.name;
		r_tsg_old.primary_key := :OLD.primary_key;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_tsg (r_tsg_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_tsg (l_cube_rowid, r_tsg_old, r_tsg_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_tsg (l_cube_rowid, r_tsg_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_tsp
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_type_specialisation
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_tsp_new v_type_specialisation%ROWTYPE;
	r_tsp_old v_type_specialisation%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_tsp_new.cube_sequence := :NEW.cube_sequence;
		r_tsp_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_tsp_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_tsp_new.fk_tsg_code := REPLACE(:NEW.fk_tsg_code,' ','_');
		r_tsp_new.code := REPLACE(:NEW.code,' ','_');
		r_tsp_new.name := REPLACE(:NEW.name,' ','_');
		r_tsp_new.xf_tsp_typ_name := REPLACE(:NEW.xf_tsp_typ_name,' ','_');
		r_tsp_new.xf_tsp_tsg_code := REPLACE(:NEW.xf_tsp_tsg_code,' ','_');
		r_tsp_new.xk_tsp_code := REPLACE(:NEW.xk_tsp_code,' ','_');
	END IF;
	IF UPDATING THEN
		r_tsp_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_type_specialisation
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND fk_tsg_code = :OLD.fk_tsg_code
		  AND code = :OLD.code;
		r_tsp_old.cube_sequence := :OLD.cube_sequence;
		r_tsp_old.fk_bot_name := :OLD.fk_bot_name;
		r_tsp_old.fk_typ_name := :OLD.fk_typ_name;
		r_tsp_old.fk_tsg_code := :OLD.fk_tsg_code;
		r_tsp_old.code := :OLD.code;
		r_tsp_old.name := :OLD.name;
		r_tsp_old.xf_tsp_typ_name := :OLD.xf_tsp_typ_name;
		r_tsp_old.xf_tsp_tsg_code := :OLD.xf_tsp_tsg_code;
		r_tsp_old.xk_tsp_code := :OLD.xk_tsp_code;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_tsp (r_tsp_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_tsp (l_cube_rowid, r_tsp_old, r_tsp_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_tsp (l_cube_rowid, r_tsp_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_dct
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_description_type
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_dct_new v_description_type%ROWTYPE;
	r_dct_old v_description_type%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_dct_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		r_dct_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		r_dct_new.text := :NEW.text;
	END IF;
	IF UPDATING THEN
		r_dct_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_description_type
		WHERE fk_typ_name = :OLD.fk_typ_name;
		r_dct_old.fk_bot_name := :OLD.fk_bot_name;
		r_dct_old.fk_typ_name := :OLD.fk_typ_name;
		r_dct_old.text := :OLD.text;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_dct (r_dct_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_dct (l_cube_rowid, r_dct_old, r_dct_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_dct (l_cube_rowid, r_dct_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE VIEW v_system AS 
	SELECT
		cube_id,
		name,
		database,
		schema,
		password
	FROM t_system
/
CREATE OR REPLACE VIEW v_system_bo_type AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_sys_name,
		xk_bot_name
	FROM t_system_bo_type
/

CREATE OR REPLACE PACKAGE pkg_sys_trg IS
	PROCEDURE insert_sys (p_sys IN OUT NOCOPY v_system%ROWTYPE);
	PROCEDURE update_sys (p_cube_rowid IN UROWID, p_sys_old IN OUT NOCOPY v_system%ROWTYPE, p_sys_new IN OUT NOCOPY v_system%ROWTYPE);
	PROCEDURE delete_sys (p_cube_rowid IN UROWID, p_sys IN OUT NOCOPY v_system%ROWTYPE);
	PROCEDURE insert_sbt (p_sbt IN OUT NOCOPY v_system_bo_type%ROWTYPE);
	PROCEDURE update_sbt (p_cube_rowid IN UROWID, p_sbt_old IN OUT NOCOPY v_system_bo_type%ROWTYPE, p_sbt_new IN OUT NOCOPY v_system_bo_type%ROWTYPE);
	PROCEDURE delete_sbt (p_cube_rowid IN UROWID, p_sbt IN OUT NOCOPY v_system_bo_type%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_sys_trg IS

	PROCEDURE insert_sys (p_sys IN OUT NOCOPY v_system%ROWTYPE) IS
	BEGIN
		p_sys.cube_id := 'SYS-' || TO_CHAR(sys_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_system (
			cube_id,
			name,
			database,
			schema,
			password)
		VALUES (
			p_sys.cube_id,
			p_sys.name,
			p_sys.database,
			p_sys.schema,
			p_sys.password);
	END;

	PROCEDURE update_sys (p_cube_rowid UROWID, p_sys_old IN OUT NOCOPY v_system%ROWTYPE, p_sys_new IN OUT NOCOPY v_system%ROWTYPE) IS
	BEGIN
		UPDATE t_system SET 
			database = p_sys_new.database,
			schema = p_sys_new.schema,
			password = p_sys_new.password
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_sys (p_cube_rowid UROWID, p_sys IN OUT NOCOPY v_system%ROWTYPE) IS
	BEGIN
		DELETE t_system 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_sbt (p_sbt IN OUT NOCOPY v_system_bo_type%ROWTYPE) IS
	BEGIN
		p_sbt.cube_id := 'SBT-' || TO_CHAR(sbt_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_system_bo_type (
			cube_id,
			cube_sequence,
			fk_sys_name,
			xk_bot_name)
		VALUES (
			p_sbt.cube_id,
			p_sbt.cube_sequence,
			p_sbt.fk_sys_name,
			p_sbt.xk_bot_name);
	END;

	PROCEDURE update_sbt (p_cube_rowid UROWID, p_sbt_old IN OUT NOCOPY v_system_bo_type%ROWTYPE, p_sbt_new IN OUT NOCOPY v_system_bo_type%ROWTYPE) IS
	BEGIN
		UPDATE t_system_bo_type SET 
			cube_sequence = p_sbt_new.cube_sequence
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_sbt (p_cube_rowid UROWID, p_sbt IN OUT NOCOPY v_system_bo_type%ROWTYPE) IS
	BEGIN
		DELETE t_system_bo_type 
		WHERE rowid = p_cube_rowid;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_sys
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_system
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_sys_new v_system%ROWTYPE;
	r_sys_old v_system%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_sys_new.name := REPLACE(:NEW.name,' ','_');
		r_sys_new.database := REPLACE(:NEW.database,' ','_');
		r_sys_new.schema := REPLACE(:NEW.schema,' ','_');
		r_sys_new.password := REPLACE(:NEW.password,' ','_');
	END IF;
	IF UPDATING THEN
		r_sys_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_system
		WHERE name = :OLD.name;
		r_sys_old.name := :OLD.name;
		r_sys_old.database := :OLD.database;
		r_sys_old.schema := :OLD.schema;
		r_sys_old.password := :OLD.password;
	END IF;

	IF INSERTING THEN 
		pkg_sys_trg.insert_sys (r_sys_new);
	ELSIF UPDATING THEN
		pkg_sys_trg.update_sys (l_cube_rowid, r_sys_old, r_sys_new);
	ELSIF DELETING THEN
		pkg_sys_trg.delete_sys (l_cube_rowid, r_sys_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_sbt
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_system_bo_type
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_sbt_new v_system_bo_type%ROWTYPE;
	r_sbt_old v_system_bo_type%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_sbt_new.cube_sequence := :NEW.cube_sequence;
		r_sbt_new.fk_sys_name := REPLACE(:NEW.fk_sys_name,' ','_');
		r_sbt_new.xk_bot_name := REPLACE(:NEW.xk_bot_name,' ','_');
	END IF;
	IF UPDATING THEN
		r_sbt_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_system_bo_type
		WHERE fk_sys_name = :OLD.fk_sys_name
		  AND xk_bot_name = :OLD.xk_bot_name;
		r_sbt_old.cube_sequence := :OLD.cube_sequence;
		r_sbt_old.fk_sys_name := :OLD.fk_sys_name;
		r_sbt_old.xk_bot_name := :OLD.xk_bot_name;
	END IF;

	IF INSERTING THEN 
		pkg_sys_trg.insert_sbt (r_sbt_new);
	ELSIF UPDATING THEN
		pkg_sys_trg.update_sbt (l_cube_rowid, r_sbt_old, r_sbt_new);
	ELSIF DELETING THEN
		pkg_sys_trg.delete_sbt (l_cube_rowid, r_sbt_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE VIEW v_cube_gen_documentation AS 
	SELECT
		cube_id,
		name,
		description,
		description_functions
	FROM t_cube_gen_documentation
/
CREATE OR REPLACE VIEW v_cube_gen_paragraph AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_cub_name,
		id,
		header,
		description,
		example
	FROM t_cube_gen_paragraph
/
CREATE OR REPLACE VIEW v_cube_gen_example_model AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_cub_name,
		id,
		header,
		included_object_names,
		description
	FROM t_cube_gen_example_model
/
CREATE OR REPLACE VIEW v_cube_gen_example_object AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_cub_name,
		fk_cgm_id,
		xk_bot_name
	FROM t_cube_gen_example_object
/
CREATE OR REPLACE VIEW v_cube_gen_function AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_cub_name,
		fk_cgm_id,
		id,
		header,
		description,
		template
	FROM t_cube_gen_function
/
CREATE OR REPLACE VIEW v_cube_gen_template_function AS 
	SELECT
		cube_id,
		fk_cub_name,
		name,
		indication_logical,
		description,
		syntax
	FROM t_cube_gen_template_function
/

CREATE OR REPLACE PACKAGE pkg_cub_trg IS
	PROCEDURE insert_cub (p_cub IN OUT NOCOPY v_cube_gen_documentation%ROWTYPE);
	PROCEDURE update_cub (p_cube_rowid IN UROWID, p_cub_old IN OUT NOCOPY v_cube_gen_documentation%ROWTYPE, p_cub_new IN OUT NOCOPY v_cube_gen_documentation%ROWTYPE);
	PROCEDURE delete_cub (p_cube_rowid IN UROWID, p_cub IN OUT NOCOPY v_cube_gen_documentation%ROWTYPE);
	PROCEDURE insert_cgp (p_cgp IN OUT NOCOPY v_cube_gen_paragraph%ROWTYPE);
	PROCEDURE update_cgp (p_cube_rowid IN UROWID, p_cgp_old IN OUT NOCOPY v_cube_gen_paragraph%ROWTYPE, p_cgp_new IN OUT NOCOPY v_cube_gen_paragraph%ROWTYPE);
	PROCEDURE delete_cgp (p_cube_rowid IN UROWID, p_cgp IN OUT NOCOPY v_cube_gen_paragraph%ROWTYPE);
	PROCEDURE insert_cgm (p_cgm IN OUT NOCOPY v_cube_gen_example_model%ROWTYPE);
	PROCEDURE update_cgm (p_cube_rowid IN UROWID, p_cgm_old IN OUT NOCOPY v_cube_gen_example_model%ROWTYPE, p_cgm_new IN OUT NOCOPY v_cube_gen_example_model%ROWTYPE);
	PROCEDURE delete_cgm (p_cube_rowid IN UROWID, p_cgm IN OUT NOCOPY v_cube_gen_example_model%ROWTYPE);
	PROCEDURE insert_cgo (p_cgo IN OUT NOCOPY v_cube_gen_example_object%ROWTYPE);
	PROCEDURE update_cgo (p_cube_rowid IN UROWID, p_cgo_old IN OUT NOCOPY v_cube_gen_example_object%ROWTYPE, p_cgo_new IN OUT NOCOPY v_cube_gen_example_object%ROWTYPE);
	PROCEDURE delete_cgo (p_cube_rowid IN UROWID, p_cgo IN OUT NOCOPY v_cube_gen_example_object%ROWTYPE);
	PROCEDURE insert_cgf (p_cgf IN OUT NOCOPY v_cube_gen_function%ROWTYPE);
	PROCEDURE update_cgf (p_cube_rowid IN UROWID, p_cgf_old IN OUT NOCOPY v_cube_gen_function%ROWTYPE, p_cgf_new IN OUT NOCOPY v_cube_gen_function%ROWTYPE);
	PROCEDURE delete_cgf (p_cube_rowid IN UROWID, p_cgf IN OUT NOCOPY v_cube_gen_function%ROWTYPE);
	PROCEDURE insert_ctf (p_ctf IN OUT NOCOPY v_cube_gen_template_function%ROWTYPE);
	PROCEDURE update_ctf (p_cube_rowid IN UROWID, p_ctf_old IN OUT NOCOPY v_cube_gen_template_function%ROWTYPE, p_ctf_new IN OUT NOCOPY v_cube_gen_template_function%ROWTYPE);
	PROCEDURE delete_ctf (p_cube_rowid IN UROWID, p_ctf IN OUT NOCOPY v_cube_gen_template_function%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_cub_trg IS

	PROCEDURE insert_cub (p_cub IN OUT NOCOPY v_cube_gen_documentation%ROWTYPE) IS
	BEGIN
		p_cub.cube_id := 'CUB-' || TO_CHAR(cub_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_cube_gen_documentation (
			cube_id,
			name,
			description,
			description_functions)
		VALUES (
			p_cub.cube_id,
			p_cub.name,
			p_cub.description,
			p_cub.description_functions);
	END;

	PROCEDURE update_cub (p_cube_rowid UROWID, p_cub_old IN OUT NOCOPY v_cube_gen_documentation%ROWTYPE, p_cub_new IN OUT NOCOPY v_cube_gen_documentation%ROWTYPE) IS
	BEGIN
		UPDATE t_cube_gen_documentation SET 
			description = p_cub_new.description,
			description_functions = p_cub_new.description_functions
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_cub (p_cube_rowid UROWID, p_cub IN OUT NOCOPY v_cube_gen_documentation%ROWTYPE) IS
	BEGIN
		DELETE t_cube_gen_documentation 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_cgp (p_cgp IN OUT NOCOPY v_cube_gen_paragraph%ROWTYPE) IS
	BEGIN
		p_cgp.cube_id := 'CGP-' || TO_CHAR(cgp_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_cube_gen_paragraph (
			cube_id,
			cube_sequence,
			fk_cub_name,
			id,
			header,
			description,
			example)
		VALUES (
			p_cgp.cube_id,
			p_cgp.cube_sequence,
			p_cgp.fk_cub_name,
			p_cgp.id,
			p_cgp.header,
			p_cgp.description,
			p_cgp.example);
	END;

	PROCEDURE update_cgp (p_cube_rowid UROWID, p_cgp_old IN OUT NOCOPY v_cube_gen_paragraph%ROWTYPE, p_cgp_new IN OUT NOCOPY v_cube_gen_paragraph%ROWTYPE) IS
	BEGIN
		UPDATE t_cube_gen_paragraph SET 
			cube_sequence = p_cgp_new.cube_sequence,
			header = p_cgp_new.header,
			description = p_cgp_new.description,
			example = p_cgp_new.example
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_cgp (p_cube_rowid UROWID, p_cgp IN OUT NOCOPY v_cube_gen_paragraph%ROWTYPE) IS
	BEGIN
		DELETE t_cube_gen_paragraph 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_cgm (p_cgm IN OUT NOCOPY v_cube_gen_example_model%ROWTYPE) IS
	BEGIN
		p_cgm.cube_id := 'CGM-' || TO_CHAR(cgm_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_cube_gen_example_model (
			cube_id,
			cube_sequence,
			fk_cub_name,
			id,
			header,
			included_object_names,
			description)
		VALUES (
			p_cgm.cube_id,
			p_cgm.cube_sequence,
			p_cgm.fk_cub_name,
			p_cgm.id,
			p_cgm.header,
			p_cgm.included_object_names,
			p_cgm.description);
	END;

	PROCEDURE update_cgm (p_cube_rowid UROWID, p_cgm_old IN OUT NOCOPY v_cube_gen_example_model%ROWTYPE, p_cgm_new IN OUT NOCOPY v_cube_gen_example_model%ROWTYPE) IS
	BEGIN
		UPDATE t_cube_gen_example_model SET 
			cube_sequence = p_cgm_new.cube_sequence,
			header = p_cgm_new.header,
			included_object_names = p_cgm_new.included_object_names,
			description = p_cgm_new.description
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_cgm (p_cube_rowid UROWID, p_cgm IN OUT NOCOPY v_cube_gen_example_model%ROWTYPE) IS
	BEGIN
		DELETE t_cube_gen_example_model 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_cgo (p_cgo IN OUT NOCOPY v_cube_gen_example_object%ROWTYPE) IS
	BEGIN
		p_cgo.cube_id := 'CGO-' || TO_CHAR(cgo_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_cube_gen_example_object (
			cube_id,
			cube_sequence,
			fk_cub_name,
			fk_cgm_id,
			xk_bot_name)
		VALUES (
			p_cgo.cube_id,
			p_cgo.cube_sequence,
			p_cgo.fk_cub_name,
			p_cgo.fk_cgm_id,
			p_cgo.xk_bot_name);
	END;

	PROCEDURE update_cgo (p_cube_rowid UROWID, p_cgo_old IN OUT NOCOPY v_cube_gen_example_object%ROWTYPE, p_cgo_new IN OUT NOCOPY v_cube_gen_example_object%ROWTYPE) IS
	BEGIN
		UPDATE t_cube_gen_example_object SET 
			cube_sequence = p_cgo_new.cube_sequence
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_cgo (p_cube_rowid UROWID, p_cgo IN OUT NOCOPY v_cube_gen_example_object%ROWTYPE) IS
	BEGIN
		DELETE t_cube_gen_example_object 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_cgf (p_cgf IN OUT NOCOPY v_cube_gen_function%ROWTYPE) IS
	BEGIN
		p_cgf.cube_id := 'CGF-' || TO_CHAR(cgf_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_cube_gen_function (
			cube_id,
			cube_sequence,
			fk_cub_name,
			fk_cgm_id,
			id,
			header,
			description,
			template)
		VALUES (
			p_cgf.cube_id,
			p_cgf.cube_sequence,
			p_cgf.fk_cub_name,
			p_cgf.fk_cgm_id,
			p_cgf.id,
			p_cgf.header,
			p_cgf.description,
			p_cgf.template);
	END;

	PROCEDURE update_cgf (p_cube_rowid UROWID, p_cgf_old IN OUT NOCOPY v_cube_gen_function%ROWTYPE, p_cgf_new IN OUT NOCOPY v_cube_gen_function%ROWTYPE) IS
	BEGIN
		UPDATE t_cube_gen_function SET 
			cube_sequence = p_cgf_new.cube_sequence,
			header = p_cgf_new.header,
			description = p_cgf_new.description,
			template = p_cgf_new.template
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_cgf (p_cube_rowid UROWID, p_cgf IN OUT NOCOPY v_cube_gen_function%ROWTYPE) IS
	BEGIN
		DELETE t_cube_gen_function 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_ctf (p_ctf IN OUT NOCOPY v_cube_gen_template_function%ROWTYPE) IS
	BEGIN
		p_ctf.cube_id := 'CTF-' || TO_CHAR(ctf_seq.NEXTVAL,'FM000000000000');
		INSERT INTO t_cube_gen_template_function (
			cube_id,
			fk_cub_name,
			name,
			indication_logical,
			description,
			syntax)
		VALUES (
			p_ctf.cube_id,
			p_ctf.fk_cub_name,
			p_ctf.name,
			p_ctf.indication_logical,
			p_ctf.description,
			p_ctf.syntax);
	END;

	PROCEDURE update_ctf (p_cube_rowid UROWID, p_ctf_old IN OUT NOCOPY v_cube_gen_template_function%ROWTYPE, p_ctf_new IN OUT NOCOPY v_cube_gen_template_function%ROWTYPE) IS
	BEGIN
		UPDATE t_cube_gen_template_function SET 
			description = p_ctf_new.description,
			syntax = p_ctf_new.syntax
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_ctf (p_cube_rowid UROWID, p_ctf IN OUT NOCOPY v_cube_gen_template_function%ROWTYPE) IS
	BEGIN
		DELETE t_cube_gen_template_function 
		WHERE rowid = p_cube_rowid;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_cub
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_cube_gen_documentation
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_cub_new v_cube_gen_documentation%ROWTYPE;
	r_cub_old v_cube_gen_documentation%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_cub_new.name := REPLACE(:NEW.name,' ','_');
		r_cub_new.description := :NEW.description;
		r_cub_new.description_functions := :NEW.description_functions;
	END IF;
	IF UPDATING THEN
		r_cub_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_cube_gen_documentation
		WHERE name = :OLD.name;
		r_cub_old.name := :OLD.name;
		r_cub_old.description := :OLD.description;
		r_cub_old.description_functions := :OLD.description_functions;
	END IF;

	IF INSERTING THEN 
		pkg_cub_trg.insert_cub (r_cub_new);
	ELSIF UPDATING THEN
		pkg_cub_trg.update_cub (l_cube_rowid, r_cub_old, r_cub_new);
	ELSIF DELETING THEN
		pkg_cub_trg.delete_cub (l_cube_rowid, r_cub_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_cgp
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_cube_gen_paragraph
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_cgp_new v_cube_gen_paragraph%ROWTYPE;
	r_cgp_old v_cube_gen_paragraph%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_cgp_new.cube_sequence := :NEW.cube_sequence;
		r_cgp_new.fk_cub_name := REPLACE(:NEW.fk_cub_name,' ','_');
		r_cgp_new.id := REPLACE(:NEW.id,' ','_');
		r_cgp_new.header := :NEW.header;
		r_cgp_new.description := :NEW.description;
		r_cgp_new.example := :NEW.example;
	END IF;
	IF UPDATING THEN
		r_cgp_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_cube_gen_paragraph
		WHERE fk_cub_name = :OLD.fk_cub_name
		  AND id = :OLD.id;
		r_cgp_old.cube_sequence := :OLD.cube_sequence;
		r_cgp_old.fk_cub_name := :OLD.fk_cub_name;
		r_cgp_old.id := :OLD.id;
		r_cgp_old.header := :OLD.header;
		r_cgp_old.description := :OLD.description;
		r_cgp_old.example := :OLD.example;
	END IF;

	IF INSERTING THEN 
		pkg_cub_trg.insert_cgp (r_cgp_new);
	ELSIF UPDATING THEN
		pkg_cub_trg.update_cgp (l_cube_rowid, r_cgp_old, r_cgp_new);
	ELSIF DELETING THEN
		pkg_cub_trg.delete_cgp (l_cube_rowid, r_cgp_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_cgm
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_cube_gen_example_model
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_cgm_new v_cube_gen_example_model%ROWTYPE;
	r_cgm_old v_cube_gen_example_model%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_cgm_new.cube_sequence := :NEW.cube_sequence;
		r_cgm_new.fk_cub_name := REPLACE(:NEW.fk_cub_name,' ','_');
		r_cgm_new.id := REPLACE(:NEW.id,' ','_');
		r_cgm_new.header := :NEW.header;
		r_cgm_new.included_object_names := :NEW.included_object_names;
		r_cgm_new.description := :NEW.description;
	END IF;
	IF UPDATING THEN
		r_cgm_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_cube_gen_example_model
		WHERE fk_cub_name = :OLD.fk_cub_name
		  AND id = :OLD.id;
		r_cgm_old.cube_sequence := :OLD.cube_sequence;
		r_cgm_old.fk_cub_name := :OLD.fk_cub_name;
		r_cgm_old.id := :OLD.id;
		r_cgm_old.header := :OLD.header;
		r_cgm_old.included_object_names := :OLD.included_object_names;
		r_cgm_old.description := :OLD.description;
	END IF;

	IF INSERTING THEN 
		pkg_cub_trg.insert_cgm (r_cgm_new);
	ELSIF UPDATING THEN
		pkg_cub_trg.update_cgm (l_cube_rowid, r_cgm_old, r_cgm_new);
	ELSIF DELETING THEN
		pkg_cub_trg.delete_cgm (l_cube_rowid, r_cgm_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_cgo
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_cube_gen_example_object
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_cgo_new v_cube_gen_example_object%ROWTYPE;
	r_cgo_old v_cube_gen_example_object%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_cgo_new.cube_sequence := :NEW.cube_sequence;
		r_cgo_new.fk_cub_name := REPLACE(:NEW.fk_cub_name,' ','_');
		r_cgo_new.fk_cgm_id := REPLACE(:NEW.fk_cgm_id,' ','_');
		r_cgo_new.xk_bot_name := REPLACE(:NEW.xk_bot_name,' ','_');
	END IF;
	IF UPDATING THEN
		r_cgo_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_cube_gen_example_object
		WHERE fk_cub_name = :OLD.fk_cub_name
		  AND fk_cgm_id = :OLD.fk_cgm_id
		  AND xk_bot_name = :OLD.xk_bot_name;
		r_cgo_old.cube_sequence := :OLD.cube_sequence;
		r_cgo_old.fk_cub_name := :OLD.fk_cub_name;
		r_cgo_old.fk_cgm_id := :OLD.fk_cgm_id;
		r_cgo_old.xk_bot_name := :OLD.xk_bot_name;
	END IF;

	IF INSERTING THEN 
		pkg_cub_trg.insert_cgo (r_cgo_new);
	ELSIF UPDATING THEN
		pkg_cub_trg.update_cgo (l_cube_rowid, r_cgo_old, r_cgo_new);
	ELSIF DELETING THEN
		pkg_cub_trg.delete_cgo (l_cube_rowid, r_cgo_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_cgf
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_cube_gen_function
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_cgf_new v_cube_gen_function%ROWTYPE;
	r_cgf_old v_cube_gen_function%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_cgf_new.cube_sequence := :NEW.cube_sequence;
		r_cgf_new.fk_cub_name := REPLACE(:NEW.fk_cub_name,' ','_');
		r_cgf_new.fk_cgm_id := REPLACE(:NEW.fk_cgm_id,' ','_');
		r_cgf_new.id := REPLACE(:NEW.id,' ','_');
		r_cgf_new.header := :NEW.header;
		r_cgf_new.description := :NEW.description;
		r_cgf_new.template := :NEW.template;
	END IF;
	IF UPDATING THEN
		r_cgf_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_cube_gen_function
		WHERE id = :OLD.id;
		r_cgf_old.cube_sequence := :OLD.cube_sequence;
		r_cgf_old.fk_cub_name := :OLD.fk_cub_name;
		r_cgf_old.fk_cgm_id := :OLD.fk_cgm_id;
		r_cgf_old.id := :OLD.id;
		r_cgf_old.header := :OLD.header;
		r_cgf_old.description := :OLD.description;
		r_cgf_old.template := :OLD.template;
	END IF;

	IF INSERTING THEN 
		pkg_cub_trg.insert_cgf (r_cgf_new);
	ELSIF UPDATING THEN
		pkg_cub_trg.update_cgf (l_cube_rowid, r_cgf_old, r_cgf_new);
	ELSIF DELETING THEN
		pkg_cub_trg.delete_cgf (l_cube_rowid, r_cgf_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_ctf
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_cube_gen_template_function
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_ctf_new v_cube_gen_template_function%ROWTYPE;
	r_ctf_old v_cube_gen_template_function%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_ctf_new.fk_cub_name := REPLACE(:NEW.fk_cub_name,' ','_');
		r_ctf_new.name := REPLACE(:NEW.name,' ','_');
		r_ctf_new.indication_logical := :NEW.indication_logical;
		r_ctf_new.description := :NEW.description;
		r_ctf_new.syntax := :NEW.syntax;
	END IF;
	IF UPDATING THEN
		r_ctf_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_cube_gen_template_function
		WHERE fk_cub_name = :OLD.fk_cub_name
		  AND name = :OLD.name
		  AND indication_logical = :OLD.indication_logical;
		r_ctf_old.fk_cub_name := :OLD.fk_cub_name;
		r_ctf_old.name := :OLD.name;
		r_ctf_old.indication_logical := :OLD.indication_logical;
		r_ctf_old.description := :OLD.description;
		r_ctf_old.syntax := :OLD.syntax;
	END IF;

	IF INSERTING THEN 
		pkg_cub_trg.insert_ctf (r_ctf_new);
	ELSIF UPDATING THEN
		pkg_cub_trg.update_ctf (l_cube_rowid, r_ctf_old, r_ctf_new);
	ELSIF DELETING THEN
		pkg_cub_trg.delete_ctf (l_cube_rowid, r_ctf_old);
	END IF;
END;
/
SHOW ERRORS

EXIT;