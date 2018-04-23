----------------------------------------------------------
-- CubeTool System Import DML
----------------------------------------------------------
--
-- Delete All
--
DELETE v_cube_description;
--
-- Insert Descriptions
--
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100000','INFORMATION_TYPE_ELEMENT','PRESENTATION',-1,UTL_URL.UNESCAPE('Indication%20how%20the%20string%20is%20presented%20in%20the%20user%20dialog.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100000','BUSINESS_OBJECT_TYPE','_',-1,UTL_URL.UNESCAPE('An%20object%20type%20related%20to%20the%20business%20supported%20by%20the%20system.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100001','TYPE','_',-1,UTL_URL.UNESCAPE('An%20entity%20type%20related%20to%20the%20business%20that%20is%20supported%20by%20the%20system.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100001','TYPE','TRANSFERABLE',-1,UTL_URL.UNESCAPE('Indication%20that%20in%20case%20of%20a%20recursive%20type%20the%20type%20may%20moved%20to%20an%20other%20parent%20in%20the%20hierarchy.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100002','ATTRIBUTE','NAME',-1,UTL_URL.UNESCAPE('Unique%20identifier%20of%20the%20attribute.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100003','ATTRIBUTE','PRIMARY_KEY',-1,UTL_URL.UNESCAPE('Indication%20that%20attribute%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100004','ATTRIBUTE','DEFAULT_VALUE',-1,UTL_URL.UNESCAPE('Defaut%20value%20that%20overules%20the%20default%20value%20specified%20by%20the%20information%20type%20element.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100005','ATTRIBUTE','UNCHANGEABLE',-1,UTL_URL.UNESCAPE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20value%20of%20the%20atrribute%20can%20not%20be%20changed.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100006','RESTRICTION_TYPE_SPEC_ATB','INCLUDE_OR_EXCLUDE',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20attribute%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100007','REFERENCE','PRIMARY_KEY',-1,UTL_URL.UNESCAPE('Indication%20that%20reference%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100008','REFERENCE','SCOPE',-1,UTL_URL.UNESCAPE('In%20case%20of%20a%20recursive%20target%2C%20the%20definition%20of%20the%20collection%20of%20the%20types%20to%20select.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100009','REFERENCE','UNCHANGEABLE',-1,UTL_URL.UNESCAPE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20reference%20can%20not%20be%20changed.%20So%20in%20case%20of%20a%20recursive%20reference%20the%20indication%20too%20that%20the%20relation%20is%20used%20to%20select%20the%20parents%20or%20children%20in%20the%20hierarchy.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100010','REFERENCE','WITHIN_SCOPE_LEVEL',-1,UTL_URL.UNESCAPE('In%20case%20of%20recursive%20%22wihin%20scope%20of%22%20type%20the%20relative%20level%20in%20the%20hierarchy%2C%20Positive%20numbers%20are%20the%20parent%20levels%2C%20Negative%20numbers%20are%20the%20child%20levels.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCR-0100000','REFERENCE','TYPE',0,UTL_URL.UNESCAPE('The%20target%20entity%20type%20of%20the%20reference.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCR-0100001','REFERENCE','TYPE',1,UTL_URL.UNESCAPE('In%20case%20of%20non%20recursive%20target%20or%20a%20scope%20all%20recursive%20target%20the%20common%20type%20for%20the%20selection.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100011','RESTRICTION_TYPE_SPEC_REF','INCLUDE_OR_EXCLUDE',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20reference%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100002','TYPE_SPECIALISATION_GROUP','_',-1,UTL_URL.UNESCAPE('A%20group%20of%20classifications%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100012','TYPE_SPECIALISATION_GROUP','PRIMARY_KEY',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20type%20specification%20group%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCR-0100002','TYPE_SPECIALISATION_GROUP','ATTRIBUTE',0,UTL_URL.UNESCAPE('Defines%20the%20location%20of%20the%20classifying%20attribute%20within%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100003','TYPE_SPECIALISATION','_',-1,UTL_URL.UNESCAPE('A%20classification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100004','DESCRIPTION_TYPE','_',-1,UTL_URL.UNESCAPE('Test%0D%0AMet%20LF%20en%20%22%20en%20%27%20%20en%20%25%20%20%20%20%25%0D%0AEInde'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100005','CUBE_GEN_DOCUMENTATION','_',-1,UTL_URL.UNESCAPE('A%20document%20to%20give%20an%20explanation%20of%20CubeGen%20based%20on%20examples.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100013','CUBE_GEN_DOCUMENTATION','NAME',-1,UTL_URL.UNESCAPE('The%20name%20of%20the%20document.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100014','CUBE_GEN_DOCUMENTATION','DESCRIPTION_FUNCTIONS',-1,UTL_URL.UNESCAPE('Description%20for%20Template%20Function%20chapter.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100015','CUBE_GEN_PARAGRAPH','ID',-1,UTL_URL.UNESCAPE('Technical%20identifier.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100016','CUBE_GEN_PARAGRAPH','HEADER',-1,UTL_URL.UNESCAPE('Text%20used%20as%20header%20and%20used%20in%20the%20index.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100017','CUBE_GEN_PARAGRAPH','EXAMPLE',-1,UTL_URL.UNESCAPE('An%20example%20to%20explain%20the%20paragraph.%20No%20example%20is%20indicated%20by%20a%20%27%23%27.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100006','CUBE_GEN_EXAMPLE_MODEL','_',-1,UTL_URL.UNESCAPE('A%20view%20on%20the%20business%20object%20model%20with%20examples%20of%20functions%20based%20on%20the%20business%20object%20model.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100018','CUBE_GEN_EXAMPLE_MODEL','ID',-1,UTL_URL.UNESCAPE('Technical%20identifier.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100019','CUBE_GEN_EXAMPLE_MODEL','HEADER',-1,UTL_URL.UNESCAPE('Text%20used%20as%20header%20and%20used%20in%20the%20index.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100020','CUBE_GEN_EXAMPLE_MODEL','INCLUDED_OBJECT_NAMES',-1,UTL_URL.UNESCAPE('The%20names%20of%20types%20that%20are%20included%20in%20the%20view%20of%20the%20business%20object%20model.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100007','CUBE_GEN_EXAMPLE_OBJECT','_',-1,UTL_URL.UNESCAPE('A%20reference%20to%20a%20business%20object%20that%20is%20used%20in%20the%20examples.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100008','CUBE_GEN_FUNCTION','_',-1,UTL_URL.UNESCAPE('A%20CubeGen%20function%20that%20has%20been%20explained%20with%20a%20template.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100021','CUBE_GEN_FUNCTION','ID',-1,UTL_URL.UNESCAPE('Technical%20identifier.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100022','CUBE_GEN_FUNCTION','HEADER',-1,UTL_URL.UNESCAPE('Text%20used%20as%20header%20and%20used%20in%20the%20index.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100023','CUBE_GEN_FUNCTION','TEMPLATE',-1,UTL_URL.UNESCAPE('CubeGen%20template%20used%20as%20example.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100024','CUBE_GEN_TEMPLATE_FUNCTION','INDICATION_LOGICAL',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20function%20is%20a%20locical%20expression%20used%20in%20a%20condition.'));
EXIT;