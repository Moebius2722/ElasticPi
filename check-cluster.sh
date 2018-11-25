#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Cluster Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

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
    ses=ok
  elif [[ $ees = 4 ]] ; then
    ses='  '
  else
    ses=KO
  fi
  printf "$ses "
  ssh -t $ipnode check-logstash >/dev/null 2>/dev/null
  els=$?
  if [[ $els = 0 ]] ; then
    sls=ok
  elif [[ $els = 4 ]] ; then
    sls='  '
  else
    sls=KO
  fi
  printf "$sls "
  ssh -t $ipnode check-kibana >/dev/null 2>/dev/null
  ekb=$?
  if [[ $ekb = 0 ]] ; then
    skb=ok
  elif [[ $ekb = 4 ]] ; then
    skb='  '
  else
    skb=KO
  fi
  printf "$skb "
  ssh -t $ipnode check-metricbeat >/dev/null 2>/dev/null
  emb=$?
  if [[ $emb = 0 ]] ; then
    smb=ok
  elif [[ $emb = 4 ]] ; then
    smb='  '
  else
    smb=KO
  fi
  printf "$smb "
  ssh -t $ipnode check-nginx >/dev/null 2>/dev/null
  eng=$?
  if [[ $eng = 0 ]] ; then
    sng=ok
  elif [[ $eng = 4 ]] ; then
    sng='  '
  else
    sng=KO
  fi
  printf "$sng "
  ssh -t $ipnode check-cerebro >/dev/null 2>/dev/null
  ecb=$?
  if [[ $ecb = 0 ]] ; then
    scb=ok
  elif [[ $ecb = 4 ]] ; then
    scb='  '
  else
    scb=KO
  fi
  printf "$scb "
  ssh -t $ipnode check-nodered >/dev/null 2>/dev/null
  enr=$?
  if [[ $enr = 0 ]] ; then
    snr=ok
  elif [[ $enr = 4 ]] ; then
    snr='  '
  else
    snr=KO
  fi
  printf "$snr "
  ssh -t $ipnode check-mosquitto >/dev/null 2>/dev/null
  emq=$?
  if [[ $emq = 0 ]] ; then
    smq=ok
  elif [[ $emq = 4 ]] ; then
    smq='  '
  else
    smq=KO
  fi
  printf "$smq "
  ssh -t $ipnode check-keepalived >/dev/null 2>/dev/null
  eka=$?
  if [[ $eka = 0 ]] ; then
    ska=ok
  elif [[ $eka = 4 ]] ; then
    ska='  '
  else
    ska=KO
  fi
  printf "$ska "
  ssh -t $ipnode check-squid >/dev/null 2>/dev/null
  esq=$?
  if [[ $esq = 0 ]] ; then
    ssq=ok
  elif [[ $esq = 4 ]] ; then
    ssq='  '
  else
    ssq=KO
  fi
  printf "$ssq\n"
done
