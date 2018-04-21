#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Oracle Java installed version


####### COMMON #######

# Check if Oracle Java is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show oracle-java8-installer >/dev/null 2>/dev/null; then
  echo "Oracle Java is not installed" >&2
  exit 1
fi


####### GET-ORACLE-JAVA-VERSION #######

# Get Oracle Java installed version

dpkg-query --showformat='${source:Upstream-Version}\n' --show oracle-java8-installer
