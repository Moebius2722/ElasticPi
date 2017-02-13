#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Hard Overcloking Raspberry Pi 3

echo arm_freq=1400 | sudo tee -a /boot/config.txt
echo sdram_freq=500 | sudo tee -a /boot/config.txt
echo core_freq=500 | sudo tee -a /boot/config.txt
echo over_voltage=6 | sudo tee -a /boot/config.txt