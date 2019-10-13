#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Ansible on Raspberry Pi 2 or 3 or 4


####### COMMON #######

# Check if already installed
if get-ansible-version >/dev/null 2>/dev/null; then
  echo "Ansible is already installed" >&2
  exit 1
fi


####### ANSIBLE #######

# Add Ansible Repository
echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/ansible.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
sudo apt update

# Install Squid
sudo apt install ansible
