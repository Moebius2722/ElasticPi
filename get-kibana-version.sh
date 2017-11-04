#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Kibana installed version


####### GET-KIBANA-VERSION #######

dpkg-query -W -f='${Version}\n' kibana
