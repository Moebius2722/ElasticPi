#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Golang on Raspberry Pi 2 or 3 to Secured Kibana


####### COMMON #######

# Set Version
if [[ ${GO_VERSION} = '' ]]; then
  GO_VERSION=`get-golang-lastversion`
fi

# Check if already up to date
GO_CVERSION=`get-golang-version`
if [ $? -ne 0 ] ; then
  exit 1
fi
if [[ "${GO_VERSION}" = "${GO_CVERSION}" ]]; then
  echo "Golang is already up to date to ${GO_CVERSION} version"
  exit 0
fi
echo "Update Golang ${GO_CVERSION} to ${GO_VERSION}"


####### GOLANG #######

# Update Golang
rm -f /tmp/${GO_VERSION}.linux-armv6l.tar.gz ; wget -P/tmp https://redirector.gvt1.com/edgedl/go/${GO_VERSION}.linux-armv6l.tar.gz && sudo mv /usr/local/go /usr/local/go.ori && sudo tar -C /usr/local -xzf /tmp/${GO_VERSION}.linux-armv6l.tar.gz && sudo rm -rf /usr/local/go.ori && rm -f /tmp/${GO_VERSION}.linux-armv6l.tar.gz
