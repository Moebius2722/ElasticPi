#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Logstash last version


####### GET-LOGSTASH-VERSION #######

# Get Logstash last version

wget https://www.elastic.co/downloads/logstash-oss/  -qO- | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep -i '\.deb$' | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 3 | cut -d . -f 1-3 | head -n 1
