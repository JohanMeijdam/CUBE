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
	VALUES ( 'CUBE-DCT-0100000','BUSINESS_OBJECT_TYPE','_',-1,UTL_URL.UNESCAPE('An%20object%20type%20related%20to%20the%20business%20supported%20by%20the%20system.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100001','TYPE','_',-1,UTL_URL.UNESCAPE('An%20entity%20type%20related%20to%20the%20business%20that%20is%20supported%20by%20the%20system.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100000','TYPE','TRANSFERABLE',-1,UTL_URL.UNESCAPE('Indication%20that%20in%20case%20of%20a%20recursive%20type%20the%20type%20may%20moved%20to%20an%20other%20parent%20in%20the%20hierarchy.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100001','ATTRIBUTE','NAME',-1,UTL_URL.UNESCAPE('Unique%20identifier%20of%20the%20attribute.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100002','ATTRIBUTE','PRIMARY_KEY',-1,UTL_URL.UNESCAPE('Indication%20that%20attribute%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100003','ATTRIBUTE','DEFAULT_VALUE',-1,UTL_URL.UNESCAPE('Defaut%20value%20that%20overules%20the%20default%20value%20specified%20by%20the%20information%20type%20element.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100004','ATTRIBUTE','UNCHANGEABLE',-1,UTL_URL.UNESCAPE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20value%20of%20the%20atrribute%20can%20not%20be%20changed.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100005','RESTRICTION_TYPE_SPEC_ATB','INCLUDE_OR_EXCLUDE',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20attribute%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100006','REFERENCE','PRIMARY_KEY',-1,UTL_URL.UNESCAPE('Indication%20that%20reference%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100007','REFERENCE','SCOPE',-1,UTL_URL.UNESCAPE('In%20case%20of%20a%20recursive%20target%2C%20the%20definition%20of%20the%20collection%20of%20the%20types%20to%20select.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100008','REFERENCE','UNCHANGEABLE',-1,UTL_URL.UNESCAPE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20reference%20can%20not%20be%20changed.%20So%20in%20case%20of%20a%20recursive%20reference%20the%20indication%20too%20that%20the%20relation%20is%20used%20to%20select%20the%20parents%20or%20children%20in%20the%20hierarchy.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100009','REFERENCE','WITHIN_SCOPE_LEVEL',-1,UTL_URL.UNESCAPE('In%20case%20of%20recursive%20%22wihin%20scope%20of%22%20type%20the%20relative%20level%20in%20the%20hierarchy%2C%20Positive%20numbers%20are%20the%20parent%20levels%2C%20Negative%20numbers%20are%20the%20child%20levels.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCR-0100000','REFERENCE','TYPE',0,UTL_URL.UNESCAPE('The%20target%20entity%20type%20of%20the%20reference.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCR-0100001','REFERENCE','TYPE',1,UTL_URL.UNESCAPE('In%20case%20of%20non%20recursive%20target%20or%20a%20scope%20all%20recursive%20target%20the%20common%20type%20for%20the%20selection.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100010','RESTRICTION_TYPE_SPEC_REF','INCLUDE_OR_EXCLUDE',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20reference%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100011','TYPE_SPECIALISATION_GROUP','PRIMARY_KEY',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20type%20specification%20group%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100002','DESCRIPTION_TYPE','_',-1,UTL_URL.UNESCAPE('Test%0D%0AMet%20LF%20en%20%22%20en%20%27%20%20en%20%25%20%20%20%20%25%0D%0AEInde'));
EXIT;