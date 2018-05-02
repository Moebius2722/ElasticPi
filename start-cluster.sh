#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Start Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### START-CLUSTER #######

# Check and Start Cluster Services
echo "================================= START-CLUSTER ================================"
date

# Start Services
#for svc in nginx keepalived elasticsearch cerebro mosquitto nodered logstash kibana
for svc in nginx keepalived elasticsearch cerebro metricbeat logstash kibana
do
echo "================================= $svc ================================"
allssh start-$svc
done

# Waiting Elasticsearch Up
allssh wait-elasticsearch-start

date
echo "================================= CLUSTER-START ================================"
