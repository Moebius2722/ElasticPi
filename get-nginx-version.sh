#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Nginx installed version


####### GET-NGINX-VERSION #######

/usr/sbin/nginx -v 2>&1 | cut -d / -f 2
