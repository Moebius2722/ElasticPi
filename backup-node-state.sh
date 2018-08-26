#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Start Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### START-CLUSTER #######

# Check and Start Cluster Services
echo "================================= BACKUP-NODE-STATE ================================"
# Start Services
#for svc in nginx keepalived elasticsearch cerebro mosquitto nodered logstash kibana
for svc in nginx keepalived squid elasticsearch cerebro kibana logstash metricbeat mosquitto nodered
do
echo "================================= $svc ================================"
sudo systemctl is-enabled metricbeat.service
done


echo "================================= CLUSTER-NODE-BACKUPs ================================"
