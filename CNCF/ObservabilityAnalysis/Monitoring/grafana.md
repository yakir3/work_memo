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
docker run -d -p 3000:3000 --name=grafana \
  -e "GF_INSTALL_PLUGINS=grafana-clock-panel 1.0.1" \
  grafana/grafana-oss:latest-ubuntu
docker run -d -p 3000:3000 --name=grafana --rm \
  -e "GF_INSTALL_PLUGINS=grafana-image-renderer" \
  grafana/grafana-enterprise:latest-ubuntu

# run with plugins by source
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
helm fetch grafana/grafana --untar
cd grafana

# configure and run
vim values.yaml
helm -n monitorning install grafana .
```


#### Grafana Labs
##### Node 
```shell
# Node Exporter Full
1860


```

##### Kubernetes
```shell
# K8s Cluster Summary
8685

# Kubernetes Pods
3146

# Kubernetes cluster monitoring (via Prometheus)
315

# 
```


#### Alert
##### telegra_bot
```shell
# 1.get bot and token
https://core.telegram.org/bots#how-do-i-create-a-bot
https://core.telegram.org/bots/features#botfather

# 2.create telegram alert group and invited bot into group

# 3.get bot or chat_id info
curl https://api.telegram.org/bot<token>/getMe
curl https://api.telegram.org/bot<token>/getUpdates

# 4.send test message
curl "https://api.telegram.org/bot<token>/sendMessage?chat_id=<chat_id>&text=<msg>"

# 5.add bot to grafana

```

##### alerting config
1. Dashboard --> edit panel --> create alert rule from this panel
![[Pasted image 20230821114504.png]]

2. Notifications --> add Labels(related Contact points)
![[Pasted image 20230821114732.png]]
![[Pasted image 20230821114429.png]]

3. Contact points --> Add template --> create notification template
![[Pasted image 20230821143025.png]]

![[Pasted image 20230822100216.png]]
```jinja2
{{ define "tg_alert_template" -}}
{{/* firing info */}}
{{- if gt (len .Alerts.Firing) 0 -}}
{{ range $index, $alert := .Alerts }}
=========={{ $alert.Status }}==========
告警名称: {{ $alert.Labels.alertname }}
告警级别: {{ $alert.Labels.severity }}
告警详情: {{ $alert.Annotations.summary }};{{ $alert.Annotations.description }}
故障时间: {{ ($alert.StartsAt.Add 28800e9).Format "2006-01-02 15:04:05" }}
实例信息: {{ $alert.Labels.instance }}
当前数值: {{ $alert.values.alarmvalue}}
静默告警: {{ .SilenceURL }}
告警大盘: {{ .DashboardURL }}
============END============
{{- end -}}
{{- end }}
{{/* resolved info */}}
{{- if gt (len .Alerts.Resolved) 0 -}}
{{ range $index, $alert := .Alerts }}
=========={{ $alert.Status }}==========
告警名称: {{ $alert.Labels.alertname }}
告警级别: {{ $alert.Labels.severity }}
告警详情: {{ $alert.Annotations.summary }};{{ $alert.Annotations.description }}
故障时间: {{ ($alert.StartsAt.Add 28800e9).Format "2006-01-02 15:04:05" }}
恢复时间: {{ ($alert.EndsAt.Add 28800e9).Format "2006-01-02 15:04:05" }}
实例信息: {{ $alert.Labels.instance }}
当前数值: {{ $alert.values.alarmvalue }}
静默告警: {{ .SilenceURL }}
告警大盘: {{ .DashboardURL }}
============END============
{{- end -}}
{{- end }}
{{- end -}}
```

4. Contact points --> Add contact point --> create telegram contact point
![[Pasted image 20230821115559.png]]
```jinja2
# Message
{{ template "tg_alert_template" . }}
```

![[Pasted image 20230822100054.png]]

5. Notification policies --> New nested policy --> create new notification policy
![[Pasted image 20230821115717.png]]

6. Check alert notification
![[Pasted image 20230823080802.png]]



>Reference:
>1. [Official Grafana Documentation](https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/)
>2. [Grafana Github](https://github.com/grafana/grafana)
>3. [Grafana CN Doc](https://www.qikqiak.com/k8s-book/docs/56.Grafana%E7%9A%84%E5%AE%89%E8%A3%85%E4%BD%BF%E7%94%A8.html)
>4. [Grafana Alert](https://grafana.com/docs/grafana/latest/alerting/fundamentals/)
>5. [Telegram Api SDK](https://github.com/python-telegram-bot/python-telegram-bot/wiki/Introduction-to-the-API)