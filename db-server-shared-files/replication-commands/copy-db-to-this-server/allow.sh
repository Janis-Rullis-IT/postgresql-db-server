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
  readonly DIR_DATA="${ROOT_DIR}/db-data";
  readonly DIR=$PWD;
  readonly POSTGRES_DIR="${DIR_DATA}/postgresql/12/main";

  readonly POSTGRES_CONF="postgresql.conf";
  readonly RECEIVER_REPLICA_CONF="receiver-replica.conf.example";

  readonly SUFFIX_BACKUP="backup";
  readonly SUFFIX_EXAMPLE="example";
  readonly SUFFIX_PRIMARY_REPLIC="secondary-replic.backup";
}

if [[ ! -n $1 ]]; then
        echo "IP of the other server?";
        echo "Example: allow.sh 1.1.1.1 user1 123";
        exit;
else
  readonly REMOTE_IP=$1;
fi

if [[ ! -n $2 ]]; then
        echo "The remote DB user?";
        echo "Example: allow.sh 1.1.1.1 user1 123";
        exit;
else
  readonly REMOTE_DB_USER=$2;
fi

if [[ ! -n $3 ]]; then
        echo "The remote DB user's password?";
        echo "Example: allow.sh 1.1.1.1 user1 123";
        exit;
else
  readonly REMOTE_DB_PW=$3;
fi

function stopThePgServer(){
	echo "Stoping the PostgresSQL server ...";
	service postgresql stop
	service postgresql status
}

function allowReceiverReplicationInPostgresqlConf(){
	echo "Allowing a receiving replication in the '${POSTGRES_CONF}' ...";
	cd $DIR_CONF;

	echo "Backing-up the current '${POSTGRES_CONF}' to '${POSTGRES_CONF}.${SUFFIX_BACKUP}' ...";
	mv ${POSTGRES_CONF} ${POSTGRES_CONF}.${SUFFIX_BACKUP}

	echo "Replacing the current '${POSTGRES_CONF}' with '${RECEIVER_REPLICA_CONF}' ...";
	cp ${RECEIVER_REPLICA_CONF} ${POSTGRES_CONF}

  cd $DIR
}

function removeCurrentDatabaseFiles(){
  echo "Moving '${POSTGRES_DIR}' to '${POSTGRES_DIR}.${SUFFIX_BACKUP}' so could import the data from the other servrer into a fresh PG direcotry ...";
  rm ${POSTGRES_DIR}.${SUFFIX_BACKUP} -R
  mv ${POSTGRES_DIR} ${POSTGRES_DIR}.${SUFFIX_BACKUP}
}

function copyDataFromTheOtherServer(){
  echo "Copying data from the remote server '${REMOTE_IP}' with a user -'${REMOTE_DB_USER}' ...";
  echo "Please, repeat the DB password for this user...";
  pg_basebackup -h ${REMOTE_IP} -U ${REMOTE_DB_USER} -D ${POSTGRES_DIR} -Fp -Xs -R -v

  echo 'Set correct permissions and links for the copied files ...';
  mv "${POSTGRES_DIR}/postgresql.auto.conf" "${POSTGRES_DIR}/postgresql.auto.conf.${SUFFIX_BACKUP}"
  cp "${DIR_CONF}/postgresql.auto.conf" "${DIR_CONF}/postgresql.auto.conf.${SUFFIX_BACKUP}"
  echo "primary_conninfo = 'user=${REMOTE_DB_USER} password=${REMOTE_DB_PW} host=${REMOTE_IP} port=5432 sslmode=prefer sslcompression=0 gssencmode=prefer krbsrvname=postgres target_session_attrs=any application_name=node01'" > "${DIR_CONF}/postgresql.auto.conf";
  ln -s "${DIR_CONF}/postgresql.auto.conf" "${POSTGRES_DIR}/postgresql.auto.conf"
  chown postgres:postgres ${POSTGRES_DIR} -R
}

function startThePgServer(){
	echo "Start the PostgresSQL server ...";
	service postgresql start
	service postgresql status
}

init
stopThePgServer
removeCurrentDatabaseFiles
copyDataFromTheOtherServer
startThePgServer
./status.sh