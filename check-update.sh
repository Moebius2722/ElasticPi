#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Update Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version ELK
E_VERSION=`get-elasticsearch-lastversion`
L_VERSION=`get-logstash-lastversion`
K_VERSION=`get-kibana-lastversion`
K_MVERSION=`echo $K_VERSION | cut -d . -f 1-2`
NGX_VERSION=`get-nginx-lastversion`
N_VERSION=`wget https://raw.githubusercontent.com/elastic/kibana/$K_MVERSION/.node-version -qO-`
C_VERSION=`get-cerebro-lastversion`
NR_VERSION=`get-nodered-lastversion`


####### ELASTICSEARCH #######

# Check if already up to date
E_CVERSION=`get-elasticsearch-version`
if [[ "${E_VERSION}" = "${E_CVERSION}" ]]; then
  echo "Elasticsearch : Up to date '${E_CVERSION}'"
else
  echo "Elasticsearch : New version '${E_CVERSION}' => '${E_VERSION}'"
fi


####### LOGSTASH #######

# Check if already up to date
L_CVERSION=`get-logstash-version`
if [[ "${L_VERSION}" = "${L_CVERSION}" ]]; then
  echo "Logstash : Up to date '${L_CVERSION}'"
else
  echo "Logstash : New version '${L_CVERSION}' => '${L_VERSION}'"
fi


####### KIBANA #######

# Check if already up to date
K_CVERSION=`get-kibana-version`
if [[ "${K_VERSION}" = "${K_CVERSION}" ]]; then
  echo "Kibana : Up to date '${K_CVERSION}'"
else
  echo "Kibana : New version '${K_CVERSION}' => '${K_VERSION}'"
fi


####### NGINX #######

# Check if already up to date
NGX_CVERSION=`get-nginx-version`
if [[ "${NGX_VERSION}" = "${NGX_CVERSION}" ]]; then
  echo "Nginx : Up to date '${NGX_CVERSION}'"
else
  echo "Nginx : New version '${NGX_CVERSION}' => '${NGX_VERSION}'"
fi


####### CEREBRO #######

# Check if already up to date
C_CVERSION=`get-cerebro-version`
if [[ "${C_VERSION}" = "${C_CVERSION}" ]]; then
  echo "Cerebro : Up to date '${C_CVERSION}'"
else
  echo "Cerebro : New version '${C_CVERSION}' => '${C_VERSION}'"
fi


####### NODERED #######

# Check if already up to date
NR_CVERSION=`get-nodered-version`
if [[ "${NR_VERSION}" = "${NR_CVERSION}" ]]; then
  echo "Node-RED : Up to date '${NR_CVERSION}'"
else
  echo "Node-RED : New version '${NR_CVERSION}' => '${NR_VERSION}'"
fi
