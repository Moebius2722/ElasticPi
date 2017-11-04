#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Nginx max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Nginx max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort | tr "\n" " "`


####### GET-NGINX-VERSION #######

# Get Nginx max installed version

L_VERSION=""
for ipnode in ${ipnodes[@]}
do
  L_NVERSION=`ssh $ipnode get-nginx-version 2>/dev/null`
  if [[ "$L_NVERSION" > "$L_VERSION" ]]; then
    L_VERSION=$L_NVERSION
  fi
done

echo $L_VERSION
exit 0
