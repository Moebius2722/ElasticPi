#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Create Repo NFS Mount Folder for Elastic Stack on Raspberry Pi 2 or 3


####### REPO #######

# Create and configure Repo NFS mount point
sudo mkdir /mnt/elasticpi
sudo chmod -R 770 /mnt/elasticpi
sudo apt-get install nfs-common -q -y
sudo systemctl enable rpcbind.service
sudo systemctl start rpcbind.service
echo '192.168.0.1:/volume1/elasticpi /mnt/elasticpi nfs rw         0       0' | sudo tee -a /etc/fstab
sudo mount /mnt/elasticpi
sudo chmod -R 770 /mnt/elasticpi
