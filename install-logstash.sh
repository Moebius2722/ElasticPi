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


####### LOGSTASH #######

# Install Logstash Prerequisites
install-oracle-java

#Create Logstash Build Folder
if [ ! -d "/mnt/elasticpi/build/logstash/${L_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/logstash/${L_VERSION}
  sudo chown -R root:root /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get and Check Logstash Debian Package
rm -f /tmp/logstash-oss-${L_VERSION}.deb.sha512
wget -P/tmp https://artifacts.elastic.co/downloads/logstash/logstash-oss-${L_VERSION}.deb.sha512
if [ -f "/mnt/elasticpi/build/logstash/${L_VERSION}/logstash-oss-${L_VERSION}.deb" ]; then
  pushd /mnt/elasticpi/build/logstash/${L_VERSION}
  sha512sum -c /tmp/logstash-oss-${L_VERSION}.deb.sha512
  if [ $? -ne 0 ] ; then
    rm -f /tmp/logstash-oss-${L_VERSION}.deb
    wget -P/tmp https://artifacts.elastic.co/downloads/logstash/logstash-oss-${L_VERSION}.deb
    pushd /tmp
    sha512sum -c /tmp/logstash-oss-${L_VERSION}.deb.sha512
    if [ $? -ne 0 ] ; then
      popd
      exit 1
    fi
	  popd
	  sudo cp -f /tmp/logstash-oss-${L_VERSION}.deb /mnt/elasticpi/build/logstash/${L_VERSION}/logstash-oss-${L_VERSION}.deb
	  rm -f /tmp/logstash-oss-${L_VERSION}.deb
  fi
  popd
else
  rm -f /tmp/logstash-oss-${L_VERSION}.deb
  wget -P/tmp https://artifacts.elastic.co/downloads/logstash/logstash-oss-${L_VERSION}.deb
  pushd /tmp
  sha512sum -c /tmp/logstash-oss-${L_VERSION}.deb.sha512
  if [ $? -ne 0 ] ; then
    popd
	  exit 1
  fi
  popd
  sudo cp -f /tmp/logstash-oss-${L_VERSION}.deb /mnt/elasticpi/build/logstash/${L_VERSION}/logstash-oss-${L_VERSION}.deb
  rm -f /tmp/logstash-oss-${L_VERSION}.deb
fi
rm -f /tmp/logstash-oss-${L_VERSION}.deb.sha512

# Get JFFI Version
JFFI_LIB_PKG=`dpkg -c /mnt/elasticpi/build/logstash/${L_VERSION}/logstash-oss-${L_VERSION}.deb | grep -i arm-Linux/libjffi`
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
    rm -rf /tmp/jffi ; sudo apt-get install ant texinfo -y && git clone -b $JFFI_RELEASE https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-${JFFI_VERSION}.so /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so && rm -rf /tmp/jffi && pushd /mnt/elasticpi/build/jffi/${JFFI_RELEASE} && sha512sum libjffi-${JFFI_VERSION}.so | sudo tee /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so.sha512 && popd
  fi
  popd
else
  # Get and Compile JFFI library for Logstash
  rm -rf /tmp/jffi ; sudo apt-get install ant texinfo -y && git clone -b $JFFI_RELEASE https://github.com/jnr/jffi.git /tmp/jffi && ant -f /tmp/jffi/build.xml jar && sudo cp -f /tmp/jffi/build/jni/libjffi-${JFFI_VERSION}.so /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so && rm -rf /tmp/jffi && pushd /mnt/elasticpi/build/jffi/${JFFI_RELEASE} && sha512sum libjffi-${JFFI_VERSION}.so | sudo tee /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so.sha512 && popd
fi

# Fix Logstash Installation Package
sudo cp -f /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so /lib/libjffi-1.2.so

# Install Logstash
sudo dpkg -i /mnt/elasticpi/build/logstash/${L_VERSION}/logstash-oss-${L_VERSION}.deb

# Replace Logstash JFFI library
sudo cp -f /mnt/elasticpi/build/jffi/${JFFI_RELEASE}/libjffi-${JFFI_VERSION}.so $JFFI_LIB
sudo chown logstash:logstash $JFFI_LIB

# Set Logstash Memory Configuration (Max 200mb of memory)
sudo sed -i 's/-Xms.*/-Xms200m/' /etc/logstash/jvm.options
sudo sed -i 's/-Xmx.*/-Xmx200m/' /etc/logstash/jvm.options
sudo sed -i 's/^#.*-server.*/-server/' /etc/logstash/jvm.options
sudo grep -q '^-server' /etc/logstash/jvm.options || echo | sudo tee -a /etc/logstash/jvm.options
sudo grep -q '^-server' /etc/logstash/jvm.options || echo "# force the server VM" | sudo tee -a /etc/logstash/jvm.options
sudo grep -q '^-server' /etc/logstash/jvm.options || echo "-server" | sudo tee -a /etc/logstash/jvm.options

# Disable X-Pack
#echo 'xpack.management.enabled: false' | sudo tee -a /etc/logstash/logstash.yml
#echo 'xpack.monitoring.enabled: false' | sudo tee -a /etc/logstash/logstash.yml

# Update Plugins
sudo /usr/share/logstash/bin/logstash-plugin update

# Install logstash-patterns-core Plugin
sudo /usr/share/logstash/bin/logstash-plugin install logstash-patterns-core

# Configure and Start Logstash as Daemon
sudo sed -i 's/Nice=.*/Nice=1/' /etc/systemd/system/logstash.service
sudo /bin/systemctl daemon-reload

# Set Logstash Node Configuration
configure-logstash $e_ip $e_user $e_password
