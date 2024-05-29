@echo off
set sysname=CubeRoot
set logfile=Generate%sysname%Pg.log
set sysdir=Systems\%sysname%Pg
set cubesysdir=Systems\CubeSysPg
set wwwroot=C:\inetpub\wwwroot
set sysroot=%wwwroot%\%sysname%Pg
call ..\..\pg_conn_vars.cmd
set db_name=cuberoot
set PGPASSWORD=%db_password%

echo Start > %logfile%
goto :Database
::goto :Packages
::goto :Application
::goto :Install
::goto :ModelImport
::goto :ModelExport
::goto :System
::echo Extract Cube Model
sqlplus.exe cuberoot/composys@composys @%sysdir%\ModelExport.sql %sysdir%\CubeModel.cgm ALL REPLACE >> %logfile% 2>&1
::goto End
:Models
echo Generate Models.
CubeGen.exe %sysdir%\CubeModel.cgm Templates\Model0.cgt %sysdir%\CubeModel0.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModel0.cgm Templates\ModelA.cgt %sysdir%\CubeModelA.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModelA.cgm Templates\ModelB.cgt %sysdir%\CubeModelB.cgm >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModelB.cgm Templates\BoModel.cgt %sysdir%\CubeBoModel.cgm >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ServerSpecModel.cgt %sysdir%\CubeServerSpecModel.cgm %sysname% >> %logfile% 2>&1
::goto :end
:Database
echo Generate Database.
::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\DbModel.cgt %sysdir%\CubeDbModel.cgm %sysname% >> %logfile% 2>&1
::CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\Table_pg.cgt %sysdir%\TableDdl_pg.sql >> %logfile% 2>&1
::CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\AlterTable_pg.cgt %sysdir%\AlterTableDdl_pg.sql >> %logfile% 2>&1
psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\TableDdl_pg.sql >> %logfile% 2>&1
::psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\AlterTableDdl_pg.sql >> %logfile% 2>&1
goto :end
:Views
echo Generate Database Views.
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\View_pg.cgt %sysdir%\ViewDdl_pg.sql %sysname% >> %logfile% 2>&1
psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\ViewDdl_pg.sql >> %logfile% 2>&1
::goto :end
:ModelImport
echo Import Model.
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelImport_pg.cgt %sysdir%\ModelImport_pg.pl %sysname% >> %logfile% 2>&1
perl %sysdir%\ModelImport_pg.pl %sysdir%\CubeModel.cgm %sysdir%\ToolModelImport_pg.sql >> %logfile% 2>&1
psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\ToolModelImport_pg.sql >> %logfile% 2>&1
::goto :end
:Packages
echo Generate Packages.
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\ServerImplModel.cgt %sysdir%\CubeServerImplModel.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerImplModel.cgm Templates\Package_pg.cgt %sysdir%\PackageDdl_pg.sql %sysname% >> %logfile% 2>&1
psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\PackageDdl_pg.sql >> %logfile% 2>&1
::goto :end
:Application
echo Generate Application.
del /S/Q %sysdir%\php\*.php >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeDbLogonPhp.cgt %sysdir%\php\CubeDbLogon.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\IndexHtml.cgt %sysdir%\php\index.html %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeTreePhp.cgt %sysdir%\php\%sysname%Tree.php %sysname% %sysdir%\php >> %logfile% 2>&1
::::::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeMainPhp.cgt %sysdir%\php\%sysname%Main.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\CubeDetailPhp.cgt %sysdir%\php\%sysname%Detail.php %sysname% %sysdir%\php >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\CubeServerPhp_pg.cgt %sysdir%\php\%sysname%Server.php %sysname% %sysdir%\php >> %logfile% 2>&1
::goto :end
:Install
del /S/Q %sysroot% >> %logfile% 2>&1
xcopy /Y/S/E %sysdir%\files %sysroot% >> %logfile% 2>&1
xcopy /Y/S/E %sysdir%\php %sysroot% >> %logfile% 2>&1
xcopy /Y %cubesysdir%\php %sysroot% >> %logfile% 2>&1
::goto :end
:ModelExport
echo Generate Model Export.
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelExport_pg.cgt %sysdir%\ModelExport_pg.sql %sysname% >> %logfile% 2>&1
::goto :end
:System
call GenerateCubeSysPg.cmd
::goto :end
echo Install CubeSys.
psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %cubesysdir%\TableDdl_pg.sql >> %logfile% 2>&1
psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %cubesysdir%\ViewDdl_pg.sql >> %logfile% 2>&1
psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %cubesysdir%\PackageDdl_pg.sql >> %logfile% 2>&1
::xcopy /Y %cubesysdir%\php %sysroot% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\SystemImport.cgt %sysdir%\SystemImport.sql %sysname% >> %logfile% 2>&1
psql -h %db_host% -p %db_port% -d %db_name% -U %db_user% -f %sysdir%\SystemImport.sql >> %logfile% 2>&1
:end
pause
