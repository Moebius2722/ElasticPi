#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Show Logs for Metricbeat on Raspberry Pi 2 or 3


####### show-log-metricbeat #######

sudo tail -f -n 60 /var/log/metricbeat/metricbeat
