#!/bin/bash

set -eux

chown -R user7:group7    /usr/local/nginx
chown -R user7:group7    /usr/local/php
chown -R user7:group7    /usr/local/mysql
chown -R user7:group7    /usr/local/redis

if [ -z "$(ls -A /usr/local/mysql/datadir)" ]; then
   /usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf --initialize-insecure --user=user7 --basedir=/usr/local/mysql --datadir=/usr/local/mysql/datadir
   sleep 3s
fi

# mysql
if [ ! -f /usr/local/mysql/log_error_file.log ]; then
    touch /usr/local/mysql/log_error_file.log
    chown -R user7:group7    /usr/local/mysql
fi

/usr/local/mysql/support-files/mysql.server start
sleep 3s
chmod 777 /tmp/mysql.sock

# php
/usr/local/php/sbin/php-fpm

# redis
/usr/local/redis/bin/redis-server /usr/local/redis/conf_file.conf

# nginx
/usr/local/nginx/sbin/nginx

chown -R user7:group7    /usr/local/nginx
chown -R user7:group7    /usr/local/php
chown -R user7:group7    /usr/local/mysql
chown -R user7:group7    /usr/local/redis
