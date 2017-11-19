#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Filebeat last version


####### GET-FILEBEAT-VERSION #######

# Get Filebeat last version

wget https://www.elastic.co/downloads/beats/filebeat/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 7 | cut -d - -f 2 | cut -d . -f 1-3 | head -n 1
