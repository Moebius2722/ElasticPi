#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Kibana installed version


####### GET-KIBANA-VERSION #######

# Check if Kibana OSS is installed

if dpkg-query --showformat='${source:Upstream-Version}\n' --show kibana-oss >/dev/null 2>/dev/null; then
  # Get Kibana installed version
  dpkg-query --showformat='${source:Upstream-Version}\n' --show kibana-oss 2>/dev/null | head -n 1
  exit 0
fi

# Check if Kibana is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show kibana >/dev/null 2>/dev/null; then
  echo "Kibana is not installed" >&2
  exit 1
else
  # Get Kibana installed version
  dpkg-query --showformat='${source:Upstream-Version}\n' --show kibana 2>/dev/null | head -n 1
  exit 0
fi
