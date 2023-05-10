```shell


password: Sa@acclub.io


# 验证结果
kubectl -n middleware debug -it --image=docker.io/bitnami/redis-cluster:7.0.11-debian-11-r0 uat-redis-v3-redis-cluster-0 -- bash

kubectl run --namespace middleware uat-redis-v3-redis-cluster-client --rm --tty -i --restart='Never' \
 --env REDIS_PASSWORD=Sa@acclub.io \
--image docker.io/bitnami/redis-cluster:7.0.11-debian-11-r0 -- bash

```