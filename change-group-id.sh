#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Change Group ID Script on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 2 ]] ; then
  echo "Usage : $0 groupname newid" >&2
  exit 1
fi

# Get Groupname
groupname=$1

# Get New ID
newid=$2

# Check if group exist
getent group $groupname >/dev/null 2>/dev/null
if [[ $? -ne 0 ]]; then
  echo "Group ""$groupname"" not exist" >&2
  exit 2
fi

# Check if new id is free
getent group $newid >/dev/null 2>/dev/null
if [[ $? -eq 0 ]]; then
  echo "New ID ""$newid"" is already used" >&2
  exit 3
fi

# Get Group ID
groupid=`getent group $groupname | cut -d: -f 3`


####### CHANGE-USER-ID #######

# Change User ID
sudo groupmod -g $newid $groupname

# Get user with this principal group
getent passwd | grep "^.*:x:.*:${groupid}:.*" | cut -d ':' -f 1 | sudo usermod -g $groupname

# Update Owner User Files
sudo find / -gid $groupid | xargs sudo chown :$groupname
