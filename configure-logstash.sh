#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Configure Script for Logstash on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 3 ]] ; then
  echo "Usage : $0 Elasticsearch_IP Elasticsearch_User Elasticsearch_Password"
  exit 1
fi

# Get Elasticsearch IP
e_ip=$1

# Get Elasticsearch User
e_user=$2

# Get Elasticsearch Password
e_password=$3

# Check if installed
if ! get-logstash-version >/dev/null 2>/dev/null; then
  echo "Logstash isn't installed" >&2
  exit 1
fi


####### LOGSTASH #######

# Set Logstash Node Configuration
sudo cp -f /opt/elasticpi/Logstash/00-default.conf /etc/logstash/conf.d/00-default.conf
sudo sed -i "s/\[IP_ADDRESS\]/$e_ip/" /etc/logstash/conf.d/00-default.conf
sudo sed -i "s/\[USER\]/$e_user/" /etc/logstash/conf.d/00-default.conf
sudo sed -i "s/\[PASSWORD\]/$e_password/" /etc/logstash/conf.d/00-default.conf

# Restart Logstash Load Balancer
restart-logstash
