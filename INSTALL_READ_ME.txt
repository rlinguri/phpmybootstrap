*** PLEASE NOTE : THIS SCRIPT IS PROVIDED WITHOUT WARRANTY OR LIABILITY OF ANY KIND ***

INSTALLATION INSTRUCTIONS

This script is meant to install the PHP application n your local development machine. Once you have extracted the phpmybootstrap directory, you can run the install script on the command line.

First change directory (cd) to the phpmybootstrap directory. Then type:

sudo sh install.sh

You will be asked a few questions starting with the full path to the parent directory.

This will be something like "/Library/WebServer/Documents" or wherever your php pages will run from.

What is the short name of this project? 

(This will be the directory within the parent directory.)

What is the verbose title of this project?

(Enter a longer, more descriptive name)

Who is the author? 

(Feel free to use your own name)

Please enter a new password for the MySQL project user:

(This will be a password for the script to use to access the database with read-only access. Should be different from the root user's password)

You can then have the script connect to mysql at localhost and create the database and database user if you wish. Please note that the script uses your root password on the command line interface, so you won't want to do this on a production machine, but for localhost the security issue may not be of concern. If you choose no, the necessary sql will be placed into the ./lib/sql folder. You can then send this script to your MySQL server manually over a secure connection.

If you are installing on a production machine, please double-check all your configurations manually.

The "./assets/phpmybootstrap" directory could be moved directly into /Library/WebServer/Documents for an easy default configuration, though you will need to customize some settings in the ./lib/config.php file, the ./lib/mysql.sql file and do some troubleshooting to get it all to work properly. Most notably, you may want to change the password, which in the default configuration is set to "password".