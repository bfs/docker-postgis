#!/bin/bash

#defaults
POSTGRES="/usr/lib/postgresql/9.4/bin/postgres"
CONFIG_PATH="/etc/postgresql/9.4/main/"

SHARED_BUFFERS=${SHARED_BUFFERS:-"2GB"}
PG_PASSWORD=${PG_PASSWORD:-"postgres"}
WHITELIST_NETWORKS=${WHITELIST_NETWORKS:-"10.0.0.0/8,192.168.0.0/16"}

mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private

#apply memory settings to config file
sed -i "s/\*\*SHARED_BUFFERS\*\*/$SHARED_BUFFERS/" $CONFIG_PATH/postgresql.conf

#whitelist networks in pg_hba
for n in $(echo $WHITELIST_NETWORKS | tr "," " "); do
  echo "host    all             all             $n             md5" >> $CONFIG_PATH/pg_hba.conf
done

#initialize the database (or fail) at /data/
chown -R postgres /data
su - postgres  -c "/usr/lib/postgresql/9.4/bin/initdb -D /data"

#set default password
su - postgres -c "$POSTGRES --single -c config_file=$CONFIG_PATH/postgresql.conf <<< \"ALTER USER postgres WITH PASSWORD '$PG_PASSWORD';\""

#now run
su - postgres -c "$POSTGRES -c config_file=$CONFIG_PATH/postgresql.conf"