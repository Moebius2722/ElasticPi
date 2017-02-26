#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for ElasticPi Tools on Raspberry Pi 2 or 3


####### TOOLS #######
cd

allssh "rm -rf ~/ElasticPi ; git clone https://github.com/Moebius2722/ElasticPi.git ~/ElasticPi ; chmod -R a+x ~/ElasticPi/*.sh"

cd `dirname $0`
