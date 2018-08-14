#!/usr/bin/env bash

eval "$(docker-machine env dev)"
docker ps -aq -f status=exited | xargs docker rm
docker images -q --no-trunc -f dangling=true | xargs  docker rmi
