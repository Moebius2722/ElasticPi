#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Stop Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticsearch/discovery-file/unicast_hosts.txt | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort` )


####### STOP-CLUSTER #######

# Check and Start Cluster Services

# Stop Nginx
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl status nginx.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "$ipnode : Stop Nginx"
	ssh $ipnode sudo systemctl stop nginx.service >/dev/null 2>/dev/null
  fi
done

# Stop Kibana
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl status kibana.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "$ipnode : Stop Kibana"
	ssh $ipnode sudo systemctl stop kibana.service >/dev/null 2>/dev/null
  fi
done

# Stop Logstash
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl status logstash.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "$ipnode : Stop Logstash"
	ssh $ipnode sudo systemctl stop logstash.service >/dev/null 2>/dev/null
  fi
done

# Stop Node-RED
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl status nodered.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "$ipnode : Stop Node-RED"
	ssh $ipnode sudo systemctl stop nodered.service >/dev/null 2>/dev/null
  fi
done

# Stop Mosquitto
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl status mosquitto.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "$ipnode : Stop Mosquitto"
	ssh $ipnode sudo systemctl stop mosquitto.service >/dev/null 2>/dev/null
  fi
done

# Stop Cerebro
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl status cerebro.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "$ipnode : Stop Cerebro"
	ssh $ipnode sudo systemctl stop cerebro.service >/dev/null 2>/dev/null
  fi
done

# Stop Elasticsearch
for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "$ipnode : Stop Elasticsearch"
	ssh $ipnode "curl -XPOST 'localhost:9200/_flush/synced?pretty' ; sudo systemctl stop elasticsearch.service" >/dev/null 2>/dev/null
  fi
done
