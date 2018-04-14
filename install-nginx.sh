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

# Get and Install GCC and MAKE
sudo apt-get install gcc g++ make -y

####### NGINX #######

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
    sudo sha512sum /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz | sudo tee /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz.sha512

    # Get Auth PAM module
    sudo git clone https://github.com/sto/ngx_http_auth_pam_module.git /mnt/elasticpi/build/nginx/${NGX_VERSION}/ngx_http_auth_pam_module

    # Compile Nginx
    sudo mkdir -p /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION} && sudo tar -xzvf /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz -C /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION} && pushd /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}
    sudo ./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --with-threads --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-google_perftools_module --with-cpp_test_module --with-http_realip_module --with-stream_realip_module --with-debug --add-module=/mnt/elasticpi/build/nginx/${NGX_VERSION}/ngx_http_auth_pam_module
    sudo make
    popd
  fi
  popd
else
  # Get Nginx Source
  rm -f /tmp/nginx-${NGX_VERSION}.tar.gz
  wget -P/tmp http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz && sudo cp -f /tmp/nginx-${NGX_VERSION}.tar.gz /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz && rm -f /tmp/nginx-${NGX_VERSION}.tar.gz
  sudo sha512sum /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz | sudo tee /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz.sha512

  # Get Auth PAM module
  sudo git clone https://github.com/sto/ngx_http_auth_pam_module.git /mnt/elasticpi/build/nginx/${NGX_VERSION}/ngx_http_auth_pam_module

  # Compile Nginx
  sudo tar -xzvf /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}.tar.gz -C /mnt/elasticpi/build/nginx/${NGX_VERSION} && pushd /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}
  sudo ./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --with-threads --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-google_perftools_module --with-cpp_test_module --with-http_realip_module --with-stream_realip_module --with-debug --add-module=/mnt/elasticpi/build/nginx/${NGX_VERSION}/ngx_http_auth_pam_module
  sudo make
  popd
fi

# Install Nginx Reverse Proxy
pushd /mnt/elasticpi/build/nginx/${NGX_VERSION}/nginx-${NGX_VERSION}
sudo make install
popd

# Configure Nginx Daemon
sudo apt-get -o Dpkg::Options::="--force-overwrite" -o Dpkg::Options::="--force-confnew" install nginx-common -q -y
sudo sed -i '/\[Service\]/a Restart=always' /lib/systemd/system/nginx.service
sudo /bin/systemctl daemon-reload

# Configure Nginx
configure-nginx
