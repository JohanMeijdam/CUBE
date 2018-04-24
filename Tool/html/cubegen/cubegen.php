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

exec ('perl CubeGen.pl '.$tmpModel.' '.$tmpTempl.' '.$tmpCode);
$handleCode = fopen($tmpCode, "r");
$code = fread($handleCode, filesize($tmpCode));

echo $code;
fclose($handleCode);

unlink($tmpModel);
unlink($tmpTempl);
unlink($tmpCode);

?>