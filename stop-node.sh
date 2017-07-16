#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Stop Node Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Node
if [[ $# = 0 ]] ; then
  ipnode=`hostname -i`
else
  ipnode=$1
fi


####### STOP-NODE #######

# Check and Stop Node Services
echo "================================== STOP-NODE ==================================="
date

# Stop Elasticsearch
echo "================================= Elasticsearch ================================"
# Disable shard allocation
echo "Disable shard allocation"
curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
{
  "transient": {
    "cluster.routing.allocation.enable": "none"
  }
}
' >/dev/null 2>/dev/null

sleep 10

# Flush Index and Stop Elasticsearch Services
ssh -t $ipnode sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  # Exclude node of shard allocation
  #ssh -t $ipnode "curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
  #{
  #  \"transient\": {
  #    \"cluster.routing.allocation.exclude._ip\" : \"$ipnode\"
  #  }
  #}
  #'
  #" >/dev/null 2>/dev/null
  ## Wait for node entering in maintenance mode
  #echo "Wait for node entering in maintenance mode"
  #nb_shards=1
  #int_cpt=0
  #while [ "$nb_shards" != "0" ] && [ $int_cpt -lt 120 ]; do
  #  nb_shards=`curl -ss -XGET 'localhost:9200/_cat/shards'|grep -ic "$ipnode"`
  #  echo -n '.'
  #  sleep 5
  #  int_cpt=$[$int_cpt+1]
  #done
  #echo
  echo "$ipnode : Stop elasticsearch"
  ssh -t $ipnode "curl -XPOST 'localhost:9200/_flush/synced?pretty'" >/dev/null 2>/dev/null
fi
ssh -t $ipnode stop-elasticsearch >/dev/null 2>/dev/null


# Stop Services
for svc in logstash kibana nodered mosquitto cerebro keepalived nginx         
do
echo "================================= $svc ================================"
echo "$ipnode : Stop $svc"
ssh -t $ipnode stop-$svc >/dev/null 2>/dev/null
done


date
echo "================================== NODE-STOP ==================================="
