#!/bin/bash



CMD="docker run --interactive \
                --name snowsql \
                --rm \
                --tty \
                snowsql:latest"
echo $CMD
$CMD
