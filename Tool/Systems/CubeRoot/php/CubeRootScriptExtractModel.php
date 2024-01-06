<?php
	echo "Excuting ExtractModel\n";
	echo shell_exec (". Systems\CubeRoot\php/scripts/ExtractModel 2>&1");
	ob_flush();
	flush();
?>