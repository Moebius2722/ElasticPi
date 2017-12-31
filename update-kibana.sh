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

# Get and Update Kibana with amd64 package (Just NodeJS is amd64 in package)
rm -f /tmp/kibana-${K_VERSION}-amd64.deb ; wget -P/tmp https://artifacts.elastic.co/downloads/kibana/kibana-${K_VERSION}-amd64.deb && sudo dpkg --force-architecture --force-confold --force-overwrite -i /tmp/kibana-${K_VERSION}-amd64.deb && rm -f /tmp/kibana-${K_VERSION}-amd64.deb

# Get and Replace NodeJS amd64 by ARMv7l in Kibana
rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz ; wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz && sudo tar -xf /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz -C /usr/share/kibana && sudo mv /usr/share/kibana/node /usr/share/kibana/node.ori && sudo mv /usr/share/kibana/node-v${N_VERSION}-linux-armv7l /usr/share/kibana/node && sudo chown -R root:root /usr/share/kibana/node && sudo rm -rf /usr/share/kibana/node.ori && rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz

# Configure and Start Kibana as Daemon
sudo /bin/systemctl daemon-reload
start-kibana
