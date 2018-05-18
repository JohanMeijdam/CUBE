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
::goto Models
::goto Scripts
::goto ModelImport
::goto ModelExport
::goto Packages
::goto Application 
echo Extract Cube Model
sqlplus.exe cuberoot/composys@composys @Systems\CubeRoot\ModelExport.sql %sysdir%\CubeModel.cgm REPLACE >> %logfile% 2>&1
::goto End
:Models
echo Generate Models.
CubeGen.exe %sysdir%\CubeModel.cgm Templates\Model0.cgt %sysdir%\CubeModel0.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModel0.cgm Templates\ModelA.cgt %sysdir%\CubeModelA.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModelA.cgm Templates\ModelB.cgt %sysdir%\CubeModelB.cgm >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModelB.cgm Templates\BoModel.cgt %sysdir%\CubeBoModel.cgm >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\DbModel.cgt %sysdir%\CubeDbModel.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ServerSpecModel.cgt %sysdir%\CubeServerSpecModel.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\ServerImplModel.cgt %sysdir%\CubeServerImplModel.cgm %sysname% >> %logfile% 2>&1
:Scripts
echo Generate Scripts.
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelImport.cgt %sysdir%\ModelImport.pl %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ModelExport.cgt %sysdir%\ModelExport.sql %sysname% >> %logfile% 2>&1
::goto End
:Database
echo Generate Database Tables.
CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\Table.cgt %sysdir%\TableDdl.sql >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeDbModel.cgm Templates\AlterTable.cgt %sysdir%\AlterTableDdl.sql >> %logfile% 2>&1

::sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\TableDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\AlterTableDdl.sql >> %logfile% 2>&1

CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\View.cgt %sysdir%\ViewDdl.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ViewDdl.sql >> %logfile% 2>&1
:ModelImport 
echo Import Model.
::::::perl Systems\CubeRoot\ModelImport.pl %sysdir%\ToolModel.cgm %sysdir%\ToolModelImport.sql >> %logfile% 2>&1
::::::sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ToolModelImport.sql >> %logfile% 2>&1
::goto End
:ModelExport
echo Extract Tool Model
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ModelExport.sql %sysdir%\CubeToolModel.cgm REPLACE >> %logfile% 2>&1
::goto End
:Packages
echo Generate Packages.
CubeGen.exe %sysdir%\CubeServerImplModel.cgm Templates\Package.cgt %sysdir%\PackageDdl.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\PackageDdl.sql >> %logfile% 2>&1
::goto End
:Application 
echo Generate Application.
del /S/Q %sysdir%\php\*.php >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeDbLogonPhp.cgt %sysdir%\php\CubeDbLogon.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\IndexPhp.cgt %sysdir%\php\Index.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeTreePhp.cgt %sysdir%\php\%sysname%Tree.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeMainPhp.cgt %sysdir%\php\%sysname%Main.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\CubeDetailPhp.cgt %sysdir%\php\%sysname%Detail.php %sysname% %sysdir%\php >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.cgm Templates\CubeServerPhp.cgt %sysdir%\php\%sysname%Server.php %sysname% >> %logfile% 2>&1
del /S/Q %sysroot% >> %logfile% 2>&1
xcopy /Y/E %sysdir%\files %sysroot% >> %logfile% 2>&1
xcopy /Y/E %sysdir%\php %sysroot% >> %logfile% 2>&1
::goto End
:System
::call GenerateCubeSys.cmd
::goto End
echo Install CubeSys.
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\TableDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\ViewDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\PackageDdl.sql >> %logfile% 2>&1
xcopy /Y %cubesysdir%\php %sysroot% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\SystemImport.cgt %sysdir%\SystemImport.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\SystemImport.sql >> %logfile% 2>&1
:end
pause
