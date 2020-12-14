FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# create source directory
RUN rm -rf /var/www
RUN mkdir /var/www

RUN apt-get clean && apt-get -y update && apt-get install -y locales && locale-gen en_US.UTF-8
RUN apt update -y
RUN apt-get install --yes build-essential inotify-tools cron nano mc htop curl \ 
	iputils-ping less net-tools rsync iputils-tracepath

RUN apt-get install --yes postgresql postgresql-contrib postgresql-client

RUN apt install software-properties-common -y
RUN apt update -y

RUN usermod -a -G postgres postgres

RUN mv /etc/postgresql/12/main/postgresql.conf /etc/postgresql/12/main/postgresql.conf.orig.backup
RUN mv /etc/postgresql/12/main/environment /etc/postgresql/12/main/environment.orig.backup
RUN mv /etc/postgresql/12/main/pg_hba.conf /etc/postgresql/12/main/pg_hba.conf.orig.backup
RUN mv /etc/postgresql/12/main/pg_ident.conf /etc/postgresql/12/main/pg_ident.conf.orig.backup

WORKDIR /var/www
COPY db-config db-config
RUN ln -s /var/www/db-config/postgresql.conf /etc/postgresql/12/main/postgresql.conf
RUN ln -s /var/www/db-config/postgresql.auto.conf /etc/postgresql/12/main/postgresql.auto.conf
RUN ln -s /var/www/db-config/environment /etc/postgresql/12/main/environment
RUN ln -s /var/www/db-config/pg_hba.conf /etc/postgresql/12/main/pg_hba.conf
RUN ln -s /var/www/db-config/pg_ident.conf /etc/postgresql/12/main/pg_ident.conf

EXPOSE 5432
CMD ["./start-db-server.sh"]