#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Configure Script for Metricbeat on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 1 ]] ; then
  echo "Usage : $0 Logstash_IP"
  exit 1
fi

# Get Logstash IP
l_ip=$1

# Check if installed
if ! get-metricbeat-version >/dev/null 2>/dev/null; then
  echo "Metricbeat isn't installed" >&2
  exit 1
fi


####### METRICBEAT #######

# Stop Metricbeat Daemon
stop-metricbeat

# Backup Olg Configuration
sudo cp -f /etc/metricbeat/metricbeat.yml /etc/metricbeat/metricbeat.yml.ori


# Set Metricbeat Node Configuration

# Clean Old Configuration
sudo sed -i "s/setup.kibana:/#setup.kibana:/" /etc/metricbeat/metricbeat.yml
sudo sed -i "s/^output.elasticsearch:/#output.elasticsearch:/" /etc/metricbeat/metricbeat.yml
sudo sed -i '/\ host:/d' /etc/metricbeat/metricbeat.yml
sudo sed -i '/\ hosts:/d' /etc/metricbeat/metricbeat.yml
sudo sed -i '/\ protocol:/d' /etc/metricbeat/metricbeat.yml
sudo sed -i '/\ username:/d' /etc/metricbeat/metricbeat.yml
sudo sed -i '/\ password:/d' /etc/metricbeat/metricbeat.yml
sudo sed -i '/ssl.enabled: true/d' /etc/metricbeat/metricbeat.yml
sudo sed -i '/ssl.enabled: true/d' /etc/metricbeat/metricbeat.yml
sudo sed -i '/ssl.verification_mode: none/d' /etc/metricbeat/metricbeat.yml

# Configure Metricbeat for Elasticsearch Template
sudo sed -i 's/  index.number_of_shards:.*/  index.number_of_shards: 5/' /etc/metricbeat/metricbeat.yml
sudo sed -i '/index.auto_expand_replicas:/d' /etc/metricbeat/metricbeat.yml
sudo sed -i '/  index.number_of_shards: 5/a\  index.auto_expand_replicas: 0-1' /etc/metricbeat/metricbeat.yml

# Configure Metricbeat for Logstash
sudo sed -i "s/^#output.logstash:/output.logstash:/" /etc/metricbeat/metricbeat.yml

#output.logstash:
sudo sed -i "/  #hosts: \[\"localhost:5044\"\]/a\  hosts: [\"${l_ip}:5012\"]" /etc/metricbeat/metricbeat.yml

# Fix Modules Path for 6.4.0
if [ ! -d /etc/metricbeat/modules.d ]; then
  # Fix Modules Path for 6.4.0
  sudo sed -i "s/\${path\.config}\/modules.d\/\*\.yml/\/usr\/share\/metricbeat\/modules.d\/\*\.yml/" /etc/metricbeat/metricbeat.yml
  # Configure Metricbeat Period
  sudo sed -i 's/  period: 10s/  period: 30s/' /usr/share/metricbeat/modules.d/system.yml
else
  # Configure Metricbeat Period
  sudo sed -i 's/  period: 10s/  period: 30s/' /etc/metricbeat/modules.d/system.yml
fi


# Start Metricbeat Daemon
start-metricbeat
