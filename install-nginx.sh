#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Nginx on Raspberry Pi 2 or 3 to Secured Kibana


####### COMMON #######

# Set Version
if [[ ${NGX_VERSION} = '' ]]; then
  NGX_VERSION=`wget http://nginx.org/en/download.html -qO- | sed 's/>/>\n/g' | grep -i 'tar.gz"' | sort -V -r | head -1 | cut -d '"' -f 2 | cut -d / -f 3 | cut -d - -f 2 | cut -d . -f 1-3`
fi

# Full System Update
if [[ ! "${PI_UPDATED}" = "1" ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi


####### NGINX #######

# Get Auth PAM module
git clone https://github.com/sto/ngx_http_auth_pam_module.git /tmp/ngx_http_auth_pam_module

# Install Nginx Reverse Proxy
#sudo apt-get install nginx-extras -q -y
sudo apt-get purge nginx nginx-common nginx-doc nginx-extras nginx-extras-dbg nginx-full nginx-full-dbg nginx-light nginx-light-dbg -q -y
sudo apt-get install libpcre3 libpcre3-dev libperl5.20 libperl-dev zlib1g zlib1g-dev libssl-dev libssl1.0.0 libxml2 libxml2-dev libxslt1.1 libxslt1-dev libjpeg62-turbo libjpeg62-turbo-dev libgd3 libgd-dev libgeoip1 libgeoip-dev libgoogle-perftools4 libgoogle-perftools-dev libpam0g libpam0g-dev -q -y
wget -P/tmp http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz && tar -xzvf /tmp/nginx-${NGX_VERSION}.tar.gz -C /tmp && cd /tmp/nginx-${NGX_VERSION}
./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --with-threads --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-google_perftools_module --with-cpp_test_module --with-debug --add-module=/tmp/ngx_http_auth_pam_module
make
sudo make install
rm -rf /tmp/ngx_http_auth_pam_module
rm -rf /tmp/nginx-${NGX_VERSION}
rm -f /tmp/nginx-${NGX_VERSION}.tar.gz

sudo apt-get -o Dpkg::Options::="--force-overwrite" -o Dpkg::Options::="--force-confnew" install nginx-common -q -y

# Create SSL Auto Signed Certificate for Nginx Reverse Proxy
sudo mkdir /etc/nginx/ssl && (echo FR; echo France; echo Paris; echo Raspberry Pi; echo Nginx; echo $(hostname -I); echo ;) | sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt

# Create Kibana User Group
if ! getent group kibana-usr >/dev/null; then
  sudo groupadd -r kibana-usr
fi

# Add "pi" user to Kibana User Group
sudo usermod -a -G kibana-usr pi

# Create Restricted Groups File for Nginx PAM authentication with "kibana-usr" default access group
sudo cp -f `dirname $0`/Nginx/restricted_groups /etc/nginx/restricted_groups

# Allow Nginx to read /etc/shadow file for PAM authentication
sudo usermod -a -G shadow www-data

# Set PAM Authentication for Nginx
sudo cp -f `dirname $0`/Nginx/nginx_restricted /etc/pam.d/nginx_restricted

# Set Nginx Default Site redirect on local Kibana with PAM authentication
sudo cp -f `dirname $0`/Nginx/default /etc/nginx/sites-available/default

# Restart Nginx Daemon for Update Configuration
sudo /bin/systemctl restart nginx.service

# Secured Kibana
sudo sed -i 's/.*server\.host:.*/server\.host: "127.0.0.1"/' /etc/kibana/kibana.yml
sudo /bin/systemctl restart kibana.service
