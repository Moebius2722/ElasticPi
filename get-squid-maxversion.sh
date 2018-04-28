#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Squid max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Squid max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort -V | tr "\n" " "`


####### GET-SQUID-VERSION #######

# Get Squid max installed version

SQ_VERSION=""
for ipnode in ${ipnodes[@]}
do
  SQ_NVERSION=`ssh $ipnode get-squid-version 2>/dev/null`
  if [[ "$SQ_NVERSION" > "$SQ_VERSION" ]]; then
    SQ_VERSION=$SQ_NVERSION
  fi
done

echo $SQ_VERSION
exit 0
