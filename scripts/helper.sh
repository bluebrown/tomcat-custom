#!/bin/bash

# Thi script will pull all config files from the target tomcat images 
# and save them into a local the conf folder.

set -ex

image="$1"

if [ -z "$image" ]
  then
    image="tomcat:latest"
fi



for item in $(docker run "$image" ls conf); do
    docker run "$image" cat "conf/$item" 2>&1 | cat > "conf/$item"
done
