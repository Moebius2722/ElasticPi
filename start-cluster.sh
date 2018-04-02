#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Start Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort` )


####### START-CLUSTER #######

# Check and Start Cluster Services
echo "================================= START-CLUSTER ================================"
date

# Start Services
#for svc in nginx keepalived elasticsearch cerebro mosquitto nodered logstash kibana
for svc in nginx keepalived elasticsearch cerebro metricbeat logstash kibana
do
echo "================================= $svc ================================"
for ipnode in "${ipnodes[@]}"
do
echo "$ipnode : Start $svc"
ssh -t $ipnode start-$svc >/dev/null 2>/dev/null
done
done


# Waiting Elasticsearch Up
wait-elasticsearch-start
echo "================================= CLUSTER-START ================================"
