#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Cerebro installed version


####### COMMON #######

# Check if Cerebro is installed

if [ ! -f /usr/share/cerebro/lib/cerebro.cerebro-*-assets.jar ]; then
  echo "Cerebro is not installed" >&2
  exit 1
fi


####### GET-CEREBRO-VERSION #######

# Get Cerebro installed version

ls /usr/share/cerebro/lib/cerebro.cerebro-*-assets.jar | cut -d - -f2
