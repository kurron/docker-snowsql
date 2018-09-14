#!/bin/bash

CMD="docker run --cpus 2 \
                --interactive \
                --name single-core-jdk \
                --rm \
                --tty \
                --memory 268435546 \
                --memory-swap 0 \
                multicore_multi-core-jdk:latest"
echo $CMD
$CMD
