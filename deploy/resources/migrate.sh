#!/usr/bin/env bash
DIRECTORY=$1 ACTION=migrate DB_NAME=$2 DB_USER=$3 DB_PASSWORD=$4 HOME=~ REPLACE_OS_VARS=true "`dirname $0`/current/bin/migrator" foreground
echo "Finished."
