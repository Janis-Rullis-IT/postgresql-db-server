#!/bin/bash

set +x # set -o xtrace;

if [[ ! -r setup-done  ]]; then	

	echo "Point DB 'data_diretory' to '/var/lib/postgresql db-data/' - will keep data even when the container is shut down.";
	rsync -av --ignore-existing /var/lib/postgresql db-data/

	echo "Create a PostgreSQL user '${POSTGRES_USER}' from credentials received from 'docker-compose.yml' ...";
	echo "CREATE USER ${POSTGRES_USER} WITH SUPERUSER PASSWORD '${POSTGRES_PASSWORD}';" > init.sql
	echo "and DB '${POSTGRES_DB}' ...";
	echo "CREATE DATABASE ${POSTGRES_DB};" >> init.sql

	service postgresql start
	su postgres -c 'psql -f init.sql'
	service postgresql stop
	rm init.sql
	touch setup-done
fi