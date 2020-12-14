#!/bin/bash
set -e
echo "" >> db-logs/server.log

chown postgres:postgres db-config/ -R
# chown postgres:postgres db-data
# chown postgres:postgres db-data/ -R

chmod a+rw db-config -R

# Stupid workaround to make the setup create the user and keep it.
# When executed from setup.sh then is executed correctly but the user is not present.
 if [[ ! -r setup-done  ]]; then	
  ./create-init-user-and-db.sh  
fi

# tail -f /dev/null
service postgresql start && tail -F /var/www/db-logs/server.log