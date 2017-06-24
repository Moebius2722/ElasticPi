#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Logstash on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${L_VERSION} = '' ]]; then
  L_VERSION=`wget https://www.elastic.co/downloads/logstash/ -qO- | grep -i "\.deb\" class=\"zip-link\">" | cut -d '"' -f 2 | cut -d / -f 6 | cut -d - -f 2 | cut -d . -f 1-3 | head -n 1`
fi

# Full System Update
if [[ ! "${PI_UPDATED}" = "1" ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi


####### LOGSTASH #######

# Get and Install Logstash
wget -P/tmp https://artifacts.elastic.co/downloads/logstash/logstash-${L_VERSION}.deb && sudo dpkg -i /tmp/logstash-${L_VERSION}.deb && rm -f /tmp/logstash-${L_VERSION}.deb

# Get and Compile JFFI library for Logstash
sudo apt-get install ant texinfo -y && git clone https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-1.2.so /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so && sudo chown logstash:logstash /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so && rm -rf /tmp/jffi

# Set Logstash Memory Configuration (Max 200mb of memory)
sudo sed -i 's/-Xms.*/-Xms200m/' /etc/logstash/jvm.options
sudo sed -i 's/-Xmx.*/-Xmx200m/' /etc/logstash/jvm.options

# Set Logstash Node Configuration
sudo cp -f `dirname $0`/Logstash/00-default.conf /etc/logstash/conf.d/00-default.conf

# Configure and Start Logstash as Daemon
sudo sed -i 's/Nice=.*/Nice=1/' /etc/systemd/system/logstash.service
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable logstash.service
sudo /bin/systemctl start logstash.service
