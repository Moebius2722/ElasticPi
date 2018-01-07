#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Start Node Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Node
if [[ $# = 0 ]] ; then
  ipnode=`hostname -i`
else
  ipnode=$1
fi


####### START-NODE #######

# Check and Start Node Services
echo "================================== START-NODE =================================="
date

# Start Services
#for svc in nginx keepalived mosquitto elasticsearch cerebro kibana nodered logstash
for svc in nginx keepalived elasticsearch cerebro kibana logstash metricbeat
do
echo "================================= $svc ================================"
echo "$ipnode : Start $svc"
ssh -t $ipnode start-$svc >/dev/null 2>/dev/null
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
echo "================================== NODE-START =================================="
