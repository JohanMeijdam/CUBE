\o :model

--SET CLIENT_MIN_MESSAGES = 'debug';
-- Equivalent To Oracle SET SERVEROUTPUT ON

--DO $$
--BEGIN
--RAISE DEBUG USING MESSAGE := 'hello world';
--END $$;

\pset tuples_only
\pset format unaligned
\pset fieldsep ''


SELECT '	TESTAAP';
SELECT '		TESTAAP2';

\qecho :system
\qecho "	AAP"
\qecho ! Generated with CubeGen
select 'Test Aap' from aap.aap;
select * from aap.aap;
\qecho MODEL
SELECT '+INFORMATION_TYPE[' || cube_id || ']:' || name|| ';',
( SELECT array_agg(name) FROM (SELECT 'AAP'||sequence FROM itp.t_information_type_element WHERE fk_itp_name = itp.name ORDER BY name DESC) AS tab )
FROM itp.t_information_type itp ORDER BY name;

--DO $BODY$
--	DECLARE
--	BEGIN
--		RAISE DEBUG 'Test aap';
--	END;
--$BODY$
\o