----------------------------------------------------------
-- CubeTool Model Import DML
--
-- Model: Systems\CubeDocu\CubeToolModel.cgm
----------------------------------------------------------
--
-- Delete All
--
DELETE v_information_type;
DELETE v_information_type_element;
DELETE v_permitted_value;
DELETE v_business_object_type;
DELETE v_type;
DELETE v_attribute;
DELETE v_derivation;
DELETE v_description_attribute;
DELETE v_restriction_type_spec_atb;
DELETE v_reference;
DELETE v_description_reference;
DELETE v_restriction_type_spec_ref;
DELETE v_type_reuse;
DELETE v_partition;
DELETE v_subtype;
DELETE v_type_specialisation_group;
DELETE v_type_specialisation;
DELETE v_description_type;
DELETE v_system;
DELETE v_system_bo_type;
DELETE v_cube_gen_documentation;
DELETE v_cube_gen_paragraph;
DELETE v_cube_gen_example_model;
DELETE v_cube_gen_example_object;
DELETE v_cube_gen_function;
--
-- Insert BUSINESS_OBJECT_TYPE business object types
--
INSERT INTO v_business_object_type (CUBE_SEQUENCE, NAME, DIRECTORY)
	VALUES (1, 'CUSTOMERS', 'customer_files');

INSERT INTO v_business_object_type (CUBE_SEQUENCE, NAME, DIRECTORY)
	VALUES (2, 'ORDER', 'order_directory');

INSERT INTO v_business_object_type (CUBE_SEQUENCE, NAME, DIRECTORY)
	VALUES (3, 'PRODUCT', 'product_definitions');

--
-- Insert CUBE_GEN_DOCUMENTATION business object types
--
INSERT INTO v_cube_gen_documentation (NAME)
	VALUES ('Cube_Gen_Manual');

INSERT INTO v_cube_gen_paragraph (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, DESCRIPTION)
	VALUES (1, 'Cube_Gen_Manual', 'CMDLINE', 'Command Line', 'cubegen.exe <model> <template> <code> <arguments> '||CHR(10)||'perl cubegen.pl <model> <template> <code> <arguments>'||CHR(10)||'- <model>: Imported Cube Model textfile'||CHR(10)||'- <template>: Importede CubeGen Template Textfile'||CHR(10)||'- <code>: Textfile to generate'||CHR(10)||'- <argument>: Parameters used in template');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (1, 'Cube_Gen_Manual', 'CASE1', 'First Impression', '', 'A simple example is used to give a first impression of the functionality of CubeGen.');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE1', 'CUSTOMERS');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (2, 'Cube_Gen_Manual', 'CASE1', 'ORDER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (3, 'Cube_Gen_Manual', 'CASE1', 'PRODUCT');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE1', 'LOOP1', 'Iteration', 'Walk through model elements.', 'This is a list of the Busines Object Types:[[LOOP,BUSINESS_OBJECT_TYPE]]'||CHR(10)||'-'||CHR(9)||'<<BUSINESS_OBJECT_TYPE:U>>[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (2, 'Cube_Gen_Manual', 'CASE1', 'REPL1', 'Replace', 'Replace ', '[[LOOP,BUSINESS_OBJECT_TYPE]]'||CHR(10)||'Uppercase: <<BUSINESS_OBJECT_TYPE:U>>'||CHR(10)||'Lowercase: <<BUSINESS_OBJECT_TYPE:L>>'||CHR(10)||'Number: <<BUSINESS_OBJECT_TYPE:N>>'||CHR(10)||'Subnumber: <<BUSINESS_OBJECT_TYPE:S>>'||CHR(10)||'CamelCase: <<BUSINESS_OBJECT_TYPE:C>>'||CHR(10)||'ID: <<BUSINESS_OBJECT_TYPE:I>>'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

EXIT;
