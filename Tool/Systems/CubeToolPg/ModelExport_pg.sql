-- CUBETOOL Export tool
--
DO $BODY$
	DECLARE
		rec_nspname RECORD;
	BEGIN
		FOR rec_nspname IN 
			SELECT nspname 
			FROM pg_catalog.pg_namespace, pg_catalog.pg_user
			WHERE nspowner = usesysid
			  AND usename = 'JohanM'
			  AND nspname = 'cube_exp'
		LOOP
			EXECUTE 'DROP SCHEMA ' || rec_nspname.nspname || ' CASCADE';
		END LOOP;
	END;
$BODY$;

CREATE SCHEMA cube_exp;

CREATE TABLE cube_exp.line ();
ALTER TABLE cube_exp.line ADD COLUMN IF NOT EXISTS num NUMERIC(8);
ALTER TABLE cube_exp.line ADD COLUMN IF NOT EXISTS str VARCHAR;

CREATE FUNCTION cube_exp.ftabs (p_level IN NUMERIC) RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
		l_tabs VARCHAR(80) := '';
BEGIN
	FOR i IN 1..p_level
	LOOP
		l_tabs := l_tabs || '	';
	END LOOP;
	RETURN(l_tabs);		
END; 
$$;
		
CREATE FUNCTION cube_exp.fenperc (p_text IN VARCHAR) RETURNS VARCHAR LANGUAGE plpgsql AS $$
BEGIN
	RETURN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(p_text,'%','%25'),';','%3B'),'"','%22'),'|','%7C'),CHR(13),'%0D'),CHR(10),'%0A'),CHR(9),'%09'));		
END;
$$;


CREATE PROCEDURE cube_exp.export_val (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_ite IN itp.v_information_type_element) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_val itp.v_permitted_value;
BEGIN
	FOR r_val IN
		SELECT *				
		FROM itp.v_permitted_value
		WHERE fk_itp_name = p_ite.fk_itp_name
		  AND fk_ite_sequence = p_ite.sequence
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'=PERMITTED_VALUE[', r_val.cube_id, ']:', cube_exp.fenperc(r_val.code), '|', cube_exp.fenperc(r_val.prompt), ';'));
		p_level := p_level + 1;
		p_level := p_level - 1;
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_ite (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_itp IN itp.v_information_type) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_ite itp.v_information_type_element;
BEGIN
	FOR r_ite IN
		SELECT *				
		FROM itp.v_information_type_element
		WHERE fk_itp_name = p_itp.name
		ORDER BY fk_itp_name, sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+INFORMATION_TYPE_ELEMENT[', r_ite.cube_id, ']:', r_ite.sequence, '|', cube_exp.fenperc(r_ite.suffix), '|', cube_exp.fenperc(r_ite.domain), '|', r_ite.length, '|', r_ite.decimals, '|', cube_exp.fenperc(r_ite.case_sensitive), '|', cube_exp.fenperc(r_ite.default_value), '|', cube_exp.fenperc(r_ite.spaces_allowed), '|', cube_exp.fenperc(r_ite.presentation), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_val (p_line_num, p_level, r_ite);
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-INFORMATION_TYPE_ELEMENT:', r_ite.sequence, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_itp (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_itp itp.v_information_type;
BEGIN
	FOR r_itp IN
		SELECT *				
		FROM itp.v_information_type
		ORDER BY name
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+INFORMATION_TYPE[', r_itp.cube_id, ']:', cube_exp.fenperc(r_itp.name), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_ite (p_line_num, p_level, r_itp);
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-INFORMATION_TYPE:', r_itp.name, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_tsp (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_tsg IN bot.v_type_specialisation_group) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_tsp bot.v_type_specialisation;
BEGIN
	FOR r_tsp IN
		SELECT *				
		FROM bot.v_type_specialisation
		WHERE fk_bot_name = p_tsg.fk_bot_name
		  AND fk_typ_name = p_tsg.fk_typ_name
		  AND fk_tsg_code = p_tsg.code
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+TYPE_SPECIALISATION[', r_tsp.cube_id, ']:', cube_exp.fenperc(r_tsp.code), '|', cube_exp.fenperc(r_tsp.name), ';'));
		p_level := p_level + 1;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type_specialisation
			WHERE fk_typ_name = r_tsp.xf_tsp_typ_name
			  AND fk_tsg_code = r_tsp.xf_tsp_tsg_code
			  AND code = r_tsp.xk_tsp_code;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>TYPE_SPECIALISATION:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-TYPE_SPECIALISATION:', r_tsp.code, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_tsg_recursive (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_tsg IN bot.v_type_specialisation_group) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_tsg bot.v_type_specialisation_group;
