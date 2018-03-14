SET ECHO OFF
SET VERIFY OFF
SET SERVEROUT ON
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET HEADING ON
SET PAGESIZE 0
SET LINESIZE 999

SPOOL "&1" &2;
DECLARE

	l_level NUMBER(4) := 0;
	l_cube_id VARCHAR2(16);

	FUNCTION ftabs RETURN VARCHAR2 IS
		l_tabs VARCHAR2(80) := '';
	BEGIN
		FOR i IN 1..l_level
		LOOP
			l_tabs := l_tabs || '	';
		END LOOP;
		RETURN(l_tabs);		
	END;

	FUNCTION fenperc (p_text IN VARCHAR2) RETURN VARCHAR2 IS
	BEGIN
		RETURN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(p_text,'%','%25'),';','%3B'),'"','%22'),'|','%7C'),CHR(13),'%0D'),CHR(10),'%0A'),CHR(9),'%09'));		
	END;


	PROCEDURE report_val (p_ite IN t_information_type_element%ROWTYPE) IS
	BEGIN
		FOR r_val IN (
			SELECT *				
			FROM t_permitted_value
			WHERE fk_itp_name = p_ite.fk_itp_name
			  AND fk_ite_sequence = p_ite.sequence
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '=PERMITTED_VALUE[' || r_val.cube_id || ']:' || fenperc(r_val.code) || '|' || fenperc(r_val.prompt) || ';');
				l_level := l_level + 1;
				l_level := l_level - 1;
		END LOOP;
	END;


	PROCEDURE report_ite (p_itp IN t_information_type%ROWTYPE) IS
	BEGIN
		FOR r_ite IN (
			SELECT *				
			FROM t_information_type_element
			WHERE fk_itp_name = p_itp.name
			ORDER BY fk_itp_name, sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+INFORMATION_TYPE_ELEMENT[' || r_ite.cube_id || ']:' || fenperc(r_ite.sequence) || '|' || fenperc(r_ite.suffix) || '|' || fenperc(r_ite.domain) || '|' || fenperc(r_ite.length) || '|' || fenperc(r_ite.decimals) || '|' || fenperc(r_ite.case_sensitive) || '|' || fenperc(r_ite.default_value) || '|' || fenperc(r_ite.spaces_allowed) || '|' || fenperc(r_ite.descriptive) || ';');
				l_level := l_level + 1;
				report_val (r_ite);
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-INFORMATION_TYPE_ELEMENT:' || r_ite.sequence || ';');
		END LOOP;
	END;


	PROCEDURE report_itp IS
	BEGIN
		FOR r_itp IN (
			SELECT *				
			FROM t_information_type
			ORDER BY name )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+INFORMATION_TYPE[' || r_itp.cube_id || ']:' || fenperc(r_itp.name) || ';');
				l_level := l_level + 1;
				report_ite (r_itp);
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-INFORMATION_TYPE:' || r_itp.name || ';');
		END LOOP;
	END;


	PROCEDURE report_der (p_atb IN t_attribute%ROWTYPE) IS
	BEGIN
		FOR r_der IN (
			SELECT *				
			FROM t_derivation
			WHERE fk_bot_name = p_atb.fk_bot_name
			  AND fk_typ_name = p_atb.fk_typ_name
			  AND fk_atb_name = p_atb.name
			ORDER BY cube_id )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+DERIVATION[' || r_der.cube_id || ']:' || fenperc(r_der.cube_tsg_type) || '|' || fenperc(r_der.aggregate_function) || ';');
				l_level := l_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM t_type
					WHERE name = r_der.xk_typ_name;

					DBMS_OUTPUT.PUT_LINE (ftabs || '>DERIVATION_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM t_type
					WHERE name = r_der.xk_typ_name_1;

					DBMS_OUTPUT.PUT_LINE (ftabs || '>DERIVATION_TYPE_CONCERNS_CHILD:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-DERIVATION:' || r_der.cube_tsg_type || ';');
		END LOOP;
	END;


	PROCEDURE report_dca (p_atb IN t_attribute%ROWTYPE) IS
	BEGIN
		FOR r_dca IN (
			SELECT *				
			FROM t_description_attribute
			WHERE fk_bot_name = p_atb.fk_bot_name
			  AND fk_typ_name = p_atb.fk_typ_name
			  AND fk_atb_name = p_atb.name
			ORDER BY cube_id )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '=DESCRIPTION_ATTRIBUTE[' || r_dca.cube_id || ']:' || fenperc(r_dca.text) || ';');
				l_level := l_level + 1;
				l_level := l_level - 1;
		END LOOP;
	END;


	PROCEDURE report_rta (p_atb IN t_attribute%ROWTYPE) IS
	BEGIN
		FOR r_rta IN (
			SELECT *				
			FROM t_restriction_type_spec_atb
			WHERE fk_bot_name = p_atb.fk_bot_name
			  AND fk_typ_name = p_atb.fk_typ_name
			  AND fk_atb_name = p_atb.name
			ORDER BY fk_typ_name, fk_atb_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+RESTRICTION_TYPE_SPEC_ATB[' || r_rta.cube_id || ']:' || fenperc(r_rta.include_or_exclude) || ';');
				l_level := l_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM t_type_specialisation
					WHERE fk_typ_name = r_rta.xf_tsp_typ_name
					  AND fk_tsg_code = r_rta.xf_tsp_tsg_code
					  AND code = r_rta.xk_tsp_code;

					DBMS_OUTPUT.PUT_LINE (ftabs || '>TYPE_SPECIALISATION:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-RESTRICTION_TYPE_SPEC_ATB:' || r_rta.include_or_exclude || ';');
		END LOOP;
	END;


	PROCEDURE report_atb (p_typ IN t_type%ROWTYPE) IS
	BEGIN
		FOR r_atb IN (
			SELECT *				
			FROM t_attribute
			WHERE fk_bot_name = p_typ.fk_bot_name
			  AND fk_typ_name = p_typ.name
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+ATTRIBUTE[' || r_atb.cube_id || ']:' || fenperc(r_atb.name) || '|' || fenperc(r_atb.primary_key) || '|' || fenperc(r_atb.code_display_key) || '|' || fenperc(r_atb.code_foreign_key) || '|' || fenperc(r_atb.flag_hidden) || '|' || fenperc(r_atb.default_value) || '|' || fenperc(r_atb.unchangeable) || ';');
				l_level := l_level + 1;
				report_der (r_atb);
				report_dca (r_atb);
				report_rta (r_atb);
				BEGIN
					SELECT cube_id INTO l_cube_id FROM t_information_type
					WHERE name = r_atb.xk_itp_name;

					DBMS_OUTPUT.PUT_LINE (ftabs || '>INFORMATION_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-ATTRIBUTE:' || r_atb.name || ';');
		END LOOP;
	END;


	PROCEDURE report_dcr (p_ref IN t_reference%ROWTYPE) IS
	BEGIN
		FOR r_dcr IN (
			SELECT *				
			FROM t_description_reference
			WHERE fk_bot_name = p_ref.fk_bot_name
			  AND fk_typ_name = p_ref.fk_typ_name
			  AND fk_ref_sequence = p_ref.sequence
			  AND fk_ref_typ_name = p_ref.xk_typ_name
			ORDER BY cube_id )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '=DESCRIPTION_REFERENCE[' || r_dcr.cube_id || ']:' || fenperc(r_dcr.text) || ';');
				l_level := l_level + 1;
				l_level := l_level - 1;
		END LOOP;
	END;


	PROCEDURE report_rtr (p_ref IN t_reference%ROWTYPE) IS
	BEGIN
		FOR r_rtr IN (
			SELECT *				
			FROM t_restriction_type_spec_ref
			WHERE fk_bot_name = p_ref.fk_bot_name
			  AND fk_typ_name = p_ref.fk_typ_name
			  AND fk_ref_sequence = p_ref.sequence
			  AND fk_ref_typ_name = p_ref.xk_typ_name
			ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+RESTRICTION_TYPE_SPEC_REF[' || r_rtr.cube_id || ']:' || fenperc(r_rtr.include_or_exclude) || ';');
				l_level := l_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM t_type_specialisation
					WHERE fk_typ_name = r_rtr.xf_tsp_typ_name
					  AND fk_tsg_code = r_rtr.xf_tsp_tsg_code
					  AND code = r_rtr.xk_tsp_code;

					DBMS_OUTPUT.PUT_LINE (ftabs || '>TYPE_SPECIALISATION:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-RESTRICTION_TYPE_SPEC_REF:' || r_rtr.include_or_exclude || ';');
		END LOOP;
	END;


	PROCEDURE report_ref (p_typ IN t_type%ROWTYPE) IS
	BEGIN
		FOR r_ref IN (
			SELECT *				
			FROM t_reference
			WHERE fk_bot_name = p_typ.fk_bot_name
			  AND fk_typ_name = p_typ.name
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+REFERENCE[' || r_ref.cube_id || ']:' || fenperc(r_ref.name) || '|' || fenperc(r_ref.primary_key) || '|' || fenperc(r_ref.code_display_key) || '|' || fenperc(r_ref.sequence) || '|' || fenperc(r_ref.scope) || '|' || fenperc(r_ref.unchangeable) || '|' || fenperc(r_ref.within_scope_level) || ';');
				l_level := l_level + 1;
				report_dcr (r_ref);
				report_rtr (r_ref);
				BEGIN
					SELECT cube_id INTO l_cube_id FROM t_type
					WHERE name = r_ref.xk_typ_name;

					DBMS_OUTPUT.PUT_LINE (ftabs || '>REFERENCE_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM t_type
					WHERE name = r_ref.xk_typ_name_1;

					DBMS_OUTPUT.PUT_LINE (ftabs || '>REFERENCE_TYPE_WITHIN_SCOPE_OF:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-REFERENCE:' || r_ref.name || ';');
		END LOOP;
	END;


	PROCEDURE report_tyr (p_typ IN t_type%ROWTYPE) IS
	BEGIN
		FOR r_tyr IN (
			SELECT *				
			FROM t_type_reuse
			WHERE fk_bot_name = p_typ.fk_bot_name
			  AND fk_typ_name = p_typ.name
			ORDER BY fk_typ_name, xk_typ_name )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+TYPE_REUSE[' || r_tyr.cube_id || ']:' || fenperc(r_tyr.cardinality) || ';');
				l_level := l_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM t_type
					WHERE name = r_tyr.xk_typ_name;

					DBMS_OUTPUT.PUT_LINE (ftabs || '>TYPE_REUSE_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-TYPE_REUSE:' || r_tyr.cardinality || ';');
		END LOOP;
	END;


	PROCEDURE report_stp (p_par IN t_partition%ROWTYPE) IS
	BEGIN
		FOR r_stp IN (
			SELECT *				
			FROM t_subtype
			WHERE fk_bot_name = p_par.fk_bot_name
			  AND fk_typ_name = p_par.fk_typ_name
			  AND fk_par_name = p_par.name
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '=SUBTYPE[' || r_stp.cube_id || ']:' || fenperc(r_stp.name) || ';');
				l_level := l_level + 1;
				l_level := l_level - 1;
		END LOOP;
	END;


	PROCEDURE report_par (p_typ IN t_type%ROWTYPE) IS
	BEGIN
		FOR r_par IN (
			SELECT *				
			FROM t_partition
			WHERE fk_bot_name = p_typ.fk_bot_name
			  AND fk_typ_name = p_typ.name
			ORDER BY cube_id )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+PARTITION[' || r_par.cube_id || ']:' || fenperc(r_par.name) || ';');
				l_level := l_level + 1;
				report_stp (r_par);
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-PARTITION:' || r_par.name || ';');
		END LOOP;
	END;


	PROCEDURE report_tsp (p_tsg IN t_type_specialisation_group%ROWTYPE) IS
	BEGIN
		FOR r_tsp IN (
			SELECT *				
			FROM t_type_specialisation
			WHERE fk_bot_name = p_tsg.fk_bot_name
			  AND fk_typ_name = p_tsg.fk_typ_name
			  AND fk_tsg_code = p_tsg.code
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+TYPE_SPECIALISATION[' || r_tsp.cube_id || ']:' || fenperc(r_tsp.code) || '|' || fenperc(r_tsp.name) || ';');
				l_level := l_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM t_type_specialisation
					WHERE fk_typ_name = r_tsp.xf_tsp_typ_name
					  AND fk_tsg_code = r_tsp.xf_tsp_tsg_code
					  AND code = r_tsp.xk_tsp_code;

					DBMS_OUTPUT.PUT_LINE (ftabs || '>TYPE_SPECIALISATION:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-TYPE_SPECIALISATION:' || r_tsp.code || ';');
		END LOOP;
	END;


	PROCEDURE report_tsg_recursive (p_tsg IN t_type_specialisation_group%ROWTYPE) IS
	BEGIN
		FOR r_tsg IN (
			SELECT *				
			FROM t_type_specialisation_group
			WHERE fk_bot_name = p_tsg.fk_bot_name
			  AND fk_typ_name = p_tsg.fk_typ_name
			  AND fk_tsg_code = p_tsg.code
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+TYPE_SPECIALISATION_GROUP[' || r_tsg.cube_id || ']:' || fenperc(r_tsg.code) || '|' || fenperc(r_tsg.name) || '|' || fenperc(r_tsg.primary_key) || ';');
				l_level := l_level + 1;
				report_tsp (r_tsg);
				report_tsg_recursive (r_tsg);
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-TYPE_SPECIALISATION_GROUP:' || r_tsg.code || ';');
		END LOOP;
	END;


	PROCEDURE report_tsg (p_typ IN t_type%ROWTYPE) IS
	BEGIN
		FOR r_tsg IN (
			SELECT *				
			FROM t_type_specialisation_group
			WHERE fk_bot_name = p_typ.fk_bot_name
			  AND fk_typ_name = p_typ.name
			  AND fk_tsg_code IS NULL
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+TYPE_SPECIALISATION_GROUP[' || r_tsg.cube_id || ']:' || fenperc(r_tsg.code) || '|' || fenperc(r_tsg.name) || '|' || fenperc(r_tsg.primary_key) || ';');
				l_level := l_level + 1;
				report_tsp (r_tsg);
				report_tsg_recursive (r_tsg);
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-TYPE_SPECIALISATION_GROUP:' || r_tsg.code || ';');
		END LOOP;
	END;


	PROCEDURE report_dct (p_typ IN t_type%ROWTYPE) IS
	BEGIN
		FOR r_dct IN (
			SELECT *				
			FROM t_description_type
			WHERE fk_bot_name = p_typ.fk_bot_name
			  AND fk_typ_name = p_typ.name
			ORDER BY cube_id )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '=DESCRIPTION_TYPE[' || r_dct.cube_id || ']:' || fenperc(r_dct.text) || ';');
				l_level := l_level + 1;
				l_level := l_level - 1;
		END LOOP;
	END;


	PROCEDURE report_typ_recursive (p_typ IN t_type%ROWTYPE) IS
	BEGIN
		FOR r_typ IN (
			SELECT *				
			FROM t_type
			WHERE fk_bot_name = p_typ.fk_bot_name
			  AND fk_typ_name = p_typ.name
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+TYPE[' || r_typ.cube_id || ']:' || fenperc(r_typ.name) || '|' || fenperc(r_typ.code) || '|' || fenperc(r_typ.flag_partial_key) || '|' || fenperc(r_typ.flag_recursive) || '|' || fenperc(r_typ.recursive_cardinality) || '|' || fenperc(r_typ.cardinality) || '|' || fenperc(r_typ.sort_order) || '|' || fenperc(r_typ.icon) || '|' || fenperc(r_typ.transferable) || ';');
				l_level := l_level + 1;
				report_atb (r_typ);
				report_ref (r_typ);
				report_tyr (r_typ);
				report_par (r_typ);
				report_tsg (r_typ);
				report_dct (r_typ);
				report_typ_recursive (r_typ);
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-TYPE:' || r_typ.name || ';');
		END LOOP;
	END;


	PROCEDURE report_typ (p_bot IN t_business_object_type%ROWTYPE) IS
	BEGIN
		FOR r_typ IN (
			SELECT *				
			FROM t_type
			WHERE fk_bot_name = p_bot.name
			  AND fk_typ_name IS NULL
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+TYPE[' || r_typ.cube_id || ']:' || fenperc(r_typ.name) || '|' || fenperc(r_typ.code) || '|' || fenperc(r_typ.flag_partial_key) || '|' || fenperc(r_typ.flag_recursive) || '|' || fenperc(r_typ.recursive_cardinality) || '|' || fenperc(r_typ.cardinality) || '|' || fenperc(r_typ.sort_order) || '|' || fenperc(r_typ.icon) || '|' || fenperc(r_typ.transferable) || ';');
				l_level := l_level + 1;
				report_atb (r_typ);
				report_ref (r_typ);
				report_tyr (r_typ);
				report_par (r_typ);
				report_tsg (r_typ);
				report_dct (r_typ);
				report_typ_recursive (r_typ);
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-TYPE:' || r_typ.name || ';');
		END LOOP;
	END;


	PROCEDURE report_bot IS
	BEGIN
		FOR r_bot IN (
			SELECT *				
			FROM t_business_object_type
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+BUSINESS_OBJECT_TYPE[' || r_bot.cube_id || ']:' || fenperc(r_bot.name) || '|' || fenperc(r_bot.directory) || ';');
				l_level := l_level + 1;
				report_typ (r_bot);
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-BUSINESS_OBJECT_TYPE:' || r_bot.name || ';');
		END LOOP;
	END;


	PROCEDURE report_sbt (p_sys IN t_system%ROWTYPE) IS
	BEGIN
		FOR r_sbt IN (
			SELECT *				
			FROM t_system_bo_type
			WHERE fk_sys_name = p_sys.name
			ORDER BY cube_sequence )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+SYSTEM_BO_TYPE[' || r_sbt.cube_id || ']:' || ';');
				l_level := l_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM t_business_object_type
					WHERE name = r_sbt.xk_bot_name;

					DBMS_OUTPUT.PUT_LINE (ftabs || '>BUSINESS_OBJECT_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-SYSTEM_BO_TYPE:' || ';');
		END LOOP;
	END;


	PROCEDURE report_sys IS
	BEGIN
		FOR r_sys IN (
			SELECT *				
			FROM t_system
			ORDER BY name )
		LOOP
			DBMS_OUTPUT.PUT_LINE (ftabs || '+SYSTEM[' || r_sys.cube_id || ']:' || fenperc(r_sys.name) || '|' || fenperc(r_sys.database) || '|' || fenperc(r_sys.schema) || '|' || fenperc(r_sys.password) || ';');
				l_level := l_level + 1;
				report_sbt (r_sys);
				l_level := l_level - 1;
			DBMS_OUTPUT.PUT_LINE (ftabs || '-SYSTEM:' || r_sys.name || ';');
		END LOOP;
	END;

BEGIN
	DBMS_OUTPUT.PUT_LINE ('! Generated with CubeGen');
	DBMS_OUTPUT.PUT_LINE ('+META_MODEL:CUBE;');
	DBMS_OUTPUT.PUT_LINE ('	+META_TYPE:INFORMATION_TYPE|;');
	DBMS_OUTPUT.PUT_LINE ('		=PROPERTY:0|Name|;');
	DBMS_OUTPUT.PUT_LINE ('		+META_TYPE:INFORMATION_TYPE_ELEMENT|;');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:0|Sequence|;');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:1|Suffix|;');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:2|Domain| Values: CH(Text), NR(Number), DT(Date), TI(Time), TS(Timestamp);');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:3|Length|;');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:4|Decimals|;');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:5|CaseSensitive| Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:6|DefaultValue|;');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:7|SpacesAllowed| Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:8|Descriptive| Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('			+META_TYPE:PERMITTED_VALUE|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:0|Code|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:1|Prompt|;');
	DBMS_OUTPUT.PUT_LINE ('			-META_TYPE:PERMITTED_VALUE;');
	DBMS_OUTPUT.PUT_LINE ('		-META_TYPE:INFORMATION_TYPE_ELEMENT;');
	DBMS_OUTPUT.PUT_LINE ('	-META_TYPE:INFORMATION_TYPE;');
	DBMS_OUTPUT.PUT_LINE ('	+META_TYPE:BUSINESS_OBJECT_TYPE|'||REPLACE('An%20object%20type%20related%20to%20the%20business%20supported%20by%20the%20system.','%20',' ')||';');
	DBMS_OUTPUT.PUT_LINE ('		=PROPERTY:0|Name|;');
	DBMS_OUTPUT.PUT_LINE ('		=PROPERTY:1|Directory|;');
	DBMS_OUTPUT.PUT_LINE ('		+META_TYPE:TYPE|'||REPLACE('An%20entity%20type%20related%20to%20the%20business%20that%20is%20supported%20by%20the%20system.','%20',' ')||';');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:0|Name|;');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:1|Code|;');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:2|FlagPartialKey| Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:3|FlagRecursive| Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:4|RecursiveCardinality| Values: 1(1), 2(2), 3(3), 4(4), 5(5), N(Many);');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:5|Cardinality| Values: 1(1), 2(2), 3(3), 4(4), 5(5), N(Many);');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:6|SortOrder| Values: N(No sort), K(Key), P(Position);');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:7|Icon|;');
	DBMS_OUTPUT.PUT_LINE ('			=PROPERTY:8|Transferable|'||REPLACE('Indication%20that%20in%20case%20of%20a%20recursive%20type%20the%20type%20may%20moved%20to%20an%20other%20parent%20in%20the%20hierarchy.','%20',' ')||' Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('			+META_TYPE:ATTRIBUTE|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:0|Name|'||REPLACE('Unique%20identifier%20of%20the%20attribute.','%20',' ')||';');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:1|PrimaryKey|'||REPLACE('Indication%20that%20attribute%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.','%20',' ')||' Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:2|CodeDisplayKey| Values: Y(Yes), S(Sub), N(No);');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:3|CodeForeignKey| Values: N(None);');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:4|FlagHidden| Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:5|DefaultValue|'||REPLACE('Defaut%20value%20that%20overules%20the%20default%20value%20specified%20by%20the%20information%20type%20element.','%20',' ')||';');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:6|Unchangeable|'||REPLACE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20value%20of%20the%20atrribute%20can%20not%20be%20changed.','%20',' ')||' Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('				=ASSOCIATION:INFORMATION_TYPE|HasDomain|INFORMATION_TYPE|;');
	DBMS_OUTPUT.PUT_LINE ('				+META_TYPE:DERIVATION|;');
	DBMS_OUTPUT.PUT_LINE ('					=PROPERTY:0|CubeTsgType| Values: DN(DENORMALIZATION), IN(INTERNAL), AG(AGGREGATION);');
	DBMS_OUTPUT.PUT_LINE ('					=PROPERTY:1|AggregateFunction| Values: SUM(Sum), AVG(Average), MIN(Minimum), MAX(Maximum);');
	DBMS_OUTPUT.PUT_LINE ('					=ASSOCIATION:DERIVATION_TYPE|ConcernsParent|TYPE|;');
	DBMS_OUTPUT.PUT_LINE ('					=ASSOCIATION:DERIVATION_TYPE_CONCERNS_CHILD|ConcernsChild|TYPE|;');
	DBMS_OUTPUT.PUT_LINE ('				-META_TYPE:DERIVATION;');
	DBMS_OUTPUT.PUT_LINE ('				+META_TYPE:DESCRIPTION_ATTRIBUTE|;');
	DBMS_OUTPUT.PUT_LINE ('					=PROPERTY:0|Text|;');
	DBMS_OUTPUT.PUT_LINE ('				-META_TYPE:DESCRIPTION_ATTRIBUTE;');
	DBMS_OUTPUT.PUT_LINE ('				+META_TYPE:RESTRICTION_TYPE_SPEC_ATB|;');
	DBMS_OUTPUT.PUT_LINE ('					=PROPERTY:0|IncludeOrExclude|'||REPLACE('Indication%20that%20the%20attribute%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.','%20',' ')||' Values: IN(Include), EX(Exclude);');
	DBMS_OUTPUT.PUT_LINE ('					=ASSOCIATION:TYPE_SPECIALISATION|IsValidFor|TYPE_SPECIALISATION|;');
	DBMS_OUTPUT.PUT_LINE ('				-META_TYPE:RESTRICTION_TYPE_SPEC_ATB;');
	DBMS_OUTPUT.PUT_LINE ('			-META_TYPE:ATTRIBUTE;');
	DBMS_OUTPUT.PUT_LINE ('			+META_TYPE:REFERENCE|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:0|Name|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:1|PrimaryKey|'||REPLACE('Indication%20that%20reference%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.','%20',' ')||' Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:2|CodeDisplayKey| Values: Y(Yes), S(Sub), N(No);');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:3|Sequence|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:4|Scope|'||REPLACE('In%20case%20of%20a%20recursive%20target%2C%20the%20definition%20of%20the%20collection%20of%20the%20types%20to%20select.','%20',' ')||' Values: ALL(All), ENC(Encapsulated), PRA(Parents all), PR1(Parents first level), CHA(Children all), CH1(Children first level);');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:5|Unchangeable|'||REPLACE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20reference%20can%20not%20be%20changed.%20So%20in%20case%20of%20a%20recursive%20reference%20the%20indication%20too%20that%20the%20relation%20is%20used%20to%20select%20the%20parents%20or%20children%20in%20the%20hierarchy.','%20',' ')||' Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:6|WithinScopeLevel|'||REPLACE('In%20case%20of%20recursive%20%22wihin%20scope%20of%22%20type%20the%20relative%20level%20in%20the%20hierarchy%2C%20Positive%20numbers%20are%20the%20parent%20levels%2C%20Negative%20numbers%20are%20the%20child%20levels.','%20',' ')||';');
	DBMS_OUTPUT.PUT_LINE ('				=ASSOCIATION:REFERENCE_TYPE|Refer|TYPE|'||REPLACE('The%20target%20entity%20type%20of%20the%20reference.','%20',' ')||';');
	DBMS_OUTPUT.PUT_LINE ('				=ASSOCIATION:REFERENCE_TYPE_WITHIN_SCOPE_OF|WithinScopeOf|TYPE|'||REPLACE('In%20case%20of%20non%20recursive%20target%20or%20a%20scope%20all%20recursive%20target%20the%20common%20type%20for%20the%20selection.','%20',' ')||';');
	DBMS_OUTPUT.PUT_LINE ('				+META_TYPE:DESCRIPTION_REFERENCE|;');
	DBMS_OUTPUT.PUT_LINE ('					=PROPERTY:0|Text|;');
	DBMS_OUTPUT.PUT_LINE ('				-META_TYPE:DESCRIPTION_REFERENCE;');
	DBMS_OUTPUT.PUT_LINE ('				+META_TYPE:RESTRICTION_TYPE_SPEC_REF|;');
	DBMS_OUTPUT.PUT_LINE ('					=PROPERTY:0|IncludeOrExclude|'||REPLACE('Indication%20that%20the%20reference%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.','%20',' ')||' Values: IN(Include), EX(Exclude);');
	DBMS_OUTPUT.PUT_LINE ('					=ASSOCIATION:TYPE_SPECIALISATION|IsValidFor|TYPE_SPECIALISATION|;');
	DBMS_OUTPUT.PUT_LINE ('				-META_TYPE:RESTRICTION_TYPE_SPEC_REF;');
	DBMS_OUTPUT.PUT_LINE ('			-META_TYPE:REFERENCE;');
	DBMS_OUTPUT.PUT_LINE ('			+META_TYPE:TYPE_REUSE|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:0|Cardinality| Values: 1(1), 2(2), 3(3), 4(4), 5(5), N(Many);');
	DBMS_OUTPUT.PUT_LINE ('				=ASSOCIATION:TYPE_REUSE_TYPE|Refer|TYPE|;');
	DBMS_OUTPUT.PUT_LINE ('			-META_TYPE:TYPE_REUSE;');
	DBMS_OUTPUT.PUT_LINE ('			+META_TYPE:PARTITION|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:0|Name|;');
	DBMS_OUTPUT.PUT_LINE ('				+META_TYPE:SUBTYPE|;');
	DBMS_OUTPUT.PUT_LINE ('					=PROPERTY:0|Name|;');
	DBMS_OUTPUT.PUT_LINE ('				-META_TYPE:SUBTYPE;');
	DBMS_OUTPUT.PUT_LINE ('			-META_TYPE:PARTITION;');
	DBMS_OUTPUT.PUT_LINE ('			+META_TYPE:TYPE_SPECIALISATION_GROUP|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:0|Code|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:1|Name|;');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:2|PrimaryKey|'||REPLACE('Indication%20that%20the%20type%20specification%20group%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.','%20',' ')||' Values: Y(Yes), N(No);');
	DBMS_OUTPUT.PUT_LINE ('				+META_TYPE:TYPE_SPECIALISATION|;');
	DBMS_OUTPUT.PUT_LINE ('					=PROPERTY:0|Code|;');
	DBMS_OUTPUT.PUT_LINE ('					=PROPERTY:1|Name|;');
	DBMS_OUTPUT.PUT_LINE ('					=ASSOCIATION:TYPE_SPECIALISATION|Specialise|TYPE_SPECIALISATION|;');
	DBMS_OUTPUT.PUT_LINE ('				-META_TYPE:TYPE_SPECIALISATION;');
	DBMS_OUTPUT.PUT_LINE ('			-META_TYPE:TYPE_SPECIALISATION_GROUP;');
	DBMS_OUTPUT.PUT_LINE ('			+META_TYPE:DESCRIPTION_TYPE|'||REPLACE('Test%0D%0AMet%20LF%20en%20%22%20en%20%27%20%20en%20%25%20%20%20%20%25%0D%0AEInde','%20',' ')||';');
	DBMS_OUTPUT.PUT_LINE ('				=PROPERTY:0|Text|;');
	DBMS_OUTPUT.PUT_LINE ('			-META_TYPE:DESCRIPTION_TYPE;');
	DBMS_OUTPUT.PUT_LINE ('		-META_TYPE:TYPE;');
	DBMS_OUTPUT.PUT_LINE ('	-META_TYPE:BUSINESS_OBJECT_TYPE;');
	DBMS_OUTPUT.PUT_LINE ('	+META_TYPE:SYSTEM|;');
	DBMS_OUTPUT.PUT_LINE ('		=PROPERTY:0|Name|;');
	DBMS_OUTPUT.PUT_LINE ('		=PROPERTY:1|Database|;');
	DBMS_OUTPUT.PUT_LINE ('		=PROPERTY:2|Schema|;');
	DBMS_OUTPUT.PUT_LINE ('		=PROPERTY:3|Password|;');
	DBMS_OUTPUT.PUT_LINE ('		+META_TYPE:SYSTEM_BO_TYPE|;');
	DBMS_OUTPUT.PUT_LINE ('			=ASSOCIATION:BUSINESS_OBJECT_TYPE|Has|BUSINESS_OBJECT_TYPE|;');
	DBMS_OUTPUT.PUT_LINE ('		-META_TYPE:SYSTEM_BO_TYPE;');
	DBMS_OUTPUT.PUT_LINE ('	-META_TYPE:SYSTEM;');
	DBMS_OUTPUT.PUT_LINE ('-META_MODEL:CUBE;');

	report_itp;
	report_bot;
	report_sys;
END;
/
SPOOL OFF;
EXIT;