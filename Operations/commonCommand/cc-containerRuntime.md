#### docker & podman
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
docker history db6effbaf70b --format {{.CreatedBy}} --no-trunc=true |sed "s#/bin/sh -c \#(nop) *##g" |tac


# 编译自定义镜像
docker build -t yakir/uatproxy -f APP-META/Dockerfile .


# qucick running server
# mysql-server
podman run --name mysql -e MYSQL_ROOT_PASSWORD=1qaz@WSX -e MYSQL_DATABASE=devops_tools -p 3307:3306 -d mysql --character-set-server=utf8mb4


# knowledge-base
mkdir -p /opt/MrDoc/config /opt/MrDoc/data/mysql
docker run -d --name mrdoc -p 10086:10086 -v /opt/MrDoc:/app/MrDoc --net=bridge zmister/mrdoc:v4
docker run -d --name mrdoc_mysql -e MYSQL_ROOT_PASSWORD=knowledge_base123 -e MYSQL_DATABASE=knowledge_base -v /opt/MrDoc/data/mysql/:/var/lib/mysql mysql --character-set-server=utf8mb4



# Dockerfile
# exec 形式，直接启动程序进程，pid=1
ENTRYPOINT ["node", "app.js"]
# shell 形式，fork 一个 shell 子进程，shell 子进程启动程序
ENTRYPOINT "node" "app.js"


# Pod resources map: 
spec.contianers[n].command = ENTRYPOINT
spec.contianers[n].args = CMD


```


#### containerd
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
##### Basic
```shell
# create
kubectl create secret tls my-tls --cert=./tls.crt --key=./tls.key
kubectl create secret tls my-tls --save-config \
--dry-run=client \
--cert=./tls.crt \
--key=./tls.key \
-oyaml | kubectl apply -f -

# expose 
kubectl expose service/pod nginx --port=8888 --target-port=8080 --name=myname

# run
kubectl run --rm -it busybox --image=busybox --restart=Never -- sh
kubectl run --rm -it mysql_client --image bitnami/mysql --restart=Never -- /bin/bash

# explain
kubectl explain statefulset.spec.updateStrategy.rollingUpdate

# get
# batch select pod state
JSONPATH='{range .items[*]};{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status},{end}{end};'
kubectl get pods -o jsonpath="$JSONPATH" | tr ";" "\n"
# batch get nodes ip
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' |xargs -n1
# select by custome-columns
kubectl get pod -o=custom-columns=\
PodName:.metadata.name,\
NodeName:.spec.nodeName,\
ContainerPort:.spec.containers[*].ports[*].containerPort

# edit
kubectl edit (resource_type) (resource_name)

# delete
kubectl delete pod pod_name
kubectl delete pod pod_name --force=true --grace-period=0


```


##### Deploy
```shell
# rollout 
kubectl rollout (history|pause|restart|resume|status|undo) (resource_type) (resource_name)

# scale
kubectl scale [--resource-version=version] [--current-replicas=count] --replicas=COUNT (-f x.yaml | deployment mysql)

# autoscale
kubectl autoscale (-f x.yaml | deployment/mysql) [--min=MINPODS] --max=MAXPODS [--cpu-percent=CPU] [options]

```


##### Cluster Management
```shell
# top
kubectl -n namespace_name top pod
kubectl top node

# schedulable and evicted
kubectl cordon <node-name>
kubectl uncordon <node-name>
kubectl drain <node-name> [--ignore-daemonsets=true] [--delete-emptydir-data=true]

# taint and affnity
kubectl describe nodes |grep Taints
kubectl taint NODE NAME KEY_1=VAL_1:TAINT_EFFECT_1 ... KEY_N=VAL_N:TAINT_EFFECT_N [options]

```


##### Troubleshooting and Debugging
```shell
# describe
kubectl describe service service_name

# logs
kubectl get pod --show-labels
kubectl logs -f --tail 10 pod_name -l app.kubernetes.io/instance=ingress-nginx --max-log-requests=5

# attach and exec 
kubectl attach -it pod pod_name [-c container_name]
kubectl exec -it pod_name [-c container_name] -- bash/sh

