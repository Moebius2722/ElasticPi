#!/bin/sh

# Install dependencies
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get install git build-essential autoconf automake libtool python python3 python-dev python3-dev python-pip python3-pip libjerasure-dev libjerasure2 -y
sudo pip install --upgrade setuptools
sudo pip3 install --upgrade setuptools

# Install GF-Complete
cd /tmp
git clone http://lab.jerasure.org/jerasure/gf-complete.git
cd gf-complete
./autogen.sh
./configure
make 
sudo make install

# Install jerasure
cd /tmp
git clone http://lab.jerasure.org/jerasure/jerasure.git
cd jerasure
autoreconf --force --install
./configure
make
sudo make install

# Install liberasurecode
cd /tmp
git clone https://github.com/openstack/liberasurecode.git
cd liberasurecode
./autogen.sh
./configure
make
make test
sudo make install

cd /tmp
git clone https://github.com/openstack/pyeclib.git

# Install PyEClib for Python 2.x
sudo pip install pyeclib

# Install PyEClib for Python 3.x
sudo pip3 install pyeclib