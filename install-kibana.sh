#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Installation Script for Kibana on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${K_VERSION} = '' ]]; then
  K_VERSION=5.1.2
fi
if [[ ${N_VERSION} = '' ]]; then
  N_VERSION=6.9.0
fi

# Full System Update
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo apt-get install rpi-update -q -y && sudo rpi-update


####### KIBANA #######

# Get and Install Kibana with i386 package (Just NodeJS is i386 in package)
#--force-confold
wget -P/tmp https://artifacts.elastic.co/downloads/kibana/kibana-${K_VERSION}-i386.deb && sudo dpkg --force-architecture -i /tmp/kibana-${K_VERSION}-i386.deb

# Get and Replace NodeJS i386 by ARMv7l in Kibana
wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz && sudo tar -xf /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz -C /usr/share/kibana && sudo mv /usr/share/kibana/node /usr/share/kibana/node.ori && sudo mv /usr/share/kibana/node-v${N_VERSION}-linux-armv7l /usr/share/kibana/node && sudo chown -R root:root /usr/share/kibana/node && sudo rm -rf /usr/share/kibana/node.ori

# Set Kibana Memory Configuration (Max 100mb of memory)
echo 'NODE_OPTIONS="--max-old-space-size=100"' | sudo tee -a /etc/default/kibana

# Set Kibana Node Configuration
sudo sed -i 's/.*server\.port:.*/server\.port: 5601/' /etc/kibana/kibana.yml
sudo sed -i 's/.*server\.host:.*/server\.host: "0.0.0.0"/' /etc/kibana/kibana.yml
sudo sed -i 's/.*elasticsearch\.url:.*/elasticsearch\.url: "http:\/\/localhost:9200"/' /etc/kibana/kibana.yml
sudo sed -i 's/.*elasticsearch\.preserveHost:.*/elasticsearch\.preserveHost: true/' /etc/kibana/kibana.yml
sudo sed -i 's/.*kibana\.index:.*/kibana\.index: "\.kibana"/' /etc/kibana/kibana.yml
sudo sed -i 's/.*kibana\.defaultAppId:.*/kibana\.defaultAppId: "dashboard"/' /etc/kibana/kibana.yml
sudo sed -i 's/.*pid\.file:.*/pid\.file: \/var\/run\/kibana\/kibana\.pid/' /etc/kibana/kibana.yml
sudo sed -i 's/.*logging\.dest:.*/logging\.dest: \/var\/log\/kibana\/kibana\.log/' /etc/kibana/kibana.yml
sudo sed -i 's/.*logging\.verbose:.*/logging\.verbose: true/' /etc/kibana/kibana.yml

# Create Log Directory
sudo mkdir /var/log/kibana && sudo chown kibana /var/log/kibana

# Add PID File Management to Kibana Service
sudo sed -i '/Type=.*/a PermissionsStartOnly=true' /etc/systemd/system/kibana.service
sudo sed -i '/PermissionsStartOnly=.*/a ExecStartPre=\/usr\/bin\/install -o kibana -g kibana -d \/var/run/kibana' /etc/systemd/system/kibana.service
sudo sed -i '/ExecStartPre=.*/a PIDFile=\/var\/run\/kibana\/kibana\.pid' /etc/systemd/system/kibana.service

# Configure and Start Kibana as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl start kibana.service
