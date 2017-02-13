#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Keepalived on Raspberry Pi 2 or 3


####### COMMON #######

# Full System Update
if [[ ! "${PI_UPDATED}" = 1 ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi


####### KEEPALIVED #######

# Prevent loopback ARP response for Keepalived.

echo net.ipv4.ip_nonlocal_bind=1 | sudo tee /etc/sysctl.d/95-keepalived.conf
sudo sysctl -w net.ipv4.ip_nonlocal_bind=1
echo net.ipv4.ip_forward=1 | sudo tee -a /etc/sysctl.d/95-keepalived.conf
sudo sysctl -w net.ipv4.ip_forward=1
echo net.ipv4.conf.lo.arp_ignore=1 | sudo tee -a /etc/sysctl.d/95-keepalived.conf
sudo sysctl -w net.ipv4.conf.lo.arp_ignore=1
echo net.ipv4.conf.lo.arp_announce=2 | sudo tee -a /etc/sysctl.d/95-keepalived.conf
sudo sysctl -w net.ipv4.conf.lo.arp_announce=2
sudo sysctl -p

#sudo apt-get install iptables-persistent -y

#sudo iptables -P INPUT ACCEPT
#sudo iptables -P FORWARD ACCEPT
#sudo iptables -P OUTPUT ACCEPT
#sudo iptables -t nat -F
#sudo iptables -t mangle -F
#sudo iptables -F
#sudo iptables -X

#sudo sh -c "iptables-save > /etc/iptables/rules.v4"
#echo "iptables-restore < /etc/iptables/rules.v4" | sudo tee -a /etc/rc.local


# Install Keepalived Load Balancer
sudo apt-get install keepalived -q -y

# Set Static IP Addresses

#/etc/network/interfaces

# auto eth0
# iface eth0 inet static
# address 192.168.0.21
# netmask 255.255.255.0
# gateway 192.168.0.254

# auto eth0:0
# iface eth0:0 inet static
# address 192.168.1.21
# netmask 255.255.255.0

# auto lo:0
# iface lo:0 inet static
# address 192.168.0.10
# netmask 255.255.255.255

# auto lo:1
# iface lo:1 inet static
# address 192.168.0.11
# netmask 255.255.255.255

# auto lo:2
# iface lo:2 inet static
# address 192.168.0.12
# netmask 255.255.255.255

# Disable DHCP Client and enable manual network configuation
sudo systemctl disable dhcpcd
sudo systemctl enable networking

# Set DNS server with "resolvconf"
echo name_servers=192.168.0.254 | sudo tee -a /etc/resolvconf.conf

# Set DNS server with classic method and lock "resolv.conf" file
echo "nameserver 192.168.0.254" | sudo tee /etc/resolv.conf
sudo chattr +i /etc/resolv.conf
