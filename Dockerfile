FROM boritzio/docker-base

RUN apt-get update && apt-get install -y postgresql postgresql-contrib postgis postgresql-9.3-postgis-2.1

ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf 
ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf

RUN mkdir -p /data
RUN chown -R postgres /data

VOLUME ["/data"]

ADD start_postgres.sh /etc/my_init.d/start_postgres.sh
