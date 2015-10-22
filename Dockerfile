FROM boritzio/docker-base

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
RUN apt-get install wget
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN sudo apt-get update

RUN apt-get update && apt-get install -y postgresql-9.4 postgresql-contrib-9.4 postgis postgresql-9.4-postgis-2.1

ADD pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf 
ADD postgresql.conf /etc/postgresql/9.4/main/postgresql.conf

RUN mkdir -p /data

ENV PG_VERSION=9.4

ENV POSTGRES="/usr/lib/postgresql/$PG_VERSION/bin/postgres"
ENV CONFIG_PATH="/etc/postgresql/$PG_VERSION/main/"

VOLUME ["/data"]

ADD configure_postgres.sh /etc/my_init.d/01_configure_postgres
ADD bootstrap.sh /etc/my_init.d/09_bootstrap
ADD start_postgres.sh /etc/my_init.d/99_start_postgres
