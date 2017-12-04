#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Get Golang last version


####### GET-GOLANG-VERSION #######

# Get Golang last version

wget https://golang.org/dl/ -qO-  | grep -i "<div class=\"toggleVisible\" id=\"" | cut -d '"' -f 4 | sort -r | head -n 1