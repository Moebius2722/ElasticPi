#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Update Script for Nginx on Raspberry Pi 2 or 3


####### COMMON #######

# Set Version
if [[ ${NGX_VERSION} = '' ]]; then
  NGX_VERSION=`wget http://nginx.org/en/download.html -qO- | sed 's/>/>\n/g' | grep -i 'tar.gz"' | sort -V -r | head -1 | cut -d '"' -f 2 | cut -d / -f 3 | cut -d - -f 2 | cut -d . -f 1-3`
fi

# Check if already up to date
NGX_CVERSION=`nginx -v 2>&1 | cut -d / -f 2`
if [[ "${NGX_VERSION}" = "${NGX_CVERSION}" ]]; then
  echo "Nginx is already up to date to ${NGX_CVERSION} version"
  exit 0
fi

# Stop Keepalived Daemon
sudo /bin/systemctl stop keepalived.service

# Stop Nginx Daemon
sudo /bin/systemctl stop nginx.service

# Full System Update
if [[ ! "${PI_UPDATED}" = 1 ]]; then
  echo "Full System Update"
  sudo apt-get update && sudo apt-get upgrade -q -y && sudo apt-get dist-upgrade -q -y && sudo rpi-update
  export PI_UPDATED=1
fi


####### NGINX #######

# Get Auth PAM module
git clone https://github.com/sto/ngx_http_auth_pam_module.git /tmp/ngx_http_auth_pam_module

# Install Nginx Reverse Proxy
#sudo apt-get install nginx-extras -q -y
wget -P/tmp http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz && tar -xzvf /tmp/nginx-${NGX_VERSION}.tar.gz -C /tmp && cd /tmp/nginx-${NGX_VERSION}
./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --with-threads --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-google_perftools_module --with-cpp_test_module --with-debug --add-module=/tmp/ngx_http_auth_pam_module
make
sudo make install

# Start Nginx Daemon
sudo /bin/systemctl start nginx.service

# Start Keepalived Daemon
sudo /bin/systemctl start keepalived.service
