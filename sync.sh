#!/bin/sh

set -ex

if [ "$SRC_PASSWORD" == "" ]; then
  SOURCE_QUERY="-u $SRC_USERNAME -h $SRC_HOST --port $SRC_PORT $SRC_DBNAME"
else
  SOURCE_QUERY="-u $SRC_USERNAME -p $SRC_PASSWORD -h $SRC_HOST --port $SRC_PORT $SRC_DBNAME"
fi

if [ "$DIST_PASSWORD" == "" ]; then
  DIST_QUERY="-u $DIST_USERNAME -h $DIST_HOST --port $DIST_PORT $DIST_DBNAME"
else
  DIST_QUERY="-u $DIST_USERNAME -p $DIST_PASSWORD -h $DIST_HOST --port $DIST_PORT $DIST_DBNAME"
fi

GET_TABLES_QRY="select table_name from information_schema.tables where TABLE_SCHEMA='${SRC_DBNAME}' and TABLE_TYPE='BASE TABLE';"

function sync_table {
  if [ "$table" != "table_name" ]; then
    echo "dumping $table data to temp file"
    mysqldump $SOURCE_QUERY $table > data/temp/$table.sql
    echo "importing temp $table data to destination db"
    # $DIST_QUERY --local-infile=1 -e "LOAD DATA LOCAL INFILE '/app/data/temp/${table}.txt' INTO TABLE $table" || true
    mysql $DIST_QUERY < data/temp/$table.sql
  fi
}

# create temp folder 
mkdir -p data/temp
rm -f data/temp/*

echo 'Getting all tables for sync...'
mysql $SOURCE_QUERY -e "$GET_TABLES_QRY" > data/tables.txt

echo 'Syncing tables..'


cat data/tables.txt | while read table
do
  sync_table $table
done
