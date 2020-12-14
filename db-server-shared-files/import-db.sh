#!/bin/bash

 if [[ ! -r /var/www/db-import-export/import-me.gz ]]; then
  echo "Put the DB import file into db-import-export/import-me.gz";
else
  gunzip -c /var/www/db-import-export/import-me.gz | psql -U  "${POSTGRES_USER}" -h localhost --set ON_ERROR_STOP=on ${POSTGRES_DB}
  echo "The import-me.gz has been imported into '${POSTGRES_DB}'";
 fi
