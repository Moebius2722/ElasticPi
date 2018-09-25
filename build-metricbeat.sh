#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Buid Metricbeat Script for Metricbeat on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 1 ]] ; then
  echo "Usage : $0 Metricbeat_Version"
  exit 1
fi

# Get Metricbeat Version
MB_VERSION=$1


####### BUILD-METRICBEAT #######

# Check If Already Build
if [ -f /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm.sha512 ] && [ -f /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm ]; then
  pushd /mnt/elasticpi/build/metricbeat/${MB_VERSION}
  sha512sum -c /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm.sha512
  if [ $? -eq 0 ] ; then
    popd
    exit 0
    # Exit Build
  fi
  popd
fi

# Backup Node State and Stop Node
backup-node-state
stop-node

# Install Golang
install-golang

# Create Metricbeat Build Folder
if [ ! -d "/mnt/elasticpi/build/metricbeat/${MB_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/metricbeat/${MB_VERSION}
  sudo chown -R root:root /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

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

# Restore Node State
restore-node-state
