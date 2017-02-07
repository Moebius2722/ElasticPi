#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Update Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version ELK
E_VERSION=`wget https://www.elastic.co/downloads/elasticsearch/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
L_VERSION=`wget https://www.elastic.co/downloads/logstash/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
K_VERSION=`wget https://www.elastic.co/downloads/kibana/ -qO- | grep -i "\-i386\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
K_MVERSION=`echo $K_VERSION | cut -d . -f 1-2`
N_VERSION=`wget https://raw.githubusercontent.com/elastic/kibana/$K_MVERSION/.node-version -qO-`
C_VERSION=`wget https://github.com/lmenezes/cerebro/releases/latest -qO- | grep -i "\.tgz\"" | cut -d '"' -f 2 | cut -d / -f 7 | cut -d - -f 2 | cut -d . -f 1-3`

# Set Pi Updated Flag
export PI_UPDATED=0

####### ELASTICSEARCH #######

`dirname $0`/update-elasticsearch.sh


####### LOGSTASH #######

`dirname $0`/update-logstash.sh


####### KIBANA #######

`dirname $0`/update-kibana.sh


####### CEREBRO #######

`dirname $0`/update-cerebro.sh


####### NODERED #######

`dirname $0`/update-nodered.sh

# Full System Update
if [[ ! "${PI_UPDATED}" = 1 ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi
