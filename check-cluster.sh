#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

echo " HOST             ES LS KB NG CB NR MQ KA"


# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticsearch/discovery-file/unicast_hosts.txt | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort` )


####### CHECK-CLUSTER #######

# Check Cluster Services

for ipnode in "${ipnodes[@]}"
do
  ssh -t $ipnode check-elasticsearch
  if [[ $? = 0 ]] ; then
    ses=ok
  else
    ses=KO
  fi
  ssh -t $ipnode check-logstash
  if [[ $? = 0 ]] ; then
    sls=ok
  else
    sls=KO
  fi
  ssh -t $ipnode check-kibana
  if [[ $? = 0 ]] ; then
    skb=ok
  else
    skb=KO
  fi
  ssh -t $ipnode check-nginx
  if [[ $? = 0 ]] ; then
    sng=ok
  else
    sng=KO
  fi
  ssh -t $ipnode check-cerebro
  if [[ $? = 0 ]] ; then
    scb=ok
  else
    scb=KO
  fi
  ssh -t $ipnode check-nodered
  if [[ $? = 0 ]] ; then
    snr=ok
  else
    snr=KO
  fi
  ssh -t $ipnode check-mosquitto
  if [[ $? = 0 ]] ; then
    smq=ok
  else
    smq=KO
  fi
  ssh -t $ipnode check-keepalived
  if [[ $? = 0 ]] ; then
    ska=ok
  else
    ska=KO
  fi
  iipnode=${#ipnode}
  iend=$((15-iipnode))
  send=`printf "%${iend}s"`
  echo " $ipnode$send  $ses $sls $skb $sng $scb $snr $smq $ska"
done
