<?php

/*
 * project name: phpmybootstrap
 * file name:    view.php 
 * description:  abstract view
 * author:       Roderic Linguri
 * date created: Tue Sep  3 06:48:06 CDT 2013
 */

require_once('/Library/WebServer/Documents/phpmybootstrap/lib/config.php');

class View {

	// public view properties
	public $pageTitle;
	public $pages; // array of page names
	public $sections; // array of content containers
	
	// html DOM object
	protected $hto;
	protected $htc;

	// head DOM object
	protected $heo;
	protected $hec;

	// body DOM object
	protected $bdo;
	protected $bdc;

	// nav DOM object
	protected $nvo;
	protected $nvd;
	protected $nvc;

	// container DOM object
	protected $cto;
	protected $ctd;
	protected $ctc;
	
	/* constructor automatically loads default view settings */
	function __construct() {
		$this->hto = '<!DOCTYPE HTML>
<html lang="en">
';
		$this->heo = '  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="'.DSC.'">
    <meta name="author" content="'.AUT.'">
    <link rel="shortcut icon" href="ico/favicon.png">
    <title>'.NAM.' : ';
		$this->hec = '</title>
    <link href="css/bootstrap.css" rel="stylesheet">
    <link href="css/phpmybootstrap.css" rel="stylesheet">
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="js/html5shiv.js"></script>
      <script src="js/respond.min.js"></script>
    <![endif]-->
  </head>
';
		$this->bdo = '  <body>
    ';
		$this->nvo = '<div class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">'.NAM.'</a>
        </div>
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav">';
		$this->nvc = '          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </div>
';
		$this->cto = '    <div class="container">
';
		$this->ctc = '    </div><!--container-->
';
		$this->bdc = '    <script src="js/jquery.js"></script>
    <script src="js/bootstrap.js"></script>
  </body>
';
		$this->htc = '</html>';
	} // end constructor
	
	/* construct output string
	 * @param void
	 * @return string (html page)
	 */		
	public function getOutput() {
	
		// iterate through page links and build up navbar
		foreach ($this->pages as $page) {
			$this->nvd .= '<li';
			if ($page['name'] == $this->pageTitle) {
				$this->nvd .= ' class="active"';
			}
			$this->nvd .= '><a href="index.php?id='.$page['id'].'">'.$page['name'].'</a></li>';
		} // end nav loop
		
		// loop through content array and build up sections
		foreach ($this->sections as $section) {
			$this->ctd .= '    <'.$section['tag'];
			if ($section['class']) {
				$this->ctd .= ' class="'.$section['class'].'"';
			}
			$this->ctd .= '>'.$section['data'].'</'.$section['tag'].'>
';
		} // end sections loop
		// begin assembling output
		
		$out = '';
		$out .= $this->hto;
		$out .= $this->heo;
		$out .= $this->pageTitle;
		$out .= $this->hec;
		$out .= $this->bdo;
		$out .= $this->nvo;
		$out .= $this->nvd;
		$out .= $this->nvc;
		$out .= $this->cto;
		$out .= $this->ctd;
		$out .= $this->ctc;
		$out .= $this->bdc;
		$out .= $this->htc;
		
		//	
		return $out;
	
	} // end getOutput()

}


?>
