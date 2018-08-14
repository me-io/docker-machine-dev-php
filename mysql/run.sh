#!/bin/sh
echo
echo '* MySQL Folders'

chmod -R 777 /var/lib/mysql

echo '**** entrypoint.sh mysqld'

/image/before-startup.sh

/image/after/init_db.sh 2>&1 &

/image/startup.sh

