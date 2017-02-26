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

# Stop Keepalived
echo "================================== Keepalived =================================="
ssh -t $ipnode sudo systemctl status keepalived.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Keepalived"
  ssh -t $ipnode sudo systemctl stop keepalived.service >/dev/null 2>/dev/null
fi
ssh -t $ipnode sudo systemctl disable keepalived.service >/dev/null 2>/dev/null

# Stop Nginx
echo "===================================== Nginx ===================================="
ssh -t $ipnode sudo systemctl status nginx.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Nginx"
  ssh -t $ipnode sudo systemctl stop nginx.service >/dev/null 2>/dev/null
fi
ssh -t $ipnode sudo systemctl disable nginx.service >/dev/null 2>/dev/null

# Stop Kibana
echo "==================================== Kibana ===================================="
ssh -t $ipnode sudo systemctl status kibana.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Kibana"
  ssh -t $ipnode sudo systemctl stop kibana.service >/dev/null 2>/dev/null
fi
ssh -t $ipnode sudo systemctl disable kibana.service >/dev/null 2>/dev/null

# Stop Logstash
echo "=================================== Logstash ==================================="
ssh -t $ipnode sudo systemctl status logstash.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Logstash"
  ssh -t $ipnode sudo systemctl stop logstash.service >/dev/null 2>/dev/null
fi
ssh -t $ipnode sudo systemctl disable logstash.service >/dev/null 2>/dev/null

# Stop Node-RED
echo "=================================== Node-RED ==================================="
ssh -t $ipnode sudo systemctl status nodered.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Node-RED"
  ssh -t $ipnode sudo systemctl stop nodered.service >/dev/null 2>/dev/null
fi
ssh -t $ipnode sudo systemctl disable nodered.service >/dev/null 2>/dev/null

# Stop Mosquitto
echo "=================================== Mosquitto =================================="
ssh -t $ipnode sudo systemctl status mosquitto.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Mosquitto"
  ssh -t $ipnode sudo systemctl stop mosquitto.service >/dev/null 2>/dev/null
fi
ssh -t $ipnode sudo systemctl disable mosquitto.service >/dev/null 2>/dev/null

# Stop Cerebro
echo "==================================== Cerebro ==================================="
ssh -t $ipnode sudo systemctl status cerebro.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  echo "$ipnode : Stop Cerebro"
  ssh -t $ipnode sudo systemctl stop cerebro.service >/dev/null 2>/dev/null
fi
ssh -t $ipnode sudo systemctl disable cerebro.service >/dev/null 2>/dev/null

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
  echo "$ipnode : Stop Elasticsearch"
  ssh -t $ipnode "curl -XPOST 'localhost:9200/_flush/synced?pretty' ; sudo systemctl stop elasticsearch.service" >/dev/null 2>/dev/null
fi
ssh -t $ipnode sudo systemctl disable elasticsearch.service >/dev/null 2>/dev/null

date
echo "================================== NODE-STOP ==================================="
