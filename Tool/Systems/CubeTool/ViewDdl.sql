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
		WHERE procedure_name = 'CUBE_TRG_CUBETOOL' )
	LOOP
		EXECUTE IMMEDIATE 'DROP PACKAGE '||r_p.object_name;
	END LOOP;
END;
/
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
	FUNCTION cube_trg_cubetool RETURN VARCHAR2;
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

	FUNCTION cube_trg_cubetool RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubetool';
	END;

	PROCEDURE insert_itp (p_itp IN OUT NOCOPY v_information_type%ROWTYPE) IS
	BEGIN
		p_itp.cube_id := 'ITP-' || TO_CHAR(sq_itp.NEXTVAL,'FM000000000000');
		p_itp.name := NVL(p_itp.name,' ');
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
		p_ite.cube_id := 'ITE-' || TO_CHAR(sq_ite.NEXTVAL,'FM000000000000');
		p_ite.fk_itp_name := NVL(p_ite.fk_itp_name,' ');
		p_ite.sequence := NVL(p_ite.sequence,0);
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
		p_val.cube_id := 'VAL-' || TO_CHAR(sq_val.NEXTVAL,'FM000000000000');
		p_val.fk_itp_name := NVL(p_val.fk_itp_name,' ');
		p_val.fk_ite_sequence := NVL(p_val.fk_ite_sequence,0);
		p_val.code := NVL(p_val.code,' ');
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
		IF :NEW.name = ' ' THEN
			r_itp_new.name := ' ';
		ELSE
			r_itp_new.name := REPLACE(:NEW.name,' ','_');
		END IF;
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
		IF :NEW.fk_itp_name = ' ' THEN
			r_ite_new.fk_itp_name := ' ';
		ELSE
			r_ite_new.fk_itp_name := REPLACE(:NEW.fk_itp_name,' ','_');
		END IF;
		r_ite_new.sequence := :NEW.sequence;
		IF :NEW.suffix = ' ' THEN
			r_ite_new.suffix := ' ';
		ELSE
			r_ite_new.suffix := REPLACE(:NEW.suffix,' ','_');
		END IF;
		IF :NEW.domain = ' ' THEN
			r_ite_new.domain := ' ';
		ELSE
			r_ite_new.domain := REPLACE(:NEW.domain,' ','_');
		END IF;
		r_ite_new.length := :NEW.length;
		r_ite_new.decimals := :NEW.decimals;
		r_ite_new.case_sensitive := :NEW.case_sensitive;
		r_ite_new.default_value := :NEW.default_value;
		r_ite_new.spaces_allowed := :NEW.spaces_allowed;
		IF :NEW.presentation = ' ' THEN
			r_ite_new.presentation := ' ';
		ELSE
			r_ite_new.presentation := REPLACE(:NEW.presentation,' ','_');
		END IF;
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
		IF :NEW.fk_itp_name = ' ' THEN
			r_val_new.fk_itp_name := ' ';
		ELSE
			r_val_new.fk_itp_name := REPLACE(:NEW.fk_itp_name,' ','_');
		END IF;
		r_val_new.fk_ite_sequence := :NEW.fk_ite_sequence;
		IF :NEW.code = ' ' THEN
			r_val_new.code := ' ';
		ELSE
			r_val_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
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
		cube_tsg_type,
		directory,
		api_url
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
		primary_key,
		xf_atb_typ_name,
		xk_atb_name
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
		within_scope_extension,
		cube_tsg_int_ext,
		xk_bot_name,
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
		fk_ref_bot_name,
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
		fk_ref_bot_name,
		fk_ref_typ_name,
		include_or_exclude,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM t_restriction_type_spec_ref
/
CREATE OR REPLACE VIEW v_restriction_target_type_spec AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		fk_ref_sequence,
		fk_ref_bot_name,
		fk_ref_typ_name,
		include_or_exclude,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM t_restriction_target_type_spec
/
CREATE OR REPLACE VIEW v_restriction_type_spec_typ AS 
	SELECT
		cube_id,
		fk_bot_name,
		fk_typ_name,
		include_or_exclude,
		xf_tsp_typ_name,
		xf_tsp_tsg_code,
		xk_tsp_code
	FROM t_restriction_type_spec_typ
