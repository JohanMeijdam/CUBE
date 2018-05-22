@echo off
set sysname=CubeRoot
set logfile=Generate%sysname%Html.log
set sysdir=Systems\%sysname%
set cubesysdir=Systems\CubeSys
set db_name=composys
set db_schema=cuberoot
set db_password=composys
set wwwroot=C:\inetpub\wwwroot
set sysroot=%wwwroot%\%sysname%

echo Start > %logfile%

echo Exporting model.
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelExport.sql %sysdir%\CubeToolModel.cgm ALL REPLACE >> %logfile% 2>&1

echo Generate HTML documentation.
CubeGen.exe %sysdir%\CubeToolModel.cgm Templates\BoHtml.cgt %sysdir%\html\CubeMetaModel.htm %sysname% >> %logfile% 2>&1
::pause