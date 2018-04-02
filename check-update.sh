#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Update Script for Elastic Stack on Raspberry Pi 2 or 3


####### ELASTICSEARCH #######

# Get Version
E_VERSION=`get-elasticsearch-lastversion`

# Check if already up to date
E_CVERSION=`get-elasticsearch-version`
if [[ "${E_CVERSION}" = "" ]]; then
  echo "Elasticsearch : Not installed"
elif [[ "${E_VERSION}" = "${E_CVERSION}" ]]; then
  echo "Elasticsearch : Up to date '${E_CVERSION}'"
else
  echo "Elasticsearch : New version '${E_CVERSION}' => '${E_VERSION}'"
fi


####### LOGSTASH #######

# Get Version
L_VERSION=`get-logstash-lastversion`

# Check if already up to date
L_CVERSION=`get-logstash-version`
if [[ "${L_CVERSION}" = "" ]]; then
  echo "Logstash : Not installed"
elif [[ "${L_VERSION}" = "${L_CVERSION}" ]]; then
  echo "Logstash : Up to date '${L_CVERSION}'"
else
  echo "Logstash : New version '${L_CVERSION}' => '${L_VERSION}'"
fi


####### KIBANA #######

# Get Version
K_VERSION=`get-kibana-lastversion`

# Check if already up to date
K_CVERSION=`get-kibana-version`
if [[ "${K_CVERSION}" = "" ]]; then
  echo "Kibana : Not installed"
elif [[ "${K_VERSION}" = "${K_CVERSION}" ]]; then
  echo "Kibana : Up to date '${K_CVERSION}'"
else
  echo "Kibana : New version '${K_CVERSION}' => '${K_VERSION}'"
fi


####### METRICBEAT #######

# Get Version
MB_VERSION=`get-metricbeat-lastversion`

# Check if already up to date
MB_CVERSION=`get-metricbeat-version`
if [[ "${MB_CVERSION}" = "" ]]; then
  echo "Metricbeat : Not installed"
elif [[ "${MB_VERSION}" = "${MB_CVERSION}" ]]; then
  echo "Metricbeat : Up to date '${MB_CVERSION}'"
else
  echo "Metricbeat : New version '${MB_CVERSION}' => '${MB_VERSION}'"
fi


####### NGINX #######

# Get Version
NG_VERSION=`get-nginx-lastversion`

# Check if already up to date
NG_CVERSION=`get-nginx-version`
if [[ "${NG_CVERSION}" = "" ]]; then
  echo "Nginx : Not installed"
elif [[ "${NG_VERSION}" = "${NG_CVERSION}" ]]; then
  echo "Nginx : Up to date '${NG_CVERSION}'"
else
  echo "Nginx : New version '${NG_CVERSION}' => '${NG_VERSION}'"
fi


####### CEREBRO #######

# Get Version
C_VERSION=`get-cerebro-lastversion`

# Check if already up to date
C_CVERSION=`get-cerebro-version`
if [[ "${C_CVERSION}" = "" ]]; then
  echo "Cerebro : Not installed"
elif [[ "${C_VERSION}" = "${C_CVERSION}" ]]; then
  echo "Cerebro : Up to date '${C_CVERSION}'"
else
  echo "Cerebro : New version '${C_CVERSION}' => '${C_VERSION}'"
fi


####### NODERED #######

# Get Version
NR_VERSION=`get-nodered-lastversion`

# Check if already up to date
NR_CVERSION=`get-nodered-version`
if [[ "${NR_CVERSION}" = "" ]]; then
  echo "Node-RED : Not installed"
elif [[ "${NR_VERSION}" = "${NR_CVERSION}" ]]; then
  echo "Node-RED : Up to date '${NR_CVERSION}'"
else
  echo "Node-RED : New version '${NR_CVERSION}' => '${NR_VERSION}'"
fi


####### MOSQUITTO #######

# Get Version
MQ_VERSION=`get-mosquitto-lastversion`

# Check if already up to date
MQ_CVERSION=`get-mosquitto-version`
if [[ "${MQ_CVERSION}" = "" ]]; then
  echo "Mosquitto : Not installed"
elif [[ "${MQ_VERSION}" = "${MQ_CVERSION}" ]]; then
  echo "Mosquitto : Up to date '${MQ_CVERSION}'"
else
  echo "Mosquitto : New version '${MQ_CVERSION}' => '${MQ_VERSION}'"
fi


####### KEEPALIVED #######

# Get Version
KA_VERSION=`get-keepalived-lastversion`

# Check if already up to date
KA_CVERSION=`get-keepalived-version`
if [[ "${KA_CVERSION}" = "" ]]; then
  echo "Keepalived : Not installed"
elif [[ "${KA_VERSION}" = "${KA_CVERSION}" ]]; then
  echo "Keepalived : Up to date '${KA_CVERSION}'"
else
  echo "Keepalived : New version '${KA_CVERSION}' => '${KA_VERSION}'"
fi
