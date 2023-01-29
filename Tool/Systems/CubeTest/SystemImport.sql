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
	VALUES ( 'DCT-000000100000','PRODUKT','_',-1,UTL_URL.UNESCAPE('Dit%20is%20een%20produkt'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'DCA-000000100000','PRODUKT','CODE',-1,UTL_URL.UNESCAPE('De%20code%20voor%20een%20produkt'));
INSERT INTO v_cube_description (CUBE_ID, TYPE_NAME, ATTRIBUTE_TYPE_NAME, SEQUENCE, VALUE)
	VALUES ( 'DCT-000000100001','ONDERDEEL','_',-1,UTL_URL.UNESCAPE('Onderdeel%20van%20een%20produkt'));
EXIT;