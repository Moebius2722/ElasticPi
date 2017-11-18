#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Logstash on Raspberry Pi 2 or 3


####### LOGSTASH #######

# Stop Logstash
stop-logstash

# Remove Logstash
sudo dpkg --purge logstash

# Purge Logstash configuration
sudo rm -rf /etc/logstash
sudo rm -rf /var/lib/logstash
