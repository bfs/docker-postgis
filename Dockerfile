FROM boritzio/docker-base

RUN apt-get update && apt-get install -y postgresql postgresql-contrib postgis postgresql-9.3-postgis-2.1

ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf 
ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf 

RUN mv /var/lib/postgresql/9.3/main /data

VOLUME ["/data"]

RUN mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700     /etc/ssl/private; chown -R postgres /etc/ssl/private

ADD start_postgres.sh /etc/my_init.d/start_postgres.sh
