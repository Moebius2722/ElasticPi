#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Kibana on Raspberry Pi 2 or 3


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before install Kibana"
  exit 1
fi

# Check if already installed
if get-kibana-version >/dev/null 2>/dev/null; then
  echo "Kibana is already installed" >&2
  exit 1
fi

# Get IP Host
iphost=`hostname -I | cut -d ' ' -f 1`

# Generate virtual IP host
viphost=${iphost::-2}$((${iphost:(-2):1}-1))${iphost:(-1):1}

# Set Elasticsearch User and Password
e_user=pi
e_password=LuffyNami3003

# Set Version
if [[ ${K_VERSION} = '' ]]; then
  K_VERSION=`wget https://www.elastic.co/downloads/kibana/ -qO- | grep -i "\-i386\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3 | head -n 1`
fi
if [[ ${N_VERSION} = '' ]]; then
  K_MVERSION=`echo $K_VERSION | cut -d . -f 1-2`
  N_VERSION=`wget https://raw.githubusercontent.com/elastic/kibana/$K_MVERSION/.node-version -qO-`
fi

# Full System Update
if [[ ! "${PI_UPDATED}" = "1" ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi


####### KIBANA #######

# Get and Install Kibana with i386 package (Just NodeJS is i386 in package)
#--force-confold
wget -P/tmp https://artifacts.elastic.co/downloads/kibana/kibana-${K_VERSION}-i386.deb && sudo dpkg --force-architecture -i /tmp/kibana-${K_VERSION}-i386.deb && rm -f /tmp/kibana-${K_VERSION}-i386.deb

# Get and Replace NodeJS i386 by ARMv7l in Kibana
wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz && sudo tar -xf /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz -C /usr/share/kibana && sudo mv /usr/share/kibana/node /usr/share/kibana/node.ori && sudo mv /usr/share/kibana/node-v${N_VERSION}-linux-armv7l /usr/share/kibana/node && sudo chown -R root:root /usr/share/kibana/node && sudo rm -rf /usr/share/kibana/node.ori && rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz

# Set Kibana Memory Configuration (Max 100mb of memory)
echo 'NODE_OPTIONS="--max-old-space-size=100"' | sudo tee -a /etc/default/kibana

# Set Kibana Node Configuration
sudo sed -i 's/.*server\.port:.*/server\.port: 5601/' /etc/kibana/kibana.yml
sudo sed -i 's/.*server\.host:.*/server\.host: "0.0.0.0"/' /etc/kibana/kibana.yml
sudo sed -i "s/.*elasticsearch\.url:.*/elasticsearch\.url: \"https:\/\/$viphost:9202\"/" /etc/kibana/kibana.yml
sudo sed -i 's/.*elasticsearch\.preserveHost:.*/elasticsearch\.preserveHost: true/' /etc/kibana/kibana.yml
sudo sed -i 's/.*kibana\.index:.*/kibana\.index: "\.kibana"/' /etc/kibana/kibana.yml
sudo sed -i 's/.*kibana\.defaultAppId:.*/kibana\.defaultAppId: "dashboard"/' /etc/kibana/kibana.yml
sudo sed -i "s/.*elasticsearch\.username:.*/elasticsearch\.username: \"$e_user\"/" /etc/kibana/kibana.yml
sudo sed -i "s/.*elasticsearch\.password:.*/elasticsearch\.password: \"$e_password\"/" /etc/kibana/kibana.yml
sudo sed -i "s/.*elasticsearch\.ssl\.verificationMode:.*/elasticsearch\.ssl\.verificationMode: none/" /etc/kibana/kibana.yml
sudo sed -i 's/.*pid\.file:.*/pid\.file: \/var\/run\/kibana\/kibana\.pid/' /etc/kibana/kibana.yml
sudo sed -i 's/.*logging\.dest:.*/logging\.dest: \/var\/log\/kibana\/kibana\.log/' /etc/kibana/kibana.yml
sudo sed -i 's/.*logging\.verbose:.*/logging\.verbose: true/' /etc/kibana/kibana.yml

# Create Log Directory
sudo mkdir /var/log/kibana && sudo chown kibana /var/log/kibana

# Add PID File Management to Kibana Service
sudo sed -i '/Type=.*/a PermissionsStartOnly=true' /etc/systemd/system/kibana.service
sudo sed -i '/PermissionsStartOnly=.*/a ExecStartPre=\/usr\/bin\/install -o kibana -g kibana -d \/var\/run\/kibana' /etc/systemd/system/kibana.service
sudo sed -i '/ExecStartPre=.*/a PIDFile=\/var\/run\/kibana\/kibana\.pid' /etc/systemd/system/kibana.service

# Configure and Start Kibana as Daemon
sudo /bin/systemctl daemon-reload
start-kibana
