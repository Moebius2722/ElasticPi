#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Start Node Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get Service Name

svcname=`basename $0 | cut -d '.' -f 1 | cut -d '-' -f 2`

####### START-SERVICE #######

# Node Service
sudo systemctl is-enabled $svcname.service >/dev/null 2>/dev/null
if [[ ! $? = 0 ]] ; then
  sudo systemctl enable $svcname.service >/dev/null 2>/dev/null
fi

sudo systemctl is-active $svcname.service >/dev/null 2>/dev/null
if [[ ! $? = 0 ]] ; then
  sudo systemctl start $svcname.service >/dev/null 2>/dev/null
fi
