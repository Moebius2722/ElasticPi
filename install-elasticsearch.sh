#!/bin/sh

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Installation Script for Elasticsearch on Raspberry Pi 2 or 3



####### COMMON #######

# Set Version
if [[ ${E_VERSION} = '' ]]; then
  E_VERSION=5.1.1
fi

# Full System Update
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y

# Install Tools
# If you get script via GitHub, git tool is already installed ;)
# Htop is a good tool for monitoring cpu and memory usage by ELK Stack
sudo apt-get install curl jq git -q -y


####### ELASTICSEARCH #######

# Install Elasticsearch Prerequisites
sudo apt-get install oracle-java8-jdk -y

# Get and Install Elasticsearch
wget -P/tmp https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${E_VERSION}.deb && sudo dpkg -i /tmp/elasticsearch-${E_VERSION}.deb

# Set Elasticsearch Memory Configuration (Max 300mb of memory)
sudo sed -i 's/-Xms.*/-Xms300m/' /etc/elasticsearch/jvm.options
sudo sed -i 's/-Xmx.*/-Xmx300m/' /etc/elasticsearch/jvm.options
sudo sed -i '/#MAX_LOCKED_MEMORY=unlimited/a MAX_LOCKED_MEMORY=unlimited' /etc/default/elasticsearch
sudo sed -i '/#LimitMEMLOCK=infinity/a LimitMEMLOCK=infinity' /usr/lib/systemd/system/elasticsearch.service
sudo sed -i '/#MAX_MAP_COUNT=262144/a MAX_MAP_COUNT=262144' /etc/default/elasticsearch
echo vm.max_map_count=262144 | sudo tee /etc/sysctl.d/96-elasticsearch.conf
echo vm.swappiness=1 | sudo tee -a /etc/sysctl.d/96-elasticsearch.conf
sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
sudo systemctl restart dphys-swapfile.service
sudo sed -i '/#bootstrap.memory_lock: true/a bootstrap.memory_lock: true' /etc/elasticsearch/elasticsearch.yml

# Set Elasticsearch Node Configuration
sudo sed -i '/#cluster\.name: .*/a cluster.name: espi' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#node\.name: .*/a node.name: ${HOSTNAME}' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#node.attr.rack: .*/a node.attr.rack: espi-rack-1' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#network\.host: .*/a network.host: 0.0.0.0' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#http\.port: .*/a http.port: 9200' /etc/elasticsearch/elasticsearch.yml
#sudo sed -i '/#discovery\.zen\.ping\.unicast\.hosts: .*/a discovery.zen.ping.unicast.hosts: ["192.168.0.22", "192.168.0.23"]' /etc/elasticsearch/elasticsearch.yml
#sudo sed -i '/#discovery\.zen\.minimum_master_nodes: .*/a discovery.zen.minimum_master_nodes: 1' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#node\.max_local_storage_nodes: .*/a node.max_local_storage_nodes: 1' /etc/elasticsearch/elasticsearch.yml

# Enable Site Plugins
echo 'http.cors.enabled: true' | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo 'http.cors.allow-origin: "*"' | sudo tee -a /etc/elasticsearch/elasticsearch.yml

# Install Head, Kopf, HQ and Paramedic plugins for ElasticSearch
#sudo /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
#http://server:9200/_plugin/head
#sudo /usr/share/elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf
#http://server:9200/_plugin/kopf
#sudo /usr/share/elasticsearch/bin/plugin install royrusso/elasticsearch-HQ
#http://server:9200/_plugin/hq
#sudo /usr/share/elasticsearch/bin/plugin install karmi/elasticsearch-paramedic
#http://server:9200/_plugin/paramedic

echo 'http.cors.enabled: true' | sudo tee -a /etc/elasticsearch/elasticsearch.yml
#echo 'http.cors.allow-origin: /https?:\/\/localhost(:[0-9]+)?/' | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo 'http.cors.allow-origin: /*/' | sudo tee -a /etc/elasticsearch/elasticsearch.yml

# Configure and Start Elasticsearch as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl start elasticsearch.service

# Install and Configure Curator for Elasticsearch
sudo cp -f ./Curator/curator-config.yml /etc/elasticsearch/curator-config.yml
sudo cp -f ./Curator/curator-actions.yml /etc/elasticsearch/curator-actions.yml
sudo apt-get install python-pip -q -y && sudo pip install PySocks && sudo pip install elasticsearch-curator && echo -e "20 0    * * *   root    /usr/local/bin/curator --config /etc/elasticsearch/curator-config.yml /etc/elasticsearch/curator-actions.yml" | sudo tee -a /etc/crontab && sudo /bin/systemctl restart cron.service
