#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Elastic Stack on Raspberry Pi 2 or 3


####### FULL SYSTEM UPDATE #######

echo "================================= System Update ================================"
allssh update-system


####### TOOLS #######

echo "===================================== Tools ===================================="
allssh update-tools


####### ELASTICSEARCH #######

echo "================================= Elasticsearch ================================"
allssh update-elasticsearch


####### LOGSTASH #######

echo "=================================== Logstash ==================================="
allssh update-logstash


####### KIBANA #######

echo "==================================== Kibana ===================================="
allssh update-kibana


####### METRICBEAT #######

echo "================================== Metricbeat =================================="
allssh update-metricbeat


####### NGINX #######

echo "===================================== Nginx ===================================="
allssh update-nginx


####### CEREBRO #######

echo "==================================== Cerebro ==================================="
allssh update-cerebro


####### NODERED #######

echo "=================================== Node-RED ==================================="
allssh update-nodered

