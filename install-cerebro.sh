#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Cerebro on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 3 ]] ; then
  echo "Usage : $0 Elasticsearch_IP Elasticsearch_User Elasticsearch_Password"
  exit 1
fi

# Get Elasticsearch IP
e_ip=$1

# Get Elasticsearch User
e_user=$2

# Get Elasticsearch Password
e_password=$3

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before install Cerebro"
  exit 1
fi

# Check if already installed
if get-cerebro-version >/dev/null 2>/dev/null; then
  echo "Cerebro is already installed" >&2
  exit 1
fi

# Set Version
C_VERSION=`get-cerebro-maxversion`
if [[ ${C_VERSION} = '' ]]; then
  C_VERSION=`get-cerebro-lastversion`
fi


####### CEREBRO #######

# Install Cerebro Prerequisites
install-oracle-java

# Create Cerebro Build Folder
if [ ! -d "/mnt/elasticpi/build/cerebro/${C_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/cerebro/${C_VERSION}
  sudo chown -R root:root /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get and Check Cerebro Source
if [ -f /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz.sha512 ] && [ -f /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz ]; then
  pushd /mnt/elasticpi/build/cerebro/${C_VERSION}
  sha512sum -c /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz.sha512
  if [ $? -ne 0 ] ; then
    # Get Cerebro Source
    rm -f /tmp/cerebro-${C_VERSION}.tgz
    wget -P/tmp https://github.com/lmenezes/cerebro/releases/download/v${C_VERSION}/cerebro-${C_VERSION}.tgz && sudo cp -f /tmp/cerebro-${C_VERSION}.tgz /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz && rm -f /tmp/cerebro-${C_VERSION}.tgz
    pushd /mnt/elasticpi/build/cerebro/${C_VERSION} && sha512sum cerebro-${C_VERSION}.tgz | sudo tee /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz.sha512 && popd
  fi
  popd
else
  # Get Cerebro Source
  rm -f /tmp/cerebro-${C_VERSION}.tgz
  wget -P/tmp https://github.com/lmenezes/cerebro/releases/download/v${C_VERSION}/cerebro-${C_VERSION}.tgz && sudo cp -f /tmp/cerebro-${C_VERSION}.tgz /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz && rm -f /tmp/cerebro-${C_VERSION}.tgz
  pushd /mnt/elasticpi/build/cerebro/${C_VERSION} && sha512sum cerebro-${C_VERSION}.tgz | sudo tee /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz.sha512 && popd
fi

# Install Cerebro
sudo tar -xf /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz -C /usr/share && sudo mv /usr/share/cerebro-${C_VERSION} /usr/share/cerebro
sudo cp -f /opt/elasticpi/Cerebro/application.conf /usr/share/cerebro/conf/.
sudo sed -i "s/\[IP_ADDRESS\]/$e_ip/" /usr/share/cerebro/conf/application.conf
sudo sed -i "s/\[USER\]/$e_user/" /usr/share/cerebro/conf/application.conf
sudo sed -i "s/\[PASSWORD\]/$e_password/" /usr/share/cerebro/conf/application.conf

# Create Cerebro Group
if ! getent group cerebro >/dev/null; then
  sudo groupadd -r cerebro
fi

# Create Cerebro User
if ! getent passwd cerebro >/dev/null; then
  sudo useradd -M -r -g cerebro -d /usr/share/cerebro -s /usr/sbin/nologin -c "Cerebro Service User" cerebro
fi

sudo chown -R cerebro:cerebro /usr/share/cerebro

# Adding Autostart capability using SystemD
sudo cp -f /opt/elasticpi/Cerebro/cerebro.service /etc/systemd/system/.
sudo /bin/systemctl daemon-reload

# Enable and start Cerebro daemon
start-cerebro
