<?php

/*
 * project name: phpmybootstrap
 * file name:    index.php  
 * description:  main index page and application bootstrap
 * author:       Roderic Linguri
 * date created: Tue Sep  3 06:48:06 CDT 2013
 */

require_once('/Library/WebServer/Documents/phpmybootstrap/lib/config.php');
require_once(PTH.'/app/controller.php');

// instantiate a new controller object
$controller = new Controller;

// pass get and post arrays to the controller
$controller->initialize($_GET,$_POST);


?>
