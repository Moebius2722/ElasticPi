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
sudo apt-get install checkinstall libfontconfig-dev qt5-default automake mercurial libtool libfreeimage-dev libopenal-dev libpango1.0-dev libsndfile-dev libudev-dev libtiff5-dev libwebp-dev libasound2-dev libaudio-dev libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev libxss-dev libesd0-dev freeglut3-dev libmodplug-dev libsmpeg-dev libjpeg-dev -y -q

# Set Working Directory Variable
WORKDIR=${HOME}/buid-sdl

# Get Last SDL Release
SDL_RELEASE=`curl --silent "http://hg.libsdl.org/SDL/tags" | grep 'release-' | cut -d '>' -f 4 | cut -d '<' -f 1 | sort -V -r | head -1`

# Set SDL Mercurial Directory
SDL_DIR=${WORKDIR}/sdl/${SDL_RELEASE}

# Get Last SDL_image Release
SDL_image_RELEASE=`curl --silent "http://hg.libsdl.org/SDL_image/tags" | grep 'release-' | cut -d '>' -f 4 | cut -d '<' -f 1 | sort -V -r | head -1`

# Set SDL_image Mercurial Directory
SDL_image_DIR=${WORKDIR}/sdl_image/${SDL_image_RELEASE}

# Get Last SDL_mixer Release
SDL_mixer_RELEASE=`curl --silent "http://hg.libsdl.org/SDL_mixer/tags" | grep 'release-' | cut -d '>' -f 4 | cut -d '<' -f 1 | sort -V -r | head -1`

# Set SDL_mixer Mercurial Directory
SDL_mixer_DIR=${WORKDIR}/sdl_mixer/${SDL_mixer_RELEASE}

# Get Last SDL_net Release
SDL_net_RELEASE=`curl --silent "http://hg.libsdl.org/SDL_net/tags" | grep 'release-' | cut -d '>' -f 4 | cut -d '<' -f 1 | sort -V -r | head -1`

# Set SDL_net Mercurial Directory
SDL_net_DIR=${WORKDIR}/sdl_net/${SDL_net_RELEASE}

# Get Last SDL_ttf Release
SDL_ttf_RELEASE=`curl --silent "http://hg.libsdl.org/SDL_ttf/tags" | grep 'release-' | cut -d '>' -f 4 | cut -d '<' -f 1 | sort -V -r | head -1`

# Set SDL_ttf Mercurial Directory
SDL_ttf_DIR=${WORKDIR}/sdl_ttf/${SDL_ttf_RELEASE}


####### BUILD-SDL #######

# Create SDL Working Directory
sudo rm -rf ${SDL_DIR}
mkdir -p ${SDL_DIR}

# Get SDL Sources
hg clone -u ${SDL_RELEASE} http://hg.libsdl.org/SDL ${SDL_DIR}

# Build SDL
pushd ${SDL_DIR}
./autogen.sh
./configure --disable-pulseaudio --disable-esd --disable-video-mir --disable-video-wayland --disable-video-opengl --host=arm-raspberry-linux-gnueabihf
make

# Create SDL Debian Package
SDL_VERSION=`echo ${SDL_RELEASE} | cut -d '-' -f 2`
echo 'Simple DirectMedia Layer
 SDL is a library that allows programs portable low level access to a video
 framebuffer, audio output, mouse, and keyboard.
 .
 This version of SDL is compiled with X11 and Wayland graphics drivers and OSS,
 ALSA, sndio and PulseAudio sound drivers.' | sudo tee description-pak
sudo checkinstall -D --install=no -y --pkgname="libsdl2-${SDL_VERSION}" --pkgversion="${SDL_VERSION}" --pkgarch='armhf' --pkgrelease="${SDL_VERSION}" --pkglicense='ZLIB' --pkggroup='libs' --pkgsource='libsdl2' --pkgaltsource='' --maintainer='pkg-sdl-maintainers@lists.alioth.debian.org' --provides='' --requires='' --conflicts='' --replaces='' --nodoc --deldoc=yes --deldesc=yes --delspec=yes --backup=no
sudo rm -f description-pak
cp "libsdl2-${SDL_VERSION}_${SDL_VERSION}-${SDL_VERSION}_armhf.deb"  ../.
sudo rm -f "libsdl2-${SDL_VERSION}_${SDL_VERSION}-${SDL_VERSION}_armhf.deb"

