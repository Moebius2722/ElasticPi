#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Metricbeat on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${MB_VERSION} = '' ]]; then
  MB_VERSION=`get-metricbeat-lastversion`
fi

# Check if already up to date
#MB_CVERSION=`get-metricbeat-version`
MB_CVERSION=`/usr/share/metricbeat/bin/metricbeat version | cut -d ' ' -f 3`
if [ $? -ne 0 ] ; then
  exit 1
fi
if [[ "${MB_VERSION}" = "${MB_CVERSION}" ]]; then
  echo "Metricbeat is already up to date to ${MB_CVERSION} version"
  exit 0
fi
echo "Update Metricbeat ${MB_CVERSION} to ${MB_VERSION}"

# Stop Metricbeat Daemon
stop-metricbeat


####### METRICBEAT #######

#Create Metricbeat Build Folder
if [ ! -d "/mnt/elasticpi/build/metricbeat/${MB_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/metricbeat/${MB_VERSION}
  sudo chown -R elasticsearch:elasticsearch /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get and Check Metricbeat Debian Package
rm -f /tmp/metricbeat-${MB_VERSION}-amd64.deb.sha512
wget -P/tmp https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${MB_VERSION}-amd64.deb.sha512
if [ -f "/mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-${MB_VERSION}-amd64.deb" ]; then
  pushd /mnt/elasticpi/build/metricbeat/${MB_VERSION}
  sha512sum -c /tmp/metricbeat-${MB_VERSION}-amd64.deb.sha512
  if [ $? -ne 0 ] ; then
    rm -f /tmp/metricbeat-${MB_VERSION}-amd64.deb
    wget -P/tmp https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${MB_VERSION}-amd64.deb
    pushd /tmp
    sha512sum -c /tmp/metricbeat-${MB_VERSION}-amd64.deb.sha512
    if [ $? -ne 0 ] ; then
      exit 1
    fi
	popd
	sudo cp -f /tmp/metricbeat-${MB_VERSION}-amd64.deb /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-${MB_VERSION}-amd64.deb
	rm -f /tmp/metricbeat-${MB_VERSION}-amd64.deb
  fi
  popd
else
  rm -f /tmp/metricbeat-${MB_VERSION}-amd64.deb
  wget -P/tmp https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${MB_VERSION}-amd64.deb
  pushd /tmp
  sha512sum -c /tmp/metricbeat-${MB_VERSION}-amd64.deb.sha512
  if [ $? -ne 0 ] ; then
    popd
	exit 1
  fi
  popd
  sudo cp -f /tmp/metricbeat-${MB_VERSION}-amd64.deb /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-${MB_VERSION}-amd64.deb
  rm -f /tmp/metricbeat-${MB_VERSION}-amd64.deb
fi
rm -f /tmp/metricbeat-${MB_VERSION}-amd64.deb.sha512

# Update Metricbeat with amd64 package
sudo dpkg --force-architecture --force-confold --force-overwrite -i /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-${MB_VERSION}-amd64.deb

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
    sudo sha512sum /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm | sudo tee /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm.sha512
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
  sudo sha512sum /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm | sudo tee /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm.sha512
fi

# Replace Metricbeat Binary
sudo cp -f /mnt/elasticpi/build/metricbeat/${MB_VERSION}/metricbeat-linux-arm /usr/share/metricbeat/bin/metricbeat


# Configure and Start Metricbeat as Daemon
sudo /bin/systemctl daemon-reload
start-metricbeat
