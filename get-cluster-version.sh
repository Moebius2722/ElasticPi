#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Get Cluster Components Version Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

echo " HOST             ES LS KB NG CB NR MQ KA"


# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort` )


####### GET-CLUSTER-VERSION #######

# Check Cluster Services

for ipnode in "${ipnodes[@]}"
do
  echo $ipnode
  ves=`ssh -t $ipnode get-elasticsearch-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    ses=ok
  else
    ves="N/A"
  fi
  echo $ves
  vls=`ssh -t $ipnode get-logstash-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    sls=ok
  else
    vls="N/A"
  fi
  echo $vls
  vkb=`ssh -t $ipnode get-kibana-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    skb=ok
  else
    vkb="N/A"
  fi
  echo $vkb
  vng=`ssh -t $ipnode get-nginx-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    sng=ok
  else
    vng="N/A"
  fi
  echo $vng
  vcb=`ssh -t $ipnode get-cerebro-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    scb=ok
  else
    vcb="N/A"
  fi
  echo $vcb
  vnr=`ssh -t $ipnode get-nodered-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    snr=ok
  else
    vnr="N/A"
  fi
  echo $vnr
  vmq=`ssh -t $ipnode get-mosquitto-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    smq=ok
  else
    vmq="N/A"
  fi
  echo $vmq
  vka=`ssh -t $ipnode get-keepalived-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    ska=ok
  else
    vka="N/A"
  fi
  echo $vka
  iipnode=${#ipnode}
  iend=$((15-iipnode))
  send=`printf "%${iend}s"`
  echo " $ipnode$send  $ves $vls $vkb $vng $vcb $vnr $vmq $vka"
done
