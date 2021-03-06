#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update System Node with Reboot on Raspberry Pi 2 or 3


####### AUTO-UPDATE #######

# Auto Update System
echo "================================= AUTO-UPDATE =================================="
date

# Update System
update-system

date
echo "================================= AUTO-UPDATED ================================="

sudo reboot
