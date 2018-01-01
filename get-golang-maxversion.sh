#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Golang max installed version


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before get Golang max version"
  exit 1
fi

# Get IP Nodes
ipnodes=`sudo cat /etc/elasticpi/nodes.lst | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort | tr "\n" " "`


####### GET-GOLANG-VERSION #######

# Get Golang max installed version

GO_VERSION=""
for ipnode in ${ipnodes[@]}
do
  GO_NVERSION=`ssh $ipnode get-golang-version 2>/dev/null`
  if [[ "$GO_NVERSION" > "$GO_VERSION" ]]; then
    GO_VERSION=$GO_NVERSION
  fi
done

echo $GO_VERSION
exit 0
