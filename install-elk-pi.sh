#!/bin/sh

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Installation Script for ELK Stack on Raspberry Pi 2 or 3



####### COMMON #######

# Set Version ELK
E_VERSION=2.3.3
L_VERSION=2.3.2-1
K_VERSION=4.5.1
N_VERSION=4.4.4

# Disable IPv6
echo net.ipv6.conf.all.disable_ipv6=1 | sudo tee /etc/sysctl.d/disableipv6.conf

# Full System Update
sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y

# Install Tools
# If you get script via GitHub, git tool is already installed ;)
# Htop is a good tool for monitoring cpu and memory usage by ELK Stack
sudo apt-get install curl git htop -y



####### ELASTICSEARCH #######

# Install Elasticsearch Prerequisites
sudo apt-get install oracle-java8-jdk -y

# Get and Install Elasticsearch
wget -P/tmp https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/${E_VERSION}/elasticsearch-${E_VERSION}.deb && sudo dpkg -i /tmp/elasticsearch-${E_VERSION}.deb

# Set Elasticsearch Memory Configuration (Max 300mb of memory)
sudo sed -i '/#ES_HEAP_SIZE=2g/a ES_MIN_MEM=300m' /etc/default/elasticsearch
sudo sed -i '/ES_MIN_MEM=300m/a ES_MAX_MEM=300m' /etc/default/elasticsearch
sudo sed -i '/ES_MAX_MEM=300m/a ES_HEAP_SIZE=300m' /etc/default/elasticsearch
sudo sed -i '/#MAX_LOCKED_MEMORY=unlimited/a MAX_LOCKED_MEMORY=unlimited' /etc/default/elasticsearch
sudo sed -i '/#LimitMEMLOCK=infinity/a LimitMEMLOCK=infinity' /usr/lib/systemd/system/elasticsearch.service

# Set Elasticsearch Node Configuration
sudo sed -i '/# cluster\.name: .*/a cluster.name: espi' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# node\.name: .*/a node.name: ${HOSTNAME}' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# node\.rack: .*/a node.rack: espi-rack-1' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# network\.host: .*/a network.host: 0.0.0.0' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# http\.port: .*/a http.port: 9200' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# bootstrap\.mlockall: true/a bootstrap.mlockall: true' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# node\.max_local_storage_nodes: 1/a node.max_local_storage_nodes: 1' /etc/elasticsearch/elasticsearch.yml

# Configure and Start Elasticsearch as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl start elasticsearch.service

# Install and Configure Curator for Elasticsearch
sudo apt-get install python-pip -y && sudo pip install elasticsearch-curator && echo -e "20 0    * * *   root    /usr/local/bin/curator delete indices --older-than 7 --time-unit days --timestring '%Y.%m.%d'" | sudo tee -a /etc/crontab && sudo /bin/systemctl restart cron.service



####### LOGSTASH #######

# Get and Install Logstash
wget -P/tmp https://download.elastic.co/logstash/logstash/packages/debian/logstash_${L_VERSION}_all.deb && sudo dpkg -i /tmp/logstash_${L_VERSION}_all.deb

# Get and Compile JFFI library for Logstash
sudo apt-get install ant -y && git clone https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-1.2.so /opt/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so && sudo chown logstash:logstash /opt/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so

# Set Logstash Memory Configuration (Max 300mb of memory)
sudo sed -i '/#LS_OPTS=""/a LS_OPTS="-w 4"' /etc/default/logstash
sudo sed -i '/#LS_HEAP_SIZE="1g"/a LS_HEAP_SIZE="300m"' /etc/default/logstash

# Set Logstash Node Configuration
sudo cp -f ./Logstash/00-default.conf /etc/logstash/conf.d/00-default.conf

# Configure and Start Logstash as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable logstash.service
sudo /bin/systemctl start logstash.service



####### KIBANA #######

# Get and Install Kibana
wget -P/tmp https://download.elastic.co/kibana/kibana/kibana-${K_VERSION}-linux-x86.tar.gz && sudo tar -xf /tmp/kibana-${K_VERSION}-linux-x86.tar.gz -C /opt && sudo mv /opt/kibana-${K_VERSION}-linux-x86 /opt/kibana

