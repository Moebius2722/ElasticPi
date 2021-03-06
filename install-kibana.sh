#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Kibana on Raspberry Pi 2 or 3


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
  echo "Create cluster before install Kibana"
  exit 1
fi

# Check if already installed
if get-kibana-version >/dev/null 2>/dev/null; then
  echo "Kibana is already installed" >&2
  exit 1
fi

# Set Version
K_VERSION=`get-kibana-maxversion`
if [[ ${K_VERSION} = '' ]]; then
  K_VERSION=`get-kibana-lastversion`
fi
if [[ ${N_VERSION} = '' ]]; then
  K_MVERSION=`echo $K_VERSION | cut -d . -f 1-2`
  N_VERSION=`wget https://raw.githubusercontent.com/elastic/kibana/$K_MVERSION/.node-version -qO-`
fi


####### KIBANA #######

#Create Kibana Build Folder
if [ ! -d "/mnt/elasticpi/build/kibana/${K_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/kibana/${K_VERSION}
  sudo chown -R root:root /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get and Check Kibana Debian Package
rm -f /tmp/kibana-oss-${K_VERSION}-amd64.deb.sha512
wget -P/tmp https://artifacts.elastic.co/downloads/kibana/kibana-oss-${K_VERSION}-amd64.deb.sha512
if [ -f "/mnt/elasticpi/build/kibana/${K_VERSION}/kibana-oss-${K_VERSION}-amd64.deb" ]; then
  pushd /mnt/elasticpi/build/kibana/${K_VERSION}
  sha512sum -c /tmp/kibana-oss-${K_VERSION}-amd64.deb.sha512
  if [ $? -ne 0 ] ; then
    rm -f /tmp/kibana-oss-${K_VERSION}-amd64.deb
    wget -P/tmp https://artifacts.elastic.co/downloads/kibana/kibana-oss-${K_VERSION}-amd64.deb
    pushd /tmp
    sha512sum -c /tmp/kibana-oss-${K_VERSION}-amd64.deb.sha512
    if [ $? -ne 0 ] ; then
      popd
      exit 1
    fi
	  popd
	  sudo cp -f /tmp/kibana-oss-${K_VERSION}-amd64.deb /mnt/elasticpi/build/kibana/${K_VERSION}/kibana-oss-${K_VERSION}-amd64.deb
	  rm -f /tmp/kibana-oss-${K_VERSION}-amd64.deb
  fi
  popd
else
  rm -f /tmp/kibana-oss-${K_VERSION}-amd64.deb
  wget -P/tmp https://artifacts.elastic.co/downloads/kibana/kibana-oss-${K_VERSION}-amd64.deb
  pushd /tmp
  sha512sum -c /tmp/kibana-oss-${K_VERSION}-amd64.deb.sha512
  if [ $? -ne 0 ] ; then
    popd
	  exit 1
  fi
  popd
  sudo cp -f /tmp/kibana-oss-${K_VERSION}-amd64.deb /mnt/elasticpi/build/kibana/${K_VERSION}/kibana-oss-${K_VERSION}-amd64.deb
  rm -f /tmp/kibana-oss-${K_VERSION}-amd64.deb
fi
rm -f /tmp/kibana-oss-${K_VERSION}-amd64.deb.sha512

# Install Kibana with amd64 package (Just NodeJS is amd64 in package)
sudo dpkg --force-architecture -i /mnt/elasticpi/build/kibana/${K_VERSION}/kibana-oss-${K_VERSION}-amd64.deb

#Create NodeJS Build Folder
if [ ! -d "/mnt/elasticpi/build/nodejs/${N_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/nodejs/${N_VERSION}
  sudo chown -R root:root /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get and Check NodeJS Binary Archive
rm -f /tmp/SHASUMS256.txt
rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256
wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/SHASUMS256.txt
cat /tmp/SHASUMS256.txt | grep node-v${N_VERSION}-linux-armv7l.tar.gz >/tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256
rm -f /tmp/SHASUMS256.txt

if [ -f "/mnt/elasticpi/build/nodejs/${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz" ]; then
  pushd /mnt/elasticpi/build/nodejs/${N_VERSION}
  sha256sum -c /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256
  if [ $? -ne 0 ] ; then
    rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz
    wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz
    pushd /tmp
    sha256sum -c /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256
    if [ $? -ne 0 ] ; then
      popd
      exit 1
    fi
	  popd
	  sudo cp -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz /mnt/elasticpi/build/nodejs/${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz
	  rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz
  fi
  popd
else
  rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz
  wget -P/tmp https://nodejs.org/download/release/v${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz
  pushd /tmp
  sha256sum -c /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256
  if [ $? -ne 0 ] ; then
    popd
	  exit 1
  fi
  popd
  sudo cp -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz /mnt/elasticpi/build/nodejs/${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz
  rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz
fi
rm -f /tmp/node-v${N_VERSION}-linux-armv7l.tar.gz.sha256

# Replace NodeJS amd64 by ARMv7l in Kibana
sudo tar xzvf /mnt/elasticpi/build/nodejs/${N_VERSION}/node-v${N_VERSION}-linux-armv7l.tar.gz -C /usr/share/kibana && sudo mv /usr/share/kibana/node /usr/share/kibana/node.ori && sudo mv /usr/share/kibana/node-v${N_VERSION}-linux-armv7l /usr/share/kibana/node && sudo chown -R root:root /usr/share/kibana/node && sudo rm -rf /usr/share/kibana/node.ori

# Set Kibana Memory Configuration (Max 100mb of memory)
echo 'NODE_OPTIONS="--max-old-space-size=100"' | sudo tee -a /etc/default/kibana

# Set Kibana Node Configuration
sudo sed -i 's/.*server\.port:.*/server\.port: 5601/' /etc/kibana/kibana.yml
sudo sed -i 's/.*server\.host:.*/server\.host: "0.0.0.0"/' /etc/kibana/kibana.yml
sudo sed -i "s/.*elasticsearch\.url:.*/elasticsearch\.url: \"https:\/\/$e_ip:9202\"/" /etc/kibana/kibana.yml
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
