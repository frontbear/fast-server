### Install Docker
```bash
sed -r -i -e "s/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list

apt-get -y update && apt-get -y upgrade

apt-get remove docker docker-engine docker.io

apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get -y update && apt-get -y upgrade

apt-get -y install docker-ce

docker run hello-world
```

### Basic Usage

#### init
- for production
```bash
docker run \
 -v /app7/nginx/vhosts:/usr/local/nginx/vhosts:rw \
 -v /app7/mysql/datadir:/usr/local/mysql/datadir:rw \
 -p 80:80 \
 -p 443:443 \
 -d frontbear/fastserver:1.0.5
```

- for development
```bash
# Linux
docker run \
 -v /app7/nginx/vhosts:/usr/local/nginx/vhosts:rw \
 -v /app7/php/logdir:/usr/local/php/logdir:rw \
 -v /app7/php/cfgdir:/usr/local/php/cfgdir:rw \
 -v /app7/redis/datadir:/usr/local/redis/datadir:rw \
 -v /app7/redis/logdir:/usr/local/redis/logdir:rw   \
 -v /app7/mysql/datadir:/usr/local/mysql/datadir:rw \
 -v /app7/mysql/logdir:/usr/local/mysql/logdir:rw \
 -p 80:80 \
 -p 443:443 \
 -p 3306:3306 \
 -p 6379:6379 \
 -p 9000:9000 \
 -d frontbear/fastserver:1.0.5

# Windows
docker run \
 -v d:/app7/nginx/vhosts:/usr/local/nginx/vhosts:rw \
 -v d:/app7/php/logdir:/usr/local/php/logdir:rw \
 -v d:/app7/php/cfgdir:/usr/local/php/cfgdir:rw \
 -v d:/app7/redis/datadir:/usr/local/redis/datadir:rw \
 -v d:/app7/redis/logdir:/usr/local/redis/logdir:rw   \
 -v d:/app7/mysql/datadir:/usr/local/mysql/datadir:rw \
 -v d:/app7/mysql/logdir:/usr/local/mysql/logdir:rw \
 -p 80:80 \
 -p 443:443 \
 -p 3306:3306 \
 -p 6379:6379 \
 -p 9000:9000 \
 -d frontbear/fastserver:1.0.5
```

- set new password for mysql
```bash
/usr/local/mysql/bin/mysqladmin -uroot password
```

- for development
```bash
sed -r -i -e "s/127.0.0.1/0.0.0.0/g" /usr/local/redis/conf_file.conf \
&& /usr/local/redis/bin/redis-cli shutdown \
&& sleep 1s \
&& /usr/local/redis/bin/redis-server /usr/local/redis/conf_file.conf

sed -r -i -e "s/127.0.0.1/0.0.0.0/g" /etc/my.cnf \
&& /usr/local/mysql/support-files/mysql.server restart

/usr/local/mysql/bin/mysql -uroot -p
use mysql;
update `user` set `Host` = '%' where `User` = 'root' and `Host` = 'localhost';
flush privileges;
```

### Useful Commands

#### restart nginx
```bash
docker exec -d CONTAINER /usr/local/nginx/sbin/nginx -s reload
```

#### restart mysql
```bash
touch /usr/local/mysql/log_error_file.log
chown -R user7:group7 /usr/local/mysql
/usr/local/mysql/support-files/mysql.server start/restart
```

#### enable mysql query log
```bash
SET global log_output = 'file';
SET global general_log = 1;
SET global general_log_file = '/usr/local/nginx/vhosts/PATH/query.log';
```

### REFERENCE
- [Initializing the Data Directory Manually Using mysqld](https://dev.mysql.com/doc/refman/5.7/en/data-directory-initialization-mysqld.html)
