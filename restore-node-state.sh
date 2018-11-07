#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Restore Services Node State Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Check if node state is backup
if [ ! -f /etc/elasticpi/node.state ]; then
  echo "Backup Node State Before Restore"
  exit 1
fi


####### RESTORE-NODE-STATE #######

# Get Services Old State
for svc in nginx keepalived squid elasticsearch cerebro kibana logstash metricbeat mosquitto nodered
do
  # Get Service Old State
  sudo cat /etc/elasticpi/node.state | grep -c $svc >/dev/null 2>/dev/null
  if [ $? -eq 0 ] ; then
    # Start Service
    start-$svc
  else
    # Stop Service
    stop-$svc
  fi
done
