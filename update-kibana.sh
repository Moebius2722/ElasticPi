#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Kibana on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${K_VERSION} = '' ]]; then
  K_VERSION=`get-kibana-lastversion`
fi
if [[ ${N_VERSION} = '' ]]; then
  K_MVERSION=`echo $K_VERSION | cut -d . -f 1-2`
  N_VERSION=`wget https://raw.githubusercontent.com/elastic/kibana/$K_MVERSION/.node-version -qO-`
fi

# Check if already up to date
K_CVERSION=`get-kibana-version`
if [ $? -ne 0 ] ; then
  exit 1
fi
if [[ "${K_VERSION}" = "${K_CVERSION}" ]]; then
  echo "Kibana is already up to date to ${K_CVERSION} version"
  exit 0
fi
echo "Update Kibana ${K_CVERSION} to ${K_VERSION}"

# Stop Kibana Daemon
stop-kibana


####### KIBANA #######

#Create Kibana Build Folder
if [ ! -d "/mnt/espibackup/build/kibana/${K_VERSION}" ]; then
  sudo mkdir -p /mnt/espibackup/build/kibana/${K_VERSION}
  sudo chown -R elasticsearch:elasticsearch /mnt/espibackup/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/espibackup/build
  sudo chmod o=rx /mnt/espibackup
fi

# Get and Check Kibana Debian Package
rm -f /tmp/kibana-${K_VERSION}-amd64.deb.sha512
wget -P/tmp https://artifacts.elastic.co/downloads/kibana/kibana-${K_VERSION}-amd64.deb.sha512
if [ -f "/mnt/espibackup/build/kibana/${K_VERSION}/kibana-${K_VERSION}-amd64.deb" ]; then
  pushd /mnt/espibackup/build/kibana/${K_VERSION}
  sha512sum -c /tmp/kibana-${K_VERSION}-amd64.deb.sha512
  if [ $? -ne 0 ] ; then
    rm -f /tmp/kibana-${K_VERSION}-amd64.deb
    wget -P/tmp https://artifacts.elastic.co/downloads/kibana/kibana-${K_VERSION}-amd64.deb
    pushd /tmp
    sha512sum -c /tmp/kibana-${K_VERSION}-amd64.deb.sha512
    if [ $? -ne 0 ] ; then
      exit 1
    fi
	popd
	sudo cp -f /tmp/kibana-${K_VERSION}-amd64.deb /mnt/espibackup/build/kibana/${K_VERSION}/kibana-${K_VERSION}-amd64.deb
	rm -f /tmp/kibana-${K_VERSION}-amd64.deb
  fi
  popd
else
  rm -f /tmp/kibana-${K_VERSION}-amd64.deb
  wget -P/tmp https://artifacts.elastic.co/downloads/kibana/kibana-${K_VERSION}-amd64.deb
  pushd /tmp
  sha512sum -c /tmp/kibana-${K_VERSION}-amd64.deb.sha512
  if [ $? -ne 0 ] ; then
    popd
	exit 1
  fi
  popd
  sudo cp -f /tmp/kibana-${K_VERSION}-amd64.deb /mnt/espibackup/build/kibana/${K_VERSION}/kibana-${K_VERSION}-amd64.deb
  rm -f /tmp/kibana-${K_VERSION}-amd64.deb
fi
rm -f /tmp/kibana-${K_VERSION}-amd64.deb.sha512

# Update Kibana with amd64 package (Just NodeJS is amd64 in package)
sudo dpkg --force-architecture --force-confold --force-overwrite -i /mnt/espibackup/build/kibana/${K_VERSION}/kibana-${K_VERSION}-amd64.deb

#Create NodeJS Build Folder
if [ ! -d "/mnt/espibackup/build/nodejs/${N_VERSION}" ]; then
  sudo mkdir -p /mnt/espibackup/build/nodejs/${N_VERSION}
  sudo chown -R elasticsearch:elasticsearch /mnt/espibackup/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/espibackup/build
  sudo chmod o=rx /mnt/espibackup
fi

# Get and Check NodeJS Binary Archive
rm -f /tmp/SHASUMS256.txt
rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256
wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/SHASUMS256.txt
cat /tmp/SHASUMS256.txt | grep node-v${N_VERSION}-linux-armv7l.tar.gz >/tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256
rm -f /tmp/SHASUMS256.txt

if [ -f "/mnt/espibackup/build/nodejs/${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz" ]; then
  pushd /mnt/espibackup/build/nodejs/${N_VERSION}
  sha256sum -c /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256
  if [ $? -ne 0 ] ; then
    rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz
    wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz
    pushd /tmp
    sha256sum -c /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256
    if [ $? -ne 0 ] ; then
      exit 1
    fi
	popd
	sudo cp -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz /mnt/espibackup/build/nodejs/${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz
	rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz
  fi
  popd
else
  rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz
  wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz
  pushd /tmp
  sha256sum -c /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256
  if [ $? -ne 0 ] ; then
    popd
	exit 1
  fi
  popd
  sudo cp -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz /mnt/espibackup/build/nodejs/${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz
  rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz
fi
rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256

# Replace NodeJS amd64 by ARMv7l in Kibana
sudo tar xzvf /mnt/espibackup/build/nodejs/${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz -C /usr/share/kibana && sudo mv /usr/share/kibana/node /usr/share/kibana/node.ori && sudo mv /usr/share/kibana/node-v${N_VERSION}-linux-armv7l /usr/share/kibana/node && sudo chown -R root:root /usr/share/kibana/node && sudo rm -rf /usr/share/kibana/node.ori

# Configure and Start Kibana as Daemon
sudo /bin/systemctl daemon-reload
start-kibana
