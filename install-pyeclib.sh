#!/bin/sh

# Install dependencies
#sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo apt-get install git build-essential autoconf automake libtool python python3 python-dev python3-dev python-pip python3-pip libjerasure-dev libjerasure2 -q -y
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo apt-get install git build-essential autoconf automake libtool python python3 python-dev python3-dev python-pip python3-pip -q -y
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
# Clean Install Source
cd
rm -rf /tmp/gf-complete

# Install jerasure
cd /tmp
git clone http://lab.jerasure.org/jerasure/jerasure.git
cd jerasure
autoreconf --force --install
./configure
make
sudo make install
# Clean Install Source
cd
rm -rf /tmp/jerasure

# Install liberasurecode
cd /tmp
git clone https://github.com/openstack/liberasurecode.git
cd liberasurecode
./autogen.sh
./configure
make
make test
sudo make install
# Clean Install Source
cd
rm -rf /tmp/liberasurecode

# Install PyEClib
cd /tmp
git clone https://github.com/openstack/pyeclib.git
cd pyeclib
# For Python 2.x
sudo pip install -U bindep -r test-requirements.txt
sudo bindep -f bindep.txt
sudo python setup.py install
sudo ldconfig
# Check PyEClib for Python 2.x
./.unittests
# For Python 3.x
sudo pip3 install -U bindep -r test-requirements.txt
sudo bindep -f bindep.txt
sudo python3 setup.py install
sudo ldconfig
# Check PyEClib for Python 3.x
cp .unittests .unittests3
sudo sed -i "s,python,python3," .unittests3
sudo sed -i "s,print os,print(os," .unittests3
sudo sed -i "s,'))\"),')))\")," .unittests3
./.unittests3
# Clean Install Source
cd
rm -rf /tmp/pyeclib

# Install PyEClib for Python 2.x with PIP
#sudo pip install pyeclib

# Install PyEClib for Python 3.x with PIP
#sudo pip3 install pyeclib