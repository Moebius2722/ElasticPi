#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Stop Node Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Node
if [[ $# = 0 ]] ; then
  ipnode=`hostname -i`
else
  ipnode=$1
fi

####### STOP-CLUSTER #######

# Check and Stop Cluster Services

# Stop Keepalived
echo "================================== Keepalived =================================="
ssh $ipnode sudo systemctl status keepalived.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Keepalived"
  ssh $ipnode sudo systemctl stop keepalived.service >/dev/null 2>/dev/null
fi
ssh $ipnode sudo systemctl disable keepalived.service >/dev/null 2>/dev/null

# Stop Nginx
echo "===================================== Nginx ===================================="
ssh $ipnode sudo systemctl status nginx.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Nginx"
  ssh $ipnode sudo systemctl stop nginx.service >/dev/null 2>/dev/null
fi
ssh $ipnode sudo systemctl disable nginx.service >/dev/null 2>/dev/null

# Stop Kibana
echo "==================================== Kibana ===================================="
ssh $ipnode sudo systemctl status kibana.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Kibana"
  ssh $ipnode sudo systemctl stop kibana.service >/dev/null 2>/dev/null
fi
ssh $ipnode sudo systemctl disable kibana.service >/dev/null 2>/dev/null

# Stop Logstash
echo "=================================== Logstash ==================================="
ssh $ipnode sudo systemctl status logstash.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Logstash"
  ssh $ipnode sudo systemctl stop logstash.service >/dev/null 2>/dev/null
fi
ssh $ipnode sudo systemctl disable logstash.service >/dev/null 2>/dev/null

# Stop Node-RED
echo "=================================== Node-RED ==================================="
ssh $ipnode sudo systemctl status nodered.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Node-RED"
  ssh $ipnode sudo systemctl stop nodered.service >/dev/null 2>/dev/null
fi
ssh $ipnode sudo systemctl disable nodered.service >/dev/null 2>/dev/null

# Stop Mosquitto
echo "=================================== Mosquitto =================================="
ssh $ipnode sudo systemctl status mosquitto.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Mosquitto"
  ssh $ipnode sudo systemctl stop mosquitto.service >/dev/null 2>/dev/null
fi
ssh $ipnode sudo systemctl disable mosquitto.service >/dev/null 2>/dev/null

# Stop Cerebro
echo "==================================== Cerebro ==================================="
ssh $ipnode sudo systemctl status cerebro.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Cerebro"
  ssh $ipnode sudo systemctl stop cerebro.service >/dev/null 2>/dev/null
fi
ssh $ipnode sudo systemctl disable cerebro.service >/dev/null 2>/dev/null

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

# Flush Index and Stop Elasticsearch Services
ssh $ipnode sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Elasticsearch"
  ssh $ipnode "curl -XPOST 'localhost:9200/_flush/synced?pretty' ; sudo systemctl stop elasticsearch.service" >/dev/null 2>/dev/null
fi
ssh $ipnode sudo systemctl disable elasticsearch.service >/dev/null 2>/dev/null
