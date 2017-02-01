#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Update Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ "${E_VERSION}" = '' ]]; then
  E_VERSION=5.2.0
fi

# Check if already up to date
E_CVERSION=`dpkg-query -W -f='${Version}\n' elasticsearch`
if [[ "${E_VERSION}" = "${E_CVERSION}" ]]; then
  echo "Elasticsearch is already up to date to ${E_CVERSION} version"
  exit 0
fi

# Disable shard allocation
curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
{
  "transient": {
    "cluster.routing.allocation.enable": "none"
  }
}
'

# Stop non-essential indexing and perform a synced flush
curl -XPOST 'localhost:9200/_flush/synced?pretty'

# Stop Elasticsearch Daemon
sudo /bin/systemctl stop elasticsearch.service

# Full System Update
if [[ ! "${PI_UPDATED}" = "1" ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi


####### ELASTICSEARCH #######

# Get and Update Elasticsearch
wget -P/tmp https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${E_VERSION}.deb && sudo dpkg --force-confold --force-overwrite -i /tmp/elasticsearch-${E_VERSION}.deb

# Update Discovery-File plugin
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin remove discovery-file
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-file

# Configure and Start Elasticsearch as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl start elasticsearch.service

# Install and Configure Curator for Elasticsearch
sudo pip install --upgrade PySocks && sudo pip install --upgrade elasticsearch-curator

# Reenable shard allocation
curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
{
  "transient": {
    "cluster.routing.allocation.enable": "all"
  }
}
'
