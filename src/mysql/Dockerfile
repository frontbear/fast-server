FROM phusion/baseimage:0.10.1

MAINTAINER frontbear <frontbear@outlook.com>

ENV PERCONA_VERSION         5.7.22-22
ENV BOOST_VERSION           1_59_0

COPY ./start_service.sh                        /etc/my_init.d/
COPY ./conf/generated.my.cnf                   /etc/my.cnf
COPY ./src/boost_1_59_0.tar.gz                 /usr/local/src/
COPY ./src/percona-server-5.7.22-22.tar.gz     /usr/local/src/

# see http://www.ruanyifeng.com/blog/2017/11/bash-set.html
RUN set -eux \
&& export DEBIAN_FRONTEND=noninteractive \
&& sed -i 's/http:\/\/archive.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& sed -i 's/http:\/\/security.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& sed -i 's/https:\/\/archive.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& sed -i 's/https:\/\/security.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
&& apt-get -y update            \
&& apt-get -y upgrade           \
&& apt-get -y install cmake     \
bison                           \
build-essential                 \
libjemalloc-dev                 \
libssl-dev                      \
libcurl4-openssl-dev            \
libedit-dev                     \
libeditline-dev                 \
libevent-dev                    \
liblz4-dev                      \
zlib1g-dev                      \
\
&& CPU_NUM=`cat /proc/cpuinfo | grep processor | wc -l` \
\
&& groupadd group7 \
&& useradd -g group7 -M -d /usr/local/mysql user7 -s /sbin/nologin \
\
&& chmod +x /etc/my_init.d/start_service.sh \
\
&& cd /usr/local/src \
\
&& tar -zxf percona-server-${PERCONA_VERSION}.tar.gz \
&& tar -zxf boost_${BOOST_VERSION}.tar.gz \
\
&& cd /usr/local/src/percona-server-${PERCONA_VERSION} \
&& cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DDEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_unicode_ci \
-DENABLED_LOCAL_INFILE=1 \
-DENABLED_PROFILING=1 \
-DENABLE_DOWNLOADS=0 \
-DWITH_LIBEVENT=system \
-DWITH_SSL=system \
-DWITH_ZLIB=system \
-DWITH_LZ4=system \
-DWITH_EDITLINE=system \
-DWITH_SYSTEMD=0 \
-DSYSCONFDIR=/etc \
-DMYSQL_DATADIR=/usr/local/mysql/datadir \
-DTMPDIR=/usr/local/mysql/tmpdir \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DWITH_BOOST=/usr/local/src/boost_${BOOST_VERSION} \
-DMYSQL_TCP_PORT=3306 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_EXAMPLE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
-DWITH_ROCKSDB=1 \
-DWITH_TOKUDB=0 \
-DWITH_EXTRA_CHARSETS=all \
\
&& make -j${CPU_NUM} \
&& make install \
\
&& mkdir /usr/local/mysql/datadir \
&& mkdir /usr/local/mysql/logdir \
&& mkdir /usr/local/mysql/tmpdir \
\
&& chown -R user7:group7 /usr/local/mysql \
&& chown -R user7:group7 /etc/my.cnf \
\
&& rm -rf /usr/local/mysql/mysql-test \
\
&& echo '' >> ~/.bashrc
&& echo 'export PATH="$PATH:/usr/local/mysql/bin"' >> ~/.bashrc
&& source ~/.bashrc
\
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& rm -rf /usr/local/src/*

EXPOSE 3306

CMD ["/sbin/my_init"]
