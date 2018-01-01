#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Metricbeat max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Metricbeat max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort | tr "\n" " "`


####### GET-METRICBEAT-VERSION #######

# Get Metricbeat max installed version

MB_VERSION=""
for ipnode in ${ipnodes[@]}
do
  L_NVERSION=`ssh $ipnode get-metricbeat-version 2>/dev/null`
  if [[ "$MB_NVERSION" > "$MB_VERSION" ]]; then
    MB_VERSION=$MB_NVERSION
  fi
done

echo $MB_VERSION
exit 0
