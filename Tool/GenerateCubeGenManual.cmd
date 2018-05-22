@echo off
set sysname=CubeDocu
set logfile=GenerateCubeGenManual.log
set sysdir=Systems\%sysname%
set db_name=composys
set db_schema=cubedocu
set db_password=composys

echo Start > %logfile%

echo extract model.
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelExport.sql %sysdir%\CubeToolModel.cgm ALL REPLACE >> %logfile% 2>&1

echo Generate Model.
CubeGen.exe %sysdir%\CubeToolModel.cgm Templates\CubeGenManualModel.cgt %sysdir%\CubeGenManualModel.cgm >> %logfile% 2>&1

echo Generate Manual.
CubeGen.exe  %sysdir%\CubeGenManualModel.cgm Templates\CubeGenManual.cgt html\cubegen\cubegen_manual.html >> %logfile% 2>&1

pause