#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Installation Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${E_VERSION} = '' ]]; then
  E_VERSION=`wget https://www.elastic.co/downloads/elasticsearch/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
fi

# Disable IPv6
echo net.ipv6.conf.all.disable_ipv6=1 | sudo tee /etc/sysctl.d/97-disableipv6.conf
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1

# Full System Update
if [[ ! "${PI_UPDATED}" = 1 ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi

# Install Tools
# If you get script via GitHub, git tool is already installed ;)
# Htop is a good tool for monitoring cpu and memory usage by ELK Stack
sudo apt-get install curl jq git -q -y


####### ELASTICSEARCH #######

# Install Elasticsearch Prerequisites
sudo apt-get install oracle-java8-jdk -q -y

# Get and Install Elasticsearch
#--force-confold
wget -P/tmp https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${E_VERSION}.deb && sudo dpkg -i /tmp/elasticsearch-${E_VERSION}.deb

# Set Elasticsearch Memory Configuration (Max 200mb of memory)
sudo sed -i 's/-Xms.*/-Xms200m/' /etc/elasticsearch/jvm.options
sudo sed -i 's/-Xmx.*/-Xmx200m/' /etc/elasticsearch/jvm.options
sudo sed -i '/#MAX_LOCKED_MEMORY=unlimited/a MAX_LOCKED_MEMORY=unlimited' /etc/default/elasticsearch
sudo sed -i '/#LimitMEMLOCK=infinity/a LimitMEMLOCK=infinity' /usr/lib/systemd/system/elasticsearch.service
sudo sed -i '/#MAX_MAP_COUNT=262144/a MAX_MAP_COUNT=262144' /etc/default/elasticsearch
echo vm.max_map_count=262144 | sudo tee /etc/sysctl.d/96-elasticsearch.conf
sudo sysctl -w vm.max_map_count=262144
echo vm.swappiness=1 | sudo tee -a /etc/sysctl.d/96-elasticsearch.conf
sudo sysctl -w vm.swappiness=1
sudo sed -i '/#bootstrap.memory_lock: true/a bootstrap.memory_lock: true' /etc/elasticsearch/elasticsearch.yml

# Set Elasticsearch Node Configuration
sudo sed -i '/#cluster\.name: .*/a cluster.name: espi' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#node\.name: .*/a node.name: ${HOSTNAME}' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#node.attr.rack: .*/a node.attr.rack: espi-rack-1' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#network\.host: .*/a network.host: 0.0.0.0' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#http\.port: .*/a http.port: 9200' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#node\.max_local_storage_nodes: .*/a node.max_local_storage_nodes: 1' /etc/elasticsearch/elasticsearch.yml

# Enable Site Plugins
echo 'http.cors.enabled: true' | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo 'http.cors.allow-origin: ".*"' | sudo tee -a /etc/elasticsearch/elasticsearch.yml

# Disable System Call Filter Check (Since 5.2.0 this check blocking start-up daemon)
echo 'bootstrap.system_call_filter: false' | sudo tee -a /etc/elasticsearch/elasticsearch.yml

# Install and Configure Discovery-File plugin
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-file
sudo sed -i '/#discovery\.zen\.ping\.unicast\.hosts: .*/a discovery.zen.hosts_provider: file' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/#discovery\.zen\.minimum_master_nodes: .*/a discovery.zen.minimum_master_nodes: 1' /etc/elasticsearch/elasticsearch.yml
echo . | sudo tee -a /etc/elasticsearch/discovery-file/unicast_hosts.txt
echo '192.168.0.21' | sudo tee -a /etc/elasticsearch/discovery-file/unicast_hosts.txt
echo '192.168.0.22' | sudo tee -a /etc/elasticsearch/discovery-file/unicast_hosts.txt
echo '192.168.0.23' | sudo tee -a /etc/elasticsearch/discovery-file/unicast_hosts.txt
echo '192.168.0.24' | sudo tee -a /etc/elasticsearch/discovery-file/unicast_hosts.txt
echo '192.168.0.25' | sudo tee -a /etc/elasticsearch/discovery-file/unicast_hosts.txt

# Create and configure Backup NFS mount point
sudo mkdir /mnt/espibackup
sudo chown elasticsearch:elasticsearch /mnt/espibackup
sudo systemctl enable rpcbind.service
sudo systemctl start rpcbind.service
echo '192.168.0.1:/volume1/espibackup /mnt/espibackup nfs rw         0       0' | sudo tee -a /etc/fstab
sudo mount /mnt/espibackup
sudo mkdir /mnt/espibackup/repo
sudo chown elasticsearch:elasticsearch /mnt/espibackup/repo
sudo chmod -R 770 /mnt/espibackup
sudo sed -i '/#path\.logs: .*/a path.repo: ["/mnt/espibackup/repo"]' /etc/elasticsearch/elasticsearch.yml

# Configure and Start Elasticsearch as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl start elasticsearch.service

# Create Snapshot Repository for Backup NFS mount point
curl -XPUT 'http://localhost:9200/_snapshot/espibackup' -d '{
 "type": "fs",
 "settings": {
  "location": "/mnt/espibackup/repo"
 }
}'

# Install and Configure Curator for Elasticsearch
sudo cp -f `dirname $0`/Curator/curator-config.yml /etc/elasticsearch/curator-config.yml
sudo cp -f `dirname $0`/Curator/curator-actions.yml /etc/elasticsearch/curator-actions.yml
sudo apt-get install python-pip -q -y && sudo pip install PySocks && sudo pip install elasticsearch-curator && echo -e "20 0    * * *   root    /usr/local/bin/curator --config /etc/elasticsearch/curator-config.yml /etc/elasticsearch/curator-actions.yml" | sudo tee -a /etc/crontab && sudo /bin/systemctl restart cron.service
