```shell
# 快速启动 mysql-client 调试容器
kubectl run client-mysql --rm -it --restart=Never --image bitnami/mysql -- /bin/bash
```