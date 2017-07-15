#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Nginx Service Script for Elasticsearch on Raspberry Pi 2 or 3


####### CHECK-NGINX #######

sudo systemctl status nginx.service >/dev/null 2>/dev/null