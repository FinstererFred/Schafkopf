<?php

include '../controller/dbconfig.php';
include '../controller/common.php';
include '../controller/ergebnis.php';
include '../controller/spiele.php';
include '../controller/spieler.php';
include '../controller/spieltyp.php';
include '../controller/tische.php';

$provider = new DBProvider($db, $tablePrefix);

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


if($action == 'getSummenR') {
	$sql = "SELECT sum(preis) as stand, spielerID from (
		SELECT e.spielerID, CASE WHEN gewinner THEN (CASE WHEN gew.anz = 1 THEN s.preis * 3 ELSE s.preis END)
		ELSE (CASE WHEN gew.anz = 3 THEN s.preis * -3 ELSE s.preis * -1 END) END AS preis
		FROM ".$tablePrefix."ergebnis e
		INNER JOIN ".$tablePrefix."spiele s ON e.spielID = s.id
		INNER JOIN ".$tablePrefix."spieler sp ON e.spielerID = sp.id
		INNER JOIN (
		SELECT spielID, SUM(gewinner) AS anz
		FROM ".$tablePrefix."ergebnis
		GROUP BY spielID) gew ON e.spielID = gew.spielID
		WHERE s.tischID = :id) result
		group by spielerID";
	$stmt = $db->prepare($sql);
	$stmt->bindParam(':id', $id);
	$stmt->execute();
	$out = array();
	while ($result = $stmt->fetch(PDO::FETCH_ASSOC)) {
		$out[$result['spielerID']] = $result['stand'];
	}
	
	echo json_encode($out);
}
