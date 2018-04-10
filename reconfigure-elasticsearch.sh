#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Configure Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/vip.lst ]; then
  echo "Create cluster before reconfigure Elasticsearch"
  exit 1
fi

# Check if installed
if ! get-elasticsearch-version >/dev/null 2>/dev/null; then
  echo "Elasticsearch isn't installed" >&2
  exit 2
fi


####### ELASTICSEARCH #######

# Reconfigure Elasticsearch
allssh "sudo cp -f /etc/elasticpi/nodes.lst /etc/elasticsearch/discovery-file/unicast_hosts.txt"
