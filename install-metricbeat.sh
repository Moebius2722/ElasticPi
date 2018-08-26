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
echo "1 MB_VERSION = ${MB_VERSION}"
if [[ "${MB_VERSION}" = "" ]]; then
  # Check if cluster is created
  if [ -f /etc/elasticpi/nodes.lst ]; then
    echo "2 MB_VERSION = ${MB_VERSION}"
    MB_VERSION=`get-metricbeat-maxversion`
  else
    echo "3 MB_VERSION = ${MB_VERSION}"
    MB_VERSION=`get-metricbeat-lastversion`
  fi
fi
echo "4 MB_VERSION = ${MB_VERSION}"
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

# Install Golang
install-golang

# Get and Check Metricbeat Source
if [ -f /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm.sha512 ] && [ -f /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm ]; then
  pushd /mnt/elasticpi/build/metricbeat/${MB_VERSION}
  sha512sum -c /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm.sha512
  if [ $? -ne 0 ] ; then
    # Get and Compile Metricbeat Binary for ARM
    rm -rf ${GOPATH}/src/github.com/elastic ; mkdir -p ${GOPATH}/src/github.com/elastic && git clone -b v${MB_VERSION} https://github.com/elastic/beats.git ${GOPATH}/src/github.com/elastic/beats
    pushd ${GOPATH}/src/github.com/elastic/beats/metricbeat
    export GOX_OSARCH='!netbsd/386 !linux/amd64 !windows/386 !linux/386 !windows/amd64 !netbsd/arm !linux/ppc64le !solaris/amd64 !netbsd/amd64 !linux/ppc64 !freebsd/arm !darwin/amd64 !darwin/386 !openbsd/amd64 !freebsd/386 !openbsd/386 !freebsd/amd64'
    make clean
    make crosscompile
    sudo cp -f ${GOPATH}/src/github.com/elastic/beats/metricbeat/build/bin/metricbeat-linux-arm /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm
    popd
    rm -rf ${GOPATH}/src/github.com/elastic
    pushd /mnt/elasticpi/build/metricbeat/${MB_VERSION}/ && sha512sum metricbeat-linux-arm | sudo tee /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm.sha512 && popd
  fi
  popd
else
  # Get and Compile Metricbeat Binary for ARM
  rm -rf ${GOPATH}/src/github.com/elastic ; mkdir -p ${GOPATH}/src/github.com/elastic && git clone -b v${MB_VERSION} https://github.com/elastic/beats.git ${GOPATH}/src/github.com/elastic/beats
  pushd ${GOPATH}/src/github.com/elastic/beats/metricbeat
  export GOX_OSARCH='!netbsd/386 !linux/amd64 !windows/386 !linux/386 !windows/amd64 !netbsd/arm !linux/ppc64le !solaris/amd64 !netbsd/amd64 !linux/ppc64 !freebsd/arm !darwin/amd64 !darwin/386 !openbsd/amd64 !freebsd/386 !openbsd/386 !freebsd/amd64'
  make clean
  make crosscompile
  sudo cp -f ${GOPATH}/src/github.com/elastic/beats/metricbeat/build/bin/metricbeat-linux-arm /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm
  popd
  rm -rf ${GOPATH}/src/github.com/elastic
  pushd /mnt/elasticpi/build/metricbeat/${MB_VERSION} && sha512sum metricbeat-linux-arm | sudo tee /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm.sha512 && popd
fi

# Replace Metricbeat Binary
sudo cp -f /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm /usr/share/metricbeat/bin/metricbeat

# Load Index Template
sudo metricbeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'

# Set up dashboards for Logstash output
sudo metricbeat setup -e -E output.logstash.enabled=false -E output.elasticsearch.hosts=['localhost:9200'] -E setup.kibana.host=localhost:5601

# Configure and Start Metricbeat as Daemon
sudo /bin/systemctl daemon-reload

# Configure Metricbeat
configure-metricbeat ${l_ip}

restart-metricbeat
