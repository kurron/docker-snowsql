#!/bin/bash

# use the time as a tag
UNIXTIME=$(date +%s)

# docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
docker tag snowsql:latest kurron/snowsql:latest
docker tag snowsql:latest kurron/snowsql:${UNIXTIME}
docker images

# Usage:  docker push [OPTIONS] NAME[:TAG]
docker push kurron/snowsql:latest
docker push kurron/snowsql:${UNIXTIME}
