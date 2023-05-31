### 二进制部署
```shell
# Ubuntu Package install
https://nginx.org/en/linux_packages.html#Ubuntu


```
[[sc-nginx|nginx常用配置]]

### helm 部署
>k8s 集群建议使用 ingress-nginx-controller
```shell
### for Nginx
# add and update repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm update

# get charts package
helm pull bitnami/nginx --untar
cd nginx

# configure and run
vim values.yaml
helm -n nginx install ingress-nginx .
###


### for ingress
# add and update repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm update

# get charts package
helm pull ingress-nginx/ingress-nginx --untar
cd ingress-nginx

# configure and run
vim values.yaml
helm -n ingress-nginx install ingress-nginx .
### 
```

> 参考文档：
> 1、官方文档 = https://nginx.org/en/docs/
> 2、官方 helm 安装指引 = https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/