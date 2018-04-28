#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get NodeJS installed version


####### COMMON #######

# Check if NodeJS is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show nodejs >/dev/null 2>/dev/null; then
  echo "NodeJS is not installed" >&2
  exit 1
fi


####### GET-NODEJS-VERSION #######

# Get NodeJS installed version

dpkg-query --showformat='${source:Upstream-Version}\n' --show nodejs
