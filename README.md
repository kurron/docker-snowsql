# Overview
This project is a simple Docker image that provides access to the
[Azul Systems JDK](http://www.azul.com/downloads/zulu/).  It is intended
for **running** JVM applications, not building and testing them. If you
need to build a JVM application, [look at this project](https://github.com/kurron/docker-azul-jdk-8-build).


# Prerequisites
* a working [Docker](http://docker.io) engine
* a working [Docker Compose](http://docker.io) installation

# Building
Type `./build.sh` to build the image.

# Installation
Docker will automatically install the newly built image into the cache.

# Tips and Tricks

## Launching The Image
Use `./test.sh` to exercise the image.  

## Example Usage
There are samples on how to use the image in the `examples` folder and we will
highlight some options here as well.

The basic idea is to use a Bash script to launch the JVM so you can apply
the appropriate switches that are useful in a containerized environment.  You
should copy that script into your image and make the script the entrypoint
to your image.

The `Dockerfile`:
```
FROM kurron/docker-azul-jdk-8:latest

MAINTAINER Ron Kurr <kurr@kurron.org>

ADD launch-jvm.sh /home/microservice/launch-jvm.sh
RUN chmod a+x /home/microservice/launch-jvm.sh
ADD Hello.class /home/microservice/Hello.class

# Switch to the non-root user
USER microservice

# Run the simple program
ENTRYPOINT ["/home/microservice/launch-jvm.sh", "Hello"]
```
The `Bash script` for a single core host:
```
#!/bin/bash

JVM_DNS_TTL=${1:-30}

CMD="${JAVA_HOME}/bin/java \
    -server \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+UseCGroupMemoryLimitForHeap \
    -XX:+ScavengeBeforeFullGC \
    -XX:+CMSScavengeBeforeRemark \
    -XX:+UseSerialGC \
    -XX:MinHeapFreeRatio=20 \
    -XX:MaxHeapFreeRatio=40 \
    -XX:GCTimeRatio=4 \
    -XX:AdaptiveSizePolicyWeight=90
    -Dsun.net.inetaddr.ttl=${JVM_DNS_TTL} \
    $*"

echo ${CMD}
exec ${CMD}
```

The `Bash script` for a multi-core host:
```
#!/bin/bash

JVM_DNS_TTL=${1:-30}
JVM_GC_THREADS=${2:-2}

CMD="${JAVA_HOME}/bin/java \
    -server \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+UseCGroupMemoryLimitForHeap \
    -XX:+ScavengeBeforeFullGC \
    -XX:+CMSScavengeBeforeRemark \
    -XX:ParallelGCThreads=${JVM_GC_THREADS} \
    -XX:+UseConcMarkSweepGC \
    -XX:+CMSParallelRemarkEnabled \
    -XX:+UseCMSInitiatingOccupancyOnly \
    -XX:CMSInitiatingOccupancyFraction=70 \
    -Dsun.net.inetaddr.ttl=${JVM_DNS_TTL} \
    $*"

echo ${CMD}
exec ${CMD}
```

Please note that it is **very important to use `exec` to launch your script**
or you will have signal issues.

You can control how much CPU and RAM the container see via Docker's
`--cpus`, `--memory` and `--memory-swap` switches.

## Observed JVM Memory Behavior
Using [VisualVM](https://visualvm.github.io/) I was able to watch the JVM's heap
and have the following observations. Test were run with
`OpenJDK Runtime Environment (Zulu 8.21.0.1-linux64) (build 1.8.0_131-b11)`.

1. Docker's `--memory` switch sets the cgroup settings
1. `exec` into a container and run `mount | grep cgroup | grep memory`, `more /sys/fs/cgroup/memory/memory.limit_in_bytes` to see the cgroup value
1. JVM's `-XX:+UseCGroupMemoryLimitForHeap` only respects the cgroup settings when explicit settings are **not** provided
1. setting `-Xms` and `-Xmx` can exceed the cgroup setting and what Docker thinks you are using for memory
1. not specifing heap settings cause the JVM to allocate a much smaller heap, anecdotally about half of the Docker allocation

Your situation will dictate what runtime switches to use. A scheduler, such as Kubernetes,
will only understand the cgroup settings so you can either let the JVM figure out the heap
based on what the scheduler assigns it or specify the heap settings explicitly.  If you
specify the heap by hand and get it wrong by exceeding the amount of memory the scheduler
thinks you want to use, you could cause an OOM situation with other containers.
Eventually, the JVM will catch up with the container world but until that day, we'll have
to manage memory settings very carefully.

# Troubleshooting

# License and Credits
This project is licensed under the
[Apache License Version 2.0, January 2004](http://www.apache.org/licenses/).

* [Guidance for Docker Image Authors](http://www.projectatomic.io/docs/docker-image-author-guidance/)
* [Java RAM Usage in Containers: Top 5 Tips Not to Lose Your Memory](http://blog.jelastic.com/2017/04/13/java-ram-usage-in-containers-top-5-tips-not-to-lose-your-memory/)
* [Java and Memory Limits in Containers: LXC, Docker and OpenVZ](http://blog.jelastic.com/2016/05/03/java-and-memory-limits-in-containers-lxc-docker-and-openvz/)
* [OpenJDK and Containers](https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers/)
* [Java VM Options You Should Always Use in Production](http://blog.sokolenko.me/2014/11/javavm-options-production.html)
* [Exec form ENTRYPOINT example](https://docs.docker.com/engine/reference/builder/#exec-form-entrypoint-example)
* [Java SE support for Docker CPU and memory limits](https://blogs.oracle.com/java-platform-group/java-se-support-for-docker-cpu-and-memory-limits)

# List of Changes

* removed Docker, Docker Compose and Ansible from the image. Use the build image instead.
* use `azul/zulu-openjdk:8u131` as the base image to be more Kubernetes friendly
* update to OpenJDK 64-Bit Server VM (Zulu 8.21.0.1-linux64) (build 25.131-b11, mixed mode)