BEGIN
	FOR r_tsg IN
		SELECT *				
		FROM bot.v_type_specialisation_group
		WHERE fk_bot_name = p_tsg.fk_bot_name
		  AND fk_typ_name = p_tsg.fk_typ_name
		  AND fk_tsg_code = p_tsg.code
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+TYPE_SPECIALISATION_GROUP[', r_tsg.cube_id, ']:', cube_exp.fenperc(r_tsg.code), '|', cube_exp.fenperc(r_tsg.name), '|', cube_exp.fenperc(r_tsg.primary_key), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_tsp (p_line_num, p_level, r_tsg);
		CALL cube_exp.export_tsg_recursive (p_line_num, p_level, r_tsg);
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_attribute
			WHERE fk_typ_name = r_tsg.xf_atb_typ_name
			  AND name = r_tsg.xk_atb_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>ATTRIBUTE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-TYPE_SPECIALISATION_GROUP:', r_tsg.code, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_tsg (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_typ IN bot.v_type) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_tsg bot.v_type_specialisation_group;
BEGIN
	FOR r_tsg IN
		SELECT *				
		FROM bot.v_type_specialisation_group
		WHERE fk_bot_name = p_typ.fk_bot_name
		  AND fk_typ_name = p_typ.name
		  AND fk_tsg_code IS NULL
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+TYPE_SPECIALISATION_GROUP[', r_tsg.cube_id, ']:', cube_exp.fenperc(r_tsg.code), '|', cube_exp.fenperc(r_tsg.name), '|', cube_exp.fenperc(r_tsg.primary_key), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_tsp (p_line_num, p_level, r_tsg);
		CALL cube_exp.export_tsg_recursive (p_line_num, p_level, r_tsg);
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_attribute
			WHERE fk_typ_name = r_tsg.xf_atb_typ_name
			  AND name = r_tsg.xk_atb_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>ATTRIBUTE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-TYPE_SPECIALISATION_GROUP:', r_tsg.code, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_der (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_atb IN bot.v_attribute) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_der bot.v_derivation;
BEGIN
	FOR r_der IN
		SELECT *				
		FROM bot.v_derivation
		WHERE fk_bot_name = p_atb.fk_bot_name
		  AND fk_typ_name = p_atb.fk_typ_name
		  AND fk_atb_name = p_atb.name
		ORDER BY cube_id
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+DERIVATION[', r_der.cube_id, ']:', cube_exp.fenperc(r_der.cube_tsg_type), '|', cube_exp.fenperc(r_der.aggregate_function), ';'));
		p_level := p_level + 1;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type
			WHERE name = r_der.xk_typ_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>DERIVATION_TYPE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type
			WHERE name = r_der.xk_typ_name_1;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>DERIVATION_TYPE_CONCERNS_CHILD:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-DERIVATION:', r_der.cube_tsg_type, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_dca (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_atb IN bot.v_attribute) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_dca bot.v_description_attribute;
BEGIN
	FOR r_dca IN
		SELECT *				
		FROM bot.v_description_attribute
		WHERE fk_bot_name = p_atb.fk_bot_name
		  AND fk_typ_name = p_atb.fk_typ_name
		  AND fk_atb_name = p_atb.name
		ORDER BY cube_id
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'=DESCRIPTION_ATTRIBUTE[', r_dca.cube_id, ']:', cube_exp.fenperc(r_dca.text), ';'));
		p_level := p_level + 1;
		p_level := p_level - 1;
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_rta (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_atb IN bot.v_attribute) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_rta bot.v_restriction_type_spec_atb;
BEGIN
	FOR r_rta IN
		SELECT *				
		FROM bot.v_restriction_type_spec_atb
		WHERE fk_bot_name = p_atb.fk_bot_name
		  AND fk_typ_name = p_atb.fk_typ_name
		  AND fk_atb_name = p_atb.name
		ORDER BY fk_typ_name, fk_atb_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+RESTRICTION_TYPE_SPEC_ATB[', r_rta.cube_id, ']:', cube_exp.fenperc(r_rta.include_or_exclude), ';'));
		p_level := p_level + 1;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type_specialisation
			WHERE fk_typ_name = r_rta.xf_tsp_typ_name
			  AND fk_tsg_code = r_rta.xf_tsp_tsg_code
			  AND code = r_rta.xk_tsp_code;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>TYPE_SPECIALISATION:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-RESTRICTION_TYPE_SPEC_ATB:', r_rta.include_or_exclude, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_atb (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_typ IN bot.v_type) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_atb bot.v_attribute;
BEGIN
	FOR r_atb IN
		SELECT *				
		FROM bot.v_attribute
		WHERE fk_bot_name = p_typ.fk_bot_name
		  AND fk_typ_name = p_typ.name
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+ATTRIBUTE[', r_atb.cube_id, ']:', cube_exp.fenperc(r_atb.name), '|', cube_exp.fenperc(r_atb.primary_key), '|', cube_exp.fenperc(r_atb.code_display_key), '|', cube_exp.fenperc(r_atb.code_foreign_key), '|', cube_exp.fenperc(r_atb.flag_hidden), '|', cube_exp.fenperc(r_atb.default_value), '|', cube_exp.fenperc(r_atb.unchangeable), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_der (p_line_num, p_level, r_atb);
		CALL cube_exp.export_dca (p_line_num, p_level, r_atb);
		CALL cube_exp.export_rta (p_line_num, p_level, r_atb);
		BEGIN
			SELECT cube_id INTO l_cube_id FROM itp.v_information_type
			WHERE name = r_atb.xk_itp_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>INFORMATION_TYPE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-ATTRIBUTE:', r_atb.name, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_dcr (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_ref IN bot.v_reference) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_dcr bot.v_description_reference;
