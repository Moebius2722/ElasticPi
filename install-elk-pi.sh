#!/bin/sh

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Installation Script for ELK Stack on Raspberry Pi 2 or 3



####### COMMON #######

# Set Version ELK
E_VERSION=2.4.1
L_VERSION=2.4.0
K_VERSION=4.6.1
N_VERSION=6.4.0

# Disable IPv6
echo net.ipv6.conf.all.disable_ipv6=1 | sudo tee /etc/sysctl.d/disableipv6.conf

# Full System Update
sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y

# Install Tools
# If you get script via GitHub, git tool is already installed ;)
# Htop is a good tool for monitoring cpu and memory usage by ELK Stack
sudo apt-get install curl jq git htop -y



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
echo vm.max_map_count=262144 | sudo tee -a /etc/sysctl.conf
#echo vm.swappiness=0 | sudo tee -a /etc/sysctl.conf
echo vm.swappiness=1 | sudo tee -a /etc/sysctl.conf

# Set Elasticsearch Node Configuration
sudo sed -i '/# cluster\.name: .*/a cluster.name: espi' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# node\.name: .*/a node.name: ${HOSTNAME}' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# node\.rack: .*/a node.rack: espi-rack-1' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# network\.host: .*/a network.host: 0.0.0.0' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# http\.port: .*/a http.port: 9200' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# bootstrap\.mlockall: true/a bootstrap.mlockall: true' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/# node\.max_local_storage_nodes: 1/a node.max_local_storage_nodes: 1' /etc/elasticsearch/elasticsearch.yml
#sudo sed -i '/# discovery\.zen\.ping\.unicast\.hosts: \["host1", "host2"\]/a discovery.zen.ping.unicast.hosts: ["192.168.0.22", "192.168.0.23"]' /etc/elasticsearch/elasticsearch.yml
#sudo sed -i '/# discovery\.zen\.minimum_master_nodes: 3/a discovery.zen.minimum_master_nodes: 1' /etc/elasticsearch/elasticsearch.yml

# Install Head, Kopf, HQ and Paramedic plugins for ElasticSearch
sudo /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
#http://server:9200/_plugin/head
sudo /usr/share/elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf
#http://server:9200/_plugin/kopf
sudo /usr/share/elasticsearch/bin/plugin install royrusso/elasticsearch-HQ
#http://server:9200/_plugin/hq
sudo /usr/share/elasticsearch/bin/plugin install karmi/elasticsearch-paramedic
#http://server:9200/_plugin/paramedic

# Configure and Start Elasticsearch as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl start elasticsearch.service

# Install and Configure Curator for Elasticsearch
sudo cp -f ./Curator/curator-config.yml /etc/elasticsearch/curator-config.yml
sudo cp -f ./Curator/curator-actions.yml /etc/elasticsearch/curator-actions.yml
#sudo apt-get install python-pip -y && sudo pip install PySocks && sudo pip install elasticsearch-curator && echo -e "20 0    * * *   root    /usr/local/bin/curator delete indices --older-than 7 --time-unit days --timestring '%Y.%m.%d'" | sudo tee -a /etc/crontab && sudo /bin/systemctl restart cron.service
sudo apt-get install python-pip -y && sudo pip install PySocks && sudo pip install elasticsearch-curator && echo -e "20 0    * * *   root    /usr/local/bin/curator --config /etc/elasticsearch/curator-config.yml /etc/elasticsearch/curator-actions.yml" | sudo tee -a /etc/crontab && sudo /bin/systemctl restart cron.service



####### LOGSTASH #######

# Get and Install Logstash
wget -P/tmp https://download.elastic.co/logstash/logstash/packages/debian/logstash-${L_VERSION}_all.deb && sudo dpkg -i /tmp/logstash-${L_VERSION}_all.deb

# Get and Compile JFFI library for Logstash
sudo apt-get install ant texinfo -y && git clone https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-1.2.so /opt/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so && sudo chown logstash:logstash /opt/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so

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
sudo sed -i '/exec "${NODE}" $NODE_OPTIONS "${DIR}\/src\/cli" ${@}/i NODE_OPTIONS="--max-old-space-size=100"' /opt/kibana/bin/kibana

# Set Kibana Node Configuration
sudo sed -i '/# server\.port: .*/a server.port: 5601' /opt/kibana/config/kibana.yml
sudo sed -i '/# server\.host: .*/a server.host: "127.0.0.1"' /opt/kibana/config/kibana.yml
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



####### KEEPALIVED #######

# Prevent loopback ARP response for Keepalived.

echo net.ipv4.ip_nonlocal_bind=1 | sudo tee /etc/sysctl.d/keepalived.conf
echo net.ipv4.ip_forward=1 | sudo tee -a /etc/sysctl.d/keepalived.conf
echo net.ipv4.conf.lo.arp_ignore=1 | sudo tee -a /etc/sysctl.d/keepalived.conf
echo net.ipv4.conf.lo.arp_announce=2 | sudo tee -a /etc/sysctl.d/keepalived.conf

sudo sysctl -p
sudo apt-get install iptables-persistent -y

sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X

sudo sh -c "iptables-save > /etc/iptables/rules.v4"
echo "iptables-restore < /etc/iptables/rules.v4" | sudo tee -a /etc/rc.local

# Install Keepalived Load Balancer
sudo apt-get install keepalived -y

# Set Static IP Addresses

#/etc/network/interfaces

# auto eth0
# iface eth0 inet static
# address 192.168.0.21
# netmask 255.255.255.0
# gateway 192.168.0.254

# auto eth0:0
# iface eth0:0 inet static
# address 192.168.1.21
# netmask 255.255.255.0

# auto lo:0
# iface lo:0 inet static
# address 192.168.0.10
# netmask 255.255.255.255

# auto lo:1
# iface lo:1 inet static
# address 192.168.0.11
# netmask 255.255.255.255

# auto lo:2
# iface lo:2 inet static
# address 192.168.0.12
# netmask 255.255.255.255

# Disable DHCP Client and enable manual network configuation
sudo systemctl disable dhcpcd
sudo systemctl enable networking

# Set DNS server with "resolvconf"
echo name_servers=192.168.0.254 | sudo tee -a /etc/resolvconf.conf

# Set DNS server with classic method and lock "resolv.conf" file
echo "nameserver 192.168.0.254" | sudo tee /etc/resolv.conf
sudo chattr +i /etc/resolv.conf