#### Docker & Podman
##### introduction

![[docker-dsfasxcv.jpg]]

![[docker-fsdfsolnn.webp]]

![[docker-fsdsdf.webp]]

![[docker-fdsfcv.webp]]

![[docker-fsdfsobgb.webp]]

![[docker-fsdfdfsckl.webp]]


![[docker-fsdfsoasdaw.webp]]


##### command
```shell
# common parameters
-d, --detach    Run container in background and print container ID
-e, --env stringArray   Set environment variables in container
--env-file strings      Read in a file of environment variables
--name
-p, --publish strings   Publish a containers port
--restart               Restart policy to apply when a container exits ("always"|"no"|"on-failure"|"unless-stopped")
--rm                    Remove container (and pod if created) after exit
-v, --volume stringArray   Bind mount a volume into the container.


# select container ip
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' yakir-test


# 反查镜像 Dockerfile 内容
docker history db6effbaf70b --format {{.CreatedBy}} --no-trunc=true |sed "s#/bin/sh -c \#(nop) *##g"|sed "s#/bin/sh -c#RUN#g" |tac


# 编译自定义镜像
docker build -t yakir/uatproxy -f APP-META/Dockerfile .


# qucick running server
# mysql-server
podman run --name mysql -e MYSQL_ROOT_PASSWORD=1qaz@WSX -e MYSQL_DATABASE=devops_tools -p 3307:3306 -d mysql --character-set-server=utf8mb4


# knowledge-base
mkdir -p /opt/MrDoc/config /opt/MrDoc/data/mysql
docker run -d --name mrdoc -p 10086:10086 -v /opt/MrDoc:/app/MrDoc --net=bridge zmister/mrdoc:v4
docker run -d --name mrdoc_mysql -e MYSQL_ROOT_PASSWORD=knowledge_base123 -e MYSQL_DATABASE=knowledge_base -v /opt/MrDoc/data/mysql/:/var/lib/mysql mysql --character-set-server=utf8mb4

```


> 阿里云 ACR 仓库加速地址 = taa4w07u.mirror.aliyuncs.com


#### Containerd
```shell
# default run by systemd
systemctl start containerd.service
# run by k3s
containerd -c /var/lib/rancher/k3s/agent/etc/containerd/config.toml -a /run/k3s/containerd/containerd.sock --state /run/k3s/containerd --root /var/lib/rancher/k3s/agent/containerd


# ctr (see pause container)
ctr --address /run/k3s/containerd/containerd.sock namespace ls 
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images ls 
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io container ls


# crictl
endpoint="/run/k3s/containerd/containerd.sock" URL="unix:///run/k3s/containerd/containerd.sock" 
crictl ps 
crictl images


```

#### kubectl
```shell
# select cluster config
kubectl config current-context
kubectl config get-clusters
kubectl config get-contexts
kubectl config get-users
kubectl config view

# add or set cluster config
kubectl config set PROPERTY_NAME PROPERTY_VALUE

# add cluster config
kubectl config set-cluster NAME [--server=server] [--certificate-authority=path/to/certficate/authority] [--insecure-skip-tls-verify=true]
kubectl config set-context NAME [--cluster=cluster_nickname] [--user=user_nickname] [--namespace=namespace]
kubectl config set-credentials NAME [--client-certificate=path/to/certfile] [--client-key=path/to/keyfile] [--token=bearer_token] [--username=basic_user] [--password=basic_password]

# use and set context
kubectl config use-context CONTEXT_NAME
kubectl config set-context NAME [--cluster=cluster_nickname] [--user=user_nickname] [--namespace=namespace]


# evicted pod
kubectl cordon <node-name>
kubectl drain <node-name> --ignore-daemonsets
kubectl uncordon <node-name>


# forward pod/service port
kubectl -n argocd port-forward --address=0.0.0.0 pods/argocd-server-cd747d9d7-k7k4z 9999:8080
kubectl -n argocd port-forward --address=0.0.0.0 services/argocd-server 9999:80


# describe info
kubectl describe clusterrolebindings |grep argo -A 6
kubectl -n argo describe clusterrole argo-cluster-role


# quick operations
kubectl run --rm pod_name --image=busybox -it 
kubectl delete pod_name
kubectl exec -it pod_name [-c container_name] -- bash/sh
# force delete
kubect delete pod yakir_test --force=true --grace-period=0
# logs
kubectl logs -f --tail 10 pod_name
# quick debug
kubectl debug -it pod_name --image=busybox [--target=container_name] -- /bin/bash


# select resource info
kubectl get pod pod_name
kubectl describe service service_name


# quick running client images
kubectl run -it busybox --image=busybox --restart=Never --rm -- sh
# mysql-client
kubectl run mysql_client --rm -it --restart=Never --image bitnami/mysql -- /bin/bash
# redis-client


# create secrets
kubectl -n islot create secret tls my-tls --cert=./tls.crt --key=./tls.key
# upgrade secrets
kubectl create secret tls my-tls --save-config --dry-run=client --cert=./tls.crt --key=./tls.key -oyaml | kubectl apply -f -
kubectl create secret generic my-secret --save-config --dry-run=client --from-file=./tls.crt --from-file=./tls.key -oyaml | kubectl apply -f -


# batch select pod state
JSONPATH='{range .items[*]};{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status},{end}{end};'
kubectl get pods -l k8s-app=fluentbit-gke -n kube-system -o jsonpath="$JSONPATH" | tr ";" "\n"

```
