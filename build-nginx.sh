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
if [ -f /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.sha512 ] && [ -d /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION} ]; then
  pushd /mnt/elasticpi/build/nginx/${NGX_VERSION}
  sha512sum -c /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.sha512
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
sudo apt-get install gcc g++ make libpcre3 libpcre3-dev libperl5.24 libperl-dev zlib1g zlib1g-dev libssl-dev libssl1.0.2 libxml2 libxml2-dev libxslt1.1 libxslt1-dev libjpeg62-turbo libjpeg62-turbo-dev libgd3 libgd-dev libgeoip1 libgeoip-dev libgoogle-perftools4 libgoogle-perftools-dev libpam0g libpam0g-dev -q -y

# Create Nginx Build Folder
if [ ! -d "/mnt/elasticpi/build/nginx/${NGX_VERSION}" ]; then
  sudo mkdir -p /mnt/elasticpi/build/nginx/${NGX_VERSION}
  sudo chown -R root:root /mnt/elasticpi/build
  sudo chmod -R u=rwx,g=rwx,o=rx /mnt/elasticpi/build
fi

# Get and Check Nginx Source
if [ -f /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz.sha512 ] && [ -f /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz.sha512 ]; then
  pushd /mnt/elasticpi/build/nginx/${NGX_VERSION}
  sha512sum -c /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz.sha512
  if [ $? -ne 0 ] ; then
    # Get Nginx Source
    rm -f /tmp/nginx-${NGX_VERSION}.tar.gz
    wget -P/tmp http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz && sudo cp -f /tmp/nginx-${NGX_VERSION}.tar.gz /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz && rm -f /tmp/nginx-${NGX_VERSION}.tar.gz
    pushd /mnt/elasticpi/build/nginx/${NGX_VERSION} && sha512sum nginx-${NGX_VERSION}.tar.gz | sudo tee /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz.sha512 && popd

    # Get Auth PAM module
    sudo git clone https://github.com/sto/ngx_http_auth_pam_module.git /mnt/elasticpi/build/nginx/${NGX_VERSION}/ngx_http_auth_pam_module


  fi
  popd
else
  # Get Nginx Source
  rm -f /tmp/nginx-${NGX_VERSION}.tar.gz
  wget -P/tmp http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz && sudo cp -f /tmp/nginx-${NGX_VERSION}.tar.gz /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz && rm -f /tmp/nginx-${NGX_VERSION}.tar.gz
  pushd /mnt/elasticpi/build/nginx/${NGX_VERSION} && sha512sum nginx-${NGX_VERSION}.tar.gz | sudo tee /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz.sha512 && popd

  # Get Auth PAM module
  sudo git clone https://github.com/sto/ngx_http_auth_pam_module.git /mnt/elasticpi/build/nginx/${NGX_VERSION}/ngx_http_auth_pam_module

fi

# Compile Nginx
sudo mkdir -p /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION} && sudo tar -xzvf /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz -C /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION} && pushd /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}
sudo ./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --with-threads --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-google_perftools_module --with-cpp_test_module --with-http_realip_module --with-stream_realip_module --with-debug --add-module=/mnt/elasticpi/build/nginx/${NGX_VERSION}/ngx_http_auth_pam_module
sudo make
popd


find /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION} -type f -print0 | xargs -0 sha256sum | sudo tee /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-1.15.6.sha256


# Restore Node State
restore-node-state
