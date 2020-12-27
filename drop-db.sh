#!/bin/bash

function retrieve() {
  echo $(./read-env.sh $1)
}

DB_NAME=$(retrieve DB_NAME)
DB_USERNAME=$(retrieve DB_USERNAME)
DB_PASSWORD=$(retrieve DB_PASSWORD)
DB_HOST=$(retrieve DB_HOST)
DB_PORT=$(retrieve DB_PORT)

command="psql -w"

if [ -z "$DB_NAME" ]; then
  echo "Error: Database name not specified" 1>&2
  exit 1
fi

if [ ! -z "$DB_USERNAME" ]; then
  command="$command -U $DB_USERNAME"
fi

if [ ! -z "$DB_PASSWORD" ]; then
  command="PGPASSWORD=$DB_PASSWORD $command"
fi

if [ ! -z "$DB_HOST" ]; then
  command="$command -h $DB_HOST"
fi

if [ ! -z "$DB_PORT" ]; then
  command="$command -p $DB_PORT"
fi

command="$command -c 'DROP DATABASE $DB_NAME;'"

eval $command
