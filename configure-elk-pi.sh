#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git



####### CONFIGURE ELK PI #######

# Install sshpass utility for ssh connection without password prompt
sudo apt-get install sshpass -y

# Question for new cluster creation or add new node in cluster
echo -n "New Cluster (Y/N)?          : "
while read -r -n 1 -s answer; do
  if [[ $answer = [YyNn] ]]; then
    [[ $answer = [Yy] ]] && NewCluster=0
    [[ $answer = [Nn] ]] && NewCluster=1
    break
  fi
done
echo $answer

# If new cluster creation
if [[ $NewCluster -eq 0 ]]; then
# Set Name of New Cluster
  read -p "Set Cluster Name            : " -r -e ClusterName
else
# If add new node in cluster
  GoodIP=0
  while [[ $GoodIP -eq 0 ]]; do
# Get IP of a node in cluster
    IFS="." read -n 15 -p "IP Existing Node            : " -r -e ExistingNodeIP1 ExistingNodeIP2 ExistingNodeIP3 ExistingNodeIP4
# Ping test of IP
    ping -q -c 1 $ExistingNodeIP1.$ExistingNodeIP2.$ExistingNodeIP3.$ExistingNodeIP4 &>/dev/null
    if [[ $? -eq 0 ]]; then
      GoodIP=1
	else
      echo "Error to ping IP !"
    fi
  done
# Get privates IPs of cluter nodes
  ipnodes=`curl -s $ExistingNodeIP1.$ExistingNodeIP2.$ExistingNodeIP3.$ExistingNodeIP4:9200/_nodes/_all | jq -c '[.nodes[].transport_address]'`
  echo $ipnodes
fi

# Set name of new node
read -p "Set Node Name               : " -r -e NodeName

# Set public IP of new node
IFS="." read -n 15 -p "Set Node Public  IP Address : " -r -e NodePubIP1 NodePubIP2 NodePubIP3 NodePubIP4

# Set private IP of new node
IFS="." read -n 15 -p "Set Node Private IP Address : " -r -e NodePrivIP1 NodePrivIP2 NodePrivIP3 NodePrivIP4

# If new cluster creation
if [[ $NewCluster -eq 0 ]]; then
 GoodPassword=0
  while [[ GoodPassword -eq 0 ]]; do
# Set password of node with verification pass
    read -p "Set Node Password           : " -r -e -s NodePassword
	echo
    read -p "Verify Node Password        : " -r -e -s VerifyNodePassword
	echo
    if [[ $NodePassword = $VerifyNodePassword ]]; then
      GoodPassword=1
	else
	  echo "Passwords mismatch !"
    fi
  done
else
# If add new node in cluster
# Get password of node in cluster
 read -p "Set Nodes Password          : " -r -e -s NodePassword
 echo
fi

if [[ $NewCluster -eq 0 ]]; then
  echo -e "Cluster          : " $ClusterName
else
  echo -e "IP Existing Node : " $ExistingNodeIP1.$ExistingNodeIP2.$ExistingNodeIP3.$ExistingNodeIP4
  ping -q -c 1 $ExistingNodeIP1.$ExistingNodeIP2.$ExistingNodeIP3.$ExistingNodeIP4 &>/dev/null
  if [[ $? -eq 0 ]]; then
    echo "Success to ping Existing Node !"
	sshpass -p $NodePassword ssh pi@$ExistingNodeIP1.$ExistingNodeIP2.$ExistingNodeIP3.$ExistingNodeIP4 date &>/dev/null
	if [[ $? -eq 0 ]]; then
		GoodPassword=1
		echo "Success to connect to Existing Node !"
	else
		GoodPassword=0
		echo "Error to connect to Existing Node !"
	fi
  else
	GoodPassword=0
    echo "Error to ping Existing Node !"
  fi
fi

echo -e "Node               : " $NodeName

echo -e "Public  IP         : " $NodePubIP1.$NodePubIP2.$NodePubIP3.$NodePubIP4

echo -e "Private IP         : " $NodePrivIP1.$NodePrivIP2.$NodePrivIP3.$NodePrivIP4

echo -e "Password           : " $NodePassword

#echo -e "$NodePassword\n$NodePassword" | sudo passwd pi &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "Successful Set Node Password !"
else
  echo "Error to Set Node Password !"
fi

OldNodeName=$(hostname)
for file in \
   /etc/hostname \
   /etc/hosts \
   /etc/ssh/ssh_host_rsa_key.pub \
   /etc/ssh/ssh_host_dsa_key.pub
do
   [ -f $file ] && sudo sed -i.old -e "s:$OldNodeName:$NodeName:g" $file
done
