FROM phusion/baseimage:0.10.0

MAINTAINER frontbear <frontbear@outlook.com>

ENV NGINX_VERSION         1.13.9
ENV PHP_VERSION           7.1.15

COPY ./start_service.sh         /etc/my_init.d/

COPY ./conf/nginx.conf            /usr/local/src/
COPY ./src/nginx-1.13.9.tar.gz    /usr/local/src/

COPY ./conf/php.ini             /usr/local/src/
COPY ./conf/php-fpm.conf        /usr/local/src/
COPY ./conf/www.conf            /usr/local/src/
COPY ./src/php-7.1.15.tar.gz    /usr/local/src/

# see http://www.ruanyifeng.com/blog/2017/11/bash-set.html
RUN set -eux \
&& export DEBIAN_FRONTEND=noninteractive \
&& sed -i 's/http:\/\/archive.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& sed -i 's/http:\/\/security.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& sed -i 's/https:\/\/archive.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& sed -i 's/https:\/\/security.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& apt-get -y update            \
&& apt-get -y upgrade           \
&& apt-get -y install build-essential \
\
libssl-dev                      \
zlib1g-dev                      \
libpcre3-dev                    \
libgeoip-dev                    \
libjemalloc-dev                 \
libevent-dev                    \
\
re2c                            \
bison                           \
libtool                         \
libssl-dev                      \
zlib1g-dev                      \
libpcre3-dev                    \
libedit-dev                     \
libeditline-dev                 \
libgd-dev                       \
libwebp-dev                     \
libfreetype6-dev                \
libpng12-dev                    \
libjpeg-dev                     \
libxml2-dev                     \
libbz2-dev                      \
libcurl4-openssl-dev            \
libgmp-dev                      \
libreadline-dev                 \
libicu-dev                      \
libzip-dev                      \
libtidy-dev                     \
libevent-dev                    \
\
&& CPU_NUM=`cat /proc/cpuinfo | grep processor | wc -l` \
\
&& groupadd group7 \
&& useradd -g group7 -M -d /usr/local/php user7 -s /sbin/nologin \
\
&& chmod +x /etc/my_init.d/start_service.sh \
\
\
&& cd /usr/local/src \
&& tar -zxf nginx-${NGINX_VERSION}.tar.gz \
&& cd /usr/local/src/nginx-${NGINX_VERSION} \
&& ./configure --prefix=/usr/local/nginx \
--without-select_module \
--with-poll_module \
--with-threads \
--with-file-aio \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_geoip_module \
--with-http_geoip_module=dynamic \
--with-http_sub_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-http_stub_status_module \
--without-mail_pop3_module \
--without-mail_imap_module \
--without-mail_smtp_module \
--with-stream \
--with-stream=dynamic \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_geoip_module \
--with-stream_geoip_module=dynamic \
--with-stream_ssl_preread_module \
--with-pcre \
--with-pcre-jit \
--with-ld-opt="-ljemalloc" \
\
&& make \
&& make install \
\
&& mkdir -p /usr/local/nginx/vhosts/cfg \
&& mkdir -p /usr/local/nginx/vhosts/logs \
&& mkdir -p /usr/local/nginx/vhosts/certbot \
\
&& cd /usr/local/src \
&& yes | cp ./nginx.conf  /usr/local/nginx/conf/nginx.conf \
\
&& chown -R user7:group7            /usr/local/nginx \
&& /usr/local/nginx/sbin/nginx -t \
&& /usr/local/nginx/sbin/nginx \
&& sleep 3s \
&& /usr/local/nginx/sbin/nginx -s stop \
\
\
&& cd /usr/local/src \
&& tar -zxf php-${PHP_VERSION}.tar.gz \
&& cd /usr/local/src/php-${PHP_VERSION} \
&& ./configure --prefix=/usr/local/php \
--enable-fpm \
--with-fpm-user=user7 \
--with-fpm-group=group7 \
--disable-short-tags \
--with-libxml-dir \
--with-openssl \
--with-openssl-dir \
--with-pcre-regex \
--with-pcre-dir \
--with-pcre-jit \
--with-zlib \
--with-zlib-dir \
--enable-bcmath \
--with-bz2 \
--enable-calendar \
--with-curl \
--enable-exif \
--with-gd \
--with-webp-dir \
--with-jpeg-dir \
--with-png-dir \
--with-xpm-dir \
--with-freetype-dir \
--enable-gd-native-ttf \
--enable-gd-jis-conv \
--with-gettext \
--with-gmp \
--with-mhash \
--enable-intl \
--with-icu-dir=/usr \
--enable-mbstring \
--enable-mysqlnd \
--enable-pdo \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--enable-pcntl \
--with-readline \
--enable-soap \
--enable-sockets \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
--with-tidy \
--with-xmlrpc \
--enable-zip \
--with-libzip \
--with-iconv-dir \
--with-pear \
\
&& make -j${CPU_NUM} \
&& make install \
\
&& mkdir /usr/local/php/logdir \
&& mkdir -p /usr/local/php/cfgdir/php-fpm.d \
\
&& cd /usr/local/src \
&& yes | cp ./php-fpm.conf /usr/local/php/etc/php-fpm.conf \
&& yes | cp ./www.conf     /usr/local/php/cfgdir/php-fpm.d/www.conf \
&& yes | cp ./php.ini      /usr/local/php/lib/php.ini \
\
&& chown -R user7:group7        /usr/local/php \
&& /usr/local/php/sbin/php-fpm \
&& sleep  3s \
&& kill -INT `cat /usr/local/php/var/run/php-fpm.pid` \
\
\
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& rm -rf /usr/local/src/*

EXPOSE 80 443 9000

CMD ["/sbin/my_init"]
