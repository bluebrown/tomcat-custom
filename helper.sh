#!/bin/bash

for item in $(docker run tc ls conf); do
    docker run tc cat "conf/$item" 2>&1 | cat >> "conf/$item"
done
