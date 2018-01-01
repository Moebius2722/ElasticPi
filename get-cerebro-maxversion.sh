#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Cerebro max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Cerebro max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort | tr "\n" " "`


####### GET-CEREBRO-VERSION #######

# Get Cerebro max installed version

CB_VERSION=""
for ipnode in ${ipnodes[@]}
do
  CB_NVERSION=`ssh $ipnode get-cerebro-version 2>/dev/null`
  if [[ "$CB_NVERSION" > "$CB_VERSION" ]]; then
    CB_VERSION=$CB_NVERSION
  fi
done

echo $CB_VERSION
exit 0
