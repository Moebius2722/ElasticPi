#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get NodeJS last version


####### GET-NODEJS-VERSION #######

# Get NodeJS last version

wget https://nodejs.org/en/download/ -qO- | grep -i "LTS Version" | cut -d '>' -f 3 | cut -d '<' -f 1
