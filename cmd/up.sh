#! /bin/bash

LaraDock_Service="`cat cmd/service.lst`"
cd laradock
    echo ---------- up: LaraDock_Service ----------
    docker-compose up -d $LaraDock_Service
cd ..
 cmd/ps.sh

if [[ "$1" != "-" ]]; then
    cmd/conn-workspace.sh
fi                                           
