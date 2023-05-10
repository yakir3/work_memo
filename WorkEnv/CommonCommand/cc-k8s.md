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
