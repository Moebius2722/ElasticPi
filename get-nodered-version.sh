#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Node-RED installed version


####### GET-NODERED-VERSION #######

npm -g ls --depth=0 node-red | grep -i node-red | cut -d @ -f2 | cut -d ' ' -f1
