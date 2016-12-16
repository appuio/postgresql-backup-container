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
* The database has to be set up to allow remote backup connections.
 * For this, add following configuration to the PostgreSQL configuration file `/etc/postgresql/X.X/main/postgresql.conf`
 * Use your database version for 'X.X'. As example: '9.5'


    max_wal_senders = 5
    wal_level = hot_standby
    archive_mode = on
    archive_command = '/bin/true'

## OpenShift
Usage on OpenShift.

### PostgreSQL Database
How to create and run the PostgreSQL database.

Create the container with the `oc tool`:

    oc new-app \
      -e POSTGRES_PASSWORD=mysecretpassword \
      -e POSTGRESQL_USER=postgresuser \
      -e POSTGRESQL_PASSWORD=mysecretpassword \
      -e POSTGRESQL_DATABASE=postgresdb \
      -e POSTGRESQL_ADMIN_PASSWORD=mysecretpassword2 \
      centos/postgresql-95-centos7

More documentation for [PostgreSQL on OpenShift](https://docs.openshift.org/latest/using_images/db_images/postgresql.html).

The PostgreSQL database container on [github](https://github.com/sclorg/postgresql-container).

### Database Backup Container

Create and run PostgreSQL backukp Container on OpenShift.

oc new-app \
  -e BACKUP_HOST=localhost \
  -e BACKUP_USER=postgres \
  -e BACKUP_PASS=mysecretpassword \
  -e BACKUP_PORT=5432 \
  -l app=backup \
  https://github.com/appuio/postgresql-simple-backup-container

### Next steps

Create and provide OpenShift templates for backup container and combined with the database.

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
