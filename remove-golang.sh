#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Golang on Raspberry Pi 2 or 3


####### COMMON #######

# Check if not installed
if ! get-golang-version >/dev/null 2>/dev/null; then
  echo "Golang isn't installed" >&2
  exit 1
fi


####### Golang #######

# Remove Golang
sudo rm -rf /usr/local/go

# Purge Golang Enironnement
sudo rm -f /etc/profile.d/go.sh
sudo rm -f /etc/bashrc.d/go.sh
sudo rm -f /usr/bin/go
