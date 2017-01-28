#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElkPi.git

# Full Automated Installation Script for Cerebro on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${C_VERSION} = '' ]]; then
  C_VERSION=0.5.0
fi

# Full System Update
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo apt-get install rpi-update -q -y && sudo rpi-update


####### CEREBRO #######

# Get and Install Cerebro
wget -P/tmp https://github.com/lmenezes/cerebro/releases/download/v${C_VERSION}/cerebro-${C_VERSION}.tgz && sudo tar -xf /tmp/cerebro-${C_VERSION}.tgz -C /usr/share && sudo mv /usr/share/cerebro-${C_VERSION} /usr/share/cerebro

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
sudo cp -f ./Cerebro/cerebro.service /etc/systemd/system/.
sudo /bin/systemctl daemon-reload

# Enable and start Cerebro daemon
sudo /bin/systemctl enable cerebro.service
sudo /bin/systemctl start cerebro.service
