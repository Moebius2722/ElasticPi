#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Kibana installed version


####### COMMON #######

# Check if Kibana is installed

if ! dpkg-query -W -f='${Version}\n' kibana >/dev/null 2>/dev/null; then
  echo "Kibana is not installed" >&2
  exit 1
fi


####### GET-KIBANA-VERSION #######

# Get Kibana installed version

dpkg-query -W -f='${Version}\n' kibana