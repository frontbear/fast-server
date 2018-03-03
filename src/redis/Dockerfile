FROM phusion/baseimage:0.10.0

MAINTAINER frontbear <frontbear@outlook.com>

ENV REDIS_VERSION           3.2.11

COPY ./start_service.sh         /etc/my_init.d/
COPY ./conf/redis.conf          /usr/local/src/
COPY ./src/redis-3.2.11.tar.gz  /usr/local/src/

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
libevent-dev                    \
\
&& groupadd group7 \
&& useradd -g group7 -M -d /usr/local/redis user7 -s /sbin/nologin \
\
&& chmod +x /etc/my_init.d/start_service.sh \
\
&& cd /usr/local/src \
\
&& tar -zxf redis-${REDIS_VERSION}.tar.gz \
\
&& cd /usr/local/src/redis-${REDIS_VERSION} \
&& make \
&& make PREFIX=/usr/local/redis install \
\
&& mkdir /usr/local/redis/datadir \
&& mkdir /usr/local/redis/logdir \
\
&& cd /usr/local/src \
&& yes | cp ./redis.conf          /usr/local/redis/conf_file.conf \
\
&& chown -R user7:group7                /usr/local/redis \
&& /usr/local/redis/bin/redis-server    /usr/local/redis/conf_file.conf \
&& sleep  3s \
&& /usr/local/redis/bin/redis-cli       shutdown \
\
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& rm -rf /usr/local/src/*

EXPOSE 6379

CMD ["/sbin/my_init"]
