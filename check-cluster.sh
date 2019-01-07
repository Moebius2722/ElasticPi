#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######
RED='\033[0;31m' # RED Color
GREEN='\033[0;32m' # GREEN Color
NC='\033[0m'     # No Color
NA=${NA}
KO="${RED}KO${NC}"
OK="${GREEN}ok${NC}"

echo " HOST             ES LS KB MB NG CB NR MQ KA SQ"


# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort -V` )


####### CHECK-CLUSTER #######

# Check Cluster Services

for ipnode in "${ipnodes[@]}"
do
  printf " $ipnode"
  ilen=${#ipnode}
  iend=$((17-ilen))
  printf "%${iend}s"
  ssh -t $ipnode check-elasticsearch >/dev/null 2>/dev/null
  ees=$?
  if [[ $ees = 0 ]] ; then
    ses=${OK}
  elif [[ $ees = 4 ]] ; then
    ses=${NA}
  else
    ses=${KO}
  fi
  printf "$ses "
  ssh -t $ipnode check-logstash >/dev/null 2>/dev/null
  els=$?
  if [[ $els = 0 ]] ; then
    sls=${OK}
  elif [[ $els = 4 ]] ; then
    sls=${NA}
  else
    sls=${KO}
  fi
  printf "$sls "
  ssh -t $ipnode check-kibana >/dev/null 2>/dev/null
  ekb=$?
  if [[ $ekb = 0 ]] ; then
    skb=${OK}
  elif [[ $ekb = 4 ]] ; then
    skb=${NA}
  else
    skb=${KO}
  fi
  printf "$skb "
  ssh -t $ipnode check-metricbeat >/dev/null 2>/dev/null
  emb=$?
  if [[ $emb = 0 ]] ; then
    smb=${OK}
  elif [[ $emb = 4 ]] ; then
    smb=${NA}
  else
    smb=${KO}
  fi
  printf "$smb "
  ssh -t $ipnode check-nginx >/dev/null 2>/dev/null
  eng=$?
  if [[ $eng = 0 ]] ; then
    sng=${OK}
  elif [[ $eng = 4 ]] ; then
    sng=${NA}
  else
    sng=${KO}
  fi
  printf "$sng "
  ssh -t $ipnode check-cerebro >/dev/null 2>/dev/null
  ecb=$?
  if [[ $ecb = 0 ]] ; then
    scb=${OK}
  elif [[ $ecb = 4 ]] ; then
    scb=${NA}
  else
    scb=${KO}
  fi
  printf "$scb "
  ssh -t $ipnode check-nodered >/dev/null 2>/dev/null
  enr=$?
  if [[ $enr = 0 ]] ; then
    snr=${OK}
  elif [[ $enr = 4 ]] ; then
    snr=${NA}
  else
    snr=${KO}
  fi
  printf "$snr "
  ssh -t $ipnode check-mosquitto >/dev/null 2>/dev/null
  emq=$?
  if [[ $emq = 0 ]] ; then
    smq=${OK}
  elif [[ $emq = 4 ]] ; then
    smq=${NA}
  else
    smq=${KO}
  fi
  printf "$smq "
  ssh -t $ipnode check-keepalived >/dev/null 2>/dev/null
  eka=$?
  if [[ $eka = 0 ]] ; then
    ska=${OK}
  elif [[ $eka = 4 ]] ; then
    ska=${NA}
  else
    ska=${KO}
  fi
  printf "$ska "
  ssh -t $ipnode check-squid >/dev/null 2>/dev/null
  esq=$?
  if [[ $esq = 0 ]] ; then
    ssq=${OK}
  elif [[ $esq = 4 ]] ; then
    ssq=${NA}
  else
    ssq=${KO}
  fi
  printf "$ssq\n"
done
