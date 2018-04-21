#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Mosquitto installed version


####### COMMON #######

# Check if Mosquitto is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show mosquitto >/dev/null 2>/dev/null; then
  echo "Mosquitto is not installed" >&2
  exit 1
fi


####### GET-MOSQUITTO-VERSION #######

# Get Mosquitto installed version

dpkg-query --showformat='${source:Upstream-Version}\n' --show mosquitto
