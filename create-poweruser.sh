#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Create Power User (Sudo) Script for Elastic Stack on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 2 ]] ; then
  echo "Usage : $0 username password"
  exit 1
fi

# Get User Name
username=$1
password=$2

####### CREATE-POWERUSER #######

if getent passwd $username >/dev/null; then
    echo "User $username is already exist."
	sudo usermod -aG sudo $username
	exit 1
else
    echo "Create user $username"
	sudo useradd -m -p $(openssl passwd -1 ${password}) -s /bin/bash -G sudo ${username}
fi
