#!/bin/sh
yum -y install httpd php
chkconfig httpd on
/etc/init.d/httpd start
cd /var/www/html
wget http://s3-demo-using-terraform.s3-website-us-east-1.amazonaws.com/demo.zip
unzip demo.zip