#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Node-RED installed version


####### COMMON #######

# Check if NPM is installed

which npm >/dev/null 2>/dev/null
if [ $? -ne 0 ] ; then
  echo "NPM is not installed" >&2
  exit 1
fi

# Check if Node-RED is installed

if ! sudo npm -g ls --depth=0 node-red >/dev/null 2>/dev/null; then
  echo "Node-RED is not installed" >&2
  exit 2
fi


####### GET-NODERED-VERSION #######

# Get Node-RED installed version

sudo npm -g ls --depth=0 node-red | grep -i node-red | cut -d @ -f2 | cut -d ' ' -f1
