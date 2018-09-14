#!/bin/bash

#RAM_IN_BYTES=${1:-67108864}
#USER=$(whoami)
#ansible-playbook --connection=local --user ${USER} --ask-pass --extra-vars "ram_in_bytes=${RAM_IN_BYTES}" launch-jvm.yml

docker run --rm --tty --interactive singlecorejmxansible_single-core-jdk-jmx-ansible:latest
