#!/bin/bash

readonly NAME="wordpress"
readonly DB_NAME="mariadb"
readonly TAG="4.7.5-apache"

docker run \
        --name "$NAME"_one \
        --link "$DB_NAME:mysql" \
        -d wordpress:"$TAG"

docker run \
        --name "$NAME"_two \
        --link "$DB_NAME:mysql" \
        -d wordpress:"$TAG"

