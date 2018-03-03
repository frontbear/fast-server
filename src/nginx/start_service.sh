#!/bin/bash

set -eux

chown -R user7:group7    /usr/local/nginx

/usr/local/nginx/sbin/nginx

chown -R user7:group7    /usr/local/nginx
