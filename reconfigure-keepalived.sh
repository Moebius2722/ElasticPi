#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Configure Script for Keepalived on Raspberry Pi 2 or 3


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/vip.lst ]; then
  echo "Create cluster before install Keepalived"
  exit 1
fi

# Check if installed
if ! get-keepalived-version >/dev/null 2>/dev/null; then
  echo "Keepalived isn't installed" >&2
  exit 1
fi

# Get Short Hostname
shost=`hostname -s`

# Get IP Host
iphost=`hostname -i`
idhost=`get-node-id`
nodescount=`get-nodes-count`
idcluster=`get-cluster-id`

# Get Main Network Interface
inet=`ip -o -4 route show to default | grep -Po '(?<=dev )(\S+)'`

####### KEEPALIVED #######

# Stop Keepalived Load Balancer Daemon
stop-keepalived

# Configure Keepalived Load Balancer
echo "
global_defs {
  #lvs_sync_daemon $inet VI_1
  router_id $shost
}

vrrp_script chk_nlb {
  script       ""/usr/bin/check-nlb""
  interval 2   # check every 2 seconds
  fall 2       # require 2 failures for KO
  rise 2       # require 2 successes for OK
}
" | sudo tee /etc/keepalived/keepalived.conf

vips=( `sudo cat /etc/elasticpi/vip.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]* [0-9]*\.[0-9]*\.[0-9]*\.[0-9].*$' | tr ' ' ';'` )
id=0

for viphip in "${vips[@]}"
do
  id=$[$id+$idcluster]

  vip=`echo $viphip | cut -d ';' -f 1`
  hip=`echo $viphip | cut -d ';' -f 2`
  idnode=`get-node-id $hip`
  priority=1$(((($nodescount-1-$idnode)+$idhost)%$nodescount))0
  if [[ "$iphost" ==  "$hip" ]]; then
    state=MASTER
  else
    state=BACKUP
  fi

  echo "vrrp_instance VI_$id {
  state $state
  interface $inet
  virtual_router_id $id
  priority $priority
  advert_int 1
  #lvs_sync_daemon_interface $inet
  virtual_ipaddress {
        $vip/24
  }
  track_script {
    chk_nlb
  }
}
" | sudo tee -a /etc/keepalived/keepalived.conf
done

# Start Keepalived Load Balancer Daemon
start-keepalived
