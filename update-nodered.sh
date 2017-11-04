#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Lastest Node-RED on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
NR_VERSION=`npm info node-red version`

# Check if already up to date
NR_CVERSION=`get-nodered-version`
if [[ "${NR_VERSION}" = "${NR_CVERSION}" ]]; then
  echo "Node-RED is already up to date to ${NR_CVERSION} version"
  exit 0
fi
echo "Update Node-RED ${NR_CVERSION} to ${NR_VERSION}"

# Stop Node-RED Daemon
stop-nodered


####### NODERED #######

# Update NodeJS
curl -sL https://deb.nodesource.com/setup_6.x | sudo bash -
sudo apt-get upgrade -q -y

# Update Node-RED
sudo npm cache clean
#sudo npm install -g npm@3.x
hash -r
sudo npm install -g node-gyp
sudo npm install -g --unsafe-perm node-red
cd ~/.node-red
npm update
npm rebuild

# Configure and Start Node-RED as Daemon
sudo /bin/systemctl daemon-reload
start-nodered
