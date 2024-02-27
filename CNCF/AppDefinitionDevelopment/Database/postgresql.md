#### Introduction
...


#### Deploy by Binaries
##### Download and Compile
```shell
# download source
wget https://ftp.postgresql.org/pub/source/v15.1/postgresql-15.1.tar.gz
tar xf postgresql-15.1.tar.gz && rm -f postgresql-15.1.tar.gz 
cd postgresql-15.1/

# compile 
mkdri bld && cd bld
../configure --prefix=/opt/pgsql --with-systemd
make -j `grep processor /proc/cpuinfo | wc -l`
make install

# postinstallation
groupadd postgres
useradd -r -g postgres -s /bin/false postgres
mkdir /opt/pgsql/data /opt/pgsql/logs
chown postgres:postgres /opt/pgsql -R

# startup 
/opt/pgsql/bin/pg_ctl -D /opt/pgsql/data initdb
/opt/pgsql/bin/pg_ctl -D /opt/pgsql/data -l /opt/pgsql/logs/pgsql.log start

```

##### Config and Boot
[[sc-mysqld|Postgresql Config]]

```shell
# boot 
cat > /etc/systemd/system/postgresql.service << "EOF"
[Unit]
Description=PostgreSQL database server
Documentation=man:postgres(1)

[Service]
Type=notify
User=postgres
ExecStart=/opt/pgsql/bin/postgres -D /opt/pgsql/data
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGINT
TimeoutSec=0

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start postgresql.service
systemctl enable postgresql.service
```

##### Verify
```shell
# syntax check
/opt/pgsql/bin/postgres --version
postgres (PostgreSQL) 15.1
```

##### Troubleshooting
```shell
# problem 1
# configure: error: readline library not found
apt install libreadline-dev

# problem 2
# configure: error: header file <systemd/sd-daemon.h> is required for systemd support 
apt install libsystemd-dev


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
helm fetch bitnami/postgresql --untar
cd postgresql

# configure and run
vim values.yaml
...
helm -n middleware install postgresql .

```


> Reference:
> 1. [官方文档](https://www.postgresql.org/)
> 2. [GitHub 地址](https://github.com/postgres/postgres)
> 3. [apt 安装方式](https://www.postgresql.org/download/linux/ubuntu/)
> 4. [PgsqlConfig Generate](https://pgtune.leopard.in.ua/)