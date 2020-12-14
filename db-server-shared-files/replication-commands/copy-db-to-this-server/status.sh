#!/bin/bash

# https://www.server-world.info/en/note?os=Ubuntu_20.04&p=postgresql12&f=3

function printSecondaryReplicationStatus(){
  service postgresql start
	su postgres -c "psql -c 'SELECT pg_is_in_recovery();'";
  echo "Secondary replication is active if 'pg_is_in_recovery();' is 'true' .";
}
printSecondaryReplicationStatus