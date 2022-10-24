#!/bin/bash
sudo yum install -y yum-utils

cat > /etc/yum.repos.d/nginx.repo << "EOF"
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

yum install -y nginx

systemctl start nginx
systemctl enable nginx

firewall-cmd --zone=public --add-port=80/tcp --permanent 
firewall-cmd --reload
