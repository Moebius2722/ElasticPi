#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Backup Services Node State Script for Elasticsearch on Raspberry Pi 2 or 3


####### BACKUP-NODE-STATE #######

# Remove Old Backup State
sudo rm -f /etc/elasticpi/node.state >/dev/null 2>/dev/null

# Check Services State
for svc in nginx keepalived squid elasticsearch cerebro kibana logstash metricbeat mosquitto nodered
do
  # Check Service State
  sudo systemctl is-enabled $svc.service >/dev/null 2>/dev/null
  if [ $? -eq 0 ] ; then
    # Backup Service State
    echo $svc | sudo tee -a /etc/elasticpi/node.state >/dev/null 2>/dev/null
  fi
done
