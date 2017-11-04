#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Elasticsearch installed version


####### GET-ELASTICSEARCH-VERSION #######

dpkg-query -W -f='${Version}\n' elasticsearch
