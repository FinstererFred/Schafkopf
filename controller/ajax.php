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


if($action == 'delete') {
  $type = $_POST['type'];
  $id = (int)$_POST['id'];
  $mandator = $provider->getAllBy($type, array("id" => $id));
  echo $provider->deleteObj($mandator);
}

if($action == 'new') {
  $type = $_POST['type'];
  $data = json_decode($_POST['data'],true);
  $object = new $type();
  $provider->updateFromArray($object,$data);
  $resp = -1;
  $resp = $provider->saveNewObj($object);

  if($type == 'offer') {
      $offer = $provider->getAllBy('offer', array('id' => $resp));
      $offer->setAlternateURL('');
      $resp = $provider->saveObject($offer);
  }

  echo true;
}

if($action == 'getTypen') {
	$typen = $provider->getAllBy('spieltyp');

	if(!is_array($typen)) { $typen = array($typen); }

	foreach($typen as $typ) {
		$out[] = $typ->toArray();
	}

	echo json_encode($out);
}

if($action == 'getAllSpieler') {
	$spieler = $provider->getAllBy('spieler');

	$out = array();

	if(!is_array($spieler)) { $spieler = array($spieler); }

	foreach($spieler as $_spieler) {
		$out[] = $_spieler->toArray();
	}
	$out = array('data' => $out);
	echo json_encode($out);
}

if($action == 'getAllTische') {
	$tische = $provider->getAllBy('tische');

	$out = array();

	if(!is_array($tische)) { $tische = array($tische); }

	foreach($tische as $tisch) {
		$out[] = $tisch->toArray();
	}
	$out = array('data' => $out);
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

if($action == 'deleteGame') {
	$sql = "DELETE FROM ".$tablePrefix."ergebnis WHERE spielID = :id;
			DELETE FROM ".$tablePrefix."spiele WHERE id = :id";
	$stmt = $db->prepare($sql);
	$stmt->bindParam(':id', $id);
	$stmt->execute();
	echo json_encode($out);
}

if($action == 'getSummen') {
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

if($action == 'getListe') {
	$sql = 'SELECT r.spielID, r.spielerID, r.preis, t.name FROM (
			SELECT s.typID, s.timestamp, s.id AS spielID, e.spielerID, CASE WHEN gewinner THEN (CASE WHEN gew.anz = 1 THEN s.preis * 3 ELSE s.preis END)
			ELSE (CASE WHEN gew.anz = 3 THEN s.preis * -3 ELSE s.preis * -1 END) END AS preis
			FROM ergebnis e
			INNER JOIN spiele s ON e.spielID = s.id
			INNER JOIN spieler sp ON e.spielerID = sp.id
			INNER JOIN (
			SELECT spielID, SUM(gewinner) AS anz
			FROM ergebnis
			GROUP BY spielID) gew ON e.spielID = gew.spielID
			WHERE s.tischID = :id) r
			INNER JOIN spieltyp t ON r.typID = t.ID
			AND DATE(r.timestamp) = DATE(now())
			ORDER BY spielID DESC';

	$stmt = $db->prepare($sql);
	$stmt->bindParam(':id', $id);
	$stmt->execute();
	$out = array();
	while ($result = $stmt->fetch(PDO::FETCH_ASSOC)) {
		$out['s'.$result['spielID']]['name'] = $result['name'];
		$out['s'.$result['spielID']]['erg'][$result['spielerID']] = array('gewinn'  => $result['preis']);
	}

	echo json_encode($out);
}

if($action == 'getDayList') {

	$sql = "SELECT DATE_FORMAT(r.timestamp,'%d-%m-%Y') AS tag, r.spielerID, SUM(r.preis) AS spieltagsgewinn
	FROM (
		SELECT s.typID, s.timestamp, s.id AS spielID, e.spielerID, CASE WHEN gewinner THEN (CASE WHEN gew.anz = 1 THEN s.preis * 3 ELSE s.preis END)
		ELSE (CASE WHEN gew.anz = 3 THEN s.preis * -3 ELSE s.preis * -1 END) END AS preis
		FROM ergebnis e
		INNER JOIN spiele s ON e.spielID = s.id
		INNER JOIN spieler sp ON e.spielerID = sp.id
		INNER JOIN (
		SELECT spielID, SUM(gewinner) AS anz
		FROM ergebnis
		GROUP BY spielID) gew ON e.spielID = gew.spielID
		WHERE s.tischID = :id
		) r
	INNER JOIN spieltyp t ON r.typID = t.ID
	GROUP BY  DAY(r.timestamp), r.spielerID
	ORDER BY r.timestamp , spielerID";

	$stmt = $db->prepare($sql);
	$stmt->bindParam(':id', $id);
	$stmt->execute();

	$out = array();
	$spieler = array();
	while ($result = $stmt->fetch(PDO::FETCH_ASSOC)) {

		if ( ! isset($spieler[ $result['spielerID'] ])) {
 		  $spieler[ $result['spielerID'] ] = 0;
		}

		$spieler[ $result['spielerID'] ] += $result['spieltagsgewinn'];
		$out[ $result['tag'] ][] = array('id' => $result['spielerID'], 'gewinn' => $spieler[  $result['spielerID'] ]);

	}
	foreach($out as &$outLine) {
		usort($outLine, function($a, $b) {
			return $a['id'] - $b['id'];
		});
	}
	if(!isset($_GET['reverse'])) {
		$out = array_reverse($out);
	}
	echo json_encode($out);
}

if($action == 'save') {
  $data = json_decode($_POST['data'],true);
  $type = $_POST['type'];
  $object = $provider->getAllBy($type, array("id" => $data['id']));
  $provider->updateFromArray($object,$data);

  echo $provider->saveObject($object);
}


if($action == 'getChart') {
	$sql = "SELECT r.spielID, r.preis, t.name as gameID FROM (
			SELECT s.typID, s.timestamp, s.id AS spielID, e.spielerID, CASE WHEN gewinner THEN (CASE WHEN gew.anz = 1 THEN s.preis * 3 ELSE s.preis END)
			ELSE (CASE WHEN gew.anz = 3 THEN s.preis * -3 ELSE s.preis * -1 END) END AS preis
			FROM ergebnis e
			INNER JOIN spiele s ON e.spielID = s.id
			INNER JOIN spieler sp ON e.spielerID = sp.id
			INNER JOIN (
			SELECT spielID, SUM(gewinner) AS anz
			FROM ergebnis
			GROUP BY spielID) gew ON e.spielID = gew.spielID
			WHERE s.tischID = :id) r
			INNER JOIN spieltyp t ON r.typID = t.ID
			and r.spielerID = :spielerID
			ORDER BY spielID DESC";

	$stmt = $db->prepare($sql);
	$stmt->bindParam(':id', $id);
	$spielerID = (int)$_GET['spielerID'];
	$stmt->bindParam(':spielerID', $spielerID);
	$stmt->execute();

	$out = array();
	$spieler = array();
	while ($result = $stmt->fetch(PDO::FETCH_ASSOC)) {
		$out[] = $result;
	}

	echo json_encode($out);
}

