#!/bin/bash
pg_dump -U "${POSTGRES_USER}" -h localhost "${POSTGRES_DB}" | gzip > "/var/www/db-import-export/${POSTGRES_DB}-export.sql.gz"
echo "Exported to /var/www/db-import-export/${POSTGRES_DB}-export.sql.gz"