#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Remove Repo NFS Mount Folder for Elastic Stack on Raspberry Pi 2 or 3


####### REPO #######

# Remove and Unconfigure Repo NFS mount point
sudo umount -f /mnt/elasticpi
sudo sed -i "/\/mnt\/elasticpi/d" /etc/fstab
sudo rm -rf /mnt/elasticpi
