#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Logstash on Raspberry Pi 2 or 3


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
  echo "Create cluster before install Logstash"
  exit 1
fi

# Check if already installed
if get-logstash-version >/dev/null 2>/dev/null; then
  echo "Logstash is already installed" >&2
  exit 1
fi

# Set Version
if [[ ${L_VERSION} = '' ]]; then
  L_VERSION=`get-logstash-maxversion`
  if [[ ${L_VERSION} = '' ]]; then
    L_VERSION=`get-logstash-lastversion`
  fi
fi

# Full System Update
if [[ ! "${PI_UPDATED}" = "1" ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi


####### LOGSTASH #######

# Install Logstash Prerequisites
install-oracle-java

# Get and Compile JFFI library for Install Logstash
sudo apt-get install ant texinfo -y && git clone https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-1.2.so /lib/libjffi-1.2.so && rm -rf /tmp/jffi

# Get and Install Logstash
rm -f /tmp/logstash-${L_VERSION}.deb ; wget -P/tmp https://artifacts.elastic.co/downloads/logstash/logstash-${L_VERSION}.deb && sudo dpkg -i /tmp/logstash-${L_VERSION}.deb && rm -f /tmp/logstash-${L_VERSION}.deb

# Get and Compile JFFI library for Launch Logstash
sudo cp -f /lib/libjffi-1.2.so /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so && sudo chown logstash:logstash /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so

# Set Logstash Memory Configuration (Max 200mb of memory)
sudo sed -i 's/-Xms.*/-Xms200m/' /etc/logstash/jvm.options
sudo sed -i 's/-Xmx.*/-Xmx200m/' /etc/logstash/jvm.options
echo "-server" | sudo tee -a /etc/logstash/jvm.options

# Set Logstash Node Configuration
sudo cp -f /opt/elasticpi/Logstash/00-default.conf /etc/logstash/conf.d/00-default.conf
sudo sed -i "s/\[IP_ADDRESS\]/$e_ip/" /etc/logstash/conf.d/00-default.conf
sudo sed -i "s/\[USER\]/$e_user/" /etc/logstash/conf.d/00-default.conf
sudo sed -i "s/\[PASSWORD\]/$e_password/" /etc/logstash/conf.d/00-default.conf

# Configure and Start Logstash as Daemon
sudo sed -i 's/Nice=.*/Nice=1/' /etc/systemd/system/logstash.service
sudo /bin/systemctl daemon-reload
start-logstash
