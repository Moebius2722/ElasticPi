#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Remove Node of Cluster Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 1 ]] ; then
  echo "Usage : $0 IpNode [-f]"
  exit 1
fi

# Get IP Node
ipnode=$1

# Check if node is member of cluster
if ! grep -c $ipnode /etc/elasticpi/nodes.lst >/dev/null 2>/dev/null; then
    echo "Node $ipnode isn't member of cluster."
	exit 1
fi

# Get Cluster VIP
vipcluster=`cat /etc/elasticpi/cluster.vip`


####### REMOVE NODE #######
echo '=========================== Remove Node ' $ipnode '==========================='

# Remove IP Node
allssh sudo sed -i "/$ipnode/d" /etc/elasticpi/nodes.lst

# Remove Node in "hosts" file
allssh sudo sed -i "/$ipnode/d" /etc/hosts

# Remove VIP Node
allssh sudo sed -i "/$ipnode/d" /etc/elasticpi/vip.lst

# If Node owned Cluser VIP, Cluster VIP assign to first another node
if ! grep -cq $vipcluster /etc/elasticpi/vip.lst; then
  # Get first another node
  ipfirstnode=`head -n 1 /etc/elasticpi/nodes.lst`

  # Cluster VIP assign to first another node
  allssh "echo $vipcluster $ipfirstnode | sudo tee -a /etc/elasticpi/vip.lst >/dev/null 2>/dev/null"
fi

# Reconfigure Elasticsearch
allssh reconfigure-elasticsearch

# Reconfigure Keepalived
allssh reconfigure-keepalived

# Reconfigure Nginx
allssh reconfigure-nginx

# Remove Elasticsearch
ssh $ipnode remove-elasticsearch

# Remove Logstash
ssh $ipnode remove-logstash

# Remove Kibana
ssh $ipnode remove-kibana

# Remove Metricbeat
ssh $ipnode remove-metricbeat

# Remove Cerebro
ssh $ipnode remove-cerebro

# Remove Node-RED
ssh $ipnode remove-nodered

# Remove Mosquitto
ssh $ipnode remove-mosquitto

# Remove Nginx
ssh $ipnode remove-nginx

# Remove Keepalived
ssh $ipnode remove-keepalived

# Remove Tools
ssh $ipnode remove-tools

# Clean Uninstalled Packeges
ssh $ipnode 'sudo dpkg --purge $(dpkg --get-selections | grep deinstall | cut -f1) >/dev/null 2>/dev/null'

# Remove Node Autorizations
ssh $ipnode rm -rf ~/.ssh

# Remove old IP node in SSH known_hosts
allssh "ssh-keygen -R $ipnode >/dev/null 2>/dev/null"
