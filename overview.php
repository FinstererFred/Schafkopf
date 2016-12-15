<?php

	require 'smarty/Smarty.class.php';
	include 'backend/config/sconfig.php';
	include 'controller/dbconfig.php';
	include 'controller/common.php';
	include 'controller/tische.php';
	include 'controller/spieler.php';
	include 'controller/spiele.php';

	session_start();
	

	$username = (isset($_POST["username"])) ? $_POST["username"] : '';
	$password = (isset($_POST["password"])) ? $_POST["password"] : '';
	$message = '';
	$smarty->assign('template', 'overview');
	
	if(!isset($_SESSION['user'])) 
	{
		if(!LoginDBCheck($db, $username, $password)) {
			$smarty->assign('message', $message);
			$smarty->display('login.tpl');		
			exit;
		}

	}
	
	$smarty->assign('loggedinUser', $_SESSION['user']['id']);
		
	$smarty->display('overview.tpl');
?>