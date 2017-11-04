#!/bin/bash
yum install httpd -y
yum install git -y
service httpd start
chkconfig httpd on
git clone https://github.com/drenner1992/website.git
cd website
git checkout one
cp -R * /root/website /var/www/html