<?php

include 'ApiKeys.php';

// header("Content-Type: application/json; charset=UTF-8");
$requestText = file_get_contents('php://input');
$requestObj = json_decode($requestText, false);

$curl = curl_init();

curl_setopt_array($curl, array(
//  CURLOPT_URL => "https://api.postcodeapi.nu/v2/addresses?postcode=".urlencode($requestObj->postcode)."&number=".($requestObj->number),
  CURLOPT_URL => "https://postcode-api.apiwise.nl/v2/addresses?postcode=".urlencode($requestObj->postcode)."&number=".($requestObj->number),
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
	$obj = json_decode($response, false)->_embedded->addresses[0];
	$responseObj = new \stdClass();
	$responseObj->street = $obj->street;
	$responseObj->city = $obj->city->label;
	$responseText = json_encode($responseObj);
	echo $responseText;
}

?>
