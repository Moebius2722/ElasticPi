#!/bin/sh

# Author : Moebius2722
# Mail : moebius2722@laposte.net

# Full Automated Installation Script for Lastest Node-RED on Raspberry Pi 2 or 3


####### COMMON #######

# Full System Update
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y


####### NODERED #######

# Remove Old Node-RED
node-red-stop
sudo apt-get remove nodered -q -y

# Remove Old NodeJS
sudo apt-get remove nodejs nodejs-legacy -q -y
sudo apt-get remove npm -q -y
sudo apt-get autoremove -q -y

# Install Lastest NodeJS and some additional dependencies
curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -
sudo apt-get install build-essential python-rpi.gpio nodejs -q -y

# Install Lastest Node-RED
sudo npm cache clean
sudo npm install -g npm@2.x
hash -r
sudo npm install -g node-gyp
sudo npm install -g --unsafe-perm node-red

# Adding Autostart capability using SystemD
sudo wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/nodered.service -O /lib/systemd/system/nodered.service
sudo sed -i 's/Wants=/After=/' /lib/systemd/system/nodered.service
sudo wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/node-red-start -O /usr/bin/node-red-start
sudo wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/node-red-stop -O /usr/bin/node-red-stop
sudo chmod +x /usr/bin/node-red-st*
sudo /bin/systemctl daemon-reload

# Enable and start Node-RED daemon
sudo /bin/systemctl enable nodered.service
sudo /bin/systemctl start nodered.service