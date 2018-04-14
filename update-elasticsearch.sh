#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ "${E_VERSION}" = '' ]]; then
  E_VERSION=`get-elasticsearch-lastversion`
fi

# Check if already up to date
E_CVERSION=`get-elasticsearch-version`
if [ $? -ne 0 ] ; then
  exit 1
fi
if [[ "${E_VERSION}" = "${E_CVERSION}" ]]; then
  echo "Elasticsearch is already up to date to ${E_CVERSION} version"
  exit 0
fi
echo "Update Elasticsearch ${E_CVERSION} to ${E_VERSION}"

# Disable shard allocation
#curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
#{
#  "transient": {
#    "cluster.routing.allocation.enable": "none"
#  }
#}
#'
#
#sleep 10

# Stop non-essential indexing and perform a synced flush
curl -XPOST 'localhost:9200/_flush/synced?pretty'

# Stop Elasticsearch Daemon
stop-elasticsearch


####### ELASTICSEARCH #######

#Create Elasticsearch Build Folder
if [ ! -d "/mnt/elasticpi/build/elasticsearch/${E_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/elasticsearch/${E_VERSION}
  sudo chown -R elasticsearch:elasticsearch /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get and Check Elasticsearch Debian Package
rm -f /tmp/elasticsearch-${E_VERSION}.deb.sha512
wget -P/tmp https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${E_VERSION}.deb.sha512
if [ -f "/mnt/elasticpi/build/elasticsearch/${E_VERSION}/elasticsearch-${E_VERSION}.deb" ]; then
  pushd /mnt/elasticpi/build/elasticsearch/${E_VERSION}
  sha512sum -c /tmp/elasticsearch-${E_VERSION}.deb.sha512
  if [ $? -ne 0 ] ; then
    rm -f /tmp/elasticsearch-${E_VERSION}.deb
    wget -P/tmp https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${E_VERSION}.deb
    pushd /tmp
    sha512sum -c /tmp/elasticsearch-${E_VERSION}.deb.sha512
    if [ $? -ne 0 ] ; then
      exit 1
    fi
	popd
	sudo cp -f /tmp/elasticsearch-${E_VERSION}.deb /mnt/elasticpi/build/elasticsearch/${E_VERSION}/elasticsearch-${E_VERSION}.deb
	rm -f /tmp/elasticsearch-${E_VERSION}.deb
  fi
  popd
else
  rm -f /tmp/elasticsearch-${E_VERSION}.deb
  wget -P/tmp https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${E_VERSION}.deb
  pushd /tmp
  sha512sum -c /tmp/elasticsearch-${E_VERSION}.deb.sha512
  if [ $? -ne 0 ] ; then
    popd
	exit 1
  fi
  popd
  sudo cp -f /tmp/elasticsearch-${E_VERSION}.deb /mnt/elasticpi/build/elasticsearch/${E_VERSION}/elasticsearch-${E_VERSION}.deb
  rm -f /tmp/elasticsearch-${E_VERSION}.deb
fi
rm -f /tmp/elasticsearch-${E_VERSION}.deb.sha512

# Update Elasticsearch
sudo dpkg --force-confold --force-overwrite -i /mnt/elasticpi/build/elasticsearch/${E_VERSION}/elasticsearch-${E_VERSION}.deb

# Get JNA Version
JNA_JAR=`ls /usr/share/elasticsearch/lib/jna-*.jar`
JNA_VERSION=`echo ${JNA_JAR::-4} | cut -d / -f 6 | cut -d - -f 2`

#Create JNA Build Folder
if [ ! -d "/mnt/elasticpi/build/jna/${JNA_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/jna/${JNA_VERSION}
  sudo chown -R elasticsearch:elasticsearch /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build

fi

# Get and Check JNA Library Source
if [ -f /mnt/elasticpi/build/jna/${JNA_VERSION}/jna.jar.sha512 ] && [ -f /mnt/elasticpi/build/jna/${JNA_VERSION}/jna.jar ]; then
  pushd /mnt/elasticpi/build/jna/${JNA_VERSION}
  sha512sum -c /mnt/elasticpi/build/jna/${JNA_VERSION}/jna.jar.sha512
  if [ $? -ne 0 ] ; then
    # Get and Compile JNA library for Elasticsearch
    rm -rf /tmp/jna ; sudo apt-get install ant texinfo -y && git clone -b $JNA_VERSION https://github.com/java-native-access/jna.git /tmp/jna && ant -f /tmp/jna/build.xml jar && sudo cp -f /tmp/jna/build/jna.jar /mnt/elasticpi/build/jna/${JNA_VERSION}/jna.jar && rm -rf /tmp/jna && sudo sha512sum /mnt/elasticpi/build/jna/${JNA_VERSION}/jna.jar | sudo tee /mnt/elasticpi/build/jna/${JNA_VERSION}/jna.jar.sha512
  fi
  popd
else
  # Get and Compile JNA library for Elasticsearch
  rm -rf /tmp/jna ; sudo apt-get install ant texinfo -y && git clone -b $JNA_VERSION https://github.com/java-native-access/jna.git /tmp/jna && ant -f /tmp/jna/build.xml jar && sudo cp -f /tmp/jna/build/jna.jar /mnt/elasticpi/build/jna/${JNA_VERSION}/jna.jar && rm -rf /tmp/jna && sudo sha512sum /mnt/elasticpi/build/jna/${JNA_VERSION}/jna.jar | sudo tee /mnt/elasticpi/build/jna/${JNA_VERSION}/jna.jar.sha512
fi

# Replace Elasticsearch JNA library
sudo cp -f /mnt/elasticpi/build/jna/${JNA_VERSION}/jna.jar $JNA_JAR

# Update Discovery-File plugin
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin remove discovery-file
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-file

# Configure and Start Elasticsearch as Daemon
sudo /bin/systemctl daemon-reload
start-elasticsearch

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
#else
#  # Reenable shard allocation
#  echo "Reenable shard allocation"
#  curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
#  {
#    "transient": {
#      "cluster.routing.allocation.enable": "all"
#    }
#  }
#  ' >/dev/null 2>/dev/null
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
