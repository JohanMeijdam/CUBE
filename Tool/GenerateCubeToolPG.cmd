@echo off
set sysname=CubeTool
set logfile=Generate%sysname%.log
set sysdir=Systems\%sysname%
set cubesysdir=Systems\CubeSys
set db_name=composys
set db_schema=cubetool
set db_password=composys
set wwwroot=C:\inetpub\wwwroot
set sysroot=%wwwroot%\%sysname%

echo Start > %logfile%

echo Generate Database Tables.
::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\DbModel_pg.cgt %sysdir%\CubeDbModel_pg.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeDbModel_pg.cgm Templates\Table_pg.cgt %sysdir%\TableDdl_pg.sql >> %logfile% 2>&1
set PGPASSWORD=H00rnse_H0p
psql -h 82.217.5.32 -p 32781 -U cubetool -f %sysdir%\TableDdl_pg.sql >> %logfile% 2>&1


echo Generate Database Views.
::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\View_pg.cgt %sysdir%\ViewDdl_pg.sql %sysname% >> %logfile% 2>&1
::set PGPASSWORD=H00rnse_H0p
::psql -h 82.217.5.32 -p 32781 -U cubetool -f %sysdir%\ViewDdl_pg.sql >> %logfile% 2>&1
pause
