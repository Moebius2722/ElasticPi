#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Elasticsearch installed version


####### GET-ELASTICSEARCH-VERSION #######

# Check if Elasticsearch OSS is installed

if dpkg-query --showformat='${source:Upstream-Version}\n' --show elasticsearch-oss >/dev/null 2>/dev/null; then
  # Get Elasticsearch installed version
  dpkg-query --showformat='${source:Upstream-Version}\n' --show elasticsearch-oss 2>/dev/null | head -n 1
  exit 0
fi

# Check if Elasticsearch is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show elasticsearch >/dev/null 2>/dev/null; then
  echo "Elasticsearch is not installed" >&2
  exit 1
else
  # Get Elasticsearch installed version
  dpkg-query --showformat='${source:Upstream-Version}\n' --show elasticsearch 2>/dev/null | head -n 1
  exit 0
fi
