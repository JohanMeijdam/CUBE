@echo off
set sysname=CubeTool
set logfile=GenerateCubeGenManual.log
set sysdir=Systems\%sysname%
set db_name=composys
set db_schema=cubetool
set db_password=composys

echo Start > %logfile%

echo extract model.
sqlplus.exe %db_schema%/%db_password%@%db_name% @Systems\CubeTool\ModelExport.sql %sysdir%\CubeToolModel.cgm REPLACE >> %logfile% 2>&1

echo Generate Model.
CubeGen.exe %sysdir%\CubeToolModel.cgm Templates\CubeGenManualModel.cgt %sysdir%\CubeGenManualModel.cgm >> %logfile% 2>&1

echo Generate Manual.
CubeGen.exe %sysdir%\CubeGenManualModel.cgm Templates\CubeGenManual.cgt %sysdir%\html\CubeGenManual.htm %sysdir% >> %logfile% 2>&1

pause