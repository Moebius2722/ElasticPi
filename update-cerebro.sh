#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Cerebro on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${C_VERSION} = '' ]]; then
  C_VERSION=`get-cerebro-lastversion`
fi

# Check if already up to date
C_CVERSION=`get-cerebro-version`
if [ $? -ne 0 ] ; then
  exit 1
fi
if [[ "${C_VERSION}" = "${C_CVERSION}" ]]; then
  echo "Cerebro is already up to date to ${C_CVERSION} version"
  exit 0
fi
echo "Update Cerebro ${C_CVERSION} to ${C_VERSION}"

# Stop Cerebro Daemon
stop-cerebro


####### CEREBRO #######

# Backup Cerebro configuration
sudo cp -f /usr/share/cerebro/conf/application.conf /tmp/cerebro-application.conf.bkp

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
    sudo sha512sum /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz | sudo tee /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz.sha512
  fi
  popd
else
  # Get Cerebro Source
  rm -f /tmp/cerebro-${C_VERSION}.tgz
  wget -P/tmp https://github.com/lmenezes/cerebro/releases/download/v${C_VERSION}/cerebro-${C_VERSION}.tgz && sudo cp -f /tmp/cerebro-${C_VERSION}.tgz /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz && rm -f /tmp/cerebro-${C_VERSION}.tgz
  sudo sha512sum /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz | sudo tee /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz.sha512
fi

# Update Cerebro
sudo tar -xf /mnt/elasticpi/build/cerebro/${C_VERSION}/cerebro-${C_VERSION}.tgz -C /usr/share && sudo mv /usr/share/cerebro /usr/share/cerebro.ori && sudo mv /usr/share/cerebro-${C_VERSION} /usr/share/cerebro && sudo chown -R cerebro:cerebro /usr/share/cerebro && sudo rm -rf /usr/share/cerebro.ori

# Restore Cerebro configuration
sudo cp -f /tmp/cerebro-application.conf.bkp /usr/share/cerebro/conf/application.conf && sudo rm -f /tmp/cerebro-application.conf.bkp

# Configure and Start Cerebro as Daemon
sudo /bin/systemctl daemon-reload
start-cerebro
