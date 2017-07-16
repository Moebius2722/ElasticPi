#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Restart Node Services Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get Service Name

svcname=`basename $0 | cut -d '.' -f 1 | cut -d '-' -f 2`

####### RESTART-SERVICE #######

# Node Service
stop-$svcname
start-$svcname
