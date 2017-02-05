#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Check Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# echo " HOST             ES LS KB NG CB NR MQ "
# echo " 192.168.123.456

# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticsearch/discovery-file/unicast_hosts.txt | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort` )


####### CHECK-CLUSTER #######

# Check Cluster Services

for ipnode in "${ipnodes[@]}"
do
  ssh $ipnode sudo systemctl status elasticsearch.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    ses=OK
  else
    ses=KO
  fi
  ssh $ipnode sudo systemctl status logstash.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    sls=OK
  else
    sls=KO
  fi
  ssh $ipnode sudo systemctl status kibana.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    skb=OK
  else
    skb=KO
  fi
  ssh $ipnode sudo systemctl status nginx.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    sng=OK
  else
    sng=KO
  fi
  ssh $ipnode sudo systemctl status cerebro.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    scb=OK
  else
    scb=KO
  fi
  ssh $ipnode sudo systemctl status nodered.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    snr=OK
  else
    snr=KO
  fi
  ssh $ipnode sudo systemctl status mosquitto.service >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    smq=OK
  else
    smq=KO
  fi
  echo "$ipnode $ses $sls $skb $sng $cb $nr $mq"
done
