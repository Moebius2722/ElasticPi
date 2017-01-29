#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Installation Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version ELK
E_VERSION=5.1.2
L_VERSION=5.1.2
K_VERSION=5.1.2
N_VERSION=6.9.0
C_VERSION=0.5.0

# Set Pi Updated Flag
PI_UPDATED=0

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


####### NODERED #######

./install-nodered.sh
