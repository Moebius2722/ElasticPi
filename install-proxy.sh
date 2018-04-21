#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Proxy on Raspberry Pi 2 or 3


####### COMMON #######

####### SQUID #######

# Install Squid
sudo apt-get install squid3 -q -y

# Configure Squid for Authorized Local Subnet
sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.ori
sudo cat /etc/squid/squid.conf.ori | egrep -v -e '^[[:blank:]]*#|^$' | sudo tee /etc/squid/squid.conf
sudo sed -i '/acl CONNECT method CONNECT.*/a acl LocalNet src 192\.168\.0.0\/24' /etc/squid/squid.conf
sudo sed -i '/http_access allow localhost.*/a http_access allow LocalNet' /etc/squid/squid.conf

# Create Squid Cache
sudo mkdir /cache
echo -e 'tmpfs /cache tmpfs defaults,noatime,nosuid,size=500m 0 0' | sudo tee -a /etc/fstab
sudo mount /cache
echo -e 'cache_dir ufs /cache 400 16 256' | sudo tee -a /etc/squid/squid.conf
sudo systemctl stop squid.service
sudo squid -z
sudo systemctl start squid.service


####### SQUIDGUARD #######

SQUIDLIB=/var/lib/squidguard/db
SQUIDLIB_BLACKLISTS=$SQUIDLIB"/blacklists"

# Install SquidGuard
sudo apt-get install squidguard -q -y

# Get and Install SquidGuard Blacklists
rm -f /tmp/blacklists.tar.gz ; wget -P/tmp http://dsi.ut-capitole.fr/blacklists/download/blacklists.tar.gz && sudo rm -rf /var/lib/squidguard/db/blacklists && sudo tar -xzvf /tmp/blacklists.tar.gz -C /var/lib/squidguard/db

# Configure SquidGuard with Parents Class Exception

echo "#
# CONFIG FILE FOR SQUIDGUARD
#
# Caution: do NOT use comments inside { }
#

dbhome /var/lib/squidguard/db
logdir /var/log/squidguard

#
# TIME RULES:
# abbrev for weekdays:
# s = sun, m = mon, t =tue, w = wed, h = thu, f = fri, a = sat

time workhours {
        weekly mtwhf 08:00 - 16:30
        date *-*-01  08:00 - 16:30
}

#
# SOURCE ADDRESSES:
#

src parents {
        ip 192.168.0.1 192.168.0.30
}

#
# DESTINATION CLASSES:
#
# [see also in file dest-snippet.txt]

" | sudo tee /etc/squidguard/squidGuard.conf

# Configure SquidGuard Class Blacklists

if [ -d $SQUIDLIB_BLACKLISTS ]; then
    for folderName in `ls $SQUIDLIB_BLACKLISTS`; do
        if [ -d "$SQUIDLIB_BLACKLISTS/${folderName}" ]; then
            echo "dest ${folderName} {" | sudo tee -a  /etc/squidguard/squidGuard.conf
            if [ -e "$SQUIDLIB_BLACKLISTS/${folderName}/domains" ]; then
                echo "      domainlist blacklists/${folderName}/domains" | sudo tee -a  /etc/squidguard/squidGuard.conf
            fi
            if [ -e "$SQUIDLIB_BLACKLISTS/${folderName}/urls" ]; then
                echo "      urllist blacklists/${folderName}/urls" | sudo tee -a  /etc/squidguard/squidGuard.conf
            fi
            echo "      log ${folderName}accesses" | sudo tee -a  /etc/squidguard/squidGuard.conf
            echo "}" | sudo tee -a  /etc/squidguard/squidGuard.conf
        fi
    done
fi

# Configure SquidGuard Access Rules

echo -e '
#
# ACL RULES:
#

acl {
        parents {
                pass all
        }

        default {
                pass !porn all
                redirect 302:http://192.168.0.1/block.php?caddr=%a&cname=%n&user=%i&group=%s&target=%t&url=%u
        }
}
' | sudo tee -a  /etc/squidguard/squidGuard.conf


# Configure Squid for use SquidGuard

echo -e 'url_rewrite_program /usr/bin/squidGuard -c /etc/squidguard/squidGuard.conf' | sudo tee -a /etc/squid/squid.conf
echo -e 'access_log tcp://192.168.0.10:5011' | sudo tee -a /etc/squid/squid.conf


# Compile and Load Squid Configuration and Cache

sudo systemctl stop squid.service
sudo squidGuard -C all
sudo chown -R proxy:proxy /var/lib/squidguard/db
sudo squid3 -z
sudo systemctl start squid.service