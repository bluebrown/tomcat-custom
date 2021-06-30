#!/bin/bash

set -ex

image="rjtest.concentrix.com:5443/tomcat:8.5"

for item in $(docker run "$image" ls conf); do
    docker run "$image" cat "conf/$item" 2>&1 | cat > "conf/$item"
done
