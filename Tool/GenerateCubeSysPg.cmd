@echo off
set c_sysname=CubeSys
set c_logfile=Generate%c_sysname%Pg.log
set c_sysdir=Systems\%c_sysname%Pg
set c_phpdir=%c_sysdir%\php
echo Start > %c_logfile%
::goto :Database
:CubeModel
echo CubeSys: Extract CubeModel.
sqlplus.exe cuberoot/composys@composys @Systems\CubeRoot\ModelExport.sql %c_sysdir%\CubeModel.cgm %c_sysname% REPLACE >> %c_logfile% 2>&1
:Models
echo CubeSys: Generate Models.
CubeGen.exe %c_sysdir%\CubeModel.cgm Templates\Model0.cgt %c_sysdir%\CubeModel0.cgm %c_sysname% >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeModel0.cgm Templates\ModelA.cgt %c_sysdir%\CubeModelA.cgm %c_sysname% >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeModelA.cgm Templates\ModelB.cgt %c_sysdir%\CubeModelB.cgm >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeModelB.cgm Templates\BoModel.cgt %c_sysdir%\CubeBoModel.cgm >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeBoModel.cgm Templates\DbModel.cgt %c_sysdir%\CubeDbModel.cgm %c_sysname% >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeBoModel.cgm Templates\ServerSpecModel.cgt %c_sysdir%\CubeServerSpecModel.cgm %c_sysname% >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeServerSpecModel.cgm Templates\ServerImplModel.cgt %c_sysdir%\CubeServerImplModel.cgm %c_sysname% >> %c_logfile% 2>&1
:Database
echo CubeSys: Generate Database DDL.
CubeGen.exe %c_sysdir%\CubeDbModel.cgm Templates\Table_pg.cgt %c_sysdir%\TableDdl_pg.sql >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeDbModel.cgm Templates\AlterTable_pg.cgt %c_sysdir%\AlterTableDdl_pg.sql >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeBoModel.cgm Templates\View_pg.cgt %c_sysdir%\ViewDdl_pg.sql %c_sysname% >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeServerImplModel.cgm Templates\Package_pg.cgt %c_sysdir%\PackageDdl_pg.sql %c_sysname% >> %c_logfile% 2>&1
::goto :End
:Application
echo CubeSys: Generate Application.
del /S/Q %c_phpdir% >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeBoModel.cgm Templates\CubeTreePhp.cgt %c_phpdir%\%c_sysname%Tree.php %c_sysname% %c_phpdir% >> %c_logfile% 2>&1
CubeGen.exe %c_sysdir%\CubeServerSpecModel.cgm Templates\CubeDetailPhp.cgt %c_phpdir%\%c_sysname%Detail.php %c_sysname% %c_sysdir%\php >> %c_logfile% 2>&1
CubeGen.exe %C_sysdir%\CubeServerSpecModel.cgm Templates\CubeServerPhp_pg.cgt %c_phpdir%\%c_sysname%Server.php %c_sysname% %c_sysdir%\php >> %c_logfile% 2>&1
:End
::pause
