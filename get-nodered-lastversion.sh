#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Node-RED last version


####### GET-NODERED-VERSION #######

# Check if NPM is installed

which npm >/dev/null 2>/dev/null
if [ $? -ne 0 ] ; then
  echo "NPM is not installed" >&2
  exit 1
fi

# Get Node-RED last version

npm info node-red version
