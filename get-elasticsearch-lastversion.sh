#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Elasticsearch last version


####### GET-ELASTICSEARCH-VERSION #######

# Get Elasticsearch last version

wget https://www.elastic.co/downloads/elasticsearch-oss/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3 | head -n 1
