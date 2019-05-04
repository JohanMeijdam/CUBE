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
	VALUES ( 'DCT-000000100020','PROD','_',-1,UTL_URL.UNESCAPE('Hoofd%20product'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'DCT-000000100021','PROD2','_',-1,UTL_URL.UNESCAPE('Sub%20product'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'DCT-000000100022','PART2','_',-1,UTL_URL.UNESCAPE('Sub%20product%20part'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'DCT-000000100023','PART','_',-1,UTL_URL.UNESCAPE('Product%20part'));
EXIT;