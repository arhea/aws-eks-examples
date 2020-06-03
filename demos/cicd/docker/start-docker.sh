#!/bin/bash

/usr/bin/dockerd \
    	--host=unix:///var/run/docker.sock \
    	--storage-driver=overlay &>/var/log/docker.log &
