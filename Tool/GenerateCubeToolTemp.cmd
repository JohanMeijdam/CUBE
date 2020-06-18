::@echo off
set sysname=CubeTool
set logfile=Generate%sysname%Temp.log
set sysdir=Systems\%sysname%
set cubesysdir=Systems\CubeSys
set db_name=composys
set db_schema=cubetool
set db_password=composys
set wwwroot=C:\inetpub\wwwroot
set sysroot=%wwwroot%\%sysname%

echo Start.
echo Start > %logfile%
CubeGen.exe %sysdir%\CubeBoModel.cgm Templates\ServerSpecModelTemp.cgt %sysdir%\CubeServerSpecModelTemp.cgm %sysname% >> %logfile% 2>&1
CubeGen.exe %sysdir%\CubeServerSpecModelTemp.cgm Templates\CubeDetailPhpTemp.cgt %sysdir%\phpTemp\%sysname%Detail.php %sysname% %sysdir%\phpTemp >> %logfile% 2>&1
echo Ready.
pause

