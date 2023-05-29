-- Model export
\o :model 
\pset tuples_only
\pset format unaligned
\pset fieldsep ''

SELECT '! Generated with CubeGen';
SELECT '+META_MODEL:CUBE;';
SELECT '	+META_TYPE:INFORMATION_TYPE|;';
SELECT '		=PROPERTY:0|Name|;';
SELECT '		+META_TYPE:INFORMATION_TYPE_ELEMENT|;';
SELECT '			=PROPERTY:0|Sequence|;';
SELECT '			=PROPERTY:1|Suffix|;';
SELECT '			=PROPERTY:2|Domain| Values: TEXT(Text), NUMBER(Number), DATE(Date), TIME(Time), DATETIME-LOCAL(Timestamp);';
SELECT '			=PROPERTY:3|Length|;';
SELECT '			=PROPERTY:4|Decimals|;';
SELECT '			=PROPERTY:5|CaseSensitive| Values: Y(Yes), N(No);';
SELECT '			=PROPERTY:6|DefaultValue|;';
SELECT '			=PROPERTY:7|SpacesAllowed| Values: Y(Yes), N(No);';
SELECT '			=PROPERTY:8|Presentation|'||REPLACE('Indication%20how%20the%20string%20is%20presented%20in%20the%20user%20dialog.','%20',' ')||' Values: LIN(Line), DES(Description), COD(Code);';
SELECT '			+META_TYPE:PERMITTED_VALUE|;';
SELECT '				=PROPERTY:0|Code|;';
SELECT '				=PROPERTY:1|Prompt|;';
SELECT '			-META_TYPE:PERMITTED_VALUE;';
SELECT '		-META_TYPE:INFORMATION_TYPE_ELEMENT;';
SELECT '	-META_TYPE:INFORMATION_TYPE;';
SELECT '	+META_TYPE:BUSINESS_OBJECT_TYPE|'||REPLACE('An%20object%20type%20related%20to%20the%20business%20supported%20by%20the%20system.','%20',' ')||';';
SELECT '		=PROPERTY:0|Name|;';
SELECT '		=PROPERTY:1|CubeTsgType| Values: INT(INTERNAL), EXT(EXTERNAL), RET(REUSABLE_TYPE);';
SELECT '		=PROPERTY:2|Directory|;';
SELECT '		=PROPERTY:3|ApiUrl|'||REPLACE('The%20basic%20URL%20for%20calling%20the%20API.','%20',' ')||';';
SELECT '		+META_TYPE:TYPE|'||REPLACE('An%20entity%20type%20related%20to%20the%20business%20that%20is%20supported%20by%20the%20system.','%20',' ')||';';
SELECT '			=PROPERTY:0|Name|;';
SELECT '			=PROPERTY:1|Code|;';
SELECT '			=PROPERTY:2|FlagPartialKey| Values: Y(Yes), N(No);';
SELECT '			=PROPERTY:3|FlagRecursive| Values: Y(Yes), N(No);';
SELECT '			=PROPERTY:4|RecursiveCardinality| Values: 1(1), 2(2), 3(3), 4(4), 5(5), N(Many);';
SELECT '			=PROPERTY:5|Cardinality| Values: 1(1), 2(2), 3(3), 4(4), 5(5), N(Many);';
SELECT '			=PROPERTY:6|SortOrder| Values: N(No sort), K(Key), P(Position);';
SELECT '			=PROPERTY:7|Icon|;';
SELECT '			=PROPERTY:8|Transferable|'||REPLACE('Indication%20that%20in%20case%20of%20a%20recursive%20type%20the%20type%20may%20moved%20to%20an%20other%20parent%20in%20the%20hierarchy.','%20',' ')||' Values: Y(Yes), N(No);';
SELECT '			+META_TYPE:TYPE_SPECIALISATION_GROUP|'||REPLACE('A%20group%20of%20classifications%20of%20the%20type.','%20',' ')||';';
SELECT '				=PROPERTY:0|Code|;';
SELECT '				=PROPERTY:1|Name|;';
SELECT '				=PROPERTY:2|PrimaryKey|'||REPLACE('Indication%20that%20the%20type%20specification%20group%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.','%20',' ')||' Values: Y(Yes), N(No);';
SELECT '				=ASSOCIATION:ATTRIBUTE|IsLocatedAfter|ATTRIBUTE|'||REPLACE('Defines%20the%20location%20of%20the%20classifying%20attribute%20within%20the%20type.','%20',' ')||';';
SELECT '				+META_TYPE:TYPE_SPECIALISATION|'||REPLACE('A%20classification%20of%20the%20type.','%20',' ')||';';
SELECT '					=PROPERTY:0|Code|;';
SELECT '					=PROPERTY:1|Name|;';
SELECT '					=ASSOCIATION:TYPE_SPECIALISATION|Specialise|TYPE_SPECIALISATION|;';
SELECT '				-META_TYPE:TYPE_SPECIALISATION;';
SELECT '			-META_TYPE:TYPE_SPECIALISATION_GROUP;';
SELECT '			+META_TYPE:ATTRIBUTE|;';
SELECT '				=PROPERTY:0|Name|'||REPLACE('Unique%20identifier%20of%20the%20attribute.','%20',' ')||';';
SELECT '				=PROPERTY:1|PrimaryKey|'||REPLACE('Indication%20that%20attribute%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.','%20',' ')||' Values: Y(Yes), N(No);';
SELECT '				=PROPERTY:2|CodeDisplayKey| Values: Y(Yes), S(Sub), N(No);';
SELECT '				=PROPERTY:3|CodeForeignKey| Values: N(None);';
SELECT '				=PROPERTY:4|FlagHidden| Values: Y(Yes), N(No);';
SELECT '				=PROPERTY:5|DefaultValue|'||REPLACE('Defaut%20value%20that%20overules%20the%20default%20value%20specified%20by%20the%20information%20type%20element.','%20',' ')||';';
SELECT '				=PROPERTY:6|Unchangeable|'||REPLACE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20value%20of%20the%20atrribute%20can%20not%20be%20changed.','%20',' ')||' Values: Y(Yes), N(No);';
SELECT '				=ASSOCIATION:INFORMATION_TYPE|HasDomain|INFORMATION_TYPE|;';
SELECT '				+META_TYPE:DERIVATION|;';
SELECT '					=PROPERTY:0|CubeTsgType| Values: DN(DENORMALIZATION), IN(INTERNAL), AG(AGGREGATION);';
SELECT '					=PROPERTY:1|AggregateFunction| Values: SUM(Sum), AVG(Average), MIN(Minimum), MAX(Maximum);';
SELECT '					=ASSOCIATION:DERIVATION_TYPE|ConcernsParent|TYPE|;';
SELECT '					=ASSOCIATION:DERIVATION_TYPE_CONCERNS_CHILD|ConcernsChild|TYPE|;';
SELECT '				-META_TYPE:DERIVATION;';
SELECT '				+META_TYPE:DESCRIPTION_ATTRIBUTE|;';
SELECT '					=PROPERTY:0|Text|;';
SELECT '				-META_TYPE:DESCRIPTION_ATTRIBUTE;';
SELECT '				+META_TYPE:RESTRICTION_TYPE_SPEC_ATB|;';
SELECT '					=PROPERTY:0|IncludeOrExclude|'||REPLACE('Indication%20that%20the%20attribute%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.','%20',' ')||' Values: IN(Include), EX(Exclude);';
SELECT '					=ASSOCIATION:TYPE_SPECIALISATION|IsValidFor|TYPE_SPECIALISATION|;';
SELECT '				-META_TYPE:RESTRICTION_TYPE_SPEC_ATB;';
SELECT '			-META_TYPE:ATTRIBUTE;';
SELECT '			+META_TYPE:REFERENCE|;';
SELECT '				=PROPERTY:0|Name|;';
SELECT '				=PROPERTY:1|PrimaryKey|'||REPLACE('Indication%20that%20reference%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.','%20',' ')||' Values: Y(Yes), N(No);';
SELECT '				=PROPERTY:2|CodeDisplayKey| Values: Y(Yes), S(Sub), N(No);';
SELECT '				=PROPERTY:3|Sequence|;';
SELECT '				=PROPERTY:4|Scope|'||REPLACE('In%20case%20of%20a%20recursive%20target%2C%20the%20definition%20of%20the%20collection%20of%20the%20types%20to%20select.','%20',' ')||' Values: ALL(All), PRA(Parents all), PR1(Parents first level), CHA(Children all), CH1(Children first level);';
SELECT '				=PROPERTY:5|Unchangeable|'||REPLACE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20reference%20can%20not%20be%20changed.%20So%20in%20case%20of%20a%20recursive%20reference%20the%20indication%20too%20that%20the%20relation%20is%20used%20to%20select%20the%20parents%20or%20children%20in%20the%20hierarchy.','%20',' ')||' Values: Y(Yes), N(No);';
SELECT '				=PROPERTY:6|WithinScopeExtension| Values: PAR(Recursive parent), REF(Referenced type);';
SELECT '				=PROPERTY:7|CubeTsgIntExt| Values: INT(INTERNAL), EXT(EXTERNAL);';
SELECT '				=ASSOCIATION:BUSINESS_OBJECT_TYPE|Refer|BUSINESS_OBJECT_TYPE|;';
SELECT '				=ASSOCIATION:REFERENCE_TYPE|Refer|TYPE|;';
SELECT '				=ASSOCIATION:REFERENCE_TYPE_WITHIN_SCOPE_OF|WithinScopeOf|TYPE|;';
SELECT '				+META_TYPE:DESCRIPTION_REFERENCE|;';
SELECT '					=PROPERTY:0|Text|;';
SELECT '				-META_TYPE:DESCRIPTION_REFERENCE;';
SELECT '				+META_TYPE:RESTRICTION_TYPE_SPEC_REF|;';
SELECT '					=PROPERTY:0|IncludeOrExclude|'||REPLACE('Indication%20that%20the%20reference%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.','%20',' ')||' Values: IN(Include), EX(Exclude);';
SELECT '					=ASSOCIATION:TYPE_SPECIALISATION|IsValidFor|TYPE_SPECIALISATION|;';
SELECT '				-META_TYPE:RESTRICTION_TYPE_SPEC_REF;';
SELECT '				+META_TYPE:RESTRICTION_TARGET_TYPE_SPEC|;';
SELECT '					=PROPERTY:0|IncludeOrExclude| Values: IN(Include), EX(Exclude);';
SELECT '					=ASSOCIATION:TYPE_SPECIALISATION|IsValidFor|TYPE_SPECIALISATION|;';
SELECT '				-META_TYPE:RESTRICTION_TARGET_TYPE_SPEC;';
SELECT '			-META_TYPE:REFERENCE;';
SELECT '			+META_TYPE:RESTRICTION_TYPE_SPEC_TYP|;';
SELECT '				=PROPERTY:0|IncludeOrExclude|'||REPLACE('Indication%20that%20the%20child%20type%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.','%20',' ')||' Values: IN(Include), EX(Exclude);';
SELECT '				=ASSOCIATION:TYPE_SPECIALISATION|IsValidFor|TYPE_SPECIALISATION|;';
SELECT '			-META_TYPE:RESTRICTION_TYPE_SPEC_TYP;';
SELECT '			+META_TYPE:JSON_PATH|;';
SELECT '				=PROPERTY:0|CubeTsgObjArr| Values: OBJ(OBJECT), ARR(ARRAY);';
SELECT '				=PROPERTY:1|CubeTsgType| Values: GRP(GROUP), ATRIBREF(ATTRIBUTE_REFERENCE), TYPEREF(TYPE_REFERENCE);';
SELECT '				=PROPERTY:2|Name|'||REPLACE('The%20tag%20of%20the%20object.','%20',' ')||';';
SELECT '				=PROPERTY:3|Location|'||REPLACE('The%20index%20of%20the%20array.%20The%20first%20item%20is%200.','%20',' ')||';';
SELECT '				=ASSOCIATION:ATTRIBUTE|Concerns|ATTRIBUTE|;';
SELECT '				=ASSOCIATION:JSON_PATH_TYPE|Concerns|TYPE|;';
SELECT '			-META_TYPE:JSON_PATH;';
SELECT '			+META_TYPE:DESCRIPTION_TYPE|'||REPLACE('Test%0D%0AMet%20LF%20en%20%22%20en%20%27%20%20en%20%25%20%20%20%20%25%0D%0AEInde','%20',' ')||';';
SELECT '				=PROPERTY:0|Text|;';
SELECT '			-META_TYPE:DESCRIPTION_TYPE;';
SELECT '		-META_TYPE:TYPE;';
SELECT '	-META_TYPE:BUSINESS_OBJECT_TYPE;';
SELECT '	+META_TYPE:SYSTEM|;';
SELECT '		=PROPERTY:0|Name|;';
SELECT '		=PROPERTY:1|CubeTsgType| Values: PRIMARY(PRIMARY_SYSTEM), SUPPORT(SUPPORTING_SYSTEM);';
SELECT '		=PROPERTY:2|Database|'||REPLACE('The%20name%20of%20the%20database%20where%20the%20tables%20of%20the%20system%20will%20be%20implemented.','%20',' ')||';';
SELECT '		=PROPERTY:3|Schema|;';
SELECT '		=PROPERTY:4|Password|;';
SELECT '		=PROPERTY:5|TablePrefix|;';
SELECT '		+META_TYPE:SYSTEM_BO_TYPE|;';
SELECT '			=ASSOCIATION:BUSINESS_OBJECT_TYPE|Has|BUSINESS_OBJECT_TYPE|;';
SELECT '		-META_TYPE:SYSTEM_BO_TYPE;';
SELECT '	-META_TYPE:SYSTEM;';
SELECT '	+META_TYPE:FUNCTION|;';
SELECT '		=PROPERTY:0|Name|;';
SELECT '		+META_TYPE:ARGUMENT|;';
SELECT '			=PROPERTY:0|Name|;';
SELECT '		-META_TYPE:ARGUMENT;';
SELECT '	-META_TYPE:FUNCTION;';
SELECT '-META_MODEL:CUBE;';

