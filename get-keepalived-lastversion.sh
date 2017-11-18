#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Keepalived last version


####### GET-KEEPALIVED-VERSION #######

# Get Keepalived last version

sudo apt-get update >/dev/null 2>/dev/null
sudo apt-cache madison keepalived | cut -d '|' -f 2 | tr -d ' '
