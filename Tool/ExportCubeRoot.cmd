@echo off
set sysname=CubeRoot
set logfile=ExportCubeRoot.log
set sysdir=Systems\%sysname%
set db_name=composys
set db_schema=cuberoot
set db_password=composys

echo Start > %logfile%
CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\AlterTable.cgt %sysdir%\AlterTableDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\AlterTableDdl.sql >> %logfile% 2>&1

echo extract model.
::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelExport.cgt %sysdir%\ModelExport.sql %sysname% >> %logfile% 2>&1
::sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelExport.sql %sysdir%\CubeModel.cgm ALL REPLACE >> %logfile% 2>&1

pause