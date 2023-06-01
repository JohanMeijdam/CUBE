-- Model export
\pset tuples_only
\pset format unaligned
\pset fieldsep ''
CALL cube_exp.export_model (:system);
\o :model 
SELECT str FROM cube_exp.line ORDER BY num;
\o