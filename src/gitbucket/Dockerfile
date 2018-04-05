FROM phusion/baseimage:0.10.1

MAINTAINER frontbear <frontbear@outlook.com>

ENV GITBUCKET_VERSION           4.23.0

COPY ./start_service.sh           /etc/my_init.d/
COPY ./src/gitbucket-4.23.0.war   /usr/local/gitbucket/gitbucket.war

# see http://www.ruanyifeng.com/blog/2017/11/bash-set.html
RUN set -eux \
&& export DEBIAN_FRONTEND=noninteractive \
&& sed -i 's/http:\/\/archive.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& sed -i 's/http:\/\/security.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& sed -i 's/https:\/\/archive.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& sed -i 's/https:\/\/security.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& apt-get -y update            \
&& apt-get -y upgrade           \
&& apt-get -y install openjdk-9-jre \
graphviz \
\
&& mkdir /gitbucket \
\
&& groupadd group7 \
&& useradd -g group7 -M -d /usr/local/gitbucket user7 -s /sbin/nologin \
\
&& ln -s /gitbucket /root/.gitbucket \
\
&& chmod +x /etc/my_init.d/start_service.sh \
\
&& cd /usr/local/src \
\
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& rm -rf /usr/local/src/*

EXPOSE 8080 29418

CMD ["/sbin/my_init"]
