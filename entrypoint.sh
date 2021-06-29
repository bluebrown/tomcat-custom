#!/bin/bash

set -e

CATALINA_OPTS="\
    -Djava.security.egd=file:/dev/./urandom \
    -XX:ParallelGCThreads=${JVM_GC_THREADS:-'2'} \
    -XX:MaxRAM=${JVM_MAX_RAM:-'4G'} \
    -XX:GCTimeRatio=${JVM_GC_TIME_RATIO='4'} \
    -XX:AdaptiveSizePolicyWeight=${JVM_GC_ADAPT_WEIGHT:-'90'} \
    $JAVA_OPTS
    "


export CATALINA_OPTS

exec $@