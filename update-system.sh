#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Elastic Stack on Raspberry Pi 2 or 3

# For run on clean installation
# curl -sL https://github.com/Moebius2722/ElasticPi/raw/master/update-system.sh | bash -

####### FULL SYSTEM UPDATE #######

sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y
