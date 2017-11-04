#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Logstash installed version


####### GET-LOGSTASH-VERSION #######

dpkg-query -W -f='${Version}\n' logstash | cut -d : -f2 | cut -d - -f1
