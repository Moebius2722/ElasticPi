#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Logstash max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Logstash max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort | tr "\n" " "`


####### GET-LOGSTASH-VERSION #######

# Get Logstash max installed version

LS_VERSION=""
for ipnode in ${ipnodes[@]}
do
  LS_NVERSION=`ssh $ipnode get-logstash-version 2>/dev/null`
  if [[ "$LS_NVERSION" > "$LS_VERSION" ]]; then
    LS_VERSION=$LS_NVERSION
  fi
done

echo $LS_VERSION
exit 0
