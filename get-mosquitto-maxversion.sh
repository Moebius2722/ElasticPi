#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Mosquitto max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Mosquitto max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort | tr "\n" " "`


####### GET-MOSQUITTO-VERSION #######

# Get Mosquitto max installed version

MQ_VERSION=""
for ipnode in ${ipnodes[@]}
do
  MQ_NVERSION=`ssh $ipnode get-mosquitto-version 2>/dev/null`
  if [[ "$MQ_NVERSION" > "$MQ_VERSION" ]]; then
    MQ_VERSION=$MQ_NVERSION
  fi
done

echo $MQ_VERSION
exit 0
