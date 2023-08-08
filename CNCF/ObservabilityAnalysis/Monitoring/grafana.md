#### Introduction
grafana 是一个可视化面板，有着非常漂亮的图表和布局展示，功能齐全的度量仪表盘和图形编辑器，支持 Graphite、zabbix、InfluxDB、Prometheus、OpenTSDB、Elasticsearch 等作为数据源，比 Prometheus 自带的图表展示功能强大太多，更加灵活，有丰富的插件，功能更加强大。


#### Deploy On Binaries
##### Download and Install
```shell
# option.1: Debian / Ubuntu repo
apt install -y apt-transport-https software-properties-common wget
wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list 
apt update
apt install grafana

# option.2: resource
wget https://dl.grafana.com/oss/release/grafana-10.0.3.linux-amd64.tar.gz
tar -zxvf grafana-10.0.3.linux-amd64.tar.gz && rm -f grafana-10.0.3.linux-amd64.tar.gz
cd grafana-10.0.3 
./bin/grafana server --config ./conf/defaults.ini

```

##### Config and Boot
##### [[sc-monitoring#Grafana|Grafana Config]]

```shell
# boot
systemctl daemon-reload
systemctl start grafana-server.service 
systemctl enable grafana-server.service 
```

#### Deploy On Container
##### Run On Docker
pull images
```shell
# default based images: Alpine
# oss version(open source, default)
docker pull grafana/grafana
docker pull grafana/grafana-oss
# enterprise version
docker pull grafana/grafana-enterprise


# other based images: Ubuntu
# oss version(open source, default)
docker pull grafana/grafana:latest-ubuntu
docker pull grafana/grafana-oss:latest-ubuntu
# enterprise version
docker pull grafana/grafana-enterprise:latest-ubuntu
```
start container
```shell
# run 
docker run -d -p 3000:3000 grafana/grafana-enterprise

# run with plugins
git clone https://github.com/grafana/grafana.git
cd grafana/packaging/docker/custom
docker build \
  --build-arg "GRAFANA_VERSION=latest" \
  --build-arg "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
  -t grafana-custom .
docker run -d -p 3000:3000 --name=grafana grafana-custom
```

> docker-compose = https://grafana.com/docs/grafana/latest/setup-grafana/start-restart-grafana/#docker-compose-example

##### Run On Kubernetes
**deploy on resource manifest**
```shell
cat > grafana.yaml << "EOF"
kind: PersistentVolumeClaim
...
kind: Deployment
...
kind: Service
...
EOF
# https://grafana.com/docs/grafana/latest/setup-grafana/installation/kubernetes/

# send the manifest to API Server
kubectl -n monitoring apply -f grafana.yaml

# forward port on host
kubectl -n monitoring port-forward service/grafana 3000:3000
```

**deploy on helm**
[[cc-helm|helm常用命令]]
```shell
# add and update repo
helm repo add grafana https://grafana.github.io/helm-charts
helm update

# get charts package
helm pull grafana/grafana --untar
cd grafana

# configure and run
vim values.yaml
helm -n monitorning install grafana .
```

#### Alert
...


>Reference:
>1. [Official Grafana Documentation](https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/)
>2. [Grafana Github](https://github.com/grafana/grafana)
>3. [Grafana CN Doc](https://www.qikqiak.com/k8s-book/docs/56.Grafana%E7%9A%84%E5%AE%89%E8%A3%85%E4%BD%BF%E7%94%A8.html)