@echo off
set sysname=CubeTool
set logfile=ExportCubeTool.log
set sysdir=Systems\%sysname%
set db_name=composys
set db_schema=cubetool
set db_password=composys

echo Start > %logfile%

echo extract model.
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelExport.sql %sysdir%\CubeToolModel.cgm REPLACE >> %logfile% 2>&1

pause