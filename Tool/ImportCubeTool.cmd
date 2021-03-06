@echo off
set sysname=CubeTool
set logfile=ImportCubeTool.log
set sysdir=Systems\%sysname%
set db_name=composys
set db_schema=cubetool
set db_password=composys

echo Start > %logfile%

perl %sysdir%\ModelImport.pl %sysdir%\CubeToolModel.cgm %sysdir%\ModelImport.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelImport.sql >> %logfile% 2>&1

pause