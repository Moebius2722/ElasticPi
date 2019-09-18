#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get OpenJDK installed version


####### COMMON #######

# Check if OpenJDK is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show openjdk-11-jdk >/dev/null 2>/dev/null; then
  echo "OpenJDK is not installed" >&2
  exit 1
fi


####### GET-ORACLE-JAVA-VERSION #######

# Get OpenJDK installed version

dpkg-query --showformat='${source:Upstream-Version}\n' --show openjdk-11-jdk 2>/dev/null | head -n 1
