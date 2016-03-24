<?php

class spieler extends qrClass
{
	private $id;
  private $name;
	private $kurz;
	private $password;
  public $sorting;


	function __construct($id = NULL, $name = NULL, $kurz = NULL, $password = NULL)
	{
		$this->id = $id;
		$this->name = $name;
		$this->kurz = $kurz;
		$this->password = $password;
    $this->sorting = 'kurz';
	}

  public function getId() {
    return $this->id;
  }

  public function getName() {
    return $this->name;
  }

  public function getKurz() {
    return $this->kurz;
  }

	public function getPassword() {
    return $this->password;
  }

  public function setId($id) {
    $this->id = $id;
  }

  public function setName($name) {
    $this->name = $name;
  }

  public function setKurz($kurz) {
    $this->kurz = $kurz;
  }

	public function setPassword($password) {
    $this->password = $password;
  }

}
