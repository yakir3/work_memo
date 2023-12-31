#### Introduction
...

#### Deploy by Binaries
##### Download and Compile
```shell
# Ubuntu Package install
# https://docs.fluentd.org/installation/install-by-deb

```

##### Config and Boot
[[sc-fluentd|Fluentd Config]]

```shell
# important
chown td-agent.td-agent /opt/fluentd-output/filepath

# boot 
systemctl daemon-reload
systemctl start td-agent.service
systemctl enable td-agent.service
```

##### Verify
```shell
# syntax check
/opt/td-agent/bin/fluentd -v
```

##### Troubleshooting
```shell
# 
```


#### Deploy by Container
##### Run by Resource
```shell
# https://docs.fluentd.org/container-deployment/kubernetes
```

##### Run by Helm
```shell
# add and update repo
helm repo add fluent https://fluent.github.io/helm-charts
helm update

# get charts package
helm fetch fluent/fluentd --untar
cd fluentd

# configure and run
vim values.yaml
...
helm -n logging install fluentd .

```


>Reference:
> 1. [Official Documentation](https://docs.fluentd.org/)
> 2. [GitHub 地址](https://github.com/fluent/fluentd)
> 3. [下载地址](https://api-docs.treasuredata.com/en/tools/cli/quickstart/)
> 4. [helm 安装指引](https://artifacthub.io/packages/helm/bitnami/fluentd)
> 5. [fluentd-beat plugin](https://github.com/repeatedly/fluent-plugin-beats)
