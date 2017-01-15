#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Update Script for Logstash on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${L_VERSION} = '' ]]; then
  L_VERSION=5.1.2
fi

# Check if already up to date
L_CVERSION=`dpkg-query -W -f='${Version}\n' logstash | cut -d : -f2 | cut -d - -f1`
if [[ "${L_VERSION}" = "${L_CVERSION}" ]]; then
  echo "Logstash is up to date to ${L_CVERSION} version"
  exit 0
fi

# Stop Logstash Daemon
sudo /bin/systemctl stop logstash.service

# Full System Update
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update


####### LOGSTASH #######

# Get and Update Logstash
wget -P/tmp https://artifacts.elastic.co/downloads/logstash/logstash-${L_VERSION}.deb && sudo dpkg --force-confold --force-overwrite -i /tmp/logstash-${L_VERSION}.deb

# Get and Compile JFFI library for Logstash
git clone https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-1.2.so /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so && sudo chown logstash:logstash /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so

# Configure and Start Logstash as Daemon
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable logstash.service
sudo /bin/systemctl start logstash.service
