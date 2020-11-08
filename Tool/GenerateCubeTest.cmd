@echo off
set sysname=CubeTest
set logfile=Generate%sysname%.log
set sysdir=Systems\%sysname%
set cubesysdir=Systems\CubeSys
set db_name=composys
set db_schema=cubetest
set db_password=composys
set wwwroot=C:\inetpub\wwwroot
set sysroot=%wwwroot%\%sysname%

echo Start > %logfile%
::goto Models
::goto Database
::goto Views
::goto Packages
goto Application
::goto System
echo Extract Cube Model
sqlplus.exe cubetool/composys@composys @Systems\CubeTool\ModelExport.sql %sysdir%\CubeModel.cgm %sysname% REPLACE >> %logfile% 2>&1
::goto End
:Models
echo Generate Models.
CubeGen.exe %sysdir%\CubeModel.cgm Templates\Model0.cgt %sysdir%\CubeModel0.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModel0.cgm Templates\ModelA.cgt %sysdir%\CubeModelA.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModelA.cgm Templates\ModelB.cgt %sysdir%\CubeModelB.cgm >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModelB.cgm Templates\BoModel.cgt %sysdir%\CubeBoModel.cgm >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\DbModel.cgt %sysdir%\CubeDbModel.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ServerSpecModel.cgt %sysdir%\CubeServerSpecModel.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\ServerImplModel.cgt %sysdir%\CubeServerImplModel.cgm %sysname% >> %logfile% 2>&1echo Extract Model
::goto end
:Database
echo Generate Database Tables.
CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\Table.cgt %sysdir%\TableDdl.sql >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\AlterTable.cgt %sysdir%\AlterTableDdl.sql >> %logfile% 2>&1
::sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\TableDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\AlterTableDdl.sql >> %logfile% 2>&1
:Views
echo Generate Database Views.
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\View.cgt %sysdir%\ViewDdl.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ViewDdl.sql >> %logfile% 2>&1
::goto end
:Packages
echo Generate Packages.
CubeGen.exe %sysdir%\CubeServerImplModel.cgm Templates\Package.cgt %sysdir%\PackageDdl.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\PackageDdl.sql >> %logfile% 2>&1
::goto end
:Application 
echo Generate Application.
del /S/Q %sysdir%\php\*.php >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeDbLogonPhp.cgt %sysdir%\php\CubeDbLogon.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\IndexHtml.cgt %sysdir%\php\Index.html %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeTreePhp.cgt %sysdir%\php\%sysname%Tree.php %sysname% %sysdir%\php >> %logfile% 2>&1
::::::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeMainPhp.cgt %sysdir%\php\%sysname%Main.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\CubeDetailPhp.cgt %sysdir%\php\%sysname%Detail.php %sysname% %sysdir%\php >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\CubeServerPhp.cgt %sysdir%\php\%sysname%Server.php %sysname% >> %logfile% 2>&1
del /S/Q %sysroot% >> %logfile% 2>&1
xcopy /Y/E %sysdir%\files %sysroot% >> %logfile% 2>&1
xcopy /Y/E %sysdir%\php %sysroot% >> %logfile% 2>&1
goto end
:System
echo ******* SYSTEM ******* >> %logfile%

::call GenerateCubeSys.cmd
echo Install CubeSys.
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\TableDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\ViewDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\PackageDdl.sql >> %logfile% 2>&1
xcopy /Y %cubesysdir%\php %sysroot% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\SystemImport.cgt %sysdir%\SystemImport.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\SystemImport.sql >> %logfile% 2>&1
:end
pause

