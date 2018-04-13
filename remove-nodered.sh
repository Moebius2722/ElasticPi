#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Node-RED on Raspberry Pi 2 or 3


####### COMMON #######

# Check if not installed
if ! get-nodered-version >/dev/null 2>/dev/null; then
  echo "Node-RED isn't installed" >&2
  exit 1
fi


####### NODE-RED #######

# Stop Node-RED
stop-nodered

# Remove Elasticsearch Node to Node-RED
node-red-admin remove node-red-contrib-elasticsearchcdb

# Purge Node-RED configuration
rm -rf /home/pi/.node-red

# Remove Node-RED-Admin Tool
sudo npm uninstall -g node-red-admin

# Remove Node-RED Daemon
sudo rm -f /lib/systemd/system/nodered.service
sudo rm -f /usr/bin/node-red-start
sudo rm -f /usr/bin/node-red-stop
sudo /bin/systemctl daemon-reload

# Remove Node-RED
sudo npm uninstall -g --unsafe-perm node-red
