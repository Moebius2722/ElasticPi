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

# Get and Update Cerebro
rm -f /tmp/cerebro-${C_VERSION}.tgz ; wget -P/tmp https://github.com/lmenezes/cerebro/releases/download/v${C_VERSION}/cerebro-${C_VERSION}.tgz && sudo tar -xf /tmp/cerebro-${C_VERSION}.tgz -C /usr/share && sudo mv /usr/share/cerebro /usr/share/cerebro.ori && sudo mv /usr/share/cerebro-${C_VERSION} /usr/share/cerebro && sudo chown -R cerebro:cerebro /usr/share/cerebro && sudo rm -rf /usr/share/cerebro.ori && rm -f /tmp/cerebro-${C_VERSION}.tgz

# Restore Cerebro configuration
sudo cp -f /tmp/cerebro-application.conf.bkp /usr/share/cerebro/conf/application.conf

# Configure and Start Cerebro as Daemon
sudo /bin/systemctl daemon-reload
start-cerebro
