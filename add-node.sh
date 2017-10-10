#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Add New Node in Cluster Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 2 ]] ; then
  echo "Usage : $0 IpNode NodePassword"
  exit 1
fi

# Get IP Node
ipnode=$1

# Get Node Password
nodepwd=$2

# Install sshpass utility for ssh connection without password prompt
sudo apt-get install sshpass -q -y >/dev/null


####### CONFIGURE NODE #######

echo 'Node ===========================' $ipnode '==========================='

# Remove old IP node in SSH known_hosts
allssh "ssh-keygen -R $ipnode >/dev/null 2>/dev/null"
  
# Add new IP node in SSH known_hosts
allssh "ssh-keyscan -H $ipnode >> ~/.ssh/known_hosts 2>/dev/null"

# Get Node Short Name
namenode=`sshpass -p $nodepwd ssh -t $ipnode 'hostname -s'`

# Remove old Short Name node in SSH known_hosts
allssh "ssh-keygen -R $namenode >/dev/null 2>/dev/null"

# Add new Short Name node in SSH known_hosts
allssh "ssh-keyscan -H $namenode >> ~/.ssh/known_hosts 2>/dev/null"

# Get Node Long Name
fqdnnode=`sshpass -p $nodepwd ssh -t $ipnode 'hostname -f'`

# Remove old Long Name node in SSH known_hosts
allssh "ssh-keygen -R $fqdnnode >/dev/null 2>/dev/null"

# Add new Long Name node in SSH known_hosts
allssh "ssh-keyscan -H $fqdnnode >> ~/.ssh/known_hosts 2>/dev/null"

# Generate RSA Key for SSH Auto Connect
sshpass -p $nodepwd ssh -t $ipnode 'sudo apt-get install sshpass -q -y >/dev/null ; rm -f ~/.ssh/authorized_keys ; rm -f ~/.ssh/id_rsa ; rm -f ~/.ssh/id_rsa.pub ; ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa >/dev/null 2>/dev/null'

# Add Node Autorizations
allssh "ssh-copy-id $ipnode >/dev/null 2>/dev/null"
allssh "ssh-copy-id $namenode >/dev/null 2>/dev/null"
allssh "ssh-copy-id $fqdnnode >/dev/null 2>/dev/null"