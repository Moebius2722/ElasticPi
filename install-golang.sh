#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Golang on Raspberry Pi 2 or 3 to Secured Kibana


####### COMMON #######

# Set Version
if [[ ${GO_VERSION} = '' ]]; then
  GO_VERSION=`get-golang-lastversion`
fi

####### GOLANG #######

# Install Golang
rm -f /tmp/${GO_VERSION}.linux-armv6l.tar.gz ; wget -P/tmp https://redirector.gvt1.com/edgedl/go/${GO_VERSION}.linux-armv6l.tar.gz && sudo tar -C /usr/local -xzf /tmp/${GO_VERSION}.linux-armv6l.tar.gz && echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile && echo 'export GOPATH=$HOME/go' | sudo tee -a /etc/profile && echo 'export PATH=$PATH:$GOPATH/bin' | sudo tee -a /etc/profile && rm -f /tmp/${GO_VERSION}.linux-armv6l.tar.gz
export PATH=$PATH:/usr/local/go/bin
mkdir -p $HOME/go
export GOPATH=$HOME/go