# Get and Update NodeJS for Kibana
wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz && sudo tar -xf /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz -C /opt/kibana && sudo mv /opt/kibana/node /opt/kibana/node.ori && sudo mv /opt/kibana/node-v${N_VERSION}-linux-armv7l /opt/kibana/node

# Set Kibana Memory Configuration (Max 100mb of memory)
sudo sed -i 's/exec "${NODE}" $NODE_OPTIONS "${DIR}\/src\/cli" ${@}/NODE_OPTIONS="--max-old-space-size=100" exec "${NODE}" $NODE_OPTIONS "${DIR}\/src\/cli" ${@}/' /opt/kibana/bin/kibana

# Set Kibana Node Configuration
sudo sed -i '/# server\.port: .*/a server.port: 5601' /opt/kibana/config/kibana.yml
sudo sed -i '/# server\.host: .*/a server.host: "localhost"' /opt/kibana/config/kibana.yml
sudo sed -i '/# elasticsearch\.url: .*/a elasticsearch.url: "http://localhost:9200"' /opt/kibana/config/kibana.yml
sudo sed -i '/# kibana\.index: .*/a kibana.index: ".kibana"' /opt/kibana/config/kibana.yml
sudo sed -i '/# kibana\.defaultAppId: .*/a kibana.defaultAppId: "dashboard"' /opt/kibana/config/kibana.yml
sudo sed -i '/# pid\.file: .*/a pid.file: \/var\/run\/kibana\/kibana.pid' /opt/kibana/config/kibana.yml
sudo sed -i '/# logging\.dest: .*/a logging.dest: \/var\/log\/kibana\/kibana.log' /opt/kibana/config/kibana.yml
sudo sed -i '/# logging\.verbose: .*/a logging.verbose: true' /opt/kibana/config/kibana.yml

# Create Kibana Group
if ! getent group kibana >/dev/null; then
  sudo groupadd -r kibana
fi

# Create Kibana User
if ! getent passwd kibana >/dev/null; then
  sudo useradd -M -r -g kibana -d /opt/kibana -s /usr/sbin/nologin -c "Kibana Service User" kibana
fi

# Configure and Start Kibana as Daemon
sudo cp -f ./Kibana/kibana_init /etc/init.d/kibana

sudo mkdir /var/log/kibana && sudo chown kibana /var/log/kibana
sudo mkdir /var/run/kibana

sudo chown -R kibana:kibana /opt/kibana

#sudo chown kibana:kibana /var/run/kibana
sudo chmod 755 /etc/init.d/kibana
sudo cp /etc/logrotate.d/logstash /etc/logrotate.d/kibana
sudo sed -i 's/\/var\/log\/logstash\/\*\.log.*/\/var\/log\/kibana\/kibana.log {/' /etc/logrotate.d/kibana
sudo chmod 0644 /etc/logrotate.d/kibana

# Configure and Start Kibana as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl start kibana.service



####### NGINX #######

# Install Nginx Reverse Proxy
sudo apt-get install nginx -y

# Create SSL Auto Signed Certificate for Nginx Reverse Proxy
sudo mkdir /etc/nginx/ssl && (echo FR; echo France; echo Paris; echo Raspberry Pi; echo Nginx; echo $(hostname -I); echo ;) | sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt

# Create Kibana User Group
if ! getent group kibana-usr >/dev/null; then
  sudo groupadd -r kibana-usr
fi

# Add "pi" user to Kibana User Group
sudo usermod -a -G kibana-usr pi

# Create Restricted Groups File for Nginx PAM authentication with "kibana-usr" default access group
sudo cp -f ./Nginx/restricted_groups /etc/nginx/restricted_groups

# Allow Nginx to read /etc/shadow file for PAM authentication
sudo usermod -a -G shadow www-data

# Set PAM Authentication for Nginx
sudo cp -f ./Nginx/nginx_restricted /etc/pam.d/nginx_restricted

# Set Nginx Default Site redirect on local Kibana with PAM authentication
sudo cp -f ./Nginx/default /etc/nginx/sites-available/default

# Restart Nginx Daemon for Update Configuration
sudo /bin/systemctl restart nginx.service
