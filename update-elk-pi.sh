#!/bin/sh

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Update Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version ELK
E_VERSION=5.1.2
L_VERSION=5.1.2
K_VERSION=5.1.2
N_VERSION=6.9.0
C_VERSION=0.4.2

####### ELASTICSEARCH #######

source ./update-elasticsearch.sh


####### LOGSTASH #######

source ./update-logstash.sh


####### KIBANA #######

source ./update-kibana.sh


####### CEREBRO #######

source ./update-cerebro.sh


####### NODERED #######

source ./update-nodered.sh
