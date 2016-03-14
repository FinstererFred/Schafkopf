<?php

class spiele extends qrClass
{
	private $id;
  private $tischID;
  private $typID;
	private $preis;
	private $timestamp;
  public $sorting;
	

	function __construct($id = NULL, $tischID = NULL, $typID = NULL, $preis = NULL, $timestamp = NULL)
	{
		$this->id = $id;
    $this->tischID = $tischID;
		$this->typID = $typID;
		$this->preis = $preis;
		$this->timestamp = $timestamp;
    $this->sorting = "timestamp DESC";
	}

  public function getId() {
    return $this->id;
  }

  public function getTischId() {
    return $this->tischID;
  }

  public function getTypId() {
    return $this->typID;
  }  

  public function getPreis() {
    return $this->preis;
  }

  public function getTimestamp() {
    return $this->timestamp;
  }

  public function setId($id) {
    $this->id = $id;
  }

  public function setTischId($tischID) {
    $this->tischID = $tischID;
  }

  public function setTypId($typID) {
    $this->typID = $typID;
  }  

  public function setPreis($preis) {
    $this->preis = $preis;
  }  
  
  public function setTimestamp($timestamp) {
    $this->timestamp = $timestamp;
  }    
}