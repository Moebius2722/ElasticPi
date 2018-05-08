#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Squid installed version


####### COMMON #######

# Check if Squid is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show squid >/dev/null 2>/dev/null; then
  echo "Squid is not installed" >&2
  exit 1
fi


####### GET-SQUID-VERSION #######

# Get Squid installed version

dpkg-query --showformat='${source:Upstream-Version}\n' --show squid 2>/dev/null | head -n 1
