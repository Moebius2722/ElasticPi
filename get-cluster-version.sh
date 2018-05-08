#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Get Cluster Components Version Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

echo " HOST             ES       LS       KB       MB       NG       CB       NR       MQ       KA       SQ"


# Get IP Nodes
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$' | sort -V` )


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
    ves="$ves"
  else
    ves="N/A"
  fi
  printf $ves
  ilen=${#ves}
  iend=$((9-ilen))
  printf "%${iend}s"
  vls=`ssh $ipnode get-logstash-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    vls="$vls"
  else
    vls="N/A"
  fi
  printf $vls
  ilen=${#vls}
  iend=$((9-ilen))
  printf "%${iend}s"
  vkb=`ssh $ipnode get-kibana-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    vkb="$vkb"
  else
    vkb="N/A"
  fi
  printf $vkb
  ilen=${#vkb}
  iend=$((9-ilen))
  printf "%${iend}s"
  vmb=`ssh $ipnode get-metricbeat-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    vmb="$vmb"
  else
    vmb="N/A"
  fi
  printf $vmb
  ilen=${#vmb}
  iend=$((9-ilen))
  printf "%${iend}s"
  vng=`ssh $ipnode get-nginx-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    vng="$vng"
  else
    vng="N/A"
  fi
  printf $vng
  ilen=${#vng}
  iend=$((9-ilen))
  printf "%${iend}s"
  vcb=`ssh $ipnode get-cerebro-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    vcb="$vcb"
  else
    vcb="N/A"
  fi
  printf $vcb
  ilen=${#vcb}
  iend=$((9-ilen))
  printf "%${iend}s"
  vnr=`ssh $ipnode get-nodered-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    vnr="$vnr"
  else
    vnr="N/A"
  fi
  printf $vnr
  ilen=${#vnr}
  iend=$((9-ilen))
  printf "%${iend}s"
  vmq=`ssh $ipnode get-mosquitto-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    vmq="$vmq"
  else
    vmq="N/A"
  fi
  printf $vmq
  ilen=${#vmq}
  iend=$((9-ilen))
  printf "%${iend}s"
  vka=`ssh $ipnode get-keepalived-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    vka="$vka"
  else
    vka="N/A"
  fi
  printf $vka
  ilen=${#vka}
  iend=$((9-ilen))
  printf "%${iend}s"
  vsq=`ssh $ipnode get-squid-version 2>/dev/null`
  if [[ $? = 0 ]] ; then
    vsq="$vsq"
  else
    vsq="N/A"
  fi
  printf $vsq
  printf "\n"
done
printf " Last Version"
iend=$((17-12))
printf "%${iend}s"
ves=`get-elasticsearch-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  ves="$ves"
else
  ves="N/A"
fi
printf $ves
ilen=${#ves}
iend=$((9-ilen))
printf "%${iend}s"
vls=`get-logstash-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  vls="$vls"
else
  vls="N/A"
fi
printf $vls
ilen=${#vls}
iend=$((9-ilen))
printf "%${iend}s"
vkb=`get-kibana-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  vkb="$vkb"
else
  vkb="N/A"
fi
printf $vkb
ilen=${#vkb}
iend=$((9-ilen))
printf "%${iend}s"
vmb=`get-metricbeat-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  vmb="$vmb"
else
  vmb="N/A"
fi
printf $vmb
ilen=${#vmb}
iend=$((9-ilen))
printf "%${iend}s"
vng=`get-nginx-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  vng="$vng"
else
  vng="N/A"
fi
printf $vng
ilen=${#vng}
iend=$((9-ilen))
printf "%${iend}s"
vcb=`get-cerebro-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  vcb="$vcb"
else
  vcb="N/A"
fi
printf $vcb
ilen=${#vcb}
iend=$((9-ilen))
printf "%${iend}s"
vnr=`get-nodered-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  vnr="$vnr"
else
  vnr="N/A"
fi
printf $vnr
ilen=${#vnr}
iend=$((9-ilen))
printf "%${iend}s"
vmq=`get-mosquitto-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  vmq="$vmq"
else
  vmq="N/A"
fi
printf $vmq
ilen=${#vmq}
iend=$((9-ilen))
printf "%${iend}s"
vka=`get-keepalived-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  vka="$vka"
else
  vka="N/A"
fi
printf $vka
ilen=${#vka}
iend=$((9-ilen))
printf "%${iend}s"
vsq=`get-squid-lastversion 2>/dev/null`
if [[ $? = 0 ]] ; then
  vsq="$vsq"
else
  vsq="N/A"
fi
printf $vsq
printf "\n"
