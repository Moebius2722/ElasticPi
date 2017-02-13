#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Backup Script for Elasticsearch on Raspberry Pi 2 or 3


####### BACKUP #######

allssh "sudo -H -u elasticsearch /usr/local/bin/curator --config /etc/elasticsearch/curator-config.yml /etc/elasticsearch/curator-actions.yml"
