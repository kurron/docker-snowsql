#!/bin/bash

docker pull ubuntu:18.04
docker build --tag snowsql:latest .
