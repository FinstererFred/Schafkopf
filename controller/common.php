<?php

class DBProvider {

	protected $db;

	public function __construct($db, $prefix)
	{
		$this->db = $db;
		$this->tablePrefix = $prefix;
	}

 	public function getAllBy($class,$array='')
  	{

		$out = '';
		if(is_array($array)) {
			foreach($array as $key => $value) {
				if(property_exists($class, $key)) {
					if(!is_array($value)) {
						$out .= ' AND '.$key.' = :'.$key;
					} else {
						$range = array_map(function($i) { return ':i'.$i; }, range(0,count($value)) );
						$out .= ' AND '.$key.' IN ('.implode(',', $range).')';
					}
				}
			}

			$sorting = new $class;
			$sorting = $sorting->getSorting();

			if($out != '') {
				$sql = "SELECT * FROM ".$this->tablePrefix.$class." WHERE 1=1 ".$out;
				if($sorting != '') {
					$sql .= ' ORDER BY '.$sorting;
				}
			} else {
				return array();
			}

			$stmt = $this->db->prepare($sql);
			foreach($array as $key => &$value) {
				if(property_exists($class, $key)) {
					$stmt->bindParam(':'.$key, $value);
				}
	    }

		} else {
			$sql = "SELECT * from ".$this->tablePrefix.$class;
			$stmt = $this->db->prepare($sql);
		}

		try {
			$stmt->execute();
		} catch (Exception $e) {
			return $e->getMessage();
		}

		$arr = array();
		while ($result = $stmt->fetch(PDO::FETCH_ASSOC))
   		{
			$obj = new $class;
			foreach($result as $key => $value) {
				$func = 'set'.ucwords($key);
				if(method_exists($obj, $func)) {
					if(strpos($key, 'date') > -1) {
						if ($class == 'lottery'){
							$value = date('d.m.Y \- H:i \U\h\r', strtotime($value));
						}
						else {
							$value = date('d.m.Y', strtotime($value));
						}
					}
					$obj->$func($value);
				}
			}

			$arr[] = $obj;
   		}

		if(count($arr) > 1) {
			return $arr;
		}
		else {
			if(count($arr)>0){
				return $arr[0];
			}
			else {
				return false;
			}
		}
  	}

	public function saveObject($obj)
	{
		$array	 = $obj->toArray();
		$class = get_class($obj);
		$out = array();

		$sorting = new $class;
		$sorting = $sorting->getSorting();

		foreach($array as $key => $value) {
			if($key != 'id' && $key != 'sorting') {
				$out[] = $key.' = :'.$key;
			}
		}
		$out = implode(', ',$out);

		$sql = "UPDATE ".$this->tablePrefix.$class." SET ".$out." WHERE id = :id";

		$stmt = $this->db->prepare($sql);

		foreach($array as $key => &$value) {
			$func = 'set'.ucwords($key);
			if(property_exists($class, $key)&& method_exists($class, $func)) {
				if(!isset($value)) { $value = NULL; }

					if(strpos($key, 'date') > -1) {
						$value = date('Y-m-d', strtotime($value));
					}
					$stmt->bindParam(":".$key, $value);

			}
    }

		try {
			$stmt->execute();
		} catch (Exception $e) {
			return $e->getMessage();
		}

		return true;
	}

	public function saveNewObj($obj)
	{
		$array	 = $obj->toArray();
		$class = get_class($obj);
		$out = array();
		$out2 = array();

		$sorting = new $class;
		$sorting = $sorting->getSorting();

		foreach($array as $key => $value) {
			if($key != 'id' && $key != 'sorting') {
				$out[] = ':'.$key;
				$out2[] = $key;
			}
		}
		$out = implode(', ',$out);
		$out2 = implode(', ',$out2);

		$sql = "INSERT INTO ".$this->tablePrefix.$class." (".$out2.") VALUES (".$out.");";
		$stmt = $this->db->prepare($sql);

		foreach($array as $key => &$value) {
			$func = 'set'.ucwords($key);
			if(property_exists($class, $key)&& method_exists($class, $func)) {
				if($key != 'id') {
					if(!$value) $value = NULL;
					if(strpos($key, 'timestamp') > -1) {

						$date = new DateTime($value);
						$value = $date->format('Y-m-d H:i:s');

					}
					$stmt->bindParam(":".$key, $value);
				}
			}
    	}

		try {
			$stmt->execute();
		} catch (Exception $e) {
			return $e->getMessage();
		}

		return $this->db->lastInsertId();
	}

	public function deleteObj($obj)
	{
		$class = get_class($obj);
		$id = $obj->getId();
		$sql = "DELETE FROM ".$this->tablePrefix.$class." WHERE id = :id LIMIT 1";
		$stmt = $this->db->prepare($sql);
		$stmt->bindParam(":id", $id);

		try {
			$stmt->execute();
		} catch (Exception $e) {
			return $e->getMessage();
		}

		return true;
	}

	public function updateFromArray(&$obj, $data)
	{
		foreach($data as $key => $value) {
			$func = 'set'.ucwords($key);
			if(method_exists($obj, $func)) {
				$obj->$func($value);
			}
		}
	}

	public function getTischSpielerDetails($ids) {
		$sql = "SELECT * from ".$this->tablePrefix."spieler where id in (".$ids.")";

		$stmt = $this->db->prepare($sql);
		$stmt->execute();
		$out = array();

		while ($result = $stmt->fetch(PDO::FETCH_ASSOC))
   		{
   			$out[] = $result;

   		}
   		return $out;
	}
}

class qrClass {

  public function toArray() {

    $className = get_class($this);
    $array = (array) $this;
    unset($array['private'], $array['privateagain']);

    $out = array();

    foreach ($array as $key => $value) {
      $newKey = trim(str_replace($className, '', $key));
      $out[$newKey] = $value;
    }
    return $out;
  }

	public function getSorting() {
		return $this->sorting;
	}
}

function convertToWindowsCharset($string) {
  $charset =  mb_detect_encoding(
    $string,
    "UTF-8, ISO-8859-1, ISO-8859-15",
    true
  );

  $string =  mb_convert_encoding($string, "Windows-1252", $charset);
  return $string;
}

function LoginDBCheck($db, $username, $password) {
	$password = md5($password);

	$sql = "SELECT * FROM spieler WHERE kurz = :name AND password = :password";
	$stmt = $db->prepare($sql);
	$user = strtoupper($username);
	$stmt->bindParam(':name', $user );
	$stmt->bindParam(':password', $password);
	$stmt->execute();
	$count = $stmt->rowCount();
	
	if($count == 0) {
		return false;	
	} else {
	
		while ($result = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$user = array('id' => $result['id'], 'name' => $result['name'], 'kurz' => $result['kurz']);
		}
		$_SESSION['user'] = $user;
		return true;
	}

	
}
