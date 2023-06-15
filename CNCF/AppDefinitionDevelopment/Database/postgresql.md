#### Introduction
...


#### Deployment
##### Run On Binaries
```shell
# download source
wget https://dlcdn.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz
mv apache-zookeeper-3.7.1-bin zookeeper-3.7.1 && cd zookeeper-3.7.1


# create data and logs dir
mkdir -p /opt/zookeeper-3.7.1/data
mkdir -p /opt/zookeeper-3.7.1/logs
cat > /opt/zookeeper-3.7.1/conf/zoo.cfg << "EOF"
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/opt/zookeeper-3.7.1/data
dataLogDir=/opt/zookeeper-3.7.1/logs
clientPort=2181
# cluster mode: service communication and election
# server.0=1.1.1.1:2888:3888
# server.1=1.1.1.2:2888:3888
# server.2=1.1.1.3:2888:3888
maxClientCnxns=300
admin.enableServer=false
EOF

# create version_id file if cluster mode
# echo 0 > /opt/zookeeper-3.7.1/data/myid
# echo 1 > /opt/zookeeper-3.7.1/data/myid
# echo 2 > /opt/zookeeper-3.7.1/data/myid

# run
# systemd
cat > /etc/systemd/system/zookeeper.service << "EOF"
[Unit]
Description=Zookeeper Server
Documentation=https://zookeeper.apache.org/
After=network.target
Wants=network-online.target

[Service]
Type=forking
# Environment=JAVA_HOME=/opt/jdk11
ExecStart=/opt/zookeeper-3.7.1/bin/zkServer.sh start
ExecStop=/opt/zookeeper-3.7.1/bin/zkServer.sh stop
ExecReload=/opt/zookeeper-3.7.1/bin/zkServer.sh restart
Restart=on-failure
RestartSec=5s
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start zookeeper.service
systemctl enable zookeeper.service
```

##### Run On Docker
[[cc-docker|Docker常用命令]]
```shell
# run by docker or docker-compose
docker run -d --rm --name yakir-postgres \
-e POSTGRES_PASSWORD=123qwe \
-e POSTGRES_DB=yakir_pg_test \
-p 5432:5432 postgres
POSTGRES_USER
```

##### Run On Kubernetes
[[cc-k8s|deploy by kubernetes manifest]]
```shell
# 
```

[[cc-helm|deploy by helm]]
```shell
# Add and update repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Get charts package
helm fetch bitnami/zookeeper --untar 
cd zookeeper

# Configure and run
vim values.yaml
global:
  storageClass: "nfs-client"
replicaCount: 3

helm -n middleware install zookeeper . --create-namespace 

# verify
kubectl -n middleware exec -it zookeeper-0 -- zkServer.sh status  
```



> 参考文档:
> 1. [官方文档](https://zookeeper.apache.org/)
> 2. [官方 github 地址](https://github.com/apache/zookeeper)
