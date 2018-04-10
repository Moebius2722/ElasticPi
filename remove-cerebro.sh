#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Cerebro on Raspberry Pi 2 or 3


####### CEREBRO #######

# Stop Cerebro
stop-cerebro

# Remove Cerebro Daemon
sudo rm -f /etc/systemd/system/cerebro.servic
sudo /bin/systemctl daemon-reload

# Remove Cerebro
sudo rm -rf /usr/share/cerebro

# Remove Cerebro User
sudo userdel -f cerebro

# Remove Cerebro Group
sudo groupdel cerebro
