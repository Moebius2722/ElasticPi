#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Get Nodes Count on Raspberry Pi 2 or 3


####### GET-NODES-COUNT #######

# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$'` )

count=0
for ipnode in "${ipnodes[@]}"
do
  count=$[$count+1]
done
echo $count
