#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Mosquitto on Raspberry Pi 2 or 3


####### COMMON #######

# Check if not installed
if ! get-mosquitto-version >/dev/null 2>/dev/null; then
  echo "Mosquitto isn't installed" >&2
  exit 1
fi


####### MOSQUITTO #######

# Stop Mosquitto
stop-mosquitto

# Remove Mosquitto MQTT Server
sudo apt-get purge mosquitto -q -y
