#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Build Script for SDL on Raspberry Pi 2 or 3

# For run on clean installation
# curl -sL https://github.com/Moebius2722/ElasticPi/raw/master/build-sdl.sh | bash -

####### COMMON #######

# Set SWAP to 2GB
sudo sed -i "s/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=2048/" /etc/dphys-swapfile
sudo systemctl restart dphys-swapfile.service

# Remove Old SDL library
sudo apt-get remove -y --force-yes libsdl2-dev
sudo apt-get autoremove -y

# Install Prerequisites
sudo apt-get install hg libfontconfig-dev qt5-default automake mercurial libtool libfreeimage-dev libopenal-dev libpango1.0-dev libsndfile-dev libudev-dev libtiff5-dev libwebp-dev libasound2-dev libaudio-dev libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev libxss-dev libesd0-dev freeglut3-dev libmodplug-dev libsmpeg-dev libjpeg-dev -y -q

# Set Working Directory Variable
WORKDIR=${HOME}/buid-sdl

# Set SDL Mercurial Directory
SDL_DIR=${WORKDIR}/sdl

# Set SDL_image Mercurial Directory
SDL_image_DIR=${WORKDIR}/sdl_image

# Set SDL_mixer Mercurial Directory
SDL_mixer_DIR=${WORKDIR}/sdl_mixer

# Set SDL_net Mercurial Directory
SDL_net_DIR=${WORKDIR}/sdl_net

# Set SDL_ttf Mercurial Directory
SDL_ttf_DIR=${WORKDIR}/sdl_ttf


####### BUILD-SDL #######

# Create SDL Working Directory
sudo rm -rf ${SDL_DIR}
mkdir -p ${SDL_DIR}

# Get SDL Sources
hg clone http://hg.libsdl.org/SDL ${SDL_DIR}

# Build SDL
pushd ${SDL_DIR}
./autogen.sh
./configure --disable-pulseaudio --disable-esd --disable-video-mir --disable-video-wayland --disable-video-opengl --host=arm-raspberry-linux-gnueabihf
make

# Install New SDL
sudo make install
popd


####### BUILD-SDL_image #######

# Create SDL_image Working Directory
sudo rm -rf ${SDL_image_DIR}
mkdir -p ${SDL_image_DIR}

# Get SDL_image Sources
hg clone http://hg.libsdl.org/SDL_image ${SDL_image_DIR}

# Build SDL_image
pushd ${SDL_image_DIR}
./autogen.sh
./configure
make

# Install New SDL_image
sudo make install
popd


####### BUILD-SDL_mixer #######

# Create SDL_mixer Working Directory
sudo rm -rf ${SDL_mixer_DIR}
mkdir -p ${SDL_mixer_DIR}

# Get SDL_mixer Sources
hg clone http://hg.libsdl.org/SDL_mixer ${SDL_mixer_DIR}

# Build SDL_mixer
pushd ${SDL_mixer_DIR}
./autogen.sh
./configure
make

# Install New SDL_mixer
sudo make install
popd


####### BUILD-SDL_net #######

# Create SDL_net Working Directory
sudo rm -rf ${SDL_net_DIR}
mkdir -p ${SDL_net_DIR}

# Get SDL_net Sources
hg clone http://hg.libsdl.org/SDL_net ${SDL_net_DIR}

# Build SDL_net
pushd ${SDL_net_DIR}
./autogen.sh
./configure
make

# Install New SDL_net
sudo make install
popd


####### BUILD-SDL_ttf #######

# Create SDL_ttf Working Directory
sudo rm -rf ${SDL_ttf_DIR}
mkdir -p ${SDL_ttf_DIR}

# Get SDL_ttf Sources
hg clone http://hg.libsdl.org/SDL_ttf ${SDL_ttf_DIR}

# Build SDL_ttf
pushd ${SDL_ttf_DIR}
./autogen.sh
./configure
make

# Install New SDL_ttf
sudo make install
popd
