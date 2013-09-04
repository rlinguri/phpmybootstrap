<?php

/***
 * project name: phpmybootstrap
 * file name:    page.php  
 * description:  page model
 * author:       Roderic Linguri
 * date created: Tue Sep  3 06:48:06 CDT 2013
 */

require_once('/Library/WebServer/Documents/phpmybootstrap/lib/config.php');
require_once('model.php');

class PageModel extends Model {
	
	/***
	* database functions for page table
	* @param void
	* @return mixed (dictionary)
	*/
	function getPages() {
		$sql = 'SELECT * FROM page WHERE vis = 1 ORDER BY psn';
		$qrh = mysqli_query($this->lnk, $sql);
		$i = 1;
		
		// iterate and extract data to be passed to view
		while ( $res = mysqli_fetch_array($qrh)) {
			$results[] = array('id' => $res['id'],'name' => $res['nam']);
			$i++;
		}
		
		return $results;
		
	}

}


?>
