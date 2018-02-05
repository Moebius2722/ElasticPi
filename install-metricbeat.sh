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

# Compile Metricbeat for arm
rm -rf ${GOPATH}/src/github.com/elastic ; mkdir -p ${GOPATH}/src/github.com/elastic && git clone -b v${MB_VERSION} https://github.com/elastic/beats.git ${GOPATH}/src/github.com/elastic/beats
cd ${GOPATH}/src/github.com/elastic/beats/metricbeat
export GOX_OSARCH='!netbsd/386 !linux/amd64 !windows/386 !linux/386 !windows/amd64 !netbsd/arm !linux/ppc64le !solaris/amd64 !netbsd/amd64 !linux/ppc64 !freebsd/arm !darwin/amd64 !darwin/386 !openbsd/amd64 !freebsd/386 !openbsd/386 !freebsd/amd64'
make clean
make crosscompile
sudo cp -f ${GOPATH}/src/github.com/elastic/beats/metricbeat/build/bin/metricbeat-linux-arm /usr/share/metricbeat/bin/metricbeat
rm -rf ${GOPATH}/src/github.com/elastic

# Configure and Start Metricbeat as Daemon
sudo /bin/systemctl daemon-reload
start-metricbeat
