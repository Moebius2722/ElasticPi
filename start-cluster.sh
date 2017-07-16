#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Start Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticsearch/discovery-file/unicast_hosts.txt | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort` )


####### START-CLUSTER #######

# Check and Start Cluster Services
echo "================================= START-CLUSTER ================================"
date

# Start Services
for svc in nginx keepalived elasticsearch cerebro mosquitto nodered logstash kibana
do
echo "================================= $svc ================================"
for ipnode in "${ipnodes[@]}"
do
echo "$ipnode : Start $svc"
ssh -t $ipnode start-$svc >/dev/null 2>/dev/null
done
done


# Waiting Elasticsearch Up
echo "==================================== Waiting ==================================="
# Wait for start-up nodes
echo "Wait for start-up Elasticsearch nodes"
s_check=red
int_cpt=0
while [ "$s_check" != "yellow" ] && [ "$s_check" != "green" ] && [ $int_cpt -lt 120 ]; do
  s_check=`curl -ss -XGET 'localhost:9200/_cat/health?pretty'|cut -d ' ' -f 4`
  echo -n '.'
  sleep 5
  int_cpt=$[$int_cpt+1]
done
echo
if [ "$s_check" != "yellow" ] && [ "$s_check" != "green" ] && [ $int_cpt -eq 120 ]; then
  echo "Time Out for start-up nodes"
else
  # Purge shard allocation exclusion
  echo "Purge shard allocation exclusion"
  curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
  {
    "transient": {
      "cluster.routing.allocation.exclude._ip" : null
    }
  }
  ' >/dev/null 2>/dev/null
  # Reenable shard allocation
  echo "Reenable shard allocation"
  curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
  {
    "transient": {
      "cluster.routing.allocation.enable": "all"
    }
  }
  ' >/dev/null 2>/dev/null
fi

# Wait for the nodes to recover
echo "Wait for the Elasticsearch nodes to recover"
int_cpt=0
while [ "$s_check" != "green" ] && [ $int_cpt -lt 180 ]; do
  s_check=`curl -ss -XGET 'localhost:9200/_cat/health?pretty'|cut -d ' ' -f 4`
  echo -n '.'
  sleep 10
  int_cpt=$[$int_cpt+1]
done
echo
if [ "$s_check" != "green" ] && [ $int_cpt -eq 180 ]; then
  echo "Time Out for the node to recover."
fi

date
echo "================================= CLUSTER-START ================================"
