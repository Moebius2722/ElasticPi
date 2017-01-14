#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Update Script for Cerebro on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${C_VERSION} = '' ]]; then
  C_VERSION=0.4.2
fi

# Stop Cerebro Daemon
sudo /bin/systemctl stop cerebro.service

# Full System Update
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update


####### CEREBRO #######

# Get and Update Cerebro
wget -P/tmp https://github.com/lmenezes/cerebro/releases/download/v${C_VERSION}/cerebro-${C_VERSION}.tgz && sudo tar -xf /tmp/cerebro-${C_VERSION}.tgz -C /usr/share && sudo mv /usr/share/cerebro /usr/share/cerebro.ori && sudo mv /usr/share/cerebro-${C_VERSION} /usr/share/cerebro && sudo chown -R cerebro:cerebro /usr/share/cerebro && sudo rm -rf /usr/share/cerebro.ori

# Configure and Start Cerebro as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable cerebro.service
sudo /bin/systemctl start cerebro.service
