<?php
require '../smarty/Smarty.class.php';
include 'config/sconfig.php';
include '../controller/dbconfig.php';
include '../controller/common.php';
include '../controller/tische.php';
include '../controller/spieler.php';
include '../controller/spiele.php';

// session_start();

// if(!isset($_SESSION['username'])) {
	// $username = (isset($_POST["username"])) ? $_POST["username"] : '';
	// $password = (isset($_POST["password"])) ? $_POST["password"] : '';

	// if (isset($_GET['login'])){
		// if (empty($username) OR empty($password)){
			// echo "fehler";
			// echo "<br />Login Maske anzeigen";
			// exit;
		// }
		// else {
			// $count = LoginDBCheck($db, $username, $password);
			// if ($count >= 1) {
				// $_SESSION['username'] = $username;
			// }
			// else {
				// echo "fehler";
				// echo "<br />Login Maske anzeigen";
				// exit;
			// }
		// }
	// }
	// else {
		// echo "XXX";
		// echo "<br />Login Maske anzeigen";
		// exit;
	// }
// }

$provider = new DBProvider($db,'');

$tische = $provider->getAllBy('tische');
$spieler = $provider->getAllBy('spieler');
$spiele = $provider->getAllBy('spiele');

$smarty->assign('tischCount', count($tische));
$smarty->assign('spieleCount', count($spiele));
$smarty->assign('spielerCount', count($spieler));

$smarty->display('dashboard.tpl');

?>
