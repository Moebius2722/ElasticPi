#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Network Load Balancer Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######


####### CHECK-NLB #######

# Check HTTP local port
/bin/nc -z localhost 80
