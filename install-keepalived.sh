#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Keepalived on Raspberry Pi 2 or 3


####### COMMON #######

# Get IP Host
iphost=`hostname -I | cut -d ' ' -f 1`

# Get last digit IP host
idhost=${iphost:(-1):1}

# Generate virtual IP host
viphost=${iphost::-2}$((${iphost:(-2):1}-1))${iphost:(-1):1}

# Full System Update
if [[ ! "${PI_UPDATED}" = "1" ]]; then
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

# Install Keepalived Load Balancer
sudo apt-get install keepalived -q -y

# Configure Keepalived Load Balancer
password='k@l!ve3'
echo "vrrp_script chk_nginx {
  script       ""/usr/bin/check-nginx""
  interval 2   # check every 2 seconds
  fall 2       # require 2 failures for KO
  rise 150     # require 150 successes for OK
}
" | sudo tee /etc/keepalived/keepalived.conf
for i in {0..9}
do
  id=1$i
  priority=1$((((9-$i)+$idhost)%10))0
  vip=${iphost::-2}$((${iphost:(-2):1}-1))$i
  if [[ $i -eq  $idhost ]]; then
    state=MASTER
  else
    state=BACKUP
  fi
  
  echo "vrrp_instance VI_$id {
  state $state
  interface eth0
  virtual_router_id $id
  priority $priority
  advert_int 1
  lvs_sync_daemon_interface eth0
  authentication {
    auth_type AH
    auth_pass $password
  }
  virtual_ipaddress {
        $vip/24
  }
  track_script {
    chk_nginx
  }" | sudo tee -a /etc/keepalived/keepalived.conf
  if [[ $i -ne  $idhost ]]; then
    echo "  preempt_delay 300" | sudo tee -a /etc/keepalived/keepalived.conf
  fi
echo "}
" | sudo tee -a /etc/keepalived/keepalived.conf
done

# Restart Keepalived Load Balancer
restart-keepalived
