#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Set Elasticsearch Auto Expand Replicas Indices on Raspberry Pi 2 or 3


####### SET-AUTO-EXPAND-REPLICAS #######

# Set Auto Expand Replicas to "0-1"

curl -X PUT "localhost:9200/_settings" -H 'Content-Type: application/json' -d'
{
    "index" : {
        "auto_expand_replicas" : "0-1"
    }
}
'
