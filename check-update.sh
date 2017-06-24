#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Update Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version ELK
E_VERSION=`wget https://www.elastic.co/downloads/elasticsearch/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3 | head -n 1`
L_VERSION=`wget https://www.elastic.co/downloads/logstash/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3 | head -n 1`
K_VERSION=`wget https://www.elastic.co/downloads/kibana/ -qO- | grep -i "\-i386\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3 | head -n 1`
K_MVERSION=`echo $K_VERSION | cut -d . -f 1-2`
NGX_VERSION=`wget http://nginx.org/en/download.html -qO- | sed 's/>/>\n/g' | grep -i 'tar.gz"' | sort -V -r | head -1 | cut -d '"' -f 2 | cut -d / -f 3 | cut -d - -f 2 | cut -d . -f 1-3`
N_VERSION=`wget https://raw.githubusercontent.com/elastic/kibana/$K_MVERSION/.node-version -qO-`
C_VERSION=`wget https://github.com/lmenezes/cerebro/releases/latest -qO- | grep -i "\.tgz\"" | cut -d '"' -f 2 | cut -d / -f 7 | cut -d - -f 2 | cut -d . -f 1-3`
NR_VERSION=`npm info node-red version`


####### ELASTICSEARCH #######

# Check if already up to date
E_CVERSION=`dpkg-query -W -f='${Version}\n' elasticsearch`
if [[ "${E_VERSION}" = "${E_CVERSION}" ]]; then
  echo "Elasticsearch : Up to date '${E_CVERSION}'"
else
  echo "Elasticsearch : New version '${E_CVERSION}' => '${E_VERSION}'"
fi


####### LOGSTASH #######

# Check if already up to date
L_CVERSION=`dpkg-query -W -f='${Version}\n' logstash | cut -d : -f2 | cut -d - -f1`
if [[ "${L_VERSION}" = "${L_CVERSION}" ]]; then
  echo "Logstash : Up to date '${L_CVERSION}'"
else
  echo "Logstash : New version '${L_CVERSION}' => '${L_VERSION}'"
fi


####### KIBANA #######

# Check if already up to date
K_CVERSION=`dpkg-query -W -f='${Version}\n' kibana`
if [[ "${K_VERSION}" = "${K_CVERSION}" ]]; then
  echo "Kibana : Up to date '${K_CVERSION}'"
else
  echo "Kibana : New version '${K_CVERSION}' => '${K_VERSION}'"
fi


####### NGINX #######

# Check if already up to date
NGX_CVERSION=`/usr/sbin/nginx -v 2>&1 | cut -d / -f 2`
if [[ "${NGX_VERSION}" = "${NGX_CVERSION}" ]]; then
  echo "Nginx : Up to date '${NGX_CVERSION}'"
else
  echo "Nginx : New version '${NGX_CVERSION}' => '${NGX_VERSION}'"
fi


####### CEREBRO #######

# Check if already up to date
C_CVERSION=`ls /usr/share/cerebro/lib/cerebro.cerebro-*-assets.jar | cut -d - -f2`
if [[ "${C_VERSION}" = "${C_CVERSION}" ]]; then
  echo "Cerebro : Up to date '${C_CVERSION}'"
else
  echo "Cerebro : New version '${C_CVERSION}' => '${C_VERSION}'"
fi


####### NODERED #######

# Check if already up to date
NR_CVERSION=`npm -g ls --depth=0 node-red | grep -i node-red | cut -d @ -f2 | cut -d ' ' -f1`
if [[ "${NR_VERSION}" = "${NR_CVERSION}" ]]; then
  echo "Node-RED : Up to date '${NR_CVERSION}'"
else
  echo "Node-RED : New version '${NR_CVERSION}' => '${NR_VERSION}'"
fi
