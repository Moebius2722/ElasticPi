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

# Start Elasticsearch
echo "================================= Elasticsearch ================================"
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl enable elasticsearch.service >/dev/null 2>/dev/null
  ssh $ipnode sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Elasticsearch"
	ssh $ipnode sudo systemctl start elasticsearch.service >/dev/null 2>/dev/null
  fi
done

# Wait for start-up nodes
echo "Wait for start-up nodes"
b_check=0
int_cpt=0
while [ $b_check -eq 0 -a $int_cpt -lt 120 ]; do
  b_check=`curl -ss -XGET 'localhost:9200/_cat/health?pretty'|cut -d ' ' -f 4|grep -ci yellow`
  echo -n '.'
  sleep 5
  int_cpt=$[$int_cpt+1]
done
echo
if [ $b_check -eq 0 -a $int_cpt -eq 120 ]; then
  echo "Time Out for start-up nodes"
else
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

# Wait for the node to recover
echo "Wait for the nodes to recover"
b_check=0
int_cpt=0
while [ $b_check -eq 0 -a $int_cpt -lt 180 ]; do
  b_check=`curl -ss -XGET 'localhost:9200/_cat/health?pretty'|cut -d ' ' -f 4|grep -ci green`
  echo -n '.'
  sleep 10
  int_cpt=$[$int_cpt+1]
done
echo
if [ $b_check -eq 0 -a $int_cpt -eq 180 ]; then
  echo "Time Out for the node to recover."
fi

# Start Cerebro
echo "==================================== Cerebro ==================================="
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl enable cerebro.service >/dev/null 2>/dev/null
  ssh $ipnode sudo systemctl status cerebro.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Cerebro"
	ssh $ipnode sudo systemctl start cerebro.service >/dev/null 2>/dev/null
  fi
done

# Start Mosquitto
echo "=================================== Mosquitto =================================="
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl enable mosquitto.service >/dev/null 2>/dev/null
  ssh $ipnode sudo systemctl status mosquitto.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Mosquitto"
	ssh $ipnode sudo systemctl start mosquitto.service >/dev/null 2>/dev/null
  fi
done

# Start Node-RED
echo "=================================== Node-RED ==================================="
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl enable nodered.service >/dev/null 2>/dev/null
  ssh $ipnode sudo systemctl status nodered.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Node-RED"
	ssh $ipnode sudo systemctl start nodered.service >/dev/null 2>/dev/null
  fi
done

# Start Logstash
echo "=================================== Logstash ==================================="
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl enable logstash.service >/dev/null 2>/dev/null
  ssh $ipnode sudo systemctl status logstash.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Logstash"
	ssh $ipnode sudo systemctl start logstash.service >/dev/null 2>/dev/null
  fi
done

# Start Kibana
echo "==================================== Kibana ===================================="
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl enable kibana.service >/dev/null 2>/dev/null
  ssh $ipnode sudo systemctl status kibana.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Kibana"
	ssh $ipnode sudo systemctl start kibana.service >/dev/null 2>/dev/null
  fi
  
done

# Start Nginx
echo "===================================== Nginx ===================================="
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl enable nginx.service >/dev/null 2>/dev/null
  ssh $ipnode sudo systemctl status nginx.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Nginx"
	ssh $ipnode sudo systemctl start nginx.service >/dev/null 2>/dev/null
  fi
done

# Start Keepalived
echo "===================================== Keepalived ===================================="
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl enable keepalived.service >/dev/null 2>/dev/null
  ssh $ipnode sudo systemctl status keepalived.service >/dev/null 2>/dev/null
  if [[ ! $? = 0 ]] ; then
    echo "$ipnode : Start Keepalived"
	ssh $ipnode sudo systemctl start keepalived.service >/dev/null 2>/dev/null
  fi
done
