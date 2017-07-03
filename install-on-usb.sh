#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated On USB Raspbian Installation Script for Raspberry Pi 2 or 3


####### INSTALL ON USB #######

# Upgrade Firmware with Boot On USB Feature
#sudo apt-get update && sudo apt-get install rpi-update rsync -q -y && sudo BRANCH=next rpi-update
sudo apt-get update && sudo apt-get install rpi-update rsync -q -y && sudo rpi-update

# Active Boot On USB Feature
echo program_usb_boot_mode=1 | sudo tee -a /boot/config.txt

# Create USB Drive Partitions
#sudo parted --script /dev/sda \
#mktable msdos \
#mkpart primary fat32 0% 100M \
#mkpart primary ext4 100M 100%

sudo parted --script /dev/sda \
mktable msdos \
mkpart primary fat32 0% 250MiB \
mkpart primary linux-swap 250MiB 2250MiB \
mkpart primary ext4 2250MiB 12250MiB \
mkpart primary 12250MiB 100% \
set 4 lvm on

sudo apt-get install lvm2 -q -y
sudo pvcreate -ffy /dev/sda4
sudo vgcreate -y vg0 /dev/sda4
sudo lvcreate -L 1G -n lvusrlocal vg0
sudo lvcreate -L 1G -n lvtmp vg0
sudo lvcreate -L 1G -n lvvar vg0
sudo lvcreate -L 1G -n lvhome vg0


# Format USB Drive Partitions
sudo apt-get install -y f2fs-tools
sudo mkfs.vfat -n BOOT -F 32 /dev/sda1
sudo mkswap -f -L SWAP /dev/sda2
sudo mkfs.f2fs -l ROOT /dev/sda3
sudo mkfs.f2fs -l USRLOCAL /dev/vg0/lvusrlocal
sudo mkfs.f2fs -l TMP /dev/vg0/lvtmp
sudo mkfs.f2fs -l VAR /dev/vg0/lvvar
sudo mkfs.f2fs -l HOME /dev/vg0/lvhome
#sudo mkfs.ext4 -F -L ROOT /dev/sda3
#sudo mkfs.ext4 -F -L USRLOCAL /dev/vg0/lvusrlocal
#sudo mkfs.ext4 -F -L TMP /dev/vg0/lvtmp
#sudo mkfs.ext4 -F -L VAR /dev/vg0/lvvar
#sudo mkfs.ext4 -F -L HOME /dev/vg0/lvhome


# Create Tree
sudo mkdir /mnt/target
sudo mount /dev/sda3 /mnt/target
sudo mkdir /mnt/target/boot
sudo mount /dev/sda1 /mnt/target/boot
sudo mkdir -p /mnt/target/usr/local
sudo mount /dev/vg0/lvusrlocal /mnt/target/usr/local
sudo mkdir /mnt/target/tmp
sudo mount /dev/vg0/lvtmp /mnt/target/tmp
sudo mkdir /mnt/target/var
sudo mount /dev/vg0/lvvar /mnt/target/var
sudo mkdir /mnt/target/home
sudo mount /dev/vg0/lvhome /mnt/target/home


# Create Root Mount Point
#sudo mkdir /mnt/target
#sudo mount /dev/sda2 /mnt/target/
# Create Boot Mount Point
#sudo mkdir /mnt/target/boot
#sudo mount /dev/sda1 /mnt/target/boot/
# Copy SD Card OS Installation on USB Drive
sudo rsync -ax --progress / /boot /mnt/target

# Preparation for Upgrade USB Drive OS Installation
sudo mount --bind /dev /mnt/target/dev
sudo mount --bind /sys /mnt/target/sys
sudo mount --bind /proc /mnt/target/proc
sudo mount --bind /dev/pts /mnt/target/dev/pts
#echo "rm /etc/ssh/ssh_host* && dpkg-reconfigure openssh-server && apt-get -q -y remove dphys-swapfile && apt-get -q -y autoremove && rm -f /var/swap && apt-get update && apt-get upgrade -q -y && apt-get dist-upgrade -q -y && rm /boot/.firmware_revision && BRANCH=next rpi-update && exit" | sudo tee /mnt/target/chroot.sh
echo "rm /etc/ssh/ssh_host* && dpkg-reconfigure openssh-server && apt-get -q -y remove dphys-swapfile && apt-get -q -y autoremove && rm -f /var/swap && apt-get update && apt-get upgrade -q -y && apt-get dist-upgrade -q -y && rm /boot/.firmware_revision && rpi-update && exit" | sudo tee /mnt/target/chroot.sh
sudo chmod a+x /mnt/target/chroot.sh

# Upgrade USB Drive OS Installation and Firmware with Boot On USB Feature
sudo chroot /mnt/target ./chroot.sh
sudo rm -f /mnt/target/chroot.sh
sudo umount /mnt/target/dev/pts
sudo umount /mnt/target/dev
sudo umount /mnt/target/sys
sudo umount /mnt/target/proc

# Change Root Partition
sudo sed -i "s,root=/dev/mmcblk0p2,root=/dev/sda3," /mnt/target/boot/cmdline.txt

# Replace SD Card partitions with USB Drive Partitions in fstab
sudo sed -i "s,/dev/mmcblk0p1,/dev/sda1          ," /mnt/target/etc/fstab
echo -e '/dev/sda2            none            swap    defaults          0       0' | sudo tee -a /mnt/target/etc/fstab
sudo sed -i "s,/dev/mmcblk0p2,/dev/sda3          ," /mnt/target/etc/fstab
echo -e '/dev/vg0/lvusrlocal  /usr/local      f2fs    defaults,noatime  0       1' | sudo tee -a /mnt/target/etc/fstab
echo -e '/dev/vg0/lvtmp       /tmp            f2fs    defaults,noatime  0       1' | sudo tee -a /mnt/target/etc/fstab
echo -e '/dev/vg0/lvvar       /var            f2fs    defaults,noatime  0       1' | sudo tee -a /mnt/target/etc/fstab
echo -e '/dev/vg0/lvhome      /home           f2fs    defaults,noatime  0       1' | sudo tee -a /mnt/target/etc/fstab
#echo -e '/dev/vg0/lvusrlocal  /usr/local      ext4    defaults,noatime  0       1' | sudo tee -a /mnt/target/etc/fstab
#echo -e '/dev/vg0/lvtmp       /tmp            ext4    defaults,noatime  0       1' | sudo tee -a /mnt/target/etc/fstab
#echo -e '/dev/vg0/lvvar       /var            ext4    defaults,noatime  0       1' | sudo tee -a /mnt/target/etc/fstab
#echo -e '/dev/vg0/lvhome      /home           ext4    defaults,noatime  0       1' | sudo tee -a /mnt/target/etc/fstab

# Unmount Root and Boot Mount Point and PowerOff
cd ~
sudo umount /mnt/target/home
sudo umount /mnt/target/var
sudo umount /mnt/target/tmp
sudo umount /mnt/target/usr/local
sudo umount /mnt/target/boot
sudo umount /mnt/target
sudo poweroff