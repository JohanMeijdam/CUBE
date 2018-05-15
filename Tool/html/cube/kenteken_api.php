<?php

include 'ApiKeys.php';

$requestText = file_get_contents('php://input');
$requestObj = json_decode($requestText, false);

$curl = curl_init();

curl_setopt_array($curl, array(
	CURLOPT_URL => "https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=".urlencode($requestObj->kenteken),
	CURLOPT_RETURNTRANSFER => true,
	CURLOPT_ENCODING => "",
	CURLOPT_MAXREDIRS => 10,
	CURLOPT_TIMEOUT => 30,
	CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
	CURLOPT_CUSTOMREQUEST => "GET"
));

$response = curl_exec($curl);
$info = curl_getinfo($curl);
curl_close($curl);

$obj = json_decode($response, false);
$responseObj = new \stdClass();
$responseObj->merk = $obj[0]->merk;
$responseObj->handelsbenaming =  $obj[0]->handelsbenaming;
$responseObj->aantal_cilinders =  $obj[0]->aantal_cilinders;
$responseObj->aantal_deuren =  $obj[0]->aantal_deuren;
$responseText = json_encode($responseObj);
echo $responseText;
http_response_code($info["http_code"]);

?>
