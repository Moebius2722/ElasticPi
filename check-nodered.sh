#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Node-RED Service Script for Elasticsearch on Raspberry Pi 2 or 3


####### CHECK-NODERED #######

sudo systemctl status nodered.service >/dev/null 2>/dev/null