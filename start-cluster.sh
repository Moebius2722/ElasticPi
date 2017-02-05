#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Start Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticsearch/discovery-file/unicast_hosts.txt | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort` )


####### START-CLUSTER #######

# Check and Start Cluster Services

for ipnode in "${ipnodes[@]}"
do
  iipnode=${#ipnode}
  ibegin=$(((($ilength-$iipnode-2)/2)+(($ilength-$iipnode-2)%2)))
  iend=$((($ilength-$iipnode-2)/2))
  sbegin=`printf "%${ibegin}s" | tr " " "="`
  send=`printf "%${iend}s" | tr " " "="`
  echo "$sbegin $ipnode $send"
  
  ssh $ipnode sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Elasticsearch"
    ssh $ipnode sudo systemctl start elasticsearch.service >/dev/null 2>/dev/null
  fi
  ssh $ipnode sudo systemctl status logstash.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Logstash"
	ssh $ipnode sudo systemctl start logstash.service >/dev/null 2>/dev/null
  fi
  ssh $ipnode sudo systemctl status kibana.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Kibana"
	ssh $ipnode sudo systemctl start kibana.service >/dev/null 2>/dev/null
  fi
  ssh $ipnode sudo systemctl status nginx.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Nginx"
	ssh $ipnode sudo systemctl start nginx.service >/dev/null 2>/dev/null
  fi
  ssh $ipnode sudo systemctl status cerebro.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Cerebro"
    ssh $ipnode sudo systemctl start cerebro.service >/dev/null 2>/dev/null
  fi
  ssh $ipnode sudo systemctl status nodered.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Node-RED"
    ssh $ipnode sudo systemctl start nodered.service >/dev/null 2>/dev/null
  fi
  ssh $ipnode sudo systemctl status mosquitto.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "$ipnode : Start Mosquitto"
    ssh $ipnode sudo systemctl start mosquitto.service >/dev/null 2>/dev/null
  fi
done
