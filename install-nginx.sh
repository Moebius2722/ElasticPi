#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Nginx on Raspberry Pi 2 or 3 to Secured Kibana


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before install Nginx"
  exit 1
fi

# Check if already installed
if get-nginx-version >/dev/null 2>/dev/null; then
  echo "Nginx is already installed" >&2
  exit 1
fi

# Set Version
NGX_VERSION=`get-nginx-maxversion`
if [[ ${NGX_VERSION} = '' ]]; then
  NGX_VERSION=`get-nginx-lastversion`
fi

# Purge Nginx Debian Installation
sudo apt-get purge nginx nginx-common nginx-doc nginx-extras nginx-full nginx-light -q -y
sudo apt-get autoremove --purge -q -y
sudo dpkg --purge $(dpkg --get-selections | grep deinstall | cut -f1) >/dev/null 2>/dev/null

# Add Nginx Requirements
sudo apt-get install libpcre3 libpcre3-dev libperl5.24 libperl-dev zlib1g zlib1g-dev libssl-dev libssl1.0.2 libxml2 libxml2-dev libxslt1.1 libxslt1-dev libjpeg62-turbo libjpeg62-turbo-dev libgd3 libgd-dev libgeoip1 libgeoip-dev libgoogle-perftools4 libgoogle-perftools-dev libpam0g libpam0g-dev -q -y


####### NGINX #######

# Build Nginx from Sources
build-nginx ${NGX_VERSION}

# Install Nginx Reverse Proxy
pushd /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}
sudo make install
popd

# Configure Nginx Daemon
sudo apt-get -o Dpkg::Options::="--force-overwrite" -o Dpkg::Options::="--force-confnew" install nginx-common -q -y
sudo sed -i '/\[Service\]/a Restart=always' /lib/systemd/system/nginx.service
sudo /bin/systemctl daemon-reload

# Configure Nginx
configure-nginx
