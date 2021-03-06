#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Keepalived installed version


####### COMMON #######

# Check if Keepalived is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show keepalived >/dev/null 2>/dev/null; then
  echo "Keepalived is not installed" >&2
  exit 1
fi


####### GET-KEEPALIVED-VERSION #######

# Get Keepalived installed version

dpkg-query --showformat='${source:Upstream-Version}\n' --show keepalived 2>/dev/null | head -n 1
