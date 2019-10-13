#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Ansible last version


####### GET-ANSIBLE-LASTVERSION #######

# Get Ansible last version

sudo apt-get update >/dev/null 2>/dev/null
sudo apt-cache madison ansible | cut -d '|' -f 2 | tr -d ' ' | cut -d ':' -f 2 | cut -d '-' -f 1 | head -n 1
