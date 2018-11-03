#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Sync Folders from NAS to Plex Script on Raspberry Pi 2 or 3

# For run on sync
# curl -sL https://github.com/Moebius2722/ElasticPi/raw/master/sync-all.sh | bash -

####### SYNC-ALL #######

# Sync All Folders

rsync -rtvn --progress --del --stats --force --exclude '@eaDir' --exclude '.DS_Store' /mnt/synovideo/Comics/ /media/media/Comics
rsync -rtvn --progress --del --stats --force --exclude '@eaDir' --exclude '.DS_Store' /mnt/synovideo/Documentaires/ /media/usb1to/Documentaires
rsync -rtvn --progress --del --stats --force --exclude '@eaDir' --exclude '.DS_Store' /mnt/synovideo/Enfants/ /media/pidrive/Enfants
rsync -rtvn --progress --del --stats --force --exclude '@eaDir' --exclude '.DS_Store' /mnt/synovideo/Films/ /media/usb1to/Films
rsync -rtvn --progress --del --stats --force --exclude '@eaDir' --exclude '.DS_Store' /mnt/synovideo/Mangas/ /media/usb1to/Mangas
rsync -rtvn --progress --del --stats --force --exclude '@eaDir' --exclude '.DS_Store' /mnt/synovideo/Séries/ /media/usb1to/Séries
rsync -rtvn --progress --del --stats --force --exclude '@eaDir' --exclude '.DS_Store' /mnt/synovideo/Spectacles/ /media/usb1to/Spectacles
