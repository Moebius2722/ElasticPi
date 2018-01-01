#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Node-RED max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Node-RED max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort | tr "\n" " "`


####### GET-NODERED-VERSION #######

# Get Node-RED max installed version

NR_VERSION=""
for ipnode in ${ipnodes[@]}
do
  NR_NVERSION=`ssh $ipnode get-nodered-version 2>/dev/null`
  if [[ "$NR_NVERSION" > "$NR_VERSION" ]]; then
    NR_VERSION=$NR_NVERSION
  fi
done

echo $NR_VERSION
exit 0
