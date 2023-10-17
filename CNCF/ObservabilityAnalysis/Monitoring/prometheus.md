#### Introduction
...


#### Deploy On Binaries
##### Download and Install
```shell
# download source and decompress
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
tar xf prometheus-2.45.0.linux-amd64.tar.gz && rm -f prometheus-2.45.0.linux-amd64.tar.gz
mv prometheus-2.45.0.linux-amd64 /opt/prometheus 
cd /opt/prometheus

# postinstallation
groupadd prometheus
useradd -r -g prometheus -s /bin/false prometheus
chown prometheus:prometheus /opt/prometheus -R

# startup 
./prometheus --config.file=prometheus.yml [--web.enable-lifecycle]
# prometheus metris
curl 127.0.0.1:9090/metrics
# dynamics reload
curl 127.0.0.1:9090/-/reload -X POST

```

##### Config and Boot
[[sc-monitoring|Prometheus Config]]

```shell
# boot
cat > /etc/systemd/system/prometheus.service << "EOF"
[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Restart=on-failure
ExecStart=/opt/prometheus/prometheus \
  --config.file=/opt/prometheus/prometheus.yml \
  --storage.tsdb.path=/opt/prometheus/data \
  --storage.tsdb.retention.time=30d \
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start prometheus.service
systemctl enable prometheus.service

# verify
# random client and metrics
git clone https://github.com/prometheus/client_golang.git
cd client_golang/examples/random
go get -d && go build
./random -listen-address=:8080
./random -listen-address=:8081
./random -listen-address=:8082
# get metrics(browser access localhost:9090/graph)
avg(rate(rpc_durations_seconds_count[5m])) by (job, service)
# custom record metrics
job_service:rpc_durations_seconds_count:avg_rate5m

```


#### Deploy On Container
##### Run On Docker
```shell
mkdir /opt/prometheus
cat > /opt/prometheus/prometheus.yml << "EOF"
...
EOF

# dockerhub
docker run --name prometheus --rm -p 9090:9090 -v /opt/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
# quay.io
docker run --name prometheus --rm -p 9090:9090 -v /opt/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml quay.io/prometheus/prometheus

```

##### Run On Helm
```shell
# add and update repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm update

# get charts package
helm fetch prometheus-community/prometheus --untar
cd prometheus

# configure and run
vim values.yaml
server:
  persistentVolume:
    enabled: true
    storageClass: "nfs-client"
kube-state-metrics:
  enabled: true

# install
helm -n monitoring install prometheus .

# access and test

```


#### Visualization
##### [[grafana|Grafana]]

##### [console template](https://prometheus.io/docs/visualization/consoles/)


#### node_exporter && blackbox_exporter
##### Download and Install
```shell
# baniry
cd /opt/prometheus
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.24.0/blackbox_exporter-0.24.0.linux-amd64.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar xf blackbox_exporter-0.24.0.linux-amd64.tar.gz && rm -f blackbox_exporter-0.24.0.linux-amd64.tar.gz 
tar xf node_exporter-1.6.1.linux-amd64.tar.gz && rm -f node_exporter-1.6.1.linux-amd64.tar.gz
./blackbox_exporter-0.24.0.linux-amd64/blackbox_exporter
./node_exporter-1.6.1.linux-amd64/node_exporter

# helm
# node_exporter: include prometheus chart package
# black_exporter
helm fetch --untar prometheus-community/prometheus-blackbox-exporter
```


#### AlertManager
##### Download and Install
```shell
# baniry
cd /opt/prometheus
wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz
tar xf alertmanager-0.25.0.linux-amd64.tar.gz && rm -f alertmanager-0.25.0.linux-amd64.tar.gz
mv alertmanager-0.25.0.linux-amd64 alertmanager

# helm
# include prometheus chart package
```

##### [[sc-monitoring#Alertmanager|Alert Config]]
```shell
cat > /opt/prometheus/alertmanager/alertmanager.yml << "EOF"
...
EOF

cd /opt/prometheus/alertmanager/
./alertmanager --config.file=alertmanager.yml
```


>Reference:
>1. [Official Prometheus Doc](https://prometheus.io/docs/introduction/overview/)
>2. [Prometheus Github](https://github.com/prometheus/prometheus)
>3. [Prometheus Download](https://prometheus.io/download/)
>4. [中文社区文档](https://icloudnative.io/prometheus/)
>5. [InfluxDB Doc](https://docs.influxdata.com/influxdb/v1.8/introduction/get-started/)