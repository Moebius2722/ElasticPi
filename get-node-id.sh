#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Get Node ID on Raspberry Pi 2 or 3


####### GET-NODE-ID #######

# Set IP Node
if [[ $# -eq 1 ]] ; then
  iphost=$1
else
  iphost=`hostname -i`
fi

# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$'` )

id=0
for ipnode in "${ipnodes[@]}"
do
  id=$[$id+1]
  if [[ "$iphost" ==  "$ipnode" ]]; then
    echo $id
    exit 0
  fi
done
echo "Host IP not known" >&2
exit 1