# Install New SDL
sudo dpkg -i ../"libsdl2-${SDL_VERSION}_${SDL_VERSION}-${SDL_VERSION}_armhf.deb"
popd


####### BUILD-SDL_image #######

# Create SDL_image Working Directory
sudo rm -rf ${SDL_image_DIR}
mkdir -p ${SDL_image_DIR}

# Get SDL_image Sources
hg clone -u ${SDL_image_RELEASE} http://hg.libsdl.org/SDL_image ${SDL_image_DIR}

# Build SDL_image
pushd ${SDL_image_DIR}
./autogen.sh
./configure
make

# Create SDL_image Debian Package
SDL_image_VERSION=`echo ${SDL_image_RELEASE} | cut -d '-' -f 2`
echo 'Image loading library for Simple DirectMedia Layer 2, libraries
  This is a simple library to load images of various formats as SDL surfaces.  It
  supports the following formats: BMP, GIF, JPEG, LBM, PCX, PNG, PNM, TGA, TIFF,
  WEBP, XCF, XPM, XV.
  .
  This package contains the shared library.' | sudo tee description-pak
sudo checkinstall -D --install=no -y --pkgname="libsdl2-image-${SDL_image_VERSION}" --pkgversion="${SDL_image_VERSION}" --pkgarch='armhf' --pkgrelease="${SDL_image_VERSION}" --pkglicense='ZLIB' --pkggroup='libs' --pkgsource='libsdl2-image' --pkgaltsource='' --maintainer='pkg-sdl-maintainers@lists.alioth.debian.org' --provides='' --requires='' --conflicts='' --replaces='' --nodoc --deldoc=yes --deldesc=yes --delspec=yes --backup=no
sudo rm -f description-pak
cp "libsdl2-image-${SDL_image_VERSION}_${SDL_image_VERSION}-${SDL_image_VERSION}_armhf.deb"  ../.
sudo rm -f "libsdl2-image-${SDL_image_VERSION}_${SDL_image_VERSION}-${SDL_image_VERSION}_armhf.deb"

# Install New SDL_image
sudo dpkg -i ../"libsdl2-image-${SDL_image_VERSION}_${SDL_image_VERSION}-${SDL_image_VERSION}_armhf.deb"
popd


####### BUILD-SDL_mixer #######

# Create SDL_mixer Working Directory
sudo rm -rf ${SDL_mixer_DIR}
mkdir -p ${SDL_mixer_DIR}

# Get SDL_mixer Sources
hg clone -u ${SDL_mixer_RELEASE} http://hg.libsdl.org/SDL_mixer ${SDL_mixer_DIR}

# Build SDL_mixer
pushd ${SDL_mixer_DIR}
./autogen.sh
./configure
make

# Create SDL_mixer Debian Package
SDL_mixer_VERSION=`echo ${SDL_mixer_RELEASE} | cut -d '-' -f 2`
echo 'Mixer library for Simple DirectMedia Layer 2, libraries
  SDL_mixer is a sample multi-channel audio mixer library.  It supports any
  number of simultaneously playing channels of 16 bit stereo audio, plus a single
  channel of music, mixed by the popular FLAC, modplug MOD, FluidSynth and
  Timidity MIDI, Ogg Vorbis, and MAD or SMPEG MP3 libraries.
  .
  This package contains the shared library.' | sudo tee description-pak
sudo checkinstall -D --install=no -y --pkgname="libsdl2-mixer-${SDL_mixer_VERSION}" --pkgversion="${SDL_mixer_VERSION}" --pkgarch='armhf' --pkgrelease="${SDL_mixer_VERSION}" --pkglicense='ZLIB' --pkggroup='libs' --pkgsource='libsdl2-mixer' --pkgaltsource='' --maintainer='pkg-sdl-maintainers@lists.alioth.debian.org' --provides='' --requires='' --conflicts='' --replaces='' --nodoc --deldoc=yes --deldesc=yes --delspec=yes --backup=no
sudo rm -f description-pak
cp "libsdl2-mixer-${SDL_mixer_VERSION}_${SDL_mixer_VERSION}-${SDL_mixer_VERSION}_armhf.deb"  ../.
sudo rm -f "libsdl2-mixer-${SDL_mixer_VERSION}_${SDL_mixer_VERSION}-${SDL_mixer_VERSION}_armhf.deb"

