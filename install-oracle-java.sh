#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Oracle Java on Raspberry Pi 2 or 3


####### COMMON #######

# Check if already installed
if get-oracle-java-version >/dev/null 2>/dev/null; then
  echo "Oracle Java is already installed" >&2
  exit 1
fi


####### ORACLE-JAVA #######

# Install apt-key Prerequisites
sudo apt-get install dirmngr -q -y

# Get and Install Oracle Java
# echo "deb http://ppa.launchpad.net/linuxuprising/java/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/linuxuprising-java.list
# echo "deb-src http://ppa.launchpad.net/linuxuprising/java/ubuntu bionic main" | sudo tee -a /etc/apt/sources.list.d/linuxuprising-java.list
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 73C3DB2A
sudo apt-get update
# echo oracle-java12-installer shared/accepted-oracle-license-v1-2 select true | sudo /usr/bin/debconf-set-selections
# sudo apt-get install oracle-java12-set-default oracle-java12-installer -q -y
sudo apt-get install openjdk-11-jdk -q -y
#--allow-unauthenticated
