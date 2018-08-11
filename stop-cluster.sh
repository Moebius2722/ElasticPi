#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Stop Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort -V` )


####### STOP-CLUSTER #######

# Check and Stop Cluster Services
echo "================================= STOP-CLUSTER ================================="
date

# Stop Services
#for svc in keepalived nginx kibana logstash nodered mosquitto cerebro
for svc in nodered mosquitto metricbeat logstash kibana cerebro squid keepalived nginx
do
echo "================================= $svc ================================"
for ipnode in "${ipnodes[@]}"
do
echo "$ipnode : Stop $svc"
ssh -t $ipnode stop-$svc >/dev/null 2>/dev/null
done
done


# Backup Elasticsearch before stop
echo "============================= Backup Elasticsearch ============================="
backup-elasticsearch

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
for ipnode in "${ipnodes[@]}"
do
  ssh -t $ipnode sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "$ipnode : Stop elasticsearch"
    ssh -t $ipnode "curl -XPOST 'localhost:9200/_flush/synced?pretty'" >/dev/null 2>/dev/null
  fi
  ssh -t $ipnode stop-elasticsearch >/dev/null 2>/dev/null
done

date
echo "================================= CLUSTER-STOP ================================="
