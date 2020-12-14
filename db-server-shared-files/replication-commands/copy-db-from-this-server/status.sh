#!/bin/bash

# https://www.server-world.info/en/note?os=Ubuntu_20.04&p=postgresql12&f=3

function printPrimaryReplicationStatus(){
  service postgresql start
	su postgres -c "psql -c 'SHOW synchronous_standby_names;'";
  echo "Primary replication is active if 'synchronous_standby_names' is '*' .";
}
printPrimaryReplicationStatus