BEGIN
	FOR r_dcr IN
		SELECT *				
		FROM bot.v_description_reference
		WHERE fk_bot_name = p_ref.fk_bot_name
		  AND fk_typ_name = p_ref.fk_typ_name
		  AND fk_ref_sequence = p_ref.sequence
		  AND fk_ref_bot_name = p_ref.xk_bot_name
		  AND fk_ref_typ_name = p_ref.xk_typ_name
		ORDER BY cube_id
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'=DESCRIPTION_REFERENCE[', r_dcr.cube_id, ']:', cube_exp.fenperc(r_dcr.text), ';'));
		p_level := p_level + 1;
		p_level := p_level - 1;
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_rtr (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_ref IN bot.v_reference) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_rtr bot.v_restriction_type_spec_ref;
BEGIN
	FOR r_rtr IN
		SELECT *				
		FROM bot.v_restriction_type_spec_ref
		WHERE fk_bot_name = p_ref.fk_bot_name
		  AND fk_typ_name = p_ref.fk_typ_name
		  AND fk_ref_sequence = p_ref.sequence
		  AND fk_ref_bot_name = p_ref.xk_bot_name
		  AND fk_ref_typ_name = p_ref.xk_typ_name
		ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+RESTRICTION_TYPE_SPEC_REF[', r_rtr.cube_id, ']:', cube_exp.fenperc(r_rtr.include_or_exclude), ';'));
		p_level := p_level + 1;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type_specialisation
			WHERE fk_typ_name = r_rtr.xf_tsp_typ_name
			  AND fk_tsg_code = r_rtr.xf_tsp_tsg_code
			  AND code = r_rtr.xk_tsp_code;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>TYPE_SPECIALISATION:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-RESTRICTION_TYPE_SPEC_REF:', r_rtr.include_or_exclude, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_rts (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_ref IN bot.v_reference) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_rts bot.v_restriction_target_type_spec;
BEGIN
	FOR r_rts IN
		SELECT *				
		FROM bot.v_restriction_target_type_spec
		WHERE fk_bot_name = p_ref.fk_bot_name
		  AND fk_typ_name = p_ref.fk_typ_name
		  AND fk_ref_sequence = p_ref.sequence
		  AND fk_ref_bot_name = p_ref.xk_bot_name
		  AND fk_ref_typ_name = p_ref.xk_typ_name
		ORDER BY cube_id
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+RESTRICTION_TARGET_TYPE_SPEC[', r_rts.cube_id, ']:', cube_exp.fenperc(r_rts.include_or_exclude), ';'));
		p_level := p_level + 1;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type_specialisation
			WHERE fk_typ_name = r_rts.xf_tsp_typ_name
			  AND fk_tsg_code = r_rts.xf_tsp_tsg_code
			  AND code = r_rts.xk_tsp_code;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>TYPE_SPECIALISATION:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-RESTRICTION_TARGET_TYPE_SPEC:', r_rts.include_or_exclude, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_ref (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_typ IN bot.v_type) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_ref bot.v_reference;
BEGIN
	FOR r_ref IN
		SELECT *				
		FROM bot.v_reference
		WHERE fk_bot_name = p_typ.fk_bot_name
		  AND fk_typ_name = p_typ.name
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+REFERENCE[', r_ref.cube_id, ']:', cube_exp.fenperc(r_ref.name), '|', cube_exp.fenperc(r_ref.primary_key), '|', cube_exp.fenperc(r_ref.code_display_key), '|', r_ref.sequence, '|', cube_exp.fenperc(r_ref.scope), '|', cube_exp.fenperc(r_ref.unchangeable), '|', cube_exp.fenperc(r_ref.within_scope_extension), '|', cube_exp.fenperc(r_ref.cube_tsg_int_ext), '|', cube_exp.fenperc(r_ref.type_prefix), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_dcr (p_line_num, p_level, r_ref);
		CALL cube_exp.export_rtr (p_line_num, p_level, r_ref);
		CALL cube_exp.export_rts (p_line_num, p_level, r_ref);
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_business_object_type
			WHERE name = r_ref.xk_bot_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>BUSINESS_OBJECT_TYPE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type
			WHERE name = r_ref.xk_typ_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>REFERENCE_TYPE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type
			WHERE name = r_ref.xk_typ_name_1;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>REFERENCE_TYPE_WITHIN_SCOPE_OF:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-REFERENCE:', r_ref.name, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_sst (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_srv IN bot.v_service) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_sst bot.v_service_step;
