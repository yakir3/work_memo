#### Introduction
...


#### Deployment
##### Run On Binaries
```shell
# download source
wget https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.zip
unzip nacos-server-2.2.3.zip && cd nacos


# create data and config dir
mkdir -p /opt/zookeeper-3.7.1/data
mkdir -p /opt/zookeeper-3.7.1/logs
cat > /opt/nacos/conf/application.properties << "EOF"
...
EOF


# run
# standalone
sh startup.sh -m standalone
# cluster
sh startup.sh 

```

##### Run On Docker
[[cc-docker|Docker常用命令]]
```shell
# run by docker or docker-compose
# https://hub.docker.com/r/nacos/nacos-server
```

##### Run On Kubernetes
[[cc-k8s|deploy by kubernetes manifest]]
```shell
# 
```

[[cc-helm|deploy by helm]]
```shell
# Add and update repo
helm repo add 
helm repo update

# Get charts package


# Configure and run
vim values.yaml
...
helm -n middleware install nacos . --create-namespace 

# verify

```


> 参考文档:
> 1. [官方文档](https://nacos.io/zh-cn/docs/quick-start.html)
> 2. [官方 github 地址](https://github.com/alibaba/nacos)
