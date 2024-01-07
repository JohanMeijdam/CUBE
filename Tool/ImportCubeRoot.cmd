@echo off
set sysname=CubeRoot
set logfile=ImportCubeTool.log
set sysdir=Systems\%sysname%
set db_name=composys
set db_schema=cuberoot
set db_password=composys

echo Start > %logfile%
--CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelImport.cgt %sysdir%\ModelImport.pl %sysname% >> %logfile% 2>&1
perl %sysdir%\ModelImport.pl %sysdir%\CubeModel.cgm %sysdir%\ModelImport.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelImport.sql >> %logfile% 2>&1

pause