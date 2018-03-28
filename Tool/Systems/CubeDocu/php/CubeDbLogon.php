<?php
$conn = oci_pconnect("cubedocu", "composys", "//localhost:1521/composys");
$stid = oci_parse($conn, "ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY'");
oci_execute($stid);
$stid = oci_parse($conn, "ALTER SESSION SET NLS_NUMERIC_CHARACTERS=',.'");
oci_execute($stid);
?>
