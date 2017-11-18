#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Installation Script for Nginx on Raspberry Pi 2 or 3 to Secured Kibana


####### COMMON #######

# Check if cluster is created
if [ ! -f /etc/elasticpi/nodes.lst ]; then
  echo "Create cluster before install Nginx"
  exit 1
fi

# Check if already installed
if get-nginx-version >/dev/null 2>/dev/null; then
  echo "Nginx is already installed" >&2
  exit 1
fi

# Set Version
NGX_VERSION=`get-nginx-maxversion`
if [[ ${NGX_VERSION} = '' ]]; then
  NGX_VERSION=`get-nginx-lastversion`
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
sudo apt-get purge nginx nginx-common nginx-doc nginx-extras nginx-full nginx-light -q -y
sudo apt-get install libpcre3 libpcre3-dev libperl5.24 libperl-dev zlib1g zlib1g-dev libssl-dev libssl1.0.2 libxml2 libxml2-dev libxslt1.1 libxslt1-dev libjpeg62-turbo libjpeg62-turbo-dev libgd3 libgd-dev libgeoip1 libgeoip-dev libgoogle-perftools4 libgoogle-perftools-dev libpam0g libpam0g-dev -q -y
rm -f /tmp/nginx-${NGX_VERSION}.tar.gz ; wget -P/tmp http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz && tar -xzvf /tmp/nginx-${NGX_VERSION}.tar.gz -C /tmp && pushd /tmp/nginx-${NGX_VERSION}
./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --with-threads --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-google_perftools_module --with-cpp_test_module --with-debug --add-module=/tmp/ngx_http_auth_pam_module
make
sudo make install
popd
rm -rf /tmp/ngx_http_auth_pam_module
rm -rf /tmp/nginx-${NGX_VERSION}
rm -f /tmp/nginx-${NGX_VERSION}.tar.gz

sudo apt-get -o Dpkg::Options::="--force-overwrite" -o Dpkg::Options::="--force-confnew" install nginx-common -q -y

# Configure Nginx Daemon
sudo sed -i '/\[Service\]/a Restart=always' /lib/systemd/system/nginx.service
sudo /bin/systemctl daemon-reload

# Configure Nginx
configure-nginx
