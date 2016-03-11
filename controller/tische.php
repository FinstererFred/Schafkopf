<?php

class tische extends qrClass
{
	private $id;
  	private $name;
  	private $sp1;
  	private $sp2;
  	private $sp3;
  	private $sp4;
	
	function __construct($id = NULL, $name = NULL, $sp1 = NULL, $sp2 = NULL, $sp3 = NULL, $sp4 = NULL)
	{
		$this->id = $id;
    	$this->tischID = $name;
		$this->sp1 = $sp1;
		$this->sp2 = $sp2;
		$this->sp3 = $sp3;
		$this->sp4 = $sp4;
	}

  public function getId() {
    return $this->id;
  }

  public function getName() {
    return $this->name;
  }

  public function getSp1() {
    return $this->sp1;
  }

  public function getSp2() {
    return $this->sp2;
  }

  public function getSp3() {
    return $this->sp3;
  }

  public function getSp4() {
    return $this->sp4;
  }

  public function setId($id) {
    $this->id = $id;
  }

  public function setName($name) {
    $this->name = $name;
  }

  public function setSp1($sp1) {
    $this->sp1 = $sp1;
  }
  
  public function setSp2($sp2) {
    $this->sp2 = $sp2;
  }

  public function setSp3($sp3) {
    $this->sp3 = $sp3;
  }

  public function setSp4($sp4) {
    $this->sp4 = $sp4;
  }
}