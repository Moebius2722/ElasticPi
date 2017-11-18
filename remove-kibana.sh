#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Kibana on Raspberry Pi 2 or 3


####### KIBANA #######

# Stop Kibana
stop-kibana

# Remove Kibana
sudo dpkg --purge kibana

# Purge Kibana configuration
sudo rm -rf /etc/kibana
sudo rm -rf /usr/share/kibana
sudo rm -rf /var/lib/kibana
sudo rm -rf /var/log/kibana
