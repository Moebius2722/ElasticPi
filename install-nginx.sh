#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Installation Script for Nginx on Raspberry Pi 2 or 3 to Secured Kibana


####### COMMON #######

# Full System Update
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo apt-get install rpi-update -q -y && sudo rpi-update


####### NGINX #######

# Install Nginx Reverse Proxy
sudo apt-get install nginx -q -y

# Create SSL Auto Signed Certificate for Nginx Reverse Proxy
sudo mkdir /etc/nginx/ssl && (echo FR; echo France; echo Paris; echo Raspberry Pi; echo Nginx; echo $(hostname -I); echo ;) | sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt

# Create Kibana User Group
if ! getent group kibana-usr >/dev/null; then
  sudo groupadd -r kibana-usr
fi

# Add "pi" user to Kibana User Group
sudo usermod -a -G kibana-usr pi

# Create Restricted Groups File for Nginx PAM authentication with "kibana-usr" default access group
sudo cp -f ./Nginx/restricted_groups /etc/nginx/restricted_groups

# Allow Nginx to read /etc/shadow file for PAM authentication
sudo usermod -a -G shadow www-data

# Set PAM Authentication for Nginx
sudo cp -f ./Nginx/nginx_restricted /etc/pam.d/nginx_restricted

# Set Nginx Default Site redirect on local Kibana with PAM authentication
sudo cp -f ./Nginx/default /etc/nginx/sites-available/default

# Restart Nginx Daemon for Update Configuration
sudo /bin/systemctl restart nginx.service

# Secured Kibana
sudo sed -i 's/.*server\.host:.*/server\.host: "127.0.0.1"/' /etc/kibana/kibana.yml
sudo /bin/systemctl restart kibana.service
