#!/bin/sh

SQUIDLIB=/var/lib/squidguard/db
SQUIDLIB_BLACKLISTS=$SQUIDLIB"/blacklists"

if [ -d $SQUIDLIB_BLACKLISTS ]; then
    for folderName in `ls $SQUIDLIB_BLACKLISTS`; do
        if [ -d "$SQUIDLIB_BLACKLISTS/$folderName" ]; then
            echo "dest $folderName {"
            if [ -e "$SQUIDLIB_BLACKLISTS/$folderName/domains" ]; then
                echo "      domainlist blacklists/$folderName/domains"
            fi
            if [ -e "$SQUIDLIB_BLACKLISTS/$folderName/urls" ]; then
                echo "      urllist blacklists/$folderName/urls"
            fi
            echo "      log ${folderName}accesses"
            echo "}"
        fi
    done
fi
