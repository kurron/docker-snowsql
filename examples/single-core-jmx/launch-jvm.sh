#!/bin/bash

set -e


# Showcases settings described in http://blog.sokolenko.me/2014/11/javavm-options-production.html and
# https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers/
# Since we are running in a container, the heap dump and RMI settings have been omitted.

# This is a sample to show how you might invoke the JVM using settings that are
# approprivate for a single core environment.  We're using the new CGroup-aware
# memory settings.

JVM_DNS_TTL=${1:-30}
JVM_HEAP=${2:-32m}
JVM_JMX_PORT=${3:-2020}

# If you want to be explicit about memory settings
#-XX:MaxRam=${JVM_MAX_RAM} \
#-XX:MaxMetaspaceSize=${JVM_METASPACE} \

# Useful in debugging
# -XX:+PrintFlagsFinal \

#   -Xms${JVM_HEAP} \
#   -Xmx${JVM_HEAP} \

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
    -Dcom.sun.management.jmxremote.port=${JVM_JMX_PORT} \
    -Dcom.sun.management.jmxremote.rmi.port=${JVM_JMX_PORT} \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.ssl=false \
    $*"

echo ${CMD}
exec ${CMD}
