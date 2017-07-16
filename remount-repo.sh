#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Remount Repository Script for Elasticsearch on Raspberry Pi 2 or 3


####### COMMON #######

# Get Service Name

svcname=`basename $0 | cut -d '.' -f 1 | cut -d '-' -f 2`

####### REMOUNT-REPO #######

sudo umount -f /mnt/espibackup
sudo rm -rf /mnt/espibackup/repo
sudo mount /mnt/espibackup
