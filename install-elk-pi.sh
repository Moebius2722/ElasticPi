#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Elastic Stack on Raspberry Pi 2 or 3


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

####### KEEPALIVED #######

`dirname $0`/install-keepalived.sh


####### NGINX #######

`dirname $0`/install-nginx.sh


####### ELASTICSEARCH #######

`dirname $0`/install-elasticsearch.sh


####### LOGSTASH #######

`dirname $0`/install-logstash.sh


####### KIBANA #######

`dirname $0`/install-kibana.sh


####### CEREBRO #######

`dirname $0`/install-cerebro.sh


####### NODERED #######

`dirname $0`/install-nodered.sh
