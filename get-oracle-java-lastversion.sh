#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Oracle Java last version


####### GET-ORACLE-JAVA-VERSION #######

# Install apt-key Prerequisites
sudo apt-get install dirmngr -q -y >/dev/null 2>/dev/null
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/webupd8team-java.list >/dev/null 2>/dev/null
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list >/dev/null 2>/dev/null
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 >/dev/null 2>/dev/null

# Get Oracle Java last version

sudo apt-get update >/dev/null 2>/dev/null
sudo apt-cache madison oracle-java8-installer | cut -d '|' -f 2 | tr -d ' '
