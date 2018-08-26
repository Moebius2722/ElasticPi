#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Logstash installed version


####### GET-LOGSTASH-VERSION #######

# Check if Logstash OSS is installed

if dpkg-query --showformat='${source:Upstream-Version}\n' --show logstash-oss >/dev/null 2>/dev/null; then
  # Get Logstash installed version
  dpkg-query --showformat='${source:Upstream-Version}\n' --show logstash-oss 2>/dev/null | head -n 1
  exit 0
fi

# Check if Logstash is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show logstash >/dev/null 2>/dev/null; then
  echo "Logstash is not installed" >&2
  exit 1
else
  # Get Logstash installed version
  dpkg-query --showformat='${source:Upstream-Version}\n' --show logstash 2>/dev/null | head -n 1
  exit 0
fi
