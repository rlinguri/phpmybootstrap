<?php

/***
 * project name: phpmybootstrap
 * file name:    section.php  
 * description:  section model
 * author:       Roderic Linguri
 * date created: Tue Sep  3 06:48:06 CDT 2013
 */

require_once('/Library/WebServer/Documents/phpmybootstrap/lib/config.php');
require_once('model.php');

class SectionModel extends Model {

	// properties
	public $id;
	
	/***
	* database functions for section table
	* @param void
	* @return mixed (dictionary)
	*/
	function getSections() {
		$sql = 'SELECT * FROM section WHERE page = '.$this->id.' ORDER BY psn';
		$qrh = mysqli_query($this->lnk, $sql);
		$i = 1;
		
		// iterate and extract data to be passed to view
		while ( $res = mysqli_fetch_array($qrh) ) {
			$results[] = array('tag' => $res['tag'],'class' => $res['cla'], 'data' => $res['dta']);
			$i++;
		}
		
		return $results;
		
	}
	
	/***
	* database lookup for title to display on page
	* @param void
	* @return string (pageTitle)
	*/
	function getPageTitle() {
		$sql = 'SELECT * FROM page WHERE id = '.$this->id.' LIMIT 1';
		$qrh = mysqli_query($this->lnk, $sql);
		$res = mysqli_fetch_array($qrh);
		return $res['nam'];
	}

}


?>
