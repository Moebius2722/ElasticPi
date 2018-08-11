#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Start Node Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### START-NODE #######

# Check and Start Node Services
echo "================================== START-NODE =================================="
date

if [[ $# = 0 ]] ; then
  # Start Services
  #for svc in nginx keepalived mosquitto elasticsearch cerebro kibana nodered logstash
  for svc in nginx keepalived squid elasticsearch cerebro kibana logstash metricbeat mosquitto nodered
  do
    echo "================================= $svc ================================"
    echo "Start $svc"
    start-$svc
  done
else

  # Start Services
  #for svc in nginx keepalived mosquitto elasticsearch cerebro kibana nodered logstash
  for svc in nginx keepalived elasticsearch cerebro kibana logstash metricbeat
  do
    echo "================================= $svc ================================"
    echo "$1 : Start $svc"
    ssh -t $1 start-$svc
  done
fi

# Waiting Elasticsearch Up
echo "==================================== Waiting ==================================="

if [[ $# = 0 ]] ; then
  wait-elasticsearch-start
else
  wait-elasticsearch-start $1
fi

date
echo "================================== NODE-START =================================="
#	>/dev/null 2>/dev/null
