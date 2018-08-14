#!/bin/bash
set -e
echo
echo '**** entrypoint.sh nginx'

/image/before-startup.sh

# start all the services
/usr/sbin/nginx -c /etc/nginx/nginx.conf

