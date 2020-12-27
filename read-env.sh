#!/bin/bash

function help() {
  echo "Usage: ./read-env <environment variable>"
}

# Read environment variable $1 from file $2
function read_env_var_from_file() {
  # Get the last exact match
  var=$(grep -w "^$1" $2 | tail -1)
  IFS="=" read -ra var <<< "$var"
  if [ -z ${var[0]} ]; then
    # Environment variable not found in file, try looking up shell
    echo ${!1}
  else
    echo ${var[1]}
  fi
}

function read_env_var() {
  # Files are declared in the order in which they are prioritised
  declare -a development=(".env.development.local"
                          ".env.local"
                          ".env.development"
                          ".env")
  declare -a production=(".env.production.local"
                         ".env.local"
                         ".env.production"
                         ".env")
  go_env=${GO_ENV:-development}
  # Enable case-insensitive matching
  shopt -s nocasematch
  case "$go_env" in
    development )
      for file in "${development[@]}"; do
        if [ -f "$file" ]; then
          env_file="$file"
          break
        fi
      done
      ;;
    production )
      for file in "${production[@]}"; do
        if [ -f "$file" ]; then
          env_file="$file"
          break
        fi
      done
      ;;
    * )
      echo "Invalid value for GO_ENV: ${go_env}" 1>&2
      exit 1
      ;;
  esac

  if [ -z "$env_file" ]; then
    echo "Error: No .env file found" 1>&2
    exit 1
  fi

  read_env_var_from_file $1 $env_file
}

if [ -z "$1" ]; then
  help
  exit 1
fi

# Convert input to uppercase
read_env_var ${1^^}
