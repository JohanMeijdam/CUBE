<?php
	echo "TEST1";
	ob_flush();
	flush();
	sleep(3);
	echo shell_exec (". /Systems/CubeTool/scripts/CubeToolGenerate.sh 2>&1");
	ob_flush();
	flush();
	sleep(3);
	echo "TEST2";
	ob_flush();
	flush();
?>