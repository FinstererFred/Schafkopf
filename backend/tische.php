<?php


require '../smarty/Smarty.class.php';
include 'config/sconfig.php';
include '../controller/dbconfig.php';
include '../controller/common.php';
include '../controller/tische.php';
include '../controller/spieler.php';


$provider = new DBProvider($db,'');

$tische = $provider->getAllBy('tische');

if(!is_array($tische)){
	$tische = array($tische);
}

$out = array();
foreach ($tische as $key => $tisch) {
  $out[] = $tisch->toArray();
}

$spieler = $provider->getAllBy('spieler');

if(!is_array($spieler)){
	$spieler = array($spieler);
}

$out_spieler = array();
foreach ($spieler as $key => $spieleR) {
  $out_spieler[] = $spieleR->toArray();
}

$smarty->assign('objects', $out);
$smarty->assign('spieler', $out_spieler);
$smarty->assign('objectsJSON', json_encode($out));
$smarty->display('tische.tpl');