/
CREATE OR REPLACE VIEW v_json_path AS 
	SELECT
		cube_id,
		cube_sequence,
		cube_level,
		fk_bot_name,
		fk_typ_name,
		fk_jsn_name,
		fk_jsn_location,
		fk_jsn_atb_typ_name,
		fk_jsn_atb_name,
		fk_jsn_typ_name,
		cube_tsg_obj_arr,
		cube_tsg_type,
		name,
		location,
		xf_atb_typ_name,
		xk_atb_name,
		xk_typ_name
	FROM t_json_path
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
	FUNCTION cube_trg_cubetool RETURN VARCHAR2;
	PROCEDURE insert_bot (p_bot IN OUT NOCOPY v_business_object_type%ROWTYPE);
	PROCEDURE update_bot (p_cube_rowid IN UROWID, p_bot_old IN OUT NOCOPY v_business_object_type%ROWTYPE, p_bot_new IN OUT NOCOPY v_business_object_type%ROWTYPE);
	PROCEDURE delete_bot (p_cube_rowid IN UROWID, p_bot IN OUT NOCOPY v_business_object_type%ROWTYPE);
	PROCEDURE insert_typ (p_typ IN OUT NOCOPY v_type%ROWTYPE);
	PROCEDURE update_typ (p_cube_rowid IN UROWID, p_typ_old IN OUT NOCOPY v_type%ROWTYPE, p_typ_new IN OUT NOCOPY v_type%ROWTYPE);
	PROCEDURE delete_typ (p_cube_rowid IN UROWID, p_typ IN OUT NOCOPY v_type%ROWTYPE);
	PROCEDURE denorm_typ_typ (p_typ IN OUT NOCOPY v_type%ROWTYPE, p_typ_in IN v_type%ROWTYPE);
	PROCEDURE get_denorm_typ_typ (p_typ IN OUT NOCOPY v_type%ROWTYPE);
	PROCEDURE insert_tsg (p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE);
	PROCEDURE update_tsg (p_cube_rowid IN UROWID, p_tsg_old IN OUT NOCOPY v_type_specialisation_group%ROWTYPE, p_tsg_new IN OUT NOCOPY v_type_specialisation_group%ROWTYPE);
	PROCEDURE delete_tsg (p_cube_rowid IN UROWID, p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE);
	PROCEDURE denorm_tsg_tsg (p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE, p_tsg_in IN v_type_specialisation_group%ROWTYPE);
	PROCEDURE get_denorm_tsg_tsg (p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE);
	PROCEDURE insert_tsp (p_tsp IN OUT NOCOPY v_type_specialisation%ROWTYPE);
	PROCEDURE update_tsp (p_cube_rowid IN UROWID, p_tsp_old IN OUT NOCOPY v_type_specialisation%ROWTYPE, p_tsp_new IN OUT NOCOPY v_type_specialisation%ROWTYPE);
	PROCEDURE delete_tsp (p_cube_rowid IN UROWID, p_tsp IN OUT NOCOPY v_type_specialisation%ROWTYPE);
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
	PROCEDURE insert_rts (p_rts IN OUT NOCOPY v_restriction_target_type_spec%ROWTYPE);
	PROCEDURE update_rts (p_cube_rowid IN UROWID, p_rts_old IN OUT NOCOPY v_restriction_target_type_spec%ROWTYPE, p_rts_new IN OUT NOCOPY v_restriction_target_type_spec%ROWTYPE);
	PROCEDURE delete_rts (p_cube_rowid IN UROWID, p_rts IN OUT NOCOPY v_restriction_target_type_spec%ROWTYPE);
	PROCEDURE insert_rtt (p_rtt IN OUT NOCOPY v_restriction_type_spec_typ%ROWTYPE);
	PROCEDURE update_rtt (p_cube_rowid IN UROWID, p_rtt_old IN OUT NOCOPY v_restriction_type_spec_typ%ROWTYPE, p_rtt_new IN OUT NOCOPY v_restriction_type_spec_typ%ROWTYPE);
	PROCEDURE delete_rtt (p_cube_rowid IN UROWID, p_rtt IN OUT NOCOPY v_restriction_type_spec_typ%ROWTYPE);
	PROCEDURE insert_jsn (p_jsn IN OUT NOCOPY v_json_path%ROWTYPE);
	PROCEDURE update_jsn (p_cube_rowid IN UROWID, p_jsn_old IN OUT NOCOPY v_json_path%ROWTYPE, p_jsn_new IN OUT NOCOPY v_json_path%ROWTYPE);
	PROCEDURE delete_jsn (p_cube_rowid IN UROWID, p_jsn IN OUT NOCOPY v_json_path%ROWTYPE);
	PROCEDURE denorm_jsn_jsn (p_jsn IN OUT NOCOPY v_json_path%ROWTYPE, p_jsn_in IN v_json_path%ROWTYPE);
	PROCEDURE get_denorm_jsn_jsn (p_jsn IN OUT NOCOPY v_json_path%ROWTYPE);
	PROCEDURE insert_dct (p_dct IN OUT NOCOPY v_description_type%ROWTYPE);
	PROCEDURE update_dct (p_cube_rowid IN UROWID, p_dct_old IN OUT NOCOPY v_description_type%ROWTYPE, p_dct_new IN OUT NOCOPY v_description_type%ROWTYPE);
	PROCEDURE delete_dct (p_cube_rowid IN UROWID, p_dct IN OUT NOCOPY v_description_type%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_bot_trg IS

	FUNCTION cube_trg_cubetool RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubetool';
	END;

	PROCEDURE insert_bot (p_bot IN OUT NOCOPY v_business_object_type%ROWTYPE) IS
	BEGIN
		p_bot.cube_id := 'BOT-' || TO_CHAR(sq_bot.NEXTVAL,'FM000000000000');
		p_bot.name := NVL(p_bot.name,' ');
		INSERT INTO t_business_object_type (
			cube_id,
			cube_sequence,
			name,
			cube_tsg_type,
			directory,
			api_url)
		VALUES (
			p_bot.cube_id,
			p_bot.cube_sequence,
			p_bot.name,
			p_bot.cube_tsg_type,
			p_bot.directory,
			p_bot.api_url);
	END;

	PROCEDURE update_bot (p_cube_rowid UROWID, p_bot_old IN OUT NOCOPY v_business_object_type%ROWTYPE, p_bot_new IN OUT NOCOPY v_business_object_type%ROWTYPE) IS
	BEGIN
		UPDATE t_business_object_type SET 
			cube_sequence = p_bot_new.cube_sequence,
			directory = p_bot_new.directory,
			api_url = p_bot_new.api_url
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_bot (p_cube_rowid UROWID, p_bot IN OUT NOCOPY v_business_object_type%ROWTYPE) IS
	BEGIN
		DELETE t_business_object_type 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_typ (p_typ IN OUT NOCOPY v_type%ROWTYPE) IS
	BEGIN
		p_typ.cube_id := 'TYP-' || TO_CHAR(sq_typ.NEXTVAL,'FM000000000000');
		p_typ.fk_bot_name := NVL(p_typ.fk_bot_name,' ');
		p_typ.name := NVL(p_typ.name,' ');
		IF p_typ.fk_typ_name IS NOT NULL  THEN
			-- Recursive
			SELECT fk_bot_name
			  INTO p_typ.fk_bot_name
			FROM t_type
			WHERE fk_bot_name = p_typ.fk_bot_name
			  AND name = p_typ.fk_typ_name;
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

		CURSOR c_typ IS
			SELECT ROWID cube_row_id, typ.* FROM v_type typ
			WHERE fk_typ_name = p_typ_old.name;
		
		l_typ_rowid UROWID;
		r_typ_old v_type%ROWTYPE;
		r_typ_new v_type%ROWTYPE;
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
		IF NVL(p_typ_old.cube_level,0) <> NVL(p_typ_new.cube_level,0) THEN
			OPEN c_typ;
			LOOP
				FETCH c_typ INTO
					l_typ_rowid,
					r_typ_old.cube_id,
					r_typ_old.cube_sequence,
					r_typ_old.cube_level,
					r_typ_old.fk_bot_name,
					r_typ_old.fk_typ_name,
					r_typ_old.name,
					r_typ_old.code,
					r_typ_old.flag_partial_key,
					r_typ_old.flag_recursive,
					r_typ_old.recursive_cardinality,
					r_typ_old.cardinality,
					r_typ_old.sort_order,
					r_typ_old.icon,
					r_typ_old.transferable;
				EXIT WHEN c_typ%NOTFOUND;
				r_typ_new := r_typ_old;
				denorm_typ_typ (r_typ_new, p_typ_new);
				update_typ (l_typ_rowid, r_typ_old, r_typ_new);
			END LOOP;
			CLOSE c_typ;
		END IF;
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

	PROCEDURE insert_tsg (p_tsg IN OUT NOCOPY v_type_specialisation_group%ROWTYPE) IS
	BEGIN
		p_tsg.cube_id := 'TSG-' || TO_CHAR(sq_tsg.NEXTVAL,'FM000000000000');
		p_tsg.fk_bot_name := NVL(p_tsg.fk_bot_name,' ');
		p_tsg.fk_typ_name := NVL(p_tsg.fk_typ_name,' ');
		p_tsg.code := NVL(p_tsg.code,' ');
		p_tsg.xf_atb_typ_name := NVL(p_tsg.xf_atb_typ_name,' ');
		p_tsg.xk_atb_name := NVL(p_tsg.xk_atb_name,' ');
		IF p_tsg.fk_tsg_code IS NOT NULL  THEN
			-- Recursive
			SELECT fk_bot_name
			  INTO p_tsg.fk_bot_name
			FROM t_type_specialisation_group
			WHERE fk_typ_name = p_tsg.fk_typ_name
			  AND code = p_tsg.fk_tsg_code;
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
			primary_key,
			xf_atb_typ_name,
			xk_atb_name)
		VALUES (
			p_tsg.cube_id,
			p_tsg.cube_sequence,
			p_tsg.cube_level,
			p_tsg.fk_bot_name,
			p_tsg.fk_typ_name,
			p_tsg.fk_tsg_code,
			p_tsg.code,
			p_tsg.name,
			p_tsg.primary_key,
			p_tsg.xf_atb_typ_name,
			p_tsg.xk_atb_name);
	END;

	PROCEDURE update_tsg (p_cube_rowid UROWID, p_tsg_old IN OUT NOCOPY v_type_specialisation_group%ROWTYPE, p_tsg_new IN OUT NOCOPY v_type_specialisation_group%ROWTYPE) IS

		CURSOR c_tsg IS
			SELECT ROWID cube_row_id, tsg.* FROM v_type_specialisation_group tsg
			WHERE fk_typ_name = p_tsg_old.fk_typ_name
			  AND fk_tsg_code = p_tsg_old.code;
		
		l_tsg_rowid UROWID;
		r_tsg_old v_type_specialisation_group%ROWTYPE;
		r_tsg_new v_type_specialisation_group%ROWTYPE;
	BEGIN
		IF NVL(p_tsg_old.fk_tsg_code,' ') <> NVL(p_tsg_new.fk_tsg_code,' ')  THEN
			get_denorm_tsg_tsg (p_tsg_new);
		END IF;
		UPDATE t_type_specialisation_group SET 
			cube_sequence = p_tsg_new.cube_sequence,
			cube_level = p_tsg_new.cube_level,
			fk_tsg_code = p_tsg_new.fk_tsg_code,
			name = p_tsg_new.name,
			primary_key = p_tsg_new.primary_key,
			xf_atb_typ_name = p_tsg_new.xf_atb_typ_name,
			xk_atb_name = p_tsg_new.xk_atb_name
		WHERE rowid = p_cube_rowid;
		IF NVL(p_tsg_old.cube_level,0) <> NVL(p_tsg_new.cube_level,0) THEN
			OPEN c_tsg;
			LOOP
				FETCH c_tsg INTO
					l_tsg_rowid,
					r_tsg_old.cube_id,
					r_tsg_old.cube_sequence,
					r_tsg_old.cube_level,
					r_tsg_old.fk_bot_name,
					r_tsg_old.fk_typ_name,
					r_tsg_old.fk_tsg_code,
					r_tsg_old.code,
					r_tsg_old.name,
					r_tsg_old.primary_key,
					r_tsg_old.xf_atb_typ_name,
					r_tsg_old.xk_atb_name;
				EXIT WHEN c_tsg%NOTFOUND;
				r_tsg_new := r_tsg_old;
				denorm_tsg_tsg (r_tsg_new, p_tsg_new);
				update_tsg (l_tsg_rowid, r_tsg_old, r_tsg_new);
			END LOOP;
			CLOSE c_tsg;
		END IF;
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
		p_tsp.cube_id := 'TSP-' || TO_CHAR(sq_tsp.NEXTVAL,'FM000000000000');
		p_tsp.fk_bot_name := NVL(p_tsp.fk_bot_name,' ');
		p_tsp.fk_typ_name := NVL(p_tsp.fk_typ_name,' ');
		p_tsp.fk_tsg_code := NVL(p_tsp.fk_tsg_code,' ');
		p_tsp.code := NVL(p_tsp.code,' ');
		p_tsp.xf_tsp_typ_name := NVL(p_tsp.xf_tsp_typ_name,' ');
		p_tsp.xf_tsp_tsg_code := NVL(p_tsp.xf_tsp_tsg_code,' ');
		p_tsp.xk_tsp_code := NVL(p_tsp.xk_tsp_code,' ');
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

	PROCEDURE insert_atb (p_atb IN OUT NOCOPY v_attribute%ROWTYPE) IS
	BEGIN
		p_atb.cube_id := 'ATB-' || TO_CHAR(sq_atb.NEXTVAL,'FM000000000000');
		p_atb.fk_bot_name := NVL(p_atb.fk_bot_name,' ');
		p_atb.fk_typ_name := NVL(p_atb.fk_typ_name,' ');
		p_atb.name := NVL(p_atb.name,' ');
		p_atb.xk_itp_name := NVL(p_atb.xk_itp_name,' ');
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
		p_der.cube_id := 'DER-' || TO_CHAR(sq_der.NEXTVAL,'FM000000000000');
		p_der.fk_bot_name := NVL(p_der.fk_bot_name,' ');
		p_der.fk_typ_name := NVL(p_der.fk_typ_name,' ');
		p_der.fk_atb_name := NVL(p_der.fk_atb_name,' ');
		p_der.xk_typ_name := NVL(p_der.xk_typ_name,' ');
		p_der.xk_typ_name_1 := NVL(p_der.xk_typ_name_1,' ');
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
		p_dca.cube_id := 'DCA-' || TO_CHAR(sq_dca.NEXTVAL,'FM000000000000');
		p_dca.fk_bot_name := NVL(p_dca.fk_bot_name,' ');
		p_dca.fk_typ_name := NVL(p_dca.fk_typ_name,' ');
		p_dca.fk_atb_name := NVL(p_dca.fk_atb_name,' ');
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
		p_rta.cube_id := 'RTA-' || TO_CHAR(sq_rta.NEXTVAL,'FM000000000000');
		p_rta.fk_bot_name := NVL(p_rta.fk_bot_name,' ');
		p_rta.fk_typ_name := NVL(p_rta.fk_typ_name,' ');
		p_rta.fk_atb_name := NVL(p_rta.fk_atb_name,' ');
		p_rta.xf_tsp_typ_name := NVL(p_rta.xf_tsp_typ_name,' ');
		p_rta.xf_tsp_tsg_code := NVL(p_rta.xf_tsp_tsg_code,' ');
		p_rta.xk_tsp_code := NVL(p_rta.xk_tsp_code,' ');
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
		p_ref.cube_id := 'REF-' || TO_CHAR(sq_ref.NEXTVAL,'FM000000000000');
		p_ref.fk_bot_name := NVL(p_ref.fk_bot_name,' ');
		p_ref.fk_typ_name := NVL(p_ref.fk_typ_name,' ');
		p_ref.sequence := NVL(p_ref.sequence,0);
		p_ref.xk_bot_name := NVL(p_ref.xk_bot_name,' ');
		p_ref.xk_typ_name := NVL(p_ref.xk_typ_name,' ');
		p_ref.xk_typ_name_1 := NVL(p_ref.xk_typ_name_1,' ');
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
			within_scope_extension,
			cube_tsg_int_ext,
			xk_bot_name,
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
			p_ref.within_scope_extension,
			p_ref.cube_tsg_int_ext,
			p_ref.xk_bot_name,
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
			within_scope_extension = p_ref_new.within_scope_extension,
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
		p_dcr.cube_id := 'DCR-' || TO_CHAR(sq_dcr.NEXTVAL,'FM000000000000');
		p_dcr.fk_bot_name := NVL(p_dcr.fk_bot_name,' ');
		p_dcr.fk_typ_name := NVL(p_dcr.fk_typ_name,' ');
		p_dcr.fk_ref_sequence := NVL(p_dcr.fk_ref_sequence,0);
		p_dcr.fk_ref_bot_name := NVL(p_dcr.fk_ref_bot_name,' ');
		p_dcr.fk_ref_typ_name := NVL(p_dcr.fk_ref_typ_name,' ');
		SELECT fk_bot_name
		  INTO p_dcr.fk_bot_name
		FROM t_reference
		WHERE fk_typ_name = p_dcr.fk_typ_name
		  AND sequence = p_dcr.fk_ref_sequence
		  AND xk_bot_name = p_dcr.fk_ref_bot_name
		  AND xk_typ_name = p_dcr.fk_ref_typ_name;
		INSERT INTO t_description_reference (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_bot_name,
			fk_ref_typ_name,
			text)
		VALUES (
			p_dcr.cube_id,
			p_dcr.fk_bot_name,
			p_dcr.fk_typ_name,
			p_dcr.fk_ref_sequence,
			p_dcr.fk_ref_bot_name,
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
		p_rtr.cube_id := 'RTR-' || TO_CHAR(sq_rtr.NEXTVAL,'FM000000000000');
		p_rtr.fk_bot_name := NVL(p_rtr.fk_bot_name,' ');
		p_rtr.fk_typ_name := NVL(p_rtr.fk_typ_name,' ');
		p_rtr.fk_ref_sequence := NVL(p_rtr.fk_ref_sequence,0);
		p_rtr.fk_ref_bot_name := NVL(p_rtr.fk_ref_bot_name,' ');
		p_rtr.fk_ref_typ_name := NVL(p_rtr.fk_ref_typ_name,' ');
		p_rtr.xf_tsp_typ_name := NVL(p_rtr.xf_tsp_typ_name,' ');
		p_rtr.xf_tsp_tsg_code := NVL(p_rtr.xf_tsp_tsg_code,' ');
		p_rtr.xk_tsp_code := NVL(p_rtr.xk_tsp_code,' ');
		SELECT fk_bot_name
		  INTO p_rtr.fk_bot_name
		FROM t_reference
		WHERE fk_typ_name = p_rtr.fk_typ_name
		  AND sequence = p_rtr.fk_ref_sequence
		  AND xk_bot_name = p_rtr.fk_ref_bot_name
		  AND xk_typ_name = p_rtr.fk_ref_typ_name;
		INSERT INTO t_restriction_type_spec_ref (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_bot_name,
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
			p_rtr.fk_ref_bot_name,
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

	PROCEDURE insert_rts (p_rts IN OUT NOCOPY v_restriction_target_type_spec%ROWTYPE) IS
	BEGIN
		p_rts.cube_id := 'RTS-' || TO_CHAR(sq_rts.NEXTVAL,'FM000000000000');
		p_rts.fk_bot_name := NVL(p_rts.fk_bot_name,' ');
		p_rts.fk_typ_name := NVL(p_rts.fk_typ_name,' ');
		p_rts.fk_ref_sequence := NVL(p_rts.fk_ref_sequence,0);
		p_rts.fk_ref_bot_name := NVL(p_rts.fk_ref_bot_name,' ');
		p_rts.fk_ref_typ_name := NVL(p_rts.fk_ref_typ_name,' ');
		p_rts.xf_tsp_typ_name := NVL(p_rts.xf_tsp_typ_name,' ');
		p_rts.xf_tsp_tsg_code := NVL(p_rts.xf_tsp_tsg_code,' ');
		p_rts.xk_tsp_code := NVL(p_rts.xk_tsp_code,' ');
		SELECT fk_bot_name
		  INTO p_rts.fk_bot_name
		FROM t_reference
		WHERE fk_typ_name = p_rts.fk_typ_name
		  AND sequence = p_rts.fk_ref_sequence
		  AND xk_bot_name = p_rts.fk_ref_bot_name
		  AND xk_typ_name = p_rts.fk_ref_typ_name;
		INSERT INTO t_restriction_target_type_spec (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			fk_ref_sequence,
			fk_ref_bot_name,
			fk_ref_typ_name,
			include_or_exclude,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			p_rts.cube_id,
			p_rts.fk_bot_name,
			p_rts.fk_typ_name,
			p_rts.fk_ref_sequence,
			p_rts.fk_ref_bot_name,
			p_rts.fk_ref_typ_name,
			p_rts.include_or_exclude,
			p_rts.xf_tsp_typ_name,
			p_rts.xf_tsp_tsg_code,
			p_rts.xk_tsp_code);
	END;

	PROCEDURE update_rts (p_cube_rowid UROWID, p_rts_old IN OUT NOCOPY v_restriction_target_type_spec%ROWTYPE, p_rts_new IN OUT NOCOPY v_restriction_target_type_spec%ROWTYPE) IS
	BEGIN
		UPDATE t_restriction_target_type_spec SET 
			include_or_exclude = p_rts_new.include_or_exclude
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_rts (p_cube_rowid UROWID, p_rts IN OUT NOCOPY v_restriction_target_type_spec%ROWTYPE) IS
	BEGIN
		DELETE t_restriction_target_type_spec 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_rtt (p_rtt IN OUT NOCOPY v_restriction_type_spec_typ%ROWTYPE) IS
	BEGIN
		p_rtt.cube_id := 'RTT-' || TO_CHAR(sq_rtt.NEXTVAL,'FM000000000000');
		p_rtt.fk_bot_name := NVL(p_rtt.fk_bot_name,' ');
		p_rtt.fk_typ_name := NVL(p_rtt.fk_typ_name,' ');
		p_rtt.xf_tsp_typ_name := NVL(p_rtt.xf_tsp_typ_name,' ');
		p_rtt.xf_tsp_tsg_code := NVL(p_rtt.xf_tsp_tsg_code,' ');
		p_rtt.xk_tsp_code := NVL(p_rtt.xk_tsp_code,' ');
		SELECT fk_bot_name
		  INTO p_rtt.fk_bot_name
		FROM t_type
		WHERE name = p_rtt.fk_typ_name;
		INSERT INTO t_restriction_type_spec_typ (
			cube_id,
			fk_bot_name,
			fk_typ_name,
			include_or_exclude,
			xf_tsp_typ_name,
			xf_tsp_tsg_code,
			xk_tsp_code)
		VALUES (
			p_rtt.cube_id,
			p_rtt.fk_bot_name,
			p_rtt.fk_typ_name,
			p_rtt.include_or_exclude,
			p_rtt.xf_tsp_typ_name,
			p_rtt.xf_tsp_tsg_code,
			p_rtt.xk_tsp_code);
	END;

	PROCEDURE update_rtt (p_cube_rowid UROWID, p_rtt_old IN OUT NOCOPY v_restriction_type_spec_typ%ROWTYPE, p_rtt_new IN OUT NOCOPY v_restriction_type_spec_typ%ROWTYPE) IS
	BEGIN
		UPDATE t_restriction_type_spec_typ SET 
			include_or_exclude = p_rtt_new.include_or_exclude
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_rtt (p_cube_rowid UROWID, p_rtt IN OUT NOCOPY v_restriction_type_spec_typ%ROWTYPE) IS
	BEGIN
		DELETE t_restriction_type_spec_typ 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_jsn (p_jsn IN OUT NOCOPY v_json_path%ROWTYPE) IS
	BEGIN
		p_jsn.cube_id := 'JSN-' || TO_CHAR(sq_jsn.NEXTVAL,'FM000000000000');
		p_jsn.fk_bot_name := NVL(p_jsn.fk_bot_name,' ');
		p_jsn.fk_typ_name := NVL(p_jsn.fk_typ_name,' ');
		p_jsn.name := NVL(p_jsn.name,' ');
		p_jsn.location := NVL(p_jsn.location,0);
		p_jsn.xf_atb_typ_name := NVL(p_jsn.xf_atb_typ_name,' ');
		p_jsn.xk_atb_name := NVL(p_jsn.xk_atb_name,' ');
		p_jsn.xk_typ_name := NVL(p_jsn.xk_typ_name,' ');
		IF p_jsn.fk_jsn_name IS NOT NULL OR p_jsn.fk_jsn_location IS NOT NULL OR p_jsn.fk_jsn_atb_typ_name IS NOT NULL OR p_jsn.fk_jsn_atb_name IS NOT NULL OR p_jsn.fk_jsn_typ_name IS NOT NULL  THEN
			-- Recursive
			SELECT fk_bot_name
			  INTO p_jsn.fk_bot_name
			FROM t_json_path
			WHERE fk_typ_name = p_jsn.fk_typ_name
			  AND name = p_jsn.fk_jsn_name
			  AND location = p_jsn.fk_jsn_location
			  AND xf_atb_typ_name = p_jsn.fk_jsn_atb_typ_name
			  AND xk_atb_name = p_jsn.fk_jsn_atb_name
			  AND xk_typ_name = p_jsn.fk_jsn_typ_name;
		ELSE
			-- Parent
			SELECT fk_bot_name
			  INTO p_jsn.fk_bot_name
			FROM t_type
			WHERE name = p_jsn.fk_typ_name;
			
		END IF;
		get_denorm_jsn_jsn (p_jsn);
		INSERT INTO t_json_path (
			cube_id,
			cube_sequence,
			cube_level,
			fk_bot_name,
			fk_typ_name,
			fk_jsn_name,
			fk_jsn_location,
			fk_jsn_atb_typ_name,
			fk_jsn_atb_name,
			fk_jsn_typ_name,
			cube_tsg_obj_arr,
			cube_tsg_type,
			name,
			location,
			xf_atb_typ_name,
			xk_atb_name,
			xk_typ_name)
		VALUES (
			p_jsn.cube_id,
			p_jsn.cube_sequence,
			p_jsn.cube_level,
			p_jsn.fk_bot_name,
			p_jsn.fk_typ_name,
			p_jsn.fk_jsn_name,
			p_jsn.fk_jsn_location,
			p_jsn.fk_jsn_atb_typ_name,
			p_jsn.fk_jsn_atb_name,
			p_jsn.fk_jsn_typ_name,
			p_jsn.cube_tsg_obj_arr,
			p_jsn.cube_tsg_type,
			p_jsn.name,
			p_jsn.location,
			p_jsn.xf_atb_typ_name,
			p_jsn.xk_atb_name,
			p_jsn.xk_typ_name);
	END;

	PROCEDURE update_jsn (p_cube_rowid UROWID, p_jsn_old IN OUT NOCOPY v_json_path%ROWTYPE, p_jsn_new IN OUT NOCOPY v_json_path%ROWTYPE) IS

		CURSOR c_jsn IS
			SELECT ROWID cube_row_id, jsn.* FROM v_json_path jsn
			WHERE fk_typ_name = p_jsn_old.fk_typ_name
			  AND fk_jsn_name = p_jsn_old.name
			  AND fk_jsn_location = p_jsn_old.location
			  AND fk_jsn_atb_typ_name = p_jsn_old.xf_atb_typ_name
			  AND fk_jsn_atb_name = p_jsn_old.xk_atb_name
			  AND fk_jsn_typ_name = p_jsn_old.xk_typ_name;
		
		l_jsn_rowid UROWID;
		r_jsn_old v_json_path%ROWTYPE;
		r_jsn_new v_json_path%ROWTYPE;
	BEGIN
		IF NVL(p_jsn_old.fk_jsn_name,' ') <> NVL(p_jsn_new.fk_jsn_name,' ') 
		OR NVL(p_jsn_old.fk_jsn_location,0) <> NVL(p_jsn_new.fk_jsn_location,0) 
		OR NVL(p_jsn_old.fk_jsn_atb_typ_name,' ') <> NVL(p_jsn_new.fk_jsn_atb_typ_name,' ') 
		OR NVL(p_jsn_old.fk_jsn_atb_name,' ') <> NVL(p_jsn_new.fk_jsn_atb_name,' ') 
		OR NVL(p_jsn_old.fk_jsn_typ_name,' ') <> NVL(p_jsn_new.fk_jsn_typ_name,' ')  THEN
			get_denorm_jsn_jsn (p_jsn_new);
		END IF;
		UPDATE t_json_path SET 
			cube_sequence = p_jsn_new.cube_sequence,
			cube_level = p_jsn_new.cube_level,
			fk_jsn_name = p_jsn_new.fk_jsn_name,
			fk_jsn_location = p_jsn_new.fk_jsn_location,
			fk_jsn_atb_typ_name = p_jsn_new.fk_jsn_atb_typ_name,
			fk_jsn_atb_name = p_jsn_new.fk_jsn_atb_name,
			fk_jsn_typ_name = p_jsn_new.fk_jsn_typ_name
		WHERE rowid = p_cube_rowid;
		IF NVL(p_jsn_old.cube_level,0) <> NVL(p_jsn_new.cube_level,0) THEN
			OPEN c_jsn;
			LOOP
				FETCH c_jsn INTO
					l_jsn_rowid,
					r_jsn_old.cube_id,
					r_jsn_old.cube_sequence,
					r_jsn_old.cube_level,
					r_jsn_old.fk_bot_name,
					r_jsn_old.fk_typ_name,
					r_jsn_old.fk_jsn_name,
					r_jsn_old.fk_jsn_location,
					r_jsn_old.fk_jsn_atb_typ_name,
					r_jsn_old.fk_jsn_atb_name,
					r_jsn_old.fk_jsn_typ_name,
					r_jsn_old.cube_tsg_obj_arr,
					r_jsn_old.cube_tsg_type,
					r_jsn_old.name,
					r_jsn_old.location,
					r_jsn_old.xf_atb_typ_name,
					r_jsn_old.xk_atb_name,
					r_jsn_old.xk_typ_name;
				EXIT WHEN c_jsn%NOTFOUND;
				r_jsn_new := r_jsn_old;
				denorm_jsn_jsn (r_jsn_new, p_jsn_new);
				update_jsn (l_jsn_rowid, r_jsn_old, r_jsn_new);
			END LOOP;
			CLOSE c_jsn;
		END IF;
	END;

	PROCEDURE delete_jsn (p_cube_rowid UROWID, p_jsn IN OUT NOCOPY v_json_path%ROWTYPE) IS
	BEGIN
		DELETE t_json_path 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE denorm_jsn_jsn (p_jsn IN OUT NOCOPY v_json_path%ROWTYPE, p_jsn_in IN v_json_path%ROWTYPE) IS
	BEGIN
		p_jsn.cube_level := NVL (p_jsn_in.cube_level, 0) + 1;
	END;

	PROCEDURE get_denorm_jsn_jsn (p_jsn IN OUT NOCOPY v_json_path%ROWTYPE) IS

		CURSOR c_jsn IS 
			SELECT * FROM v_json_path
			WHERE fk_typ_name = p_jsn.fk_typ_name
			  AND name = p_jsn.fk_jsn_name
			  AND location = p_jsn.fk_jsn_location
			  AND xf_atb_typ_name = p_jsn.fk_jsn_atb_typ_name
			  AND xk_atb_name = p_jsn.fk_jsn_atb_name
			  AND xk_typ_name = p_jsn.fk_jsn_typ_name;
		
		r_jsn v_json_path%ROWTYPE;
	BEGIN
		IF p_jsn.fk_jsn_name IS NOT NULL AND p_jsn.fk_jsn_location IS NOT NULL AND p_jsn.fk_jsn_atb_typ_name IS NOT NULL AND p_jsn.fk_jsn_atb_name IS NOT NULL AND p_jsn.fk_jsn_typ_name IS NOT NULL THEN
			OPEN c_jsn;
			FETCH c_jsn INTO r_jsn;
			IF c_jsn%NOTFOUND THEN
				r_jsn := NULL;
			END IF;
			CLOSE c_jsn;
		ELSE
			r_jsn := NULL;
		END IF;
		denorm_jsn_jsn (p_jsn, r_jsn);
	END;

	PROCEDURE insert_dct (p_dct IN OUT NOCOPY v_description_type%ROWTYPE) IS
	BEGIN
		p_dct.cube_id := 'DCT-' || TO_CHAR(sq_dct.NEXTVAL,'FM000000000000');
		p_dct.fk_bot_name := NVL(p_dct.fk_bot_name,' ');
		p_dct.fk_typ_name := NVL(p_dct.fk_typ_name,' ');
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
		IF :NEW.name = ' ' THEN
			r_bot_new.name := ' ';
		ELSE
			r_bot_new.name := REPLACE(:NEW.name,' ','_');
		END IF;
		IF :NEW.cube_tsg_type = ' ' THEN
			r_bot_new.cube_tsg_type := ' ';
		ELSE
			r_bot_new.cube_tsg_type := REPLACE(:NEW.cube_tsg_type,' ','_');
		END IF;
		IF :NEW.directory = ' ' THEN
			r_bot_new.directory := ' ';
		ELSE
			r_bot_new.directory := REPLACE(:NEW.directory,' ','_');
		END IF;
		IF :NEW.api_url = ' ' THEN
			r_bot_new.api_url := ' ';
		ELSE
			r_bot_new.api_url := REPLACE(:NEW.api_url,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_bot_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_business_object_type
		WHERE name = :OLD.name;
		r_bot_old.cube_sequence := :OLD.cube_sequence;
		r_bot_old.name := :OLD.name;
		r_bot_old.cube_tsg_type := :OLD.cube_tsg_type;
		r_bot_old.directory := :OLD.directory;
		r_bot_old.api_url := :OLD.api_url;
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_typ_new.fk_bot_name := ' ';
		ELSE
			r_typ_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_typ_new.fk_typ_name := ' ';
		ELSE
			r_typ_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		IF :NEW.name = ' ' THEN
			r_typ_new.name := ' ';
		ELSE
			r_typ_new.name := REPLACE(:NEW.name,' ','_');
		END IF;
		IF :NEW.code = ' ' THEN
			r_typ_new.code := ' ';
		ELSE
			r_typ_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		r_typ_new.flag_partial_key := :NEW.flag_partial_key;
		r_typ_new.flag_recursive := :NEW.flag_recursive;
		r_typ_new.recursive_cardinality := :NEW.recursive_cardinality;
		r_typ_new.cardinality := :NEW.cardinality;
		r_typ_new.sort_order := :NEW.sort_order;
		IF :NEW.icon = ' ' THEN
			r_typ_new.icon := ' ';
		ELSE
			r_typ_new.icon := REPLACE(:NEW.icon,' ','_');
		END IF;
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_tsg_new.fk_bot_name := ' ';
		ELSE
			r_tsg_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_tsg_new.fk_typ_name := ' ';
		ELSE
			r_tsg_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		IF :NEW.fk_tsg_code = ' ' THEN
			r_tsg_new.fk_tsg_code := ' ';
		ELSE
			r_tsg_new.fk_tsg_code := REPLACE(:NEW.fk_tsg_code,' ','_');
		END IF;
		IF :NEW.code = ' ' THEN
			r_tsg_new.code := ' ';
		ELSE
			r_tsg_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		IF :NEW.name = ' ' THEN
			r_tsg_new.name := ' ';
		ELSE
			r_tsg_new.name := REPLACE(:NEW.name,' ','_');
		END IF;
		r_tsg_new.primary_key := :NEW.primary_key;
		IF :NEW.xf_atb_typ_name = ' ' THEN
			r_tsg_new.xf_atb_typ_name := ' ';
		ELSE
			r_tsg_new.xf_atb_typ_name := REPLACE(:NEW.xf_atb_typ_name,' ','_');
		END IF;
		IF :NEW.xk_atb_name = ' ' THEN
			r_tsg_new.xk_atb_name := ' ';
		ELSE
			r_tsg_new.xk_atb_name := REPLACE(:NEW.xk_atb_name,' ','_');
		END IF;
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
		r_tsg_old.xf_atb_typ_name := :OLD.xf_atb_typ_name;
		r_tsg_old.xk_atb_name := :OLD.xk_atb_name;
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_tsp_new.fk_bot_name := ' ';
		ELSE
			r_tsp_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_tsp_new.fk_typ_name := ' ';
		ELSE
			r_tsp_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		IF :NEW.fk_tsg_code = ' ' THEN
			r_tsp_new.fk_tsg_code := ' ';
		ELSE
			r_tsp_new.fk_tsg_code := REPLACE(:NEW.fk_tsg_code,' ','_');
		END IF;
		IF :NEW.code = ' ' THEN
			r_tsp_new.code := ' ';
		ELSE
			r_tsp_new.code := REPLACE(:NEW.code,' ','_');
		END IF;
		IF :NEW.name = ' ' THEN
			r_tsp_new.name := ' ';
		ELSE
			r_tsp_new.name := REPLACE(:NEW.name,' ','_');
		END IF;
		IF :NEW.xf_tsp_typ_name = ' ' THEN
			r_tsp_new.xf_tsp_typ_name := ' ';
		ELSE
			r_tsp_new.xf_tsp_typ_name := REPLACE(:NEW.xf_tsp_typ_name,' ','_');
		END IF;
		IF :NEW.xf_tsp_tsg_code = ' ' THEN
			r_tsp_new.xf_tsp_tsg_code := ' ';
		ELSE
			r_tsp_new.xf_tsp_tsg_code := REPLACE(:NEW.xf_tsp_tsg_code,' ','_');
		END IF;
		IF :NEW.xk_tsp_code = ' ' THEN
			r_tsp_new.xk_tsp_code := ' ';
		ELSE
			r_tsp_new.xk_tsp_code := REPLACE(:NEW.xk_tsp_code,' ','_');
		END IF;
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_atb_new.fk_bot_name := ' ';
		ELSE
			r_atb_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_atb_new.fk_typ_name := ' ';
		ELSE
			r_atb_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		IF :NEW.name = ' ' THEN
			r_atb_new.name := ' ';
		ELSE
			r_atb_new.name := REPLACE(:NEW.name,' ','_');
		END IF;
		r_atb_new.primary_key := :NEW.primary_key;
		IF :NEW.code_display_key = ' ' THEN
			r_atb_new.code_display_key := ' ';
		ELSE
			r_atb_new.code_display_key := REPLACE(:NEW.code_display_key,' ','_');
		END IF;
		r_atb_new.code_foreign_key := :NEW.code_foreign_key;
		r_atb_new.flag_hidden := :NEW.flag_hidden;
		r_atb_new.default_value := :NEW.default_value;
		r_atb_new.unchangeable := :NEW.unchangeable;
		IF :NEW.xk_itp_name = ' ' THEN
			r_atb_new.xk_itp_name := ' ';
		ELSE
			r_atb_new.xk_itp_name := REPLACE(:NEW.xk_itp_name,' ','_');
		END IF;
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_der_new.fk_bot_name := ' ';
		ELSE
			r_der_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_der_new.fk_typ_name := ' ';
		ELSE
			r_der_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		IF :NEW.fk_atb_name = ' ' THEN
			r_der_new.fk_atb_name := ' ';
		ELSE
			r_der_new.fk_atb_name := REPLACE(:NEW.fk_atb_name,' ','_');
		END IF;
		IF :NEW.cube_tsg_type = ' ' THEN
			r_der_new.cube_tsg_type := ' ';
		ELSE
			r_der_new.cube_tsg_type := REPLACE(:NEW.cube_tsg_type,' ','_');
		END IF;
		IF :NEW.aggregate_function = ' ' THEN
			r_der_new.aggregate_function := ' ';
		ELSE
			r_der_new.aggregate_function := REPLACE(:NEW.aggregate_function,' ','_');
		END IF;
		IF :NEW.xk_typ_name = ' ' THEN
			r_der_new.xk_typ_name := ' ';
		ELSE
			r_der_new.xk_typ_name := REPLACE(:NEW.xk_typ_name,' ','_');
		END IF;
		IF :NEW.xk_typ_name_1 = ' ' THEN
			r_der_new.xk_typ_name_1 := ' ';
		ELSE
			r_der_new.xk_typ_name_1 := REPLACE(:NEW.xk_typ_name_1,' ','_');
		END IF;
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_dca_new.fk_bot_name := ' ';
		ELSE
			r_dca_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_dca_new.fk_typ_name := ' ';
		ELSE
			r_dca_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		IF :NEW.fk_atb_name = ' ' THEN
			r_dca_new.fk_atb_name := ' ';
		ELSE
			r_dca_new.fk_atb_name := REPLACE(:NEW.fk_atb_name,' ','_');
		END IF;
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_rta_new.fk_bot_name := ' ';
		ELSE
			r_rta_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_rta_new.fk_typ_name := ' ';
		ELSE
			r_rta_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		IF :NEW.fk_atb_name = ' ' THEN
			r_rta_new.fk_atb_name := ' ';
		ELSE
			r_rta_new.fk_atb_name := REPLACE(:NEW.fk_atb_name,' ','_');
		END IF;
		IF :NEW.include_or_exclude = ' ' THEN
			r_rta_new.include_or_exclude := ' ';
		ELSE
			r_rta_new.include_or_exclude := REPLACE(:NEW.include_or_exclude,' ','_');
		END IF;
		IF :NEW.xf_tsp_typ_name = ' ' THEN
			r_rta_new.xf_tsp_typ_name := ' ';
		ELSE
			r_rta_new.xf_tsp_typ_name := REPLACE(:NEW.xf_tsp_typ_name,' ','_');
		END IF;
		IF :NEW.xf_tsp_tsg_code = ' ' THEN
			r_rta_new.xf_tsp_tsg_code := ' ';
		ELSE
			r_rta_new.xf_tsp_tsg_code := REPLACE(:NEW.xf_tsp_tsg_code,' ','_');
		END IF;
		IF :NEW.xk_tsp_code = ' ' THEN
			r_rta_new.xk_tsp_code := ' ';
		ELSE
			r_rta_new.xk_tsp_code := REPLACE(:NEW.xk_tsp_code,' ','_');
		END IF;
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_ref_new.fk_bot_name := ' ';
		ELSE
			r_ref_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_ref_new.fk_typ_name := ' ';
		ELSE
			r_ref_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		IF :NEW.name = ' ' THEN
			r_ref_new.name := ' ';
		ELSE
			r_ref_new.name := REPLACE(:NEW.name,' ','_');
		END IF;
		r_ref_new.primary_key := :NEW.primary_key;
		IF :NEW.code_display_key = ' ' THEN
			r_ref_new.code_display_key := ' ';
		ELSE
			r_ref_new.code_display_key := REPLACE(:NEW.code_display_key,' ','_');
		END IF;
		r_ref_new.sequence := :NEW.sequence;
		IF :NEW.scope = ' ' THEN
			r_ref_new.scope := ' ';
		ELSE
			r_ref_new.scope := REPLACE(:NEW.scope,' ','_');
		END IF;
		r_ref_new.unchangeable := :NEW.unchangeable;
		IF :NEW.within_scope_extension = ' ' THEN
			r_ref_new.within_scope_extension := ' ';
		ELSE
			r_ref_new.within_scope_extension := REPLACE(:NEW.within_scope_extension,' ','_');
		END IF;
		IF :NEW.cube_tsg_int_ext = ' ' THEN
			r_ref_new.cube_tsg_int_ext := ' ';
		ELSE
			r_ref_new.cube_tsg_int_ext := REPLACE(:NEW.cube_tsg_int_ext,' ','_');
		END IF;
		IF :NEW.xk_bot_name = ' ' THEN
			r_ref_new.xk_bot_name := ' ';
		ELSE
			r_ref_new.xk_bot_name := REPLACE(:NEW.xk_bot_name,' ','_');
		END IF;
		IF :NEW.xk_typ_name = ' ' THEN
			r_ref_new.xk_typ_name := ' ';
		ELSE
			r_ref_new.xk_typ_name := REPLACE(:NEW.xk_typ_name,' ','_');
		END IF;
		IF :NEW.xk_typ_name_1 = ' ' THEN
			r_ref_new.xk_typ_name_1 := ' ';
		ELSE
			r_ref_new.xk_typ_name_1 := REPLACE(:NEW.xk_typ_name_1,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_ref_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_reference
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND sequence = :OLD.sequence
		  AND xk_bot_name = :OLD.xk_bot_name
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
		r_ref_old.within_scope_extension := :OLD.within_scope_extension;
		r_ref_old.cube_tsg_int_ext := :OLD.cube_tsg_int_ext;
		r_ref_old.xk_bot_name := :OLD.xk_bot_name;
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_dcr_new.fk_bot_name := ' ';
		ELSE
			r_dcr_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_dcr_new.fk_typ_name := ' ';
		ELSE
			r_dcr_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		r_dcr_new.fk_ref_sequence := :NEW.fk_ref_sequence;
		IF :NEW.fk_ref_bot_name = ' ' THEN
			r_dcr_new.fk_ref_bot_name := ' ';
		ELSE
			r_dcr_new.fk_ref_bot_name := REPLACE(:NEW.fk_ref_bot_name,' ','_');
		END IF;
		IF :NEW.fk_ref_typ_name = ' ' THEN
			r_dcr_new.fk_ref_typ_name := ' ';
		ELSE
			r_dcr_new.fk_ref_typ_name := REPLACE(:NEW.fk_ref_typ_name,' ','_');
		END IF;
		r_dcr_new.text := :NEW.text;
	END IF;
	IF UPDATING THEN
		r_dcr_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_description_reference
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND fk_ref_sequence = :OLD.fk_ref_sequence
		  AND fk_ref_bot_name = :OLD.fk_ref_bot_name
		  AND fk_ref_typ_name = :OLD.fk_ref_typ_name;
		r_dcr_old.fk_bot_name := :OLD.fk_bot_name;
		r_dcr_old.fk_typ_name := :OLD.fk_typ_name;
		r_dcr_old.fk_ref_sequence := :OLD.fk_ref_sequence;
		r_dcr_old.fk_ref_bot_name := :OLD.fk_ref_bot_name;
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_rtr_new.fk_bot_name := ' ';
		ELSE
			r_rtr_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_rtr_new.fk_typ_name := ' ';
		ELSE
			r_rtr_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		r_rtr_new.fk_ref_sequence := :NEW.fk_ref_sequence;
		IF :NEW.fk_ref_bot_name = ' ' THEN
			r_rtr_new.fk_ref_bot_name := ' ';
		ELSE
			r_rtr_new.fk_ref_bot_name := REPLACE(:NEW.fk_ref_bot_name,' ','_');
		END IF;
		IF :NEW.fk_ref_typ_name = ' ' THEN
			r_rtr_new.fk_ref_typ_name := ' ';
		ELSE
			r_rtr_new.fk_ref_typ_name := REPLACE(:NEW.fk_ref_typ_name,' ','_');
		END IF;
		IF :NEW.include_or_exclude = ' ' THEN
			r_rtr_new.include_or_exclude := ' ';
		ELSE
			r_rtr_new.include_or_exclude := REPLACE(:NEW.include_or_exclude,' ','_');
		END IF;
		IF :NEW.xf_tsp_typ_name = ' ' THEN
			r_rtr_new.xf_tsp_typ_name := ' ';
		ELSE
			r_rtr_new.xf_tsp_typ_name := REPLACE(:NEW.xf_tsp_typ_name,' ','_');
		END IF;
		IF :NEW.xf_tsp_tsg_code = ' ' THEN
			r_rtr_new.xf_tsp_tsg_code := ' ';
		ELSE
			r_rtr_new.xf_tsp_tsg_code := REPLACE(:NEW.xf_tsp_tsg_code,' ','_');
		END IF;
		IF :NEW.xk_tsp_code = ' ' THEN
			r_rtr_new.xk_tsp_code := ' ';
		ELSE
			r_rtr_new.xk_tsp_code := REPLACE(:NEW.xk_tsp_code,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_rtr_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_restriction_type_spec_ref
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND fk_ref_sequence = :OLD.fk_ref_sequence
		  AND fk_ref_bot_name = :OLD.fk_ref_bot_name
		  AND fk_ref_typ_name = :OLD.fk_ref_typ_name
		  AND xf_tsp_typ_name = :OLD.xf_tsp_typ_name
		  AND xf_tsp_tsg_code = :OLD.xf_tsp_tsg_code
		  AND xk_tsp_code = :OLD.xk_tsp_code;
		r_rtr_old.fk_bot_name := :OLD.fk_bot_name;
		r_rtr_old.fk_typ_name := :OLD.fk_typ_name;
		r_rtr_old.fk_ref_sequence := :OLD.fk_ref_sequence;
		r_rtr_old.fk_ref_bot_name := :OLD.fk_ref_bot_name;
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

CREATE OR REPLACE TRIGGER trg_rts
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_restriction_target_type_spec
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_rts_new v_restriction_target_type_spec%ROWTYPE;
	r_rts_old v_restriction_target_type_spec%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		IF :NEW.fk_bot_name = ' ' THEN
			r_rts_new.fk_bot_name := ' ';
		ELSE
			r_rts_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_rts_new.fk_typ_name := ' ';
		ELSE
			r_rts_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		r_rts_new.fk_ref_sequence := :NEW.fk_ref_sequence;
		IF :NEW.fk_ref_bot_name = ' ' THEN
			r_rts_new.fk_ref_bot_name := ' ';
		ELSE
			r_rts_new.fk_ref_bot_name := REPLACE(:NEW.fk_ref_bot_name,' ','_');
		END IF;
		IF :NEW.fk_ref_typ_name = ' ' THEN
			r_rts_new.fk_ref_typ_name := ' ';
		ELSE
			r_rts_new.fk_ref_typ_name := REPLACE(:NEW.fk_ref_typ_name,' ','_');
		END IF;
		IF :NEW.include_or_exclude = ' ' THEN
			r_rts_new.include_or_exclude := ' ';
		ELSE
			r_rts_new.include_or_exclude := REPLACE(:NEW.include_or_exclude,' ','_');
		END IF;
		IF :NEW.xf_tsp_typ_name = ' ' THEN
			r_rts_new.xf_tsp_typ_name := ' ';
		ELSE
			r_rts_new.xf_tsp_typ_name := REPLACE(:NEW.xf_tsp_typ_name,' ','_');
		END IF;
		IF :NEW.xf_tsp_tsg_code = ' ' THEN
			r_rts_new.xf_tsp_tsg_code := ' ';
		ELSE
			r_rts_new.xf_tsp_tsg_code := REPLACE(:NEW.xf_tsp_tsg_code,' ','_');
		END IF;
		IF :NEW.xk_tsp_code = ' ' THEN
			r_rts_new.xk_tsp_code := ' ';
		ELSE
			r_rts_new.xk_tsp_code := REPLACE(:NEW.xk_tsp_code,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_rts_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_restriction_target_type_spec
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND fk_ref_sequence = :OLD.fk_ref_sequence
		  AND fk_ref_bot_name = :OLD.fk_ref_bot_name
		  AND fk_ref_typ_name = :OLD.fk_ref_typ_name
		  AND xf_tsp_typ_name = :OLD.xf_tsp_typ_name
		  AND xf_tsp_tsg_code = :OLD.xf_tsp_tsg_code
		  AND xk_tsp_code = :OLD.xk_tsp_code;
		r_rts_old.fk_bot_name := :OLD.fk_bot_name;
		r_rts_old.fk_typ_name := :OLD.fk_typ_name;
		r_rts_old.fk_ref_sequence := :OLD.fk_ref_sequence;
		r_rts_old.fk_ref_bot_name := :OLD.fk_ref_bot_name;
		r_rts_old.fk_ref_typ_name := :OLD.fk_ref_typ_name;
		r_rts_old.include_or_exclude := :OLD.include_or_exclude;
		r_rts_old.xf_tsp_typ_name := :OLD.xf_tsp_typ_name;
		r_rts_old.xf_tsp_tsg_code := :OLD.xf_tsp_tsg_code;
		r_rts_old.xk_tsp_code := :OLD.xk_tsp_code;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_rts (r_rts_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_rts (l_cube_rowid, r_rts_old, r_rts_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_rts (l_cube_rowid, r_rts_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_rtt
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_restriction_type_spec_typ
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_rtt_new v_restriction_type_spec_typ%ROWTYPE;
	r_rtt_old v_restriction_type_spec_typ%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		IF :NEW.fk_bot_name = ' ' THEN
			r_rtt_new.fk_bot_name := ' ';
		ELSE
			r_rtt_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_rtt_new.fk_typ_name := ' ';
		ELSE
			r_rtt_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		IF :NEW.include_or_exclude = ' ' THEN
			r_rtt_new.include_or_exclude := ' ';
		ELSE
			r_rtt_new.include_or_exclude := REPLACE(:NEW.include_or_exclude,' ','_');
		END IF;
		IF :NEW.xf_tsp_typ_name = ' ' THEN
			r_rtt_new.xf_tsp_typ_name := ' ';
		ELSE
			r_rtt_new.xf_tsp_typ_name := REPLACE(:NEW.xf_tsp_typ_name,' ','_');
		END IF;
		IF :NEW.xf_tsp_tsg_code = ' ' THEN
			r_rtt_new.xf_tsp_tsg_code := ' ';
		ELSE
			r_rtt_new.xf_tsp_tsg_code := REPLACE(:NEW.xf_tsp_tsg_code,' ','_');
		END IF;
		IF :NEW.xk_tsp_code = ' ' THEN
			r_rtt_new.xk_tsp_code := ' ';
		ELSE
			r_rtt_new.xk_tsp_code := REPLACE(:NEW.xk_tsp_code,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_rtt_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_restriction_type_spec_typ
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND xf_tsp_typ_name = :OLD.xf_tsp_typ_name
		  AND xf_tsp_tsg_code = :OLD.xf_tsp_tsg_code
		  AND xk_tsp_code = :OLD.xk_tsp_code;
		r_rtt_old.fk_bot_name := :OLD.fk_bot_name;
		r_rtt_old.fk_typ_name := :OLD.fk_typ_name;
		r_rtt_old.include_or_exclude := :OLD.include_or_exclude;
		r_rtt_old.xf_tsp_typ_name := :OLD.xf_tsp_typ_name;
		r_rtt_old.xf_tsp_tsg_code := :OLD.xf_tsp_tsg_code;
		r_rtt_old.xk_tsp_code := :OLD.xk_tsp_code;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_rtt (r_rtt_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_rtt (l_cube_rowid, r_rtt_old, r_rtt_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_rtt (l_cube_rowid, r_rtt_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_jsn
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_json_path
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_jsn_new v_json_path%ROWTYPE;
	r_jsn_old v_json_path%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_jsn_new.cube_sequence := :NEW.cube_sequence;
		IF :NEW.fk_bot_name = ' ' THEN
			r_jsn_new.fk_bot_name := ' ';
		ELSE
			r_jsn_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_jsn_new.fk_typ_name := ' ';
		ELSE
			r_jsn_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
		r_jsn_new.fk_jsn_name := :NEW.fk_jsn_name;
		r_jsn_new.fk_jsn_location := :NEW.fk_jsn_location;
		IF :NEW.fk_jsn_atb_typ_name = ' ' THEN
			r_jsn_new.fk_jsn_atb_typ_name := ' ';
		ELSE
			r_jsn_new.fk_jsn_atb_typ_name := REPLACE(:NEW.fk_jsn_atb_typ_name,' ','_');
		END IF;
		IF :NEW.fk_jsn_atb_name = ' ' THEN
			r_jsn_new.fk_jsn_atb_name := ' ';
		ELSE
			r_jsn_new.fk_jsn_atb_name := REPLACE(:NEW.fk_jsn_atb_name,' ','_');
		END IF;
		IF :NEW.fk_jsn_typ_name = ' ' THEN
			r_jsn_new.fk_jsn_typ_name := ' ';
		ELSE
			r_jsn_new.fk_jsn_typ_name := REPLACE(:NEW.fk_jsn_typ_name,' ','_');
		END IF;
		IF :NEW.cube_tsg_obj_arr = ' ' THEN
			r_jsn_new.cube_tsg_obj_arr := ' ';
		ELSE
			r_jsn_new.cube_tsg_obj_arr := REPLACE(:NEW.cube_tsg_obj_arr,' ','_');
		END IF;
		IF :NEW.cube_tsg_type = ' ' THEN
			r_jsn_new.cube_tsg_type := ' ';
		ELSE
			r_jsn_new.cube_tsg_type := REPLACE(:NEW.cube_tsg_type,' ','_');
		END IF;
		r_jsn_new.name := :NEW.name;
		r_jsn_new.location := :NEW.location;
		IF :NEW.xf_atb_typ_name = ' ' THEN
			r_jsn_new.xf_atb_typ_name := ' ';
		ELSE
			r_jsn_new.xf_atb_typ_name := REPLACE(:NEW.xf_atb_typ_name,' ','_');
		END IF;
		IF :NEW.xk_atb_name = ' ' THEN
			r_jsn_new.xk_atb_name := ' ';
		ELSE
			r_jsn_new.xk_atb_name := REPLACE(:NEW.xk_atb_name,' ','_');
		END IF;
		IF :NEW.xk_typ_name = ' ' THEN
			r_jsn_new.xk_typ_name := ' ';
		ELSE
			r_jsn_new.xk_typ_name := REPLACE(:NEW.xk_typ_name,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_jsn_new.cube_id := :OLD.cube_id;
		r_jsn_new.cube_level := :OLD.cube_level;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_json_path
		WHERE fk_typ_name = :OLD.fk_typ_name
		  AND name = :OLD.name
		  AND location = :OLD.location
		  AND xf_atb_typ_name = :OLD.xf_atb_typ_name
		  AND xk_atb_name = :OLD.xk_atb_name
		  AND xk_typ_name = :OLD.xk_typ_name;
		r_jsn_old.cube_sequence := :OLD.cube_sequence;
		r_jsn_old.fk_bot_name := :OLD.fk_bot_name;
		r_jsn_old.fk_typ_name := :OLD.fk_typ_name;
		r_jsn_old.fk_jsn_name := :OLD.fk_jsn_name;
		r_jsn_old.fk_jsn_location := :OLD.fk_jsn_location;
		r_jsn_old.fk_jsn_atb_typ_name := :OLD.fk_jsn_atb_typ_name;
		r_jsn_old.fk_jsn_atb_name := :OLD.fk_jsn_atb_name;
		r_jsn_old.fk_jsn_typ_name := :OLD.fk_jsn_typ_name;
		r_jsn_old.cube_tsg_obj_arr := :OLD.cube_tsg_obj_arr;
		r_jsn_old.cube_tsg_type := :OLD.cube_tsg_type;
		r_jsn_old.name := :OLD.name;
		r_jsn_old.location := :OLD.location;
		r_jsn_old.xf_atb_typ_name := :OLD.xf_atb_typ_name;
		r_jsn_old.xk_atb_name := :OLD.xk_atb_name;
		r_jsn_old.xk_typ_name := :OLD.xk_typ_name;
	END IF;

	IF INSERTING THEN 
		pkg_bot_trg.insert_jsn (r_jsn_new);
	ELSIF UPDATING THEN
		pkg_bot_trg.update_jsn (l_cube_rowid, r_jsn_old, r_jsn_new);
	ELSIF DELETING THEN
		pkg_bot_trg.delete_jsn (l_cube_rowid, r_jsn_old);
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
		IF :NEW.fk_bot_name = ' ' THEN
			r_dct_new.fk_bot_name := ' ';
		ELSE
			r_dct_new.fk_bot_name := REPLACE(:NEW.fk_bot_name,' ','_');
		END IF;
		IF :NEW.fk_typ_name = ' ' THEN
			r_dct_new.fk_typ_name := ' ';
		ELSE
			r_dct_new.fk_typ_name := REPLACE(:NEW.fk_typ_name,' ','_');
		END IF;
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
		cube_tsg_type,
		database,
		schema,
		password,
		table_prefix
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
	FUNCTION cube_trg_cubetool RETURN VARCHAR2;
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

	FUNCTION cube_trg_cubetool RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubetool';
	END;

	PROCEDURE insert_sys (p_sys IN OUT NOCOPY v_system%ROWTYPE) IS
	BEGIN
		p_sys.cube_id := 'SYS-' || TO_CHAR(sq_sys.NEXTVAL,'FM000000000000');
		p_sys.name := NVL(p_sys.name,' ');
		INSERT INTO t_system (
			cube_id,
			name,
			cube_tsg_type,
			database,
			schema,
			password,
			table_prefix)
		VALUES (
			p_sys.cube_id,
			p_sys.name,
			p_sys.cube_tsg_type,
			p_sys.database,
			p_sys.schema,
			p_sys.password,
			p_sys.table_prefix);
	END;

	PROCEDURE update_sys (p_cube_rowid UROWID, p_sys_old IN OUT NOCOPY v_system%ROWTYPE, p_sys_new IN OUT NOCOPY v_system%ROWTYPE) IS
	BEGIN
		UPDATE t_system SET 
			database = p_sys_new.database,
			schema = p_sys_new.schema,
			password = p_sys_new.password,
			table_prefix = p_sys_new.table_prefix
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_sys (p_cube_rowid UROWID, p_sys IN OUT NOCOPY v_system%ROWTYPE) IS
	BEGIN
		DELETE t_system 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_sbt (p_sbt IN OUT NOCOPY v_system_bo_type%ROWTYPE) IS
	BEGIN
		p_sbt.cube_id := 'SBT-' || TO_CHAR(sq_sbt.NEXTVAL,'FM000000000000');
		p_sbt.fk_sys_name := NVL(p_sbt.fk_sys_name,' ');
		p_sbt.xk_bot_name := NVL(p_sbt.xk_bot_name,' ');
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
		IF :NEW.name = ' ' THEN
			r_sys_new.name := ' ';
		ELSE
			r_sys_new.name := REPLACE(:NEW.name,' ','_');
		END IF;
		IF :NEW.cube_tsg_type = ' ' THEN
			r_sys_new.cube_tsg_type := ' ';
		ELSE
			r_sys_new.cube_tsg_type := REPLACE(:NEW.cube_tsg_type,' ','_');
		END IF;
		IF :NEW.database = ' ' THEN
			r_sys_new.database := ' ';
		ELSE
			r_sys_new.database := REPLACE(:NEW.database,' ','_');
		END IF;
		IF :NEW.schema = ' ' THEN
			r_sys_new.schema := ' ';
		ELSE
			r_sys_new.schema := REPLACE(:NEW.schema,' ','_');
		END IF;
		IF :NEW.password = ' ' THEN
			r_sys_new.password := ' ';
		ELSE
			r_sys_new.password := REPLACE(:NEW.password,' ','_');
		END IF;
		IF :NEW.table_prefix = ' ' THEN
			r_sys_new.table_prefix := ' ';
		ELSE
			r_sys_new.table_prefix := REPLACE(:NEW.table_prefix,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_sys_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_system
		WHERE name = :OLD.name;
		r_sys_old.name := :OLD.name;
		r_sys_old.cube_tsg_type := :OLD.cube_tsg_type;
		r_sys_old.database := :OLD.database;
		r_sys_old.schema := :OLD.schema;
		r_sys_old.password := :OLD.password;
		r_sys_old.table_prefix := :OLD.table_prefix;
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
		IF :NEW.fk_sys_name = ' ' THEN
			r_sbt_new.fk_sys_name := ' ';
		ELSE
			r_sbt_new.fk_sys_name := REPLACE(:NEW.fk_sys_name,' ','_');
		END IF;
		IF :NEW.xk_bot_name = ' ' THEN
			r_sbt_new.xk_bot_name := ' ';
		ELSE
			r_sbt_new.xk_bot_name := REPLACE(:NEW.xk_bot_name,' ','_');
		END IF;
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

CREATE OR REPLACE VIEW v_function AS 
	SELECT
		cube_id,
		name
	FROM t_function
/
CREATE OR REPLACE VIEW v_argument AS 
	SELECT
		cube_id,
		cube_sequence,
		fk_fun_name,
		name
	FROM t_argument
/

CREATE OR REPLACE PACKAGE pkg_fun_trg IS
	FUNCTION cube_trg_cubetool RETURN VARCHAR2;
	PROCEDURE insert_fun (p_fun IN OUT NOCOPY v_function%ROWTYPE);
	PROCEDURE update_fun (p_cube_rowid IN UROWID, p_fun_old IN OUT NOCOPY v_function%ROWTYPE, p_fun_new IN OUT NOCOPY v_function%ROWTYPE);
	PROCEDURE delete_fun (p_cube_rowid IN UROWID, p_fun IN OUT NOCOPY v_function%ROWTYPE);
	PROCEDURE insert_arg (p_arg IN OUT NOCOPY v_argument%ROWTYPE);
	PROCEDURE update_arg (p_cube_rowid IN UROWID, p_arg_old IN OUT NOCOPY v_argument%ROWTYPE, p_arg_new IN OUT NOCOPY v_argument%ROWTYPE);
	PROCEDURE delete_arg (p_cube_rowid IN UROWID, p_arg IN OUT NOCOPY v_argument%ROWTYPE);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_fun_trg IS

	FUNCTION cube_trg_cubetool RETURN VARCHAR2 IS
	BEGIN
		RETURN 'cube_trg_cubetool';
	END;

	PROCEDURE insert_fun (p_fun IN OUT NOCOPY v_function%ROWTYPE) IS
	BEGIN
		p_fun.cube_id := 'FUN-' || TO_CHAR(sq_fun.NEXTVAL,'FM000000000000');
		p_fun.name := NVL(p_fun.name,' ');
		INSERT INTO t_function (
			cube_id,
			name)
		VALUES (
			p_fun.cube_id,
			p_fun.name);
	END;

	PROCEDURE update_fun (p_cube_rowid UROWID, p_fun_old IN OUT NOCOPY v_function%ROWTYPE, p_fun_new IN OUT NOCOPY v_function%ROWTYPE) IS
	BEGIN
		NULL;
	END;

	PROCEDURE delete_fun (p_cube_rowid UROWID, p_fun IN OUT NOCOPY v_function%ROWTYPE) IS
	BEGIN
		DELETE t_function 
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE insert_arg (p_arg IN OUT NOCOPY v_argument%ROWTYPE) IS
	BEGIN
		p_arg.cube_id := 'ARG-' || TO_CHAR(sq_arg.NEXTVAL,'FM000000000000');
		p_arg.fk_fun_name := NVL(p_arg.fk_fun_name,' ');
		p_arg.name := NVL(p_arg.name,' ');
		INSERT INTO t_argument (
			cube_id,
			cube_sequence,
			fk_fun_name,
			name)
		VALUES (
			p_arg.cube_id,
			p_arg.cube_sequence,
			p_arg.fk_fun_name,
			p_arg.name);
	END;

	PROCEDURE update_arg (p_cube_rowid UROWID, p_arg_old IN OUT NOCOPY v_argument%ROWTYPE, p_arg_new IN OUT NOCOPY v_argument%ROWTYPE) IS
	BEGIN
		UPDATE t_argument SET 
			cube_sequence = p_arg_new.cube_sequence
		WHERE rowid = p_cube_rowid;
	END;

	PROCEDURE delete_arg (p_cube_rowid UROWID, p_arg IN OUT NOCOPY v_argument%ROWTYPE) IS
	BEGIN
		DELETE t_argument 
		WHERE rowid = p_cube_rowid;
	END;
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER trg_fun
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_function
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_fun_new v_function%ROWTYPE;
	r_fun_old v_function%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		IF :NEW.name = ' ' THEN
			r_fun_new.name := ' ';
		ELSE
			r_fun_new.name := REPLACE(:NEW.name,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_fun_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_function
		WHERE name = :OLD.name;
		r_fun_old.name := :OLD.name;
	END IF;

	IF INSERTING THEN 
		pkg_fun_trg.insert_fun (r_fun_new);
	ELSIF UPDATING THEN
		pkg_fun_trg.update_fun (l_cube_rowid, r_fun_old, r_fun_new);
	ELSIF DELETING THEN
		pkg_fun_trg.delete_fun (l_cube_rowid, r_fun_old);
	END IF;
END;
/
SHOW ERRORS

CREATE OR REPLACE TRIGGER trg_arg
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_argument
FOR EACH ROW
DECLARE
	l_cube_rowid UROWID;
	r_arg_new v_argument%ROWTYPE;
	r_arg_old v_argument%ROWTYPE;
BEGIN
	IF INSERTING OR UPDATING THEN
		r_arg_new.cube_sequence := :NEW.cube_sequence;
		IF :NEW.fk_fun_name = ' ' THEN
			r_arg_new.fk_fun_name := ' ';
		ELSE
			r_arg_new.fk_fun_name := REPLACE(:NEW.fk_fun_name,' ','_');
		END IF;
		IF :NEW.name = ' ' THEN
			r_arg_new.name := ' ';
		ELSE
			r_arg_new.name := REPLACE(:NEW.name,' ','_');
		END IF;
	END IF;
	IF UPDATING THEN
		r_arg_new.cube_id := :OLD.cube_id;
	END IF;
	IF UPDATING OR DELETING THEN
		SELECT rowid INTO l_cube_rowid FROM t_argument
		WHERE fk_fun_name = :OLD.fk_fun_name
		  AND name = :OLD.name;
		r_arg_old.cube_sequence := :OLD.cube_sequence;
		r_arg_old.fk_fun_name := :OLD.fk_fun_name;
		r_arg_old.name := :OLD.name;
	END IF;

	IF INSERTING THEN 
		pkg_fun_trg.insert_arg (r_arg_new);
	ELSIF UPDATING THEN
		pkg_fun_trg.update_arg (l_cube_rowid, r_arg_old, r_arg_new);
	ELSIF DELETING THEN
		pkg_fun_trg.delete_arg (l_cube_rowid, r_arg_old);
	END IF;
END;
/
SHOW ERRORS

EXIT;