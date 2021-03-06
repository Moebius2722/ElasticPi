#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Wait Elasticsearch to Start on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ $# -gt 1 ]] ; then
  echo "Usage : $0 [Node]"
  exit 1
fi

# Set Node
if [[ $# = 0 ]] ; then
  node=`hostname -i`
else
  node=$1
fi

# Check Elasticsearch Installed
ssh $node 'get-elasticsearch-version' >/dev/null 2>/dev/null
if [[ $? -ne 0 ]] ; then
  echo "Elasticsearch is not installed." >&2
  exit 1
fi


####### WAIT-ELASTICSEARCH-START #######

# Waiting Elasticsearch Up
echo "=========================== Wait Elasticsearch Start ==========================="
date
echo

# Wait for start-up nodes
echo "Wait for start-up Elasticsearch nodes"
s_check=`curl -ss -XGET "$node:9200/_cat/health?pretty"|cut -d ' ' -f 4`
int_cpt=0
while [ "$s_check" != "yellow" ] && [ "$s_check" != "green" ] && [ $int_cpt -lt 120 ]; do
  s_check=`curl -ss -XGET "$node:9200/_cat/health?pretty"|cut -d ' ' -f 4`
  echo -n '.'
  sleep 5
  int_cpt=$[$int_cpt+1]
done
echo
if [ "$s_check" != "yellow" ] && [ "$s_check" != "green" ] && [ $int_cpt -eq 120 ]; then
  echo "Time Out for start-up nodes"
  date
  echo "========================= End Wait Elasticsearch Start ========================="
  exit 2
else
  echo "Elasticsearch Started"
  # Wait for the nodes to recover
  echo "Wait for the Elasticsearch nodes to recover"
  sleep 10
  int_cpt=0
  while [ "$s_check" != "green" ] && [ $int_cpt -lt 180 ]; do
    s_check=`curl -ss -XGET "$node:9200/_cat/health?pretty"|cut -d ' ' -f 4`
    echo -n '.'
    sleep 10
    int_cpt=$[$int_cpt+1]
  done
  echo
  if [ "$s_check" != "green" ] && [ $int_cpt -eq 180 ]; then
    echo "Time Out for the node to recover."
    date
    echo "========================= End Wait Elasticsearch Start ========================="
    exit 3
  else
    echo "Elasticsearch Recovered"
  fi
fi

date
echo "========================= End Wait Elasticsearch Start ========================="
exit 0
