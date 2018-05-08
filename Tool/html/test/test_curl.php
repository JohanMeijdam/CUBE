<?php

include 'ApiKeys.php';

// header("Content-Type: application/json; charset=UTF-8");
$requestText = file_get_contents('php://input');
$requestObj = json_decode($requestText, false);

$curl = curl_init();

curl_setopt_array($curl, array(
//  CURLOPT_URL => "https://opendata.rijksoverheid.nl/v1/sources/rijksoverheid/infotypes/schoolholidays?output=json",
//  CURLOPT_URL => "https://opendata.rijksoverheid.nl/v1/sources/rijksoverheid/infotypes/ministry/?output=json",
//  CURLOPT_URL => "https://api.overheid.io/openkvk?filters[postcode]=2587RV",
//  CURLOPT_URL => "https://bag.basisregistraties.overheid.nl/api/v1/id/nummeraanduiding/0150200000036467",
//  CURLOPT_URL => "https://api.postcodeapi.nu/v2/addresses/?postcode=2587RV&number=8",
//  CURLOPT_URL => "https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=KL237Z",
  CURLOPT_URL => "https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=".urlencode($requestObj->kenteken),
  CURLOPT_RETURNTRANSFER => true,
  CURLOPT_ENCODING => "",
  CURLOPT_MAXREDIRS => 10,
  CURLOPT_TIMEOUT => 30,
  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
  CURLOPT_CUSTOMREQUEST => "GET",
  CURLOPT_HTTPHEADER => array(
   "accept:application/hal+json",
//  "x-api-key:" . $OverheidKey
   "x-api-key:" . $KadasterKey
  )
));

$response = curl_exec($curl);
$info = curl_getinfo($curl);
$err = curl_error($curl);

curl_close($curl);

if ($err) {
	echo '[{"curl_error":"' . $err . '"}]';
} else {
	$obj = json_decode($response, false);
	$responseObj = new \stdClass();
	$responseObj->merk = $obj[0]->merk;
	$responseObj->handelsbenaming =  $obj[0]->handelsbenaming;
	$responseObj->aantal_cilinders =  $obj[0]->aantal_cilinders;
	$responseObj->aantal_deuren =  $obj[0]->aantal_deuren;
	$responseText = json_encode($responseObj);
	echo $responseText;
	http_response_code($info["http_code"]);
}

?>
