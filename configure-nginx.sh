#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Configure Script for Nginx on Raspberry Pi 2 or 3


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before install Nginx"
  exit 1
fi

# Check if installed
if ! get-nginx-version >/dev/null 2>/dev/null; then
  echo "Nginx isn't installed" >&2
  exit 1
fi

# Get IP Host
iphost=`hostname -i`


####### NGINX #######

# Copy Cluster SSL Auto Signed Certificate for Nginx Reverse Proxy
sudo cp -Rf /etc/elasticpi/ssl /etc/nginx/.

# Create Kibana User Group
if ! getent group kibana-usr >/dev/null; then
  sudo groupadd -r kibana-usr
fi

# Add "pi" user to Kibana User Group
sudo usermod -a -G kibana-usr pi

# Create Restricted Groups File for Nginx PAM authentication with "kibana-usr" default access group
sudo cp -f /opt/elasticpi/Nginx/restricted_groups /etc/nginx/restricted_groups

# Allow Nginx to read /etc/shadow file for PAM authentication
sudo usermod -a -G shadow www-data

# Set PAM Authentication for Nginx
sudo cp -f /opt/elasticpi/Nginx/nginx_restricted /etc/pam.d/nginx_restricted

# Set Nginx Default Site redirect on local Kibana with PAM authentication
sudo cp -f /opt/elasticpi/Nginx/nginx.conf /etc/nginx/nginx.conf
echo "# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git" | sudo tee /etc/nginx/sites-available/default
services=( "kibana 5601 80 443" "cerebro 9000 9001 9002" "nodered 1880 1881 1882" "elasticsearch 9200 9201 9202" )
for svc in "${services[@]}"
do
set -- $svc
servicename=$1
remoteserviceport=$2
localserviceport=$3
localsslserviceport=$4
echo "upstream stream_$servicename {" | sudo tee -a /etc/nginx/sites-available/default
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$'` )
for ipnode in "${ipnodes[@]}"
do
if [[ "$ipnode" == "$iphost" ]]; then
echo "    server $ipnode:$remoteserviceport;" | sudo tee -a /etc/nginx/sites-available/default
else
echo "    server $ipnode:$remoteserviceport backup;" | sudo tee -a /etc/nginx/sites-available/default
fi
done
echo "}

server {
    listen $localserviceport;

    listen $localsslserviceport ssl;
    server_name 0.0.0.0;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    auth_pam \"Restricted Zone\";
    auth_pam_service_name \"nginx_restricted\";
    auth_pam_set_pam_env on;

    location / {
        proxy_pass http://stream_$servicename;
        proxy_set_header  X-Real-IP  \$remote_addr;
        proxy_set_header Host \$http_host;
        proxy_set_header X-forwarded-for \$proxy_add_x_forwarded_for;
        port_in_redirect off;

        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
    }
}
" | sudo tee -a /etc/nginx/sites-available/default
done

# Set Nginx Stream Load Balancing
sudo sed -i 's/worker_processes.*/worker_processes 1;/' /etc/nginx/nginx.conf
echo "stream {" | sudo tee -a /etc/nginx/nginx.conf
services=( "syslog 5000 5010" "squid 5001 5011" "mosquitto 1883 1884" )
for svc in "${services[@]}"
do
set -- $svc
servicename=$1
remoteserviceport=$2
localserviceport=$3
echo "    upstream stream_$servicename {" | sudo tee -a /etc/nginx/nginx.conf
ipnodes=( `sudo cat /etc/elasticpi/nodes.lst | grep -e '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$'` )
for ipnode in "${ipnodes[@]}"
do
if [[ "$ipnode" == "$iphost" ]]; then
echo "        server $ipnode:$remoteserviceport;" | sudo tee -a /etc/nginx/nginx.conf
else
echo "        server $ipnode:$remoteserviceport backup;" | sudo tee -a /etc/nginx/nginx.conf
fi
done
echo "    }

    server {
        listen $localserviceport;
        proxy_pass stream_$servicename;
    }
" | sudo tee -a /etc/nginx/nginx.conf
done
echo "}" | sudo tee -a /etc/nginx/nginx.conf

# Restart Nginx Daemon for Update Configuration
restart-nginx
