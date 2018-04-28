#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Keepalived max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Keepalived max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort -V | tr "\n" " "`


####### GET-KEEPALIVED-VERSION #######

# Get Keepalived max installed version

KA_VERSION=""
for ipnode in ${ipnodes[@]}
do
  KA_NVERSION=`ssh $ipnode get-keepalived-version 2>/dev/null`
  if [[ "$KA_NVERSION" > "$KA_VERSION" ]]; then
    KA_VERSION=$KA_NVERSION
  fi
done

echo $KA_VERSION
exit 0
