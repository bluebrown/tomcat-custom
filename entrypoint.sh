#!/bin/bash

set -e
CATALINA_OPTS="-Djava.security.egd=file:/dev/./urandom $CATALINA_OPTS"
export CATALINA_OPTS
exec $@