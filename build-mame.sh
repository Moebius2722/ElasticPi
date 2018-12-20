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
sudo apt-get install git build-essential libfontconfig-dev qt5-default p7zip-full -q -y

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
#make REGENIE=1 TOOLS=1 -j1
make TARGET=mame TOOLS=1 SEPARATE_BIN=1 PTR64=0 OPTIMIZE=3 SYMBOLS=1 SYMLEVEL=1 REGENIE=1 -j1
make -f dist.mak PTR64=0

# Get MAME Build Package Tools
git clone https://github.com/mamedev/build.git ${WORKDIR}/build

# Create Package
echo Starting release of MAME ${MAME_RELEASE} ...
echo Remove old release directories ...
rm -f build\release\*.zip build\release\*.txt

echo Creating release directories ...
mkdir build\release\x32\Release\mame 2>/dev/null
cp -f ../build/whatsnew/whatsnew_${MAME_RELEASE}.txt ${RELEASE_DIR}/whatsnew.txt >/dev/null
echo Copy files MAME 32-bit Release build ...
mkdir ${RELEASE_DIR}/artwork 2>/dev/null
cp -rf artwork/* ${RELEASE_DIR}/artwork
mkdir ${RELEASE_DIR}/bgfx 2>/dev/null
cp -rf bgfx/* ${RELEASE_DIR}/bgfx
mkdir ${RELEASE_DIR}/hlsl 2>/dev/null
cp -rf hlsl/* ${RELEASE_DIR}/hlsl
mkdir ${RELEASE_DIR}/plugins 2>/dev/null
cp -rf plugins/* ${RELEASE_DIR}/plugins
mkdir ${RELEASE_DIR}/samples 2>/dev/null
cp -rf samples/* ${RELEASE_DIR}/samples
# Add Missing files and folders in dist.mak
mkdir ${RELEASE_DIR}/ini/examples 2>/dev/null
cp -rf ini/examples/* ${RELEASE_DIR}/ini/examples
cp -fR pngcmp ${RELEASE_DIR}/pngcmp
cp -fR regrep ${RELEASE_DIR}/regrep
cp -fR split ${RELEASE_DIR}/split
cp -fR src2html ${RELEASE_DIR}/src2html
cp -fR srcclean ${RELEASE_DIR}/srcclean
popd

echo Packing ${MAME_ARCHIVE}
pushd ${MAME_DIR}/${RELEASE_DIR}
7za a -mpass=4 -mfb=255 -y -tzip  "../../../${MAME_ARCHIVE}"
popd

echo Calculating digests....
pushd ${MAME_DIR}/build/release
sha1sum ${MAME_ARCHIVE} > ${MAME_ARCHIVE}.sha1
sha256sum ${MAME_ARCHIVE} > ${MAME_ARCHIVE}.sha256
rm -rf x32
popd
