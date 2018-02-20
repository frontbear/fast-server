### install docker
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

### usage

#### init image
- for production
```bash
docker run \
 -v /app7/nginx/vhosts_dir:/usr/local/nginx/vhosts_dir:rw \
 -v /app7/mysql/datadir:/usr/local/mysql/datadir:rw \
 -p 80:80 \
 -p 443:443 \
 -d frontbear/fast-server:1.0.0
```

- for development
```bash
docker run \
 -v /app7/nginx/vhosts_dir:/usr/local/nginx/vhosts_dir:rw \
 -v /app7/mysql/datadir:/usr/local/mysql/datadir:rw \
 -p 80:80 \
 -p 443:443 \
 -p 3306:3306 \
 -p 6379:6379 \
 -p 9000:9000 \
 -d frontbear/fast-server:1.0.0
```

- init mysql server
```bash
chown -R app7:group7     /usr/local/mysql

/usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf             \
--initialize-insecure                                               \
--user=app7                                                         \
--basedir=/usr/local/mysql                                          \
--datadir=/usr/local/mysql/datadir

/usr/local/mysql/support-files/mysql.server start

chmod 777 /tmp/mysql.sock

# set new password
/usr/local/mysql/bin/mysqladmin -uroot password
```

- for development
```bash
sed -r -i -e "s/127.0.0.1/0.0.0.0/g" /usr/local/redis/conf_file.conf
/usr/local/redis/bin/redis-cli shutdown
/usr/local/redis/bin/redis-server /usr/local/redis/conf_file.conf

sed -r -i -e "s/127.0.0.1/0.0.0.0/g" /etc/my.cnf
/usr/local/mysql/support-files/mysql.server restart

/usr/local/mysql/bin/mysql -uroot -p
use mysql;
update `user` set `Host` = '%' where `User` = 'root' and `Host` = 'localhost';
flush privileges;
```

#### restart nginx
```bash
docker exec -d CONTAINER /usr/local/nginx/sbin/nginx -s reload
```

#### restart mysql
```bash
touch /usr/local/mysql/log_error_file.log
chown -R app7:group7 /usr/local/mysql
/usr/local/mysql/support-files/mysql.server start
```

#### enable mysql query log
```bash
SET global log_output = 'file';
SET global general_log = 1;
SET global general_log_file = '/usr/local/nginx/vhosts_dir/PATH/query.log';
```

### REFERENCE
- [Initializing the Data Directory Manually Using mysqld](https://dev.mysql.com/doc/refman/5.7/en/data-directory-initialization-mysqld.html)