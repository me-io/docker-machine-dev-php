#!/usr/bin/env bash
set -e

if [ -z "$SUDO_USER" ]; then
CUSER=$USER
else
CUSER=$SUDO_USER
fi

which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    #brew update
    true
fi

brew upgrade docker
docker-machine upgrade dev

docker-machine create --driver xhyve --xhyve-boot2docker-url="./scripts/boot2docker.iso" --xhyve-cpu-count 4 --xhyve-memory-size "8096" --xhyve-disk-size "20000" dev