#!/bin/bash

# https://www.server-world.info/en/note?os=Ubuntu_20.04&p=postgresql12&f=3

function init() {
  # TODO: Add some notification about causes when executed multiple times.

  echo "Define error reporting level, file seperator, and init direcotry."
  set +x # set -o xtrace;
  # https://unix.stackexchange.com/a/164548 You can preserve newlines in the .env.
  IFS=$''
  readonly ROOT_DIR="/var/www";
  readonly DIR_CONF="${ROOT_DIR}/db-config";
  readonly DIR=$PWD;
  readonly POSTGRES_CONF="postgresql.conf";
  readonly PRIMARY_REPLICA_CONF="primary-replica.conf.example";
  readonly PG_HBA_CONF="pg_hba.conf";

  readonly SUFFIX_BACKUP="backup";
  readonly SUFFIX_EXAMPLE="example";
}

function stopThePgServer(){
	echo "Stoping the PostgresSQL server ...";
	service postgresql stop
	service postgresql status
}

function allowPrimaryReplicationInPostgresqlConf(){
	echo "Allowing a replication in the '${POSTGRES_CONF}' ...";
	cd $DIR_CONF;

	echo "Backing-up the current '${POSTGRES_CONF}' to '${POSTGRES_CONF}.${SUFFIX_BACKUP}' ...";
	mv ${POSTGRES_CONF} ${POSTGRES_CONF}.${SUFFIX_BACKUP}

	echo "Replacing the current '${POSTGRES_CONF}' with '${PRIMARY_REPLICA_CONF}' ...";
	cp ${PRIMARY_REPLICA_CONF} ${POSTGRES_CONF}

	cd $DIR
}

function allowReplicationConnectionInPgHbaConf(){
	echo "Allowing a replication connection in the '${PG_HBA_CONF}' ...";
	cd $DIR_CONF;

	echo "Backing-up the current '${PG_HBA_CONF}' to '${PG_HBA_CONF}.${SUFFIX_BACKUP}' ...";
	cp ${PG_HBA_CONF} ${PG_HBA_CONF}.${SUFFIX_BACKUP}

	echo "Allowing the '${POSTGRES_USER}' to replicate ...";	
	echo "
# ===== Custom: Allow replication =====
host    replication     ${POSTGRES_USER}        0.0.0.0/0                md5
	" >> $PG_HBA_CONF;

	cd $DIR
}

function startThePgServer(){
	echo "Start the PostgresSQL server ...";
	service postgresql start
	service postgresql status
}

init
stopThePgServer
allowPrimaryReplicationInPostgresqlConf
allowReplicationConnectionInPgHbaConf
startThePgServer
./status.sh