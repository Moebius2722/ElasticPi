#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Elasticsearch installed version


####### COMMON #######

# Check if Elasticsearch is installed

if ! dpkg-query -W -f='${Version}\n' elasticsearch >/dev/null 2>/dev/null; then
  echo "Elasticsearch is not installed" >&2
  exit 1
fi


####### GET-ELASTICSEARCH-VERSION #######

# Get Elasticsearch installed version

dpkg-query -W -f='${Version}\n' elasticsearch