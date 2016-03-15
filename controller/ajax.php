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

if($action == 'getTypen') {
	$typen = $provider->getAllBy('spieltyp');
	
	if(!is_array($typen)) { $typen = array($typen); }

	foreach($typen as $typ) {
		$out[] = $typ->toArray();
	}

	echo json_encode($out);
}

if($action == 'getTische') {
	$tische = $provider->getAllBy('tische', array('verantwortlicher' => $id));
	
	$out = array();

	if(!is_array($tische)) { $tische = array($tische); }

	foreach($tische as $tisch) {
		$out[] = $tisch->toArray();
	}

	echo json_encode($out);
}	

if($action == 'getTisch') {
	$tische = $provider->getAllBy('tische', array('id' => $id));
	
	$out = array();

	if(!is_array($tische)) { $tische = array($tische); }

	$i = 0;
	foreach($tische as $tisch) {
		$out[$i]['tisch'] = $tisch->toArray();
		$ids = $out[$i]['tisch']['sp1'].','.$out[$i]['tisch']['sp2'].','.$out[$i]['tisch']['sp3'].','.$out[$i]['tisch']['sp4'];
		$out[$i]['spieler'] = $provider->getTischSpielerDetails($ids);

		$i++;
	}

	echo json_encode($out);
}	

if($action == 'saveGame') {
	$data = json_decode($_POST['data']);

	$spiel = new spiele();
	$provider->updateFromArray($spiel, $data);
	$spielID = $provider->saveNewObj($spiel);

	$spieler = $data->winner;

	foreach ($spieler as $value) {
		$ergebnis = new ergebnis();
		$value->spielID = $spielID;
		$provider->updateFromArray($ergebnis, $value);
		$provider->saveNewObj($ergebnis);
	}

	echo "ok";

}

if($action == 'getSummen') {
	$sql = 'select er.spielerID, sp.preis, er.spielID, er.gewinner from tische left join spiele sp on sp.tischID = tische.id left join ergebnis er on er.spielID = sp.id where tische.id = 2';
	$stmt = $db->prepare($sql);
	$stmt->execute();

	$arr = array();
	$grp = -1;
	$preis = 0;
	$winner = 0;
	$tempwinner = [];
	$first = true;
	$i = 0;
	$lastpreis = 0;
	$verlierer = 0;
	while ($result = $stmt->fetch(PDO::FETCH_ASSOC))
   	{ 
		
   		if(empty($arr[$result['spielerID']])) {
   			$arr[$result['spielerID']] = 0;
   		}

		if($preis == 0) {
			$preis = $result['preis'];
			$grp = $result['spielID'];
		}

   		
   		if($i > 0 && $grp != $result['spielID'] ) {
   			foreach($tempwinner as $twinner) {
   				$arr[$twinner] += $preis * count($temploser);
  			}

			foreach($temploser as $tloser) {
   				$arr[$tloser] -= count($tempwinner) > 2 ? $preis * 3 : $preis;
  			}

  			$tempwinner = array();
  			$temploser = array();
  			$preis = $result['preis'];
   			$grp = $result['spielID'];
	   		$winner = 0;
	   		$verlierer = 0;
	   	}
   	
   		if($result['gewinner'] == 0) {
   			$temploser[] = $result['spielerID'];
   		} else {
   			$tempwinner[] = $result['spielerID']; 
   		}

   		$lastpreis = $result['preis'];
   		$i++;
   	}

   	foreach($tempwinner as $twinner) {
		$arr[$twinner] +=  $lastpreis * count($temploser);
	}

	foreach($temploser as $loser) {
   		$arr[$loser] -= count($tempwinner) > 2 ? $preis * 3 : $preis;
  	}

   	var_dump($arr);
}
