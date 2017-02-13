#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Remote SSH for All Elasticsearch Nodes on Raspberry Pi 2 or 3


####### ALLSSH #######

echo "Executing $*"
ilength=80
iphost=`hostname -i`

ipnodes=( `sudo cat /etc/elasticsearch/discovery-file/unicast_hosts.txt | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | grep -v $iphost | sort` )
for ipnode in "${ipnodes[@]}"
do
  iipnode=${#ipnode}
  ibegin=$(((($ilength-$iipnode-2)/2)+(($ilength-$iipnode-2)%2)))
  iend=$((($ilength-$iipnode-2)/2))
  sbegin=`printf "%${ibegin}s" | tr " " "="`
  send=`printf "%${iend}s" | tr " " "="`
  echo "$sbegin $ipnode $send"
  ssh -t $ipnode $*
done

iiphost=${#iphost}
ibegin=$(((($ilength-$iiphost-2)/2)+(($ilength-$iiphost-2)%2)))
iend=$((($ilength-$iiphost-2)/2))
sbegin=`printf "%${ibegin}s" | tr " " "="`
send=`printf "%${iend}s" | tr " " "="`
echo "$sbegin $iphost $send"
ssh -t $iphost $*
