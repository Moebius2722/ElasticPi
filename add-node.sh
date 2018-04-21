#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Add New Node in Cluster Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 3 ]] ; then
  echo "Usage : $0 IpNewNode VIpNewNode NodePassword"
  exit 1
fi

# Get IP Node
ipnewnode=$1

# Check if script is run on new node
if ip addr | grep -q -c "$ipnewnode/"; then
  echo "Script must be launch on cluster member."
  exit 2
fi

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before add New Node"
  exit 3
fi

# Check if node is already member of cluster
if grep -c $ipnewnode /etc/elasticpi/nodes.lst >/dev/null 2>/dev/null; then
    echo "Node $ipnewnode is already member of cluster."
	exit 4
fi

# Get VIP Node
vipnewnode=$2

# Check if VIP is already declared in cluster
if grep -c $vipnewnode /etc/elasticpi/vip.lst >/dev/null 2>/dev/null; then
    echo "VIP $vipnewnode is already declared in cluster."
	exit 5
fi

# Get Node Password
nodepwd=$3

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
sshpass -p $nodepwd ssh $ipnewnode sudo apt-get install openssh-client -y
sshpass -p $nodepwd ssh $ipnewnode mkdir ~/.ssh
sshpass -p $nodepwd scp ~/.ssh/id_rsa $ipnewnode:~/.ssh/id_rsa
sshpass -p $nodepwd scp ~/.ssh/id_rsa.pub $ipnewnode:~/.ssh/id_rsa.pub
sshpass -p $nodepwd scp ~/.ssh/authorized_keys $ipnewnode:~/.ssh/authorized_keys
sshpass -p $nodepwd scp ~/.ssh/known_hosts $ipnewnode:~/.ssh/known_hosts

# Add Node to Cluster
namenewnode=`ssh $ipnewnode hostname -s`
fqdnnewnode=`ssh $ipnewnode hostname`
allssh "echo -e $ipnewnode\\\t$fqdnnewnode $namenewnode | sudo tee -a /etc/hosts >/dev/null 2>/dev/null"
scp /etc/hosts $ipnewnode:/tmp/hosts >/dev/null 2>/dev/null
ssh $ipnewnode "sudo cp /tmp/hosts /etc/hosts && rm /tmp/hosts >/dev/null 2>/dev/null"
allssh "echo $vipnewnode $ipnewnode | sudo tee -a /etc/elasticpi/vip.lst >/dev/null 2>/dev/null"
scp /etc/elasticpi/cluster.vip $ipnewnode:/tmp/cluster.vip >/dev/null 2>/dev/null
ssh $ipnewnode "sudo mkdir /etc/elasticpi ; sudo cp -f /tmp/cluster.vip /etc/elasticpi/cluster.vip && rm -f /tmp/cluster.vip >/dev/null 2>/dev/null"
scp /etc/elasticpi/vip.lst $ipnewnode:/tmp/vip.lst >/dev/null 2>/dev/null
ssh $ipnewnode "sudo cp -f /tmp/vip.lst /etc/elasticpi/vip.lst && rm -f /tmp/vip.lst >/dev/null 2>/dev/null"
allssh "echo $ipnewnode | sudo tee -a /etc/elasticpi/nodes.lst >/dev/null 2>/dev/null"
scp /etc/elasticpi/nodes.lst $ipnewnode:/tmp/nodes.lst >/dev/null 2>/dev/null
ssh $ipnewnode "sudo cp -f /tmp/nodes.lst /etc/elasticpi/nodes.lst && rm -f /tmp/nodes.lst >/dev/null 2>/dev/null"

# Add SSL Certificate # >/dev/null 2>/dev/null
sudo cp -rf /etc/elasticpi/ssl /tmp/. >/dev/null 2>/dev/null
sudo chmod a+r /tmp/ssl/*.key >/dev/null 2>/dev/null
scp -r /tmp/ssl $ipnewnode:/tmp/. >/dev/null 2>/dev/null
sudo rm -rf /tmp/ssl >/dev/null 2>/dev/null
ssh $ipnewnode "sudo chmod u=rw,g=-,o=- /tmp/ssl/*.key && sudo cp -rf /tmp/ssl /etc/elasticpi/. ; sudo rm -rf /tmp/ssl >/dev/null 2>/dev/null"

# Install Cluster Tools on New Node
ssh $ipnewnode "update-tools >/dev/null 2>/dev/null"
scp /opt/elasticpi/install-tools.sh $ipnewnode:/tmp/install-tools.sh
ssh $ipnewnode "/bin/bash /tmp/install-tools.sh ; rm /tmp/install-tools.sh >/dev/null 2>/dev/null"

# Disable IPv6
ssh $ipnewnode "echo net.ipv6.conf.all.disable_ipv6=1 | sudo tee /etc/sysctl.d/97-disableipv6.conf"
ssh $ipnewnode "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1"

# Update System
ssh $ipnewnode "update-system"

# Create Repo
ssh $ipnewnode create-repo

# Install Keepalived
ssh $ipnewnode install-keepalived

# Install Nginx
ssh $ipnewnode install-nginx

# Reconfigure Keepalived
allssh reconfigure-keepalived

# Reconfigure Nginx
allssh reconfigure-nginx

# Reconfigure Elasticsearch
allssh reconfigure-elasticsearch
