<?php

include '../controller/dbconfig.php';
include '../controller/spieler.php';

$provider = new DBProvider($db);

$action = $_GET['action'];
$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if($action == 'getSpieler') {
  $mandator = $provider->getAllBy('spieler', array("id" => $id));
}
