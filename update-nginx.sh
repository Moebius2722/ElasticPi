#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Nginx on Raspberry Pi 2 or 3


####### COMMON #######

# Check if not installed
if ! get-nginx-version >/dev/null 2>/dev/null; then
  echo "Nginx is not installed" >&2
  exit 1
fi

# Set Version
if [[ ${NGX_VERSION} = '' ]]; then
  NGX_VERSION=`get-nginx-lastversion`
fi

# Check if already up to date
NGX_CVERSION=`get-nginx-version`
if [ $? -ne 0 ] ; then
  exit 1
fi
if [[ "${NGX_VERSION}" = "${NGX_CVERSION}" ]]; then
  echo "Nginx is already up to date to ${NGX_CVERSION} version"
  exit 0
fi
echo "Update Nginx ${NGX_CVERSION} to ${NGX_VERSION}"

# Stop Keepalived Daemon
stop-keepalived

# Stop Nginx Daemon
stop-nginx


####### NGINX #######

# Build Nginx from Sources
build-nginx ${NGX_VERSION}

# Install Nginx Reverse Proxy
pushd /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}
sudo make install
popd

# Start Nginx Daemon
start-nginx

# Start Keepalived Daemon
start-keepalived
