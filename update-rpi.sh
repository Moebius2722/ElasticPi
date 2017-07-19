#!/bin/bash
sudo apt-get update && sudo apt-get -o Dpkg::Options::="--force-confnew --force-overwrite" --force-yes --auto-remove -fquy upgrade && sudo apt-get -o Dpkg::Options::="--force-confnew --force-overwrite" --force-yes --auto-remove -fquy dist-upgrade && sudo SKIP_WARNING=1 rpi-update && sudo reboot
