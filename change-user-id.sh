#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Change User ID Script on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 2 ]] ; then
  echo "Usage : $0 username newid" >&2
  exit 1
fi

# Get Username
username=$1

# Get New ID
newid=$2

# Check if user exist
getent passwd $username >/dev/null 2>/dev/null
if [[ $? -ne 0 ]]; then
  echo "User ""$username"" not exist" >&2
  exit 2
fi

# Check if new id is free
getent passwd $newid >/dev/null 2>/dev/null
if [[ $? -eq 0 ]]; then
  echo "New ID ""$newid"" is already used" >&2
  exit 3
fi

# Get User ID
userid=`getent passwd $username | cut -d: -f 3`


####### CHANGE-USER-ID #######

# Change User ID
sudo usermod -u $newid $username

# Update Owner User Files
sudo find / -uid $userid | xargs sudo chown $username
