<?php

$tmpModel = tempnam("tmp", "Model");
$tmpTempl = tempnam("tmp", "Templ");
$tmpCode = tempnam("tmp", "Code");

$handleModel = fopen($tmpModel, "w");
$handleTempl = fopen($tmpTempl, "w");

$import = explode("<|||>",file_get_contents('php://input'));

fwrite ($handleModel,$import[0]);
fwrite ($handleTempl,$import[1]);

fclose($handleModel);
fclose($handleTempl);

if (strpos($import[1], '[[EVAL') !== false || strpos($import[1], '[[DECL') !== false || strpos($import[1], ':EVAL') !== false || strpos($import[1], '[[FILE') !== false) {
    echo 'For security reasons the eval and file functions are not allowed here!!!';
} else { 
	exec ('perl CubeGen.pl '.$tmpModel.' '.$tmpTempl.' '.$tmpCode);
	$handleCode = fopen($tmpCode, "r");
	$code = fread($handleCode, filesize($tmpCode));

	echo $code;
	fclose($handleCode);
}
unlink($tmpModel);
unlink($tmpTempl);
unlink($tmpCode);

?>