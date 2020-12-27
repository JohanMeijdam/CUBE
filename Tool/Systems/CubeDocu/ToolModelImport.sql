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
DELETE v_type_specialisation_group;
DELETE v_type_specialisation;
DELETE v_attribute;
DELETE v_derivation;
DELETE v_description_attribute;
DELETE v_restriction_type_spec_atb;
DELETE v_reference;
DELETE v_description_reference;
DELETE v_restriction_type_spec_ref;
DELETE v_restriction_target_type_spec;
DELETE v_restriction_type_spec_typ;
DELETE v_json_path;
DELETE v_description_type;
DELETE v_system;
DELETE v_system_bo_type;
--
-- Insert BUSINESS_OBJECT_TYPE business object types
--
INSERT INTO v_business_object_type (CUBE_SEQUENCE, NAME, CUBE_TSG_TYPE, DIRECTORY, API_URL)
	VALUES (1, 'CUSTOMER', 'EXT', 'customer_files', '');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'CUSTOMER', '', 'CUSTOMER', 'CUS', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (1, 'CUSTOMER', 'CUSTOMER', 'RELATION_NUMBER', 'Y', 'Y', 'N', 'N', '', 'N', '');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (2, 'CUSTOMER', 'CUSTOMER', 'NAME', 'N', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_business_object_type (CUBE_SEQUENCE, NAME, CUBE_TSG_TYPE, DIRECTORY, API_URL)
	VALUES (2, 'ORDER', 'INT', 'order_directory', '');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'ORDER', '', 'ORDER', 'ORD', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (1, 'ORDER', 'ORDER', 'NUMBER', 'N', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (2, 'ORDER', 'ORDER', 'DELIVERY_DATE', 'N', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (3, 'ORDER', 'ORDER', 'DESCRIPTION', 'N', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_reference (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, SEQUENCE, SCOPE, UNCHANGEABLE, WITHIN_SCOPE_EXTENSION, CUBE_TSG_INT_EXT, XK_BOT_NAME, XK_TYP_NAME, XK_TYP_NAME_1)
	VALUES (1, 'ORDER', 'ORDER', 'IS_PLACED_BY', 'N', 'N', 0, 'ALL', 'N', '', 'INT', '', 'CUSTOMER', '');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'ORDER', 'ORDER', 'ORDER_LINE', 'ORL', 'Y', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (1, 'ORDER', 'ORDER_LINE', 'NUMBER', 'Y', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (2, 'ORDER', 'ORDER_LINE', 'DESCRIPTION', 'N', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_reference (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, SEQUENCE, SCOPE, UNCHANGEABLE, WITHIN_SCOPE_EXTENSION, CUBE_TSG_INT_EXT, XK_BOT_NAME, XK_TYP_NAME, XK_TYP_NAME_1)
	VALUES (1, 'ORDER', 'ORDER_LINE', 'CONCERNS', 'Y', 'Y', 0, 'ALL', 'N', '', 'INT', '', 'PRODUCT', '');

INSERT INTO v_business_object_type (CUBE_SEQUENCE, NAME, CUBE_TSG_TYPE, DIRECTORY, API_URL)
	VALUES (3, 'PRODUCT', 'INT', 'product_definitions', '');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'PRODUCT', '', 'PRODUCT', 'PRD', 'Y', 'N', 'N', 'N', 'N', 'PRODUCT', 'Y');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (1, 'PRODUCT', 'PRODUCT', 'CODE', 'Y', 'Y', 'N', 'N', '', 'N', '');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'PRODUCT', 'PRODUCT', 'PRODUCT_PART_APPLICATION', 'PPA', 'Y', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (1, 'PRODUCT', 'PRODUCT_PART_APPLICATION', 'CODE', 'Y', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (2, 'PRODUCT', 'PRODUCT_PART_APPLICATION', 'COUNT', 'N', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (2, 'PRODUCT', 'PRODUCT', 'PRODUCTION_PROCES', 'PPR', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (1, 'PRODUCT', 'PRODUCTION_PROCES', 'PROCES_ID', 'Y', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'PRODUCT', 'PRODUCTION_PROCES', 'PRODUCTION_PROCES_STEP', 'PPS', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (1, 'PRODUCT', 'PRODUCTION_PROCES_STEP', 'PROCES_STEP_ID', 'Y', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_attribute (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, PRIMARY_KEY, CODE_DISPLAY_KEY, CODE_FOREIGN_KEY, FLAG_HIDDEN, DEFAULT_VALUE, UNCHANGEABLE, XK_ITP_NAME)
	VALUES (2, 'PRODUCT', 'PRODUCTION_PROCES_STEP', 'DESCRIPTION', 'N', 'N', 'N', 'N', '', 'N', '');

INSERT INTO v_business_object_type (CUBE_SEQUENCE, NAME, CUBE_TSG_TYPE, DIRECTORY, API_URL)
	VALUES (4, 'FACTORY', 'INT', 'production_locations', '');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'FACTORY', '', 'FACTORY', 'FCT', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'FACTORY', 'FACTORY', 'FACTORY_HALL', 'FCH', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_business_object_type (CUBE_SEQUENCE, NAME, CUBE_TSG_TYPE, DIRECTORY, API_URL)
	VALUES (5, 'AAA', 'INT', '<b>Bold</b><br>Normal', '');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'AAA', '', 'AAA', 'AAA', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'AAA', 'AAA', 'BBB1', 'BB1', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'AAA', 'BBB1', 'CCC11', 'C11', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'AAA', 'CCC11', 'DDD111', 'D01', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (2, 'AAA', 'BBB1', 'CCC12', 'C12', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'AAA', 'CCC12', 'DDD121', 'D11', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (2, 'AAA', 'CCC12', 'DDD122', 'D12', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (3, 'AAA', 'BBB1', 'CCC13', 'C13', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'AAA', 'CCC13', 'DDD131', 'D21', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (2, 'AAA', 'CCC13', 'DDD132', 'D22', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (3, 'AAA', 'CCC13', 'DDD133', 'D23', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (2, 'AAA', 'AAA', 'BBB2', 'BB2', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (1, 'AAA', 'BBB2', 'CCC21', 'C21', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (2, 'AAA', 'BBB2', 'CCC22', 'C22', 'N', 'N', 'N', 'N', 'N', '', 'Y');

INSERT INTO v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)
	VALUES (3, 'AAA', 'BBB2', 'CCC23', 'C2', 'N', 'N', 'N', 'N', 'N', '', 'Y');

--
-- Insert CUBE_GEN_DOCUMENTATION business object types
--
INSERT INTO v_cube_gen_documentation (NAME, DESCRIPTION, DESCRIPTION_FUNCTIONS, DESCRIPTION_LOGICAL_EXPRESSION)
	VALUES ('Cube_Gen_Manual', 'CubeGen is essentially a copy with replace function. The input consists of two text files: the model file and the template file. The model file contains the parameters for replacing the labels that have been applied in the template file. The template file contains the source code provided with labels.'||CHR(10)||'The special thing about CubeGen is that the parameters have a hierarchical structure, which you can easily run through recursively.', 'Functions that are applied In the templates to navigate through the hierarchy of the model elements and then export the selected template segments. In addition to navigation functions, there are functions for replacing the labels in the texts to be exported.', 'The logical functions are the elements of the logical expressions.');

INSERT INTO v_cube_gen_paragraph (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, DESCRIPTION, EXAMPLE)
	VALUES (1, 'Cube_Gen_Manual', 'CMDLINE', 'Command Line', 'The program can be run from the command line as a executable or as a Perl script.', 'cubegen.exe <model> <template> <code> <arguments> '||CHR(10)||'perl cubegen.pl <model> <template> <code> <arguments>'||CHR(10)||'-'||CHR(9)||'<model>: Imported Cube Model textfile'||CHR(10)||'-'||CHR(9)||'<template>: Imported CubeGen Template Textfile'||CHR(10)||'-'||CHR(9)||'<code>: Textfile to generate'||CHR(10)||'-'||CHR(9)||'<parameters>: Arguments that can be referenced in the template');

INSERT INTO v_cube_gen_paragraph (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, DESCRIPTION, EXAMPLE)
	VALUES (2, 'Cube_Gen_Manual', 'MDLSTRUC', 'Cube Model Structure', 'A Cube model is a hierachical structure of model elements.  An element can be a group of other elements. A group starts with a "+" followed by a tag and ends with "-" followed by the tag. In the case of a separate element the two lines can be merged into one line starting with a "=". A model element can have an idenfier specified between brackets.'||CHR(10)||'The structure can best be explained by an example:', '+<tagA>[<identA]:<prop0>|<prop1>|...|propN;'||CHR(10)||''||CHR(9)||'=<tagB>[<identB]:<prop0>|<prop1>|...|propN;'||CHR(10)||''||CHR(9)||'+<tagC>[<identC]:<prop0>|<prop1>|...|propN;'||CHR(10)||''||CHR(9)||''||CHR(9)||'=<tagD>[<identD]:<prop0>|<prop1>|..|propN;'||CHR(10)||''||CHR(9)||'-<tagC>:;'||CHR(10)||'-<tagA>:;');

INSERT INTO v_cube_gen_paragraph (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, DESCRIPTION, EXAMPLE)
	VALUES (3, 'Cube_Gen_Manual', 'RGUIDE', 'Reading Guide', 'In the first part the functions are explained with examples. The input and output of CubeGen have a background color that match the arrows in the above logo. When the content of a Model or Template is changed, the concernded Code is regenerated by pressing the CubeGen button.'||CHR(10)||'Internet Explorer users have to take the following into account:'||CHR(10)||'-'||CHR(9)||'A new line in the Model or Template has to be added with shift-Enter.'||CHR(10)||'-'||CHR(9)||'When the code is regenerated the tab characters are presented as a single space.'||CHR(10)||'The second part contains an overview of the template functions and the logical functions.'||CHR(10)||'', '#');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (1, 'Cube_Gen_Manual', 'CASE1', 'First Impression', '', 'A simple example with a small model is used to give a first impression of the functionality of CubeGen.');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE1', 'CUSTOMER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (2, 'Cube_Gen_Manual', 'CASE1', 'ORDER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (3, 'Cube_Gen_Manual', 'CASE1', 'PRODUCT');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE1', 'LOOP1', 'Iteration Stack', 'The LOOP statement walks through the model elements for the specified type. For each nested LOOP a model element is placed on the stack.', 'This is a list of the Busines Object Types:[[LOOP,BUSINESS_OBJECT_TYPE]]'||CHR(10)||'-'||CHR(9)||'<<BUSINESS_OBJECT_TYPE:U>>[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (2, 'Cube_Gen_Manual', 'CASE1', 'SELECT1', 'Selection', 'The IF, ELSIF, ELSE structure makes a choice between texts based on conditions (logical_expressions).', 'Explain selection:[[LOOP,BUSINESS_OBJECT_TYPE]][[IF:0=CUSTOMER]]'||CHR(10)||'<<BUSINESS_OBJECT_TYPE>> concerns customers.[[ELSIF:0=ORDER]]'||CHR(10)||'<<BUSINESS_OBJECT_TYPE>> concerns no customers but orders.[[ELSE]]'||CHR(10)||'<<BUSINESS_OBJECT_TYPE>> concerns something else.[[ENDIF]][[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (3, 'Cube_Gen_Manual', 'CASE1', 'REPL1', 'Replacement', 'Replace a label with the model value. By default, a label refers to the value of the first property of the model element. A number behind the tag refers to the other properties. For example, "1" refers to the next following property, so the second one.', '[[LOOP,BUSINESS_OBJECT_TYPE]]Unchanged: <<BUSINESS_OBJECT_TYPE>>, <<BUSINESS_OBJECT_TYPE2>>'||CHR(10)||'Uppercase: <<BUSINESS_OBJECT_TYPE:U>>, <<BUSINESS_OBJECT_TYPE2:U>>'||CHR(10)||'Lowercase: <<BUSINESS_OBJECT_TYPE:L>>, <<BUSINESS_OBJECT_TYPE2:L>>'||CHR(10)||'Camelcase: <<BUSINESS_OBJECT_TYPE:L>>, <<BUSINESS_OBJECT_TYPE2:C>>'||CHR(10)||''||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (2, 'Cube_Gen_Manual', 'CASE2', 'Introduction Recursivity', 'TYPE', 'A first impression of going through a hierarchy in a recursive way.');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE2', 'PRODUCT');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE2', 'REPEAT1', 'Repeating Iteration', 'On the location of the REPEAT statement the loop has been repeated for all underlying elements of the same type.', '[[LOOP,BUSINESS_OBJECT_TYPE]]Structure of <<BUSINESS_OBJECT_TYPE:C>>:[[LOOP,TYPE]]'||CHR(10)||'-'||CHR(9)||'<<TYPE:C>>[[REPEAT:TAB]][[ENDLOOP,TYPE]]'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (2, 'Cube_Gen_Manual', 'CASE2', 'REPEAT2', 'Stack Locations', 'For each nested LOOP a model element is placed on the stack. By default, reference is made to the last model element placed on the stack. By means of a tag and location, reference can be made to every model element on the stack.'||CHR(10)||'Location "1" refers to the first model element that is placed on the stack for the relevant tag. Location "N" shows the most recent. A calculation can refer to an intermediate model element. For example, location "N-1" refers to the second to last.', '[[LOOP,BUSINESS_OBJECT_TYPE]]Structure of <<BUSINESS_OBJECT_TYPE:C>>:[[LOOP,TYPE]]'||CHR(10)||'-'||CHR(9)||'<<TYPE:C>> R=<<TYPE(1):C>>[[IF:!ROOT]] P=<<TYPE(N-1):C>> L2=<<TYPE(2):C>>[[ENDIF]][[REPEAT:TAB]][[ENDLOOP,TYPE]]'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (3, 'Cube_Gen_Manual', 'CASE10', 'Model References', 'TYPE REFERENCE', 'A model element can also have references to other model elements. These model lines start with ">" and have an alias followed by the identifier of the target model element.');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE10', 'CUSTOMER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (2, 'Cube_Gen_Manual', 'CASE10', 'ORDER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (3, 'Cube_Gen_Manual', 'CASE10', 'PRODUCT');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE10', 'LOOPREF1', 'Reference Processing', 'The LOOP statement also processes the references as they are model elements.', 'List of References:[[LOOP,BUSINESS_OBJECT_TYPE]][[LOOP,TYPE]][[LOOP,REFERENCE]][[LOOP,REFERENCE_TYPE]]'||CHR(10)||'<<TYPE:C>> <<REFERENCE:C>> <<REFERENCE_TYPE:C>>[[ENDLOOP,REFERENCE_TYPE]][[ENDLOOP,REFERENCE]][[REPEAT]][[ENDLOOP,TYPE]][[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (2, 'Cube_Gen_Manual', 'CASE10', 'LOOPPAR1', 'Parent Processing', 'With a "^" in front of the tag, the LOOP statement also processes the parents as they are chiild model elements.', 'List of References with parent:[[LOOP,BUSINESS_OBJECT_TYPE]][[LOOP,TYPE]][[LOOP,REFERENCE]][[LOOP,REFERENCE_TYPE]]'||CHR(10)||'<<TYPE:C>> <<REFERENCE:C>> <<REFERENCE_TYPE:C>> (<<REFERENCE_TYPE1:U>>)[[LOOP,^BUSINESS_OBJECT_TYPE]]'||CHR(10)||'-'||CHR(9)||'Business Object Type: <<^BUSINESS_OBJECT_TYPE:C>> (<<^BUSINESS_OBJECT_TYPE2:C>>)[[ENDLOOP,^BUSINESS_OBJECT_TYPE]][[ENDLOOP,REFERENCE_TYPE]][[ENDLOOP,REFERENCE]][[REPEAT]][[ENDLOOP,TYPE]][[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (3, 'Cube_Gen_Manual', 'CASE10', 'LOOPINV1', 'Inversion Processing', 'With a "*" in front of the tag, the LOOP statement processes the referenes in the inversed direction.', 'List of referenced types:[[LOOP,BUSINESS_OBJECT_TYPE]][[LOOP,TYPE]][[LOOP,*REFERENCE]]'||CHR(10)||'<<TYPE:C>> is referenced by [[LOOP,^TYPE]]<<^TYPE:C>>[[ENDLOOP,^TYPE]] with reference <<REFERENCE:C>>[[ENDLOOP,*REFERENCE]][[REPEAT]][[ENDLOOP,TYPE]][[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (4, 'Cube_Gen_Manual', 'CASE20', 'Logical Expressions', 'TYPE', 'Logical expressions are used in the LOOP, IF, CHILD and PARENT functions. A logical expression consists of one logical function or one or more logical operators that combine logical functions.');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE20', 'CUSTOMER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (2, 'Cube_Gen_Manual', 'CASE20', 'ORDER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (3, 'Cube_Gen_Manual', 'CASE20', 'PRODUCT');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (4, 'Cube_Gen_Manual', 'CASE20', 'FACTORY');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE20', 'LOGIC0', 'Logical Operators', 'The logical operators are acting on the results of logical expressions. The precedence order of execution is first the NOT, then the AND, and finally the OR.  ', 'Show the precedence of the logical operators:[[LOOP,BUSINESS_OBJECT_TYPE:1=EXT]]'||CHR(10)||' True OR False  AND False = [[IF:1=EXT[OR]1=INT[AND]1=INT]]True[[ELSE]]False[[ENDIF]]'||CHR(10)||'(True OR False) AND False = [[IF:(1=EXT[OR]1=INT)[AND]1=INT]]True[[ELSE]]False[[ENDIF]]'||CHR(10)||' False OR NOT True AND False  = [[IF:1=INT[OR]!1=EXT[AND]1=INT]]True[[ELSE]]False[[ENDIF]]'||CHR(10)||' False OR NOT(True AND False) = [[IF:1=INT[OR]!(1=EXT[AND]1=INT)]]True[[ELSE]]False[[ENDIF]][[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (2, 'Cube_Gen_Manual', 'CASE20', 'LOGIC3', 'Qualifier', 'A qualifier for a logical function can refer to a specific model element on the LOOP stack. This qualifier consists of a tag, possibly followed by a location on the stack. The dafault location is "N", which is a reference to the last model element placed on the stack.', '[[LOOP,BUSINESS_OBJECT_TYPE]][[LOOP,TYPE]][[IF:BUSINESS_OBJECT_TYPE.1=INT[AND]TYPE(1).2=Y]]'||CHR(10)||'<<TYPE:C>>[[ENDIF]][[IF,TYPE(1):BUSINESS_OBJECT_TYPE.1=INT[AND]2=Y]]'||CHR(10)||'<<TYPE:C>>[[ENDIF]][[REPEAT]][[ENDLOOP,TYPE]][[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (3, 'Cube_Gen_Manual', 'CASE20', 'LOGIC1', 'First and Last', 'The FIRST and LAST logical functions are referring to the first and last selected model element.', '[[LOOP,BUSINESS_OBJECT_TYPE:1=INT]][[IF:FIRST]]Internal Objects: [[ENDIF]]<<BUSINESS_OBJECT_TYPE:C>>[[IF:!LAST]], [[ELSE]];'||CHR(10)||'[[ENDIF]][[ENDLOOP,BUSINESS_OBJECT_TYPE]][[LOOP,BUSINESS_OBJECT_TYPE:1=EXT]][[IF:FIRST]]External Objects: [[ENDIF]]<<BUSINESS_OBJECT_TYPE:C>>[[IF:!LAST]], [[ELSE]];'||CHR(10)||'[[ENDIF]][[ENDLOOP,BUSINESS_OBJECT_TYPE]][[LOOP,BUSINESS_OBJECT_TYPE:1=INV]][[IF:FIRST]]Invalid Objects: [[ENDIF]]<<BUSINESS_OBJECT_TYPE:C>>[[IF:!LAST]], [[ELSE]];'||CHR(10)||'[[ENDIF]][[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (4, 'Cube_Gen_Manual', 'CASE20', 'LOGIC2', 'Parent and Child', 'The PARENT and CHILD logical functions are referring to relative locations in the hierarchy.', 'Type list:[[LOOP,BUSINESS_OBJECT_TYPE]][[LOOP,TYPE]]'||CHR(10)||'[[IF:PARENT(BUSINESS_OBJECT_TYPE:1=EXT)]]External[[ELSE]]Internal[[ENDIF]] <<TYPE:C>>[[IF:CHILD(TYPE)]]'||CHR(10)||'- has child[[ENDIF]][[REPEAT]][[ENDLOOP,TYPE]][[ENDLOOP,BUSINESS_OBJECT_TYPE]]'||CHR(10)||''||CHR(10)||'List of internal objects with a child:[[LOOP,BUSINESS_OBJECT_TYPE]][[LOOP,TYPE:PARENT(BUSINESS_OBJECT_TYPE:1=INT)[AND]CHILD(TYPE)]]'||CHR(10)||'- <<TYPE:C>>[[REPEAT]][[ENDLOOP,TYPE]][[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (5, 'Cube_Gen_Manual', 'CASE30', 'Hierarchy Navigation', 'TYPE', 'Navigate through a hierarchy of model elements of one type selected in the active LOOP functions. For a better understanding of the examples, a coding is used for the tags of model elements.');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE30', 'AAA');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE30', 'FORV1', 'Vertical navigation', 'In the hierarchy selected by LOOP functions, the FORV function navigates top down (vertical) through the model elements. The template segments for the selected model elements will be exported in the order of the loop specification. The loop specification consists of two locations separated by a ">" as arrow and specifies which model elements are run through on the stack. Location references that fall outside the range are skipped.'||CHR(10)||'With the FORV function, the "V" has been added for specifying the location. Next to the "N" referring to the last placed on the stack, the "V" refers to the model element selected in the FORV function. Also the V can be used in the expression.', 'Parents for all types (with types in between):[[LOOP,BUSINESS_OBJECT_TYPE]][[LOOP,TYPE]]'||CHR(10)||'<<TYPE>>: [[FORV:1>N-1:, ]]<<TYPE>>([[FORV:V+1>N-1:, ]]<<TYPE>>[[ENDFOR]])[[ENDFOR]][[REPEAT]][[ENDLOOP,TYPE]]'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (2, 'Cube_Gen_Manual', 'CASE30', 'FORH1', 'Horizontal Navigation', 'In the hierarchy selected by LOOP functions, the FORH function navigates on the same level (horizontal) through the model elements. The template segments for the selected model elements will be exported in the order of the loop specification. For the FORH function, the locations refer to the siblings in the hierarchy.', 'All types in the hierachy with their left and right siblings:[[LOOP,BUSINESS_OBJECT_TYPE]][[LOOP,TYPE]][[REPEAT]][[IF:LAST]][[FORH:1>N]]'||CHR(10)||'<<TYPE>> left:[[FORH:V-1>1:,]]<<TYPE>>[[ENDFOR]] right:[[FORH:V+1>N:,]]<<TYPE>>[[ENDFOR]][[ENDFOR]][[ENDIF]][[ENDLOOP,TYPE]]'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (3, 'Cube_Gen_Manual', 'CASE30', 'REPREF1', 'Replacement References', 'A replacement label refers to a model element property and can also refer to another model element on the LOOP stack.', 'All types (with root and parent) with the types in the branch (with parent and child):[[LOOP,BUSINESS_OBJECT_TYPE]][[LOOP,TYPE]]'||CHR(10)||'<<TYPE>>: Root=<<TYPE(1)>> Parent=[[IF:!ROOT]]<<TYPE(N-1)>>[[ENDIF]][[FOR:2>N-1]]'||CHR(10)||'-'||CHR(9)||'<<TYPE>> Parent=<<TYPE(V-1)>> Child=<<TYPE(V+1)>>[[ENDFOR]][[REPEAT]][[ENDLOOP,TYPE]]'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (6, 'Cube_Gen_Manual', 'CASE40', 'Replacement Functions', '', 'Manipulate the export of the model element texts or replace the references with model element properties.');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE40', 'AAA');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (2, 'Cube_Gen_Manual', 'CASE40', 'CUSTOMER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (3, 'Cube_Gen_Manual', 'CASE40', 'ORDER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (4, 'Cube_Gen_Manual', 'CASE40', 'PRODUCT');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE40', 'REPL4', 'Manipulate Text', 'Manipulate the exported text of the model element properties by a function.', '[[LOOP,BUSINESS_OBJECT_TYPE:!0=AAA]]Unchanged: <<BUSINESS_OBJECT_TYPE>>, <<BUSINESS_OBJECT_TYPE2>>'||CHR(10)||'Uppercase: <<BUSINESS_OBJECT_TYPE:U>>, <<BUSINESS_OBJECT_TYPE2:U>>'||CHR(10)||'Lowercase: <<BUSINESS_OBJECT_TYPE:L>>, <<BUSINESS_OBJECT_TYPE2:L>>'||CHR(10)||'Camelcase: <<BUSINESS_OBJECT_TYPE:L>>, <<BUSINESS_OBJECT_TYPE2:C>>'||CHR(10)||''||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (2, 'Cube_Gen_Manual', 'CASE40', 'REPL2', 'Property Replacements', 'Export a model property of the model element.', '[[LOOP,BUSINESS_OBJECT_TYPE:!0=AAA]]Unique Number  : <<BUSINESS_OBJECT_TYPE:N>>'||CHR(10)||'Sub Number     : <<BUSINESS_OBJECT_TYPE:S>> (serial number within parent model element)'||CHR(10)||'Index          : <<BUSINESS_OBJECT_TYPE:IX>> (serial number within the LOOP selection)'||CHR(10)||'Cube Identifier: <<BUSINESS_OBJECT_TYPE:I>>'||CHR(10)||''||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (3, 'Cube_Gen_Manual', 'CASE40', 'REPL3', 'Character Escaping', 'Escape characters in the exported text of the model element properties by a function.', '[[LOOP,BUSINESS_OBJECT_TYPE:0=AAA]]Plain text:'||CHR(10)||'<<BUSINESS_OBJECT_TYPE2>>'||CHR(10)||'Percent escapes:'||CHR(10)||'<<BUSINESS_OBJECT_TYPE2:P>>'||CHR(10)||'HTML escapes (with HTML break):'||CHR(10)||'<<BUSINESS_OBJECT_TYPE2:H>>'||CHR(10)||'HTML escapes (with linefeed):'||CHR(10)||'<<BUSINESS_OBJECT_TYPE2:HE>>'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (4, 'Cube_Gen_Manual', 'CASE40', 'LOOPRF1', 'HTML / Percent Encoding', 'Apply the HTML escape or URI escacpe (Percent escape) functions to the text within the loop, using LOOP_HTML and LOOP_PERC functions.', 'The result of LOOP also presented In HTML and percentage escaping:'||CHR(10)||'[[LOOP,BUSINESS_OBJECT_TYPE:!0=AAA]]<<<BUSINESS_OBJECT_TYPE:C>>/>'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]'||CHR(10)||'HTML: '||CHR(10)||'[[LOOP_HTML,BUSINESS_OBJECT_TYPE:!0=AAA]]<<<BUSINESS_OBJECT_TYPE:C>>/>'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]'||CHR(10)||'PERC: '||CHR(10)||'[[LOOP_PERC,BUSINESS_OBJECT_TYPE:!0=AAA]]<<<BUSINESS_OBJECT_TYPE:C>>/>'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]'||CHR(10)||'');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (7, 'Cube_Gen_Manual', 'CASE45', 'Reusable Text', '', '');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE45', 'CUSTOMER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (2, 'Cube_Gen_Manual', 'CASE45', 'ORDER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (3, 'Cube_Gen_Manual', 'CASE45', 'PRODUCT');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (4, 'Cube_Gen_Manual', 'CASE45', 'FACTORY');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE45', 'TEXT0', 'Text Blocks / Text Labels', 'Text blocks are defined for reuse of template segments. The text may contain labels that are replaced with arguments that are defined at the place where the text is applied. ', '[[TEXT,OBJECT_LIST]][[LOOP,BUSINESS_OBJECT_TYPE:1=<<T1>>]][[IF:FIRST]]<<T2>> Objects: [[ENDIF]]<<BUSINESS_OBJECT_TYPE:C>>[[IF:!LAST]], [[ELSE]];'||CHR(10)||'[[ENDIF]][[ENDLOOP,BUSINESS_OBJECT_TYPE]][[ENDTEXT]]'||CHR(10)||'[[BODY]]<<TEXT,OBJECT_LIST[|]INT[|]Internal[|]>><<TEXT,OBJECT_LIST[|]EXT[|]External[|]>><<TEXT,OBJECT_LIST[|]INV[|]Invalid[|]>>[[ENDBODY]]');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (8, 'Cube_Gen_Manual', 'CASE50', 'External Functions', '', 'Perl expressions can be used for special functionality that is not available as standard CubeGen functions.');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE50', 'CUSTOMER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (2, 'Cube_Gen_Manual', 'CASE50', 'PRODUCT');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (3, 'Cube_Gen_Manual', 'CASE50', 'ORDER');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE50', 'PERL1', 'Perl Expressions', 'The DECL and EVAL functions are performing the Perl eval statement. Only the EVAL function (not the logical expression) exports te result to the code. This can be suppressed by putting the Perl expression between parentheses.', 'Total length (bits) of the names:[[DECL:sub myLen{return 8*length(@_[0])}]][[LOOP,BUSINESS_OBJECT_TYPE]]'||CHR(10)||'[[IF:EVAL:myLen(''<<BUSINESS_OBJECT_TYPE>>'')<48]]Next with one additional byte.'||CHR(10)||'[[EVAL:($myC+=8)]][[ENDIF]]<<BUSINESS_OBJECT_TYPE>>: [[EVAL:$myC+=myLen(''<<BUSINESS_OBJECT_TYPE>>'')]][[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (9, 'Cube_Gen_Manual', 'CASE60', 'Sequential Processing', 'TYPE ATTRIBUTE', 'Export the model elements in the order as they appaer in de Cube model.');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE60', 'ORDER');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE60', 'SEQU1', 'Sequential Iterations', 'The model elements referenced by the LOOP functions nested in the SEQUENCE function are exported in the order as they appear in the Cube model.', '[[LOOP,BUSINESS_OBJECT_TYPE]]Structure of <<BUSINESS_OBJECT_TYPE:C>>:[[SEQUENCE]][[LOOP,ATTRIBUTE]]'||CHR(10)||'-'||CHR(9)||'Attribute: <<ATTRIBUTE:C>>[[ENDLOOP,ATTRIBUTE]][[LOOP,TYPE]]'||CHR(10)||'-'||CHR(9)||'Type: <<TYPE:C>>[[REPEAT:TAB]][[ENDLOOP,TYPE]][[ENDSEQUENCE]]'||CHR(10)||'[[ENDLOOP,BUSINESS_OBJECT_TYPE]]');

INSERT INTO v_cube_gen_example_model (CUBE_SEQUENCE, FK_CUB_NAME, ID, HEADER, INCLUDED_OBJECT_NAMES, DESCRIPTION)
	VALUES (10, 'Cube_Gen_Manual', 'CASE90', 'Model Enhancement', 'TYPE ATTRIBUTE REFERENCE', 'The CUBE development framework has steps in which a cube model is copied with a number of enhancements. CubeGen has functions especially for supporting these steps.');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (1, 'Cube_Gen_Manual', 'CASE90', 'CUSTOMER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (2, 'Cube_Gen_Manual', 'CASE90', 'ORDER');

INSERT INTO v_cube_gen_example_object (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, XK_BOT_NAME)
	VALUES (3, 'Cube_Gen_Manual', 'CASE90', 'PRODUCT');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (1, 'Cube_Gen_Manual', 'CASE90', 'WILDCARD', 'Wildcard', 'Instead of a tag, an "*" can be used to apply a template function for all model elements.'||CHR(10)||'The VALUE function is used to copy a specified number of model element values.', '! Copied model[[LOOP,*]]'||CHR(10)||'+<<*TAG>>[[IF:!ID()]][<<*:I>>][[ENDIF]]:[[VALUE,*:0>N:|]];[[REPEAT:TAB]][[LOOP,>*]]'||CHR(10)||''||CHR(9)||'><<*TAG>>:<<*:I>>;[[ENDLOOP,>*]]'||CHR(10)||'-<<*TAG>>:;[[ENDLOOP,*]]');

INSERT INTO v_cube_gen_function (CUBE_SEQUENCE, FK_CUB_NAME, FK_CGM_ID, ID, HEADER, DESCRIPTION, TEMPLATE)
	VALUES (2, 'Cube_Gen_Manual', 'CASE90', 'ENHANCE', 'Enhance Model', 'In the generic model copy function texts can be added as specific enhancements. The TAG logical function has been added to select the concerning model elements.', '! Model enhanced with foreign keys[[LOOP,*]]'||CHR(10)||'+<<*TAG>>[[IF:!ID()]][<<*:I>>][[ENDIF]]:[[VALUE,*:0>N:|]];[[IF:TAG(TYPE)]][[LOOP,REFERENCE]][[LOOP,REFERENCE_TYPE]][[LOOP,ATTRIBUTE:1=Y]]'||CHR(10)||''||CHR(9)||'=FOREIGN_KEY:FK_<<REFERENCE_TYPE1>>_<<ATTRIBUTE>>|<<REFERENCE1>>;[[ENDLOOP,ATTRIBUTE]][[ENDLOOP,REFERENCE_TYPE]][[ENDLOOP,REFERENCE]][[ENDIF]][[REPEAT:TAB]][[LOOP,>*]]'||CHR(10)||''||CHR(9)||'><<*TAG>>:<<*:I>>;[[ENDLOOP,>*]]'||CHR(10)||'-<<*TAG>>:;[[ENDLOOP,*]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'AND', 'Y', 'Perform the logical AND function on the results of two logical expressions.', '<logical_expression>[AND]<logical_expression>');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'BODY', 'N', 'The BODY function selects the part of the template file or include file that is being exported. Only one BODY function can be applied per file. If the file contains no BODY function, the entire file is exported.', '... [[BODY]] ... [[ENDBODY]] ... ');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'CHILD', 'Y', 'Check that the current model element for the concerned tag has a child model element with the specified tag (or all for *) that meets (optionally) the specified logical expression. ', 'CHILD(<tag>)'||CHR(10)||'CHILD(*)'||CHR(10)||'CHILD(<tag>:<logical_expression>)'||CHR(10)||'<tag>.CHILD(~~~)'||CHR(10)||'<tag>(<location>).CHILD(~~~)');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'DECL', 'N', 'Perform the Perl eval expression once to decclare in functions or variables. To prefix the names with "my", they will not mixed up to the CubeGen code.', '[[DECL:<perl_expression>]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'EVAL', 'N', 'Export the result of a Perl exprssion. When the Perl expression is placed between parentheses, the result is not exported. To prefix the names with "my", they will not mixed up to the CubeGen code.'||CHR(10)||'The <perl_expression> can contain labels that will be replaced by model element property values.', '[[EVAL:<perl_expression>]]'||CHR(10)||'[[EVAL:(<perl_expression>)]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'EVAL', 'Y', 'Perform a logical Perl expression.'||CHR(10)||'The <perl logicsal expression> can contain labels that will be replaced by a model element property value.', 'EVAL:<perl_logical_expression>');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'FILE', 'N', 'The FILE function switches over to another code file during the generation process. The <file_name> can also contain a path reference and labels that will be replaced by a model element property value or parameter value.', '[[FILE,<file_name>]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'FIRST', 'Y', 'Check that it is the first selected model element in the LOOP for the concerned tag. ', 'FIRST'||CHR(10)||'<tag>.FIRST'||CHR(10)||'<tag>(<location>).FIRST');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'FOR', 'N', 'Equal to FORV.', '');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'FORH', 'N', 'In the hierarchy selected by LOOP functions, the FORH function navigates on the same level (horizontal) through the model elements of the specified (by the tag) or actual type. The template segments for the selected model elements will be exported in the order of the loop specification, possibly separated by a specified string.'||CHR(10)||'In case of just tag ROOT the FORH function navigates to the top of the hierarchy.', '[[FORH:<loopspec>]] ... [[ENDFOR]]'||CHR(10)||'[[FORH,<tag>:<loopspec>]] ... [[ENDFOR]]'||CHR(10)||'[[FORH:<loopspec>:<seperator>]] ... [[ENDFOR]]'||CHR(10)||'[[FORH,<tag>:<loopspec>:<seperator>]] ... [[ENDFOR]]'||CHR(10)||'[[FORH,ROOT]] ... [[ENDFOR]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'FORV', 'N', 'In the hierarchy selected by LOOP functions, the FORV function navigates top down (vertical) through the model elements of the tag specified (by the tag) or actual type. The template segments for the selected model elements will be exported in the order of the loop specification, possibly separated by a specified string.'||CHR(10)||'In case of just tag ROOT the FORV function navigates to the top of the hierarchy.'||CHR(10)||''||CHR(10)||'', '[[FORV:<loopspec>]] ... [[ENDFOR]]'||CHR(10)||'[[FORV,<tag>:<loopspec>]] ... [[ENDFOR]]'||CHR(10)||'[[FORV:<loopspec>:<seperator>]] ... [[ENDFOR]]'||CHR(10)||'[[FORV,<tag>:<loopspec>:<seperator>]] ... [[ENDFOR]]'||CHR(10)||'[[FORV,ROOT]] ... [[ENDFOR]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'ID', 'Y', 'Check for the id of the actual model element.'||CHR(10)||'The <value> can contain labels that will be replaced by a model element property value.', 'ID(<value>)'||CHR(10)||'<tag>.ID(<value>)'||CHR(10)||'<tag>(<location>).ID(<value>)');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'IF', 'N', 'Export a template segment that applies to a condition (logical_expression). By default, the logical functions in the logical expression work on the model elements that are selected within the valid loop. If a tag for the colon is filled, the model elements of this tag are used by default. This tag can be overruled by a tag that can be defined for the logical function.', '[[IF:<(logical_expression>]] ... [[ENDIF]]'||CHR(10)||'[[IF,<tag>:<(logical_expression>]] ... [[ENDIF]]'||CHR(10)||'[[IF,<tag>(<location>):<(logical_expression>]] ... [[ENDIF]]'||CHR(10)||'[[IF~~~]] ... [[ELSIF~~~]] ... [[ELSE]] ... [[ENDIF]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'INCLUDE', 'N', 'Template segments can be included from another file. The filename can also contain a path reference.', '[[INCLUDE,<<file_name>>]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'LAST', 'Y', 'Check that it is the last selected model element in the LOOP for the concerned tag. ', 'LAST'||CHR(10)||'<tag>.LAST'||CHR(10)||'<tag>(<location>).LAST');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'LEVEL', 'Y', 'Check that the model element is of the specified level in the hierachy of the REPEAT LOOP for the concerned tag. So LEVEL(1) checks for the root model element.', 'LEVEL(<repeat_level>)'||CHR(10)||'<tag>.LEVEL(<repeat_level>)'||CHR(10)||'<tag>(<location>).LEVEL(<repeat_level>)');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'LOOP', 'N', 'Export the template segment for the model elements that (optionally) meet the logical expression for the specified tag in sequential order .', '[[LOOP,<tag>]] ... [[ENDLOOP,<tag>]]'||CHR(10)||'[[LOOP,<tag>:<(logical_expression>]] ... [[ENDLOOP,<tag>]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'NOT', 'Y', 'Invert the result of a logical expression.', '!<logical_expression>');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'OR', 'Y', 'Perform the logical OR function on the results of two logical expressions.', '<logical_expression>[OR]<logical_expression>');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'PARENT', 'Y', 'Check that the current model element for the concerned tag has a parent model element with the specified tag that meets (optionally) the specified logical expression. ', 'PARENT(<tag>)'||CHR(10)||'PARENT(<tag>:<logical_expression>)'||CHR(10)||'<tag>.PARENT(~~~)'||CHR(10)||'<tag>(<location>).PARENT(~~~)');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'REPEAT', 'N', 'Repeat the LOOP function for all underlying model elements of the specified type. The indentation of the exported text can be increased by one or more tabs. (eg. TAB, 2TAB, 3TAB, ...)', '[[LOOP,<tag>]] ... [[REPEAT]] ... [[ENDLOOP,<tag>]]'||CHR(10)||'[[LOOP,<tag>]] ... [[REPEAT:nTAB]] ... [[ENDLOOP,<tag>]]'||CHR(10)||'[[LOOP,<tag>]] ... [[LOOP...]] ... [[REPEAT,<tag>]] ... [[ENDLOOP...]] ... [[ENDLOOP,<tag>]]'||CHR(10)||'[[LOOP,<tag>]] ... [[LOOP...]] ... [[REPEAT,<tag>:nTAB]] ... [[ENDLOOP...]] ... [[ENDLOOP,<tag>]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'ROOT', 'Y', 'Check that the model element is the root of the hierachy of the REPEAT LOOP for the concerned tag. ', 'ROOT'||CHR(10)||'<tag>.ROOT'||CHR(10)||'<tag>(<location>).ROOT');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'SEQUENCE', 'N', 'The model elements referenced by the LOOP functions nested in the SEQUENCE function are exported in the order as they appear in the Cube model. The text within the SEQUENCE function and outside the nested LOOP function is ignored, and will not be exported. ', '[[SEQUENCE]]'||CHR(10)||'[[LOOP,<tag1>]] ... [[ENDLOOP,<tag1>]]'||CHR(10)||'[[LOOP,<tag2>]] ... [[ENDLOOP,<tag2>]]'||CHR(10)||'...'||CHR(10)||'[[LOOP,<tagN>]] ... [[ENDLOOP,<tagN>]]'||CHR(10)||'[[ENDSEQUENCE]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'TABS', 'N', 'Increase or decrease indentation of the current and following text segments. To decrease indentation specify a negative increment.', '[[TABS:<increment>]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'TAG', 'Y', 'Check for the type of the actual model element.', 'TAG(<tag>)');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'TEMPLATE', 'N', 'Process a model element property as a template segment.', '[[TEMPLATE:<tag>]]'||CHR(10)||'[[TEMPLATE:<tag>(<location>)]]'||CHR(10)||'[[TEMPLATE:<tag>(<location>)<property>]]'||CHR(10)||'[[TEMPLATE:<tag>:<function>]]'||CHR(10)||'[[TEMPLATE:<tag>(<location>):<function>]]'||CHR(10)||'[[TEMPLATE:<tag>(<location>)<property>:<function>]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'TEXT', 'N', 'Text blocks are defined for reuse of template segments. The text may contain labels that are replaced with arguments that are defined at the place where the text is applied. The optional list of arguments starts and ends with the separator "[|]". The text is only exported at the location of the text labels. The text blocks themselves are not exported.'||CHR(10)||'The indentation of the exported text can be increased by one or more tabs. (eg. TAB, 2TAB, 3TAB, ...)', '[[TEXT,<name>]] ... [[ENDTEXT]]'||CHR(10)||'<<TEXT,<name>>>'||CHR(10)||'<<TEXT:nTAB,<name>>>'||CHR(10)||''||CHR(10)||'[[TEXT,<name>]] ... <<T1>> ... <<T2>> ... [[ENDTEXT]]'||CHR(10)||'<<TEXT,<name>[|]<parm1>[|]<parm2>[|]>>'||CHR(10)||'<<TEXT:nTAB,<name>[|]<parm1>[|]<parm2>[|]>>');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'VALUE', 'N', 'Export the properties of a model element.', '[[VALUE,<tag>:<loop_spec>:<separator>]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'comment', 'N', 'Text that is not exported.', '[[* ... *]]');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'parameter=', 'Y', 'The parameters specified on the command line can be referenced in the "is equal to" logical expression.'||CHR(10)||'The <value> can contain labels that will be replaced by a model element property value or parameter value.', 'P<parm_number>=<value>');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'parameters', 'N', 'The parameters specified on the command line can be selected for export. Only the replace functions L (lowercase) and U (uppercase) are supported.', '<<<parm_number>>>'||CHR(10)||'<<<parm_number>:<function>>>');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'parentheses', 'Y', 'Parentheses are used in the logical expressions to define the precedence of the AND,OR and NOT operations.', '!(<logical_expression>[AND](<logical_expression>[OR]<logical_expression>))');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'property=', 'Y', 'A model element property can be referenced in the "is equal to" logical expression.'||CHR(10)||'The <value> can contain labels that will be replaced by a model element property value or parameter value.', '<property_number>=<value>'||CHR(10)||'<tag>.<property_number>=<value>'||CHR(10)||'<tag>(<location>).<property_number>=<value>');

INSERT INTO v_cube_gen_template_function (FK_CUB_NAME, NAME, INDICATION_LOGICAL, DESCRIPTION, SYNTAX)
	VALUES ('Cube_Gen_Manual', 'replacement', 'N', 'Replace a label with a model value.', '<<<tag>>>'||CHR(10)||'<<<tag>(<location>)>>'||CHR(10)||'<<<tag><property>>>'||CHR(10)||'<<<tag>(<location>)<property>>>'||CHR(10)||'<<<tag>:<function>>>'||CHR(10)||'<<<tag>(<location>):<function>>>'||CHR(10)||'<<<tag><property>:<function>>>'||CHR(10)||'<<<tag>(<location>)<property>:<function>>>'||CHR(10)||'');

EXIT;
