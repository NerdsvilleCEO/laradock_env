#! /bin/bash
echo ---------- rebuild docker containers ----------

LaraDock_DBG=1;
if [[ "$1" == "--silence" || "$2" == "--silence" ]]; then
    LaraDock_DBG=0;
fi
LaraDock_STOP=1;
if [[ "$1" == "--stopped" || "$2" == "--stopped" ]]; then
    LaraDock_STOP=0;
fi

LaraDock_Service="`cat cmd/service.lst`"

cd laradock
    if [[ "$LaraDock_STOP" == "1" ]]; then
        docker-compose stop
    fi
    docker-compose pull
    LaraDock_PARAM='cat'
    if [[ "$LaraDock_DBG" == "0" ]]; then
        LaraDock_PARAM='grep -v ^\s---'
    fi
    echo ---------- rebuild: $LaraDock_Service ----------
    docker-compose build --pull $LaraDock_Service | $LaraDock_PARAM
cd ..

cmd/up.sh -

docker exec --user=laradock -it laradock_workspace_1 bash -c 'composer install;php ./artisan migrate'
docker exec -it laradock_workspace_1 bash -c 'service supervisor start;'
#supervisorctl start laravel-worker:*

cd laradock
    ./xdebugPhpFpm start
    ./xdebugPhpCli start laravel
cd ..
cmd/ps.sh
cmd/conn-workspace.sh  