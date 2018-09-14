#!/bin/bash



CMD="docker run --cpus 1 \
                --interactive \
                --name zulu-test \
                --rm \
                --tty \
                dockerazuljdk8_azul-jdk:latest"
echo $CMD
$CMD
