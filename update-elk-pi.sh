#!/bin/sh

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Update Script for ELK Stack on Raspberry Pi 2 or 3



####### COMMON #######

# Set Version ELK
E_VERSION=2.3.4
L_VERSION=2.3.4-1
K_VERSION=4.5.2
N_VERSION=4.4.7

# Full System Update
sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y

####### ELASTICSEARCH #######

# Stop Elasticsearch service
sudo /bin/systemctl stop elasticsearch.service

# Get and Update Elasticsearch
wget -P/tmp https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/${E_VERSION}/elasticsearch-${E_VERSION}.deb && sudo dpkg -i --force-all /tmp/elasticsearch-${E_VERSION}.deb

# Set Elasticsearch Memory Configuration (Max 300mb of memory)
sudo sed -i '/#LimitMEMLOCK=infinity/a LimitMEMLOCK=infinity' /usr/lib/systemd/system/elasticsearch.service

# Update Head, Kopf, HQ and Paramedic plugins for ElasticSearch
sudo /usr/share/elasticsearch/bin/plugin remove head
sudo /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
#http://server:9200/_plugin/head
sudo /usr/share/elasticsearch/bin/plugin remove kopf
sudo /usr/share/elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf
#http://server:9200/_plugin/kopf
sudo /usr/share/elasticsearch/bin/plugin remove hq
sudo /usr/share/elasticsearch/bin/plugin install royrusso/elasticsearch-HQ
#http://server:9200/_plugin/hq
sudo /usr/share/elasticsearch/bin/plugin remove paramedic
sudo /usr/share/elasticsearch/bin/plugin install karmi/elasticsearch-paramedic
#http://server:9200/_plugin/paramedic

# Configure and Start Elasticsearch as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl start elasticsearch.service

# Upgrade Curator for Elasticsearch
sudo pip install --upgrade elasticsearch-curator



####### LOGSTASH #######

# Stop Logstash service
sudo /bin/systemctl stop logstash.service

# Get and Update Logstash
wget -P/tmp https://download.elastic.co/logstash/logstash/packages/debian/logstash_${L_VERSION}_all.deb && sudo dpkg -i --force-all /tmp/logstash_${L_VERSION}_all.deb

# Get and Compile JFFI library for Logstash
sudo apt-get install ant texinfo -y && git clone https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-1.2.so /opt/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so && sudo chown logstash:logstash /opt/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so

# Set Logstash Memory Configuration (Max 300mb of memory)
sudo sed -i '/#LS_OPTS=""/a LS_OPTS="-w 4"' /etc/default/logstash
sudo sed -i '/#LS_HEAP_SIZE="1g"/a LS_HEAP_SIZE="300m"' /etc/default/logstash

# Configure and Start Logstash as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable logstash.service
sudo /bin/systemctl start logstash.service



####### KIBANA #######

# Stop Kibana service
sudo /bin/systemctl stop kibana.service

# Backup Kibana previous installation
sudo mv /opt/kibana /opt/kibana-old

# Get and Update Kibana
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

# Configure Kibana installation
sudo chown -R kibana:kibana /opt/kibana

# Configure and Start Kibana as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl start kibana.service
