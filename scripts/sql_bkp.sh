#!/bin/bash
##
## MySQL backup script
## @author: Thibault BRONCHAIN
##

DB_HOST=
DB_USER=
DB_PASS=
DB_NAME=
BK_NAME=

mysqldump --host=$DB_HOST --user=$DB_USER --password=$DB_PASS $DB_NAME > $BK_NAME
