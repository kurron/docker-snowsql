#!/usr/bin/env bash

# Runs the specified Snowflake script using the specified configuration file

CONFIGURATION=${1:-${PWD}/config}
SCRIPT=${2:-${PWD}/create-warehouse.sql}

#--env SNOWSQL_PWD=${SNOWSQL_PWD}
#--rolename ${ROLE_NAME} \

CMD="docker run --interactive \
                --name snowsql \
                --rm \
                --tty \
                --volume ${CONFIGURATION}:/mnt/config:ro \
                --volume ${SCRIPT}:/mnt/script.sql:ro \
                snowsql:latest --config /mnt/config --filename /mnt/script.sql"
echo $CMD
$CMD
