#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Nginx last version


####### GET-NGINX-VERSION #######

# Get Nginx last version

wget http://nginx.org/en/download.html -qO- | sed 's/>/>\n/g' | grep -i 'tar.gz"' | sort -V -r | head -1 | cut -d '"' -f 2 | cut -d / -f 3 | cut -d - -f 2 | cut -d . -f 1-3
