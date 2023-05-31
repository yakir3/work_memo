```shell
# 查看集群配置信息
kubectl config view
kubectl config get-contexts
# 添加、配置集群配置信息
kubectl config set...
# 切换默认 namespace
kubectl config set-context --current --namespace=kube-system


# 转发 pod / service 端口
kubectl -n cattle-system port-forward --address 0.0.0.0 pods/rancher-6bd6ff6b7b-2v6qq 8888:80


# Pod 相关操作
# 从 yaml 文件创建资源
kubectl apply -f test.yaml
kubectl apply -k
# 创建
kubectl run --rm pod_name --image=busybox -it 
# 删除
kubectl delete pod_name
# 查看日志
kubectl logs -f --tail 10 pod_name
# 查看信息
kubectl get pod pod_name
kubectl describe pod pod_name
# 进入容器终端
kubectl exec -it pod_name [-c container_name] -- bash/sh
# 快速 debug 调试
kubectl debug -it pod_name --image=busybox [--target=container_name]


# 强制删除 pod 容器
kubect delete pod yakir_test --force=true --grace-period=0


# 批量查看 Pod 状态
JSONPATH='{range .items[*]};{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status},{end}{end};'  \
 && kubectl get pods -l k8s-app=fluentbit-gke -n kube-system -o jsonpath="$JSONPATH" | tr ";" "\n"
```
