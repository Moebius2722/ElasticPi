#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get NodeJS max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Mosquitto max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort | tr "\n" " "`


####### GET-NODEJS-VERSION #######

# Get NodeJS max installed version

NJ_VERSION=""
for ipnode in ${ipnodes[@]}
do
  NJ_NVERSION=`ssh $ipnode get-nodejs-version 2>/dev/null`
  if [[ "$NJ_NVERSION" > "$NJ_VERSION" ]]; then
    NJ_VERSION=$NJ_NVERSION
  fi
done

echo $NJ_VERSION
exit 0
