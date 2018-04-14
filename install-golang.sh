#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Golang on Raspberry Pi 2 or 3 to Secured Kibana


####### COMMON #######

# Check if already installed
if get-golang-version >/dev/null 2>/dev/null; then
  echo "Golang is already installed" >&2
  exit 1
fi

# Set Version
if [[ ${GO_VERSION} = '' ]]; then
  GO_VERSION=`get-golang-lastversion`
fi


####### GOLANG #######

# Create Golang Build Folder
if [ ! -d "/mnt/elasticpi/build/golang/${GO_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/golang/${GO_VERSION}
  sudo chown -R root:root /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get and Check Golang Source
if [ -f /mnt/elasticpi/build/golang/${GO_VERSION}/${GO_VERSION}.linux-armv6l.tar.gz.sha512 ] && [ -f /mnt/elasticpi/build/golang/${GO_VERSION}/${GO_VERSION}.linux-armv6l.tar.gz ]; then
  pushd /mnt/elasticpi/build/golang/${GO_VERSION}
  sha512sum -c /mnt/elasticpi/build/golang/${GO_VERSION}/${GO_VERSION}.linux-armv6l.tar.gz.sha512
  if [ $? -ne 0 ] ; then
    # Get Golang Source
    rm -f /tmp/${GO_VERSION}.linux-armv6l.tar.gz
    wget -P/tmp https://redirector.gvt1.com/edgedl/go/${GO_VERSION}.linux-armv6l.tar.gz && sudo cp -f /tmp/${GO_VERSION}.linux-armv6l.tar.gz /mnt/elasticpi/build/golang/${GO_VERSION}/${GO_VERSION}.linux-armv6l.tar.gz && rm -f /tmp/${GO_VERSION}.linux-armv6l.tar.gz
    sudo sha512sum /mnt/elasticpi/build/golang/${GO_VERSION}/${GO_VERSION}.linux-armv6l.tar.gz | sudo tee /mnt/elasticpi/build/golang/${GO_VERSION}/${GO_VERSION}.linux-armv6l.tar.gz.sha512
  fi
  popd
else
  # Get Golang Source
  rm -f /tmp/${GO_VERSION}.linux-armv6l.tar.gz
  wget -P/tmp https://redirector.gvt1.com/edgedl/go/${GO_VERSION}.linux-armv6l.tar.gz && sudo cp -f /tmp/${GO_VERSION}.linux-armv6l.tar.gz /mnt/elasticpi/build/golang/${GO_VERSION}/${GO_VERSION}.linux-armv6l.tar.gz && rm -f /tmp/${GO_VERSION}.linux-armv6l.tar.gz
  sudo sha512sum /mnt/elasticpi/build/golang/${GO_VERSION}/${GO_VERSION}.linux-armv6l.tar.gz | sudo tee /mnt/elasticpi/build/golang/${GO_VERSION}/${GO_VERSION}.linux-armv6l.tar.gz.sha512
fi

# Install Golang
sudo tar -C /usr/local -xzf /mnt/elasticpi/build/golang/${GO_VERSION}/${GO_VERSION}.linux-armv6l.tar.gz && echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile && echo 'export GOPATH=$HOME/go' | sudo tee -a /etc/profile && echo 'export PATH=$PATH:$GOPATH/bin' | sudo tee -a /etc/profile && sudo ln -sf /usr/local/go/bin/go /usr/bin/go
export PATH=$PATH:/usr/local/go/bin
mkdir -p $HOME/go
export GOPATH=$HOME/go
