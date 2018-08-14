#!/bin/bash
set -e
echo
echo '**** entrypoint.sh redis'

sh /image/before-startup.sh

redis-server /image/files/server.conf

