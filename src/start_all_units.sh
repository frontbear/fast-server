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
if [ ! -f /usr/local/mysql/logdir/error.log ]; then
    touch /usr/local/mysql/logdir/error.log
fi

if [ ! -f /usr/local/mysql/logdir/general.log ]; then
    touch /usr/local/mysql/logdir/general.log
fi

if [ ! -f /usr/local/mysql/logdir/slow.log ]; then
    touch /usr/local/mysql/logdir/slow.log
fi

chown -R user7:group7    /usr/local/mysql

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
