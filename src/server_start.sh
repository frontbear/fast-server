#!/bin/bash

set -eux

chown -R user7:group7    /usr/local/nginx
chown -R user7:group7    /usr/local/php
chown -R user7:group7    /usr/local/mysql
chown -R user7:group7    /usr/local/redis

# init mysql
if [ -z "$(ls -A /usr/local/mysql/datadir)" ]; then
   /usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf --initialize-insecure --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/datadir
   sleep 3s
fi

# start mysql
/usr/local/mysql/support-files/mysql.server start
sleep 3s
chmod 777 /tmp/mysql.sock

# start php-fpm
/usr/local/php/sbin/php-fpm

# start redis-server
/usr/local/redis/bin/redis-server /usr/local/redis/conf_file.conf

# start nginx
/usr/local/nginx/sbin/nginx
