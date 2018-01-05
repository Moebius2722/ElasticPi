#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Stop Node Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### STOP-NODE #######

# Check and Stop Node Services
echo "================================== STOP-NODE ==================================="
date

if [[ $# = 0 ]] ; then
  # Flush Elasticsearch Indices
  sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "Flush Elasticsearch Indices"
    curl -XPOST 'localhost:9200/_flush/synced?pretty'
  fi
  
  # Stop Services
  for svc in elasticsearch logstash kibana nodered mosquitto cerebro keepalived nginx         
  do
    echo "================================= $svc ================================"
    echo "Stop $svc"
    stop-$svc
  done
else
  # Flush Elasticsearch Indices
  ssh -t $1 sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    echo "Flush Elasticsearch Indices"
    ssh -t $1 "curl -XPOST 'localhost:9200/_flush/synced?pretty'"
  fi
  
  # Stop Services
  for svc in elasticsearch logstash kibana nodered mosquitto cerebro keepalived nginx         
  do
    echo "================================= $svc ================================"
    echo "$1 : Stop $svc"
    ssh -t $1 stop-$svc
  done
fi

date
echo "================================== NODE-STOP ==================================="
#	>/dev/null 2>/dev/null
