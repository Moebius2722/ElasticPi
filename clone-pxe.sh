#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Clone PXE Install for Raspberry Pi 2 or 3

# curl -sL https://raw.githubusercontent.com/Moebius2722/ElasticPi/master/clone-pxe.sh | bash -


####### CLONE-PXE #######

cpuinfoserial=`cat /proc/cpuinfo | grep -i Serial`
serialsize=8
cpuserial=`echo ${cpuinfoserial:${#cpuinfoserial} - $serialsize}`

sudo umount /mnt/tftp
sudo rm -rf /mnt/tftp
sudo mkdir /mnt/tftp
sudo mount -t nfs 192.168.0.1:/volume1/tftp /mnt/tftp
sudo mkdir /mnt/tftp/$cpuserial
sudo rsync -ax --progress --exclude */ /mnt/tftp/ /mnt/tftp/$cpuserial
sudo rsync -ax --progress /mnt/tftp/overlays /mnt/tftp/$cpuserial
sudo sed -i "s/\/volume1\/rpi\/rpi/\/volume1\/rpi\/$cpuserial/" /mnt/tftp/$cpuserial/cmdline.txt
sudo umount /mnt/tftp
sudo rm -rf /mnt/tftp

sudo umount /mnt/pxe
sudo rm -rf /mnt/pxe
sudo mkdir /mnt/pxe
sudo mount -t nfs 192.168.0.1:/volume1/rpi /mnt/pxe
sudo mkdir /mnt/pxe/$cpuserial
sudo rsync -ax --progress  --exclude mnt/* --exclude boot/* --exclude boot/.* --exclude boot.bak/ /mnt/pxe/rpi/ /mnt/pxe/$cpuserial
sudo sed -i "s/\/volume1\/tftp/\/volume1\/tftp\/$cpuserial/" /mnt/pxe/$cpuserial/etc/fstab
sudo umount /mnt/pxe
sudo rm -rf /mnt/pxe

sudo reboot
