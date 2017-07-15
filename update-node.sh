#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Elastic Stack on Raspberry Pi 2 or 3


####### FULL SYSTEM UPDATE #######

echo "================================= System Update ================================"
update-system


####### ELASTICSEARCH #######

echo "================================= Elasticsearch ================================"
update-elasticsearch


####### LOGSTASH #######

echo "=================================== Logstash ==================================="
update-logstash


####### KIBANA #######

echo "==================================== Kibana ===================================="
update-kibana


####### NGINX #######

echo "===================================== Nginx ===================================="
update-nginx


####### CEREBRO #######

echo "==================================== Cerebro ==================================="
update-cerebro


####### NODERED #######

echo "=================================== Node-RED ==================================="
update-nodered

