#### Introduction
...


#### Deploy by Binaries
##### Download and Compile
```shell
# download source with boost lib
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-boost-8.0.34.tar.gz
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
tar xf mysql-boost-8.0.34.tar.gz && rm -f mysql-8.0.34

# compile 
mkdir /opt/mysql
mkdir bld && cd bld
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/mysql -DMYSQL_DATADIR=/opt/mysql/data -DWITH_BOOST=/root/mysql-8.0.34/boost/ -DSYSCONFDIR=/opt/mysql/sysconfig
make -j `grep processor /proc/cpuinfo | wc -l`
make install

# postinstallation
cd /opt/mysql
# mkdir mysql-files && chmod 750 mysql-files
chown mysql:mysql /opt/mysql -R
./bin/mysqld --initialize --user=mysql --basedir=/opt/mysql --datadir=/opt/mysql/data
# ./bin/mysql_ssl_rsa_setup

# startup
./bin/mysqld_safe --user=mysql &
# reset root password
./bin/mysql -uroot -p

# my.cnf config
mkdir /opt/mysql/sysconfig
cat > /opt/mysql/sysconfig/my.cnf << "EOF"
...
EOF

```

##### Config and Boot
[[sc-mysqld|Mysqld Config]]

```shell
# boot 
cp support-files/mysql.server /etc/init.d/mysql

systemctl daemon-reload
systemctl start mysql.service
systemctl enable mysql.service
```

##### Verify
```shell
# syntax check
./bin/mysql -V
Ver 8.0.34 for Linux on x86_64 (Source distribution)
```

##### Troubleshooting
```shell
# every remake need to execute
make clean && rm CMakeCache.txt

# problem 1
# CMake Error at cmake/readline.cmake:92 (MESSAGE):
# Curses library not found.  Please install appropriate package,
apt install libncurses5-dev

# problem 2
# CMake Warning at cmake/pkg-config.cmake:29 (MESSAGE):
# Cannot find pkg-config.  You need to install the required package:
apt install pkg-config

# problem 3


```


#### Deploy by Container
##### Run by Resource
```shell
#
```

##### Run by Helm
```shell
# add and update repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm update

# get charts package
helm fetch bitnami/mysql --untar
cd mysql

# configure and run
vim values.yaml
...
helm -n middleware install mysql .

```


> 参考文档：
> 1. [官方文档](https://www.mysql.com/)
> 2. [GitHub 地址](https://github.com/mysql/mysql-server)
> 3. [Download](https://dev.mysql.com/downloads/)
> 4. [apt 安装方式](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/)
