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

#Create Logstash Build Folder
if [ ! -d "/mnt/elasticpi/build/logstash/${L_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/logstash/${L_VERSION}
  sudo chown -R logstash:logstash /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get and Check Logstash Debian Package
rm -f /tmp/logstash-${L_VERSION}.deb.sha512
wget -P/tmp https://artifacts.elastic.co/downloads/logstash/logstash-${L_VERSION}.deb.sha512
if [ -f "/mnt/elasticpi/build/logstash/${L_VERSION}/logstash-${L_VERSION}.deb" ]; then
  pushd /mnt/elasticpi/build/logstash/${L_VERSION}
  sha512sum -c /tmp/logstash-${L_VERSION}.deb.sha512
  if [ $? -ne 0 ] ; then
    rm -f /tmp/logstash-${L_VERSION}.deb
    wget -P/tmp https://artifacts.elastic.co/downloads/logstash/logstash-${L_VERSION}.deb
    pushd /tmp
    sha512sum -c /tmp/logstash-${L_VERSION}.deb.sha512
    if [ $? -ne 0 ] ; then
      exit 1
    fi
	popd
	sudo cp -f /tmp/logstash-${L_VERSION}.deb /mnt/elasticpi/build/logstash/${L_VERSION}/logstash-${L_VERSION}.deb
	rm -f /tmp/logstash-${L_VERSION}.deb
  fi
  popd
else
  rm -f /tmp/logstash-${L_VERSION}.deb
  wget -P/tmp https://artifacts.elastic.co/downloads/logstash/logstash-${L_VERSION}.deb
  pushd /tmp
  sha512sum -c /tmp/logstash-${L_VERSION}.deb.sha512
  if [ $? -ne 0 ] ; then
    popd
	exit 1
  fi
  popd
  sudo cp -f /tmp/logstash-${L_VERSION}.deb /mnt/elasticpi/build/logstash/${L_VERSION}/logstash-${L_VERSION}.deb
  rm -f /tmp/logstash-${L_VERSION}.deb
fi
rm -f /tmp/logstash-${L_VERSION}.deb.sha512

# Get JFFI Version
JFFI_LIB_PKG=`dpkg -c /mnt/elasticpi/build/logstash/${L_VERSION}/logstash-${L_VERSION}.deb | grep -i arm-Linux/libjffi`
JFFI_LIB=`echo ${JFFI_LIB_PKG} | cut -d . -f 2-`
#JFFI_LIB=`ls /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-*.so`
JFFI_VERSION=`echo ${JFFI_LIB::-3} | cut -d / -f 10 | cut -d - -f 2`
JFFI_LENGTH=$(( ${#JFFI_VERSION}+1 ))
JFFI_RELEASE=`curl -s "https://api.github.com/repos/jnr/jffi/tags" | jq -r "[ .[] | if .name | startswith(\"jffi-\") then .version=.name[5:] else .version=.name end | select( .version | startswith(\"$JFFI_VERSION\") ) | .version=.version[$JFFI_LENGTH:] | .version=( .version | tonumber ) ] | sort_by(.version) | reverse | .[0].name"`

#Create JFFI Build Folder
if [ ! -d "/mnt/elasticpi/build/jffi/${JFFI_RELEASE}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/jffi/${JFFI_RELEASE}
  sudo chown -R root:root /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

if [ -f /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so.sha512 ] && [ -f /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so ]; then
  pushd /mnt/elasticpi/build/jffi/${JFFI_RELEASE}
  sha512sum -c /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so.sha512
  if [ $? -ne 0 ] ; then
    # Get and Compile JFFI library for Logstash
    rm -rf /tmp/jffi ; sudo apt-get install ant texinfo -y && git clone -b $JFFI_RELEASE https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-${JFFI_VERSION}.so /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so && rm -rf /tmp/jffi && sudo sha512sum /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so | sudo tee /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so.sha512
  fi
  popd
else
  # Get and Compile JFFI library for Logstash
  rm -rf /tmp/jffi ; sudo apt-get install ant texinfo -y && git clone -b $JFFI_RELEASE https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-${JFFI_VERSION}.so /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so && rm -rf /tmp/jffi && sudo sha512sum /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so | sudo tee /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so.sha512
fi

# Fix Logstash Update Package
sudo cp -f /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so /lib/libjffi-1.2.so

# Update Logstash
sudo dpkg --force-confold --force-overwrite -i /mnt/elasticpi/build/logstash/${L_VERSION}/logstash-${L_VERSION}.deb

# Replace Logstash JFFI library
sudo cp -f /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so $JFFI_LIB
sudo chown logstash:logstash $JFFI_LIB

# Update Input Beats Plugin
sudo /usr/share/logstash/bin/logstash-plugin update logstash-input-beats

# Configure and Start Logstash as Daemon
sudo sed -i 's/Nice=.*/Nice=1/' /etc/systemd/system/logstash.service
sudo /bin/systemctl daemon-reload
start-logstash
