#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Build Script for MAME on Raspberry Pi 2 or 3

# For run on clean installation
# curl -sL https://github.com/Moebius2722/ElasticPi/raw/master/build-mame.sh | bash -

####### COMMON #######

# Set SWAP to 2GB
sudo sed -i "s/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=2048/" /etc/dphys-swapfile
sudo systemctl restart dphys-swapfile.service

# Install Prerequisites
sudo apt-get install git build-essential libfontconfig-dev qt5-default -q -y

# Get MAME Last Version
MAME_VERSION=`curl --silent "https://api.github.com/repos/mamedev/mame/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`

# Set Working Directory Variable
WORKDIR=${HOME}/buid-mame

# Set MAME Git Directory
MAME_DIR=${WORKDIR}/${MAME_VERSION}


####### BUILD-MAME #######

# Create MAME Working Directory
sudo rm -rf ${MAME_DIR}
mkdir -p ${MAME_DIR}

# Get MAME Sources
git clone -b ${MAME_VERSION} --depth 1 https://github.com/mamedev/mame.git ${MAME_DIR}

# Build MAME
pushd ${MAME_DIR}
make REGENIE=1 TOOLS=1 -j1

# Install MAME
#sudo make install
popd
