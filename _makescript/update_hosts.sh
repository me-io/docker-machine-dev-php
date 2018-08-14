#!/usr/bin/env bash
#ip addr add 192.168.64.100/32 dev bridge100
#DEVIP="192.168.64.100"
#DEVIP=$(docker-machine ip dev)
DEVIP=$(cat ~/.docker/machine/machines/dev/config.json | grep IPAddress | cut -d'"' -f4)
if [ "$DEVIP" = 0 ] || [ "$DEVIP" = "" ]; then
    echo "Run or create the docker machine"
    exit 1
fi
# docker machine version
DV="docker-machine-v2"
FILE=/etc/hosts
echo
echo "medevCOM Machine IP : "  $DEVIP
echo
echo "* Updating $FILE file"
grep -q "#$DV" "$FILE"
RESETHOST=$?
if [ "$RESETHOST" = 1 ]; then
echo "##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
" > $FILE
fi

#echo "##
## Host Database
##
## localhost is used to configure the loopback interface
## when the system is booting.  Do not change this entry.
###
#127.0.0.1	localhost
#255.255.255.255	broadcasthost
#::1             localhost" > /etc/hosts
#echo "# =====DEV MACHINE IPS START=====" >> /etc/hosts
hosts=(
    "www-api.medev.local"
    "config-api.medev.local"
    "myaccount-api.medev.local"
    "location-api.medev.local"
    "schedule-api.medev.local"
    "all-api.medev.local"
    "medev-machine"
    )


for i in "${hosts[@]}"
do
   :
   LINE=$DEVIP"    "$i" #$DV"
   LINEGREP=" "$i
   HOSTDATA=$(grep -vwE "$LINEGREP" $FILE)
   echo "$HOSTDATA" > "$FILE"
   echo "$LINE" >> "$FILE"
   #echo "=> "$LINE
done
echo
# Get the HOST IP to use inside docker
VIRTUALHOST="dockerhost"
DOCKERHOST="$(ifconfig  | grep 'inet ' | grep -v '127.0.0.1' | cut -d' ' -f2 | head -1) $VIRTUALHOST"

echo "* NOTE: To access host machine inside docker, add following to $FILE file of the container"
echo "=>" $DOCKERHOST
#echo "# =====DEV MACHINE IPS START=====" >> /etc/hosts
