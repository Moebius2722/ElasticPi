#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Node-RED installed version


####### COMMON #######

# Check if Node-RED is installed

if ! npm -g ls --depth=0 node-red >/dev/null 2>/dev/null; then
  echo "Node-RED is not installed" >&2
  exit 1
fi


####### GET-NODERED-VERSION #######

# Get Node-RED installed version

npm -g ls --depth=0 node-red | grep -i node-red | cut -d @ -f2 | cut -d ' ' -f1
