#!/bin/bash
##
## SCALA VALUES GENERATION SCRIPT FOR SCALA APPLICATION
## by Thibault BRONCHAIN
##

## Global variables
NAME='SQLValues'
CONF_FILE='/home/thibault/Projects/scalaws/conf/application.conf'
PACKAGE_NAME='models'
USER_FIELD='^db.default.user'
PASS_FIELD='^db.default.password'
BASE_FIELD='^db.default.url'

## Temporary variables
SQL_SCRIPT="tmp_getColumnsReqSQL.sql"
SQL_TABLE_RES="tmp_getTableReqSQL.txt"
SQL_COL_RES="tmp_getColumnsReqSQL.txt"
RES_TABLE="tmp_res_table.txt"
RES_COL="tmp_res_col.txt"

## Generated variables
USER=`cat $CONF_FILE | grep $USER_FIELD | rev | cut -d '"' -f 2 | rev`
PASS=`cat $CONF_FILE | grep $PASS_FIELD | rev | cut -d '"' -f 2 | rev`
BASE=`cat $CONF_FILE | grep $BASE_FIELD | rev | cut -d '"' -f 2 | cut -d '/' -f 1 | rev`
RES="$NAME.scala"
OBJECT_NAME="$NAME"

## Empty result files
echo -n > $RES
echo -n > $RES_COL
echo -n > $RES_TABLE

## Get tables
echo "SHOW TABLES;" > $SQL_SCRIPT
(mysql --user=$USER --password=$PASS $BASE < $SQL_SCRIPT | cut -f 1) > $SQL_TABLE_RES

## Loop on tables
TABLE=0
echo "// SQL Tables constant values" >> $RES_TABLE
for table in `cat $SQL_TABLE_RES`; do
    (
	if [ $TABLE -eq 1 ] ; then
	    ## Store tables
	    (
		echo -n "val T_"
		echo -n $table | tr "[:lower:]" "[:upper:]"
		echo "=\"$table\""
	    ) >> $RES_TABLE

	    ## Get columns
	    echo "SHOW COLUMNS FROM $table;" > $SQL_SCRIPT
	    (mysql --user=$USER --password=$PASS $BASE < $SQL_SCRIPT | cut -f 1) > $SQL_COL_RES

	    ## Loop on columns
	    LOOP=0
	    echo "// SQL columns constant values for table $table" >> $RES_COL
	    for line in `cat $SQL_COL_RES`; do
		(
		    if [ $LOOP -eq 1 ] ; then
			# Store columns
			echo -n "val F_"
			echo -n $line | tr "[:lower:]" "[:upper:]"
			echo "=\"$line\""
		    fi
		) >> $RES_COL
		LOOP=1
	    done
	    echo >> $RES_COL
	fi
    )
    TABLE=1
done

## Generate final scala file
(
    echo "package $PACKAGE_NAME" && echo
    echo "object $OBJECT_NAME {" && echo
    cat $RES_TABLE
    echo
    cat $RES_COL
    echo "}"
) > $RES

## Remove temporary files
rm $SQL_SCRIPT
rm $SQL_COL_RES
rm $SQL_TABLE_RES
rm $RES_COL
rm $RES_TABLE

# EOF
