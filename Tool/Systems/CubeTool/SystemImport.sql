----------------------------------------------------------
-- CubeTool System Import DML
----------------------------------------------------------
--
-- Delete All
--
--
-- Insert Descriptions
--
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100040','INFORMATION_TYPE_ELEMENT','PRESENTATION',-1,UTL_URL.UNESCAPE('Indication%20how%20the%20string%20is%20presented%20in%20the%20user%20dialog.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100020','BUSINESS_OBJECT_TYPE','_',-1,UTL_URL.UNESCAPE('An%20object%20type%20related%20to%20the%20business%20supported%20by%20the%20system.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100041','BUSINESS_OBJECT_TYPE','API_URL',-1,UTL_URL.UNESCAPE('The%20basic%20URL%20for%20calling%20the%20API.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100021','TYPE','_',-1,UTL_URL.UNESCAPE('An%20entity%20type%20related%20to%20the%20business%20that%20is%20supported%20by%20the%20system.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100042','TYPE','TRANSFERABLE',-1,UTL_URL.UNESCAPE('Indication%20that%20in%20case%20of%20a%20recursive%20type%20the%20type%20may%20moved%20to%20an%20other%20parent%20in%20the%20hierarchy.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100022','TYPE_SPECIALISATION_GROUP','_',-1,UTL_URL.UNESCAPE('A%20group%20of%20classifications%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100043','TYPE_SPECIALISATION_GROUP','PRIMARY_KEY',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20type%20specification%20group%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCR-0100020','TYPE_SPECIALISATION_GROUP','ATTRIBUTE',0,UTL_URL.UNESCAPE('Defines%20the%20location%20of%20the%20classifying%20attribute%20within%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100023','TYPE_SPECIALISATION','_',-1,UTL_URL.UNESCAPE('A%20classification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100044','ATTRIBUTE','NAME',-1,UTL_URL.UNESCAPE('Unique%20identifier%20of%20the%20attribute.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100045','ATTRIBUTE','PRIMARY_KEY',-1,UTL_URL.UNESCAPE('Indication%20that%20attribute%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100046','ATTRIBUTE','DEFAULT_VALUE',-1,UTL_URL.UNESCAPE('Defaut%20value%20that%20overules%20the%20default%20value%20specified%20by%20the%20information%20type%20element.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100047','ATTRIBUTE','UNCHANGEABLE',-1,UTL_URL.UNESCAPE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20value%20of%20the%20atrribute%20can%20not%20be%20changed.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100048','RESTRICTION_TYPE_SPEC_ATB','INCLUDE_OR_EXCLUDE',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20attribute%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100049','REFERENCE','PRIMARY_KEY',-1,UTL_URL.UNESCAPE('Indication%20that%20reference%20is%20part%20of%20the%20unique%20identification%20of%20the%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100050','REFERENCE','SCOPE',-1,UTL_URL.UNESCAPE('In%20case%20of%20a%20recursive%20target%2C%20the%20definition%20of%20the%20collection%20of%20the%20types%20to%20select.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100051','REFERENCE','UNCHANGEABLE',-1,UTL_URL.UNESCAPE('Indication%20that%20after%20the%20creation%20of%20the%20type%20the%20reference%20can%20not%20be%20changed.%20So%20in%20case%20of%20a%20recursive%20reference%20the%20indication%20too%20that%20the%20relation%20is%20used%20to%20select%20the%20parents%20or%20children%20in%20the%20hierarchy.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100052','REFERENCE','TYPE_PREFIX',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20technical%20(model)%20name%20is%20prefixed%20with%20the%20name%20of%20the%20parent%20type.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100053','RESTRICTION_TYPE_SPEC_REF','INCLUDE_OR_EXCLUDE',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20reference%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100054','RESTRICTION_TYPE_SPEC_TYP','INCLUDE_OR_EXCLUDE',-1,UTL_URL.UNESCAPE('Indication%20that%20the%20child%20type%20is%20valid%20(included)%20or%20invalid%20(excluded)%20for%20the%20concerning%20type%20specialisation.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100055','JSON_PATH','NAME',-1,UTL_URL.UNESCAPE('The%20tag%20of%20the%20object.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100056','JSON_PATH','LOCATION',-1,UTL_URL.UNESCAPE('The%20index%20of%20the%20array.%20The%20first%20item%20is%200.'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCT-0100024','DESCRIPTION_TYPE','_',-1,UTL_URL.UNESCAPE('Test%0D%0AMet%20LF%20en%20%22%20en%20%27%20%20en%20%25%20%20%20%20%25%0D%0AEInde'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'CUBE-DCA-0100057','SYSTEM','DATABASE',-1,UTL_URL.UNESCAPE('The%20name%20of%20the%20database%20where%20the%20tables%20of%20the%20system%20will%20be%20implemented.'));
EXIT;