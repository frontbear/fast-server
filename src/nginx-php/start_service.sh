#!/bin/bash

set -eux

chown -R user7:group7    /usr/local/nginx
chown -R user7:group7    /usr/local/php

/usr/local/php/sbin/php-fpm

/usr/local/nginx/sbin/nginx

chown -R user7:group7    /usr/local/nginx
chown -R user7:group7    /usr/local/php
