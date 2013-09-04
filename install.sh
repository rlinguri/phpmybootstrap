#! /usr/bin/env bash

# variables
# a project author
# d current date
# h project hostname
# j project name
# p user password
# u mysql root username
# r root password
# s source
# t project title

clear
export PS1="\e[0;35m[\u@\h \W]\$ \e[m "
echo "Welcome to the phpMyBootstrap installer."
d="$(date)";
printf "What this the full path to the parent directory? \n(A new directory containing the project will be created therein. \nNo trailing slash, please.) "
read k
printf "What is the short name of this project? \n(also the name of the project directory within the above path) "
read j
printf "What is the verbose title of this project? "
read t
printf "Who is the author? "
read a
printf "Please enter a new password for the MySQL project user: "
read p

echo "CREATE PROJECT DIRECTIVE"
echo "Project Name:    $j"
echo "MySQL DB Name:   $j"
echo "MySQL User:      $j"
echo "$j password ******"
echo "Path to Project: $k/$j"
echo "-----FILE HEADERS-----"
echo "Project Title:   $t"
echo "Project Author:  $a"
echo "Creation Date:   ${d}"


read -p "Is this okay? (y/n) " RESP
if [ "$RESP" = "y" ]; then

	# create directory structure
	mkdir $k/$j
	mkdir -p $k/$j/app
	mkdir -p $k/$j/lib
	mkdir -p $k/$j/lib/sh
	mkdir -p $k/$j/lib/sql
	mkdir -p $k/$j/web/img

	# create .htaccess files
	echo "Deny from all" > $k/$j/app/.htaccess
	echo "Deny from all" > $k/$j/lib/.htaccess
	echo "Deny from all" > $k/$j/lib/sh/.htaccess
	echo "Deny from all" > $k/$j/lib/sql/.htaccess

	# copy Bootstrap assets
	cp -R $PWD/assets/css $k/$j/web/css
	cp -R $PWD/assets/fonts $k/$j/web/fonts
	cp -R $PWD/assets/ico $k/$j/web/ico
	cp -R $PWD/assets/js $k/$j/web/js

	# create index file
	echo "<?php\n\n/*\n * project name: $j\n * file name:    index.php  \n * description:  main index page and application bootstrap\n * author:       $a\n * date created: ${d}\n */\n\nrequire_once('$k/$j/lib/config.php');\nrequire_once(PTH.'/app/controller.php');\n\n// instantiate a new controller object\n\$controller = new Controller;\n\n// pass get and post arrays to the controller\n\$controller->initialize(\$_GET,\$_POST);\n\n\n?>" > $k/$j/web/index.php

	# create custom css file
	echo "body {\n  padding-top: 50px;\n}\n.starter-template {\n  padding: 40px 15px;\n  text-align: center;\n}" > $k/$j/web/css/$j.css

	# create configuration file
	echo "<?php\n\n/*\n * project name: $j\n * file name:    config.php  \n * description:  declaration of constants\n * author:       $a\n * date created: ${d}\n */\n\nif ( ! defined('PTH') ) define('PTH','$k/$j/');\nif ( ! defined('NAM') ) define('NAM','$t');\nif ( ! defined('AUT') ) define('AUT','$a');\nif ( ! defined('DSC') ) define('DSC','An extensible MVC PHP Framework that includes a MySQL database for the model and Twitter Bootstrap for the view');\nif ( ! defined('HST') ) define('HST','localhost');\nif ( ! defined('USN') ) define('USN','$j');\nif ( ! defined('PSW') ) define('PSW','$p');\nif ( ! defined('DBS') ) define('DBS','$j');\n\n?>" > $k/$j/lib/config.php

	# create controller class
	echo "<?php\n\n/*\n * project name: $j\n * file name:    controller.php  \n * description:  default controller\n * author:       $a\n * date created: ${d}\n */\n\nrequire_once('$k/$j/lib/config.php');\nrequire_once(PTH.'app/view.php');\nrequire_once(PTH.'app/page.php');\nrequire_once(PTH.'app/section.php');\n\nclass Controller {\n\n	// properties\n	protected \$gts;\n	protected \$pst;\n	\n	public function initialize(\$getArray,\$postArray) {\n\n		// instantiate necessary objects\n		\$htm = new View;\n		\$page = new PageModel;\n		\$section = new SectionModel;\n\n		// FIRST check for POST\n		\n		// this conditional requires any post array to contain a key for 'id'\n		if (!\$postArray) {\n			\$postArray = NULL;\n		} else {\n			// form processing goes here\n			\$model = new PostModel;\n			\$model->pst = \$pstArray;\n			\$model->processPst();\n		}\n		\n		// SECOND check for GET\n		\n		// this conditional sets GET-id to 1 if none is received\n		if (!\$getArray) {\n			\$this->gts = array('id' => 1 ,'axn' => 'view');\n		} else {\n			\$this->gts = \$getArray;\n		}\n		\n		\$section->id = \$this->gts['id'];\n		\$htm->pageTitle = \$section->getPageTitle();\n		\$htm->sections = \$section->getSections();\n		\$htm->pages = \$page->getPages();\n		\n		echo \$htm->getOutput();\n		\n		}\n				\n}\n\n\n?>" > $k/$j/app/controller.php

	# create model classes
	echo "<?php\n\n/***\n * project name: $j\n * file name:    model.php  \n * description:  abstract model\n * author:       $a\n * date created: ${d}\n */\n\nrequire_once('$k/$j/app/model.php');\n\nabstract class Model {\n\n	protected \$lnk;\n		\n	/***\n	* automatic database connection upon instantiation\n	* @param void\n	* @return void\n	*/\n	function __construct() {\n		\$this->lnk = mysqli_connect(HST,USN,PSW,DBS);\n	}\n\n	function __clone() {\n		// empty clone to prevent duplicate connections\n	}\n\n}\n\n\n?>"  > $k/$j/app/model.php
	echo "<?php\n\n/***\n * project name: $j\n * file name:    page.php  \n * description:  page model\n * author:       $a\n * date created: ${d}\n */\n\nrequire_once('$k/$j/lib/config.php');\nrequire_once('model.php');\n\nclass PageModel extends Model {\n	\n	/***\n	* database functions for page table\n	* @param void\n	* @return mixed (dictionary)\n	*/\n	function getPages() {\n		\$sql = 'SELECT * FROM page WHERE vis = 1 ORDER BY psn';\n		\$qrh = mysqli_query(\$this->lnk, \$sql);\n		\$i = 1;\n		\n		// iterate and extract data to be passed to view\n		while ( \$res = mysqli_fetch_array(\$qrh)) {\n			\$results[] = array('id' => \$res['id'],'name' => \$res['nam']);\n			\$i++;\n		}\n		\n		return \$results;\n		\n	}\n\n}\n\n\n?>" > $k/$j/app/page.php
	echo "<?php\n\n/***\n * project name: $j\n * file name:    section.php  \n * description:  section model\n * author:       $a\n * date created: ${d}\n */\n\nrequire_once('$k/$j/lib/config.php');\nrequire_once('model.php');\n\nclass SectionModel extends Model {\n\n	// properties\n	public \$id;\n	\n	/***\n	* database functions for section table\n	* @param void\n	* @return mixed (dictionary)\n	*/\n	function getSections() {\n		\$sql = 'SELECT * FROM section WHERE page = '.\$this->id.' ORDER BY psn';\n		\$qrh = mysqli_query(\$this->lnk, \$sql);\n		\$i = 1;\n		\n		// iterate and extract data to be passed to view\n		while ( \$res = mysqli_fetch_array(\$qrh) ) {\n			\$results[] = array('tag' => \$res['tag'],'class' => \$res['cla'], 'data' => \$res['dta']);\n			\$i++;\n		}\n		\n		return \$results;\n		\n	}\n	\n	/***\n	* database lookup for title to display on page\n	* @param void\n	* @return string (pageTitle)\n	*/\n	function getPageTitle() {\n		\$sql = 'SELECT * FROM page WHERE id = '.\$this->id.' LIMIT 1';\n		\$qrh = mysqli_query(\$this->lnk, \$sql);\n		\$res = mysqli_fetch_array(\$qrh);\n		return \$res['nam'];\n	}\n\n}\n\n\n?>" > $k/$j/app/section.php

	# create view class
	echo "<?php\n\n/*\n * project name: $j\n * file name:    view.php \n * description:  abstract view\n * author:       $a\n * date created: ${d}\n */\n\nrequire_once('$k/$j/lib/config.php');\n\nclass View {\n\n	// public view properties\n	public \$pageTitle;\n	public \$pages; // array of page names\n	public \$sections; // array of content containers\n	\n	// html DOM object\n	protected \$hto;\n	protected \$htc;\n\n	// head DOM object\n	protected \$heo;\n	protected \$hec;\n\n	// body DOM object\n	protected \$bdo;\n	protected \$bdc;\n\n	// nav DOM object\n	protected \$nvo;\n	protected \$nvd;\n	protected \$nvc;\n\n	// container DOM object\n	protected \$cto;\n	protected \$ctd;\n	protected \$ctc;\n	\n	/* constructor automatically loads default view settings */\n	function __construct() {\n		\$this->hto = '<!DOCTYPE HTML>\n<html lang=\"en\">\n';\n		\$this->heo = '  <head>\n    <meta charset=\"utf-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <meta name=\"description\" content=\"'.DSC.'\">\n    <meta name=\"author\" content=\"'.AUT.'\">\n    <link rel=\"shortcut icon\" href=\"ico/favicon.png\">\n    <title>'.NAM.' : ';\n		\$this->hec = '</title>\n    <link href=\"css/bootstrap.css\" rel=\"stylesheet\">\n    <link href=\"css/$j.css\" rel=\"stylesheet\">\n    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->\n    <!--[if lt IE 9]>\n      <script src=\"js/html5shiv.js\"></script>\n      <script src=\"js/respond.min.js\"></script>\n    <![endif]-->\n  </head>\n';\n		\$this->bdo = '  <body>\n    ';\n		\$this->nvo = '<div class=\"navbar navbar-inverse navbar-fixed-top\">\n      <div class=\"container\">\n        <div class=\"navbar-header\">\n          <button type=\"button\" class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\".navbar-collapse\">\n            <span class=\"icon-bar\"></span>\n            <span class=\"icon-bar\"></span>\n            <span class=\"icon-bar\"></span>\n          </button>\n          <a class=\"navbar-brand\" href=\"#\">'.NAM.'</a>\n        </div>\n        <div class=\"collapse navbar-collapse\">\n          <ul class=\"nav navbar-nav\">';\n		\$this->nvc = '          </ul>\n        </div><!--/.nav-collapse -->\n      </div>\n    </div>\n';\n		\$this->cto = '    <div class=\"container\">\n';\n		\$this->ctc = '    </div><!--container-->\n';\n		\$this->bdc = '    <script src=\"js/jquery.js\"></script>\n    <script src=\"js/bootstrap.js\"></script>\n  </body>\n';\n		\$this->htc = '</html>';\n	} // end constructor\n	\n	/* construct output string\n	 * @param void\n	 * @return string (html page)\n	 */		\n	public function getOutput() {\n	\n		// iterate through page links and build up navbar\n		foreach (\$this->pages as \$page) {\n			\$this->nvd .= '<li';\n			if (\$page['name'] == \$this->pageTitle) {\n				\$this->nvd .= ' class=\"active\"';\n			}\n			\$this->nvd .= '><a href=\"index.php?id='.\$page['id'].'\">'.\$page['name'].'</a></li>';\n		} // end nav loop\n		\n		// loop through content array and build up sections\n		foreach (\$this->sections as \$section) {\n			\$this->ctd .= '    <'.\$section['tag'];\n			if (\$section['class']) {\n				\$this->ctd .= ' class=\"'.\$section['class'].'\"';\n			}\n			\$this->ctd .= '>'.\$section['data'].'</'.\$section['tag'].'>\n';\n		} // end sections loop\n		// begin assembling output\n		\n		\$out = '';\n		\$out .= \$this->hto;\n		\$out .= \$this->heo;\n		\$out .= \$this->pageTitle;\n		\$out .= \$this->hec;\n		\$out .= \$this->bdo;\n		\$out .= \$this->nvo;\n		\$out .= \$this->nvd;\n		\$out .= \$this->nvc;\n		\$out .= \$this->cto;\n		\$out .= \$this->ctd;\n		\$out .= \$this->ctc;\n		\$out .= \$this->bdc;\n		\$out .= \$this->htc;\n		\n		//	\n		return \$out;\n	\n	} // end getOutput()\n\n}\n\n\n?>" > $k/$j/app/view.php
	
	# provide option to create mysql database
	read -p "Do you wish to create the MySQL Database at localhost? (y/n) " RESP
	if [ "$RESP" = "y" ]; then

		echo "What is the MySQL root password?"
		read r
		mysql -u root -h localhost -p$r -Bse "CREATE DATABASE $j;"
		mysql -u root -h localhost -p$r -Bse "use $j;"
		mysql -u root -h localhost -p$r -Bse "CREATE USER '$j'@'%' IDENTIFIED BY  '$p';"
		mysql -u root -h localhost -p$r -Bse "GRANT USAGE ON * . * TO  '$j'@'%' IDENTIFIED BY  '$p' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;"
		mysql -u root -h localhost -p$r -Bse "CREATE DATABASE IF NOT EXISTS $j"
		mysql -u root -h localhost -p$r -Bse "GRANT SELECT ON $j . * TO '$j'@'%' IDENTIFIED BY  '$p' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;"
		mysql -u root -h localhost -p$r -Bse "CREATE TABLE IF NOT EXISTS $j.page ( id int(4) NOT NULL AUTO_INCREMENT, dpt int(2) NOT NULL, psn int(2) NOT NULL, vis tinyint(1) NOT NULL DEFAULT '1', nam varchar(40) NOT NULL, PRIMARY KEY (id) ) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;"
		mysql -u root -h localhost -p$r -Bse "INSERT INTO $j.page (id, dpt, psn, vis, nam) VALUES (1, 1, 1, 1, 'Home'), (2, 2, 2, 1, 'About'),(3, 3, 3, 1, 'Contact') ;"
		mysql -u root -h localhost -p$r -Bse "CREATE TABLE IF NOT EXISTS $j.section ( id int(8) NOT NULL AUTO_INCREMENT, page int(2) NOT NULL, psn int(4) NOT NULL, tag varchar(20) NOT NULL, cla varchar(128) DEFAULT NULL, dta text, PRIMARY KEY (id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;"
		mysql -u root -h localhost -p$r -Bse "INSERT INTO $j.section (id, page, psn, tag, cla, dta) VALUES (1, 1, 1, 'h1', NULL, 'Home Page'), (2, 1, 2, 'p', 'lead', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'), (3, 2, 1, 'h1', NULL, 'About Us'), (4, 2, 2, 'p', 'lead', 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '), (5, 3, 1, 'h1', NULL, 'Contact Us'), (6, 3, 2, 'p', 'lead', 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');"
	  echo "CREATE DATABASE $j;\nuse $j;\nCREATE USER '$j'@'%' IDENTIFIED BY  '$p';\nGRANT USAGE ON * . * TO  '$j'@'%' IDENTIFIED BY  '$p' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;\nCREATE DATABASE IF NOT EXISTS $j\nGRANT SELECT ON $j . * TO '$j'@'%' IDENTIFIED BY  '$p' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;\nCREATE TABLE IF NOT EXISTS $j.page ( id int(4) NOT NULL AUTO_INCREMENT, dpt int(2) NOT NULL, psn int(2) NOT NULL, vis tinyint(1) NOT NULL DEFAULT '1', nam varchar(40) NOT NULL, PRIMARY KEY (id) ) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;\nINSERT INTO $j.page (id, dpt, psn, vis, nam) VALUES (1, 1, 1, 1, 'Home'), (2, 2, 2, 1, 'About'),(3, 3, 3, 1, 'Contact') ;\nCREATE TABLE IF NOT EXISTS $j.section ( id int(8) NOT NULL AUTO_INCREMENT, page int(2) NOT NULL, psn int(4) NOT NULL, tag varchar(20) NOT NULL, cla varchar(128) DEFAULT NULL, dta text, PRIMARY KEY (id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;\nINSERT INTO $j.section (id, page, psn, tag, cla, dta) VALUES (1, 1, 1, 'h1', NULL, 'Home Page'), (2, 1, 2, 'p', 'lead', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'), (3, 2, 1, 'h1', NULL, 'About Us'), (4, 2, 2, 'p', 'lead', 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '), (5, 3, 1, 'h1', NULL, 'Contact Us'), (6, 3, 2, 'p', 'lead', 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');" > $k/$j/lib/sql/mysql.sql

	else
	  echo "okay, skipping MySQL database creation"
	  echo "CREATE DATABASE $j;\nuse $j;\nCREATE USER '$j'@'%' IDENTIFIED BY  '$p';\nGRANT USAGE ON * . * TO  '$j'@'%' IDENTIFIED BY  '$p' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;\nCREATE DATABASE IF NOT EXISTS $j\nGRANT SELECT ON $j . * TO '$j'@'%' IDENTIFIED BY  '$p' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;\nCREATE TABLE IF NOT EXISTS $j.page ( id int(4) NOT NULL AUTO_INCREMENT, dpt int(2) NOT NULL, psn int(2) NOT NULL, vis tinyint(1) NOT NULL DEFAULT '1', nam varchar(40) NOT NULL, PRIMARY KEY (id) ) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;\nINSERT INTO $j.page (id, dpt, psn, vis, nam) VALUES (1, 1, 1, 1, 'Home'), (2, 2, 2, 1, 'About'),(3, 3, 3, 1, 'Contact') ;\nCREATE TABLE IF NOT EXISTS $j.section ( id int(8) NOT NULL AUTO_INCREMENT, page int(2) NOT NULL, psn int(4) NOT NULL, tag varchar(20) NOT NULL, cla varchar(128) DEFAULT NULL, dta text, PRIMARY KEY (id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;\nINSERT INTO $j.section (id, page, psn, tag, cla, dta) VALUES (1, 1, 1, 'h1', NULL, 'Home Page'), (2, 1, 2, 'p', 'lead', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'), (3, 2, 1, 'h1', NULL, 'About Us'), (4, 2, 2, 'p', 'lead', 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '), (5, 3, 1, 'h1', NULL, 'Contact Us'), (6, 3, 2, 'p', 'lead', 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');" > $k/$j/lib/sql/mysql.sql
	  export PS1="\e[0;31m[\u@\h \W]\$ \e[m "
	  echo "The batch file \"mysql.sql\" for the creation of the database is in the 'sql' folder.\nYou will need to connect to your mysql server and issue the commands therein."
	fi

else

	exit

fi




