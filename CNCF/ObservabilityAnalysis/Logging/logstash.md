#### Introduction
...

#### Deploy by Binaries
##### Download and Compile
```shell
# 1.download and decompression
https://www.elastic.co/downloads/logstash

# 2.configure
touch config/logstash.conf
vim config/logstash.conf

# 3.run
bin/logstash -f logstash.conf
```


##### Config and Boot
[[sc-logstash|Logstash config]]

```shell
# boot 
cat > /usr/lib/systemd/system/logstash.service << "EOF"
[Unit]
Description=logstash
Documentation=https://www.elastic.co
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=logstash
Group=logstash
EnvironmentFile=-/etc/default/logstash
ExecStart=/opt/logstash/bin/logstash "--path.settings" "/opt/logstash/config" "--path.logs" "/opt/logstash/logs" -f /opt/logstash/config/conf.d/logstash.conf
Restart=always
WorkingDirectory=/opt/logstash
Nice=19
LimitNOFILE=65535
TimeoutStopSec=infinity

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start .service
systemctl enable .service
```


#### Deploy by Container
##### Run by Resource
```shell
# https://docs.fluentd.org/container-deployment/kubernetes
```

##### Run by Helm
```shell
# add and update repo
helm repo add elastic https://helm.elastic.co
helm update

# get charts package
helm pull elastic/logstash --untar
cd logstash

# configure and run
vim values.yaml
logstashPipeline:
  logstash.conf: |
    input {
      exec {
        command => "uptime"
        interval => 30
      }
    }
    output { stdout { } }
...

helm -n logging install logstash .

```

>Reference:
>1. [Logstash Official Documentation](https://www.elastic.co/guide/en/logstash/current/introduction.html)
>2. [Logstash helm chart](https://github.com/elastic/helm-charts/blob/main/logstash/README.md)
>3. [apt installing](https://www.elastic.co/guide/en/logstash/current/installing-logstash.html)
