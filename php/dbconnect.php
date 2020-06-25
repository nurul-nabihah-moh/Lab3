<?php
$servername = "localhost";
$username   = "saujanae_adminFastingHealth";
$password   = "fUb?aVz_k[CC";
$dbname     = "saujanae_FastingHealth";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>