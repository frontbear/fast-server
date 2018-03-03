#!/bin/bash

set -eux

chown -R user7:group7    /usr/local/php

/usr/local/php/sbin/php-fpm

chown -R user7:group7    /usr/local/php
