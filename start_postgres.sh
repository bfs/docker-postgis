#!/bin/bash

#now run
su - postgres -c "$POSTGRES -c config_file=$CONFIG_PATH/postgresql.conf"