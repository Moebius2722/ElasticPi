#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Tools on Raspberry Pi 2 or 3


####### TOOLS #######

# Remove Binary Links
for tool in `sudo ls /opt/elasticpi/*.sh  | cut -d '/' -f 4 | cut -d '.' -f 1`
do
sudo rm -f "/usr/bin/$tool"
done
for svc in elasticsearch logstash kibana nginx cerebro nodered mosquitto keepalived metricbeat
do
sudo rm -f "/usr/bin/check-$svc"
sudo rm -f "/usr/bin/start-$svc"
sudo rm -f "/usr/bin/stop-$svc"
sudo rm -f "/usr/bin/restart-$svc"
done

# Remove Tools
sudo rm -rf /opt/elasticpi

# Remove Tools Configuration
sudo rm -rf /etc/elasticpi