# Install New SDL_mixer
sudo dpkg -i ../"libsdl2-mixer-${SDL_mixer_VERSION}_${SDL_mixer_VERSION}-${SDL_mixer_VERSION}_armhf.deb"
popd


####### BUILD-SDL_net #######

# Create SDL_net Working Directory
sudo rm -rf ${SDL_net_DIR}
mkdir -p ${SDL_net_DIR}

# Get SDL_net Sources
hg clone -u ${SDL_net_RELEASE} http://hg.libsdl.org/SDL_net ${SDL_net_DIR}

# Build SDL_net
pushd ${SDL_net_DIR}
./autogen.sh
./configure
make

# Create SDL_net Debian Package
SDL_net_VERSION=`echo ${SDL_net_RELEASE} | cut -d '-' -f 2`
echo 'Network library for Simple DirectMedia Layer 2, libraries
  This is a small, low-level, cross-platform networking library, that can be used
  with the Simple DirectMedia Layer library.
  .
  This package contains the shared library.' | sudo tee description-pak
sudo checkinstall -D --install=no -y --pkgname="libsdl2-net-${SDL_net_VERSION}" --pkgversion="${SDL_net_VERSION}" --pkgarch='armhf' --pkgrelease="${SDL_net_VERSION}" --pkglicense='ZLIB' --pkggroup='libs' --pkgsource='libsdl2-net' --pkgaltsource='' --maintainer='pkg-sdl-maintainers@lists.alioth.debian.org' --provides='' --requires='' --conflicts='' --replaces='' --nodoc --deldoc=yes --deldesc=yes --delspec=yes --backup=no
sudo rm -f description-pak
cp "libsdl2-net-${SDL_net_VERSION}_${SDL_net_VERSION}-${SDL_net_VERSION}_armhf.deb"  ../.
sudo rm -f "libsdl2-net-${SDL_net_VERSION}_${SDL_net_VERSION}-${SDL_net_VERSION}_armhf.deb"

# Install New SDL_net
sudo dpkg -i ../"libsdl2-net-${SDL_net_VERSION}_${SDL_net_VERSION}-${SDL_net_VERSION}_armhf.deb"
popd


####### BUILD-SDL_ttf #######

# Create SDL_ttf Working Directory
sudo rm -rf ${SDL_ttf_DIR}
mkdir -p ${SDL_ttf_DIR}

# Get SDL_ttf Sources
hg clone -u ${SDL_ttf_RELEASE} http://hg.libsdl.org/SDL_ttf ${SDL_ttf_DIR}

# Build SDL_ttf
pushd ${SDL_ttf_DIR}
./autogen.sh
./configure
make

# Create SDL_ttf Debian Package
SDL_ttf_VERSION=`echo ${SDL_ttf_RELEASE} | cut -d '-' -f 2`
echo 'TrueType Font library for Simple DirectMedia Layer 2, libraries
  Wrapper around FreeType 2.0 library, making possible to use TrueType fonts to
  render text in SDL applications.
  .
  This package contains the shared library.' | sudo tee description-pak
sudo checkinstall -D --install=no -y --pkgname="libsdl2-ttf-${SDL_ttf_VERSION}" --pkgversion="${SDL_ttf_VERSION}" --pkgarch='armhf' --pkgrelease="${SDL_ttf_VERSION}" --pkglicense='ZLIB' --pkggroup='libs' --pkgsource='libsdl2-ttf' --pkgaltsource='' --maintainer='pkg-sdl-maintainers@lists.alioth.debian.org' --provides='' --requires='' --conflicts='' --replaces='' --nodoc --deldoc=yes --deldesc=yes --delspec=yes --backup=no
sudo rm -f description-pak
cp "libsdl2-ttf-${SDL_ttf_VERSION}_${SDL_ttf_VERSION}-${SDL_ttf_VERSION}_armhf.deb"  ../.
sudo rm -f "libsdl2-ttf-${SDL_ttf_VERSION}_${SDL_ttf_VERSION}-${SDL_ttf_VERSION}_armhf.deb"

# Install New SDL_ttf
sudo dpkg -i ../"libsdl2-ttf-${SDL_ttf_VERSION}_${SDL_ttf_VERSION}-${SDL_ttf_VERSION}_armhf.deb"
popd
