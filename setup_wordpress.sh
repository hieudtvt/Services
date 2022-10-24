#!/bin/bash
# Cai dat Nginx

if ( yum list installed | grep -q nginx )
    then
        echo =========================================================
    else
                cat << EOF > /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=https://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF

        yum install nginx -y

        systemctl start nginx
                systemctl enable nginx
    fi
# Cai PHP

if [ yum list installed | grep -q php ]
    then

        systemctl restart nginx
    else

        yum install -y epel-release
        rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm
        yum install -y yum-utils
        yum-config-manager --enable remi-php74 php

        yum install -y php-mysql php-fpm
        systemctl restart nginx
    fi
# Cai wordpress

if [ yum list installed | grep -q wget ]
    then
        echo =======================================================================
    else
        yum install -y wget
    fi

# Config php

sed -i "s/user = apache/user = nginx/g" /etc/php-fpm.d/www.conf
sed -i "s/group = apache/group = nginx/g" /etc/php-fpm.d/www.conf
sed -i "s+listen = 127.0.0.1:9000+listen = /var/run/php-fpm/php-fpm.sock+g" /etc/php-fpm.d/www.conf
sed -i "s/;listen.owner = nobody/listen.owner = nginx/g" /etc/php-fpm.d/www.conf
sed -i 's/;listen.group = nobody/listen.group = nginx/g' /etc/php-fpm.d/www.conf

systemctl start php-fpm
systemctl enable php-fpm

# Download sourcode wordperss

cd /usr/share/nginx/html
rm -rf *

wget https://wordpress.org/latest.tar.gz

tar -xzvf latest.tar.gz

mv wordpress/* /usr/share/nginx/html

mv wp-config-sample.php wp-config.php

cd

echo 'Ten database cho wordpress (Enter se mac dinh la wordpress):'
read p1
p1=${p1:-wordpress}
echo 'Ten user su dung cho wordperss login mysql(Enter se mac dinh la user1):'
read p2
p2=${p2:-user1}
echo 'Password cho user (Enter se mac dinh la 123456):'
read p3
p3=${p3:-123456}
echo 'Nhap Ip database:'
read p4 

sed -i "s/database_name_here/$p1/g" /usr/share/nginx/html/wp-config.php
sed -i "s/username_here/$p2/g" /usr/share/nginx/html/wp-config.php
sed -i "s/password_here/$p3/g" /usr/share/nginx/html/wp-config.php
sed -i "s/localhost/$p4/g" /usr/share/nginx/html/wp-config.php

systemctl stop firewalld
setenforce 0

echo Cai thanh cong!!!!!!!!!!!!
