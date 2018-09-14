#!/bin/bash

set -e


# Showcases settings described in http://blog.sokolenko.me/2014/11/javavm-options-production.html and
# https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers/
# Since we are running in a container, the heap dump and RMI settings have been omitted.

# This is a sample to show how you might invoke the JVM using settings that are
# approprivate for a single core environment.  We're using the new CGroup-aware
# memory settings.

JVM_DNS_TTL=${1:-30}

# If you want to be explicit about memory settings
#-XX:MaxRam=${JVM_MAX_RAM} \
#-Xms${JVM_HEAP_MIN} \
#-Xmx${JVM_HEAP_MAX} \
#-XX:MaxMetaspaceSize=${JVM_METASPACE} \

# Useful in debugging
# -XX:+PrintFlagsFinal \

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
