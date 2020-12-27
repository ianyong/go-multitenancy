#!/bin/bash

path="migrations"

function help() {
  echo "Usage: ./create-migration OPTIONS"
  echo ""
  echo "Options:"
  echo -e "   -p\tPath to migration"
  echo -e "   -n\tMigration name"
  echo -e "   -h\tDisplay this help message"
}

while getopts ":p:n:h" opt; do
  case "$opt" in
    p )
      path=$OPTARG
      ;;
    n )
      name=$OPTARG
      ;;
    h )
      help
      exit 0
      ;;
    ? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

if [ -z "$name" ]; then
  echo "Error: Migration name cannot be empty!" 1>&2
  help
  exit 1
fi

migrate create -ext sql -format unix -dir $path $name
