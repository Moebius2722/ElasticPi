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

# Start Elasticsearch
echo "================================= Elasticsearch ================================"
ssh -t $ipnode sudo systemctl enable elasticsearch.service >/dev/null 2>/dev/null
ssh -t $ipnode sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
if [[ ! $? = 0 ]] ; then
  echo "$ipnode : Start Elasticsearch"
  ssh -t $ipnode sudo systemctl start elasticsearch.service >/dev/null 2>/dev/null
fi

# Wait for start-up node
echo "Wait for start-up node"
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
echo "Wait for the node to recover"
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

# Start Cerebro
echo "==================================== Cerebro ==================================="
ssh -t $ipnode sudo systemctl enable cerebro.service >/dev/null 2>/dev/null
ssh -t $ipnode sudo systemctl status cerebro.service >/dev/null 2>/dev/null
if [[ ! $? = 0 ]] ; then
  echo "$ipnode : Start Cerebro"
  ssh -t $ipnode "sudo rm -f /usr/share/cerebro/RUNNING_PID ; sudo systemctl start cerebro.service" >/dev/null 2>/dev/null
fi

# Start Mosquitto
echo "=================================== Mosquitto =================================="
ssh -t $ipnode sudo systemctl enable mosquitto.service >/dev/null 2>/dev/null
ssh -t $ipnode sudo systemctl status mosquitto.service >/dev/null 2>/dev/null
if [[ ! $? = 0 ]] ; then
  echo "$ipnode : Start Mosquitto"
  ssh -t $ipnode sudo systemctl start mosquitto.service >/dev/null 2>/dev/null
fi

# Start Node-RED
echo "=================================== Node-RED ==================================="
ssh -t $ipnode sudo systemctl enable nodered.service >/dev/null 2>/dev/null
ssh -t $ipnode sudo systemctl status nodered.service >/dev/null 2>/dev/null
if [[ ! $? = 0 ]] ; then
  echo "$ipnode : Start Node-RED"
  ssh -t $ipnode sudo systemctl start nodered.service >/dev/null 2>/dev/null
fi

# Start Logstash
echo "=================================== Logstash ==================================="
ssh -t $ipnode sudo systemctl enable logstash.service >/dev/null 2>/dev/null
ssh -t $ipnode sudo systemctl status logstash.service >/dev/null 2>/dev/null
if [[ ! $? = 0 ]] ; then
  echo "$ipnode : Start Logstash"
  ssh -t $ipnode sudo systemctl start logstash.service >/dev/null 2>/dev/null
fi

# Start Kibana
echo "==================================== Kibana ===================================="
ssh -t $ipnode sudo systemctl enable kibana.service >/dev/null 2>/dev/null
ssh -t $ipnode sudo systemctl status kibana.service >/dev/null 2>/dev/null
if [[ ! $? = 0 ]] ; then
  echo "$ipnode : Start Kibana"
  ssh -t $ipnode sudo systemctl start kibana.service >/dev/null 2>/dev/null
fi

# Start Nginx
echo "===================================== Nginx ===================================="
ssh -t $ipnode sudo systemctl enable nginx.service >/dev/null 2>/dev/null
ssh -t $ipnode sudo systemctl status nginx.service >/dev/null 2>/dev/null
if [[ ! $? = 0 ]] ; then
  echo "$ipnode : Start Nginx"
  ssh -t $ipnode sudo systemctl start nginx.service >/dev/null 2>/dev/null
fi

# Start Keepalived
echo "================================== Keepalived =================================="
ssh -t $ipnode sudo systemctl enable keepalived.service >/dev/null 2>/dev/null
ssh -t $ipnode sudo systemctl status keepalived.service >/dev/null 2>/dev/null
if [[ ! $? = 0 ]] ; then
  echo "$ipnode : Start Keepalived"
  ssh -t $ipnode sudo systemctl start keepalived.service >/dev/null 2>/dev/null
fi

date
echo "================================== NODE-START =================================="
