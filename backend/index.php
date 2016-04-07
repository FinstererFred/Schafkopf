<?php
require '../smarty/Smarty.class.php';
include 'config/sconfig.php';
include '../controller/dbconfig.php';
include '../controller/common.php';
include '../controller/tische.php';
include '../controller/spieler.php';
include '../controller/spiele.php';

session_start();

if(!isset($_SESSION['user'])) 
{
	$username = (isset($_POST["username"])) ? $_POST["username"] : '';
	$password = (isset($_POST["password"])) ? $_POST["password"] : '';
	
	$message = '';

	if($username != '' && $password != '' && !LoginDBCheck($db, $username, $password)) {
		$message = 'error';
		$smarty->assign('message', $message);
		$smarty->display('login.tpl');		
		exit;	
	} 
}

$provider = new DBProvider($db,'');

$tische = $provider->getAllBy('tische');
$spieler = $provider->getAllBy('spieler');
$spiele = $provider->getAllBy('spiele');

$smarty->assign('tischCount', count($tische));
$smarty->assign('spieleCount', count($spiele));
$smarty->assign('spielerCount', count($spieler));

$smarty->display('dashboard.tpl');

?>
