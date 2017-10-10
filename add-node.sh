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
allssh "sudo apt-get install sshpass -q -y >/dev/null"


####### CONFIGURE NODE #######
echo '=========================== Add Node ' $ipnode '==========================='

# Remove old IP node in SSH known_hosts
allssh "ssh-keygen -R $ipnode >/dev/null 2>/dev/null"

# Add new IP node in SSH known_hosts
allssh "ssh-keyscan -H $ipnode >> ~/.ssh/known_hosts 2>/dev/null"

# Generate RSA Key for SSH Auto Connect
sshpass -p $nodepwd ssh -t $ipnode 'sudo apt-get install sshpass -q -y >/dev/null ; rm -f ~/.ssh/authorized_keys ; rm -f ~/.ssh/id_rsa ; rm -f ~/.ssh/id_rsa.pub ; ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa >/dev/null 2>/dev/null'

# Add Node Autorizations
allssh "sshpass -p $nodepwd ssh-copy-id $ipnode >/dev/null 2>/dev/null"

# Add Node to Cluster
echo $ipnode | sudo tee -a /etc/elasticpi/nodes.lst >/dev/null 2>/dev/null
scp /etc/elasticpi/nodes.lst $ipnode:/tmp/nodes.lst >/dev/null 2>/dev/null
ssh $ipnode "sudo mkdir /etc/elasticpi && sudo cp /tmp/nodes.lst /etc/elasticpi/nodes.lst && rm /tmp/nodes.lst >/dev/null 2>/dev/null"

# Install Cluster Tools on New Node
scp /opt/elasticpi/install-tools.sh $ipnode:/tmp/install-tools.sh
ssh $ipnode "/bin/bash /tmp/install-tools.sh >/dev/null 2>/dev/null"
