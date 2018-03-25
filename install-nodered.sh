#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Lastest Node-RED on Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 3 ]] ; then
  echo "Usage : $0 Elasticsearch_IP Elasticsearch_User Elasticsearch_Password"
  exit 1
fi

# Get Elasticsearch IP
e_ip=$1

# Get Elasticsearch User
e_user=$2

# Get Elasticsearch Password
e_password=$3

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before install Node-RED"
  exit 1
fi

# Check if already installed
if get-nodered-version >/dev/null 2>/dev/null; then
  echo "Node-RED is already installed" >&2
  exit 1
fi

# Full System Update
if [[ ! "${PI_UPDATED}" = "1" ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi


####### NODERED #######

# Remove Old Node-RED
node-red-stop
sudo apt-get purge nodered -q -y

# Remove Old NodeJS
sudo apt-get purge nodejs nodejs-legacy -q -y
sudo apt-get purge npm -q -y
sudo apt-get autoremove -q -y

# Install Lastest NodeJS and some additional dependencies
curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
sudo apt-get install build-essential python-rpi.gpio nodejs -q -y

# Install Lastest Node-RED
sudo npm cache clean
#sudo npm install -g npm@2.x
hash -r
sudo npm install -g node-gyp
sudo npm install -g --unsafe-perm node-red

# Adding Autostart capability using SystemD
sudo wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/nodered.service -O /lib/systemd/system/nodered.service
sudo sed -i 's/Wants=/After=/' /lib/systemd/system/nodered.service
sudo sed -i 's/Nice=.*/Nice=1/' /lib/systemd/system/nodered.service
sudo sed -i 's/Restart=.*/Restart=always/' /lib/systemd/system/nodered.service
sudo wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/node-red-start -O /usr/bin/node-red-start
sudo wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/node-red-stop -O /usr/bin/node-red-stop
sudo chmod +x /usr/bin/node-red-st*
sudo /bin/systemctl daemon-reload

# Enable and start Node-RED daemon
start-nodered

# Install Node-RED-Admin Tool
sudo npm install -g node-red-admin

# Install Elasticsearch Node to Node-RED
node-red-admin install node-red-contrib-elasticsearchcdb

# Import Flows into Node-RED
stop-nodered
cp -f /opt/elasticpi/Node-RED/flows.json /home/pi/.node-red/flows_`hostname`.json
sudo sed -i "s/\[IP_ADDRESS\]/$e_ip/" /home/pi/.node-red/flows_`hostname`.json
sudo sed -i "s/\[USER\]/$e_user/" /home/pi/.node-red/flows_`hostname`.json
sudo sed -i "s/\[PASSWORD\]/$e_password/" /home/pi/.node-red/flows_`hostname`.json
start-nodered

# Install Mosquitto MQTT Server
sudo apt-get install mosquitto -q -y

# Enable and start Mosquitto daemon
sudo /bin/systemctl daemon-reload
start-mosquitto
