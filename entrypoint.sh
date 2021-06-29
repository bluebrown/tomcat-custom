#!/bin/bash

set -e

CATALINA_OPTS="\
    -Djava.security.egd=file:/dev/./urandom \
    -XX:ParallelGCThreads=${GC_THREADS:-'2'} \
    -XX:MaxRAM=${GC_MAXRAM:-'4G'} \
    -XX:GCTimeRatio=${GC_TIME_RATIO='4'} \
    -XX:AdaptiveSizePolicyWeight=${GC_ADAPT_WEIGHT:-'90'}"

export CATALINA_OPTS

exec $@