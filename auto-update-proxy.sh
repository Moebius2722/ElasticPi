#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Proxy Blacklist and System with Reboot on Raspberry Pi 2 or 3


####### AUTO-UPDATE-PROXY #######

# Auto Update System
echo "================================= AUTO-UPDATE-PROXY =================================="
date

# Update Squidguard Blacklist
update-squidguard-blacklist

# Update System
update-system

date
echo "================================= AUTO-UPDATED-PROXY ================================="

sudo reboot
