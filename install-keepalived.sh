#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Keepalived on Raspberry Pi 2 or 3


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/vip.lst ]; then
  echo "Create cluster before install Keepalived"
  exit 1
fi

# Check if already installed
if get-keepalived-version >/dev/null 2>/dev/null; then
  echo "Keepalived is already installed" >&2
  exit 1
fi


####### KEEPALIVED #######

# Prevent loopback ARP response for Keepalived.
echo net.ipv4.ip_nonlocal_bind=1 | sudo tee /etc/sysctl.d/95-keepalived.conf
sudo sysctl -w net.ipv4.ip_nonlocal_bind=1
echo net.ipv4.ip_forward=1 | sudo tee -a /etc/sysctl.d/95-keepalived.conf
sudo sysctl -w net.ipv4.ip_forward=1
echo net.ipv4.conf.lo.arp_ignore=1 | sudo tee -a /etc/sysctl.d/95-keepalived.conf
sudo sysctl -w net.ipv4.conf.lo.arp_ignore=1
echo net.ipv4.conf.lo.arp_announce=2 | sudo tee -a /etc/sysctl.d/95-keepalived.conf
sudo sysctl -w net.ipv4.conf.lo.arp_announce=2
sudo sysctl -p

# Install Keepalived Load Balancer
sudo apt-get install ipset netcat keepalived -q -y

# Configure Keepalived Load Balancer
configure-keepalived
