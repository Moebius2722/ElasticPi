#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Metricbeat on Raspberry Pi 2 or 3


####### COMMON #######

# Check if not installed
if get-metricbeat-version >/dev/null 2>/dev/null; then
  echo "Metricbeat isn't installed" >&2
  exit 1
fi


####### Metricbeat #######

# Stop Metricbeat
stop-metricbeat

# Remove Metricbeat
sudo dpkg --purge metricbeat

# Purge Metricbeat configuration
sudo rm -rf /etc/metricbeat
sudo rm -rf /usr/share/metricbeat
sudo rm -rf /var/lib/metricbeat
sudo rm -rf /var/log/metricbeat
