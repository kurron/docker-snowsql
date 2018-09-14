#!/bin/bash

RAM_IN_BYTES=${1:-67108864}

CMD="docker run --cpus 1 \
                --interactive \
                --name single-core-jdk-jmx \
                --net host \
                --rm \
                --tty \
                --memory ${RAM_IN_BYTES} \
                --memory-swap 0 \
                --volume /var/run/docker.sock:/var/run/docker.sock \
                singlecorejmx_single-core-jdk-jmx:latest"
echo $CMD
$CMD
