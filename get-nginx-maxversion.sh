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
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort -V | tr "\n" " "`


####### GET-NGINX-VERSION #######

# Get Nginx max installed version

NGX_VERSION=""
for ipnode in ${ipnodes[@]}
do
  NGX_NVERSION=`ssh $ipnode get-nginx-version 2>/dev/null`
  if [[ "$NGX_NVERSION" > "$NGX_VERSION" ]]; then
    NGX_VERSION=$NGX_NVERSION
  fi
done

echo $NGX_VERSION
exit 0
