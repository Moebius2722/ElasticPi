#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Logstash on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${L_VERSION} = '' ]]; then
  L_VERSION=`get-logstash-lastversion`
fi

# Check if already up to date
L_CVERSION=`get-logstash-version`
if [ $? -ne 0 ] ; then
  exit 1
fi
if [[ "${L_VERSION}" = "${L_CVERSION}" ]]; then
  echo "Logstash is already up to date to ${L_CVERSION} version"
  exit 0
fi
echo "Update Logstash ${L_CVERSION} to ${L_VERSION}"

# Stop Logstash Daemon
stop-logstash


####### LOGSTASH #######

# Get and Update Logstash
rm -f /tmp/logstash-${L_VERSION}.deb ; wget -P/tmp https://artifacts.elastic.co/downloads/logstash/logstash-${L_VERSION}.deb && sudo dpkg --force-confold --force-overwrite -i /tmp/logstash-${L_VERSION}.deb && rm -f /tmp/logstash-${L_VERSION}.deb

# Get and Compile JFFI library for Logstash
git clone https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-1.2.so /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so && sudo chown logstash:logstash /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so && rm -rf /tmp/jffi

# Configure and Start Logstash as Daemon
sudo sed -i 's/Nice=.*/Nice=1/' /etc/systemd/system/logstash.service
sudo /bin/systemctl daemon-reload
start-logstash