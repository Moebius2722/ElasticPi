#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get OpenJDK last version


####### GET-ORACLE-JAVA-VERSION #######

# Get OpenJDK last version

sudo apt-get update >/dev/null 2>/dev/null
sudo apt-cache madison openjdk-11-jdk | grep -i Packages | cut -d '|' -f 2 | tr -d ' ' | head -n 1
