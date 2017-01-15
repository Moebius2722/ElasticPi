#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Update Script for Kibana on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${K_VERSION} = '' ]]; then
  K_VERSION=5.1.2
fi
if [[ ${N_VERSION} = '' ]]; then
  N_VERSION=6.9.0
fi

# Check if already up to date
K_CVERSION=`dpkg-query -W -f='${Version}\n' kibana`
if [[ "${K_VERSION}" = "${K_CVERSION}" ]]; then
  echo "Kibana is already up to date to ${K_CVERSION} version"
  exit 0
fi

# Full System Update
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update


####### KIBANA #######

# Get and Update Kibana with i386 package (Just NodeJS is i386 in package)
wget -P/tmp https://artifacts.elastic.co/downloads/kibana/kibana-${K_VERSION}-i386.deb && sudo dpkg --force-architecture --force-confold --force-overwrite -i /tmp/kibana-${K_VERSION}-i386.deb

# Get and Replace NodeJS i386 by ARMv7l in Kibana
wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz && sudo tar -xf /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz -C /usr/share/kibana && sudo mv /usr/share/kibana/node /usr/share/kibana/node.ori && sudo mv /usr/share/kibana/node-v${N_VERSION}-linux-armv7l /usr/share/kibana/node && sudo chown -R root:root /usr/share/kibana/node && sudo rm -rf /usr/share/kibana/node.ori

# Configure and Start Kibana as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl start kibana.service
