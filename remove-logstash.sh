#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Logstash on Raspberry Pi 2 or 3


####### COMMON #######

# Check if not installed
if ! get-logstash-version >/dev/null 2>/dev/null; then
  echo "Logstash isn't installed" >&2
  exit 1
fi


####### LOGSTASH #######

# Stop Logstash
stop-logstash

# Remove Logstash
sudo dpkg --purge logstash-oss

# Purge Logstash configuration
sudo rm -rf /etc/logstash
sudo rm -rf /usr/share/logstash
sudo rm -rf /var/lib/logstash
sudo rm -rf /var/log/logstash
