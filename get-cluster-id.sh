#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Cluster ID for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/cluster.id ]; then
  echo "Cluster isn't created"
  exit 1
fi


####### GET-CLUSTER-ID #######

cat /etc/elasticpi/cluster.id
