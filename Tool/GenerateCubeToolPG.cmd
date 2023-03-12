@echo off
set sysname=CubeTool
set logfile=Generate%sysname%.log
set sysdir=Systems\%sysname%
set cubesysdir=Systems\CubeSys
set wwwroot=C:\inetpub\wwwroot
set sysroot=%wwwroot%\%sysname%
call ..\..\pg_conn_vars.cmd
echo Start > %logfile%
set PGPASSWORD=%db_password%

CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelExport_pg.cgt %sysdir%\ModelExport_pg.sql %sysname% >> %logfile% 2>&1
psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\ModelExport_pg.sql -v model="%sysdir%\CubeToolModelPg.cgm" -v system="'%sysname%'" >> %logfile% 2>&1
::psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\test.sql -v model="%sysdir%\CubeToolModelPg.cgm" -v system="'%sysname%'" >> %logfile% 2>&1
:Scripts
echo Generate Scripts.
::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelImport.cgt %sysdir%\ModelImport.pl %sysname% >> %logfile% 2>&1
::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelExport_pg.cgt %sysdir%\ModelExport_pg.sql %sysname% >> %logfile% 2>&1
::goto End

echo Generate Database Tables.
::CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\Table_pg.cgt %sysdir%\TableDdl_pg.sql %db_user% >> %logfile% 2>&1
::CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\AlterTable_pg.cgt %sysdir%\AlterTableDdl_pg.sql %db_user% >> %logfile% 2>&1
::psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\TableDdl_pg.sql >> %logfile% 2>&1
::psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\AlterTableDdl_pg.sql >> %logfile% 2>&1

echo Generate Database Views.
::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\View_pg.cgt %sysdir%\ViewDdl_pg.sql %sysname% %db_user% >> %logfile% 2>&1
::psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\ViewDdl_pg.sql >> %logfile% 2>&1

echo Generate Packages.
::CubeGen.exe %sysdir%\CubeServerImplModel.cgm Templates\Package_pg.cgt %sysdir%\PackageDdl_pg.sql %sysname% %db_user% >> %logfile% 2>&1
::psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\PackageDdl_pg.sql >> %logfile% 2>&1

echo Generate Application.
::CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\CubeServerPhp_pg.cgt D:\www\%sysname%\%sysname%Server.php %sysname% >> %logfile% 2>&1
:End
pause
