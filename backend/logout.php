<?php
require '../smarty/Smarty.class.php';
include 'config/sconfig.php';
include 'config/dbconfig.php';

 $smarty->assign('message','');
session_start();
if(isset($_SESSION['username'])) { 
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
