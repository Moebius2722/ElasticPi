#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated SSH Configuration Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 2 ]] ; then
  echo "Usage : $0 IpCluster ClusterPassword"
  exit 1
fi

# Get IP Cluster
ipcluster=$1

# Get Cluster Password
clusterpwd=$2

# Install sshpass utility for ssh connection without password prompt
sudo apt-get install sshpass -q -y >/dev/null


####### CONFIGURE ELK PI #######

# Get IP Nodes
ipnodes=`ssh $ipcluster sudo cat /etc/elasticsearch/discovery-file/unicast_hosts.txt | grep -e "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$" | sort`

# Nodes Initialisation
for ipnode in ${ipnodes[@]}
do
  echo "=========================== $ipnode ==========================="
  echo 
  
  # Remove old node in SSH known_hosts
  ssh-keygen -R $ipnode >/dev/null 2>/dev/null
  
  # Add new node in SSH known_hosts
  ssh-keyscan -H $ipnode >> ~/.ssh/known_hosts 2>/dev/null
  
  # Generate RSA Key for SSH Auto Connect
  sshpass -p $clusterpwd ssh $ipnode 'sudo apt-get install sshpass -q -y >/dev/null ; rm -f ~/.ssh/authorized_keys ; rm -f ~/.ssh/id_rsa ; rm -f ~/.ssh/id_rsa.pub ; ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa >/dev/null 2>/dev/null'
done

# Nodes Autorizations
for ipnode in ${ipnodes[@]}
do
  # Add SSH Auto Connect
  for subipnode in ${ipnodes[@]}
  do
	echo "=================== $ipnode => $subipnode ==================="
	echo
    sshpass -p $clusterpwd ssh $ipnode "ssh-keygen -R $subipnode >/dev/null 2>/dev/null ; ssh-keyscan -H $subipnode >> ~/.ssh/known_hosts 2>/dev/null ; sshpass -p $clusterpwd ssh-copy-id $subipnode >/dev/null 2>/dev/null"
  done
done
