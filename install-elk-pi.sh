#!/bin/sh

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Installation Script for ELK Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version ELK
E_VERSION=5.1.1
L_VERSION=5.1.1
K_VERSION=5.1.1
N_VERSION=6.9.0

####### ELASTICSEARCH #######

./install-elasticsearch.sh


####### LOGSTASH #######

./install-logstash.sh


####### KIBANA #######

./install-kibana.sh


####### NGINX #######

./install-nginx.sh

####### CEREBRO #######

./install-cerebro.sh
