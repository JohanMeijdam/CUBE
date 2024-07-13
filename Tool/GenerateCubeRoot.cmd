@echo off
set sysname=CubeRoot
set logfile=Generate%sysname%.log
set sysdir=Systems\%sysname%
set cubesysdir=Systems\CubeSys
set db_name=composys
set db_schema=cuberoot
set db_password=composys
set wwwroot=C:\inetpub\wwwroot
set sysroot=%wwwroot%\%sysname%

echo Start > %logfile%
::goto :Database
::goto :Views
::goto :Packages
::goto :Application
::goto :Install
::goto :ModelImport
::goto :ModelExport
goto :System
echo Extract Cube Model
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelExport.sql %sysdir%\CubeModel.cgm ALL REPLACE >> %logfile% 2>&1
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
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\DbModel.cgt %sysdir%\CubeDbModel.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\Table.cgt %sysdir%\TableDdl.sql >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\AlterTable.cgt %sysdir%\AlterTableDdl.sql >> %logfile% 2>&1
::sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\TableDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\AlterTableDdl.sql >> %logfile% 2>&1
::goto :end
:Views
echo Generate Database Views.
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\View.cgt %sysdir%\ViewDdl.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ViewDdl.sql >> %logfile% 2>&1
::goto :end
:ModelImport
echo Import Model.
::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelImport.cgt %sysdir%\ModelImport.pl %sysname% >> %logfile% 2>&1
::perl %sysdir%\ModelImport.pl %sysdir%\CubeModel.cgm %sysdir%\ModelImport.sql >> %logfile% 2>&1
::sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelImport.sql >> %logfile% 2>&1
::goto :ModelExport
::goto :end
:Packages
echo Generate Packages.
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\ServerImplModel.cgt %sysdir%\CubeServerImplModel.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerImplModel.cgm Templates\Package.cgt %sysdir%\PackageDdl.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\PackageDdl.sql >> %logfile% 2>&1
::goto :end
:Application
echo Generate Application.
del /S/Q %sysdir%\php\*.php >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeDbLogonPhp.cgt %sysdir%\php\CubeDbLogon.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\IndexHtml.cgt %sysdir%\php\index.html %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeTreePhp.cgt %sysdir%\php\%sysname%Tree.php %sysname% %sysdir%\php >> %logfile% 2>&1
::::::CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeMainPhp.cgt %sysdir%\php\%sysname%Main.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\CubeDetailPhp.cgt %sysdir%\php\%sysname%Detail.php %sysname% %sysdir%\php >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\CubeServerPhp.cgt %sysdir%\php\%sysname%Server.php %sysname% %sysdir%\php >> %logfile% 2>&1
::goto :end
:Install
del /S/Q %sysroot% >> %logfile% 2>&1
xcopy /Y/S/E %sysdir%\files %sysroot% >> %logfile% 2>&1
xcopy /Y/S/E %sysdir%\php %sysroot% >> %logfile% 2>&1
xcopy /Y %cubesysdir%\php %sysroot% >> %logfile% 2>&1
::goto :end
:ModelExport
echo Generate Model Export.
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelExport.cgt %sysdir%\ModelExport.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelExport.sql %sysdir%\CubeToolModel.cgm ALL REPLACE >> %logfile% 2>&1
::goto :end
:System
call GenerateCubeSys.cmd
::goto :end
echo Install CubeSys.
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\TableDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\ViewDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\PackageDdl.sql >> %logfile% 2>&1
::xcopy /Y %cubesysdir%\php %sysroot% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\SystemImport.cgt %sysdir%\SystemImport.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\SystemImport.sql >> %logfile% 2>&1
:end
pause