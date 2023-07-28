#### Introduction
...


#### Deploy by Binaries
##### Download and Compile
```shell
# dependencies
apt install python3-pip
apt install python-dev-is-python3 libssl-dev
apt install build-essential

# download source
git clone -b r6.0.1 https://github.com/mongodb/mongo.git
cd mongo

# compile 
python3 -m pip install -r etc/pip/compile-requirements.txt
python3 buildscripts/scons.py DESTDIR=/opt/mongo install-all

# postinstallation
# groupadd mongodb
# useradd -r -g mongodb -s /bin/false mongodb
mkdir /opt/mongodb/data /opt/mongodb/logs
# chown mongodb:mongodb /opt/mongodb -R

# startup 
/opt/mongodb/bin/mongod --dbpath /opt/mongodb --logpath /opt/mongodb/logs/mongod.log --fork #--config /opt/mongodb/mongod.conf --bind_ip 0.0.0.0

```

##### Config and Boot
[[sc-mongodb|MongoDB Config]]

```shell
# boot 
cat > /etc/systemd/system/mongod.service << "EOF"
...
EOF

systemctl daemon-reload
systemctl start mongod.service
systemctl enable mongod.service
```

##### Verify
```shell
# syntax check

```

##### Troubleshooting
```shell
# problem 1
#

```


#### Deploy by Container
##### Run by Docker
```shell
# 
```

##### Run by Helm
```shell
# add and update repo
helm repo add hashicorp https://helm.releases.hashicorp.com
helm update

# get charts package
helm fetch hashicorp/vault --untar
cd vault

# configure and run
vim values.yaml
...
helm -n provisioning install vault .

```


> 参考文档：
> 1. [Vault 官方文档](https://developer.hashicorp.com/vault/docs?product_intent=vault)
> 2. [Vault GitHub](https://github.com/hashicorp/vault)
