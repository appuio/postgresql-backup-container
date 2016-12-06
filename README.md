# postgresql-simple-backup-container
Container to backup PostgreSQL databases running on OpenShift

## Intention
Provide a container that does periodical backups of a PostgreSQL database.

## WIP
The backup container is not finished jet: work in progress.

This repo ist inspired by the MySQL backup container: https://github.com/appuio/mysql-simple-backup-container

## Docker only

### Start PostgreSQL database
Run a PostgreSQL 9.5 Database container.

    docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d -p 5432:5432 postgres:9.5

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
      -e "BACKUP_HOST=localhost" \
      -e "BACKUP_USER=postgres" \
      -e "BACKUP_PASS=mysecretpassword" \
      -e "BACKUP_PORT=5432" \
      -v $(pwd)/pgdata/:/pgdata/ pg_backup
