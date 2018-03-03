#!/bin/bash

set -eux

chown -R user7:group7    /usr/local/redis

/usr/local/redis/bin/redis-server /usr/local/redis/conf_file.conf

chown -R user7:group7    /usr/local/redis
