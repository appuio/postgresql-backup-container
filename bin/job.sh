#!/bin/sh
DATE=$(date +%Y-%m-%d-%H-%M)

if [ -z $BACKUP_HOST ]; then
  if [ -v $POSTGRESQLDB_SERVICE_HOST ]; then
    echo "BACKUP_HOST fallback to POSTGRESQLDB_SERVICE_HOST";
    export BACKUP_HOST=$POSTGRESQLDB_SERVICE_HOST
  fi
fi

if [ -z $BACKUP_HOST ]; then
  echo "no BACKUP_HOST configured!"
  exit 1
else
  echo "used BACKUP_HOST '$BACKUP_HOST'";
fi

# call backup script
dump=$(/opt/cpm/bin/start-backupjob.sh)

if [ $? -ne 0 ]; then
    echo "dump not successful: ${DATE}"
    exit 1
fi

printf '%s' "$dump" | gzip > $BACKUP_DATA_DIR/dump-${DATE}.sql.gz

if [ $? -eq 0 ]; then
    echo "backup created: ${DATE}"
else
    echo "backup not successful: ${DATE}"
    exit 1
fi

# Delete old files
old_dumps=$(ls -1 $BACKUP_DATA_DIR/dump* | head -n -$BACKUP_KEEP)
if [ "$old_dumps" ]; then
    echo "Deleting: $old_dumps"
    rm $old_dumps
fi
