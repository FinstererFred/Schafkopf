<?php

$dbhost = '';
$dbname = '';
$dbuser = '';
$dbpw = '';

try
{
	// Connection-String erstellen
	$constr = sprintf("mysql:host=%s;port=%d;dbname=%s", $dbhost, '3306', $dbname);

	// Versuchen, eine DB-Verbindung herzustellen
	$db = new PDO($constr, $dbuser, $dbpw);

	// Errormode setzen
	$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
}
catch(PDOException $e)
{
	// Fehler beim Verbinden -> Skript beenden
	// $logger->debug("Kann keine Verbindung zur Datenbank herstellen: " . $e->getMessage());
	die ($e->getMessage());
}
