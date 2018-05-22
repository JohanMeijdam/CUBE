@echo off
set sysname=CubeDemo
set logfile=GenerateCubeExtApiTest.log
set sysdir=Systems\%sysname%
set db_name=composys
set db_schema=cubetool
set db_password=composys

echo Start > %logfile%

echo extract model.
sqlplus.exe %db_schema%/%db_password%@%db_name% @Systems\cubetool\ModelExport.sql %sysdir%\CubeModel.cgm %sysname% REPLACE >> %logfile% 2>&1

echo :Models
echo Generate Models.
::CubeGen.exe %sysdir%\CubeModel.cgm Templates\Model0.cgt %sysdir%\CubeModel0.cgm %sysname% >> %logfile% 2>&1



echo Generate Ext API Test page.
CubeGen.exe %sysdir%\CubeModel.cgm Templates\CubeExtApiTest.cgt html\cube\cube_external_api_test.html %sysname% >> %logfile% 2>&1

echo Generate Ext API Test servers.


pause