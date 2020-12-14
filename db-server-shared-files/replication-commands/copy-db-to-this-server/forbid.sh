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
  readonly SUFFIX_PRIMARY_REPLIC="primary-replic.backup";
}

function stopThePgServer(){
	echo "Stoping the PostgresSQL server ...";
	service postgresql stop
	service postgresql status
}

function forbidPrimaryReplicationInPostgresqlConf(){
	echo "Forbid a replication in the '${POSTGRES_CONF}' ...";
	cd $DIR_CONF;

	echo "Backing-up the current '${POSTGRES_CONF}' to '${POSTGRES_CONF}.${SUFFIX_PRIMARY_REPLIC}' ...";
	mv ${POSTGRES_CONF} ${POSTGRES_CONF}.${SUFFIX_PRIMARY_REPLIC}

	echo "Replacing the current '${POSTGRES_CONF}' with the '${POSTGRES_CONF}.${SUFFIX_BACKUP}' or '${POSTGRES_CONF}.${SUFFIX_EXAMPLE}' ...";

  if [[ -r "${POSTGRES_CONF}.${SUFFIX_BACKUP}" ]]; then 
    cp ${POSTGRES_CONF}.${SUFFIX_BACKUP} ${POSTGRES_CONF}
  else
    cp ${POSTGRES_CONF}.${SUFFIX_EXAMPLE} ${POSTGRES_CONF}
  fi

	cd $DIR
}

function forbidReplicationConnectionAutoConf(){
	echo "Forbid a receiving replication connection ...";
	cd $DIR_CONF;

  echo "Backing-up the current '${POSTGRES_CONF}' to '${POSTGRES_CONF}.${SUFFIX_PRIMARY_REPLIC}' ...";
  mv "${DIR_CONF}/postgresql.auto.conf" "${DIR_CONF}/postgresql.auto.conf".${SUFFIX_PRIMARY_REPLIC}

  echo "Replacing the current '${POSTGRES_CONF}' with the '${POSTGRES_CONF}.${SUFFIX_BACKUP}' or '${POSTGRES_CONF}.${SUFFIX_EXAMPLE}' ...";
  cp "${DIR_CONF}/postgresql.auto.conf.example" "${DIR_CONF}/postgresql.auto.conf"

	cd $DIR
}

function startThePgServer(){
	echo "Start the PostgresSQL server ...";
	service postgresql start
	service postgresql status
}

init
stopThePgServer
forbidPrimaryReplicationInPostgresqlConf
forbidReplicationConnectionAutoConf
./allow-db-write.sh
startThePgServer
./status.sh