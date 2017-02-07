#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Update Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version ELK
#E_VERSION=5.2.0
E_VERSION=`wget https://www.elastic.co/downloads/elasticsearch/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
#L_VERSION=5.2.0
L_VERSION=`wget https://www.elastic.co/downloads/logstash/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
#K_VERSION=5.2.0
K_VERSION=`wget https://www.elastic.co/downloads/kibana/ -qO- | grep -i "\-i386\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
#N_VERSION=6.9.0
K_MVERSION=`echo $K_VERSION | cut -d . -f 1-2`
N_VERSION=`wget https://raw.githubusercontent.com/elastic/kibana/$K_MVERSION/.node-version -qO-`
#C_VERSION=0.5.0
C_VERSION=`wget https://github.com/lmenezes/cerebro/releases/latest -qO- | grep -i "\.tgz\"" | cut -d '"' -f 2 | cut -d / -f 7 | cut -d - -f 2 | cut -d . -f 1-3`

# Set Pi Updated Flag
export PI_UPDATED=0

####### ELASTICSEARCH #######

./update-elasticsearch.sh


####### LOGSTASH #######

./update-logstash.sh


####### KIBANA #######

./update-kibana.sh


####### CEREBRO #######

./update-cerebro.sh


####### NODERED #######

./update-nodered.sh
