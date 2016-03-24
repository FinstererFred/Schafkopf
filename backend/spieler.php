<?php


require '../smarty/Smarty.class.php';
include 'config/sconfig.php';
include '../controller/dbconfig.php';
include '../controller/common.php';
include '../controller/spieler.php';


$provider = new DBProvider($db,'');

$spieler = $provider->getAllBy('spieler');

if(!is_array($spieler)){
	$spieler = array($spieler);
}

$out_spieler = array();
foreach ($spieler as $key => $spieleR) {
  $out_spieler[] = $spieleR->toArray();
}

$smarty->assign('objects', $out_spieler);
$smarty->assign('objectsJSON', json_encode($out_spieler));
$smarty->display('spieler.tpl');
