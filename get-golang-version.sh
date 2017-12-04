#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Golang installed version


####### COMMON #######

# Check if Golang is installed

if ! go version >/dev/null 2>/dev/null; then
  echo "Golang is not installed" >&2
  exit 1
fi


####### GET-GOLANG-VERSION #######

# Get Golang installed version

go version | cut -d ' ' -f 3
