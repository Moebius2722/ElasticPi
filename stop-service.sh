#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Stop Node Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get Service Name

svcname=`basename $0 | cut -d '.' -f 1 | cut -d '-' -f 2`

####### STOP-SERVICE #######

# Node Service
sudo systemctl is-active $svcname.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  sudo systemctl stop $svcname.service >/dev/null 2>/dev/null
fi

sudo systemctl is-enabled $svcname.service >/dev/null 2>/dev/null
if [[ $? = 0 ]] ; then
  sudo systemctl disable $svcname.service >/dev/null 2>/dev/null
fi
