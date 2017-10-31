#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Host
iphost=`hostname -I | cut -d ' ' -f 1`

# Set Version
if [[ ${E_VERSION} = '' ]]; then
  E_VERSION=`wget https://www.elastic.co/downloads/elasticsearch/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3 | head -n 1`
fi

# Disable IPv6
echo net.ipv6.conf.all.disable_ipv6=1 | sudo tee /etc/sysctl.d/97-disableipv6.conf
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1

# Full System Update
if [[ ! "${PI_UPDATED}" = "1" ]]; then
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
#sudo apt-get install oracle-java8-jdk -q -y
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install oracle-java8-installer -q -y --allow-unauthenticated


# Get and Install Elasticsearch
#--force-confold
wget -P/tmp https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${E_VERSION}.deb && sudo dpkg -i /tmp/elasticsearch-${E_VERSION}.deb && rm -f /tmp/elasticsearch-${E_VERSION}.deb

# Get and Compile JNA library for Elasticsearch
JNA_JAR=`ls /usr/share/elasticsearch/lib/jna-*.jar`
JNA_VERSION=`echo $JNA_JAR | cut -d / -f 6 | cut -d - -f 2`
sudo apt-get install ant texinfo -y && git clone -b $JNA_VERSION https://github.com/java-native-access/jna.git /tmp/jna && ant -f /tmp/jna/build.xml jar && sudo cp -f /tmp/jna/build/jna.jar $JNA_JAR && rm -rf /tmp/jna

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
sudo sed -i "/#network\.host: .*/a network.host: [127.0.0.1, $iphost]" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^network\.host: .*/a network.bind_host: [127.0.0.1, $iphost]" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^network\.bind_host: .*/a network.publish_host: $iphost" /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/^network\.publish_host: .*/a transport.tcp.port: 9300' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/^transport\.tcp\.port: .*/a transport.publish_port: 9300' /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^transport\.publish_port: .*/a transport.bind_host: $iphost" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^transport\.bind_host: .*/a transport.publish_host: $iphost" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^transport\.publish_host: .*/a transport.host: $iphost" /etc/elasticsearch/elasticsearch.yml
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
echo  | sudo tee -a /etc/elasticsearch/discovery-file/unicast_hosts.txt
for i in {0..9}
do
   echo "192.168.0.2$i" | sudo tee -a /etc/elasticsearch/discovery-file/unicast_hosts.txt
done

# Create and configure Backup NFS mount point
sudo mkdir /mnt/espibackup
sudo chown -R elasticsearch:elasticsearch /mnt/espibackup
sudo systemctl enable rpcbind.service
sudo systemctl start rpcbind.service
echo '192.168.0.1:/volume1/espibackup /mnt/espibackup nfs rw         0       0' | sudo tee -a /etc/fstab
sudo mount /mnt/espibackup
sudo mkdir /mnt/espibackup/repo
sudo chown -R elasticsearch:elasticsearch /mnt/espibackup/repo
sudo chmod -R 770 /mnt/espibackup
sudo sed -i '/#path\.logs: .*/a path.repo: ["/mnt/espibackup/repo"]' /etc/elasticsearch/elasticsearch.yml

# Configure and Start Elasticsearch as Daemon
sudo sed -i '/\[Service\]/a Restart=always' /usr/lib/systemd/system/elasticsearch.service
sudo /bin/systemctl daemon-reload
start-elasticsearch

# Create Snapshot Repository for Backup NFS mount point
curl -XPUT 'http://localhost:9200/_snapshot/espibackup' -d '{
 "type": "fs",
 "settings": {
  "location": "/mnt/espibackup/repo"
 }
}'

# Install and Configure Curator for Elasticsearch
sudo cp -f /opt/elasticpi/Curator/curator-config.yml /etc/elasticsearch/curator-config.yml
sudo cp -f /opt/elasticpi/Curator/curator-actions.yml /etc/elasticsearch/curator-actions.yml
sudo mkdir /var/log/curator
sudo chown -R elasticsearch:elasticsearch /var/log/curator
sudo chmod -R 770 /var/log/curator
sudo apt-get install python-pip -q -y && sudo pip install PySocks && sudo pip install elasticsearch-curator && echo -e "0 1    * * *   elasticsearch    /usr/local/bin/curator --config /etc/elasticsearch/curator-config.yml /etc/elasticsearch/curator-actions.yml" | sudo tee -a /etc/crontab && sudo /bin/systemctl restart cron.service
