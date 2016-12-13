# postgresql-simple-backup-container
Container to backup PostgreSQL databases running on OpenShift

## Intention
Provide a container that does periodical backups of a PostgreSQL database.

## WIP
The backup container is not finished jet: work in progress.

This repo ist inspired by the MySQL backup container: https://github.com/appuio/mysql-simple-backup-container

## Prerequisites

### PostgreSQL Database
* The database has to be set up with a master user and it's password.
* The database has to be configured to allow remote access from other hosts.
* The database user for the backup has to have superuser or replication role.

## Docker only

### Start PostgreSQL database
Run a PostgreSQL Database container.

    docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d -p 5432:5432 postgres

Run a Crunchy PostgreSQL Database container.

    docker run \
      --name some-postgres \
      -e "PG_MODE=master" \
      -e "PG_MASTER_USER=master" \
      -e "PG_MASTER_PASSWORD=master.chief" \
      -e "PG_USER=postgres" \
      -e "PG_PASSWORD=mysecretpassword" \
      -e "PG_DATABASE=postgres" \
      -e "PG_ROOT_PASSWORD=mysecretpassword2" \
      -d -p 5432:5432 \
      crunchydata/crunchy-postgres:centos7-9.5-1.2.5

Init Database.

### Build Backup image

    docker build -t pg_backup .

### Start Backup Container

Environment:
* $BACKUP_HOST host we are connecting to
* $BACKUP_USER pg user we are connecting with
* $BACKUP_PASS pg user password we are connecting with
* $BACKUP_PORT pg port we are connecting to

Create backup directory:

    mkdir pgdata

Start backup container:

    docker run -ti \
      -e "BACKUP_HOST=postgresdb" \
      -e "BACKUP_USER=postgres" \
      -e "BACKUP_PASS=mysecretpassword" \
      -e "BACKUP_PORT=5432" \
      -v $(pwd)/pgdata:/pgdata \
      --link some-postgres:postgresdb \
      pg_backup
