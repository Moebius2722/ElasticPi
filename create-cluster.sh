#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Create Cluster Script for Elastic Stack on Raspberry Pi 2 or 3

# Install Cluster Tools
# curl -sL https://raw.githubusercontent.com/Moebius2722/ElasticPi/master/install-tools.sh | bash -


####### COMMON #######

# Check Parameters
if [[ ! $# = 2 ]] ; then
  echo "Usage : $0 VIpCluster VIpFirstNode"
  exit 1
fi

# Check if cluster is already created
if [ -f /etc/elasticpi/nodes.lst ]; then
  echo "Cluster si already created"
  exit 1
fi

# Get VIP Cluster
vipcluster=$1

# Check Free Cluster VIP
ping -q -c 1 $vipcluster &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "Cluster VIP \"$vipcluster\" exist"
  exit 2
fi

# Get VIP First Node
vipfirstnode=$2

# Check Free First Node VIP
ping -q -c 1 $vipfirstnode &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "First Node VIP \"$vipfirstnode\" exist"
  exit 3
fi

# Get IP Node
ipnode=`hostname -I | cut -d ' ' -f 1`


####### CREATE CLUSTER #######

# Create Cluster Configuration Folder
sudo mkdir /etc/elasticpi

# Set Cluster VIP
echo $vipcluster | sudo tee /etc/elasticpi/cluster.vip >/dev/null 2>/dev/null
echo $vipcluster $ipnode | sudo tee /etc/elasticpi/vip.lst >/dev/null 2>/dev/null

# Set Node VIP
echo $vipfirstnode $ipnode | sudo tee -a /etc/elasticpi/vip.lst >/dev/null 2>/dev/null

# Set Cluster IP First Node
echo $ipnode | sudo tee /etc/elasticpi/nodes.lst >/dev/null 2>/dev/null

# Generate RSA Key for SSH Auto Connect
rm -rf ~/.ssh ; ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa >/dev/null 2>/dev/null && ssh-keyscan -H $ipnode >> ~/.ssh/known_hosts 2>/dev/null && cp -f ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys && chmod u=rw,g=-,o=- ~/.ssh/authorized_keys

# Create SSL Auto Signed Certificate for Nginx Reverse Proxy
sudo mkdir /etc/elasticpi/ssl && (echo FR; echo France; echo Paris; echo Raspberry Pi; echo Nginx; echo $vipcluster; echo ;) | sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/elasticpi/ssl/nginx.key -out /etc/elasticpi/ssl/nginx.crt && sudo chmod u=rw,g=-,o=- /etc/elasticpi/ssl/*.key

# Disable IPv6
echo net.ipv6.conf.all.disable_ipv6=1 | sudo tee /etc/sysctl.d/97-disableipv6.conf
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1

# Update System
update-system

# Create Repo
create-repo

# Install Keepalived
install-keepalived

# Install Nginx
install-nginx
