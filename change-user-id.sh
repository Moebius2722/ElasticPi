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

getent passwd $username >/dev/null 2>/dev/null
if [[ $? -ne 0 ]]; then
  echo "User ""$username"" not exist" >&2
  exit 2
fi

getent passwd $newid >/dev/null 2>/dev/null
if [[ $? -eq 0 ]]; then
  echo "New ID ""$newid"" is already used" >&2
  exit 3
fi


####### CHANGE-USER-ID #######

# Get files owned by user
sudo find / -user $username >"/tmp/${username}_usr_files.lst"

# Change User ID
sudo usermod -u $newid $username

# Update Owner User Files
cat "/tmp/${username}_usr_files.lst" | xargs sudo chown $username

# Remove temporary file
rm -f "/tmp/${username}_usr_files.lst"
