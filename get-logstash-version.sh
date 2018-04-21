#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Logstash installed version


####### COMMON #######

# Check if Logstash is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show logstash >/dev/null 2>/dev/null; then
  echo "Logstash is not installed" >&2
  exit 1
fi


####### GET-LOGSTASH-VERSION #######

# Get Logstash installed version

dpkg-query --showformat='${source:Upstream-Version}\n' --show logstash | cut -d : -f2 | cut -d - -f1