# forward pod/service port
kubectl -n argocd port-forward --address=0.0.0.0 pods/argocd-server-cd747d9d7-k7k4z 9999:8080
kubectl -n argocd port-forward --address=0.0.0.0 services/argocd-server 9999:80

# proxy(apiserver)
kubectl proxy --address=0.0.0.0

# cp
kubectl cp pod_name:/path/path /tmp/path

# debug 
kubectl debug -it pod/pod_name --image=busybox [--target=container_name] -- /bin/sh
# debug node(need to be deleted pod manually and node persistent in /host/)
kubectl debug -it node/node_name --image=ubuntu -- /bin/bash
kubectl delete pod node-debuger-xxx

# events
kubectl events -n namespace_name

```


##### Advanced
```shell
# diff
kubectl diff -f FILENAME [options]

# apply and replace
kubectl apply (-f FILENAME | -k DIRECTORY) [options]
kubectl replace -f FILENAME [options]

# patch
# option1
kubectl -n provisioning patch ingress harbor-ingress-notary --type='json' -p='[{"op": "add", "path": "/spec", "value":"ingressClassName: nginx"}]'
# option2
kubectl -n cicd patch ingress gitlab-webservice-default --patch '{"spec":{"ingressClassName": "nginx"}}'

# kustomize(need kustomization.yaml)
kubectl kustomize DIR [flags] [options]

```


##### Settings
```shell
# label
kubectl label nodes Node1 node-role.kubernetes.io/control-plane=true

# annotate
kubectl annotate pods yakir-tools key1=value1

# completion
source <(kubectl completion bash)

```


##### Other
```shell
# api resources and versions infomation
kubectl api-resources
kubectl api-versions

# config
# select cluster config
kubectl config current-context
kubectl config get-clusters
kubectl config get-contexts
kubectl config get-users
kubectl config view
# add or set custom config
kubectl config set PROPERTY_NAME PROPERTY_VALUE
# add cluster config
kubectl config set-cluster NAME [--server=server] [--certificate-authority=path/to/certficate/authority] [--insecure-skip-tls-verify=true]
kubectl config set-context NAME [--cluster=cluster_nickname] [--user=user_nickname] [--namespace=namespace]
kubectl config set-credentials NAME [--client-certificate=path/to/certfile] [--client-key=path/to/keyfile] [--token=bearer_token] [--username=basic_user] [--password=basic_password]
# use and set context
kubectl config use-context CONTEXT_NAME
kubectl config set-context NAME [--cluster=cluster_nickname] [--user=user_nickname] [--namespace=namespace]


# check version
kubectl version

```

#### helm
```shell
# parameter
-n namespace 
--create-namespace
--set hostname=xxx

# completion
source <(helm completion bash)

# create 
helm create mychart

# dependency
helm dependency update

# env
helm env

# get 
helm get (all|manifest) chart_name --revision int

# history
helm -n cattle-system history rancher

# install,upgrade,uninstall
helm install [RELEASE_NAME] ingress-nginx/ingress-nginx
helm upgrade [RELEASE_NAME] [CHART] --install
helm uninstall [RELEASE_NAME]

# lint 
helm lint /opt/helm-charts/*

# list
helm list -A

# package
helm package /opt/helm-charts/*

# pull,fetch and push
helm fetch --version=x.x.x rancher-stable/rancher --untar
helm push [chart] [remote] [flags]

# registry
helm registry [command]

# repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm update

# rollback

# search
helm search hub ingress-nginx
helm search repo ingress-nginx 
--versions           # search repo all charts version
--max-col-width 150  # search display width

# show 
helm show values [CHART] [flags]

# status
helm status RELEASE_NAME [flags]

# template
helm template [NAME] [CHART] [flags]

# test

# verify

# version
helm version

```



> 1. [阿里云 ACR 仓库加速地址](taa4w07u.mirror.aliyuncs.com)
> 2. [Docker Engine Install](https://docs.docker.com/engine/install/)
> 3. [Helm Official Documentation](https://helm.sh/docs/)
> 4. [Kubectl Official Documentation](https://kubernetes.io/docs/reference/kubectl/)