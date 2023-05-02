```shell
# 添加仓库
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm update

# 搜索仓库包
helm search repo ingress-nginx 

# 直接安装、更新、卸载
helm install [RELEASE_NAME] ingress-nginx/ingress-nginx
helm upgrade [RELEASE_NAME] [CHART] --install
helm uninstall [RELEASE_NAME]
# 参数
-n namespace --create-namespace
--set hostname=xxx


# 拉取源 chart 包安装
helm pull ingress-nginx/ingress-nginx --untar 
cd ingress-nginx && vim Chart.yaml & vim values.yaml
helm install ingress-nginx .

```

