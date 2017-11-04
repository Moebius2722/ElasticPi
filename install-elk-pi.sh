#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before install Elastic Stack"
  exit 1
fi

# Set Version ELK
E_VERSION=`wget https://www.elastic.co/downloads/elasticsearch/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
L_VERSION=`wget https://www.elastic.co/downloads/logstash/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
K_VERSION=`wget https://www.elastic.co/downloads/kibana/ -qO- | grep -i "\-i386\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3`
K_MVERSION=`echo $K_VERSION | cut -d . -f 1-2`
N_VERSION=`wget https://raw.githubusercontent.com/elastic/kibana/$K_MVERSION/.node-version -qO-`
C_VERSION=`wget https://github.com/lmenezes/cerebro/releases/latest -qO- | grep -i "\.tgz\"" | cut -d '"' -f 2 | cut -d / -f 7 | cut -d - -f 2 | cut -d . -f 1-3`

# Set Pi Updated Flag
export PI_UPDATED=0

####### KEEPALIVED #######

/opt/elasticpi/install-keepalived.sh


####### NGINX #######

/opt/elasticpi/install-nginx.sh


####### ELASTICSEARCH #######

/opt/elasticpi/install-elasticsearch.sh


####### LOGSTASH #######

/opt/elasticpi/install-logstash.sh


####### KIBANA #######

/opt/elasticpi/install-kibana.sh


####### CEREBRO #######

/opt/elasticpi/install-cerebro.sh


####### NODERED #######

/opt/elasticpi/install-nodered.sh
