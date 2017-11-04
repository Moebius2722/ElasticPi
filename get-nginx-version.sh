#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Nginx installed version


####### COMMON #######

# Check if Nginx is installed

if [ ! -f /usr/sbin/nginx ]; then
  echo "Nginx is not installed" >&2
  exit 1
fi


####### GET-NGINX-VERSION #######

# Get Nginx installed version

/usr/sbin/nginx -v 2>&1 | cut -d / -f 2
