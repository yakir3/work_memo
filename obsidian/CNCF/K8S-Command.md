## K8S 常用命令

```shell
# 查看集群配置信息
kubectl config view
kubectl config get-contexts

# 添加、配置集群配置信息
kubectl config set...

# 切换默认 namespace
kubectl config set-context --current --namespace=kube-system

# 快速调试
kubectl run --rm yakir-busybox --image=busybox -it 

# 批量查看 Pod 状态
JSONPATH='{range .items[*]};{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status},{end}{end};'  \
 && kubectl get pods -l k8s-app=fluentbit-gke -n kube-system -o jsonpath="$JSONPATH" | tr ";" "\n"
```



## helm 常用命令
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


