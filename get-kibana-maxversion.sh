#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Kibana max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Kibana max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort -V | tr "\n" " "`


####### GET-KIBANA-VERSION #######

# Get Kibana max installed version

KB_VERSION=""
for ipnode in ${ipnodes[@]}
do
  KB_NVERSION=`ssh $ipnode get-kibana-version 2>/dev/null`
  if [[ "$KB_NVERSION" > "$KB_VERSION" ]]; then
    KB_VERSION=$KB_NVERSION
  fi
done

echo $KB_VERSION
exit 0
