#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Check Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

echo " HOST             ES LS KB NG CB NR MQ "


# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticsearch/discovery-file/unicast_hosts.txt | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort` )


####### CHECK-CLUSTER #######

# Check Cluster Services

for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    ses=ok
  else
    ses=KO
  fi
  ssh $ipnode sudo systemctl status logstash.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    sls=ok
  else
    sls=KO
  fi
  ssh $ipnode sudo systemctl status kibana.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    skb=ok
  else
    skb=KO
  fi
  ssh $ipnode sudo systemctl status nginx.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    sng=ok
  else
    sng=KO
  fi
  ssh $ipnode sudo systemctl status cerebro.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    scb=ok
  else
    scb=KO
  fi
  ssh $ipnode sudo systemctl status nodered.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    snr=ok
  else
    snr=KO
  fi
  ssh $ipnode sudo systemctl status mosquitto.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    smq=ok
  else
    smq=KO
  fi
  iipnode=${#ipnode}
  iend=$((15-iipnode))
  send=`printf "%${iend}s"`
  echo " $ipnode$send  $ses $sls $skb $sng $scb $snr $smq"
done
