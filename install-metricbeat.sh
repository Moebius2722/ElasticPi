#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Metricbeat on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 1 ]] ; then
  echo "Usage : $0 Logstash_IP"
  exit 1
fi

# Get Logstash IP
l_ip=$1

# Check if already installed
if get-metricbeat-version >/dev/null 2>/dev/null; then
  echo "Metricbeat is already installed" >&2
  exit 1
fi

# Set Version
if [[ "${MB_VERSION}" = "" ]]; then
  # Check if cluster is created
  if [ -f /etc/elasticpi/nodes.lst ]; then
    MB_VERSION=`get-metricbeat-maxversion`
  else
    MB_VERSION=`get-metricbeat-lastversion`
  fi
fi
echo Install Metricbeat ${MB_VERSION}

####### METRICBEAT #######

# Create Metricbeat Build Folder
if [ ! -d "/mnt/elasticpi/build/metricbeat/${MB_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/metricbeat/${MB_VERSION}
  sudo chown -R root:root /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get and Check Metricbeat Debian Package
rm -f /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb.sha512
wget -P/tmp https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-${MB_VERSION}-amd64.deb.sha512
if [ -f "/mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-oss-${MB_VERSION}-amd64.deb" ]; then
  pushd /mnt/elasticpi/build/metricbeat/${MB_VERSION}
  sha512sum -c /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb.sha512
  if [ $? -ne 0 ] ; then
    rm -f /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb
    wget -P/tmp https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-${MB_VERSION}-amd64.deb
    pushd /tmp
    sha512sum -c /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb.sha512
    if [ $? -ne 0 ] ; then
      popd
      exit 1
    fi
	  popd
	  sudo cp -f /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-oss-${MB_VERSION}-amd64.deb
	  rm -f /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb
  fi
  popd
else
  rm -f /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb
  wget -P/tmp https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-${MB_VERSION}-amd64.deb
  pushd /tmp
  sha512sum -c /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb.sha512
  if [ $? -ne 0 ] ; then
    popd
	  exit 1
  fi
  popd
  sudo cp -f /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-oss-${MB_VERSION}-amd64.deb
  rm -f /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb
fi
rm -f /tmp/metricbeat-oss-${MB_VERSION}-amd64.deb.sha512

# Install Metricbeat with amd64 package
sudo dpkg --force-architecture --force-confold --force-overwrite -i /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-oss-${MB_VERSION}-amd64.deb

# Buid Metricbeat Binary
build-metricbeat ${MB_VERSION}

# Replace Metricbeat Binary
sudo cp -f /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm /usr/share/metricbeat/bin/metricbeat

# Check if cluster is created
if [ -f /etc/elasticpi/nodes.lst ]; then
  # Load Index Template
  sudo metricbeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'

  # Set up dashboards for Logstash output
  sudo metricbeat setup -e -E output.logstash.enabled=false -E output.elasticsearch.hosts=['localhost:9200'] -E setup.kibana.host=localhost:5601
  # sudo metricbeat setup --dashboards -e -E setup.dashboards.retry.enabled=true -E output.logstash.enabled=false -E output.elasticsearch.hosts=['https://192.168.0.17:9202'] -E output.elasticsearch.ssl.enabled=true -E output.elasticsearch.ssl.verification_mode=none -E setup.kibana.ssl.enabled=true -E setup.kibana.ssl.verification_mode=none -E setup.kibana.host='https://192.168.0.17:443' -E output.elasticsearch.username=pi -E output.elasticsearch.password=######
fi

# Configure and Start Metricbeat as Daemon
sudo /bin/systemctl daemon-reload

# Configure Metricbeat
configure-metricbeat ${l_ip}

# restart Metricbeat Daemon
restart-metricbeat
