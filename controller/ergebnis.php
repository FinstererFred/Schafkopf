<?php

class ergebnis extends qrClass
{
	private $id;
  private $spielID;
  private $spielerID;
	private $gewinner;
  public $sorting;
	

	function __construct($id = NULL, $spielID = NULL, $spielerID = NULL, $gewinner = NULL)
	{
		$this->id = $id;
    $this->spielID = $spielID;
		$this->spielerID = $spielerID;
		$this->gewinner = $gewinner;
	  $this->sorting = '';
  }


  public function getId() {
    return $this->id;
  }

  public function getSpielId() {
    return $this->spielID;
  }

  public function getSpielerId() {
    return $this->spielerID;
  }

  public function getGewinner() {
    return $this->gewinner;
  }

  public function setId($id) {
    $this->id = $id;
  }

  public function setSpielId($spielID) {
    $this->spielID = $spielID;
  }

  public function setSpielerId($spielerID) {
    $this->spielerID = $spielerID;
  }

  public function setGewinner($gewinner) {
    $this->gewinner = $gewinner;
  }

}
