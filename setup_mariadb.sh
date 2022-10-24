#!/bin/bash
# Cai dat database
yum install -y mariadb-server
systemctl start mariadb

# Tao database cho wordpress
echo "Khoi tao password de login vao mysql:"
read pw

echo "Ten database wordpress (Enter mac dinh se la wordpress):"
read db
db=${db:-wordpress}
echo "Ten user su dung cho wordpress (Enter mac dinh se la user1):"
read u1
u1=${u1:-user1}
echo "Password cua user (Enter mac dinh se la 123456):"
read p1
p1=${p1:-123456}
echo "Nhap ip webserver:"
read ip
mysqladmin -u root password $pw

mysql -u root -p"$pw" -e "create database $db"
mysql -u root -p"$pw" -e "create user '$u1'@'$ip' identified by '$p1'"
mysql -u root -p"$pw" -e "grant all privileges on $db.* to '$u1'@'$ip'"
mysql -u root -p"$pw" -e "flush privileges"

systemctl stop firewalld

echo "Cai dat mariadb thanh cong !!!!!!!!!!!!"
