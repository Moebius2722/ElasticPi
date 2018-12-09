#!/bin/bash

# Author : Moebius2722
# Mail : moebius2722@laposte.net
# Git : https://github.com/Moebius2722/ElasticPi.git

# Full Automated Buid Nginx Script for Raspberry Pi 2 or 3


####### COMMON #######

# Check Parameters
if [[ ! $# = 1 ]] ; then
  echo "Usage : $0 Nginx_Version"
  exit 1
fi

# Get Metricbeat Version
NGX_VERSION=$1


####### BUILD-NGINX #######

# Check If Already Build

if [ -f /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx_${NGX_VERSION}-1_armhf.deb ] && [ -f /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx_${NGX_VERSION}-1_armhf.deb.sha512 ]; then
  pushd /mnt/elasticpi/build/nginx/${NGX_VERSION}
  sha512sum -c /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx_${NGX_VERSION}-1_armhf.deb.sha512
  if [ $? -eq 0 ] ; then
    popd
    exit 0
    # Exit Build
  fi
  popd
fi

# Backup Node State and Stop Node
backup-node-state
stop-node

# Add Nginx Build Requirements
sudo apt-get install checkinstall gcc g++ make libpcre3 libpcre3-dev libperl5.24 libperl-dev zlib1g zlib1g-dev libssl-dev libssl1.0.2 libxml2 libxml2-dev libxslt1.1 libxslt1-dev libjpeg62-turbo libjpeg62-turbo-dev libgd3 libgd-dev libgeoip1 libgeoip-dev libgoogle-perftools4 libgoogle-perftools-dev libpam0g libpam0g-dev -q -y

# Create Nginx Build Folder
if [ ! -d "/mnt/elasticpi/build/nginx/${NGX_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/nginx/${NGX_VERSION}
  sudo chown -R root:root /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get Nginx Source
rm -f /tmp/nginx-${NGX_VERSION}.tar.gz
wget -P/tmp http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz

# Get Auth PAM module
git clone https://github.com/sto/ngx_http_auth_pam_module.git /tmp/ngx_http_auth_pam_module

# Compile Nginx
tar -xzvf /tmp/nginx-${NGX_VERSION}.tar.gz -C /tmp
pushd /tmp/nginx-${NGX_VERSION}
./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --with-threads --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-google_perftools_module --with-cpp_test_module --with-http_realip_module --with-stream_realip_module --with-debug --add-module=/tmp/ngx_http_auth_pam_module
make

# Packaged Nginx
echo 'Small, powerful, scalable web/proxy server
Nginx ("engine X") is a high-performance web and reverse proxy server created by Igor Sysoev. It can be used both as a standalone web server and as a proxy to reduce the load on back-end HTTP or mail servers.

This is a dependency package to install either nginx-full (by default), nginx-light or nginx-extras.' | sudo tee description-pak
sudo checkinstall -D --install=no -y --pkgname="nginx" --pkgversion="${NGX_VERSION}" --pkgarch='armhf' --pkgrelease="1" --pkglicense='BSD' --pkggroup='httpd' --pkgsource='nginx' --pkgaltsource='' --maintainer='pkg-nginx-maintainers@lists.alioth.debian.org' --provides='' --requires='' --conflicts='' --replaces='' --nodoc --deldoc=yes --deldesc=yes --delspec=yes --backup=no --exclude="/etc/nginx/koi-utf,/etc/nginx/koi-win,/etc/nginx/win-utf"
popd

# Copy Nginx Package to Repository
sudo cp -f /tmp/nginx-${NGX_VERSION}/nginx_${NGX_VERSION}-1_armhf.deb /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx_${NGX_VERSION}-1_armhf.deb
pushd /mnt/elasticpi/build/nginx/${NGX_VERSION}
sha512sum nginx_${NGX_VERSION}-1_armhf.deb | sudo tee nginx_${NGX_VERSION}-1_armhf.deb.sha512
popd

# Clean Temp
sudo rm -f /tmp/nginx-${NGX_VERSION}.tar.gz
sudo rm -rf /tmp/nginx-${NGX_VERSION}
sudo rm -rf /tmp/ngx_http_auth_pam_module

# Restore Node State
restore-node-state
