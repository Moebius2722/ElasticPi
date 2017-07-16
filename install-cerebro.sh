#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Cerebro on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Host
iphost=`hostname -I | cut -d ' ' -f 1`

# Generate virtual IP host
viphost=${iphost::-2}$((${iphost:(-2):1}-1))${iphost:(-1):1}

# Set Elasticsearch User and Password
e_user=pi
e_password=LuffyNami3003

# Set Version
if [[ ${C_VERSION} = '' ]]; then
  C_VERSION=`wget https://github.com/lmenezes/cerebro/releases/latest -qO- | grep -i "\.tgz\"" | cut -d '"' -f 2 | cut -d / -f 7 | cut -d - -f 2 | cut -d . -f 1-3`
fi

# Full System Update
if [[ ! "${PI_UPDATED}" = "1" ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi


####### CEREBRO #######

# Get and Install Cerebro
wget -P/tmp https://github.com/lmenezes/cerebro/releases/download/v${C_VERSION}/cerebro-${C_VERSION}.tgz && sudo tar -xf /tmp/cerebro-${C_VERSION}.tgz -C /usr/share && sudo mv /usr/share/cerebro-${C_VERSION} /usr/share/cerebro && rm -f /tmp/cerebro-${C_VERSION}.tgz
sudo cp -f /opt/elasticpi/Cerebro/application.conf /usr/share/cerebro/conf/.
sudo sed -i "s/\[IP_ADDRESS\]/$viphost/" /usr/share/cerebro/conf/application.conf
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
