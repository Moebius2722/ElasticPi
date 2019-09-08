#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Kibana last version


####### GET-KIBANA-VERSION #######

# Get Kibana last version

wget https://www.elastic.co/downloads/kibana-oss/  -qO- | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep -i 'amd64\.deb$' | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 3 | cut -d . -f 1-3 | head -n 1
