<?php

session_start();
if(!isset($_SESSION['username'])) {
	$smarty->assign('message','error');
	$smarty->display('login.tpl');
	exit;
}
include 'config/dbconfig.php';


$provider = new DBProvider($db);

$mandators = $provider->getAllBy('mandator');

$temp = array();
if(!is_array($mandators)){
	$temp = $mandators;
	$mandators = array();
	$mandators[] = $temp;
}

foreach ($mandators as $key => $mandator) {
  $mandator->setStartdate( date('d.m.Y', strtotime($mandator->getStartdate())) );
  $mandator->setEnddate( date('d.m.Y', strtotime($mandator->getEnddate())) );
  $out[] = $mandator->toArray();
}

$smarty->assign('objects', $out);
$smarty->assign('objectsJSON', json_encode($out));
$smarty->display('mandators.tpl');
