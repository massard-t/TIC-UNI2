#!/bin/bash

readonly MYSQL_PASSWORD=${1:-"drowssap"}
readonly NAME=${2:-"mariadb"}
readonly TAG=${3:-"10.3"}
readonly MYSQL_DIR=${4:-"/usr/lib/mysql"}
readonly SQL_PORTS=${5:-"3306"}
readonly ALT_DIR="$(pwd)/mysqldata"

if [ -d "$MYSQL_DIR" ];
then
        SQL_DIR="$MYSQL_DIR"
else
        if [ ! -d "$ALT_DIR" ];
        then
                mkdir mysql_data
        fi
        SQL_DIR="$ALT_DIR"
fi

docker run \
        --name "$NAME" \
        -e MYSQL_ROOT_PASSWORD="$MYSQL_PASSWORD" \
        -e MYSQL_DATABASE="$DB" \
        -v "$SQL_DIR":/var/lib/mysql \
        -d mariadb:"$TAG"

echo "MYSQL_PASSWORD    = $MYSQL_PASSWORD"
echo "NAME              = $NAME"
echo "TAG               = $TAG"
echo "MYSQL_DIR         = $MYSQL_DIR"
echo "SQL_PORTS         = $SQL_PORTS"

