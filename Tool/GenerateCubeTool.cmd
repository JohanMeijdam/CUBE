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
::goto ModelImport
::goto Packages
::goto Application 
echo Extract Cube Model
sqlplus.exe cuberoot/composys@composys @Systems\CubeRoot\ModelExport.sql %sysdir%\CubeModel.txt REPLACE >> %logfile% 2>&1
::goto End
:Models
echo Generate Models.
CubeGen.exe %sysdir%\CubeModel.txt Templates\Model0Template.txt %sysdir%\CubeModel0.txt %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModel0.txt Templates\ModelATemplate.txt %sysdir%\CubeModelA.txt %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModelA.txt Templates\ModelBTemplate.txt %sysdir%\CubeModelB.txt >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeModelB.txt Templates\BoModelTemplate.txt %sysdir%\CubeBoModel.txt >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.txt Templates\DbModelTemplate.txt %sysdir%\CubeDbModel.txt %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.txt Templates\ServerSpecModelTemplate.txt %sysdir%\CubeServerSpecModel.txt %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.txt Templates\ServerImplModelTemplate.txt %sysdir%\CubeServerImplModel.txt %sysname% >> %logfile% 2>&1
:Scripts
echo Generate Scripts.
CubeGen.exe %sysdir%\CubeBoModel.txt Templates\ModelImportTemplate.txt %sysdir%\ModelImport.pl %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.txt Templates\ModelExportTemplate.txt %sysdir%\ModelExport.sql %sysname% >> %logfile% 2>&1
::goto End
:Database
echo Generate Database Tables.
CubeGen.exe %sysdir%\CubeDbModel.txt Templates\TableTemplate.txt %sysdir%\TableDdl.sql >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeDbModel.txt Templates\AlterTableTemplate.txt %sysdir%\AlterTableDdl.sql >> %logfile% 2>&1

::sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\TableDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\AlterTableDdl.sql >> %logfile% 2>&1

CubeGen.exe %sysdir%\CubeBoModel.txt Templates\ViewTemplate.txt %sysdir%\ViewDdl.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ViewDdl.sql >> %logfile% 2>&1
:ModelImport 
echo Import Model.
::::::perl Systems\CubeRoot\ModelImport.pl %sysdir%\ToolModel.txt %sysdir%\ToolModelImport.sql >> %logfile% 2>&1
::::::sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\ToolModelImport.sql >> %logfile% 2>&1
::goto End
:ModelExport
echo Extract Tool Model
sqlplus.exe %db_schema%/%db_password%@%db_name% %sysdir%\ModelExport.sql %sysdir%\CubeToolModel.txt REPLACE >> %logfile% 2>&1
::goto End
:Packages
echo Generate Packages.
CubeGen.exe %sysdir%\CubeServerImplModel.txt Templates\PackageTemplate.txt %sysdir%\PackageDdl.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\PackageDdl.sql >> %logfile% 2>&1
::goto End
:Application
echo Generate Application.
del /S/Q %sysroot% >> %logfile% 2>&1
xcopy /Y/E %sysdir%\files %sysroot% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.txt Templates\CubeDbLogonPhp.txt %sysroot%\CubeDbLogon.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.txt Templates\IndexPhp.txt %sysroot%\Index.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.txt Templates\CubeTreePhp.txt %sysroot%\%sysname%Tree.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.txt Templates\CubeMainPhp.txt %sysroot%\%sysname%Main.php %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeBoModel.txt Templates\CubeDetailPhp.txt %sysroot%\%sysname%Detail.php %sysname% %sysroot% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModel.txt Templates\CubeServerPhp.txt %sysroot%\%sysname%Server.php %sysname% >> %logfile% 2>&1
::goto End
:System
::call GenerateCubeSys.cmd
::goto End
echo Install CubeSys.
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\TableDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\ViewDdl.sql >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%cubesysdir%\PackageDdl.sql >> %logfile% 2>&1
xcopy /Y %cubesysdir%\php %sysroot% >> %logfile% 2>&1
perl CubeGen.pl %sysdir%\CubeBoModel.txt Templates\SystemImportTemplate.txt %sysdir%\SystemImport.sql %sysname% >> %logfile% 2>&1
sqlplus.exe %db_schema%/%db_password%@%db_name% @%sysdir%\SystemImport.sql >> %logfile% 2>&1
:end
pause
