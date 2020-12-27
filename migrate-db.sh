#!/bin/bash

function retrieve() {
  echo $(./read-env.sh $1)
}

DB_NAME=$(retrieve DB_NAME)
DB_USERNAME=$(retrieve DB_USERNAME)
DB_PASSWORD=$(retrieve DB_PASSWORD)
DB_HOST=$(retrieve DB_HOST)
DB_PORT=$(retrieve DB_PORT)

source="migrations"
uri="postgresql://"

if [ -z "$DB_NAME" ]; then
  echo "Error: Database name not specified" 1>&2
  exit 1
fi

if [ ! -z "$DB_USERNAME" ]; then
  if [ ! -z "$DB_PASSWORD" ]; then
    password=":$DB_PASSWORD"
  fi
  uri="$uri$DB_USERNAME$password@"
fi

if [ ! -z "$DB_HOST" ]; then
  uri="$uri$DB_HOST"
fi

if [ ! -z "$DB_PORT" ]; then
  uri="$uri:$DB_PORT"
fi

uri="$uri/$DB_NAME"

if [ -z "$DB_HOST" ]; then
  # Connect via UNIX socket if host is not defined
  uri="$uri?host=/var/run/postgresql"
fi

# Pass on all other arguments at the back
migrate -path "$source" -database "$uri" "$@"
