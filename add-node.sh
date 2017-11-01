#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Add New Node in Cluster Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 2 ]] ; then
  echo "Usage : $0 IpNewNode NodePassword"
  exit 1
fi

# Get IP Node
ipnewnode=$1

# Get Node Password
nodepwd=$2

# Install sshpass utility for ssh connection without password prompt
allssh "sudo apt-get install sshpass -q -y >/dev/null"


####### CONFIGURE NODE #######
echo '=========================== Add Node ' $ipnewnode '==========================='

# Remove old IP node in SSH known_hosts
allssh "ssh-keygen -R $ipnewnode >/dev/null 2>/dev/null"

# Add new IP node in SSH known_hosts
allssh "ssh-keyscan -H $ipnewnode >> ~/.ssh/known_hosts 2>/dev/null"

# Generate RSA Key for SSH Auto Connect
#sshpass -p $nodepwd ssh -t $ipnewnode 'sudo apt-get install sshpass -q -y >/dev/null ; rm -f ~/.ssh/authorized_keys ; rm -f ~/.ssh/id_rsa ; rm -f ~/.ssh/id_rsa.pub ; ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa >/dev/null 2>/dev/null'

# Add Node Autorizations
#allssh "sshpass -p $nodepwd ssh-copy-id -f $ipnewnode >/dev/null 2>/dev/null"
#ssh $ipnewnode "ssh-keygen -R $ipnewnode >/dev/null 2>/dev/null"
#ssh $ipnewnode "ssh-keyscan -H $ipnewnode >> ~/.ssh/known_hosts 2>/dev/null"
#ssh $ipnewnode "sshpass -p $nodepwd ssh-copy-id -f $ipnewnode >/dev/null 2>/dev/null"
sshpass -p $nodepwd scp ~/.ssh/id_rsa 192.168.0.23:~/.ssh/id_rsa
sshpass -p $nodepwd scp ~/.ssh/id_rsa.pub 192.168.0.23:~/.ssh/id_rsa.pub
sshpass -p $nodepwd scp ~/.ssh/authorized_keys  192.168.0.23:~/.ssh/authorized_keys
sshpass -p $nodepwd scp ~/.ssh/known_hosts  192.168.0.23:~/.ssh/known_hosts

# Add Node to Cluster
allssh "echo $ipnewnode | sudo tee -a /etc/elasticpi/nodes.lst >/dev/null 2>/dev/null"
namenewnode=`ssh 192.168.0.23 hostname -s`
fqdnnewnode=`ssh 192.168.0.23 hostname`
allssh "echo -e $ipnewnode\\\t$namenewnode $fqdnnewnode | sudo tee -a /etc/hosts >/dev/null 2>/dev/null"
scp /etc/elasticpi/nodes.lst $ipnewnode:/tmp/nodes.lst >/dev/null 2>/dev/null
ssh $ipnewnode "sudo mkdir /etc/elasticpi && sudo cp /tmp/nodes.lst /etc/elasticpi/nodes.lst && rm /tmp/nodes.lst >/dev/null 2>/dev/null"
scp /etc/hosts $ipnewnode:/tmp/hosts >/dev/null 2>/dev/null
ssh $ipnewnode "sudo cp /tmp/hosts /etc/hosts && rm /tmp/hosts >/dev/null 2>/dev/null"

# Install Cluster Tools on New Node
scp /opt/elasticpi/install-tools.sh $ipnewnode:/tmp/install-tools.sh
ssh $ipnewnode "/bin/bash /tmp/install-tools.sh ; rm /tmp/install-tools.sh >/dev/null 2>/dev/null"
