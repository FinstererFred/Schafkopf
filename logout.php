<?php
require 'smarty/Smarty.class.php';
include 'backend/config/sconfig.php';
include 'controller/dbconfig.php';
include 'controller/common.php';
include 'controller/tische.php';
include 'controller/spieler.php';
include 'controller/spiele.php';

$smarty->assign('message','');
session_start();
if(isset($_SESSION['user'])) { 
	$smarty->assign('message','logout');
}	

$_SESSION = array();

if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000, $params["path"],
        $params["domain"], $params["secure"], $params["httponly"]
    );
}

session_destroy();

$smarty->display('login.tpl');
