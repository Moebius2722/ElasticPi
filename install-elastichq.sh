#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Elastic-HQ on Raspberry Pi 2 or 3 to Secured Kibana


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before install Elastic-HQ"
  exit 1
fi

# Get IP Host
iphost=`hostname -I | cut -d ' ' -f 1`

# Get last digit IP host
idhost=${iphost:(-1):1}

# Get subnet IP host
subiphost=${iphost::-1}


####### ELASTIC-HQ #######

# Install Elastic-HQ
sudo git clone https://github.com/royrusso/elasticsearch-HQ.git /opt/elastichq

# Set Nginx Default Site redirect on local Kibana with PAM authentication
echo "upstream stream_elastichq {" | sudo tee -a /etc/nginx/sites-available/default
for i in {0..9}
do
if [[ "$i" -eq "$idhost" ]]; then
echo "    server $subiphost$i:9200;" | sudo tee -a /etc/nginx/sites-available/default
else
echo "    server $subiphost$i:9200 backup;" | sudo tee -a /etc/nginx/sites-available/default
fi
done
echo "}

server {
    listen 8080;

    listen 8443 ssl;
    server_name 0.0.0.0;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    auth_pam \"Restricted Zone\";
    auth_pam_service_name \"nginx_restricted\";
    auth_pam_set_pam_env on;

    location /_plugin/hq/ {
        alias /opt/elastichq/;
        expires 300s;
    }

    location ^~ / {
        proxy_pass http://stream_elastichq;
    }
}
" | sudo tee -a /etc/nginx/sites-available/default

# Restart Nginx Daemon for Update Configuration
restart-nginx
