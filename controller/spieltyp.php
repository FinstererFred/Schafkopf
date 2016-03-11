<?php

class spieltyp extends qrClass
{
	private $id;
  	private $name;
  	private $grundtarif;
	
	function __construct($id = NULL, $name = NULL, $grundtarif = NULL)
	{
		$this->id = $id;
    	$this->tischID = $name;
		$this->grundtarif = $grundtarif;
	}

  public function getId() {
    return $this->id;
  }

  public function getName() {
    return $this->name;
  }

  public function getGrundtarif() {
    return $this->grundtarif;
  }  

  public function setId($id) {
    $this->id = $id;
  }

  public function setName($name) {
    $this->name = $name;
  }

  public function setGrundtarif($grundtarif) {
    $this->grundtarif = $grundtarif;
  }  

}