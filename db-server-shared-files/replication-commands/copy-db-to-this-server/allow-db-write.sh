#!/bin/bash

# https://www.server-world.info/en/note?os=Ubuntu_20.04&p=postgresql12&f=3

function init() {
  # TODO: Add some notification about causes when executed multiple times.

  echo "Define error reporting level, file seperator, and init direcotry."
  set +x # set -o xtrace;
  # https://unix.stackexchange.com/a/164548 You can preserve newlines in the .env.
  IFS=$''
  readonly ROOT_DIR="/var/www";
  readonly DIR=$PWD;
  readonly DIR_DATA="${ROOT_DIR}/db-data";
  readonly POSTGRES_DIR="${DIR_DATA}/postgresql/12/main";
  readonly STANDBY_SIGNAL='standby.signal';
  readonly SUFFIX_BACKUP="backup";
}

function stopThePgServer(){
	echo "Stoping the PostgresSQL server ...";
	service postgresql stop
	service postgresql status
}

function turnOffReadOnlyTransactions(){
  echo "When the data is copied then this DB becomes read-only. This step makes it read-write ...";
  echo ${POSTGRES_DIR}/${STANDBY_SIGNAL};
  mv ${POSTGRES_DIR}/${STANDBY_SIGNAL} ${POSTGRES_DIR}/${STANDBY_SIGNAL}.${SUFFIX_BACKUP}
  ls ${POSTGRES_DIR}/${STANDBY_SIGNAL}
}

function startThePgServer(){
	echo "Start the PostgresSQL server ...";
	service postgresql start
	service postgresql status
}

init
stopThePgServer
turnOffReadOnlyTransactions
startThePgServer
./status.sh