#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Metricbeat on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 3 ]] ; then
  echo "Usage : $0 Elasticsearch_IP Elasticsearch_User Elasticsearch_Password"
  exit 1
fi

# Get Elasticsearch IP
e_ip=$1

# Get Elasticsearch User
e_user=$2

# Get Elasticsearch Password
e_password=$3

# Check if already installed
if get-metricbeat-version >/dev/null 2>/dev/null; then
  echo "Metricbeat is already installed" >&2
  exit 1
fi

# Check if cluster is created
if [ -f /etc/elasticpi/nodes.lst ]; then
  MB_VERSION=`get-metricbeat-maxversion`
fi

# Set Version
if [[ ${MB_VERSION} = '' ]]; then
  MB_VERSION=`get-metricbeat-lastversion`
fi


####### METRICBEAT #######

# Get and Install Metricbeat with amd64 package
rm -f /tmp/metricbeat-${MB_VERSION}-amd64.deb ; wget -P/tmp https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${MB_VERSION}-amd64.deb && sudo dpkg --force-architecture -i /tmp/metricbeat-${MB_VERSION}-amd64.deb && rm -f /tmp/metricbeat-${MB_VERSION}-amd64.deb

# Install Golang
install-golang

# Compile Metricbeat for arm
rm -rf ${GOPATH}/src/github.com/elastic ; mkdir -p ${GOPATH}/src/github.com/elastic && git clone -b v${MB_VERSION} https://github.com/elastic/beats.git ${GOPATH}/src/github.com/elastic/beats
pushd ${GOPATH}/src/github.com/elastic/beats/metricbeat
export GOX_OSARCH='!netbsd/386 !linux/amd64 !windows/386 !linux/386 !windows/amd64 !netbsd/arm !linux/ppc64le !solaris/amd64 !netbsd/amd64 !linux/ppc64 !freebsd/arm !darwin/amd64 !darwin/386 !openbsd/amd64 !freebsd/386 !openbsd/386 !freebsd/amd64'
make clean
make crosscompile
popd
sudo cp -f ${GOPATH}/src/github.com/elastic/beats/metricbeat/build/bin/metricbeat-linux-arm /usr/share/metricbeat/bin/metricbeat
rm -rf ${GOPATH}/src/github.com/elastic

# Configure Metricbeat

# Configure Metricbeat for Kibana
sudo sed -i 's/  index.number_of_shards: 1/  index.number_of_shards: 5/' /etc/metricbeat/metricbeat.yml
sudo sed -i '/  index.number_of_shards: 5/a\  index.auto_expand_replicas: 0-3' /etc/metricbeat/metricbeat.yml
sudo sed -i "/  #host: \"localhost:5601\"/a\  host: \"https:\/\/${e_ip}:443\"" /etc/metricbeat/metricbeat.yml
sudo sed -i "/  host: \"https:\/\/${e_ip}:443\"/a\  username: \"${e_user}\"" /etc/metricbeat/metricbeat.yml
sudo sed -i "/  username: \"${e_user}\"/a\  password: \"${e_password}\"" /etc/metricbeat/metricbeat.yml

# Configure Metricbeat for Elasticsearch
sudo sed -i 's/  hosts: \["localhost:9200"\]/  #hosts: ["localhost:9200"]/' /etc/metricbeat/metricbeat.yml
sudo sed -i "/  #hosts: \[\"localhost:9200\"\]/a\  hosts: [\"${e_ip}:9202\"]" /etc/metricbeat/metricbeat.yml
sudo sed -i "/  #protocol: \"https\"/a\  protocol: \"https\"" /etc/metricbeat/metricbeat.yml
sudo sed -i "/  #username: \"elastic\"/a\  username: \"${e_user}\"" /etc/metricbeat/metricbeat.yml
sudo sed -i "/  #password: \"changeme\"/a\  password: \"${e_password}\"" /etc/metricbeat/metricbeat.yml

# Configure Metricbeat SSL
sudo sed -i "/  password: \"${e_password}\"/a\  ssl.enabled: true" /etc/metricbeat/metricbeat.yml
sudo sed -i "/  ssl.enabled: true/a\  ssl.verification_mode: none" /etc/metricbeat/metricbeat.yml

# Configure Metricbeat Period
sudo sed -i 's/  period: 10s/  period: 30s/' /etc/metricbeat/modules.d/system.yml

  
# Configure and Start Metricbeat as Daemon
sudo /bin/systemctl daemon-reload
restart-metricbeat
