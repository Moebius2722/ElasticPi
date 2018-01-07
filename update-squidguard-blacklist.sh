#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Squidguard Blacklist for Raspberry Pi 2 or 3


####### UPDATE-SQUIDGUARD-BLACKLIST #######

#Update Squidguard Blacklist

rm -f /tmp/blacklists.tar.gz ; wget -P/tmp http://dsi.ut-capitole.fr/blacklists/download/blacklists.tar.gz && sudo rm -rf /var/lib/squidguard/db/blacklists && sudo tar -xzvf /tmp/blacklists.tar.gz -C /var/lib/squidguard/db && sudo squidGuard -C all && sudo chown -R proxy:proxy /var/lib/squidguard/db && sudo systemctl restart squid.service
