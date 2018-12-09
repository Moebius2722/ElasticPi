#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Uninstallation Script for Nginx on Raspberry Pi 2 or 3


####### COMMON #######

# Check if not installed
if ! get-nginx-version >/dev/null 2>/dev/null; then
  echo "Nginx isn't installed" >&2
  exit 1
fi


####### NGINX #######

# Stop Nginx
stop-nginx

# Remove Nginx Daemon
sudo apt-get purge nginx-common nginx -q -y
sudo apt-get autoremove --purge -q -y
sudo /bin/systemctl daemon-reload

# Remove Nginx
sudo rm -rf /etc/nginx
sudo rm -rf /var/www
sudo rm -rf /var/log/nginx
sudo rm -f /usr/sbin/nginx
sudo rm -f /run/nginx.pid

# Remove PAM Configuration
sudo rm -f /etc/pam.d/nginx_restricted
sudo groupdel kibana-usr
sudo deluser www-data shadow
