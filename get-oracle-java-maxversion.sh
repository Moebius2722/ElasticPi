#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Oracle Java max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Oracle Java max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort | tr "\n" " "`


####### GET-ORACLE-JAVA-VERSION #######

# Get Oracle Java max installed version

OJ_VERSION=""
for ipnode in ${ipnodes[@]}
do
  OJ_NVERSION=`ssh $ipnode get-oracle-java-version 2>/dev/null`
  if [[ "$OJ_NVERSION" > "$OJ_VERSION" ]]; then
    OJ_VERSION=$OJ_NVERSION
  fi
done

echo $OJ_VERSION
exit 0
