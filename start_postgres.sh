#!/bin/bash

#defaults
POSTGRES="/usr/lib/postgresql/9.3/bin/postgres"
CONFIG_PATH="/etc/postgresql/9.3/main/"
SHARED_BUFFERS=${SHARED_BUFFERS:-"2GB"}
PG_PASSWORD=${PG_PASSWORD:-"postgres"}


SHARED_BUFFERS=${SHARED_BUFFERS:-"2GB"}
WHITELIST_NETWORKS=${WHITELIST_NETWORKS:-"10.0.0.0/8,192.168.0.0/16"}


#apply memory settings to config file
sed -i "s/\*\*SHARED_BUFFERS\*\*/$SHARED_BUFFERS/" $CONFIG_PATH/postgresql.conf

#whitelist networks in pg_hba
for n in $(echo $WHITELIST_NETWORKS | tr "," " "); do
  echo "host    all             all             $n             md5" >> $CONFIG_PATH/pg_hba.conf
done

#set default password
su - postgres -c "$POSTGRES --single -c config_file=$CONFIG_PATH/postgresql.conf <<< \"ALTER USER postgres WITH PASSWORD '$PG_PASSWORD';\""

#now run
su - postgres -c "$POSTGRES -c config_file=$CONFIG_PATH/postgresql.conf"