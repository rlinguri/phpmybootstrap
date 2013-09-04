<?php

/*
 * project name: phpmybootstrap
 * file name:    controller.php  
 * description:  default controller
 * author:       Roderic Linguri
 * date created: Tue Sep  3 06:48:06 CDT 2013
 */

require_once('/Library/WebServer/Documents/phpmybootstrap/lib/config.php');
require_once(PTH.'app/view.php');
require_once(PTH.'app/page.php');
require_once(PTH.'app/section.php');

class Controller {

	// properties
	protected $gts;
	protected $pst;
	
	public function initialize($getArray,$postArray) {

		// instantiate necessary objects
		$htm = new View;
		$page = new PageModel;
		$section = new SectionModel;

		// FIRST check for POST
		
		// this conditional requires any post array to contain a key for 'id'
		if (!$postArray) {
			$postArray = NULL;
		} else {
			// form processing goes here
			$model = new PostModel;
			$model->pst = $pstArray;
			$model->processPst();
		}
		
		// SECOND check for GET
		
		// this conditional sets GET-id to 1 if none is received
		if (!$getArray) {
			$this->gts = array('id' => 1 ,'axn' => 'view');
		} else {
			$this->gts = $getArray;
		}
		
		$section->id = $this->gts['id'];
		$htm->pageTitle = $section->getPageTitle();
		$htm->sections = $section->getSections();
		$htm->pages = $page->getPages();
		
		echo $htm->getOutput();
		
		}
				
}


?>
