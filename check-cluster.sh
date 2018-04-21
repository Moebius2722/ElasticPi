#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

echo " HOST             ES LS KB MB NG CB NR MQ KA SQ"


# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort` )


####### CHECK-CLUSTER #######

# Check Cluster Services

for ipnode in "${ipnodes[@]}"
do
  printf " $ipnode"
  ilen=${#ipnode}
  iend=$((17-ilen))
  printf "%${iend}s"
  ssh -t $ipnode check-elasticsearch >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    ses=ok
  else
    ses=KO
  fi
  printf "$ses "
  ssh -t $ipnode check-logstash >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    sls=ok
  else
    sls=KO
  fi
  printf "$sls "
  ssh -t $ipnode check-kibana >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    skb=ok
  else
    skb=KO
  fi
  printf "$skb "
  ssh -t $ipnode check-metricbeat >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    smb=ok
  else
    smb=KO
  fi
  printf "$smb "
  ssh -t $ipnode check-nginx >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    sng=ok
  else
    sng=KO
  fi
  printf "$sng "
  ssh -t $ipnode check-cerebro >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    scb=ok
  else
    scb=KO
  fi
  printf "$scb "
  ssh -t $ipnode check-nodered >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    snr=ok
  else
    snr=KO
  fi
  printf "$snr "
  ssh -t $ipnode check-mosquitto >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    smq=ok
  else
    smq=KO
  fi
  printf "$smq "
  ssh -t $ipnode check-keepalived >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    ska=ok
  else
    ska=KO
  fi
  printf "$ska "
  ssh -t $ipnode check-squid >/dev/null 2>/dev/null
  if [[ $? = 0 ]] ; then
    ssq=ok
  else
    ssq=KO
  fi
  printf "$ssq\n"
done
