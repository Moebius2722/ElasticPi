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
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install oracle-java8-set-default oracle-java8-installer -q -y --allow-unauthenticated
