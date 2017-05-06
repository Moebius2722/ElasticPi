#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ "${E_VERSION}" = '' ]]; then
  E_VERSION=`wget https://www.elastic.co/downloads/elasticsearch/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
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

sleep 10

# Stop non-essential indexing and perform a synced flush
curl -XPOST 'localhost:9200/_flush/synced?pretty'

# Stop Elasticsearch Daemon
sudo /bin/systemctl stop elasticsearch.service

# Full System Update
echo "PI_UPDATED=${PI_UPDATED}"

if [[ ! "${PI_UPDATED}" = "1" ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi

echo "PI_UPDATED=${PI_UPDATED}"


####### ELASTICSEARCH #######

# Get and Update Elasticsearch
wget -P/tmp https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${E_VERSION}.deb && sudo dpkg --force-confold --force-overwrite -i /tmp/elasticsearch-${E_VERSION}.deb && rm -f /tmp/elasticsearch-${E_VERSION}.deb

# Get and Compile JNA library for Elasticsearch
git clone https://github.com/java-native-access/jna.git /tmp/jna && ant -f /tmp/jna/build.xml jar && sudo cp -f /tmp/jna/build/jna.jar /usr/share/elasticsearch/lib/jna-4.4.0.jar && rm -rf /tmp/jna

# Update Discovery-File plugin
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin remove discovery-file
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-file

# Configure and Start Elasticsearch as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl start elasticsearch.service

# Install and Configure Curator for Elasticsearch
sudo pip install --upgrade PySocks && sudo pip install --upgrade elasticsearch-curator

# Wait for start-up nodes
echo "Wait for start-up Elasticsearch nodes"
s_check=red
int_cpt=0
while [ "$s_check" != "yellow" ] && [ "$s_check" != "green" ] && [ $int_cpt -lt 120 ]; do
  s_check=`curl -ss -XGET 'localhost:9200/_cat/health?pretty'|cut -d ' ' -f 4`
  echo -n '.'
  sleep 5
  int_cpt=$[$int_cpt+1]
done
echo
if [ "$s_check" != "yellow" ] && [ "$s_check" != "green" ] && [ $int_cpt -eq 120 ]; then
  echo "Time Out for start-up nodes"
else
  # Reenable shard allocation
  echo "Reenable shard allocation"
  curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
  {
    "transient": {
      "cluster.routing.allocation.enable": "all"
    }
  }
  ' >/dev/null 2>/dev/null
fi

# Wait for the nodes to recover
echo "Wait for the Elasticsearch nodes to recover"
int_cpt=0
while [ "$s_check" != "green" ] && [ $int_cpt -lt 180 ]; do
  s_check=`curl -ss -XGET 'localhost:9200/_cat/health?pretty'|cut -d ' ' -f 4`
  echo -n '.'
  sleep 10
  int_cpt=$[$int_cpt+1]
done
echo
if [ "$s_check" != "green" ] && [ $int_cpt -eq 180 ]; then
  echo "Time Out for the node to recover."
fi