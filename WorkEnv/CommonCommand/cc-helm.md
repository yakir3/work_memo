>官方地址 = https://helm.sh/

#### 安装
```shell
# helm 命令安装包地址，根据版本下载，建议使用 helm3
https://github.com/helm/helm/releases

# 下载解压
tar -zxvf helm-v3.0.0-linux-amd64.tar.gz
install linux-amd64/helm /usr/local/bin/helm
```


#### 常用命令
```shell

# 添加仓库
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm update

# 搜索所有仓库包
helm search hub ingress-nginx
# 搜索已添加本地仓库包
helm search repo ingress-nginx 
# 参数
--versions           # 搜索仓库所有版本包
--max-col-width 150  # 搜索显示宽度

# 直接安装、更新、卸载
helm install [RELEASE_NAME] ingress-nginx/ingress-nginx
helm upgrade [RELEASE_NAME] [CHART] --install
helm uninstall [RELEASE_NAME]
# 参数
-n namespace --create-namespace
--set hostname=xxx


# 拉取源 chart 包安装
helm fetch/pull ingress-nginx/ingress-nginx --untar 
# 指定版本拉取
helm fetch --version=x.x.x rancher-stable/rancher --untar


```