BEGIN
	FOR r_sst IN
		SELECT *				
		FROM bot.v_service_step
		WHERE fk_bot_name = p_srv.fk_bot_name
		  AND fk_typ_name = p_srv.fk_typ_name
		  AND fk_srv_name = p_srv.name
		  AND fk_srv_cube_tsg_db_scr = p_srv.cube_tsg_db_scr
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'=SERVICE_STEP[', r_sst.cube_id, ']:', cube_exp.fenperc(r_sst.name), '|', cube_exp.fenperc(r_sst.script_name), ';'));
		p_level := p_level + 1;
		p_level := p_level - 1;
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_svd (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_srv IN bot.v_service) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_svd bot.v_service_detail;
BEGIN
	FOR r_svd IN
		SELECT *				
		FROM bot.v_service_detail
		WHERE fk_bot_name = p_srv.fk_bot_name
		  AND fk_typ_name = p_srv.fk_typ_name
		  AND fk_srv_name = p_srv.name
		  AND fk_srv_cube_tsg_db_scr = p_srv.cube_tsg_db_scr
		ORDER BY cube_id
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+SERVICE_DETAIL[', r_svd.cube_id, ']:', cube_exp.fenperc(r_svd.cube_tsg_atb_ref), ';'));
		p_level := p_level + 1;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_attribute
			WHERE fk_typ_name = r_svd.xf_atb_typ_name
			  AND name = r_svd.xk_atb_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>SERVICE_DETAIL_ATTRIBUTE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_reference
			WHERE fk_typ_name = r_svd.xf_ref_typ_name
			  AND sequence = r_svd.xk_ref_sequence
			  AND xk_bot_name = r_svd.xk_ref_bot_name
			  AND xk_typ_name = r_svd.xk_ref_typ_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>SERVICE_DETAIL_REFERENCE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-SERVICE_DETAIL:', r_svd.cube_tsg_atb_ref, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_srv (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_typ IN bot.v_type) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_srv bot.v_service;
BEGIN
	FOR r_srv IN
		SELECT *				
		FROM bot.v_service
		WHERE fk_bot_name = p_typ.fk_bot_name
		  AND fk_typ_name = p_typ.name
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+SERVICE[', r_srv.cube_id, ']:', cube_exp.fenperc(r_srv.name), '|', cube_exp.fenperc(r_srv.cube_tsg_db_scr), '|', cube_exp.fenperc(r_srv.class), '|', cube_exp.fenperc(r_srv.accessibility), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_sst (p_line_num, p_level, r_srv);
		CALL cube_exp.export_svd (p_line_num, p_level, r_srv);
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-SERVICE:', r_srv.name, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_rtt (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_typ IN bot.v_type) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_rtt bot.v_restriction_type_spec_typ;
BEGIN
	FOR r_rtt IN
		SELECT *				
		FROM bot.v_restriction_type_spec_typ
		WHERE fk_bot_name = p_typ.fk_bot_name
		  AND fk_typ_name = p_typ.name
		ORDER BY fk_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+RESTRICTION_TYPE_SPEC_TYP[', r_rtt.cube_id, ']:', cube_exp.fenperc(r_rtt.include_or_exclude), ';'));
		p_level := p_level + 1;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type_specialisation
			WHERE fk_typ_name = r_rtt.xf_tsp_typ_name
			  AND fk_tsg_code = r_rtt.xf_tsp_tsg_code
			  AND code = r_rtt.xk_tsp_code;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>TYPE_SPECIALISATION:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-RESTRICTION_TYPE_SPEC_TYP:', r_rtt.include_or_exclude, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_jsn_recursive (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_jsn IN bot.v_json_path) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_jsn bot.v_json_path;
BEGIN
	FOR r_jsn IN
		SELECT *				
		FROM bot.v_json_path
		WHERE fk_bot_name = p_jsn.fk_bot_name
		  AND fk_typ_name = p_jsn.fk_typ_name
		  AND fk_jsn_name = p_jsn.name
		  AND fk_jsn_location = p_jsn.location
		  AND fk_jsn_atb_typ_name = p_jsn.xf_atb_typ_name
		  AND fk_jsn_atb_name = p_jsn.xk_atb_name
		  AND fk_jsn_typ_name = p_jsn.xk_typ_name
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+JSON_PATH[', r_jsn.cube_id, ']:', cube_exp.fenperc(r_jsn.cube_tsg_obj_arr), '|', cube_exp.fenperc(r_jsn.cube_tsg_type), '|', cube_exp.fenperc(r_jsn.name), '|', r_jsn.location, ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_jsn_recursive (p_line_num, p_level, r_jsn);
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_attribute
			WHERE fk_typ_name = r_jsn.xf_atb_typ_name
			  AND name = r_jsn.xk_atb_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>ATTRIBUTE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type
			WHERE name = r_jsn.xk_typ_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>JSON_PATH_TYPE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-JSON_PATH:', r_jsn.cube_tsg_obj_arr, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_jsn (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_typ IN bot.v_type) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_jsn bot.v_json_path;
