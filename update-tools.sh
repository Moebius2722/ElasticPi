#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for ElasticPi Tools on Raspberry Pi 2 or 3


####### TOOLS #######
sudo rm -rf /opt/elasticpi ; sudo git clone https://github.com/Moebius2722/ElasticPi.git /opt/elasticpi ; sudo chmod -R a+x /opt/elasticpi/*.sh
for tool in `sudo ls /opt/elasticpi/*.sh  | cut -d '/' -f 4 | cut -d '.' -f 1`
do
echo "/usr/bin/$tool => /opt/elasticpi/$tool.sh"
sudo ln -sf "/opt/elasticpi/$tool.sh" "/usr/bin/$tool"
done
for svc in elasticsearch logstash kibana nginx cerebro nodered mosquitto keepalived
do
sudo ln -sf "/usr/bin/start-service" "/usr/bin/start-$svc"
done
