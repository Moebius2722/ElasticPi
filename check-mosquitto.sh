#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Check Mosquitto Service Script for Elasticsearch on Raspberry Pi 2 or 3


####### CHECK-MOSQUITTO #######

sudo systemctl status mosquitto.service >/dev/null 2>/dev/null