#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Reboot Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Disable shard allocation
curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
{
  "transient": {
    "cluster.routing.allocation.enable": "none"
  }
}
'

# Stop non-essential indexing and perform a synced flush
curl -XPOST 'localhost:9200/_flush/synced?pretty'

# Stop Elasticsearch Daemon
sudo /bin/systemctl stop elasticsearch.service




####### ELASTICSEARCH #######

# Wait for start-up the upgraded node
echo "Wait for start-up the upgraded node."
SHORTHOSTNAME=`hostname -s`
b_check=0
int_cpt=0
while [ $b_check -eq 0 -a $int_cpt -lt 120 ]; do
  b_check=`curl -ss -XGET 'localhost:9200/_cat/nodes?pretty'|grep -ic $SHORTHOSTNAME`
  echo -n '.'
  sleep 5
  int_cpt=$[$int_cpt+1]
done
if [ $b_check -eq 0 -a $int_cpt -eq 120 ]; then
  echo "Time Out for start-up the upgraded node."
else
# Reenable shard allocation
echo "Reenable shard allocation."
curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
{
  "transient": {
    "cluster.routing.allocation.enable": "all"
  }
}
'
fi

# Wait for the node to recover
echo "Wait for the node to recover."
b_check=0
int_cpt=0
while [ $b_check -eq 0 -a $int_cpt -lt 180 ]; do
  b_check=`curl -ss -XGET 'localhost:9200/_cat/health?pretty'|cut -d ' ' -f 4|grep -ci green`
  echo -n '.'
  sleep 10
  int_cpt=$[$int_cpt+1]
done
if [ $b_check -eq 0 -a $int_cpt -eq 180 ]; then
  echo "Time Out for the node to recover."
fi
