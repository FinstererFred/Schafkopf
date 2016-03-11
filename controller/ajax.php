<?php

include '../controller/dbconfig.php';
include '../controller/common.php';
include '../controller/ergebnis.php';
include '../controller/spiele.php';
include '../controller/spieler.php';
include '../controller/spieltyp.php';
include '../controller/tische.php';

$provider = new DBProvider($db);

$action = $_GET['action'];
$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if($action == 'getSpieler') {
  $spieler = $provider->getAllBy('spieler', array("id" => $id));
  echo json_encode($spieler->toArray());
}