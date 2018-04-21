#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Update Script for Elastic Stack on Raspberry Pi 2 or 3


####### ELASTICSEARCH #######

# Get Current Version
E_CVERSION=`get-elasticsearch-version 2>/dev/null`
if [[ "${E_CVERSION}" = "" ]]; then
  echo "Elasticsearch : Not installed"
else
  # Get Last Version
  E_VERSION=`get-elasticsearch-lastversion 2>/dev/null`

  # Check if already up to date
  if [[ "${E_VERSION}" = "${E_CVERSION}" ]]; then
    echo "Elasticsearch : Up to date '${E_CVERSION}'"
  else
    echo "Elasticsearch : New version '${E_CVERSION}' => '${E_VERSION}'"
  fi
fi


####### LOGSTASH #######

# Get Current Version
L_CVERSION=`get-logstash-version 2>/dev/null`
if [[ "${L_CVERSION}" = "" ]]; then
  echo "Logstash : Not installed"
else
  # Get Last Version
  L_VERSION=`get-logstash-lastversion 2>/dev/null`

  # Check if already up to date
  if [[ "${L_VERSION}" = "${L_CVERSION}" ]]; then
    echo "Logstash : Up to date '${L_CVERSION}'"
  else
    echo "Logstash : New version '${L_CVERSION}' => '${L_VERSION}'"
  fi
fi


####### KIBANA #######

# Get Current Version
K_CVERSION=`get-kibana-version 2>/dev/null`
if [[ "${K_CVERSION}" = "" ]]; then
  echo "Kibana : Not installed"
else
  # Get Last Version
  K_VERSION=`get-kibana-lastversion 2>/dev/null`

  # Check if already up to date
  if [[ "${K_VERSION}" = "${K_CVERSION}" ]]; then
    echo "Kibana : Up to date '${K_CVERSION}'"
  else
    echo "Kibana : New version '${K_CVERSION}' => '${K_VERSION}'"
  fi
fi


####### METRICBEAT #######

# Get Current Version
MB_CVERSION=`get-metricbeat-version 2>/dev/null`
if [[ "${MB_CVERSION}" = "" ]]; then
  echo "Metricbeat : Not installed"
else
  # Get Last Version
  MB_VERSION=`get-metricbeat-lastversion 2>/dev/null`

  # Check if already up to date
  if [[ "${MB_VERSION}" = "${MB_CVERSION}" ]]; then
    echo "Metricbeat : Up to date '${MB_CVERSION}'"
  else
    echo "Metricbeat : New version '${MB_CVERSION}' => '${MB_VERSION}'"
  fi
fi


####### NGINX #######

# Get Current Version
NG_CVERSION=`get-nginx-version 2>/dev/null`
if [[ "${NG_CVERSION}" = "" ]]; then
  echo "Nginx : Not installed"
else
  # Get Last Version
  NG_VERSION=`get-nginx-lastversion 2>/dev/null`

  # Check if already up to date
  if [[ "${NG_VERSION}" = "${NG_CVERSION}" ]]; then
    echo "Nginx : Up to date '${NG_CVERSION}'"
  else
    echo "Nginx : New version '${NG_CVERSION}' => '${NG_VERSION}'"
  fi
fi


####### CEREBRO #######

# Get Current Version
C_CVERSION=`get-cerebro-version 2>/dev/null`
if [[ "${C_CVERSION}" = "" ]]; then
  echo "Cerebro : Not installed"
else
  # Get Last Version
  C_VERSION=`get-cerebro-lastversion 2>/dev/null`

  # Check if already up to date
  if [[ "${C_VERSION}" = "${C_CVERSION}" ]]; then
    echo "Cerebro : Up to date '${C_CVERSION}'"
  else
    echo "Cerebro : New version '${C_CVERSION}' => '${C_VERSION}'"
  fi
fi


####### NODERED #######

# Get Current Version
NR_CVERSION=`get-nodered-version 2>/dev/null`
if [[ "${NR_CVERSION}" = "" ]]; then
  echo "Node-RED : Not installed"
else
  # Get Last Version
  NR_VERSION=`get-nodered-lastversion 2>/dev/null`

  # Check if already up to date
  if [[ "${NR_VERSION}" = "${NR_CVERSION}" ]]; then
    echo "Node-RED : Up to date '${NR_CVERSION}'"
  else
    echo "Node-RED : New version '${NR_CVERSION}' => '${NR_VERSION}'"
  fi
fi


####### MOSQUITTO #######

# Get Current Version
MQ_CVERSION=`get-mosquitto-version 2>/dev/null`
if [[ "${MQ_CVERSION}" = "" ]]; then
  echo "Mosquitto : Not installed"
else
  # Get Last Version
  MQ_VERSION=`get-mosquitto-lastversion 2>/dev/null`

  # Check if already up to date
  if [[ "${MQ_VERSION}" = "${MQ_CVERSION}" ]]; then
    echo "Mosquitto : Up to date '${MQ_CVERSION}'"
  else
    echo "Mosquitto : New version '${MQ_CVERSION}' => '${MQ_VERSION}'"
  fi
fi


####### KEEPALIVED #######

# Get Current Version
KA_CVERSION=`get-keepalived-version 2>/dev/null`
if [[ "${KA_CVERSION}" = "" ]]; then
  echo "Keepalived : Not installed"
else
  # Get Last Version
  KA_VERSION=`get-keepalived-lastversion 2>/dev/null`

  # Check if already up to date
  if [[ "${KA_VERSION}" = "${KA_CVERSION}" ]]; then
    echo "Keepalived : Up to date '${KA_CVERSION}'"
  else
    echo "Keepalived : New version '${KA_CVERSION}' => '${KA_VERSION}'"
  fi
fi


####### SQUID #######

# Get Current Version
SQ_CVERSION=`get-squid-version 2>/dev/null`
if [[ "${SQ_CVERSION}" = "" ]]; then
  echo "Squid : Not installed"
else
  # Get Last Version
  SQ_VERSION=`get-squid-lastversion 2>/dev/null`

  # Check if already up to date
  if [[ "${SQ_VERSION}" = "${SQ_CVERSION}" ]]; then
    echo "Squid : Up to date '${SQ_CVERSION}'"
  else
    echo "Squid : New version '${SQ_CVERSION}' => '${SQ_VERSION}'"
  fi
fi
