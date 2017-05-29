<?php
##
## database access settings in php format
## automatically generated from /etc/dbconfig-common/roundcube.conf
## by /usr/sbin/dbconfig-generate-include
##
## by default this file is managed via ucf, so you shouldn't have to
## worry about manual changes being silently discarded.  *however*,
## you'll probably also want to edit the configuration file mentioned
## above too.
##
$dbuser=getenv('USER_NAME');
$dbpass=getenv('USER_PASSWD');
$basepath='';
$dbname='roundcube';
$dbserver='postgres';
$dbport='5432';
$dbtype='pgsql';
