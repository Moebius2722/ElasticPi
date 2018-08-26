#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Metricbeat installed version


####### GET-METRICBEAT-VERSION #######

# Check if Metricbeat OSS is installed

if dpkg-query --showformat='${source:Upstream-Version}\n' --show metricbeat-oss >/dev/null 2>/dev/null; then
  # Get Metricbeat installed version
  dpkg-query --showformat='${source:Upstream-Version}\n' --show metricbeat-oss 2>/dev/null | head -n 1
  exit 0
fi

# Check if Metricbeat is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show metricbeat >/dev/null 2>/dev/null; then
  echo "Metricbeat is not installed" >&2
  exit 1
else
  # Get Metricbeat installed version
  dpkg-query --showformat='${source:Upstream-Version}\n' --show metricbeat 2>/dev/null | head -n 1
  exit 0
fi
