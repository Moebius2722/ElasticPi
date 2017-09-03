#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for ElasticPi Tools on Raspberry Pi 2 or 3


####### TOOLS #######
sudo rm -rf /opt/elasticpi ; sudo git clone  ; sudo chmod -R a+x /opt/elasticpi/*.sh
for tool in `sudo ls /opt/elasticpi/*.sh  | cut -d '/' -f 4 | cut -d '.' -f 1`
do
echo "/usr/bin/$tool => /opt/elasticpi/$tool.sh"
sudo ln -sf "/opt/elasticpi/$tool.sh" "/usr/bin/$tool"
done
for svc in elasticsearch logstash kibana nginx cerebro nodered mosquitto keepalived
do
echo "/usr/bin/check-$svc => /usr/bin/check-service"
sudo ln -sf "/usr/bin/check-service" "/usr/bin/check-$svc"
echo "/usr/bin/start-$svc => /usr/bin/start-service"
sudo ln -sf "/usr/bin/start-service" "/usr/bin/start-$svc"
echo "/usr/bin/stop-$svc => /usr/bin/stop-service"
sudo ln -sf "/usr/bin/stop-service" "/usr/bin/stop-$svc"
echo "/usr/bin/restart-$svc => /usr/bin/restart-service"
sudo ln -sf "/usr/bin/restart-service" "/usr/bin/restart-$svc"
done
