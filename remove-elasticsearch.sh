#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Elasticsearch on Raspberry Pi 2 or 3


####### ELASTICSEARCH #######

# Remove Curator Job
sudo sed -i '/curator/d' /etc/crontab
sudo /bin/systemctl restart cron.service
sudo rm -rf /var/log/curator

# Uninstall Curator
sudo pip uninstall elasticsearch-curator -y

# Stop Elasticsearch
stop-elasticsearch

# Remove Elasticsearch
sudo dpkg --purge elasticsearch

# Purge Elasticsearch configuration
sudo rm -rf /etc/elasticsearch
sudo rm -rf /usr/share/elasticsearch
sudo rm -rf /var/lib/elasticsearch
sudo rm -rf /var/log/elasticsearch
sudo rm -f /etc/sysctl.d/96-elasticsearch.conf

# Remove Elasticsearch Backup NFS mount point
sudo sed -i '/espibackup/d' /etc/fstab
sudo umount /mnt/espibackup
sudo rm -rf /mnt/espibackup
