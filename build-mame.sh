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
sudo apt-get install git build-essential libfontconfig-dev qt5-default p7zip -q -y

# Get MAME Last Version
MAME_VERSION=`curl --silent "https://api.github.com/repos/mamedev/mame/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`

# Get MAME Last Release
MAME_RELEASE=`echo ${MAME_VERSION} | cut -c5-`

# Set Working Directory Variable
WORKDIR=${HOME}/build-mame

# Set MAME Git Directory
MAME_DIR=${WORKDIR}/${MAME_VERSION}

# Set Release MAME Directory
RELEASE_DIR=build/release/x32/Release/mame

# Set MAME Archive Name
MAME_ARCHIVE=mame${MAME_RELEASE}b_armhf.zip

####### BUILD-MAME #######

# Create MAME Working Directory
sudo rm -rf ${MAME_DIR}
mkdir -p ${MAME_DIR}

# Get MAME Sources
git clone -b ${MAME_VERSION} --depth 1 https://github.com/mamedev/mame.git ${MAME_DIR}

# Build MAME
pushd ${MAME_DIR}
make REGENIE=1 TOOLS=1 -j1

# Get MAME Build Package Tools
git clone https://github.com/mamedev/build.git ${WORKDIR}/build

# Create Package
echo Starting release of MAME ${MAME_RELEASE} ...
echo Remove old release directories ...
rm -rf build/release
echo Copy files MAME 32-bit Release build ...
make -f dist.mak all
cp -f ../build/whatsnew/whatsnew_${MAME_RELEASE}.txt ${RELEASE_DIR}/whatsnew.txt
mkdir ${RELEASE_DIR}/artwork
cp -rf artwork/* ${RELEASE_DIR}/artwork
mkdir ${RELEASE_DIR}/bgfx
cp -rf bgfx/* ${RELEASE_DIR}/bgfx
mkdir ${RELEASE_DIR}/hlsl
cp -rf hlsl/* ${RELEASE_DIR}/hlsl
mkdir ${RELEASE_DIR}/plugins
cp -rf plugins/* ${RELEASE_DIR}/plugins
mkdir ${RELEASE_DIR}/samples
cp -rf samples/* ${RELEASE_DIR}/samples
mkdir ${RELEASE_DIR}/ini/examples
cp -rf ini/examples/* ${RELEASE_DIR}/ini/examples

echo Packing ${MAME_ARCHIVE}
pushd ${RELEASE_DIR}
7za a -mpass=4 -mfb=255 -y -tzip  "../../../${MAME_ARCHIVE}"
popd

echo Calculating digests....
pushd build/release
sha1sum ${MAME_ARCHIVE} > ${MAME_ARCHIVE}.sha1
sha256sum ${MAME_ARCHIVE} > ${MAME_ARCHIVE}.sha256
rm -rf x32
popd

popd
