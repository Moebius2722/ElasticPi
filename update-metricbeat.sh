#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Metricbeat on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${MB_VERSION} = '' ]]; then
  MB_VERSION=`get-metricbeat-lastversion`
fi

# Check if already up to date
MB_CVERSION=`get-metricbeat-version`
if [ $? -ne 0 ] ; then
  exit 1
fi
if [[ "${MB_VERSION}" = "${MB_CVERSION}" ]]; then
  echo "Metricbeat is already up to date to ${MB_CVERSION} version"
  exit 0
fi
echo "Update Metricbeat ${MB_CVERSION} to ${MB_VERSION}"

# Get Logstash IP Output
l_ip=`sudo cat /etc/metricbeat/metricbeat.yml | grep " hosts:" | cut -d '"' -f 2 | cut -d ':' -f 1`

####### METRICBEAT #######

# Remove Metricbeat Old Version
remove-metricbeat

# Install Metricbeat New version
MB_VERSION=${MB_VERSION} install-metricbeat ${l_ip}
