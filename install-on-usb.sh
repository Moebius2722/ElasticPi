#!/bin/sh

# Upgrade Firmware with Boot On USB Feature
sudo apt-get update && sudo apt-get install rpi-update rsync -q -y && sudo BRANCH=next rpi-update

# Active Boot On USB Feature
echo program_usb_boot_mode=1 | sudo tee -a /boot/config.txt

# Create USB Drive Partitions
sudo parted --script /dev/sda \
mktable msdos \
mkpart primary fat32 0% 100M \
mkpart primary ext4 100M 100%

# Format USB Drive Partitions
sudo mkfs.vfat -n BOOT -F 32 /dev/sda1
sudo mkfs.ext4 -F /dev/sda2

# Create Root Mount Point
sudo mkdir /mnt/target
sudo mount /dev/sda2 /mnt/target/
# Create Boot Mount Point
sudo mkdir /mnt/target/boot
sudo mount /dev/sda1 /mnt/target/boot/
# Copy SD Card OS Installation on USB Drive
sudo rsync -ax --progress / /boot /mnt/target

# Preparation for Upgrade USB Drive OS Installation
cd /mnt/target
sudo mount --bind /dev dev
sudo mount --bind /sys sys
sudo mount --bind /proc proc
sudo chroot /mnt/target
rm /etc/ssh/ssh_host*
dpkg-reconfigure openssh-server
# Upgrade USB Drive OS Installation and Firmware with Boot On USB Feature
sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rm /boot/.firmware_revision && sudo BRANCH=next rpi-update
exit
sudo umount dev
sudo umount sys
sudo umount proc

# Change Root Partition
sudo sed -i "s,root=/dev/mmcblk0p2,root=/dev/sda2," /mnt/target/boot/cmdline.txt
# Replace SD Card partitions with USB Drive Partitions in fstab
sudo sed -i "s,/dev/mmcblk0p,/dev/sda," /mnt/target/etc/fstab

# Unmount Root and Boot Mount Point and PowerOff
cd ~
sudo umount /mnt/target/boot 
sudo umount /mnt/target
sudo poweroff