BEGIN
	FOR r_jsn IN
		SELECT *				
		FROM bot.v_json_path
		WHERE fk_bot_name = p_typ.fk_bot_name
		  AND fk_typ_name = p_typ.name
		  AND fk_jsn_name IS NULL
		  AND fk_jsn_location IS NULL
		  AND fk_jsn_atb_typ_name IS NULL
		  AND fk_jsn_atb_name IS NULL
		  AND fk_jsn_typ_name IS NULL
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+JSON_PATH[', r_jsn.cube_id, ']:', cube_exp.fenperc(r_jsn.cube_tsg_obj_arr), '|', cube_exp.fenperc(r_jsn.cube_tsg_type), '|', cube_exp.fenperc(r_jsn.name), '|', r_jsn.location, ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_jsn_recursive (p_line_num, p_level, r_jsn);
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_attribute
			WHERE fk_typ_name = r_jsn.xf_atb_typ_name
			  AND name = r_jsn.xk_atb_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>ATTRIBUTE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_type
			WHERE name = r_jsn.xk_typ_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>JSON_PATH_TYPE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-JSON_PATH:', r_jsn.cube_tsg_obj_arr, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_dct (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_typ IN bot.v_type) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_dct bot.v_description_type;
BEGIN
	FOR r_dct IN
		SELECT *				
		FROM bot.v_description_type
		WHERE fk_bot_name = p_typ.fk_bot_name
		  AND fk_typ_name = p_typ.name
		ORDER BY cube_id
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'=DESCRIPTION_TYPE[', r_dct.cube_id, ']:', cube_exp.fenperc(r_dct.text), ';'));
		p_level := p_level + 1;
		p_level := p_level - 1;
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_typ_recursive (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_typ IN bot.v_type) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_typ bot.v_type;
BEGIN
	FOR r_typ IN
		SELECT *				
		FROM bot.v_type
		WHERE fk_bot_name = p_typ.fk_bot_name
		  AND fk_typ_name = p_typ.name
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+TYPE[', r_typ.cube_id, ']:', cube_exp.fenperc(r_typ.name), '|', cube_exp.fenperc(r_typ.code), '|', cube_exp.fenperc(r_typ.flag_partial_key), '|', cube_exp.fenperc(r_typ.flag_recursive), '|', cube_exp.fenperc(r_typ.recursive_cardinality), '|', cube_exp.fenperc(r_typ.cardinality), '|', cube_exp.fenperc(r_typ.sort_order), '|', cube_exp.fenperc(r_typ.icon), '|', cube_exp.fenperc(r_typ.transferable), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_tsg (p_line_num, p_level, r_typ);
		CALL cube_exp.export_atb (p_line_num, p_level, r_typ);
		CALL cube_exp.export_ref (p_line_num, p_level, r_typ);
		CALL cube_exp.export_srv (p_line_num, p_level, r_typ);
		CALL cube_exp.export_rtt (p_line_num, p_level, r_typ);
		CALL cube_exp.export_jsn (p_line_num, p_level, r_typ);
		CALL cube_exp.export_dct (p_line_num, p_level, r_typ);
		CALL cube_exp.export_typ_recursive (p_line_num, p_level, r_typ);
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-TYPE:', r_typ.name, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_typ (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_bot IN bot.v_business_object_type) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_typ bot.v_type;
BEGIN
	FOR r_typ IN
		SELECT *				
		FROM bot.v_type
		WHERE fk_bot_name = p_bot.name
		  AND fk_typ_name IS NULL
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+TYPE[', r_typ.cube_id, ']:', cube_exp.fenperc(r_typ.name), '|', cube_exp.fenperc(r_typ.code), '|', cube_exp.fenperc(r_typ.flag_partial_key), '|', cube_exp.fenperc(r_typ.flag_recursive), '|', cube_exp.fenperc(r_typ.recursive_cardinality), '|', cube_exp.fenperc(r_typ.cardinality), '|', cube_exp.fenperc(r_typ.sort_order), '|', cube_exp.fenperc(r_typ.icon), '|', cube_exp.fenperc(r_typ.transferable), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_tsg (p_line_num, p_level, r_typ);
		CALL cube_exp.export_atb (p_line_num, p_level, r_typ);
		CALL cube_exp.export_ref (p_line_num, p_level, r_typ);
		CALL cube_exp.export_srv (p_line_num, p_level, r_typ);
		CALL cube_exp.export_rtt (p_line_num, p_level, r_typ);
		CALL cube_exp.export_jsn (p_line_num, p_level, r_typ);
		CALL cube_exp.export_dct (p_line_num, p_level, r_typ);
		CALL cube_exp.export_typ_recursive (p_line_num, p_level, r_typ);
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-TYPE:', r_typ.name, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_bot (p_system IN VARCHAR, p_line_num INOUT NUMERIC, p_level INOUT NUMERIC) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_bot bot.v_business_object_type;
BEGIN
	FOR r_bot IN
		SELECT *				
		FROM bot.v_business_object_type
		WHERE (p_system = 'ALL' OR name in (SELECT xk_bot_name FROM sys.v_system_bo_type WHERE fk_sys_name = p_system ))
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+BUSINESS_OBJECT_TYPE[', r_bot.cube_id, ']:', cube_exp.fenperc(r_bot.name), '|', cube_exp.fenperc(r_bot.cube_tsg_type), '|', cube_exp.fenperc(r_bot.directory), '|', cube_exp.fenperc(r_bot.api_url), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_typ (p_line_num, p_level, r_bot);
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-BUSINESS_OBJECT_TYPE:', r_bot.name, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_sbt (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_sys IN sys.v_system) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_sbt sys.v_system_bo_type;
BEGIN
	FOR r_sbt IN
		SELECT *				
		FROM sys.v_system_bo_type
		WHERE fk_sys_name = p_sys.name
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+SYSTEM_BO_TYPE[', r_sbt.cube_id, ']:', ';'));
		p_level := p_level + 1;
		BEGIN
			SELECT cube_id INTO l_cube_id FROM bot.v_business_object_type
			WHERE name = r_sbt.xk_bot_name;
			p_line_num := p_line_num + 1;
			INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level), '>BUSINESS_OBJECT_TYPE:', l_cube_id, ';'));
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				NULL; 
		END;
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-SYSTEM_BO_TYPE:', ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_sys (p_system IN VARCHAR, p_line_num INOUT NUMERIC, p_level INOUT NUMERIC) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_sys sys.v_system;
BEGIN
	FOR r_sys IN
		SELECT *				
		FROM sys.v_system
		WHERE p_system = 'ALL' OR name = p_system
		ORDER BY name
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+SYSTEM[', r_sys.cube_id, ']:', cube_exp.fenperc(r_sys.name), '|', cube_exp.fenperc(r_sys.cube_tsg_type), '|', cube_exp.fenperc(r_sys.database), '|', cube_exp.fenperc(r_sys.schema), '|', cube_exp.fenperc(r_sys.password), '|', cube_exp.fenperc(r_sys.table_prefix), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_sbt (p_line_num, p_level, r_sys);
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-SYSTEM:', r_sys.name, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_arg (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC, p_fun IN fun.v_function) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_arg fun.v_argument;
BEGIN
	FOR r_arg IN
		SELECT *				
		FROM fun.v_argument
		WHERE fk_fun_name = p_fun.name
		ORDER BY cube_sequence
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'=ARGUMENT[', r_arg.cube_id, ']:', cube_exp.fenperc(r_arg.name), ';'));
		p_level := p_level + 1;
		p_level := p_level - 1;
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_fun (p_line_num INOUT NUMERIC, p_level INOUT NUMERIC) LANGUAGE plpgsql AS $$
DECLARE
	l_cube_id VARCHAR(16);
	r_fun fun.v_function;
