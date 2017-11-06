#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Get Cluster Components Version Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

echo " HOST             ES       LS       KB       NG       CB       NR       MQ       KA"


# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort` )


####### GET-CLUSTER-VERSION #######

# Check Cluster Services

for ipnode in "${ipnodes[@]}"
do
  printf " $ipnode"
  ilen=${#ipnode}
  iend=$((17-ilen))
  printf "%${iend}s"
  ves=`ssh $ipnode get-elasticsearch-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    ses=ok
  else
    ves="N/A"
  fi
  printf $ves
  ilen=${#ves}
  iend=$((9-ilen))
  printf "%${iend}s"
  vls=`ssh $ipnode get-logstash-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    sls=ok
  else
    vls="N/A"
  fi
  printf $vls
  ilen=${#vls}
  iend=$((9-ilen))
  printf "%${iend}s"
  vkb=`ssh $ipnode get-kibana-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    skb=ok
  else
    vkb="N/A"
  fi
  printf $vkb
  ilen=${#vkb}
  iend=$((9-ilen))
  printf "%${iend}s"
  vng=`ssh $ipnode get-nginx-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    sng=ok
  else
    vng="N/A"
  fi
  printf $vng
  ilen=${#vng}
  iend=$((9-ilen))
  printf "%${iend}s"
  vcb=`ssh $ipnode get-cerebro-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    scb=ok
  else
    vcb="N/A"
  fi
  printf $vcb
  ilen=${#vcb}
  iend=$((9-ilen))
  printf "%${iend}s"
  vnr=`ssh $ipnode get-nodered-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    snr=ok
  else
    vnr="N/A"
  fi
  printf $vnr
  ilen=${#vnr}
  iend=$((9-ilen))
  printf "%${iend}s"
  vmq=`ssh $ipnode get-mosquitto-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    smq=ok
  else
    vmq="N/A"
  fi
  printf $vmq
  ilen=${#vmq}
  iend=$((9-ilen))
  printf "%${iend}s"
  vka=`ssh $ipnode get-keepalived-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    ska=ok
  else
    vka="N/A"
  fi
  printf $vka
  printf "\n"
done
printf " Last Version"
ilen=${#ipnode}
iend=$((17-12))
printf "%${iend}s"
ves=`get-elasticsearch-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  ses=ok
else
  ves="N/A"
fi
printf $ves
ilen=${#ves}
iend=$((9-ilen))
printf "%${iend}s"
vls=`get-logstash-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  sls=ok
else
  vls="N/A"
fi
printf $vls
ilen=${#vls}
iend=$((9-ilen))
printf "%${iend}s"
vkb=`get-kibana-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  skb=ok
else
  vkb="N/A"
fi
printf $vkb
ilen=${#vkb}
iend=$((9-ilen))
printf "%${iend}s"
vng=`get-nginx-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  sng=ok
else
  vng="N/A"
fi
printf $vng
ilen=${#vng}
iend=$((9-ilen))
printf "%${iend}s"
vcb=`get-cerebro-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  scb=ok
else
  vcb="N/A"
fi
printf $vcb
ilen=${#vcb}
iend=$((9-ilen))
printf "%${iend}s"
vnr=`get-nodered-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  snr=ok
else
  vnr="N/A"
fi
printf $vnr
ilen=${#vnr}
iend=$((9-ilen))
printf "%${iend}s"
vmq=`get-mosquitto-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  smq=ok
else
  vmq="N/A"
fi
printf $vmq
ilen=${#vmq}
iend=$((9-ilen))
printf "%${iend}s"
vka=`get-keepalived-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  ska=ok
else
  vka="N/A"
fi
printf $vka
printf "\n"
