#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Kibana Service Script for Elasticsearch on Raspberry Pi 2 or 3


####### CHECK-KIBANA #######

sudo systemctl status kibana.service >/dev/null 2>/dev/null