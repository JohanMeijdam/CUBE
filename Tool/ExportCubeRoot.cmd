@echo off
set sysname=CubeRoot
set logfile=ExportCubeRoot.log
set sysdir=Systems\%sysname%
set db_name=composys
set db_schema=cuberoot
set db_password=composys

echo Start > %logfile%

echo extract model.
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelExport.sql %sysdir%\CubeToolModel.cgm ALL REPLACE >> %logfile% 2>&1

pause