DO $BODY$
	DECLARE
		g_level NUMERIC(4) := 0;
		g_system_name VARCHAR(30) :=  :system;
		g_line_num NUMERIC(8) := 0;
	BEGIN
		CREATE OR REPLACE FUNCTION ftabs (p_level IN NUMERIC) RETURNS VARCHAR LANGUAGE plpgsql AS $$
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
		
		CREATE OR REPLACE FUNCTION fenperc (p_text IN VARCHAR) RETURNS VARCHAR LANGUAGE plpgsql AS $$
		BEGIN
			RETURN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(p_text,'%','%25'),';','%3B'),'"','%22'),'|','%7C'),CHR(13),'%0D'),CHR(10),'%0A'),CHR(9),'%09'));		
		END;
		$$;

		CREATE SCHEMA IF NOT EXISTS cube;
		CREATE TABLE IF NOT EXISTS cube.line ();
		ALTER TABLE cube.line ADD COLUMN IF NOT EXISTS num NUMERIC(8);
		ALTER TABLE cube.line ADD COLUMN IF NOT EXISTS str VARCHAR;
		DELETE FROM cube.line;


		CREATE OR REPLACE PROCEDURE report_val (p_line_num NUMERIC, p_level NUMERIC, p_ite IN itp.t_information_type_element) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_val itp.t_permitted_value;
		BEGIN
			FOR r_val IN
				SELECT *				
				FROM itp.t_permitted_value
				WHERE fk_itp_name = p_ite.fk_itp_name
				AND fk_ite_sequence = p_ite.sequence
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '=PERMITTED_VALUE[' || r_val.cube_id || ']:' || fenperc(r_val.code) || '|' || fenperc(r_val.prompt) || ';');
				p_level := p_level + 1;
				p_level := p_level - 1;
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_ite (p_line_num NUMERIC, p_level NUMERIC, p_itp IN itp.t_information_type) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_ite itp.t_information_type_element;
		BEGIN
			FOR r_ite IN
				SELECT *				
				FROM itp.t_information_type_element
				WHERE fk_itp_name = p_itp.name
				ORDER BY fk_itp_name, sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+INFORMATION_TYPE_ELEMENT[' || r_ite.cube_id || ']:' || r_ite.sequence || '|' || fenperc(r_ite.suffix) || '|' || fenperc(r_ite.domain) || '|' || r_ite.length || '|' || r_ite.decimals || '|' || fenperc(r_ite.case_sensitive) || '|' || fenperc(r_ite.default_value) || '|' || fenperc(r_ite.spaces_allowed) || '|' || fenperc(r_ite.presentation) || ';');
				p_level := p_level + 1;
				CALL report_val (p_line_num, p_level, r_ite);
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-INFORMATION_TYPE_ELEMENT:' || r_ite.sequence || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_itp (p_line_num NUMERIC, p_level NUMERIC) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_itp itp.t_information_type;
		BEGIN
			FOR r_itp IN
				SELECT *				
				FROM itp.t_information_type
				ORDER BY name
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+INFORMATION_TYPE[' || r_itp.cube_id || ']:' || fenperc(r_itp.name) || ';');
				p_level := p_level + 1;
				CALL report_ite (p_line_num, p_level, r_itp);
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-INFORMATION_TYPE:' || r_itp.name || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_tsp (p_line_num NUMERIC, p_level NUMERIC, p_tsg IN bot.t_type_specialisation_group) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_tsp bot.t_type_specialisation;
		BEGIN
			FOR r_tsp IN
				SELECT *				
				FROM bot.t_type_specialisation
				WHERE fk_bot_name = p_tsg.fk_bot_name
				AND fk_typ_name = p_tsg.fk_typ_name
				AND fk_tsg_code = p_tsg.code
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+TYPE_SPECIALISATION[' || r_tsp.cube_id || ']:' || fenperc(r_tsp.code) || '|' || fenperc(r_tsp.name) || ';');
				p_level := p_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type_specialisation
					WHERE fk_typ_name = r_tsp.xf_tsp_typ_name
					AND fk_tsg_code = r_tsp.xf_tsp_tsg_code
					AND code = r_tsp.xk_tsp_code;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>TYPE_SPECIALISATION:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-TYPE_SPECIALISATION:' || r_tsp.code || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_tsg_recursive (p_line_num NUMERIC, p_level NUMERIC, p_tsg IN bot.t_type_specialisation_group) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_tsg bot.t_type_specialisation_group;
		BEGIN
			FOR r_tsg IN
				SELECT *				
				FROM bot.t_type_specialisation_group
				WHERE fk_bot_name = p_tsg.fk_bot_name
				AND fk_typ_name = p_tsg.fk_typ_name
				AND fk_tsg_code = p_tsg.code
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+TYPE_SPECIALISATION_GROUP[' || r_tsg.cube_id || ']:' || fenperc(r_tsg.code) || '|' || fenperc(r_tsg.name) || '|' || fenperc(r_tsg.primary_key) || ';');
				p_level := p_level + 1;
				CALL report_tsp (p_line_num, p_level, r_tsg);
				CALL report_tsg_recursive (p_line_num, p_level, r_tsg);
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_attribute
					WHERE fk_typ_name = r_tsg.xf_atb_typ_name
					AND name = r_tsg.xk_atb_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>ATTRIBUTE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-TYPE_SPECIALISATION_GROUP:' || r_tsg.code || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_tsg (p_line_num NUMERIC, p_level NUMERIC, p_typ IN bot.t_type) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_tsg bot.t_type_specialisation_group;
		BEGIN
			FOR r_tsg IN
				SELECT *				
				FROM bot.t_type_specialisation_group
				WHERE fk_bot_name = p_typ.fk_bot_name
				AND fk_typ_name = p_typ.name
				AND fk_tsg_code IS NULL
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+TYPE_SPECIALISATION_GROUP[' || r_tsg.cube_id || ']:' || fenperc(r_tsg.code) || '|' || fenperc(r_tsg.name) || '|' || fenperc(r_tsg.primary_key) || ';');
				p_level := p_level + 1;
				CALL report_tsp (p_line_num, p_level, r_tsg);
				CALL report_tsg_recursive (p_line_num, p_level, r_tsg);
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_attribute
					WHERE fk_typ_name = r_tsg.xf_atb_typ_name
					AND name = r_tsg.xk_atb_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>ATTRIBUTE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-TYPE_SPECIALISATION_GROUP:' || r_tsg.code || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_der (p_line_num NUMERIC, p_level NUMERIC, p_atb IN bot.t_attribute) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_der bot.t_derivation;
		BEGIN
			FOR r_der IN
				SELECT *				
				FROM bot.t_derivation
				WHERE fk_bot_name = p_atb.fk_bot_name
				AND fk_typ_name = p_atb.fk_typ_name
				AND fk_atb_name = p_atb.name
				ORDER BY cube_id
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+DERIVATION[' || r_der.cube_id || ']:' || fenperc(r_der.cube_tsg_type) || '|' || fenperc(r_der.aggregate_function) || ';');
				p_level := p_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type
					WHERE name = r_der.xk_typ_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>DERIVATION_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type
					WHERE name = r_der.xk_typ_name_1;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>DERIVATION_TYPE_CONCERNS_CHILD:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-DERIVATION:' || r_der.cube_tsg_type || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_dca (p_line_num NUMERIC, p_level NUMERIC, p_atb IN bot.t_attribute) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_dca bot.t_description_attribute;
		BEGIN
			FOR r_dca IN
				SELECT *				
				FROM bot.t_description_attribute
				WHERE fk_bot_name = p_atb.fk_bot_name
				AND fk_typ_name = p_atb.fk_typ_name
				AND fk_atb_name = p_atb.name
				ORDER BY cube_id
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '=DESCRIPTION_ATTRIBUTE[' || r_dca.cube_id || ']:' || fenperc(r_dca.text) || ';');
				p_level := p_level + 1;
				p_level := p_level - 1;
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_rta (p_line_num NUMERIC, p_level NUMERIC, p_atb IN bot.t_attribute) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_rta bot.t_restriction_type_spec_atb;
		BEGIN
			FOR r_rta IN
				SELECT *				
				FROM bot.t_restriction_type_spec_atb
				WHERE fk_bot_name = p_atb.fk_bot_name
				AND fk_typ_name = p_atb.fk_typ_name
				AND fk_atb_name = p_atb.name
				ORDER BY fk_typ_name, fk_atb_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+RESTRICTION_TYPE_SPEC_ATB[' || r_rta.cube_id || ']:' || fenperc(r_rta.include_or_exclude) || ';');
				p_level := p_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type_specialisation
					WHERE fk_typ_name = r_rta.xf_tsp_typ_name
					AND fk_tsg_code = r_rta.xf_tsp_tsg_code
					AND code = r_rta.xk_tsp_code;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>TYPE_SPECIALISATION:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-RESTRICTION_TYPE_SPEC_ATB:' || r_rta.include_or_exclude || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_atb (p_line_num NUMERIC, p_level NUMERIC, p_typ IN bot.t_type) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_atb bot.t_attribute;
		BEGIN
			FOR r_atb IN
				SELECT *				
				FROM bot.t_attribute
				WHERE fk_bot_name = p_typ.fk_bot_name
				AND fk_typ_name = p_typ.name
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+ATTRIBUTE[' || r_atb.cube_id || ']:' || fenperc(r_atb.name) || '|' || fenperc(r_atb.primary_key) || '|' || fenperc(r_atb.code_display_key) || '|' || fenperc(r_atb.code_foreign_key) || '|' || fenperc(r_atb.flag_hidden) || '|' || fenperc(r_atb.default_value) || '|' || fenperc(r_atb.unchangeable) || ';');
				p_level := p_level + 1;
				CALL report_der (p_line_num, p_level, r_atb);
				CALL report_dca (p_line_num, p_level, r_atb);
				CALL report_rta (p_line_num, p_level, r_atb);
				BEGIN
					SELECT cube_id INTO l_cube_id FROM itp.t_information_type
					WHERE name = r_atb.xk_itp_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>INFORMATION_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-ATTRIBUTE:' || r_atb.name || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_dcr (p_line_num NUMERIC, p_level NUMERIC, p_ref IN bot.t_reference) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_dcr bot.t_description_reference;
		BEGIN
			FOR r_dcr IN
				SELECT *				
				FROM bot.t_description_reference
				WHERE fk_bot_name = p_ref.fk_bot_name
				AND fk_typ_name = p_ref.fk_typ_name
				AND fk_ref_sequence = p_ref.sequence
				AND fk_ref_bot_name = p_ref.xk_bot_name
				AND fk_ref_typ_name = p_ref.xk_typ_name
				ORDER BY cube_id
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '=DESCRIPTION_REFERENCE[' || r_dcr.cube_id || ']:' || fenperc(r_dcr.text) || ';');
				p_level := p_level + 1;
				p_level := p_level - 1;
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_rtr (p_line_num NUMERIC, p_level NUMERIC, p_ref IN bot.t_reference) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_rtr bot.t_restriction_type_spec_ref;
		BEGIN
			FOR r_rtr IN
				SELECT *				
				FROM bot.t_restriction_type_spec_ref
				WHERE fk_bot_name = p_ref.fk_bot_name
				AND fk_typ_name = p_ref.fk_typ_name
				AND fk_ref_sequence = p_ref.sequence
				AND fk_ref_bot_name = p_ref.xk_bot_name
				AND fk_ref_typ_name = p_ref.xk_typ_name
				ORDER BY fk_typ_name, fk_ref_sequence, fk_ref_bot_name, fk_ref_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+RESTRICTION_TYPE_SPEC_REF[' || r_rtr.cube_id || ']:' || fenperc(r_rtr.include_or_exclude) || ';');
				p_level := p_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type_specialisation
					WHERE fk_typ_name = r_rtr.xf_tsp_typ_name
					AND fk_tsg_code = r_rtr.xf_tsp_tsg_code
					AND code = r_rtr.xk_tsp_code;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>TYPE_SPECIALISATION:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-RESTRICTION_TYPE_SPEC_REF:' || r_rtr.include_or_exclude || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_rts (p_line_num NUMERIC, p_level NUMERIC, p_ref IN bot.t_reference) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_rts bot.t_restriction_target_type_spec;
		BEGIN
			FOR r_rts IN
				SELECT *				
				FROM bot.t_restriction_target_type_spec
				WHERE fk_bot_name = p_ref.fk_bot_name
				AND fk_typ_name = p_ref.fk_typ_name
				AND fk_ref_sequence = p_ref.sequence
				AND fk_ref_bot_name = p_ref.xk_bot_name
				AND fk_ref_typ_name = p_ref.xk_typ_name
				ORDER BY cube_id
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+RESTRICTION_TARGET_TYPE_SPEC[' || r_rts.cube_id || ']:' || fenperc(r_rts.include_or_exclude) || ';');
				p_level := p_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type_specialisation
					WHERE fk_typ_name = r_rts.xf_tsp_typ_name
					AND fk_tsg_code = r_rts.xf_tsp_tsg_code
					AND code = r_rts.xk_tsp_code;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>TYPE_SPECIALISATION:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-RESTRICTION_TARGET_TYPE_SPEC:' || r_rts.include_or_exclude || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_ref (p_line_num NUMERIC, p_level NUMERIC, p_typ IN bot.t_type) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_ref bot.t_reference;
		BEGIN
			FOR r_ref IN
				SELECT *				
				FROM bot.t_reference
				WHERE fk_bot_name = p_typ.fk_bot_name
				AND fk_typ_name = p_typ.name
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+REFERENCE[' || r_ref.cube_id || ']:' || fenperc(r_ref.name) || '|' || fenperc(r_ref.primary_key) || '|' || fenperc(r_ref.code_display_key) || '|' || r_ref.sequence || '|' || fenperc(r_ref.scope) || '|' || fenperc(r_ref.unchangeable) || '|' || fenperc(r_ref.within_scope_extension) || '|' || fenperc(r_ref.cube_tsg_int_ext) || ';');
				p_level := p_level + 1;
				CALL report_dcr (p_line_num, p_level, r_ref);
				CALL report_rtr (p_line_num, p_level, r_ref);
				CALL report_rts (p_line_num, p_level, r_ref);
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_business_object_type
					WHERE name = r_ref.xk_bot_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>BUSINESS_OBJECT_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type
					WHERE name = r_ref.xk_typ_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>REFERENCE_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type
					WHERE name = r_ref.xk_typ_name_1;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>REFERENCE_TYPE_WITHIN_SCOPE_OF:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-REFERENCE:' || r_ref.name || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_rtt (p_line_num NUMERIC, p_level NUMERIC, p_typ IN bot.t_type) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_rtt bot.t_restriction_type_spec_typ;
		BEGIN
			FOR r_rtt IN
				SELECT *				
				FROM bot.t_restriction_type_spec_typ
				WHERE fk_bot_name = p_typ.fk_bot_name
				AND fk_typ_name = p_typ.name
				ORDER BY fk_typ_name, xf_tsp_typ_name, xf_tsp_tsg_code, xk_tsp_code
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+RESTRICTION_TYPE_SPEC_TYP[' || r_rtt.cube_id || ']:' || fenperc(r_rtt.include_or_exclude) || ';');
				p_level := p_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type_specialisation
					WHERE fk_typ_name = r_rtt.xf_tsp_typ_name
					AND fk_tsg_code = r_rtt.xf_tsp_tsg_code
					AND code = r_rtt.xk_tsp_code;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>TYPE_SPECIALISATION:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-RESTRICTION_TYPE_SPEC_TYP:' || r_rtt.include_or_exclude || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_jsn_recursive (p_line_num NUMERIC, p_level NUMERIC, p_jsn IN bot.t_json_path) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_jsn bot.t_json_path;
		BEGIN
			FOR r_jsn IN
				SELECT *				
				FROM bot.t_json_path
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
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+JSON_PATH[' || r_jsn.cube_id || ']:' || fenperc(r_jsn.cube_tsg_obj_arr) || '|' || fenperc(r_jsn.cube_tsg_type) || '|' || fenperc(r_jsn.name) || '|' || r_jsn.location || ';');
				p_level := p_level + 1;
				CALL report_jsn_recursive (p_line_num, p_level, r_jsn);
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_attribute
					WHERE fk_typ_name = r_jsn.xf_atb_typ_name
					AND name = r_jsn.xk_atb_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>ATTRIBUTE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type
					WHERE name = r_jsn.xk_typ_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>JSON_PATH_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-JSON_PATH:' || r_jsn.cube_tsg_obj_arr || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_jsn (p_line_num NUMERIC, p_level NUMERIC, p_typ IN bot.t_type) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_jsn bot.t_json_path;
		BEGIN
			FOR r_jsn IN
				SELECT *				
				FROM bot.t_json_path
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
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+JSON_PATH[' || r_jsn.cube_id || ']:' || fenperc(r_jsn.cube_tsg_obj_arr) || '|' || fenperc(r_jsn.cube_tsg_type) || '|' || fenperc(r_jsn.name) || '|' || r_jsn.location || ';');
				p_level := p_level + 1;
				CALL report_jsn_recursive (p_line_num, p_level, r_jsn);
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_attribute
					WHERE fk_typ_name = r_jsn.xf_atb_typ_name
					AND name = r_jsn.xk_atb_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>ATTRIBUTE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_type
					WHERE name = r_jsn.xk_typ_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>JSON_PATH_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-JSON_PATH:' || r_jsn.cube_tsg_obj_arr || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_dct (p_line_num NUMERIC, p_level NUMERIC, p_typ IN bot.t_type) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_dct bot.t_description_type;
		BEGIN
			FOR r_dct IN
				SELECT *				
				FROM bot.t_description_type
				WHERE fk_bot_name = p_typ.fk_bot_name
				AND fk_typ_name = p_typ.name
				ORDER BY cube_id
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '=DESCRIPTION_TYPE[' || r_dct.cube_id || ']:' || fenperc(r_dct.text) || ';');
				p_level := p_level + 1;
				p_level := p_level - 1;
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_typ_recursive (p_line_num NUMERIC, p_level NUMERIC, p_typ IN bot.t_type) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_typ bot.t_type;
		BEGIN
			FOR r_typ IN
				SELECT *				
				FROM bot.t_type
				WHERE fk_bot_name = p_typ.fk_bot_name
				AND fk_typ_name = p_typ.name
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+TYPE[' || r_typ.cube_id || ']:' || fenperc(r_typ.name) || '|' || fenperc(r_typ.code) || '|' || fenperc(r_typ.flag_partial_key) || '|' || fenperc(r_typ.flag_recursive) || '|' || fenperc(r_typ.recursive_cardinality) || '|' || fenperc(r_typ.cardinality) || '|' || fenperc(r_typ.sort_order) || '|' || fenperc(r_typ.icon) || '|' || fenperc(r_typ.transferable) || ';');
				p_level := p_level + 1;
				CALL report_tsg (p_line_num, p_level, r_typ);
				CALL report_atb (p_line_num, p_level, r_typ);
				CALL report_ref (p_line_num, p_level, r_typ);
				CALL report_rtt (p_line_num, p_level, r_typ);
				CALL report_jsn (p_line_num, p_level, r_typ);
				CALL report_dct (p_line_num, p_level, r_typ);
				CALL report_typ_recursive (p_line_num, p_level, r_typ);
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-TYPE:' || r_typ.name || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_typ (p_line_num NUMERIC, p_level NUMERIC, p_bot IN bot.t_business_object_type) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_typ bot.t_type;
		BEGIN
			FOR r_typ IN
				SELECT *				
				FROM bot.t_type
				WHERE fk_bot_name = p_bot.name
				AND fk_typ_name IS NULL
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+TYPE[' || r_typ.cube_id || ']:' || fenperc(r_typ.name) || '|' || fenperc(r_typ.code) || '|' || fenperc(r_typ.flag_partial_key) || '|' || fenperc(r_typ.flag_recursive) || '|' || fenperc(r_typ.recursive_cardinality) || '|' || fenperc(r_typ.cardinality) || '|' || fenperc(r_typ.sort_order) || '|' || fenperc(r_typ.icon) || '|' || fenperc(r_typ.transferable) || ';');
				p_level := p_level + 1;
				CALL report_tsg (p_line_num, p_level, r_typ);
				CALL report_atb (p_line_num, p_level, r_typ);
				CALL report_ref (p_line_num, p_level, r_typ);
				CALL report_rtt (p_line_num, p_level, r_typ);
				CALL report_jsn (p_line_num, p_level, r_typ);
				CALL report_dct (p_line_num, p_level, r_typ);
				CALL report_typ_recursive (p_line_num, p_level, r_typ);
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-TYPE:' || r_typ.name || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_bot (p_line_num NUMERIC, p_level NUMERIC) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_bot bot.t_business_object_type;
		BEGIN
			FOR r_bot IN
				SELECT *				
				FROM bot.t_business_object_type
				WHERE (:system = 'ALL' OR name in (SELECT xk_bot_name FROM sys.t_system_bo_type WHERE fk_sys_name = :system ))
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+BUSINESS_OBJECT_TYPE[' || r_bot.cube_id || ']:' || fenperc(r_bot.name) || '|' || fenperc(r_bot.cube_tsg_type) || '|' || fenperc(r_bot.directory) || '|' || fenperc(r_bot.api_url) || ';');
				p_level := p_level + 1;
				CALL report_typ (p_line_num, p_level, r_bot);
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-BUSINESS_OBJECT_TYPE:' || r_bot.name || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_sbt (p_line_num NUMERIC, p_level NUMERIC, p_sys IN sys.t_system) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_sbt sys.t_system_bo_type;
		BEGIN
			FOR r_sbt IN
				SELECT *				
				FROM sys.t_system_bo_type
				WHERE fk_sys_name = p_sys.name
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+SYSTEM_BO_TYPE[' || r_sbt.cube_id || ']:' || ';');
				p_level := p_level + 1;
				BEGIN
					SELECT cube_id INTO l_cube_id FROM bot.t_business_object_type
					WHERE name = r_sbt.xk_bot_name;
					p_line_num := p_line_num + 1;
					INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '>BUSINESS_OBJECT_TYPE:' || l_cube_id || ';');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL; 
				END;
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-SYSTEM_BO_TYPE:' || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_sys (p_line_num NUMERIC, p_level NUMERIC) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_sys sys.t_system;
		BEGIN
			FOR r_sys IN
				SELECT *				
				FROM sys.t_system
				WHERE :system = 'ALL' OR name = :system'
				ORDER BY name
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+SYSTEM[' || r_sys.cube_id || ']:' || fenperc(r_sys.name) || '|' || fenperc(r_sys.cube_tsg_type) || '|' || fenperc(r_sys.database) || '|' || fenperc(r_sys.schema) || '|' || fenperc(r_sys.password) || '|' || fenperc(r_sys.table_prefix) || ';');
				p_level := p_level + 1;
				CALL report_sbt (p_line_num, p_level, r_sys);
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-SYSTEM:' || r_sys.name || ';');
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_arg (p_line_num NUMERIC, p_level NUMERIC, p_fun IN fun.t_function) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_arg fun.t_argument;
		BEGIN
			FOR r_arg IN
				SELECT *				
				FROM fun.t_argument
				WHERE fk_fun_name = p_fun.name
				ORDER BY cube_sequence
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '=ARGUMENT[' || r_arg.cube_id || ']:' || fenperc(r_arg.name) || ';');
				p_level := p_level + 1;
				p_level := p_level - 1;
			END LOOP;
		END; 
		$$;

		CREATE OR REPLACE PROCEDURE report_fun (p_line_num NUMERIC, p_level NUMERIC) LANGUAGE plpgsql AS $$
		DECLARE
			l_cube_id VARCHAR(16);
			r_fun fun.t_function;
		BEGIN
			FOR r_fun IN
				SELECT *				
				FROM fun.t_function
				ORDER BY cube_id
			LOOP
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '+FUNCTION[' || r_fun.cube_id || ']:' || fenperc(r_fun.name) || ';');
				p_level := p_level + 1;
				CALL report_arg (p_line_num, p_level, r_fun);
				p_level := p_level - 1;
				p_line_num := p_line_num + 1;
				INSERT INTO cube.line VALUES(p_line_num, ftabs(p_level) || '-FUNCTION:' || r_fun.name || ';');
			END LOOP;
		END; 
		$$;

		CALL report_itp (g_line_num, g_level);
		CALL report_bot (g_line_num, g_level);
		CALL report_sys (g_line_num, g_level);
		CALL report_fun (g_line_num, g_level);
	END;
$BODY$;

SELECT str FROM cube.line ORDER BY num;
\o