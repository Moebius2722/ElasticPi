#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Update Script for Lastest Node-RED on Raspberry Pi 2 or 3


####### COMMON #######

# Stop Node-RED Daemon
sudo /bin/systemctl stop nodered.service

# Full System Update
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update


####### NODERED #######

# Update Node-RED
sudo npm cache clean
sudo npm update -g npm@2.x
hash -r
sudo npm update -g node-gyp
sudo npm update -g --unsafe-perm node-red

# Configure and Start Node-RED as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable nodered.service
sudo /bin/systemctl start nodered.service