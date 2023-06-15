#### Introduction
...


#### Deployment
##### Run On Binaries
```shell

```

##### Run On Docker
[[cc-docker|Docker常用命令]]
```shell
# run by docker or docker-compose
docker run -d --name rancher --rm \
-p 80:80 -p 443:443 \
-e HTTP_PROXY=http://1.1.1.1:8888/ \
-e HTTPS_PROXY=http://1.1.1.1:8888/ \
--privileged rancher/rancher

# get password
docker logs rancher |grep Password
```

##### Run On Kubernetes
[[cc-k8s|deploy by kubernetes manifest]]
```shell
# 
```

[[cc-helm|deploy by helm]]
```shell
# Add and update repo
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update

# Get charts package
helm fetch rancher-stable/rancher --untar
cd rancher

# Configure and run
vim values.yaml
...

helm -n cattle-system install rancher . --create-namespace 

# verify
kubectl -n cattle-system get pod 
```



> 参考文档:
> 1. [官方文档](https://github.com/rancher/rke)
> 2. [官方 github 地址](https://github.com/rancher/rke)