BEGIN
	FOR r_fun IN
		SELECT *				
		FROM fun.v_function
		ORDER BY cube_id
	LOOP
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num, CONCAT(cube_exp.ftabs(p_level),'+FUNCTION[', r_fun.cube_id, ']:', cube_exp.fenperc(r_fun.name), ';'));
		p_level := p_level + 1;
		CALL cube_exp.export_arg (p_line_num, p_level, r_fun);
		p_level := p_level - 1;
		p_line_num := p_line_num + 1;
		INSERT INTO cube_exp.line VALUES (p_line_num,CONCAT(cube_exp.ftabs(p_level), '-FUNCTION:', r_fun.name, ';'));
	END LOOP;
END; 
$$;

CREATE PROCEDURE cube_exp.export_model (p_system VARCHAR) LANGUAGE plpgsql AS $$
DECLARE
	l_level NUMERIC(4) := 0;
	l_line_num NUMERIC(8) := 0;
BEGIN
	DELETE FROM cube_exp.line;
	l_line_num := 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '! Generated with CubeGen');
	l_line_num := 2;
    INSERT INTO cube_exp.line VALUES (l_line_num, '+META_MODEL:CUBE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '	+META_TYPE:INFORMATION_TYPE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:0|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		+META_TYPE:INFORMATION_TYPE_ELEMENT|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:0|Sequence|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:1|Suffix|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:2|Domain| Values: TEXT(Text), NUMBER(Number), DATE(Date), TIME(Time), DATETIME-LOCAL(Timestamp);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:3|Length|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:4|Decimals|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:5|CaseSensitive| Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:6|DefaultValue|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:7|SpacesAllowed| Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:8|Presentation|'||REPLACE('Indication%20how%20the%20string%20is%20presented%20in%20the%20user%20dialog.','%20',' ')||' Values: LIN(Line), DES(Description), COD(Code);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			+META_TYPE:PERMITTED_VALUE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:0|Code|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:1|Prompt|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			-META_TYPE:PERMITTED_VALUE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		-META_TYPE:INFORMATION_TYPE_ELEMENT;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '	-META_TYPE:INFORMATION_TYPE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '	+META_TYPE:BUSINESS_OBJECT_TYPE|'||REPLACE('An%20object%20type%20related%20to%20the%20business%20supported%20by%20the%20system.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:0|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:1|CubeTsgType| Values: INT(INTERNAL), EXT(EXTERNAL), RET(REUSABLE_TYPE);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:2|Directory|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:3|ApiUrl|'||REPLACE('The%20basic%20URL%20for%20calling%20the%20API.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		+META_TYPE:TYPE|'||REPLACE('An%20entity%20type%20related%20to%20the%20business%20that%20is%20supported%20by%20the%20system.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:0|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:1|Code|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:2|FlagPartialKey| Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:3|FlagRecursive| Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:4|RecursiveCardinality| Values: 1(1), 2(2), 3(3), 4(4), 5(5), N(Many);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:5|Cardinality| Values: 1(1), 2(2), 3(3), 4(4), 5(5), N(Many);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:6|SortOrder| Values: N(No sort), K(Key), P(Position);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:7|Icon|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:8|Transferable|'||REPLACE('Indication%20that%20in%20case%20of%20a%20recursive%20type%20the%20type%20may%20moved%20to%20an%20other%20parent%20in%20the%20hierarchy.','%20',' ')||' Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			+META_TYPE:TYPE_SPECIALISATION_GROUP|'||REPLACE('A%20group%20of%20classifications%20of%20the%20type.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:0|Code|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:1|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:2|PrimaryKey|'||REPLACE('Indication%20that%20the%20type%20specification%20group%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.','%20',' ')||' Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=ASSOCIATION:ATTRIBUTE|IsLocatedAfter|ATTRIBUTE|'||REPLACE('Defines%20the%20location%20of%20the%20classifying%20attribute%20within%20the%20type.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				+META_TYPE:TYPE_SPECIALISATION|'||REPLACE('A%20classification%20of%20the%20type.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:0|Code|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:1|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=ASSOCIATION:TYPE_SPECIALISATION|Specialise|TYPE_SPECIALISATION|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				-META_TYPE:TYPE_SPECIALISATION;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			-META_TYPE:TYPE_SPECIALISATION_GROUP;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			+META_TYPE:ATTRIBUTE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:0|Name|'||REPLACE('Unique%20identifier%20of%20the%20attribute.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:1|PrimaryKey|'||REPLACE('Indication%20that%20attribute%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.','%20',' ')||' Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:2|CodeDisplayKey| Values: Y(Yes), S(Sub), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:3|CodeForeignKey| Values: N(None);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:4|FlagHidden| Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:5|DefaultValue|'||REPLACE('Defaut%20value%20that%20overules%20the%20default%20value%20specified%20by%20the%20information%20type%20element.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:6|Unchangeable|'||REPLACE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20value%20of%20the%20atrribute%20can%20not%20be%20changed.','%20',' ')||' Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=ASSOCIATION:INFORMATION_TYPE|HasDomain|INFORMATION_TYPE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				+META_TYPE:DERIVATION|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:0|CubeTsgType| Values: DN(DENORMALIZATION), IN(INTERNAL), AG(AGGREGATION);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:1|AggregateFunction| Values: SUM(Sum), AVG(Average), MIN(Minimum), MAX(Maximum);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=ASSOCIATION:DERIVATION_TYPE|ConcernsParent|TYPE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=ASSOCIATION:DERIVATION_TYPE_CONCERNS_CHILD|ConcernsChild|TYPE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				-META_TYPE:DERIVATION;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				+META_TYPE:DESCRIPTION_ATTRIBUTE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:0|Text|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				-META_TYPE:DESCRIPTION_ATTRIBUTE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				+META_TYPE:RESTRICTION_TYPE_SPEC_ATB|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:0|IncludeOrExclude|'||REPLACE('Indication%20that%20the%20attribute%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.','%20',' ')||' Values: IN(Include), EX(Exclude);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=ASSOCIATION:TYPE_SPECIALISATION|IsValidFor|TYPE_SPECIALISATION|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				-META_TYPE:RESTRICTION_TYPE_SPEC_ATB;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			-META_TYPE:ATTRIBUTE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			+META_TYPE:REFERENCE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:0|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:1|PrimaryKey|'||REPLACE('Indication%20that%20reference%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.','%20',' ')||' Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:2|CodeDisplayKey| Values: Y(Yes), S(Sub), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:3|Sequence|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:4|Scope|'||REPLACE('In%20case%20of%20a%20recursive%20target%2C%20the%20definition%20of%20the%20collection%20of%20the%20types%20to%20select.','%20',' ')||' Values: ALL(All), PRA(Parents all), PR1(Parents first level), CHA(Children all), CH1(Children first level);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:5|Unchangeable|'||REPLACE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20reference%20can%20not%20be%20changed.%20So%20in%20case%20of%20a%20recursive%20reference%20the%20indication%20too%20that%20the%20relation%20is%20used%20to%20select%20the%20parents%20or%20children%20in%20the%20hierarchy.','%20',' ')||' Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:6|WithinScopeExtension| Values: PAR(Recursive parent), REF(Referenced type);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:7|CubeTsgIntExt| Values: INT(INTERNAL), EXT(EXTERNAL);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:8|TypePrefix|'||REPLACE('Indication%20that%20the%20technical%20(model)%20name%20is%20prefixed%20with%20the%20name%20of%20the%20parent%20type.','%20',' ')||' Values: Y(Yes), N(No);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=ASSOCIATION:BUSINESS_OBJECT_TYPE|Refer|BUSINESS_OBJECT_TYPE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=ASSOCIATION:REFERENCE_TYPE|Refer|TYPE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=ASSOCIATION:REFERENCE_TYPE_WITHIN_SCOPE_OF|WithinScopeOf|TYPE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				+META_TYPE:DESCRIPTION_REFERENCE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:0|Text|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				-META_TYPE:DESCRIPTION_REFERENCE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				+META_TYPE:RESTRICTION_TYPE_SPEC_REF|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:0|IncludeOrExclude|'||REPLACE('Indication%20that%20the%20reference%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.','%20',' ')||' Values: IN(Include), EX(Exclude);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=ASSOCIATION:TYPE_SPECIALISATION|IsValidFor|TYPE_SPECIALISATION|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				-META_TYPE:RESTRICTION_TYPE_SPEC_REF;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				+META_TYPE:RESTRICTION_TARGET_TYPE_SPEC|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:0|IncludeOrExclude| Values: IN(Include), EX(Exclude);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=ASSOCIATION:TYPE_SPECIALISATION|IsValidFor|TYPE_SPECIALISATION|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				-META_TYPE:RESTRICTION_TARGET_TYPE_SPEC;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			-META_TYPE:REFERENCE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			+META_TYPE:SERVICE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:0|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:1|CubeTsgDbScr| Values: D(DATABASE_INTERACTION), S(SERVER_SCRIPT);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:2|Class| Values: LST(List), CNT(Count), SEL(Select), CNP(Check no part), DPO(Determine position), MOV(Move), GTN(Get next), CPA(Change parent), CRE(Create), UPD(Update), DEL(Delete), CHC(Check Content);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:3|Accessibility| Values: I(Internal), E(External), U(User);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				+META_TYPE:SERVICE_STEP|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:0|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:1|ScriptName|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				-META_TYPE:SERVICE_STEP;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				+META_TYPE:SERVICE_DETAIL|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=PROPERTY:0|CubeTsgAtbRef| Values: ATB(ATTRIBUTE), REF(REFERENCE);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=ASSOCIATION:SERVICE_DETAIL_ATTRIBUTE|Concerns|ATTRIBUTE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '					=ASSOCIATION:SERVICE_DETAIL_REFERENCE|Concerns|REFERENCE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				-META_TYPE:SERVICE_DETAIL;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			-META_TYPE:SERVICE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			+META_TYPE:RESTRICTION_TYPE_SPEC_TYP|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:0|IncludeOrExclude|'||REPLACE('Indication%20that%20the%20child%20type%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.','%20',' ')||' Values: IN(Include), EX(Exclude);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=ASSOCIATION:TYPE_SPECIALISATION|IsValidFor|TYPE_SPECIALISATION|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			-META_TYPE:RESTRICTION_TYPE_SPEC_TYP;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			+META_TYPE:JSON_PATH|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:0|CubeTsgObjArr| Values: OBJ(OBJECT), ARR(ARRAY);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:1|CubeTsgType| Values: GRP(GROUP), ATRIBREF(ATTRIBUTE_REFERENCE), TYPEREF(TYPE_REFERENCE);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:2|Name|'||REPLACE('The%20tag%20of%20the%20object.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:3|Location|'||REPLACE('The%20index%20of%20the%20array.%20The%20first%20item%20is%200.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=ASSOCIATION:ATTRIBUTE|Concerns|ATTRIBUTE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=ASSOCIATION:JSON_PATH_TYPE|Concerns|TYPE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			-META_TYPE:JSON_PATH;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			+META_TYPE:DESCRIPTION_TYPE|'||REPLACE('Test%0D%0AMet%20LF%20en%20%22%20en%20%27%20%20en%20%25%20%20%20%20%25%0D%0AEInde','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '				=PROPERTY:0|Text|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			-META_TYPE:DESCRIPTION_TYPE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		-META_TYPE:TYPE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '	-META_TYPE:BUSINESS_OBJECT_TYPE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '	+META_TYPE:SYSTEM|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:0|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:1|CubeTsgType| Values: PRIMARY(PRIMARY_SYSTEM), SUPPORT(SUPPORTING_SYSTEM);');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:2|Database|'||REPLACE('The%20name%20of%20the%20database%20where%20the%20tables%20of%20the%20system%20will%20be%20implemented.','%20',' ')||';');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:3|Schema|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:4|Password|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:5|TablePrefix|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		+META_TYPE:SYSTEM_BO_TYPE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=ASSOCIATION:BUSINESS_OBJECT_TYPE|Has|BUSINESS_OBJECT_TYPE|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		-META_TYPE:SYSTEM_BO_TYPE;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '	-META_TYPE:SYSTEM;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '	+META_TYPE:FUNCTION|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		=PROPERTY:0|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		+META_TYPE:ARGUMENT|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '			=PROPERTY:0|Name|;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '		-META_TYPE:ARGUMENT;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '	-META_TYPE:FUNCTION;');
	l_line_num := l_line_num + 1;
	INSERT INTO cube_exp.line VALUES (l_line_num, '-META_MODEL:CUBE;');
	
	CALL cube_exp.export_itp (l_line_num, l_level);
	CALL cube_exp.export_bot (p_system, l_line_num, l_level);
	CALL cube_exp.export_sys (p_system, l_line_num, l_level);
	CALL cube_exp.export_fun (l_line_num, l_level);
END;
$$;
