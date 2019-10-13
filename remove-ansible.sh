#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Ansible on Raspberry Pi 2 or 3


####### COMMON #######

# Check if not installed
if ! get-ansible-version >/dev/null 2>/dev/null; then
  echo "Ansible isn't installed" >&2
  exit 1
fi


####### ANSIBLE #######

# Remove Ansible
sudo apt purge ansible -q -y
sudo apt autoremove --purge -q -y

# Purge Ansible configuration
sudo rm -rf /etc/ansible
