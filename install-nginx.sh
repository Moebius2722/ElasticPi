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

# Get IP Host
iphost=`hostname -I | cut -d ' ' -f 1`

# Get last digit IP host
idhost=${iphost:(-1):1}

# Get subnet IP host
subiphost=${iphost::-1}

# Set Version
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
wget -P/tmp http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz && tar -xzvf /tmp/nginx-${NGX_VERSION}.tar.gz -C /tmp && pushd /tmp/nginx-${NGX_VERSION}
./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --with-threads --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-google_perftools_module --with-cpp_test_module --with-debug --add-module=/tmp/ngx_http_auth_pam_module
make
sudo make install
popd
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
sudo cp -f /opt/elasticpi/Nginx/restricted_groups /etc/nginx/restricted_groups

# Allow Nginx to read /etc/shadow file for PAM authentication
sudo usermod -a -G shadow www-data

# Set PAM Authentication for Nginx
sudo cp -f /opt/elasticpi/Nginx/nginx_restricted /etc/pam.d/nginx_restricted

# Set Nginx Default Site redirect on local Kibana with PAM authentication
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
for i in {0..9}
do
if [[ "$i" -eq "$idhost" ]]; then
echo "    server $subiphost$i:$remoteserviceport;" | sudo tee -a /etc/nginx/sites-available/default
else
echo "    server $subiphost$i:$remoteserviceport backup;" | sudo tee -a /etc/nginx/sites-available/default
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
for i in {0..9}
do
if [[ "$i" -eq "$idhost" ]]; then
echo "        server $subiphost$i:$remoteserviceport;" | sudo tee -a /etc/nginx/nginx.conf
else
echo "        server $subiphost$i:$remoteserviceport backup;" | sudo tee -a /etc/nginx/nginx.conf
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

# Configure Nginx Daemon
sudo sed -i '/\[Service\]/a Restart=always' /lib/systemd/system/nginx.service
sudo /bin/systemctl daemon-reload

# Restart Nginx Daemon for Update Configuration
restart-nginx

# Secured Kibana
#sudo sed -i 's/.*server\.host:.*/server\.host: "127.0.0.1"/' /etc/kibana/kibana.yml
#restart-kibana
