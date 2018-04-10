#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Keepalived on Raspberry Pi 2 or 3


####### KEEPALIVED #######

# Stop Keepalived
stop-keepalived

# Remove Keepalived Load Balancer
sudo apt-get purge keepalived -q -y

# Remove loopback ARP response for Keepalived.
sudo rm -f /etc/sysctl.d/95-keepalived.conf
