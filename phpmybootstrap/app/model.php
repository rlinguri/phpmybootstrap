<?php

/***
 * project name: phpmybootstrap
 * file name:    model.php  
 * description:  abstract model
 * author:       Roderic Linguri
 * date created: Tue Sep  3 06:48:06 CDT 2013
 */

require_once('/Library/WebServer/Documents/phpmybootstrap/app/model.php');

abstract class Model {

	protected $lnk;
		
	/***
	* automatic database connection upon instantiation
	* @param void
	* @return void
	*/
	function __construct() {
		$this->lnk = mysqli_connect(HST,USN,PSW,DBS);
	}

	function __clone() {
		// empty clone to prevent duplicate connections
	}

}


?>
