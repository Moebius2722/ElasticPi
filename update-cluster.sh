#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version ELK
E_VERSION=`wget https://www.elastic.co/downloads/elasticsearch/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
L_VERSION=`wget https://www.elastic.co/downloads/logstash/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
K_VERSION=`wget https://www.elastic.co/downloads/kibana/ -qO- | grep -i "\-i386\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
K_MVERSION=`echo $K_VERSION | cut -d . -f 1-2`
NGX_VERSION=`wget http://nginx.org/en/download.html -qO- | sed 's/>/>\n/g' | grep -i 'tar.gz"' | sort -V -r | head -1 | cut -d '"' -f 2 | cut -d / -f 3 | cut -d - -f 2 | cut -d . -f 1-3`
N_VERSION=`wget https://raw.githubusercontent.com/elastic/kibana/$K_MVERSION/.node-version -qO-`
C_VERSION=`wget https://github.com/lmenezes/cerebro/releases/latest -qO- | grep -i "\.tgz\"" | cut -d '"' -f 2 | cut -d / -f 7 | cut -d - -f 2 | cut -d . -f 1-3`
NR_VERSION=`npm info node-red version`

# Set Pi Updated Flag
export PI_UPDATED=0


####### ELASTICSEARCH #######

echo "================================= Elasticsearch ================================"
allssh `dirname $0`/update-elasticsearch.sh


####### LOGSTASH #######

echo "=================================== Logstash ==================================="
allssh `dirname $0`/update-logstash.sh


####### KIBANA #######

echo "==================================== Kibana ===================================="
allssh `dirname $0`/update-kibana.sh


####### NGINX #######

echo "===================================== Nginx ===================================="
allssh `dirname $0`/update-nginx.sh


####### CEREBRO #######

echo "==================================== Cerebro ==================================="
allssh `dirname $0`/update-cerebro.sh


####### NODERED #######

echo "=================================== Node-RED ==================================="
allssh `dirname $0`/update-nodered.sh


####### FULL SYSTEM UPDATE #######

if [[ ! "${PI_UPDATED}" = 1 ]]; then
  echo "================================= System Update ================================"
  allssh 'sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update'
fi

