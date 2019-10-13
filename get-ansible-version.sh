#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Ansible installed version


####### GET-ANSIBLE-VERSION #######

# Check if Ansible is installed

if ! dpkg-query --showformat='${source:Upstream-Version}\n' --show ansible >/dev/null 2>/dev/null; then
  echo "Ansible is not installed" >&2
  exit 1
else
  # Get Ansible installed version
  dpkg-query --showformat='${source:Upstream-Version}\n' --show ansible 2>/dev/null | head -n 1
  exit 0
fi
