<?php
	echo "Excuting GenerateModels\n";
	echo shell_exec (". Systems\CubeTool\php/scripts/GenerateModels 2>&1");
	ob_flush();
	flush();
	echo "Excuting GenerateScripts\n";
	echo shell_exec (". Systems\CubeTool\php/scripts/GenerateScripts 2>&1");
	ob_flush();
	flush();
	echo "Excuting GenerateDatabaseTables\n";
	echo shell_exec (". Systems\CubeTool\php/scripts/GenerateDatabaseTables 2>&1");
	ob_flush();
	flush();
	echo "Excuting GenerateDatabaseViews\n";
	echo shell_exec (". Systems\CubeTool\php/scripts/GenerateDatabaseViews 2>&1");
	ob_flush();
	flush();
	echo "Excuting ImportModel\n";
	echo shell_exec (". Systems\CubeTool\php/scripts/ImportModel 2>&1");
	ob_flush();
	flush();
?>