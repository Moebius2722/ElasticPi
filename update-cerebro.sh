#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Update Script for Cerebro on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${C_VERSION} = '' ]]; then
  C_VERSION=`wget https://github.com/lmenezes/cerebro/releases/latest -qO- | grep -i "\.tgz\"" | cut -d '"' -f 2 | cut -d / -f 7 | cut -d - -f 2 | cut -d . -f 1-3`
fi

# Check if already up to date
C_CVERSION=`ls /usr/share/cerebro/lib/cerebro.cerebro-*-assets.jar | cut -d - -f2`
if [[ "${C_VERSION}" = "${C_CVERSION}" ]]; then
  echo "Cerebro is already up to date to ${C_CVERSION} version"
  exit 0
fi

# Stop Cerebro Daemon
sudo /bin/systemctl stop cerebro.service

# Full System Update
if [[ ! "${PI_UPDATED}" = 1 ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi


####### CEREBRO #######

# Get and Update Cerebro
wget -P/tmp https://github.com/lmenezes/cerebro/releases/download/v${C_VERSION}/cerebro-${C_VERSION}.tgz && sudo tar -xf /tmp/cerebro-${C_VERSION}.tgz -C /usr/share && sudo mv /usr/share/cerebro /usr/share/cerebro.ori && sudo mv /usr/share/cerebro-${C_VERSION} /usr/share/cerebro && sudo chown -R cerebro:cerebro /usr/share/cerebro && sudo rm -rf /usr/share/cerebro.ori

# Configure and Start Cerebro as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable cerebro.service
sudo /bin/systemctl start cerebro.service
